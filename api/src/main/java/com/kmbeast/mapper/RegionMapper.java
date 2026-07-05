package com.kmbeast.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.kmbeast.pojo.dto.RegionQueryDTO;
import com.kmbeast.pojo.entity.Region;
import com.kmbeast.pojo.vo.RegionVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * 地区信息持久化接口
 */
@Mapper
public interface RegionMapper extends BaseMapper<Region> {

    List<RegionVO> selectRegionList(RegionQueryDTO regionQueryDTO);

    Integer selectRegionListCount(RegionQueryDTO regionQueryDTO);

}