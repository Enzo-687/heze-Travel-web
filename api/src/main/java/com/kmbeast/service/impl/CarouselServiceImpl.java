package com.kmbeast.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.kmbeast.mapper.CarouselMapper;
import com.kmbeast.pojo.dto.CarouselQueryDTO;
import com.kmbeast.pojo.entity.Carousel;
import com.kmbeast.service.CarouselService;
import com.kmbeast.utils.AssertUtils;
import com.kmbeast.utils.RoleValidUtils;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 轮播图业务逻辑接口实现类
 */
@Service
public class CarouselServiceImpl extends ServiceImpl<CarouselMapper, Carousel> implements CarouselService {

    private void validParams(Carousel carousel) {
        // 校验基本信息
        AssertUtils.notNull(carousel, "参数不为空");
        AssertUtils.hasText(carousel.getTitle(), "请填写标题");
        AssertUtils.hasText(carousel.getRecommendDetail(), "请补充推介语");
        AssertUtils.hasText(carousel.getCoverUrl(), "请上传封面");
        AssertUtils.notNull(carousel.getScenicSpotId(), "景点ID不为空");
        // 内容本身的限制
        AssertUtils.isTrue(carousel.getTitle().length() < 30, "标题请控制在30字以内");
        AssertUtils.isTrue(carousel.getRecommendDetail().length() < 100, "推介语请控制在100字以内");

    }

    /**
     * 轮播图新增
     *
     * @param carousel 轮播图
     */
    @Override
    public void addCarousel(Carousel carousel) {
        RoleValidUtils.requestedAdmin("无操作权限");
        validParams(carousel);
        carousel.setCreateTime(LocalDateTime.now());
        save(carousel);
    }

    /**
     * 轮播图修改
     *
     * @param carousel 实体数据
     */
    @Override
    public void updateCarousel(Carousel carousel) {
        AssertUtils.notNull(carousel.getId(), "主键ID不为空");
        RoleValidUtils.requestedAdmin("无操作权限");
        validParams(carousel);
        updateById(carousel);

    }

    /**
     * 轮播图删除
     *
     * @param id 主键ID
     */
    @Override
    public void delCarousel(Integer id) {
        removeById(id);
    }

    /**
     * 轮播图查询
     *
     * @param carouselQueryDTO 查询条件类
     * @return List<Carousel>
     */
    @Override
    public List<Carousel> queryPage(CarouselQueryDTO carouselQueryDTO) {
        return this.baseMapper.listPage(carouselQueryDTO);
    }

    @Override
    public Integer queryPageCount(CarouselQueryDTO carouselQueryDTO) {
        return this.baseMapper.queryPageCount(carouselQueryDTO);
    }
}
