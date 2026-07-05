package com.kmbeast.pojo.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 景点路线节点信息实体类
 * 数据库表：scenic_spot_route_nodes（景点路线节点信息表）
 * 字段类型映射：
 * int(11) → Integer
 * varchar(50)/varchar(100) → String
 */
@Data
@TableName(value = "scenic_spot_route_nodes") // 映射数据库表名
@AllArgsConstructor // 全参构造器
@NoArgsConstructor  // 无参构造器
@Builder           // 建造者模式，支持链式创建对象
public class ScenicSpotRouteNodes {

    /**
     * 景点路线节点信息表主键，自增
     * 对应字段：id int(11) NOT NULL AUTO_INCREMENT
     * 注释：景点路线节点信息表主键，自增
     */
    @TableId(type = IdType.AUTO) // 主键策略：自增（匹配数据库AUTO_INCREMENT）
    private Integer id;

    /**
     * 景点路线ID，外键关联景点路线信息表
     * 对应字段：scenic_spot_route_id int(11) DEFAULT NULL
     * 注释：景点路线ID，外键，关联的是景点路线表
     */
    private Integer scenicSpotRouteId; // MyBatis-Plus默认下划线转驼峰，匹配scenic_spot_route_id

    /**
     * 节点类型（如"起点节点、核心景观、休整点、终点节点"）
     * 对应字段：type varchar(50) COLLATE utf8mb4_bin DEFAULT NULL
     * 注释：节点类型
     */
    private String type;

    /**
     * 停留时长（如"10分钟、30分钟"）
     * 对应字段：times varchar(50) COLLATE utf8mb4_bin DEFAULT NULL
     * 注释：停留时长
     */
    private String times;

    /**
     * 节点看点（如"红门牌坊、孔子登临处碑刻、关帝庙"）
     * 对应字段：focus_desc varchar(100) COLLATE utf8mb4_bin DEFAULT NULL
     * 注释：看点
     */
    private String focusDesc; // 下划线转驼峰，匹配focus_desc

    /**
     * 节点序号（用于路线节点的展示排序）
     * 对应字段：order_number int(11) DEFAULT NULL
     * 注释：序号
     */
    private Integer orderNumber; // 下划线转驼峰，匹配order_number
}