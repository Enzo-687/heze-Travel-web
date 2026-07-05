package com.kmbeast.pojo.vo;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 景点攻略列表信息
 */
@Data
public class ScenicSpotStrategyListVO {
    /**
     * 景点攻略ID
     */
    private Integer id;
    /**
     * 封面
     */
    private String cover;
    /**
     * 标题
     */
    private String title;
    /**
     * 摘要
     */
    private String summary;
    /**
     * 发布时间
     */
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDateTime createTime;
    /**
     * 审核状态
     */
    private Boolean auditStatus;
    /**
     * 发布者头像
     */
    private String avatar;
    /**
     * 发布者用户名
     */
    private String username;
}
