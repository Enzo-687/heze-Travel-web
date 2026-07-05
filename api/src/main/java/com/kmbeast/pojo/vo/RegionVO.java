package com.kmbeast.pojo.vo;

import com.kmbeast.pojo.entity.Region;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 地区VO类
 */
@EqualsAndHashCode(callSuper = true)
@Data
public class RegionVO extends Region {

    /**
     * 其下是否有子地区标识
     */
    private Boolean hasChildren;

}