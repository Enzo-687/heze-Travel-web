package com.kmbeast.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.kmbeast.mapper.ScenicSpotTicketMapper;
import com.kmbeast.pojo.dto.ScenicSpotTicketQueryDTO;
import com.kmbeast.pojo.entity.ScenicSpotTicket;
import com.kmbeast.pojo.enums.TicketStatusEnum;
import com.kmbeast.service.ScenicSpotTicketService;
import com.kmbeast.utils.AssertUtils;
import com.kmbeast.utils.RoleValidUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 景点门票业务逻辑接口实现类
 */
@Service
public class ScenicSpotTicketServiceImpl extends ServiceImpl<ScenicSpotTicketMapper, ScenicSpotTicket> implements ScenicSpotTicketService {

    private void validParams(ScenicSpotTicket scenicSpotTicket) {
        // 本身的基本信息校验
        AssertUtils.notNull(scenicSpotTicket, "参数不为空");
        AssertUtils.notNull(scenicSpotTicket.getScenicId(), "请设置景点ID");
        AssertUtils.notNull(scenicSpotTicket.getTotalNumber(), "请填写实际门票数量");
        AssertUtils.hasText(scenicSpotTicket.getDetail(), "请填写详情");
        AssertUtils.notNull(scenicSpotTicket.getPrice(), "请补充门票价格");
        AssertUtils.notNull(scenicSpotTicket.getStartDate(), "请补充有效期开始时间");
        AssertUtils.notNull(scenicSpotTicket.getEndDate(), "请补充有效期结束时间");
        // 内容本身的限制
        AssertUtils.isTrue(scenicSpotTicket.getDetail().length() < 1000, "备注请控制在1000字以内");
    }

    private void dateRangesValid(ScenicSpotTicket scenicSpotTicket) {
        LocalDate startDate = scenicSpotTicket.getStartDate();
        LocalDate endDate = scenicSpotTicket.getEndDate();
        // 开始日期必须在结束日期前
        AssertUtils.isTrue(
                startDate.isBefore(endDate),
                "开始日期必须在结束日期前"
        );
        // 有效期的开始日期以及结束日期不能在当天日期之前 - 时间已经过去
        LocalDate nowDate = LocalDate.now(); // 获取当天日期
        AssertUtils.isTrue(
                !startDate.isBefore(nowDate),
                "开始日期必须在结束日期前"
        );
    }

    /**
     * 景点门票新增
     *
     * @param scenicSpotTicket 景点门票
     */
    @Override
    public void addScenicSpotTicket(ScenicSpotTicket scenicSpotTicket) {
        RoleValidUtils.requestedAdmin("无操作权限");
        validParams(scenicSpotTicket);
        dateRangesValid(scenicSpotTicket);
        scenicSpotTicket.setCreateTime(LocalDateTime.now());
        scenicSpotTicket.setStatus(TicketStatusEnum.NORMAL.getStatus());
        save(scenicSpotTicket);
    }

    /**
     * 景点门票修改
     *
     * @param scenicSpotTicket 景点门票
     */
    @Override
    public void updateScenicSpotTicket(ScenicSpotTicket scenicSpotTicket) {
        RoleValidUtils.requestedAdmin("无操作权限");
        AssertUtils.notNull(scenicSpotTicket, "参数不为空");
        AssertUtils.notNull(scenicSpotTicket.getId(), "景点ID不为空");
        updateById(scenicSpotTicket);
    }

    /**
     * 景点门票删除
     *
     * @param id 景点门票ID
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void delScenicSpotTicket(Integer id) {
        RoleValidUtils.requestedAdmin("无操作权限");
        AssertUtils.notNull(id, "景点门票ID不为空");
        removeById(id);
        // 删除景点门票关联的景点门票订单信息
        removeTicketOrdersByTicketId(id);
    }

    /**
     * 通过景点门票ID删除其关联的景点门票订单
     *
     * @param ticketId 景点门票ID
     */
    @Override
    public void removeTicketOrdersByTicketId(Integer ticketId) {
        AssertUtils.notNull(ticketId, "景点门票ID不为空");
        this.baseMapper.removeTicketOrdersByTicketId(ticketId);
    }

    /**
     * 通过景点门票ID删除其关联的景点门票订单
     *
     * @param ticketIds 景点门票ID列表
     */
    @Override
    public void removeTicketOrdersByTicketIds(List<Integer> ticketIds) {
        AssertUtils.notEmpty(ticketIds, "景点门票ID不为空");
        this.baseMapper.removeTicketOrdersByTicketIds(ticketIds);
    }

    /**
     * 批量修改景点门票数量
     * @param spotTickets 门票集合
     */
    @Override
    public void batchUpdateStore(List<ScenicSpotTicket> spotTickets) {
        AssertUtils.notNull(spotTickets,"门票列表不为空");
        this.baseMapper.batchUpdateStore(spotTickets);
    }

    /**
     * 删除景点关联的景点门票
     *
     * @param scenicSpotId 景点ID
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void delScenicSpotTicketByScenicSpotId(Integer scenicSpotId) {
        RoleValidUtils.requestedAdmin("无操作权限");
        AssertUtils.notNull(scenicSpotId, "景点ID不为空");
        // 查询景点关联的景点门票的ID列表
        List<ScenicSpotTicket> spotTickets = list(
                new LambdaQueryWrapper<ScenicSpotTicket>()
                        .eq(ScenicSpotTicket::getScenicId, scenicSpotId)
        );
        // 如果景点下无关联门票，直接返回
        if (CollectionUtils.isEmpty(spotTickets)) {
            return;
        }
        // 获取门票ID列表
        List<Integer> ticketIds = spotTickets.stream().map(
                ScenicSpotTicket::getId
        ).toList();
        // 删除景点关联的景点门票信息
        remove(
                new LambdaUpdateWrapper<ScenicSpotTicket>()
                        .eq(ScenicSpotTicket::getScenicId, scenicSpotId)
        );
        // 删除景点门票关联的景点门票订单信息
        removeTicketOrdersByTicketIds(ticketIds);
    }

    /**
     * 查询景点门票信息
     *
     * @param scenicSpotTicketQueryDTO 查询条件类
     * @return List<ScenicSpotTicket>
     */
    @Override
    public List<ScenicSpotTicket> queryPage(ScenicSpotTicketQueryDTO scenicSpotTicketQueryDTO) {
        return this.baseMapper.queryPage(scenicSpotTicketQueryDTO);
    }

    /**
     * 查询景点门票数量
     *
     * @param scenicSpotTicketQueryDTO 查询条件类
     * @return List<ScenicSpotTicket>
     */
    @Override
    public Integer queryPageCount(ScenicSpotTicketQueryDTO scenicSpotTicketQueryDTO) {
        AssertUtils.notNull(scenicSpotTicketQueryDTO, "景点门票查询条件类不为空");
        AssertUtils.notNull(scenicSpotTicketQueryDTO.getScenicSpotId(), "景点ID不为空");
        return this.baseMapper.queryPageCount(scenicSpotTicketQueryDTO);
    }
}
