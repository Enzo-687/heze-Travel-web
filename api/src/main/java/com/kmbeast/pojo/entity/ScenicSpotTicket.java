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
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 景点门票信息实体类
 * 数据库表：scenic_spot_ticket（景点门票信息表）
 * 字段类型映射：
 * int(11) → Integer
 * decimal(10,2) → BigDecimal
 * varchar(200) → String
 * date → LocalDate
 * datetime → LocalDateTime
 * tinyint(1) → Integer（多状态场景适配）
 */
@Data
@TableName(value = "scenic_spot_ticket") // 映射数据库表名
@AllArgsConstructor // 全参构造器
@NoArgsConstructor  // 无参构造器
@Builder           // 建造者模式，支持链式创建对象
public class ScenicSpotTicket {

    /**
     * 景点门票表主键ID，自增
     * 对应字段：id int(11) NOT NULL AUTO_INCREMENT
     * 注释：景点门票表主键ID，自增
     */
    @TableId(type = IdType.AUTO) // 主键策略：自增（匹配数据库AUTO_INCREMENT）
    private Integer id;

    /**
     * 景点ID，外键关联景点信息表
     * 对应字段：scenic_id int(11) DEFAULT NULL
     * 注释：景点ID，外键，关联的是景点信息表
     */
    private Integer scenicId;

    private String title;

    private Integer totalNumber;

    /**
     * 门票价格（精度10位，小数2位）
     * 对应字段：price decimal(10,2) DEFAULT NULL
     * 注释：价格
     */
    private BigDecimal price;

    private String discountDesc;

    private String purchaseDesc;

    private String detail;

    /**
     * 有效期开始日期
     * 对应字段：start_date date DEFAULT NULL
     * 注释：有效期开始日期
     */
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate startDate; // 下划线转驼峰，匹配start_date

    /**
     * 有效期结束日期
     * 对应字段：end_date date DEFAULT NULL
     * 注释：有效期结束日期
     */
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate endDate; // 下划线转驼峰，匹配end_date

    /**
     * 门票状态（1=暂停预约；2=正常）
     * 对应字段：status tinyint(1) DEFAULT NULL
     * 注释：状态（1-暂停预约；2-正常）
     */
    private Integer status; // 多状态场景用Integer，适配1/2等数值，优于Boolean

    /**
     * 创建时间
     * 对应字段：create_time datetime DEFAULT NULL
     * 注释：创建时间
     */
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime; // 统一使用LocalDateTime，与项目时间类型规范一致
}