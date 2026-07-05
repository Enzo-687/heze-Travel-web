package com.kmbeast.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.kmbeast.mapper.ScenicSpotRouteItemMapper;
import com.kmbeast.pojo.dto.ScenicSpotRouteItemQueryDTO;
import com.kmbeast.pojo.entity.ScenicSpotRouteItem;
import com.kmbeast.pojo.entity.ScenicSpotRouteNodes;
import com.kmbeast.service.ScenicSpotRouteItemService;
import com.kmbeast.service.ScenicSpotRouteNodesService;
import com.kmbeast.utils.AssertUtils;
import com.kmbeast.utils.RoleValidUtils;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;

import java.util.List;

/**
 * 景点路线项业务逻辑接口实现类
 */
@Service
public class ScenicSpotRouteItemServiceImpl extends ServiceImpl<ScenicSpotRouteItemMapper, ScenicSpotRouteItem> implements ScenicSpotRouteItemService {

    @Resource
    private ScenicSpotRouteNodesService scenicSpotRouteNodesService;

    private void validParams(ScenicSpotRouteItem scenicSpotRouteItem) {
        // 校验基本信息
        AssertUtils.notNull(scenicSpotRouteItem, "参数不为空");
        AssertUtils.hasText(scenicSpotRouteItem.getFocusDesc(), "请补充核心看点");
        AssertUtils.hasText(scenicSpotRouteItem.getPositionDesc(), "请补充路线定位");
        AssertUtils.hasText(scenicSpotRouteItem.getTimes(), "请补充路线时长");
        AssertUtils.notNull(scenicSpotRouteItem.getIntensity(), "请填写路线强度（1-5级）");
        AssertUtils.notNull(scenicSpotRouteItem.getScenicSpotId(), "景点ID不为空");
        // 路线基本信息本身的限制
        AssertUtils.isTrue(scenicSpotRouteItem.getFocusDesc().length() < 100, "核心看点请控制100字以内");
        AssertUtils.isTrue(scenicSpotRouteItem.getPositionDesc().length() < 50, "路线定位请控制在50字以内");
        AssertUtils.isTrue(scenicSpotRouteItem.getTimes().length() < 50, "路线大约时长描述请控制在50字以内");
    }

    /**
     * 景点路线新增
     *
     * @param scenicSpotRouteItem 景点路线项
     */
    @Override
    public void addScenicSpotRouteItem(ScenicSpotRouteItem scenicSpotRouteItem) {
        RoleValidUtils.requestedAdmin("无操作权限");
        validParams(scenicSpotRouteItem);
        save(scenicSpotRouteItem);
    }

    /**
     * 景点路线项修改
     *
     * @param scenicSpotRouteItem 景点路线项
     */
    @Override
    public void updateScenicSpotRouteItem(ScenicSpotRouteItem scenicSpotRouteItem) {
        RoleValidUtils.requestedAdmin("无操作权限");
        validParams(scenicSpotRouteItem);
        AssertUtils.notNull(scenicSpotRouteItem.getId(), "景点路线项主键ID不为空");
        updateById(scenicSpotRouteItem);
    }

    /**
     * 通过ID删除景点路线项
     *
     * @param scenicSpotId 景点ID
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void delScenicSpotRouteItemByScenicSpotId(Integer scenicSpotId) {
        RoleValidUtils.requestedAdmin("无操作权限");
        List<ScenicSpotRouteItem> scenicSpotRouteItems = list(
                new LambdaUpdateWrapper<ScenicSpotRouteItem>()
                        .eq(ScenicSpotRouteItem::getScenicSpotId, scenicSpotId)
        );
        if (CollectionUtils.isEmpty(scenicSpotRouteItems)) {
            return;
        }
        // 景点路线项的ID列表
        List<Integer> scenicSpotRouteItemIds = scenicSpotRouteItems.stream().map(
                ScenicSpotRouteItem::getId
        ).toList();
        // 1. 删除景点关联的景点路线本身信息
        removeBatchByIds(scenicSpotRouteItemIds);
        // 2. 删除景点路线关联的景点路线节点信息
        scenicSpotRouteNodesService.removeByRouteItemIds(scenicSpotRouteItemIds);
    }


    /**
     * 通过ID删除景点路线项
     *
     * @param id 主键ID
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void delScenicSpotRouteItem(Integer id) {
        RoleValidUtils.requestedAdmin("无操作权限");
        // 1. 删除景点路线本身信息
        removeById(id);
        // 2. 删除景点路线关联的景点路线节点信息
        scenicSpotRouteNodesService.remove(
                new LambdaQueryWrapper<ScenicSpotRouteNodes>()
                        .eq(ScenicSpotRouteNodes::getScenicSpotRouteId, id)
        );
    }

    /**
     * 景点路线项查询
     *
     * @param scenicSpotRouteItemQueryDTO 查询条件类
     * @return List<ScenicSpotRouteItem>
     */
    @Override
    public List<ScenicSpotRouteItem> queryPage(ScenicSpotRouteItemQueryDTO scenicSpotRouteItemQueryDTO) {
        AssertUtils.notNull(scenicSpotRouteItemQueryDTO, "景点路线项查询条件类不为空");
        AssertUtils.notNull(scenicSpotRouteItemQueryDTO.getScenicSpotId(), "景点ID不为空");
        return list(
                new LambdaQueryWrapper<ScenicSpotRouteItem>()
                        .eq(ScenicSpotRouteItem::getScenicSpotId, scenicSpotRouteItemQueryDTO.getScenicSpotId())
        );
    }

    /**
     * 通过景点路线项主键ID查询详情
     *
     * @param id 主键ID
     * @return ScenicSpotRouteItem
     */
    @Override
    public ScenicSpotRouteItem detail(Integer id) {
        return getById(id);
    }
}
