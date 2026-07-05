package com.kmbeast.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.kmbeast.context.LocalThreadHolder;
import com.kmbeast.exception.BusinessException;
import com.kmbeast.mapper.ScenicSpotMapper;
import com.kmbeast.pojo.dto.ScenicSpotQueryDTO;
import com.kmbeast.pojo.dto.ScenicSpotSaveDTO;
import com.kmbeast.pojo.dto.ScenicSpotUpdateDTO;
import com.kmbeast.pojo.dto.UserActionOperationQueryDTO;
import com.kmbeast.pojo.entity.Category;
import com.kmbeast.pojo.entity.ScenicSpot;
import com.kmbeast.pojo.entity.ScenicSpotBrochure;
import com.kmbeast.pojo.entity.ScenicSpotCategory;
import com.kmbeast.pojo.enums.ActionModuleEnum;
import com.kmbeast.pojo.enums.ActionTypeEnum;
import com.kmbeast.pojo.vo.ContentHotScoreVO;
import com.kmbeast.pojo.vo.ScenicSpotListVO;
import com.kmbeast.pojo.vo.ScenicSpotVO;
import com.kmbeast.pojo.vo.ScoreVO;
import com.kmbeast.service.*;
import com.kmbeast.utils.AssertUtils;
import com.kmbeast.utils.RoleValidUtils;
import com.kmbeast.utils.UserBasedCFUtil;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

/**
 * 景点业务逻辑接口实现类
 */
@Service
@Slf4j
public class ScenicSpotServiceImpl extends ServiceImpl<ScenicSpotMapper, ScenicSpot> implements ScenicSpotService {

    @Resource
    private ScenicSpotBrochureService scenicSpotBrochureService;
    @Resource
    private ScenicSpotCategoryService scenicSpotCategoryService;
    @Resource
    private UserActionOperationService userActionOperationService;
    @Resource
    private ScenicSpotRouteItemService scenicSpotRouteItemService;
    @Resource
    private ScenicSpotTicketService scenicSpotTicketService;
    @Resource
    private CategoryService categoryService;

    private final static Executor executor = Executors.newFixedThreadPool(
            Runtime.getRuntime().availableProcessors() * 2
    );

    private void validParams(ScenicSpot scenicSpot) {
        // 景点本身的基本信息
        AssertUtils.notNull(scenicSpot, "参数不为空");
        AssertUtils.notNull(scenicSpot.getRegionId(), "请设置地区");
        AssertUtils.hasText(scenicSpot.getTitle(), "请填写标题");
        AssertUtils.hasText(scenicSpot.getSummary(), "请补充摘要");
        AssertUtils.hasText(scenicSpot.getContent(), "请补充内容");
        AssertUtils.hasText(scenicSpot.getCover(), "请上传封面");
        // 内容本身的限制
        AssertUtils.isTrue(scenicSpot.getTitle().length() < 100, "标题请控制在100字以内");
        AssertUtils.isTrue(scenicSpot.getSummary().length() < 200, "摘要请控制在200字以内");

    }

    private void validScenicSpotBrochureParams(List<ScenicSpotBrochure> scenicSpotBrochureList) {
        // 景点的图册信息
        AssertUtils.notEmpty(scenicSpotBrochureList, "请补充图册（至少一张）");
        for (ScenicSpotBrochure scenicSpotBrochure : scenicSpotBrochureList) {
            AssertUtils.notNull(scenicSpotBrochure.getScenicSpotId(), "景点ID不为空");
            AssertUtils.hasText(scenicSpotBrochure.getCoverUrl(), "景点图片URL不为空");
            AssertUtils.notNull(scenicSpotBrochure.getOrderNumber(), "请补充序号");
        }
        AssertUtils.isTrue(scenicSpotBrochureList.size() <= 5, "图册至多5张");
    }

    private void validParams(List<Integer> categoryIds) {
        AssertUtils.notEmpty(categoryIds, "请绑定景点类别");
        for (Integer categoryId : categoryIds) {
            AssertUtils.notNull(categoryId, "请选择类别");
        }
    }

