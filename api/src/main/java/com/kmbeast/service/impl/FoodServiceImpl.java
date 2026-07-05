package com.kmbeast.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.kmbeast.mapper.FoodMapper;
import com.kmbeast.pojo.dto.FoodQueryDTO;
import com.kmbeast.pojo.entity.Food;
import com.kmbeast.service.FoodService;
import com.kmbeast.utils.AssertUtils;
import com.kmbeast.utils.RoleValidUtils;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class FoodServiceImpl extends ServiceImpl<FoodMapper, Food> implements FoodService {

    private void validParams(Food food) {
        AssertUtils.notNull(food, "参数不为空");
        AssertUtils.hasText(food.getName(), "请填写美食名称");
        AssertUtils.hasText(food.getCoverUrl(), "请上传封面图");
        AssertUtils.isTrue(food.getName().length() < 50, "名称请控制在50字以内");
    }

    @Override
    public void addFood(Food food) {
        RoleValidUtils.requestedAdmin("无操作权限");
        validParams(food);
        food.setCreateTime(LocalDateTime.now());
        save(food);
    }

    @Override
    public void updateFood(Food food) {
        AssertUtils.notNull(food.getId(), "主键ID不为空");
        RoleValidUtils.requestedAdmin("无操作权限");
        validParams(food);
        updateById(food);
    }

    @Override
    public void delFood(Integer id) {
        removeById(id);
    }

    @Override
    public List<Food> queryPage(FoodQueryDTO foodQueryDTO) {
        return this.baseMapper.listPage(foodQueryDTO);
    }

    @Override
    public Integer queryPageCount(FoodQueryDTO foodQueryDTO) {
        return this.baseMapper.queryPageCount(foodQueryDTO);
    }

    @Override
    public Food getDetail(Integer id) {
        return getById(id);
    }
}
