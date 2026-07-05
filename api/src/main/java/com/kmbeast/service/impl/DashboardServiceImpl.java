package com.kmbeast.service.impl;

import com.kmbeast.mapper.DashboardMapper;
import com.kmbeast.pojo.dto.ScenicSpotTicketOrderQueryDTO;
import com.kmbeast.pojo.entity.ScenicSpotTicketOrder;
import com.kmbeast.pojo.enums.OrderRefundQueryStatusEnum;
import com.kmbeast.pojo.enums.TicketOrderStatusEnum;
import com.kmbeast.pojo.vo.ScenicSpotTicketOrderVO;
import com.kmbeast.pojo.vo.ValuesVO;
import com.kmbeast.service.DashboardService;
import com.kmbeast.service.ScenicSpotTicketOrderService;
import com.kmbeast.utils.AssertUtils;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 仪表盘业务逻辑接口实现类
 */
@Service
public class DashboardServiceImpl implements DashboardService {

    @Resource
    private DashboardMapper dashboardMapper;
    @Resource
    private ScenicSpotTicketOrderService scenicSpotTicketOrderService;

    @Override
    public List<ValuesVO> staticValues() {
        return dashboardMapper.staticValues();
    }

    @Override
    public List<ValuesVO> pieValues() {
        return dashboardMapper.pieValues();
    }

    private ScenicSpotTicketOrderQueryDTO createScenicSpotTicketOrderQueryDTO(Integer days) {
        AssertUtils.notNull(days, "以往查询天数不为空");
        LocalDateTime nowTime = LocalDateTime.now();
        LocalDateTime startTime = nowTime.minusDays(days);
        ScenicSpotTicketOrderQueryDTO scenicSpotTicketOrderQueryDTO = new ScenicSpotTicketOrderQueryDTO();
        scenicSpotTicketOrderQueryDTO.setStartTime(startTime);
        scenicSpotTicketOrderQueryDTO.setEndTime(nowTime);
        return scenicSpotTicketOrderQueryDTO;
    }

    /**
     * 折线图 - 订单销售额统计
     *
     * @return List<ValuesVO>
     */
    @Override
    public List<ValuesVO> ordersMoney(Integer days) {
        ScenicSpotTicketOrderQueryDTO scenicSpotTicketOrderQueryDTO = createScenicSpotTicketOrderQueryDTO(days);
        // 只统计待使用 - 已核销状态的订单
        scenicSpotTicketOrderQueryDTO.setStatusList(
                List.of(
                        TicketOrderStatusEnum.AWAITING_USE.getStatus(),
                        TicketOrderStatusEnum.VERIFIED.getStatus()
                )
        );
        List<ScenicSpotTicketOrderVO> scenicSpotTicketOrderVOS = scenicSpotTicketOrderService.queryPage(scenicSpotTicketOrderQueryDTO);
        return countData(scenicSpotTicketOrderVOS);
    }

    private List<ValuesVO> countData(List<ScenicSpotTicketOrderVO> scenicSpotTicketOrderVOS) {
        if (CollectionUtils.isEmpty(scenicSpotTicketOrderVOS)) {
            return new ArrayList<>();
        }
        // 按照日期统计好订单销售额的双列集合
        Map<String, BigDecimal> bigDecimalMap = scenicSpotTicketOrderVOS.stream()
                .filter(order -> Objects.nonNull(order.getCreateTime()))
                .collect(
                        Collectors.groupingBy(
                                order -> order.getCreateTime().format(DateTimeFormatter.ofPattern("yyyy年MM月dd日")),
                                Collectors.reducing(
                                        BigDecimal.ZERO,
                                        ScenicSpotTicketOrder::getPrice,
                                        BigDecimal::add
                                )
                        )
                );
        return convertMapToValuesList(bigDecimalMap);
    }

    /**
     * 折线图 - 订单退款额统计
     *
     * @return List<ValuesVO>
     */
    @Override
    public List<ValuesVO> ordersRefundMoney(Integer days) {
        ScenicSpotTicketOrderQueryDTO scenicSpotTicketOrderQueryDTO = createScenicSpotTicketOrderQueryDTO(days);
        // 只统计已退款的订单
        scenicSpotTicketOrderQueryDTO.setStatus(OrderRefundQueryStatusEnum.REFUNDED.getStatus());
        List<ScenicSpotTicketOrderVO> scenicSpotTicketOrderVOS = scenicSpotTicketOrderService.queryPage(scenicSpotTicketOrderQueryDTO);
        return countData(scenicSpotTicketOrderVOS);
    }

    /**
     * 转换List<ValuesVO>
     */
    public static List<ValuesVO> convertMapToValuesList(Map<String, BigDecimal> bigDecimalMap) {
        if (bigDecimalMap == null || bigDecimalMap.isEmpty()) {
            return new ArrayList<>();
        }

        return bigDecimalMap.entrySet().stream()
                .map(entry -> {
                    ValuesVO valuesVO = new ValuesVO();
                    valuesVO.setName(entry.getKey());  // 日期作为name
                    valuesVO.setValue(entry.getValue());  // 金额作为value
                    return valuesVO;
                })
                .collect(Collectors.toList());
    }

}
