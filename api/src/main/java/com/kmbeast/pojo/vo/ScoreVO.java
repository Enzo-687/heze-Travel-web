package com.kmbeast.pojo.vo;

import lombok.Data;

/**
 * 兴趣评分VO
 */
@Data
public class ScoreVO {
    private Integer contentId;
    private Integer userId;
    private Double score;
}
