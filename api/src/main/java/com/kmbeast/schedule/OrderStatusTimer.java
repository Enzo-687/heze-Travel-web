package com.kmbeast.schedule;

import com.kmbeast.pojo.dto.ScenicSpotTicketQueryDTO;
import com.kmbeast.pojo.entity.ScenicSpotTicket;
import com.kmbeast.pojo.enums.TicketOrderStatusEnum;
import com.kmbeast.pojo.vo.ScenicSpotTicketOrderTimerVO;
import com.kmbeast.service.ScenicSpotTicketOrderService;
import com.kmbeast.service.ScenicSpotTicketService;
import jakarta.annotation.Resource;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * 景区门票订单状态定时任务
 * 核心功能：定时扫描超时未支付的订单，自动将其状态更新为取消
 */
@Component // 标记为Spring组件，使定时任务被容器扫描并加载
public class OrderStatusTimer {

    /**
     * 注入景区门票订单业务层接口，用于订单数据的查询和状态更新
     */
    @Resource
    private ScenicSpotTicketOrderService scenicSpotTicketOrderService;

    @Resource
    private ScenicSpotTicketService scenicSpotTicketService;

    /**
     * 订单超时取消定时任务
     * 执行规则：固定频率执行，每60秒（1分钟）扫描一次待付款订单
     * 业务逻辑：
     * 1. 查询所有待付款状态的订单
     * 2. 遍历订单，判断是否超过15分钟未付款
     * 3. 对超时订单批量更新状态为"已取消"
     */
    @Scheduled(fixedRate = 60000) // fixedRate：以固定频率执行，单位毫秒（60000ms = 1分钟）
    public void orderTimer() {
        // 1. 查询所有待付款状态的景区门票订单
        List<ScenicSpotTicketOrderTimerVO> ticketOrders = scenicSpotTicketOrderService.getOrdersByStatus(
                TicketOrderStatusEnum.AWAITING_PAYMENT.getStatus()
        );

        // 2. 判空处理：如果没有待付款订单，直接结束任务，避免无效遍历
        if (CollectionUtils.isEmpty(ticketOrders)) {
            return;
        }

        // 3. 初始化超时订单ID集合，用于批量更新
        List<Integer> timeoutOrderIds = new ArrayList<>();

        // 4. 遍历待付款订单，筛选出超时15分钟未付款的订单
        for (ScenicSpotTicketOrderTimerVO ticketOrder : ticketOrders) {
            // 获取订单创建时间
            LocalDateTime orderCreateTime = ticketOrder.getCreateTime();
            // 获取当前系统时间
            LocalDateTime currentTime = LocalDateTime.now();
            // 计算订单创建时间与当前时间的时间差
            Duration duration = Duration.between(orderCreateTime, currentTime);
            // 转换时间差为分钟数（向下取整）
            long minutesDiff = duration.toMinutes();
            // 判断：如果订单超过15分钟未付款，加入超时订单ID集合
            if (minutesDiff > 15) {
                timeoutOrderIds.add(ticketOrder.getId());
            }
        }

        // 5. 批量更新超时订单状态为"已取消"（避免单条更新，提升性能）
        if (!CollectionUtils.isEmpty(timeoutOrderIds)) { // 再次判空，避免无意义的数据库操作
            scenicSpotTicketOrderService.batchUpdateStatus(
                    timeoutOrderIds,
                    TicketOrderStatusEnum.CANCEL.getStatus(),
                    LocalDateTime.now()
            );
        }

        //6. 恢复被自动取消订单占据的门票库存
        // 需要更新的库存 = 目前库存 + 要恢复的已经扣除的库存
        // 获取门票ID列表
        List<Integer> scenicSpotTicketIds = ticketOrders.stream()
                .map(ScenicSpotTicketOrderTimerVO::getScenicSpotTicketId)
                .toList();
        ScenicSpotTicketQueryDTO scenicSpotTicketQueryDTO = new ScenicSpotTicketQueryDTO();
        scenicSpotTicketQueryDTO.setIds(scenicSpotTicketIds);
        List<ScenicSpotTicket> scenicSpotTickets = scenicSpotTicketService.queryPage(scenicSpotTicketQueryDTO);

        if (!CollectionUtils.isEmpty(scenicSpotTickets)) {
            // 构建Map映射表（key-景点门票ID，value：门票对象）
            Map<Integer, ScenicSpotTicket> spotTicketMap = scenicSpotTickets.stream().collect(
                    Collectors.toMap(
                            ScenicSpotTicket::getId,
                            Function.identity()
                    )
            );
            // 处理库存
            for (ScenicSpotTicketOrderTimerVO ticketOrder : ticketOrders) {
                ScenicSpotTicket scenicSpotTicket = spotTicketMap.get(ticketOrder.getScenicSpotTicketId());
                Integer totalNumber = scenicSpotTicket.getTotalNumber(); // 当前门票库存数
                Integer buyNumber = ticketOrder.getBuyNumber(); // 已取消订单占据的库存
                scenicSpotTicket.setTotalNumber(totalNumber + buyNumber);
            }
            // 把订单占据的门票的名额解放出来
            List<ScenicSpotTicket> spotTickets = spotTicketMap.values().stream().toList();
            scenicSpotTicketService.batchUpdateStore(spotTickets);
        }

    }

}