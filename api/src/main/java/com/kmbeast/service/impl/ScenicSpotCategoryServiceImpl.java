package com.kmbeast.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.kmbeast.mapper.ScenicSpotCategoryMapper;
import com.kmbeast.pojo.entity.ScenicSpotCategory;
import com.kmbeast.service.ScenicSpotCategoryService;
import com.kmbeast.utils.AssertUtils;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 景点类别关联业务逻辑接口实现类
 */
@Service
public class ScenicSpotCategoryServiceImpl extends ServiceImpl<ScenicSpotCategoryMapper, ScenicSpotCategory> implements ScenicSpotCategoryService {

    @Override
    public void batchInsert(List<ScenicSpotCategory> ScenicSpotCategories) {
        AssertUtils.notNull(ScenicSpotCategories, "景点关联不为空");
        this.baseMapper.batchInsert(ScenicSpotCategories);
    }
}
