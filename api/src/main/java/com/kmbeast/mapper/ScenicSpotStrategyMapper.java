package com.kmbeast.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.kmbeast.pojo.dto.ScenicSpotStrategyQueryDTO;
import com.kmbeast.pojo.entity.ScenicSpotStrategy;
import com.kmbeast.pojo.vo.ScenicSpotStrategyDetailVO;
import com.kmbeast.pojo.vo.ScenicSpotStrategyListVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * 景点攻略持久化接口
 */
@Mapper
public interface ScenicSpotStrategyMapper extends BaseMapper<ScenicSpotStrategy> {

    ScenicSpotStrategyDetailVO detail(@Param("id") Integer id);

    List<ScenicSpotStrategyListVO> queryList(ScenicSpotStrategyQueryDTO scenicSpotStrategyQueryDTO);

    Integer queryListCount(ScenicSpotStrategyQueryDTO scenicSpotStrategyQueryDTO);

    @Select(value = "SELECT sss.id FROM scenic_spot_strategy sss ")
    List<Integer> getIds();

}
