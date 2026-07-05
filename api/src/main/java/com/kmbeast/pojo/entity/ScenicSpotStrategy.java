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
 * 景点攻略信息实体类
 * 数据库表：scenic_spot_strategy（景点攻略信息表）
 * 字段类型映射：
 * int(11) → Integer
 * tinyint(1) → Boolean（也可保留Integer，根据业务场景选择）
 * varchar(100)/varchar(200) → String
 * text → String
 * datetime → LocalDateTime
 */
@Data
@TableName(value = "scenic_spot_strategy") // 映射数据库表名
@AllArgsConstructor // 全参构造器
@NoArgsConstructor  // 无参构造器
@Builder           // 建造者模式，支持链式创建对象
public class ScenicSpotStrategy {

    /**
     * 景点攻略信息表主键ID，自增
     * 对应字段：id int(11) NOT NULL AUTO_INCREMENT
     * 注释：景点攻略信息表主键ID，自增
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
     * 用户ID，外键关联用户信息表
     * 对应字段：user_id int(11) DEFAULT NULL
     * 注释：用户ID，外键，关联的是用户信息表
     */
    private Integer userId; // 下划线转驼峰，匹配user_id

    /**
     * 攻略标题
     * 对应字段：title varchar(100) COLLATE utf8mb4_bin DEFAULT NULL
     * 注释：标题
     */
    private String title;

    /**
     * 攻略封面URL
     * 对应字段：cover varchar(200) COLLATE utf8mb4_bin DEFAULT NULL
     * 注释：封面
     */
    private String cover;

    /**
     * 攻略摘要（注：数据库字段注释与名称反向，已按业务逻辑修正注释）
     * 对应字段：summary varchar(200) COLLATE utf8mb4_bin DEFAULT NULL
     * 注释：内容（数据库注释笔误，实际应为摘要）
     */
    private String summary;

    /**
     * 攻略详细内容
     * 对应字段：content text COLLATE utf8mb4_bin
     * 注释：摘要（数据库注释笔误，实际应为内容）
     */
    private String content;

    /**
     * 审核状态（0=未审核/1=审核通过）
     * 对应字段：audit_status tinyint(1) DEFAULT NULL
     * 注释：审核状态
     */
    private Boolean auditStatus; // 推荐用Boolean，也可改为Integer（根据业务灵活调整）

    /**
     * 发布时间
     * 对应字段：create_time datetime DEFAULT NULL
     * 注释：发布时间
     */
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime; // 统一使用LocalDateTime，与项目时间类型规范一致
}