package com.kmbeast.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.kmbeast.pojo.dto.ScenicSpotQueryDTO;
import com.kmbeast.pojo.entity.ScenicSpot;
import com.kmbeast.pojo.vo.ScenicSpotListVO;
import com.kmbeast.pojo.vo.ScenicSpotVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * 景点持久化接口
 */
@Mapper
public interface ScenicSpotMapper extends BaseMapper<ScenicSpot> {

    @Select(value = "SELECT ss.id FROM scenic_spot ss")
    List<Integer> getIds();

    List<ScenicSpotListVO> listPage(ScenicSpotQueryDTO scenicSpotQueryDTO);

    Integer listPageCount(ScenicSpotQueryDTO scenicSpotQueryDTO);

    ScenicSpotVO getDetailById(@Param(value = "id") Integer id);

}
