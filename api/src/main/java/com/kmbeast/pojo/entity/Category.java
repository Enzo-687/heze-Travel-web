package com.kmbeast.pojo.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 景点类别信息实体类
 * 数据库表：category（景点类别信息表）
 * 字段类型映射：
 * int(11) → Integer
 * varchar(100) → String
 */
@Data
@TableName(value = "category") // 对应数据库表名
@AllArgsConstructor // 全参构造器
@NoArgsConstructor  // 无参构造器
@Builder           // 建造者模式，方便快速构建对象
public class Category {

    /**
     * 主键ID，自增
     * 对应字段：id int(11) NOT NULL AUTO_INCREMENT
     * 注释：景点类别表，主键，自增
     */
    @TableId(type = IdType.AUTO) // 主键策略：自增
    private Integer id;

    /**
     * 类别名称
     * 对应字段：name varchar(100) COLLATE utf8mb4_bin DEFAULT NULL
     * 注释：名称
     */
    private String name;

    /**
     * 层级（如1级、2级分类）
     * 对应字段：level int(2) DEFAULT NULL
     * 注释：层级
     */
    private Integer level;

    /**
     * 父级ID（顶级分类父ID为null/0）
     * 对应字段：parent_id int(11) DEFAULT NULL
     * 注释：父级ID
     */
    private Integer parentId; // 数据库字段为parent_id，MyBatis-Plus默认下划线转驼峰
}