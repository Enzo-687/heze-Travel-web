package com.kmbeast.mapper;

import com.kmbeast.pojo.vo.ValuesVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * 仪表盘持久化接口
 */
@Mapper
public interface DashboardMapper {

    List<ValuesVO> staticValues();

    List<ValuesVO> pieValues();


}
