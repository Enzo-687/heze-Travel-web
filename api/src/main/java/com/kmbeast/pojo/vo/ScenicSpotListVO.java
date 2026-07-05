package com.kmbeast.pojo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 景点列表VO类
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class ScenicSpotListVO {

    /**
     * 景点ID，主键自增
     */
    private Integer id;

    /**
     * 景点标题
     */
    private String title;

    /**
     * 景点封面URL
     */
    private String cover;

    /**
     * 景点摘要
     */
    private String summary;

    /**
     * 县名
     */
    private String countyName;
    private String townName;
    private String villageName;
    private String categoryNames;

}
