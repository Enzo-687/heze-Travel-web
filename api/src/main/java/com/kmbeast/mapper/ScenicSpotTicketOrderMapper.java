package com.kmbeast.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.kmbeast.pojo.dto.ScenicSpotTicketOrderQueryDTO;
import com.kmbeast.pojo.entity.ScenicSpotTicketOrder;
import com.kmbeast.pojo.vo.ScenicSpotTicketOrderTimerVO;
import com.kmbeast.pojo.vo.ScenicSpotTicketOrderVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 景点门票订单持久化接口
 */
@Mapper
public interface ScenicSpotTicketOrderMapper extends BaseMapper<ScenicSpotTicketOrder> {

    List<ScenicSpotTicketOrderVO> queryPage(ScenicSpotTicketOrderQueryDTO scenicSpotTicketOrderQueryDTO);

    Integer queryPageCount(ScenicSpotTicketOrderQueryDTO scenicSpotTicketOrderQueryDTO);

    void removeByTicketIds(@Param(value = "ticketIds") List<Integer> ticketIds);

    List<ScenicSpotTicketOrderTimerVO> getOrdersByStatus(@Param(value = "status") Integer status);

    void batchUpdateStatus(@Param("ids") List<Integer> ticketOrderIds,
                           @Param(value = "status") Integer status,
                           @Param(value = "time") LocalDateTime time);
}
