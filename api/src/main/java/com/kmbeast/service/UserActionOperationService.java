package com.kmbeast.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.kmbeast.pojo.dto.UserActionOperationQueryDTO;
import com.kmbeast.pojo.entity.UserActionOperation;
import com.kmbeast.pojo.vo.ContentHotScoreVO;
import com.kmbeast.pojo.vo.ScoreVO;

import java.util.List;

/**
 * 用户行为操作业务逻辑接口
 */
public interface UserActionOperationService extends IService<UserActionOperation> {

    void addAction(UserActionOperation userActionOperation);

    void delAction(Integer id);

    List<UserActionOperation> queryPage(UserActionOperationQueryDTO queryDTO);

    void collection(UserActionOperation userActionOperation);

    UserActionOperationQueryDTO createQueryDTO(
            String contentModule,
            Integer contentId,
            Integer type
    );

    void upvote(UserActionOperation userActionOperation);

    List<Integer> getContentIds(UserActionOperationQueryDTO queryDTO);

    List<ContentHotScoreVO> hotContentList(UserActionOperationQueryDTO queryDTO);

    List<ScoreVO> scores(String module);

}
