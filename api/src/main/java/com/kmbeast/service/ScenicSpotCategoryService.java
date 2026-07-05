package com.kmbeast.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.kmbeast.pojo.entity.ScenicSpotCategory;

import java.util.List;

/**
 * 景点类别关联业务逻辑接口
 */
public interface ScenicSpotCategoryService extends IService<ScenicSpotCategory> {

    void batchInsert(List<ScenicSpotCategory> ScenicSpotCategories);

}
