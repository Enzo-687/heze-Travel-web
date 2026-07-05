package com.kmbeast.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.kmbeast.pojo.dto.CarouselQueryDTO;
import com.kmbeast.pojo.entity.Carousel;
import com.kmbeast.pojo.entity.OrderRefundInfo;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * 景点门票订单退款申请持久化接口
 */
@Mapper
public interface OrderRefundInfoMapper extends BaseMapper<OrderRefundInfo> {

}
