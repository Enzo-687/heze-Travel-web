package com.kmbeast.pojo.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 景点类别中间表实体类（关联景点与类别多对多关系）
 * 数据库表：scenic_spot_category（景点类别中间表）
 * 字段类型映射：
 * int(11) → Integer
 */
@Data
@TableName(value = "scenic_spot_category") // 映射数据库表名
@AllArgsConstructor // 全参构造器
@NoArgsConstructor  // 无参构造器
@Builder           // 建造者模式，支持链式创建对象
public class ScenicSpotCategory {

    /**
     * 主键ID，自增
     * 对应字段：id int(11) NOT NULL AUTO_INCREMENT
     * 注释：景点类别中间表，主键自增
     */
    @TableId(type = IdType.AUTO) // 主键策略：自增（匹配数据库AUTO_INCREMENT）
    private Integer id;

    /**
     * 景点ID（外键关联景点信息表）
     * 对应字段：scenic_spot_id int(11) DEFAULT NULL
     * 注释：景点ID
     */
    private Integer scenicSpotId; // MyBatis-Plus默认下划线转驼峰，匹配scenic_spot_id

    /**
     * 类别ID（外键关联景点类别表）
     * 对应字段：category_id int(11) DEFAULT NULL
     * 注释：类别ID
     */
    private Integer categoryId; // 下划线转驼峰，匹配category_id
}