    /**
     * 景点新增
     *
     * @param scenicSpotSaveDTO 景点新增DTO
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void addScenicSpot(ScenicSpotSaveDTO scenicSpotSaveDTO) {
        // 要求管理员才能操作
        RoleValidUtils.requestedAdmin("无操作权限");
        // 景点基本信息参数校验
        validParams(scenicSpotSaveDTO);
        // 新增景点基本信息
        ScenicSpot scenicSpot = createScenicSpot(scenicSpotSaveDTO);
        save(scenicSpot);
        // 设置景点ID
        for (ScenicSpotBrochure scenicSpotBrochure : scenicSpotSaveDTO.getScenicSpotBrochureList()) {
            scenicSpotBrochure.setScenicSpotId(scenicSpot.getId());
        }
        List<ScenicSpotCategory> scenicSpotCategories = new ArrayList<>();
        // 设置景点ID
        for (Integer categoryId : scenicSpotSaveDTO.getCategoryIds()) {
            ScenicSpotCategory scenicSpotCategory = ScenicSpotCategory.builder()
                    .scenicSpotId(scenicSpot.getId())
                    .categoryId(categoryId)
                    .build();
            scenicSpotCategories.add(scenicSpotCategory);
        }
        // 景点图册校验
        validScenicSpotBrochureParams(scenicSpotSaveDTO.getScenicSpotBrochureList());
        // 景点关联类别校验
        validParams(scenicSpotSaveDTO.getCategoryIds());
        // 新增景点图册
        scenicSpotBrochureService.addScenicSpotBrochure(
                scenicSpotSaveDTO.getScenicSpotBrochureList()
        );
        // 新增景点与景点类别的关联
        scenicSpotCategoryService.batchInsert(scenicSpotCategories);
    }

    /**
     * 构造景点信息
     *
     * @param scenicSpotSaveDTO 景点新增DTO
     * @return ScenicSpot
     */
    private ScenicSpot createScenicSpot(ScenicSpotSaveDTO scenicSpotSaveDTO) {
        return ScenicSpot.builder()
                .title(scenicSpotSaveDTO.getTitle())
                .content(scenicSpotSaveDTO.getContent())
                .summary(scenicSpotSaveDTO.getSummary())
                .regionId(scenicSpotSaveDTO.getRegionId())
                .cover(scenicSpotSaveDTO.getCover())
                .createTime(LocalDateTime.now())
                .build();
    }

    /**
     * 景点信息修改
     *
     * @param scenicSpotUpdateDTO 景点信息修改DTO
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateScenicSpot(ScenicSpotUpdateDTO scenicSpotUpdateDTO) {
        // 要求管理员才能操作
        RoleValidUtils.requestedAdmin("无操作权限");
        // 景点基本信息参数校验
        validParams(scenicSpotUpdateDTO);
        AssertUtils.notNull(scenicSpotUpdateDTO.getId(), "景点ID不为空");
        // 1. 修改景点信息
        updateById(scenicSpotUpdateDTO);
        // 2. 先删除旧数据，在新增景点图册信息
        for (ScenicSpotBrochure scenicSpotBrochure : scenicSpotUpdateDTO.getScenicSpotBrochureList()) {
            scenicSpotBrochure.setScenicSpotId(scenicSpotUpdateDTO.getId());
        }
        validScenicSpotBrochureParams(scenicSpotUpdateDTO.getScenicSpotBrochureList());
        boolean removedBrochure = scenicSpotBrochureService.remove(
                new LambdaUpdateWrapper<ScenicSpotBrochure>()
                        .eq(ScenicSpotBrochure::getScenicSpotId, scenicSpotUpdateDTO.getId())
        );
        if (removedBrochure) {
            // 新增景点图册
            scenicSpotBrochureService.addScenicSpotBrochure(
                    scenicSpotUpdateDTO.getScenicSpotBrochureList()
            );
        }
        // 3. 先删除旧数据，景点与景点类别的关联关系
        validParams(scenicSpotUpdateDTO.getCategoryIds());
        boolean removedCategory = scenicSpotCategoryService.remove(
                new LambdaUpdateWrapper<ScenicSpotCategory>()
                        .eq(ScenicSpotCategory::getScenicSpotId, scenicSpotUpdateDTO.getId())
        );
        if (removedCategory) {
            List<ScenicSpotCategory> scenicSpotCategories = new ArrayList<>();
            // 设置景点ID
            for (Integer categoryId : scenicSpotUpdateDTO.getCategoryIds()) {
                ScenicSpotCategory scenicSpotCategory = ScenicSpotCategory.builder()
                        .scenicSpotId(scenicSpotUpdateDTO.getId())
                        .categoryId(categoryId)
                        .build();
                scenicSpotCategories.add(scenicSpotCategory);
            }
            scenicSpotCategoryService.batchInsert(scenicSpotCategories);
        }
    }

    /**
     * 删除景点信息
     *
     * @param id 主键ID
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void delScenicSpot(Integer id) {
        RoleValidUtils.requestedAdmin("无操作权限");
        AssertUtils.notNull(id, "ID不为空");
        // 1. 删除景点数据
        removeById(id);
        // 2. 删除景点关联的图册
        scenicSpotBrochureService.remove(
                new LambdaUpdateWrapper<ScenicSpotBrochure>()
                        .eq(ScenicSpotBrochure::getScenicSpotId, id)
        );
        // 3. 景点关联的景点类别
        scenicSpotCategoryService.remove(
                new LambdaUpdateWrapper<ScenicSpotCategory>()
                        .eq(ScenicSpotCategory::getScenicSpotId, id)
        );
        // 4. 删除景点关联的路线信息
        scenicSpotRouteItemService.delScenicSpotRouteItemByScenicSpotId(id);
        // 5. 删除景点关联的门票信息
        scenicSpotTicketService.delScenicSpotTicketByScenicSpotId(id);
    }

    /**
     * 查询景点信息列表
     *
     * @param scenicSpotQueryDTO 查询条件类
     * @return List<ScenicSpotListVO>
     */
    @Override
    public List<ScenicSpotListVO> listPage(ScenicSpotQueryDTO scenicSpotQueryDTO) {
        // 限制其分页查询
        AssertUtils.notNull(scenicSpotQueryDTO, "参数不为空");
        AssertUtils.notNull(scenicSpotQueryDTO.getCurrent(), "当前页不为空");
        AssertUtils.notNull(scenicSpotQueryDTO.getSize(), "大小不为空");
        // 判断是否按照热度规则排序
        if (Objects.nonNull(scenicSpotQueryDTO.getHotRule()) && scenicSpotQueryDTO.getHotRule()) {
            UserActionOperationQueryDTO queryDTO = new UserActionOperationQueryDTO();
            queryDTO.setCurrent(scenicSpotQueryDTO.getCurrent()); // 偏移量 - 当前页
            queryDTO.setSize(scenicSpotQueryDTO.getSize()); // 页面大小
            queryDTO.setContentModule(ActionModuleEnum.SCENIC_SPOT.getModule()); // 设置为景点模块
            List<ContentHotScoreVO> contentHotScoreVOS = userActionOperationService.hotContentList(queryDTO);
            if (CollectionUtils.isEmpty(contentHotScoreVOS)) {
                return new ArrayList<>();
            }
            // 过滤出热度值最高的景点ID列表
            List<Integer> scenicSpotIds = contentHotScoreVOS.stream().map(ContentHotScoreVO::getContentId)
                    .toList();
            scenicSpotQueryDTO.setIds(scenicSpotIds);
        }
        // 判断是否按照类别进行查询
        if (StringUtils.hasText(scenicSpotQueryDTO.getCategoryKey())) {
            List<Category> categories = categoryService.list(
                    new LambdaQueryWrapper<Category>()
                            .like(Category::getName, scenicSpotQueryDTO.getCategoryKey())
            );
            if (!CollectionUtils.isEmpty(categories)) {
                List<Integer> categoryIds = categories.stream()
                        .map(Category::getId)
                        .toList();
                // 通过类别ID列表，查询其绑定的这些景点的ID的列表
                List<Integer> scenicSpotIds = categoryService.getScenicSpotIds(categoryIds);
                if (!CollectionUtils.isEmpty(scenicSpotIds)) {
                    scenicSpotQueryDTO.setIds(scenicSpotIds);
                }
            }
        }
        return this.baseMapper.listPage(scenicSpotQueryDTO);
    }

