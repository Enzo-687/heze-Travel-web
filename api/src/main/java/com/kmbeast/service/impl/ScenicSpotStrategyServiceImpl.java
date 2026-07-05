package com.kmbeast.service.impl;

import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.kmbeast.context.LocalThreadHolder;
import com.kmbeast.mapper.ScenicSpotStrategyMapper;
import com.kmbeast.pojo.dto.ScenicSpotStrategyQueryDTO;
import com.kmbeast.pojo.dto.UserActionOperationQueryDTO;
import com.kmbeast.pojo.entity.ScenicSpotStrategy;
import com.kmbeast.pojo.enums.ActionModuleEnum;
import com.kmbeast.pojo.enums.ActionTypeEnum;
import com.kmbeast.pojo.enums.RoleEnum;
import com.kmbeast.pojo.vo.ContentHotScoreVO;
import com.kmbeast.pojo.vo.ScenicSpotStrategyDetailVO;
import com.kmbeast.pojo.vo.ScenicSpotStrategyListVO;
import com.kmbeast.pojo.vo.ScoreVO;
import com.kmbeast.service.ScenicSpotStrategyService;
import com.kmbeast.service.UserActionOperationService;
import com.kmbeast.utils.AssertUtils;
import com.kmbeast.utils.RoleValidUtils;
import com.kmbeast.utils.UserBasedCFUtil;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * 景点攻略业务逻辑接口实现类
 */
@Service
public class ScenicSpotStrategyServiceImpl extends ServiceImpl<ScenicSpotStrategyMapper, ScenicSpotStrategy> implements ScenicSpotStrategyService {

    private final static Boolean NO_AUDIT = false; // 未审核状态
    private final static Boolean AUDITED = true; // 已审核状态

    @Resource
    private UserActionOperationService userActionOperationService;

    private void validParams(ScenicSpotStrategy scenicSpotStrategy) {
        // 景点攻略本身的基本信息
        AssertUtils.notNull(scenicSpotStrategy, "参数不为空");
        AssertUtils.notNull(scenicSpotStrategy.getScenicSpotId(), "请设置景点ID");
        AssertUtils.hasText(scenicSpotStrategy.getTitle(), "请填写标题");
        AssertUtils.hasText(scenicSpotStrategy.getSummary(), "请补充摘要");
        AssertUtils.hasText(scenicSpotStrategy.getContent(), "请补充内容");
        AssertUtils.hasText(scenicSpotStrategy.getCover(), "请上传封面");
        // 内容本身的限制
        AssertUtils.isTrue(scenicSpotStrategy.getTitle().length() < 30, "标题请控制在100字以内");
        AssertUtils.isTrue(scenicSpotStrategy.getSummary().length() < 200, "摘要请控制在200字以内");
    }

    /**
     * 景点新增业务逻辑方法
     *
     * @param scenicSpotStrategy 景点策略实体信息
     */
    @Override
    public void addScenicSpotStrategy(ScenicSpotStrategy scenicSpotStrategy) {
        validParams(scenicSpotStrategy);
        scenicSpotStrategy.setUserId(LocalThreadHolder.getUserId()); // 设置发布者用户ID
        scenicSpotStrategy.setCreateTime(LocalDateTime.now()); // 设置景点攻略发布时间 - 当前时间
        scenicSpotStrategy.setAuditStatus(NO_AUDIT); // 新增时，初始是未审核状态
        save(scenicSpotStrategy);
    }

    /**
     * 景点修改业务逻辑方法
     *
     * @param scenicSpotStrategy 景点策略实体信息
     */
    @Override
    public void updateScenicSpotStrategy(ScenicSpotStrategy scenicSpotStrategy) {
        AssertUtils.notNull(scenicSpotStrategy, "参数不为空");
        scenicSpotStrategy.setAuditStatus(null);
        updateById(scenicSpotStrategy);
    }

    /**
     * 删除景点攻略
     *
     * @param id 主键ID
     */
    @Override
    public void delScenicSpotStrategy(Integer id) {
        AssertUtils.notNull(id, "ID不能为空");
        // 一种是管理员删除
        if (RoleEnum.ADMIN.getRole().equals(LocalThreadHolder.getRoleId())) {
            removeById(id);
            return;
        }
        // 一种是用户只能删除自己的
        if (RoleEnum.USER.getRole().equals(LocalThreadHolder.getRoleId())) {
            remove(
                    new LambdaUpdateWrapper<ScenicSpotStrategy>()
                            .eq(ScenicSpotStrategy::getId, id)
                            .eq(ScenicSpotStrategy::getUserId, LocalThreadHolder.getUserId())
            );
        }
    }

