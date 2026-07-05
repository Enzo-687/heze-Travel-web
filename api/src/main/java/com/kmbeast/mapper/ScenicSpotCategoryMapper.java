package com.kmbeast.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.kmbeast.pojo.entity.ScenicSpotCategory;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 景点类别关联持久化接口
 */
@Mapper
public interface ScenicSpotCategoryMapper extends BaseMapper<ScenicSpotCategory> {

    void batchInsert(@Param(value = "ScenicSpotCategories") List<ScenicSpotCategory> ScenicSpotCategories);

}