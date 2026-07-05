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
 * 用户行为操作信息实体类
 * 数据库表：user_action_operation（用户行为操作信息表）
 * 字段类型映射：
 * int(11) → Integer
 * bigint(20) → Long
 * varchar(20) → String
 * tinyint(1) → Integer（多状态场景适配）
 * datetime → LocalDateTime
 */
@Data
@TableName(value = "user_action_operation") // 映射数据库表名
@AllArgsConstructor // 全参构造器
@NoArgsConstructor  // 无参构造器
@Builder           // 建造者模式，支持链式创建对象
public class UserActionOperation {

    /**
     * 用户行为操作信息表主键ID，自增
     * 对应字段：id int(11) NOT NULL AUTO_INCREMENT
     * 注释：用户行为操作信息表主键ID，自增
     */
    @TableId(type = IdType.AUTO) // 主键策略：自增（匹配数据库AUTO_INCREMENT）
    private Integer id;

    /**
     * 用户ID，外键关联用户信息表
     * 对应字段：user_id int(11) DEFAULT NULL
     * 注释：用户ID，外键，关联的是用户信息表
     */
    private Integer userId; // MyBatis-Plus默认下划线转驼峰，匹配user_id

    /**
     * 内容模块（如"景点攻略、景点门票、景点信息"等）
     * 对应字段：content_module varchar(20) COLLATE utf8mb4_bin DEFAULT NULL
     * 注释：内容模块
     */
    private String contentModule; // 下划线转驼峰，匹配content_module

    /**
     * 内容ID（关联对应模块的主键ID，如攻略ID/门票ID/景点ID）
     * 对应字段：content_id int(11) DEFAULT NULL
     * 注释：内容ID
     */
    private Integer contentId; // 下划线转驼峰，匹配content_id

    /**
     * 行为类型（1-收藏；2-点赞；3-浏览；4-停留）
     * 对应字段：type tinyint(1) DEFAULT NULL
     * 注释：行为类型（1-收藏；2-点赞；3-浏览；4-停留）
     */
    private Integer type; // 多状态场景用Integer，适配1/2/3/4等数值

    /**
     * 停留时长（单位：毫秒/秒，行为类型是“停留”时才需设置）
     * 对应字段：stay_time bigint(20) DEFAULT NULL
     * 注释：停留时长（行为类型是“停留”时才需要设置）
     */
    private Long stayTime; // 下划线转驼峰，匹配stay_time（bigint对应Long，避免数值溢出）

    /**
     * 创建时间（行为发生时间）
     * 对应字段：create_time datetime DEFAULT NULL
     * 注释：创建时间
     */
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime; // 统一使用LocalDateTime，与项目时间类型规范一致
}