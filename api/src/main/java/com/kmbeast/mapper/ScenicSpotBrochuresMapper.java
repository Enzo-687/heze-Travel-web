package com.kmbeast.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.kmbeast.pojo.dto.ScenicSpotBrochureQueryDTO;
import com.kmbeast.pojo.entity.ScenicSpotBrochure;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 景点图册持久化接口
 */
@Mapper
public interface ScenicSpotBrochuresMapper extends BaseMapper<ScenicSpotBrochure> {

    void batchSave(@Param(value = "scenicSpotBrochureList") List<ScenicSpotBrochure> scenicSpotBrochureList);

    List<ScenicSpotBrochure> pageList(ScenicSpotBrochureQueryDTO queryDTO);

    Integer pageListCount(ScenicSpotBrochureQueryDTO queryDTO);

}
