package com.kmbeast.service;

import com.kmbeast.pojo.dto.ScenicSpotRouteItemQueryDTO;
import com.kmbeast.pojo.entity.ScenicSpotRouteItem;

import java.util.List;

/**
 * 景点路线项业务逻辑接口
 */
public interface ScenicSpotRouteItemService {

    void addScenicSpotRouteItem(ScenicSpotRouteItem scenicSpotRouteItem);

    void updateScenicSpotRouteItem(ScenicSpotRouteItem scenicSpotRouteItem);

    void delScenicSpotRouteItem(Integer id);

    void delScenicSpotRouteItemByScenicSpotId(Integer id);

    List<ScenicSpotRouteItem> queryPage(ScenicSpotRouteItemQueryDTO scenicSpotRouteItemQueryDTO);

    ScenicSpotRouteItem detail(Integer id);

}