    /**
     * 查询景点详情
     *
     * @param id 主键ID
     * @return ScenicSpotStrategyDetailVO
     */
    @Override
    public ScenicSpotStrategyDetailVO detail(Integer id) {
        AssertUtils.notNull(id, "ID不能为空");
        return this.baseMapper.detail(id);
    }

    /**
     * 景点攻略查询
     *
     * @param scenicSpotStrategyQueryDTO 查询条件类
     * @return List<ScenicSpotStrategyListVO>
     */
    @Override
    public List<ScenicSpotStrategyListVO> queryList(ScenicSpotStrategyQueryDTO scenicSpotStrategyQueryDTO) {
        // 限制其分页查询
        AssertUtils.notNull(scenicSpotStrategyQueryDTO, "参数不为空");
        AssertUtils.notNull(scenicSpotStrategyQueryDTO.getCurrent(), "当前页不为空");
        AssertUtils.notNull(scenicSpotStrategyQueryDTO.getSize(), "大小不为空");
        // 判断是否按照热度规则排序
        if (Objects.nonNull(scenicSpotStrategyQueryDTO.getHotRule()) && scenicSpotStrategyQueryDTO.getHotRule()) {
            UserActionOperationQueryDTO queryDTO = new UserActionOperationQueryDTO();
            queryDTO.setCurrent(scenicSpotStrategyQueryDTO.getCurrent()); // 偏移量 - 当前页
            queryDTO.setSize(scenicSpotStrategyQueryDTO.getSize()); // 页面大小
            queryDTO.setContentModule(ActionModuleEnum.SCENIC_SPOT_STRATEGY.getModule()); // 设置为景点攻略模块
            List<ContentHotScoreVO> contentHotScoreVOS = userActionOperationService.hotContentList(queryDTO);
            if (CollectionUtils.isEmpty(contentHotScoreVOS)) {
                return new ArrayList<>();
            }
            // 过滤出热度值最高的景点ID列表
            List<Integer> scenicSpotIds = contentHotScoreVOS.stream().map(ContentHotScoreVO::getContentId)
                    .toList();
            scenicSpotStrategyQueryDTO.setIds(scenicSpotIds);
        }
        // 一种是管理员查列表
        // 一种是用户查列表 - 只能够查询已经审核的景点攻略
        // 一种是游客的操作
        // 检查 LocalThreadHolder 是否有用户信息
        if (!LocalThreadHolder.hasUser() || LocalThreadHolder.getUserId() == null) {
            // 未登录用户只能查看已审核的内容
            scenicSpotStrategyQueryDTO.setAuditStatus(true);
            return this.baseMapper.queryList(scenicSpotStrategyQueryDTO);
        }

        // 普通用户只能查看已审核的内容
        if (Objects.nonNull(LocalThreadHolder.getRoleId()) &&
                RoleEnum.USER.getRole().equals(LocalThreadHolder.getRoleId())) {
            scenicSpotStrategyQueryDTO.setAuditStatus(true);
        }
        return this.baseMapper.queryList(scenicSpotStrategyQueryDTO);
    }

    @Override
    public List<ScenicSpotStrategyListVO> queryUserList(ScenicSpotStrategyQueryDTO scenicSpotStrategyQueryDTO) {
        scenicSpotStrategyQueryDTO.setUserId(LocalThreadHolder.getUserId());
        return this.baseMapper.queryList(scenicSpotStrategyQueryDTO);
    }

    /**
     * 景点攻略查询符合条件的数据
     *
     * @param scenicSpotStrategyQueryDTO 查询条件类
     * @return List<ScenicSpotStrategyListVO>
     */
    @Override
    public Integer queryListCount(ScenicSpotStrategyQueryDTO scenicSpotStrategyQueryDTO) {
        return this.baseMapper.queryListCount(scenicSpotStrategyQueryDTO);
    }

    /**
     * 审核
     *
     * @param id          主键ID
     * @param auditStatus 状态
     */
    @Override
    public void auditChange(Integer id, Boolean auditStatus) {
        AssertUtils.notNull(id, "ID不能为空");
        // 要求管理员才能审核
        RoleValidUtils.requestedAdmin("无操作权限");
        ScenicSpotStrategy scenicSpotStrategy = new ScenicSpotStrategy();
        scenicSpotStrategy.setId(id);
        scenicSpotStrategy.setAuditStatus(auditStatus);
        updateById(scenicSpotStrategy);
    }

