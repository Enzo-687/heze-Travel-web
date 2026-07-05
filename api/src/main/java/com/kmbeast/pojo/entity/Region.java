package com.kmbeast.pojo.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 地区信息实体类
 * 数据库表：region（地区信息表）
 * 字段类型映射：
 * int(11) → Integer
 * varchar(100) → String
 */
@Data
@TableName(value = "region") // 映射数据库表名
@AllArgsConstructor // 全参构造器
@NoArgsConstructor // 无参构造器
@Builder // 建造者模式，支持链式创建对象
public class Region {

    /**
     * 主键ID，自增
     * 对应字段：id int(11) NOT NULL AUTO_INCREMENT
     * 注释：地区信息表，主键，自增
     */
    @TableId(type = IdType.AUTO) // 主键策略：自增（匹配数据库AUTO_INCREMENT）
    private Integer id;

    /**
     * 地区名称（如县/乡镇/村）
     * 对应字段：name varchar(100) COLLATE utf8mb4_bin DEFAULT NULL
     * 注释：名称
     */
    private String name;

    /**
     * 层级（1=县、2=乡镇、3=村）
     * 对应字段：level int(2) DEFAULT NULL
     * 注释：层级
     */
    private Integer level;

    /**
     * 父级ID（顶级地区父ID为-1，即县级的parent_id为-1）
     * 对应字段：parent_id int(11) DEFAULT NULL
     * 注释：父级ID
     */
    private Integer parentId; // MyBatis-Plus默认下划线转驼峰，匹配parent_id
}