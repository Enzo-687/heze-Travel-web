package com.kmbeast.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.kmbeast.pojo.entity.ScenicSpotRouteNodes;

import java.util.List;

/**
 * 景点路线项节点业务逻辑接口
 */
public interface ScenicSpotRouteNodesService extends IService<ScenicSpotRouteNodes> {

    void addScenicSpotRouteNotes(ScenicSpotRouteNodes scenicSpotRouteNodes);

    void updateScenicSpotRouteNotes(ScenicSpotRouteNodes scenicSpotRouteNodes);

    void delScenicSpotRouteNotes(Integer id);

    List<ScenicSpotRouteNodes> nodes(Integer id);

    void removeByRouteItemIds(List<Integer> scenicSpotRouteItemIds);

}
