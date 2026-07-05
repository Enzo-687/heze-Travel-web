package com.kmbeast.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.kmbeast.pojo.dto.CategoryQueryDTO;
import com.kmbeast.pojo.entity.Category;
import com.kmbeast.pojo.vo.CategoryVO;

import java.util.List;

/**
 * 类别业务逻辑接口
 */
public interface CategoryService extends IService<Category> {

    Category addCategory(Category category);

    void updateCategory(Category category);

    void delCategory(Integer id);

    List<CategoryVO> queryPage(CategoryQueryDTO categoryQueryDTO);

    Integer queryPageCount(CategoryQueryDTO categoryQueryDTO);

    List<Integer> getScenicSpotIds(List<Integer> categoryIds    );

    List<Category> queryCategoryByScenicSpotId(Integer scenicSpotId);

}