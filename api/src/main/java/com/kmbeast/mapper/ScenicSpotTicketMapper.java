package com.kmbeast.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.kmbeast.pojo.dto.ScenicSpotTicketQueryDTO;
import com.kmbeast.pojo.entity.ScenicSpotTicket;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 景点门票持久化接口
 */
@Mapper
public interface ScenicSpotTicketMapper extends BaseMapper<ScenicSpotTicket> {

    List<ScenicSpotTicket> queryPage(ScenicSpotTicketQueryDTO scenicSpotTicketQueryDTO);

    Integer queryPageCount(ScenicSpotTicketQueryDTO scenicSpotTicketQueryDTO);

    /**
     * 通过景点门票ID删除关联的景点门票订单
     *
     * @param ticketId 景点门票ID
     */
    void removeTicketOrdersByTicketId(@Param(value = "ticketId") Integer ticketId);

    /**
     * 通过景点门票ID列表删除关联的景点门票订单
     *
     * @param ticketIds 景点门票ID列表
     */
    void removeTicketOrdersByTicketIds(@Param(value = "ticketIds") List<Integer> ticketIds);

    void batchUpdateStore(List<ScenicSpotTicket> spotTickets);


}
