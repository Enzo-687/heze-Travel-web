package com.kmbeast.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.kmbeast.mapper.ScenicSpotRouteNodesMapper;
import com.kmbeast.pojo.entity.ScenicSpotRouteNodes;
import com.kmbeast.service.ScenicSpotRouteNodesService;
import com.kmbeast.utils.AssertUtils;
import com.kmbeast.utils.RoleValidUtils;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 景点路线项节点业务逻辑接口实现类
 */
@Service
public class ScenicSpotRouteNodesServiceImpl extends ServiceImpl<ScenicSpotRouteNodesMapper, ScenicSpotRouteNodes> implements ScenicSpotRouteNodesService {

    private void validParams(ScenicSpotRouteNodes scenicSpotRouteNodes) {
        // 校验基本信息
        AssertUtils.notNull(scenicSpotRouteNodes, "参数不为空");
        AssertUtils.hasText(scenicSpotRouteNodes.getFocusDesc(), "请补充核心看点");
        AssertUtils.hasText(scenicSpotRouteNodes.getType(), "请补充节点类型");
        AssertUtils.hasText(scenicSpotRouteNodes.getTimes(), "请补充大约游览时长");
        AssertUtils.notNull(scenicSpotRouteNodes.getOrderNumber(), "请补充排序序号");
        AssertUtils.notNull(scenicSpotRouteNodes.getScenicSpotRouteId(), "景点路线ID不为空");
        // 路线基本信息本身的限制
        AssertUtils.isTrue(scenicSpotRouteNodes.getFocusDesc().length() < 100, "核心看点请控制100字以内");
        AssertUtils.isTrue(scenicSpotRouteNodes.getType().length() < 50, "节点类型请控制在50字以内");
        AssertUtils.isTrue(scenicSpotRouteNodes.getTimes().length() < 50, "节点大约时长描述请控制在50字以内");
    }

    /**
     * 景点路线节点新增
     *
     * @param scenicSpotRouteNodes 节点实体
     */
    @Override
    public void addScenicSpotRouteNotes(ScenicSpotRouteNodes scenicSpotRouteNodes) {
        RoleValidUtils.requestedAdmin("无操作权限");
        validParams(scenicSpotRouteNodes);
        save(scenicSpotRouteNodes);
    }

    /**
     * 景点路线节点修改
     *
     * @param scenicSpotRouteNodes 节点实体
     */
    @Override
    public void updateScenicSpotRouteNotes(ScenicSpotRouteNodes scenicSpotRouteNodes) {
        RoleValidUtils.requestedAdmin("无操作权限");
        validParams(scenicSpotRouteNodes);
        AssertUtils.notNull(scenicSpotRouteNodes.getId(), "主键ID不为空");
        updateById(scenicSpotRouteNodes);
    }

    /**
     * 景点路线节点删除
     *
     * @param id 景点路线节点主键ID
     */
    @Override
    public void delScenicSpotRouteNotes(Integer id) {
        RoleValidUtils.requestedAdmin("无操作权限");
        AssertUtils.notNull(id, "主键ID不为空");
        removeById(id);
    }

    /**
     * 查询景点路线下面的节点列表
     *
     * @param id 主键ID
     * @return List<ScenicSpotRouteNodes>
     */
    @Override
    public List<ScenicSpotRouteNodes> nodes(Integer id) {
        AssertUtils.notNull(id, "主键ID不为空");
        return list(
                new LambdaQueryWrapper<ScenicSpotRouteNodes>()
                        .eq(ScenicSpotRouteNodes::getScenicSpotRouteId,id)
        );
    }

    /**
     * 删除景点路线ID列表所关联的景点路线节点
     * @param scenicSpotRouteItemIds 景点路线ID列表
     */
    @Override
    public void removeByRouteItemIds(List<Integer> scenicSpotRouteItemIds) {
        this.baseMapper.removeByRouteItemIds(scenicSpotRouteItemIds);
    }
}
