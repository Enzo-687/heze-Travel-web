package com.kmbeast.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.kmbeast.pojo.dto.CategoryQueryDTO;
import com.kmbeast.pojo.entity.Category;
import com.kmbeast.pojo.vo.CategoryVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 类别持久化接口
 */
@Mapper
public interface CategoryMapper extends BaseMapper<Category> {

    List<CategoryVO> queryPage(CategoryQueryDTO categoryQueryDTO);

    Integer queryPageCount(CategoryQueryDTO categoryQueryDTO);

    List<Integer> getScenicSpotIds(@Param(value = "categoryIds") List<Integer> categoryIds);
}