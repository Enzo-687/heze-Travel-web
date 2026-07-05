package com.kmbeast.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.kmbeast.pojo.dto.RegionQueryDTO;
import com.kmbeast.pojo.entity.Region;
import com.kmbeast.pojo.vo.RegionVO;

import java.util.List;

/**
 * 地区业务逻辑接口
 */
public interface RegionService extends IService<Region> {

    Region addRegion(Region region);

    void updateRegion(Region region);

    void delRegion(Integer id);

    List<RegionVO> pageList(RegionQueryDTO regionQueryDTO);

    Integer pageListCount(RegionQueryDTO regionQueryDTO);

}