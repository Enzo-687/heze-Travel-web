package com.kmbeast.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.kmbeast.context.LocalThreadHolder;
import com.kmbeast.mapper.UserActionOperationMapper;
import com.kmbeast.pojo.dto.UserActionOperationQueryDTO;
import com.kmbeast.pojo.entity.UserActionOperation;
import com.kmbeast.pojo.enums.ActionTypeEnum;
import com.kmbeast.pojo.vo.ContentHotScoreVO;
import com.kmbeast.pojo.vo.ScoreVO;
import com.kmbeast.service.UserActionOperationService;
import com.kmbeast.utils.AssertUtils;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 用户行为操作业务逻辑接口实现类
 */
@Service
public class UserActionOperationServiceImpl extends ServiceImpl<UserActionOperationMapper, UserActionOperation> implements UserActionOperationService {

    private void validParams(UserActionOperation userActionOperation) {
        // 校验基本信息
        AssertUtils.notNull(userActionOperation, "参数不为空");
        AssertUtils.notNull(userActionOperation.getUserId(), "用户ID不为空");
        AssertUtils.hasText(userActionOperation.getContentModule(), "内容模块不为空");
        AssertUtils.notNull(userActionOperation.getContentId(), "内容ID不为空");
        AssertUtils.notNull(userActionOperation.getType(), "类型不为空");
    }

    @Override
    public void addAction(UserActionOperation userActionOperation) {
        validParams(userActionOperation);
        userActionOperation.setCreateTime(LocalDateTime.now());
        // 如果限制一个人只能看一次，先去查，如果没有看过指定内容，才去新增
        save(userActionOperation);
    }

    @Override
    public void delAction(Integer id) {
        AssertUtils.notNull(id, "ID不为空");
        AssertUtils.notNull(LocalThreadHolder.getUserId(), "请先登录");
        remove(
                new LambdaUpdateWrapper<UserActionOperation>()
                        .eq(UserActionOperation::getId, id)
                        .eq(UserActionOperation::getUserId, LocalThreadHolder.getUserId())
        );
    }

    @Override
    public List<UserActionOperation> queryPage(UserActionOperationQueryDTO queryDTO) {
        LambdaQueryWrapper<UserActionOperation> wrapper = new LambdaQueryWrapper<>();
        // 用户ID不为空则拼接 user_id = ?
        wrapper.eq(
                queryDTO.getUserId() != null,
                UserActionOperation::getUserId,
                queryDTO.getUserId());
        // 类型不为空则拼接 type = ?
        wrapper.eq(
                queryDTO.getType() != null,
                UserActionOperation::getType,
                queryDTO.getType());
        // 内容模块不为空则拼接 content_modules = ?
        wrapper.eq(
                StringUtils.hasText(queryDTO.getContentModule()),
                UserActionOperation::getContentModule,
                queryDTO.getContentModule());
        // 内容ID不为空则拼接 content_id = ?
        wrapper.eq(
                queryDTO.getContentId() != null,
                UserActionOperation::getContentId,
                queryDTO.getContentId());
        // 开始时间及结束时间不为空，拼接 create_time BETWEEN ? AND ?
        wrapper.between(
                queryDTO.getStartTime() != null && queryDTO.getEndTime() != null,
                UserActionOperation::getCreateTime,
                queryDTO.getStartTime(),
                queryDTO.getEndTime()
        );
        return list(wrapper);
    }

    /**
     * 收藏与取消收藏
     * 对立：收藏 - 新增；取消收藏 - 删除
     *
     * @param userActionOperation 用户行为操作实体
     */
    @Override
    public void collection(UserActionOperation userActionOperation) {
        UserActionOperationQueryDTO queryDTO = createQueryDTO(
                userActionOperation.getContentModule(), // 设置模块
                userActionOperation.getContentId(), // 设置内容ID
                ActionTypeEnum.TYPE_1.getType() // 声明为收藏行为
        );
        // 先去查询，用户有没有收藏内容
        List<UserActionOperation> actions = queryPage(queryDTO);
        if (CollectionUtils.isEmpty(actions)) { // 证明用户并没有收藏指定模块下面的指定的内容
            userActionOperation.setUserId(LocalThreadHolder.getUserId()); // 设置上操作者用户ID
            userActionOperation.setType(ActionTypeEnum.TYPE_1.getType()); // 声明为收藏行为类型
            addAction(userActionOperation);
            return;
        }
        UserActionOperation actionOperation = actions.get(0);
        // 已经存在收藏记录，此操作为“取消收藏”，删除对应的数据即可
        delAction(actionOperation.getId());
    }


    /**
     * 创建查询条件类
     *
     * @param contentModule 内容模块
     * @param contentId     内容ID
     * @param type          类型
     * @return UserActionOperationQueryDTO
     */
    @Override
    public UserActionOperationQueryDTO createQueryDTO(String contentModule,
                                                      Integer contentId,
                                                      Integer type) {
        return UserActionOperationQueryDTO.builder()
                .userId(LocalThreadHolder.getUserId())
                .contentModule(contentModule)
                .contentId(contentId)
                .type(type)
                .build();
    }

    /**
     * 点赞或取消点赞
     *
     * @param userActionOperation 用户行为操作实体
     */
    @Override
    public void upvote(UserActionOperation userActionOperation) {
        UserActionOperationQueryDTO queryDTO = createQueryDTO(
                userActionOperation.getContentModule(), // 设置模块
                userActionOperation.getContentId(), // 设置内容ID
                ActionTypeEnum.TYPE_2.getType() // 声明为点赞行为
        );
        // 先去查询，用户有没有点赞内容
        List<UserActionOperation> actions = queryPage(queryDTO);
        if (CollectionUtils.isEmpty(actions)) { // 证明用户并没有点赞指定模块下面的指定的内容
            userActionOperation.setUserId(LocalThreadHolder.getUserId()); // 设置上操作者用户ID
            userActionOperation.setType(ActionTypeEnum.TYPE_2.getType()); // 声明为点赞行为类型
            addAction(userActionOperation);
            return;
        }
        UserActionOperation actionOperation = actions.get(0);
        // 已经存在点赞记录，此操作为“取消点赞”，删除对应的数据即可
        delAction(actionOperation.getId());
    }


    @Override
    public List<Integer> getContentIds(UserActionOperationQueryDTO queryDTO) {
        return this.baseMapper.getContentIds(queryDTO);
    }

    /**
     * 查询指定模块下的内容热度排行
     * @param queryDTO 查询条件类
     * @return List<ContentHotScoreVO>
     */
    @Override
    public List<ContentHotScoreVO> hotContentList(UserActionOperationQueryDTO queryDTO) {
        AssertUtils.notNull(queryDTO,"查询参数不为空");
        AssertUtils.notNull(queryDTO.getCurrent(),"当前页不为空");
        AssertUtils.notNull(queryDTO.getSize(),"页面大小不为空");
        AssertUtils.hasText(queryDTO.getContentModule(),"模块不为空");
        return this.baseMapper.hotContentList(
                queryDTO.getSize(),
                queryDTO.getCurrent(),
                queryDTO.getContentModule()
        );
    }

    /**
     * 获取用户的兴趣评分集
     * @param module 模块
     * @return List<ScoreVO>
     */
    @Override
    public List<ScoreVO> scores(String module) {
        AssertUtils.hasText(module,"模块不为空");
        return this.baseMapper.scores(module);
    }
}
