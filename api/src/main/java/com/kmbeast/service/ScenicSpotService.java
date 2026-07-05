package com.kmbeast.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.kmbeast.pojo.dto.ScenicSpotQueryDTO;
import com.kmbeast.pojo.dto.ScenicSpotSaveDTO;
import com.kmbeast.pojo.dto.ScenicSpotUpdateDTO;
import com.kmbeast.pojo.entity.ScenicSpot;
import com.kmbeast.pojo.vo.ScenicSpotListVO;
import com.kmbeast.pojo.vo.ScenicSpotVO;

import java.util.List;

/**
 * 景点业务逻辑接口
 */
public interface ScenicSpotService extends IService<ScenicSpot> {

    void addScenicSpot(ScenicSpotSaveDTO scenicSpotSaveDTO);

    void updateScenicSpot(ScenicSpotUpdateDTO scenicSpotUpdateDTO);

    void delScenicSpot(Integer id);

    List<ScenicSpotListVO> listPage(ScenicSpotQueryDTO scenicSpotQueryDTO);

    Integer listPageCount(ScenicSpotQueryDTO scenicSpotQueryDTO);

    ScenicSpotVO detail(Integer id);

    List<ScenicSpotListVO> collection(ScenicSpotQueryDTO scenicSpotQueryDTO);

    List<ScenicSpotListVO> recommend(Integer count);

}
