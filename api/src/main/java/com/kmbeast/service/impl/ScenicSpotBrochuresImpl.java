package com.kmbeast.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.kmbeast.mapper.ScenicSpotBrochuresMapper;
import com.kmbeast.pojo.dto.ScenicSpotBrochureQueryDTO;
import com.kmbeast.pojo.entity.ScenicSpotBrochure;
import com.kmbeast.service.ScenicSpotBrochureService;
import com.kmbeast.utils.AssertUtils;
import com.kmbeast.utils.RoleValidUtils;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 景点图册业务逻辑接口实现类
 */
@Service
public class ScenicSpotBrochuresImpl extends ServiceImpl<ScenicSpotBrochuresMapper, ScenicSpotBrochure> implements ScenicSpotBrochureService {

    /**
     * 景点图册新增
     *
     * @param scenicSpotBrochureList 景点图册列表
     */
    @Override
    public void addScenicSpotBrochure(List<ScenicSpotBrochure> scenicSpotBrochureList) {
        RoleValidUtils.requestedAdmin("无操作权限");
        AssertUtils.notEmpty(scenicSpotBrochureList, "景点图册不为空");
        for (ScenicSpotBrochure scenicSpotBrochure : scenicSpotBrochureList) {
            AssertUtils.notNull(scenicSpotBrochure.getScenicSpotId(), "景点ID不为空");
            AssertUtils.hasText(scenicSpotBrochure.getCoverUrl(), "景点图片URL不为空");
            AssertUtils.notNull(scenicSpotBrochure.getOrderNumber(), "请补充序号");
        }
        this.baseMapper.batchSave(scenicSpotBrochureList);
    }


    @Override
    public void updateScenicSpotBrochure(ScenicSpotBrochure scenicSpotBrochure) {

    }

    /**
     * 景点图册删除
     *
     * @param id 主键ID
     */
    @Override
    public void delScenicSpotBrochure(Integer id) {
        AssertUtils.notNull(id, "ID不为空");
        RoleValidUtils.requestedAdmin("无操作权限");
        removeById(id);
    }

    /**
     * 景点图册查询
     *
     * @param queryDTO 查询条件类
     * @return List<ScenicSpotBrochure>
     */
    @Override
    public List<ScenicSpotBrochure> pageList(ScenicSpotBrochureQueryDTO queryDTO) {
        return this.baseMapper.pageList(queryDTO);
    }

    /**
     * 查询符合条件的总条数
     *
     * @param queryDTO queryDTO
     * @return Integer
     */
    @Override
    public Integer pageListCount(ScenicSpotBrochureQueryDTO queryDTO) {
        return this.baseMapper.pageListCount(queryDTO);
    }
}
