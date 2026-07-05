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
 * 景点信息实体类
 * 数据库表：scenic_spot（景点信息表）
 * 字段类型映射：
 * int(11) → Integer
 * varchar(100)/varchar(200) → String
 * text → String
 * datetime → LocalDateTime
 */
@Data
@TableName(value = "scenic_spot") // 映射数据库表名
@AllArgsConstructor // 全参构造器
@NoArgsConstructor  // 无参构造器
@Builder           // 建造者模式，支持链式创建对象
public class ScenicSpot {

    /**
     * 景点ID，主键自增
     * 对应字段：id int(11) NOT NULL AUTO_INCREMENT
     * 注释：景点ID，主键自增
     */
    @TableId(type = IdType.AUTO) // 主键策略：自增（匹配数据库AUTO_INCREMENT）
    private Integer id;

    /**
     * 地区ID，外键关联地区信息表
     * 对应字段：region_id int(11) DEFAULT NULL
     * 注释：地区ID，外键，关联的是地区信息表
     */
    private Integer regionId; // MyBatis-Plus默认下划线转驼峰，匹配region_id

    /**
     * 景点标题
     * 对应字段：title varchar(100) COLLATE utf8mb4_bin DEFAULT NULL
     * 注释：标题
     */
    private String title;

    /**
     * 景点封面URL
     * 对应字段：cover varchar(200) COLLATE utf8mb4_bin DEFAULT NULL
     * 注释：封面
     */
    private String cover;

    /**
     * 景点详情内容
     * 对应字段：content text COLLATE utf8mb4_bin
     * 注释：内容
     */
    private String content;

    /**
     * 景点摘要
     * 对应字段：summary varchar(200) COLLATE utf8mb4_bin DEFAULT NULL
     * 注释：摘要
     */
    private String summary;

    /**
     * 创建时间
     * 对应字段：create_time datetime DEFAULT NULL
     * 注释：创建时间
     */
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime; // 匹配数据库datetime类型，统一使用LocalDateTime
}