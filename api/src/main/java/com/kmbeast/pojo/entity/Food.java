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

@Data
@TableName(value = "food")
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Food {

    @TableId(type = IdType.AUTO)
    private Integer id;

    private String name;

    private String coverUrl;

    private String description;

    private String tag;

    private String detail;

    private Double longitude;

    private Double latitude;

    private String address;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;
}
