package com.kmbeast.pojo.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * 景点门票订单退款申请信息实体
 */
@Data
@TableName(value = "order_refund_info")
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class OrderRefundInfo {

    /**
     * 主键ID
     */
    @TableId(type = IdType.AUTO)
    private Integer id;

    /**
     * 景点门票订单ID，外键，关联的是景点门票订单信息表
     */
    private Integer ticketOrderId;

    /**
     * 退款状态（1：申请中；2：已退款；3：拒绝退款）
     */
    private Integer status;

    /**
     * 拒绝退款原因（只有当拒绝退款时需要填写）
     */
    private String rejectReason;

    /**
     * 退款时间（退款成功时设置）
     */
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime refundTime;

    /**
     * 拒绝退款时间
     */
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime rejectRefundTime;

    /**
     * 申请退款时间
     */
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;
}