    /**
     * 查询符合条件的景点数据量
     *
     * @param scenicSpotQueryDTO 查询条件类
     * @return Integer
     */
    @Override
    public Integer listPageCount(ScenicSpotQueryDTO scenicSpotQueryDTO) {
        return this.baseMapper.listPageCount(scenicSpotQueryDTO);
    }

    /**
     * 查询景点详情
     *
     * @param id 景点主键ID
     * @return ScenicSpotVO
     */
    @Override
    public ScenicSpotVO detail(Integer id) {
        AssertUtils.notNull(id, "景点ID不为空");
        // 做法一：直接在sql层面做
        // return this.baseMapper.getDetailById(id);

        // 做法二 使用CompletableFuture做并行查询再组装
        // 查景点原始的详情 -> 类别关联的查询 -> 组装
        // ScenicSpotVO scenicSpotVO = this.baseMapper.getDetailById(id);
        // 1. 查询的就是景点原始的详情数据
        CompletableFuture<ScenicSpotVO> scenicSpotFuture = CompletableFuture.supplyAsync(
                () -> this.baseMapper.getDetailById(id),
                executor
        );
        // 2. 查询景点关联的类别信息
        CompletableFuture<List<ScenicSpotCategory>> spotCategoriesFuture = CompletableFuture.supplyAsync(
                () -> scenicSpotCategoryService.list(
                        new LambdaQueryWrapper<ScenicSpotCategory>()
                                .eq(ScenicSpotCategory::getScenicSpotId, id)
                ),
                executor
        );
        // 3. 数据组装
        CompletableFuture<ScenicSpotVO> scenicSpotVOCompletableFuture = scenicSpotFuture.thenCombine(
                spotCategoriesFuture,
                this::combineData
        ).exceptionally(e -> {
            log.error("查询景点信息异常:", e);
            throw new BusinessException("查询景点详情异常", e);
        });

        try {
            return scenicSpotVOCompletableFuture.get(
                    5,
                    TimeUnit.SECONDS
            );
        } catch (Exception e) {
            log.error("查询景点信息异常或超时:", e);
        }

        return null;
    }


