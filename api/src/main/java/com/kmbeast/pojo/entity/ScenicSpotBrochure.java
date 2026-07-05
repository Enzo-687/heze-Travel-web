package com.kmbeast.pojo.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 景点图册信息实体类
 * 数据库表：scenic_spot_brochure（景点图册信息表）
 * 字段类型映射：
 * int(11) → Integer
 * varchar(200) → String
 */
@Data
@TableName(value = "scenic_spot_brochure") // 映射数据库表名
@AllArgsConstructor // 全参构造器
@NoArgsConstructor  // 无参构造器
@Builder           // 建造者模式，支持链式创建对象
public class ScenicSpotBrochure {

    /**
     * 景点图册信息表ID，主键自增
     * 对应字段：id int(11) NOT NULL AUTO_INCREMENT
     * 注释：景点图册信息表ID，主键自增
     */
    @TableId(type = IdType.AUTO) // 主键策略：自增（匹配数据库AUTO_INCREMENT）
    private Integer id;

    /**
     * 景点ID，外键关联景点信息表
     * 对应字段：scenic_spot_id int(11) DEFAULT NULL
     * 注释：景点ID，外键，关联的是景点信息表
     */
    private Integer scenicSpotId; // MyBatis-Plus默认下划线转驼峰，匹配scenic_spot_id

    /**
     * 图片URL地址
     * 对应字段：cover_url varchar(200) COLLATE utf8mb4_bin DEFAULT NULL
     * 注释：图片URL地址
     */
    private String coverUrl; // 下划线转驼峰，匹配cover_url

    /**
     * 排序序号（用于图册图片的展示排序）
     * 对应字段：order_number int(11) DEFAULT NULL
     * 注释：排序序号
     */
    private Integer orderNumber; // 下划线转驼峰，匹配order_number
}