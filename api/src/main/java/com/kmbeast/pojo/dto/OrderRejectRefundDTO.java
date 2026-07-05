package com.kmbeast.pojo.dto;

import lombok.Data;

@Data
public class OrderRejectRefundDTO {
    private Integer ticketOrderId;
    private String rejectReason;
}
