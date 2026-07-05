package com.kmbeast.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.kmbeast.pojo.dto.OrderRejectRefundDTO;
import com.kmbeast.pojo.dto.ScenicSpotTicketOrderQueryDTO;
import com.kmbeast.pojo.entity.ScenicSpotTicketOrder;
import com.kmbeast.pojo.vo.ScenicSpotTicketOrderTimerVO;
import com.kmbeast.pojo.vo.ScenicSpotTicketOrderVO;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 景点门票订单业务逻辑接口
 */
public interface ScenicSpotTicketOrderService extends IService<ScenicSpotTicketOrder> {

    void addScenicSpotTicketOrder(ScenicSpotTicketOrder scenicSpotTicketOrder);

    void updateScenicSpotTicketOrder(ScenicSpotTicketOrder scenicSpotTicketOrder);

    void delScenicSpotTicketOrder(Integer id);

    void delScenicSpotTicketOrderByTicketId(Integer ticketId);

    List<ScenicSpotTicketOrderVO> queryPage(ScenicSpotTicketOrderQueryDTO scenicSpotTicketOrderQueryDTO);

    Integer queryPageCount(ScenicSpotTicketOrderQueryDTO scenicSpotTicketOrderQueryDTO);

    void removeByTicketIds(List<Integer> ticketIds);

    List<ScenicSpotTicketOrderTimerVO> getOrdersByStatus(Integer status);

    void batchUpdateStatus(List<Integer> ticketOrderIds, Integer status, LocalDateTime time);

    void status(Integer id, String methodsType);

    void rejectRefund(OrderRejectRefundDTO orderRejectRefundDTO);

}
