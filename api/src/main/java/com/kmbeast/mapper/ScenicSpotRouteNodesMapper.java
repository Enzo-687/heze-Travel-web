package com.kmbeast.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.kmbeast.pojo.entity.ScenicSpotRouteNodes;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 景点路线项节点持久化接口
 */
@Mapper
public interface ScenicSpotRouteNodesMapper extends BaseMapper<ScenicSpotRouteNodes> {

    /**
     * 删除景点路线ID列表所关联的景点路线节点
     * @param ids 景点路线ID列表
     */
    void removeByRouteItemIds(@Param(value = "ids") List<Integer> ids);

}
