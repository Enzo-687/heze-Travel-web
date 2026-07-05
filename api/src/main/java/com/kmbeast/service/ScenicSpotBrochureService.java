package com.kmbeast.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.kmbeast.pojo.dto.ScenicSpotBrochureQueryDTO;
import com.kmbeast.pojo.entity.ScenicSpotBrochure;

import java.util.List;

/**
 * 景点图册业务逻辑接口
 */
public interface ScenicSpotBrochureService extends IService<ScenicSpotBrochure> {

    void addScenicSpotBrochure(List<ScenicSpotBrochure> scenicSpotBrochureList);

    void updateScenicSpotBrochure(ScenicSpotBrochure scenicSpotBrochure);

    void delScenicSpotBrochure(Integer id);

    List<ScenicSpotBrochure> pageList(ScenicSpotBrochureQueryDTO queryDTO);

    Integer pageListCount(ScenicSpotBrochureQueryDTO queryDTO);

}
