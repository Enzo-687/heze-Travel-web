package com.kmbeast.pojo.vo;

import com.kmbeast.pojo.entity.ScenicSpotStrategy;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 景点攻略VO类
 */
@EqualsAndHashCode(callSuper = true)
@Data
public class ScenicSpotStrategyDetailVO extends ScenicSpotStrategy {
    /**
     * 景点名
     */
    private String scenicSpotTitle;
    /**
     * 发布者头像
     */
    private String avatar;
    /**
     * 发布者用户名
     */
    private String username;
    /**
     * 阅读量
     */
    private Integer viewCount;
    /**
     * 点赞量
     */
    private Integer upvoteCount;
    /**
     * 收藏量
     */
    private Integer collectionCount;
}
