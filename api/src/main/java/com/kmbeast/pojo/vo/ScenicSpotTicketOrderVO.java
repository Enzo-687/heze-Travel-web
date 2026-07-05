package com.kmbeast.pojo.vo;

import com.kmbeast.pojo.entity.OrderRefundInfo;
import com.kmbeast.pojo.entity.ScenicSpotTicketOrder;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDate;
import java.util.List;

/**
 * 景点门票VO类
 */
@EqualsAndHashCode(callSuper = true)
@Data
public class ScenicSpotTicketOrderVO extends ScenicSpotTicketOrder {
    private String username; // 用户名
    private String avatar; // 用户头像
    private String detail; // 门票备注
    private LocalDate startDate; // 门票有效期开始日期
    private LocalDate endDate; // 门票有效期结束日期
    private List<OrderRefundInfo> orderRefundInfoList; // 退款申请
}
