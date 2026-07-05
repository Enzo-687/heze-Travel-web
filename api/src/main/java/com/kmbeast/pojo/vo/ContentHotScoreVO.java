package com.kmbeast.pojo.vo;

import lombok.Data;

/**
 * 内容热度值VO
 */
@Data
public class ContentHotScoreVO {
    private Integer contentId; // 内容ID
    private Integer hotScore; // 热度值
}
