package com.kmbeast.pojo.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 景点路线信息实体类
 * 数据库表：scenic_spot_route_item（景点路线信息表）
 * 字段类型映射：
 * int(11)/int(1) → Integer
 * varchar(50)/varchar(100) → String
 */
@Data
@TableName(value = "scenic_spot_route_item") // 映射数据库表名
@AllArgsConstructor // 全参构造器
@NoArgsConstructor  // 无参构造器
@Builder           // 建造者模式，支持链式创建对象
public class ScenicSpotRouteItem {

    /**
     * 景点路线项主键ID，自增
     * 对应字段：id int(11) NOT NULL AUTO_INCREMENT
     * 注释：景点路线项主键ID，自增
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
     * 路线定位（如"经典徒步朝圣线"、"休闲观光车+索道线"）
     * 对应字段：position_desc varchar(50) COLLATE utf8mb4_bin DEFAULT NULL
     * 注释：路线定位
     */
    private String positionDesc; // 下划线转驼峰，匹配position_desc

    /**
     * 时长（如"约5-6小时（徒步）"、"约2-3小时（观光车+索道）"）
     * 对应字段：times varchar(50) COLLATE utf8mb4_bin DEFAULT NULL
     * 注释：时长
     */
    private String times;

    /**
     * 强度（1-5级）
     * 对应字段：intensity int(1) DEFAULT NULL
     * 注释：强度（1-5级）
     */
    private Integer intensity;

    /**
     * 核心看点（如"历代碑刻、古建筑群、十八盘"）
     * 对应字段：focus_desc varchar(100) COLLATE utf8mb4_bin DEFAULT NULL
     * 注释：核心看点
     */
    private String focusDesc; // 下划线转驼峰，匹配focus_desc
}