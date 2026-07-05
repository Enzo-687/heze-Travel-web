package com.kmbeast.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.kmbeast.mapper.CategoryMapper;
import com.kmbeast.pojo.dto.CategoryQueryDTO;
import com.kmbeast.pojo.entity.Category;
import com.kmbeast.pojo.entity.ScenicSpotCategory;
import com.kmbeast.pojo.vo.CategoryVO;
import com.kmbeast.service.CategoryService;
import com.kmbeast.service.ScenicSpotCategoryService;
import com.kmbeast.utils.AssertUtils;
import com.kmbeast.utils.RoleValidUtils;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.List;

/**
 * 类别业务逻辑接口实现类
 */
@Service
public class CategoryServiceImpl extends ServiceImpl<CategoryMapper, Category> implements CategoryService {

    @Resource
    private ScenicSpotCategoryService scenicSpotCategoryService;

    private final CategoryMapper categoryMapper;

    public CategoryServiceImpl(CategoryMapper categoryMapper) {
        this.categoryMapper = categoryMapper;
    }

    /**
     * 参数校验
     *
     * @param category 图书类别实体类
     */
    private void validParams(Category category) {
        AssertUtils.notNull(category, "参数项不为空");
        AssertUtils.hasText(category.getName(), "图书类别名不为空");
        AssertUtils.notNull(category.getLevel(), "图书类别层级不能为空");
        AssertUtils.notNull(category.getParentId(), "父级ID不能为空");
    }

    /**
     * 类别新增
     *
     * @param category 图书类别实体类
     */
    @Override
    public Category addCategory(Category category) {
        // 参数校验
        validParams(category);
        // 重名校验
        validAgainName(category);
        RoleValidUtils.requestedAdmin("无操作权限");
        // 类别新增
        save(category);
        return category;
    }

    /**
     * 类别修改
     *
     * @param category 图书类别实体类
     */
    @Override
    public void updateCategory(Category category) {
        AssertUtils.notNull(category, "图书类别不为空");
        AssertUtils.notNull(category.getId(), "图书类别ID不为空");
        // 重名校验
        validAgainName(category);
        RoleValidUtils.requestedAdmin("无操作权限");
        // 类别修改
        updateById(category);
    }

    /**
     * 图书类别重名校验
     *
     * @param category 图书类别实体
     */
    public void validAgainName(Category category) {
        if (category.getParentId() != null && StringUtils.hasText(category.getName())) {
            LambdaQueryWrapper<Category> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(Category::getParentId, category.getParentId());
            wrapper.eq(Category::getName, category.getName());
            Category categoryEntity = getOne(wrapper);
            AssertUtils.isTrue(categoryEntity == null, "此类别已存在");
        }
    }

    /**
     * 删除图书类别
     *
     * @param id 主键ID
     */
    @Override
    public void delCategory(Integer id) {
        AssertUtils.notNull(id, "ID不能为空");
        RoleValidUtils.requestedAdmin("无操作权限");
        removeById(id);
    }

    /**
     * 查询图书类别
     *
     * @param categoryQueryDTO 查询条件类
     * @return List<CategoryVO> 图书类别VO集合
     */
    @Override
    public List<CategoryVO> queryPage(CategoryQueryDTO categoryQueryDTO) {
        return this.baseMapper.queryPage(categoryQueryDTO);
    }

    /**
     * 查询符合条件的总条数
     *
     * @param categoryQueryDTO 查询条件类
     * @return Integer
     */
    @Override
    public Integer queryPageCount(CategoryQueryDTO categoryQueryDTO) {
        return this.baseMapper.queryPageCount(categoryQueryDTO);
    }

    /**
     * 通过类别ID列表，查询其关联的景点ID列表
     *
     * @param categoryIds 类别ID列表
     * @return List<Integer>
     */
    @Override
    public List<Integer> getScenicSpotIds(List<Integer> categoryIds) {
        AssertUtils.notEmpty(categoryIds,"种类ID不能为空");
        return this.baseMapper.getScenicSpotIds(categoryIds);
    }

    /**
     * 通过景点ID查询其关联的类别信息
     *
     * @param scenicSpotId 景点ID
     * @return Result<List < CategoryVO>> 后台通用返回封装类
     */
    @Override
    public List<Category> queryCategoryByScenicSpotId(Integer scenicSpotId) {
        AssertUtils.notNull(scenicSpotId,"景点ID不为空");
        // 第一步，看景点关联了哪些类别
        List<ScenicSpotCategory> spotCategories = scenicSpotCategoryService.list(
                new LambdaQueryWrapper<ScenicSpotCategory>()
                        .eq(ScenicSpotCategory::getScenicSpotId, scenicSpotId)
        );
        if (CollectionUtils.isEmpty(spotCategories)) {
            return new ArrayList<>();
        }
        List<Integer> categoryIds = spotCategories.stream()
                .map(ScenicSpotCategory::getCategoryId).toList();
        // 第二步，再通过类别的ID列表去查，再返回
        return this.baseMapper.selectBatchIds(categoryIds);
    }


}