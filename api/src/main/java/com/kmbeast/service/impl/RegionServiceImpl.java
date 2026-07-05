package com.kmbeast.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.kmbeast.mapper.RegionMapper;
import com.kmbeast.pojo.dto.RegionQueryDTO;
import com.kmbeast.pojo.entity.Region;
import com.kmbeast.pojo.vo.RegionVO;
import com.kmbeast.service.RegionService;
import com.kmbeast.utils.AssertUtils;
import com.kmbeast.utils.RoleValidUtils;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;

/**
 * 地区业务逻辑接口实现类
 */
@Service
public class RegionServiceImpl extends ServiceImpl<RegionMapper, Region> implements RegionService {

    /**
     * 参数校验
     *
     * @param region 地区实体类
     */
    private void validParams(Region region) {
        AssertUtils.notNull(region, "参数项不为空");
        AssertUtils.hasText(region.getName(), "地区名不为空");
        AssertUtils.notNull(region.getLevel(), "地区层级不能为空");
        AssertUtils.notNull(region.getParentId(), "父级ID不能为空");
    }

    /**
     * 地区新增
     *
     * @param region 地区实体类
     */
    @Override
    public Region addRegion(Region region) {
        // 参数校验
        validParams(region);
        // 重名校验
        validAgainName(region);
        RoleValidUtils.requestedAdmin("无操作权限");
        // 地区新增
        save(region);
        return region;
    }

    /**
     * 地区修改
     *
     * @param region 地区实体类
     */
    @Override
    public void updateRegion(Region region) {
        AssertUtils.notNull(region, "地区不为空");
        AssertUtils.notNull(region.getId(), "地区ID不为空");
        // 重名校验
        validAgainName(region);
        RoleValidUtils.requestedAdmin("无操作权限");
        // 地区修改
        updateById(region);
    }

    /**
     * 地区重名校验
     *
     * @param region 地区实体
     */
    public void validAgainName(Region region) {
        if (region.getParentId() != null && StringUtils.hasText(region.getName())) {
            LambdaQueryWrapper<Region> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(Region::getParentId, region.getParentId());
            wrapper.eq(Region::getName, region.getName());
            Region regionEntity = getOne(wrapper);
            AssertUtils.isTrue(regionEntity == null, "此地区已存在");
        }
    }

    /**
     * 删除地区
     *
     * @param id 主键ID
     */
    @Override
    public void delRegion(Integer id) {
        AssertUtils.notNull(id, "ID不能为空");
        RoleValidUtils.requestedAdmin("无操作权限");
        removeById(id);
    }

    /**
     * 查询地区
     *
     * @param regionQueryDTO 查询条件类
     * @return List<RegionVO> 地区VO集合
     */
    @Override
    public List<RegionVO> pageList(RegionQueryDTO regionQueryDTO) {
        return this.baseMapper.selectRegionList(regionQueryDTO);
    }

    /**
     * 查询符合条件的总条数
     *
     * @param regionQueryDTO 查询条件类
     * @return Integer
     */
    @Override
    public Integer pageListCount(RegionQueryDTO regionQueryDTO) {
        return this.baseMapper.selectRegionListCount(regionQueryDTO);
    }
}