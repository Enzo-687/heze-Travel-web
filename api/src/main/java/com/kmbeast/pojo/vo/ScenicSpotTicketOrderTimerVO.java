package com.kmbeast.pojo.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ScenicSpotTicketOrderTimerVO {
    /**
     * 主键ID
     */
    private Integer id;
    /**
     * 门票ID
     */
    private Integer scenicSpotTicketId;
    /**
     * 购买数量
     */
    private Integer buyNumber;
    /**
     * 创建时间
     */
    private LocalDateTime createTime;
}
