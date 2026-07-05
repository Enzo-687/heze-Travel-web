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
 * 轮播图实体
 * int tinyint bigint double decimal date datetime varchar
 * Integer Boolean Long Double BigDecimal LocalDate LocalDateTime String
 */
@Data
@TableName(value = "carousel")
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Carousel {

    /**
     * 主键ID
     */
    @TableId(type = IdType.AUTO)
    private Integer id;
    /**
     * 景点ID，外键，关联的是景点信息表
     */
    private Integer scenicSpotId;
    /**
     * 推荐图URL
     */
    private String coverUrl;
    /**
     * 标题
     */
    private String title;
    /**
     * 推荐语
     */
    private String recommendDetail;
    /**
     * 创建时间
     */
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;
}
