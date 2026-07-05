package com.kmbeast.pojo.dto;

import com.kmbeast.pojo.entity.ScenicSpot;
import com.kmbeast.pojo.entity.ScenicSpotBrochure;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.List;

/**
 * 景点新增DTO
 */
@EqualsAndHashCode(callSuper = true)
@Data
public class ScenicSpotSaveDTO extends ScenicSpot {

    /**
     * 景点图册列表
     */
    private List<ScenicSpotBrochure> scenicSpotBrochureList;

    /**
     * 景点类别ID列表
     */
    private List<Integer> categoryIds;

}
