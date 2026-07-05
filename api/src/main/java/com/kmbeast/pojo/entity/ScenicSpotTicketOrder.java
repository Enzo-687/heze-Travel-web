package com.kmbeast.pojo.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 景点门票订单实体类
 * 数据库表：scenic_spot_ticket_order（景点门票订单表）
 * 字段类型映射：
 * int(11) → Integer
 * decimal(10,2) → BigDecimal
 * varchar(20)/varchar(100) → String
 * tinyint(1) → Integer（多状态场景适配）
 * datetime → LocalDateTime
 */
@Data
@TableName(value = "scenic_spot_ticket_order") // 映射数据库表名
@AllArgsConstructor // 全参构造器
@NoArgsConstructor  // 无参构造器
@Builder           // 建造者模式，支持链式创建对象
public class ScenicSpotTicketOrder {

    /**
     * 景点门票订单主键ID，自增
     * 对应字段：id int(11) NOT NULL AUTO_INCREMENT
     * 注释：景点门票订单主键ID，自增
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
     * 景点门票ID，外键关联景点门票信息表
     * 对应字段：scenic_spot_ticket_id int(11) DEFAULT NULL
     * 注释：景点门票ID，外键，关联的是景点门票信息表
     */
    private Integer scenicSpotTicketId; // 下划线转驼峰，匹配scenic_spot_ticket_id

    /**
     * 订单状态（1-待付款；2-已核销；3-待使用；4-已取消）
     * 对应字段：status tinyint(1) DEFAULT NULL
     * 注释：订单状态（1-待付款；2-已核销；3-待使用；4-已取消）
     */
    private Integer status; // 多状态场景用Integer，适配1/2/3/4等数值

    /**
     * 购买数量
     * 对应字段：buy_number int(11) DEFAULT NULL
     * 注释：购买数量
     */
    private Integer buyNumber; // 下划线转驼峰，匹配buy_number

    /**
     * 订单价格（精度10位，小数2位）
     * 对应字段：price decimal(10,2) DEFAULT NULL
     * 注释：价格
     */
    private BigDecimal price; // 金额类型统一用BigDecimal，避免浮点精度丢失

    /**
     * 联系人
     * 对应字段：concat_username varchar(20) COLLATE utf8mb4_bin DEFAULT NULL
     * 注释：联系人
     */
    private String concatUsername; // 下划线转驼峰，匹配concat_username

    /**
     * 联系电话
     * 对应字段：concat_phone varchar(20) COLLATE utf8mb4_bin DEFAULT NULL
     * 注释：联系电话
     */
    private String concatPhone; // 下划线转驼峰，匹配concat_phone

    /**
     * 身份证号
     * 对应字段：idcard varchar(100) COLLATE utf8mb4_bin DEFAULT NULL
     * 注释：身份证号
     */
    private String idcard;

    /**
     * 创建时间
     * 对应字段：create_time datetime DEFAULT NULL
     * 注释：创建时间
     */
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime; // 统一使用LocalDateTime，与项目时间类型规范一致

    /**
     * 支付时间
     * 对应字段：pay_time datetime DEFAULT NULL
     * 注释：支付时间
     */
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime payTime; // 下划线转驼峰，匹配pay_time

    /**
     * 核销时间
     * 对应字段：use_time datetime DEFAULT NULL
     * 注释：核销时间
     */
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime useTime; // 下划线转驼峰，匹配use_time

    /**
     * 取消时间
     * 对应字段：cacel_time datetime DEFAULT NULL（数据库字段笔误：cacel → cancel）
     * 注释：取消时间
     */
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime cancelTime;
}