package com.kmbeast.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.kmbeast.pojo.dto.UserActionOperationQueryDTO;
import com.kmbeast.pojo.entity.UserActionOperation;
import com.kmbeast.pojo.vo.ContentHotScoreVO;
import com.kmbeast.pojo.vo.ScoreVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 用户行为操作持久化接口
 */
@Mapper
public interface UserActionOperationMapper extends BaseMapper<UserActionOperation> {

    List<Integer> getContentIds(UserActionOperationQueryDTO queryDTO);

    /**
     * 查询指定模块下的内容热度排行
     *
     * @param size          页面大小
     * @param current       当前页
     * @param contentModule 内容模块
     * @return List<ContentHotScoreVO>
     */
    List<ContentHotScoreVO> hotContentList(
            @Param(value = "size") Integer size,
            @Param(value = "current") Integer current,
            @Param(value = "contentModule") String contentModule
    );

    List<ScoreVO> scores(@Param(value = "contentModule") String contentModule);

}
