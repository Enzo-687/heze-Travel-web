package com.kmbeast.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.kmbeast.pojo.dto.ScenicSpotTicketQueryDTO;
import com.kmbeast.pojo.entity.ScenicSpotTicket;

import java.util.List;

/**
 * 景点门票业务逻辑接口
 */
public interface ScenicSpotTicketService extends IService<ScenicSpotTicket> {

    void addScenicSpotTicket(ScenicSpotTicket scenicSpotTicket);

    void updateScenicSpotTicket(ScenicSpotTicket scenicSpotTicket);

    void delScenicSpotTicket(Integer id);

    void delScenicSpotTicketByScenicSpotId(Integer scenicSpotId);

    List<ScenicSpotTicket> queryPage(ScenicSpotTicketQueryDTO scenicSpotTicketQueryDTO);

    Integer queryPageCount(ScenicSpotTicketQueryDTO scenicSpotTicketQueryDTO);

    void removeTicketOrdersByTicketId(Integer ticketId);

    void removeTicketOrdersByTicketIds(List<Integer> ticketIds);

    void batchUpdateStore(List<ScenicSpotTicket> spotTickets);

}