    /**
     * 查询用户收藏的景点攻略信息
     *
     * @param scenicSpotStrategyQueryDTO 景点攻略查询条件类
     * @return List<ScenicSpotStrategyListVO>
     */
    @Override
    public List<ScenicSpotStrategyListVO> collection(ScenicSpotStrategyQueryDTO scenicSpotStrategyQueryDTO) {
        // 先去查询用户收藏了哪些景点攻略
        UserActionOperationQueryDTO queryDTO = userActionOperationService.createQueryDTO(
                "SCENIC_SPOT_STRATEGY",
                null,
                ActionTypeEnum.TYPE_1.getType()
        );
        // 用户收藏的景点攻略ID列表
        List<Integer> scenicSpotStrategyIds = userActionOperationService.getContentIds(queryDTO);
        if (scenicSpotStrategyIds.isEmpty()) {
            return new ArrayList<>();
        }
        scenicSpotStrategyQueryDTO.setIds(scenicSpotStrategyIds);
        return this.baseMapper.queryList(scenicSpotStrategyQueryDTO);
    }


    /**
     * 景点攻略推荐（协同过滤算法）
     *
     * @param count 推荐的条数
     * @return Result<List < ScenicSpotStrategyListVO>> 后台通用返回封装类
     */
    @Override
    public List<ScenicSpotStrategyListVO> recommend(Integer count) {
        AssertUtils.notNull(count, "推荐条数不为空");
        // 景点ID列表
        List<Integer> scenicSpotIds = this.baseMapper.getIds();
        if (CollectionUtils.isEmpty(scenicSpotIds)) {
            return new ArrayList<>();
        }
        // 先去查询用户对于景点攻略的兴趣评分数据集
        List<ScoreVO> scores = userActionOperationService.scores(
                ActionModuleEnum.SCENIC_SPOT_STRATEGY.getModule()
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
        // 向用户推荐的景点攻略ID列表
        List<Integer> recommendScenicSpotStrategyIds = basedCFUtil.recommendItems(
                LocalThreadHolder.getUserId(),
                count
        );
        System.out.println("为用户ID为[" + LocalThreadHolder.getUserId() + "]的用户推荐的景点攻略ID列表为:" + recommendScenicSpotStrategyIds);
        // “冷启动” - 即用户可能没有产生足够的行为数据，无法计算 - 推荐热度最高的给他
        if (CollectionUtils.isEmpty(recommendScenicSpotStrategyIds)) {
            UserActionOperationQueryDTO queryDTO = new UserActionOperationQueryDTO();
            queryDTO.setCurrent(0);
            queryDTO.setSize(count);
            queryDTO.setContentModule(ActionModuleEnum.SCENIC_SPOT_STRATEGY.getModule());
            List<ContentHotScoreVO> contentHotScoreVOS = userActionOperationService.hotContentList(queryDTO);
            if (CollectionUtils.isEmpty(contentHotScoreVOS)) {
                return new ArrayList<>();
            }
            // 最热景点攻略的ID列表
            List<Integer> hotScenicSpotStrategyIds = contentHotScoreVOS.stream()
                    .map(ContentHotScoreVO::getContentId)
                    .toList();
            ScenicSpotStrategyQueryDTO scenicSpotStrategyQueryDTO = new ScenicSpotStrategyQueryDTO();
            scenicSpotStrategyQueryDTO.setIds(hotScenicSpotStrategyIds);
            return this.baseMapper.queryList(scenicSpotStrategyQueryDTO);
        }
        ScenicSpotStrategyQueryDTO scenicSpotStrategyQueryDTO = new ScenicSpotStrategyQueryDTO();
        scenicSpotStrategyQueryDTO.setIds(recommendScenicSpotStrategyIds);
            return this.baseMapper.queryList(scenicSpotStrategyQueryDTO);
    }

    /**
     * 查询景点关联的全部景点攻略
     *
     * @param scenicSpotId 景点ID
     * @return List < ScenicSpotStrategyListVO> 后台通用返回封装类
     */
    @Override
    public List<ScenicSpotStrategyListVO> all(Integer scenicSpotId) {
        AssertUtils.notNull(scenicSpotId,"景点ID不为空");
        ScenicSpotStrategyQueryDTO queryDTO = new ScenicSpotStrategyQueryDTO();
        queryDTO.setScenicSpotId(scenicSpotId);
        return this.baseMapper.queryList(queryDTO);
    }
}
