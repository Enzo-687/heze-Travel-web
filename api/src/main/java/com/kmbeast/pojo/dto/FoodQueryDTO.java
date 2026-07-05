package com.kmbeast.pojo.dto;

import lombok.Data;
import lombok.EqualsAndHashCode;

@EqualsAndHashCode(callSuper = true)
@Data
public class FoodQueryDTO extends QueryDTO {
    private String name;
    private String tag;
}