    private ScenicSpotVO combineData(ScenicSpotVO scenicSpotVO,
                                     List<ScenicSpotCategory> scenicSpotCategories) {
        AssertUtils.notNull(scenicSpotVO, "无景点详情数据");
        scenicSpotVO.setScenicSpotCategoryList(scenicSpotCategories);
        return scenicSpotVO;
    }

    /**
     * 查询用户收藏的景点信息
     *
     * @param scenicSpotQueryDTO 查询条件类
     * @return List<ScenicSpotListVO>
     */
    @Override
    public List<ScenicSpotListVO> collection(ScenicSpotQueryDTO scenicSpotQueryDTO) {
        // 先去查询用户收藏了哪些景点
        UserActionOperationQueryDTO queryDTO = userActionOperationService.createQueryDTO(
                "SCENIC_SPOT",
                null,
                ActionTypeEnum.TYPE_1.getType()
        );
        // 用户收藏的景点ID列表
        List<Integer> scenicSpotIds = userActionOperationService.getContentIds(queryDTO);
        if (scenicSpotIds.isEmpty()) {
            return new ArrayList<>();
        }
        scenicSpotQueryDTO.setIds(scenicSpotIds);
        return this.baseMapper.listPage(scenicSpotQueryDTO);
    }

    /**
     * 景点推荐（协同过滤算法）
     *
     * @param count 推荐的条数
     * @return Result<List < ScenicSpotListVO>> 后台通用返回封装类
     */
    @Override
    public List<ScenicSpotListVO> recommend(Integer count) {
        AssertUtils.notNull(count, "推荐条数不为空");
        AssertUtils.isTrue(LocalThreadHolder.hasUser() && LocalThreadHolder.getUserId() != null, "请登录后重试");
        // 景点ID列表
        List<Integer> scenicSpotIds = this.baseMapper.getIds();
        if (CollectionUtils.isEmpty(scenicSpotIds)) {
            return new ArrayList<>();
        }
        // 先去查询用户对于景点的兴趣评分数据集
        List<ScoreVO> scores = userActionOperationService.scores(
                ActionModuleEnum.SCENIC_SPOT.getModule()
        );
        if (CollectionUtils.isEmpty(scores)) {
            return new ArrayList<>();
        }
        // 构建算法工具类所需要的评分集
        List<UserBasedCFUtil.Score> scoreList = scores.stream()
                .map(scoreVO -> new UserBasedCFUtil.Score(
                        scoreVO.getUserId(),
                        scoreVO.getContentId(),
                        scoreVO.getScore()
                )).toList();
        Map<Integer, Map<Integer, Double>> userItemMatrix = UserBasedCFUtil.buildUserItemMatrix(
                scenicSpotIds,
                scoreList
        );
        UserBasedCFUtil basedCFUtil = new UserBasedCFUtil(userItemMatrix);
        // 向用户推荐的景点ID列表
        List<Integer> recommendScenicSpotIds = basedCFUtil.recommendItems(
                LocalThreadHolder.getUserId(),
                count
        );
        System.out.println("为用户ID为[" + LocalThreadHolder.getUserId() + "]的用户推荐的景点ID列表为:" + recommendScenicSpotIds);
        // “冷启动” - 即用户可能没有产生足够的行为数据，无法计算 - 推荐热度最高的给他
        if (CollectionUtils.isEmpty(recommendScenicSpotIds)) {
            UserActionOperationQueryDTO queryDTO = new UserActionOperationQueryDTO();
            queryDTO.setCurrent(0);
            queryDTO.setSize(count);
            queryDTO.setContentModule(ActionModuleEnum.SCENIC_SPOT.getModule());
            List<ContentHotScoreVO> contentHotScoreVOS = userActionOperationService.hotContentList(queryDTO);
            if (CollectionUtils.isEmpty(contentHotScoreVOS)) {
                return new ArrayList<>();
            }
            // 最热景点的ID列表
            List<Integer> hotScenicSpotIds = contentHotScoreVOS.stream()
                    .map(ContentHotScoreVO::getContentId)
                    .toList();
            ScenicSpotQueryDTO scenicSpotQueryDTO = new ScenicSpotQueryDTO();
            scenicSpotQueryDTO.setIds(hotScenicSpotIds);
            return this.baseMapper.listPage(scenicSpotQueryDTO);
        }
        ScenicSpotQueryDTO scenicSpotQueryDTO = new ScenicSpotQueryDTO();
        scenicSpotQueryDTO.setIds(recommendScenicSpotIds);
        return this.baseMapper.listPage(scenicSpotQueryDTO);
    }
}
