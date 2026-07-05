package com.kmbeast.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.kmbeast.pojo.dto.ScenicSpotStrategyQueryDTO;
import com.kmbeast.pojo.entity.ScenicSpotStrategy;
import com.kmbeast.pojo.vo.ScenicSpotListVO;
import com.kmbeast.pojo.vo.ScenicSpotStrategyDetailVO;
import com.kmbeast.pojo.vo.ScenicSpotStrategyListVO;

import java.util.List;

/**
 * 景点攻略业务逻辑接口
 */
public interface ScenicSpotStrategyService extends IService<ScenicSpotStrategy> {

    void addScenicSpotStrategy(ScenicSpotStrategy scenicSpotStrategy);

    void updateScenicSpotStrategy(ScenicSpotStrategy scenicSpotStrategy);

    void delScenicSpotStrategy(Integer id);

    ScenicSpotStrategyDetailVO detail(Integer id);

    List<ScenicSpotStrategyListVO> queryList(ScenicSpotStrategyQueryDTO scenicSpotStrategyQueryDTO);

    Integer queryListCount(ScenicSpotStrategyQueryDTO scenicSpotStrategyQueryDTO);

    void auditChange(Integer id, Boolean auditStatus);

    List<ScenicSpotStrategyListVO> queryUserList(ScenicSpotStrategyQueryDTO scenicSpotStrategyQueryDTO);

    List<ScenicSpotStrategyListVO> collection(ScenicSpotStrategyQueryDTO scenicSpotStrategyQueryDTO);

    List<ScenicSpotStrategyListVO> recommend(Integer count);

    List<ScenicSpotStrategyListVO> all(Integer scenicSpotId);


}
