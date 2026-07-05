package com.kmbeast.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.kmbeast.context.LocalThreadHolder;
import com.kmbeast.exception.BusinessException;
import com.kmbeast.mapper.ScenicSpotTicketOrderMapper;
import com.kmbeast.pojo.dto.OrderRejectRefundDTO;
import com.kmbeast.pojo.dto.ScenicSpotTicketOrderQueryDTO;
import com.kmbeast.pojo.entity.OrderRefundInfo;
import com.kmbeast.pojo.entity.ScenicSpotTicket;
import com.kmbeast.pojo.entity.ScenicSpotTicketOrder;
import com.kmbeast.pojo.enums.*;
import com.kmbeast.pojo.vo.ScenicSpotTicketOrderTimerVO;
import com.kmbeast.pojo.vo.ScenicSpotTicketOrderVO;
import com.kmbeast.service.OrderRefundInfoService;
import com.kmbeast.service.ScenicSpotTicketOrderService;
import com.kmbeast.service.ScenicSpotTicketService;
import com.kmbeast.utils.AssertUtils;
import com.kmbeast.utils.RoleValidUtils;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;

import java.math.BigDecimal;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;

/**
 * 景点门票订单业务逻辑接口实现类
 */
@Service
public class ScenicSpotTicketOrderServiceImpl extends ServiceImpl<ScenicSpotTicketOrderMapper, ScenicSpotTicketOrder> implements ScenicSpotTicketOrderService {

    @Resource
    private ScenicSpotTicketService scenicSpotTicketService;
    @Resource
    private OrderRefundInfoService orderRefundInfoService;

    private void validParams(ScenicSpotTicketOrder scenicSpotTicketOrder) {
        // 本身的基本信息校验
        AssertUtils.notNull(scenicSpotTicketOrder, "参数不为空");
        AssertUtils.notNull(scenicSpotTicketOrder.getScenicSpotTicketId(), "请设置景点门票ID");
        AssertUtils.notNull(scenicSpotTicketOrder.getBuyNumber(), "请补充购买数量");
        AssertUtils.hasText(scenicSpotTicketOrder.getConcatUsername(), "请补充联系人");
        AssertUtils.hasText(scenicSpotTicketOrder.getConcatPhone(), "请补充联系电话");
        AssertUtils.hasText(scenicSpotTicketOrder.getIdcard(), "请补充身份证");
    }

    /**
     * 设置默认值
     *
     * @param scenicSpotTicketOrder 景点门票订单
     * @param price                 门票单价
     */
    private void orderDefaultVal(ScenicSpotTicketOrder scenicSpotTicketOrder,
                                 BigDecimal price) {
        // 设置用户ID
        scenicSpotTicketOrder.setUserId(LocalThreadHolder.getUserId());
        // 创建时间
        scenicSpotTicketOrder.setCreateTime(LocalDateTime.now());
        // 设置价格
        scenicSpotTicketOrder.setPrice(
                price.multiply(BigDecimal.valueOf(scenicSpotTicketOrder.getBuyNumber()))
        );
        // 设置订单初始状态
        scenicSpotTicketOrder.setStatus(TicketOrderStatusEnum.AWAITING_PAYMENT.getStatus());
    }

    /**
     * 扣除景点门票库存
     *
     * @param id                主键ID
     * @param originStockNumber 原始库存
     * @param deductStockNumber 扣除数量
     */
    private void deductTicketStock(Integer id,
                                   Integer originStockNumber,
                                   Integer deductStockNumber) {
        ScenicSpotTicket spotTicket = ScenicSpotTicket.builder()
                .id(id)
                .totalNumber(originStockNumber - deductStockNumber)
                .build();
        scenicSpotTicketService.updateById(spotTicket);
    }

    /**
     * 创建景点门票订单
     *
     * @param scenicSpotTicketOrder 景点门票订单信息
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void addScenicSpotTicketOrder(ScenicSpotTicketOrder scenicSpotTicketOrder) {
        validParams(scenicSpotTicketOrder);
        // 通过景点门票ID查询景点门票
        ScenicSpotTicket scenicSpotTicket = scenicSpotTicketService.getById(scenicSpotTicketOrder.getScenicSpotTicketId());
        AssertUtils.notNull(scenicSpotTicket, "查询景点门票信息异常");
        // 门票库存检查
        AssertUtils.isTrue(scenicSpotTicket.getTotalNumber() - scenicSpotTicketOrder.getBuyNumber() >= 0, "景点门票库存不足，稍后再试");
        // 门票有效期校验
        LocalDate nowDate = LocalDate.now();
        AssertUtils.isTrue(
                nowDate.isBefore(scenicSpotTicket.getEndDate()),
                "门票已失效，无法创建箱单。门票有效期起始：" + scenicSpotTicket.getStartDate() + "-" + scenicSpotTicket.getEndDate()
        );
        // 门票状态校验
        AssertUtils.isTrue(
                !TicketStatusEnum.STOP.getStatus().equals(
                        scenicSpotTicket.getStatus()
                ),
                "门票已暂停预约，请稍后再试"
        );
        // 设置初始值
        orderDefaultVal(scenicSpotTicketOrder, scenicSpotTicket.getPrice());
        // 创建订单
        save(scenicSpotTicketOrder);
        // 门票库存的扣除
        deductTicketStock(
                scenicSpotTicket.getId(),
                scenicSpotTicket.getTotalNumber(),
                scenicSpotTicketOrder.getBuyNumber()
        );
    }

    /**
     * 景点门票订单修改
     *
     * @param scenicSpotTicketOrder 景点门票订单实体
     */
    @Override
    public void updateScenicSpotTicketOrder(ScenicSpotTicketOrder scenicSpotTicketOrder) {
        AssertUtils.notNull(scenicSpotTicketOrder, "参数不为空");
        AssertUtils.notNull(scenicSpotTicketOrder.getId(), "请设置主键ID");
        // 修改订单数据 - 用户只能修改自己名下的
        update(
                scenicSpotTicketOrder,
                new LambdaUpdateWrapper<ScenicSpotTicketOrder>()
                        .eq(ScenicSpotTicketOrder::getId, scenicSpotTicketOrder.getId())
                        .eq(ScenicSpotTicketOrder::getUserId, LocalThreadHolder.getUserId())
        );
    }

    /**
     * 删除景点门票订单
     *
     * @param id 主键ID
     */
    @Override
    public void delScenicSpotTicketOrder(Integer id) {
        AssertUtils.notNull(id, "主键ID不为空");
        if (RoleEnum.USER.getRole().equals(LocalThreadHolder.getRoleId())) {
            remove(
                    new LambdaUpdateWrapper<ScenicSpotTicketOrder>()
                            .eq(ScenicSpotTicketOrder::getId, id)
                            .eq(ScenicSpotTicketOrder::getUserId, LocalThreadHolder.getUserId())
            );
            return;
        }
        if (RoleEnum.ADMIN.getRole().equals(LocalThreadHolder.getRoleId())) {
            removeById(id);
        }
    }

    /**
     * 通过门票ID，删除门票订单信息
     *
     * @param ticketId 门票ID
     */
    @Override
    public void delScenicSpotTicketOrderByTicketId(Integer ticketId) {
        AssertUtils.notNull(ticketId, "主键ID不为空");
        remove(
                new LambdaUpdateWrapper<ScenicSpotTicketOrder>()
                        .eq(ScenicSpotTicketOrder::getScenicSpotTicketId, ticketId)
        );
    }

    /**
     * 通过门票ID列表，删除门票订单信息
     *
     * @param ticketIds 门票ID列表
     */
    @Override
    public void removeByTicketIds(List<Integer> ticketIds) {
        if (CollectionUtils.isEmpty(ticketIds)) {
            return;
        }
        this.baseMapper.removeByTicketIds(ticketIds);
    }

    /**
     * 查询景点门票数据
     *
     * @param scenicSpotTicketOrderQueryDTO 查询条件类
     * @return List<ScenicSpotTicketOrderVO>
     */
    @Override
    public List<ScenicSpotTicketOrderVO> queryPage(ScenicSpotTicketOrderQueryDTO scenicSpotTicketOrderQueryDTO) {
        validateUserRole(scenicSpotTicketOrderQueryDTO);
        setRefundStatus(scenicSpotTicketOrderQueryDTO);
        return this.baseMapper.queryPage(scenicSpotTicketOrderQueryDTO);
    }

    /**
     * 对于“退款态”查询条件的处理
     * 订单状态（1-4）：待付款、已核销、待使用、已取消 - 不做处理
     * 退款状态（1-3）：申请中、已退款、拒绝退款
     * 查询状态（1-7）：1-4是订单状态（原始进xml），5-7是退款相关状态（状态映射）
     *
     * @param scenicSpotTicketOrderQueryDTO 查询条件类
     */
    private void setRefundStatus(ScenicSpotTicketOrderQueryDTO scenicSpotTicketOrderQueryDTO) {
        if (Objects.nonNull(scenicSpotTicketOrderQueryDTO.getStatus())) {
            // 退款中状态
            if (scenicSpotTicketOrderQueryDTO.getStatus().equals(
                    OrderRefundQueryStatusEnum.REFUNDING.getStatus()
            )) {
                scenicSpotTicketOrderQueryDTO.setStatus(null);
                scenicSpotTicketOrderQueryDTO.setRefundStatus(
                        OrderRefundStatusEnum.REFUNDING.getStatus()
                );
            } else if (scenicSpotTicketOrderQueryDTO.getStatus().equals(
                    OrderRefundQueryStatusEnum.REFUNDED.getStatus()
            )) { // 已退款状态
                scenicSpotTicketOrderQueryDTO.setStatus(null);
                scenicSpotTicketOrderQueryDTO.setRefundStatus(
                        OrderRefundStatusEnum.REFUNDED.getStatus()
                );
            } else if (scenicSpotTicketOrderQueryDTO.getStatus().equals(
                    OrderRefundQueryStatusEnum.REJECT_REFUND.getStatus()
            )) { // 拒绝退款状态
                scenicSpotTicketOrderQueryDTO.setStatus(null);
                scenicSpotTicketOrderQueryDTO.setRefundStatus(
                        OrderRefundStatusEnum.REJECT_REFUND.getStatus()
                );
            } else { // 订单状态，不需要处理原始的查询状态
                scenicSpotTicketOrderQueryDTO.setRefundStatus(null);
            }
        }

    }

    /**
     * 查询景点门票数量
     *
     * @param scenicSpotTicketOrderQueryDTO 查询条件类
     * @return List<ScenicSpotTicketOrderVO>
     */
    @Override
    public Integer queryPageCount(ScenicSpotTicketOrderQueryDTO scenicSpotTicketOrderQueryDTO) {
        validateUserRole(scenicSpotTicketOrderQueryDTO);
        return this.baseMapper.queryPageCount(scenicSpotTicketOrderQueryDTO);
    }

    /**
     * 如果是用户查询，设置上用户ID，做权限隔离，即用户只能查询自己的；
     * 管理员查询无限制
     *
     * @param scenicSpotTicketOrderQueryDTO 查询条件类
     */
    private void validateUserRole(ScenicSpotTicketOrderQueryDTO scenicSpotTicketOrderQueryDTO) {
        if (RoleEnum.USER.getRole().equals(LocalThreadHolder.getRoleId())) {
            scenicSpotTicketOrderQueryDTO.setUserId(LocalThreadHolder.getUserId());
        }
    }

    /**
     * 查询待付款的订单
     *
     * @param status 订单状态
     * @return List<ScenicSpotTicketOrderTimerVO>
     */
    @Override
    public List<ScenicSpotTicketOrderTimerVO> getOrdersByStatus(Integer status) {
        AssertUtils.notNull(status, "状态不为空");
        return this.baseMapper.getOrdersByStatus(status);
    }

    @Override
    public void batchUpdateStatus(List<Integer> ticketOrderIds, Integer status, LocalDateTime time) {
        AssertUtils.notNull(ticketOrderIds, "订单ID列表不为空");
        AssertUtils.notNull(status, "状态不为空");
        this.baseMapper.batchUpdateStatus(ticketOrderIds, status, time);
    }

    /**
     * 变更订单状态
     *
     * @param id          订单ID
     * @param methodsType 操作
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void status(Integer id, String methodsType) {
        AssertUtils.notNull(id, "订单ID列表不为空");
        AssertUtils.hasText(methodsType, "操作不为空不为空");
        // 订单支付行为
        if (methodsType.equals(OrderOperationStateEnum.PAY.getDescription())) {
            // 支付 - 订单处在待付款状态、门票有效期问题
            payOrder(id);
        } else if (methodsType.equals(OrderOperationStateEnum.REFUND.getDescription())) { // 退款行为
            // 退款 - 订单处在待使用且无退款中申请，可提交
            refundReply(id);
        } else if (methodsType.equals(OrderOperationStateEnum.CANCEL.getDescription())) { // 取消订单
            // 取消订单 - 订单处在待支付状态，可取消（15分钟默认时间）
            cancelOrders(id);
        } else if (methodsType.equals(OrderOperationStateEnum.REMOVE.getDescription())) { // 删除订单
            // 删除订单 - 订单处在待支付或已取消时，可删除
            removeOrders(id);
        } else if (methodsType.equals(OrderOperationStateEnum.USE.getDescription())) { // 删除订单
            // 核验 - 订单处在待使用时，可核验
            useOrders(id);
        } else if (methodsType.equals(OrderOperationStateEnum.AGREE.getDescription())) { // 删除订单
            agreeOrderRefund(id);
        }
    }

    /**
     * 订单拒绝退款
     *
     * @param orderRejectRefundDTO 接收参数
     */
    @Override
    public void rejectRefund(OrderRejectRefundDTO orderRejectRefundDTO) {
        AssertUtils.notNull(orderRejectRefundDTO,"参数不为空");
        AssertUtils.notNull(orderRejectRefundDTO.getTicketOrderId(),"门票订单ID不为空");
        // 通过订单ID，查询退款记录
        List<OrderRefundInfo> orderRefundInfos = orderRefundInfoService.list(
                new LambdaQueryWrapper<OrderRefundInfo>()
                        .eq(OrderRefundInfo::getTicketOrderId, orderRejectRefundDTO.getTicketOrderId())
                        .orderByDesc(OrderRefundInfo::getCreateTime)
        );
        if (CollectionUtils.isEmpty(orderRefundInfos)) {
            return;
        }
        // 获取最新一条的退款申请记录（因为通过orderByDesc：createTime降序）
        OrderRefundInfo orderRefundInfo = orderRefundInfos.stream()
                .findFirst()
                .orElse(null);
        orderRefundInfo.setStatus(OrderRefundStatusEnum.REJECT_REFUND.getStatus()); // 设置为拒绝退款
        orderRefundInfo.setRejectRefundTime(LocalDateTime.now()); // 设置拒绝退款时间
        orderRefundInfo.setRejectReason(orderRejectRefundDTO.getRejectReason()); // 设置拒绝缘由
        orderRefundInfoService.updateById(orderRefundInfo);

    }

    /**
     * 订单同意退款
     *
     * @param id 订单ID
     */
    private void agreeOrderRefund(Integer id) {
        RoleValidUtils.requestedAdmin("无操作权限");
        // 查询订单信息
        ScenicSpotTicketOrder ticketOrder = getById(id);
        AssertUtils.notNull(ticketOrder, "订单查询异常");
        // 通过订单ID，查询退款记录
        List<OrderRefundInfo> orderRefundInfos = orderRefundInfoService.list(
                new LambdaQueryWrapper<OrderRefundInfo>()
                        .eq(OrderRefundInfo::getTicketOrderId, ticketOrder.getId())
                        .orderByDesc(OrderRefundInfo::getCreateTime)
        );
        if (CollectionUtils.isEmpty(orderRefundInfos)) {
            return;
        }
        // 获取最新一条的退款申请记录（因为通过orderByDesc：createTime降序）
        OrderRefundInfo refundInfosLast = orderRefundInfos.stream()
                .findFirst()
                .orElse(null);
        refundInfosLast.setStatus(OrderRefundStatusEnum.REFUNDED.getStatus()); // 设置成已退款状态
        refundInfosLast.setRefundTime(LocalDateTime.now()); // 设置退款时间
        orderRefundInfoService.updateById(refundInfosLast);
    }

    /**
     * 门票核验
     * 由待使用状态 -> 已核验状态
     *
     * @param id 订单ID
     */
    private void useOrders(Integer id) {
        RoleValidUtils.requestedAdmin("无操作权限");
        // 查询订单信息
        ScenicSpotTicketOrder ticketOrder = getById(id);
        AssertUtils.notNull(ticketOrder, "订单查询异常");
        // 要求当前订单状态必须是处在待使用
        AssertUtils.isTrue(
                TicketOrderStatusEnum.AWAITING_USE.getStatus().equals(
                        ticketOrder.getStatus()
                ),
                "订单状态异常"
        );
        // 查询门票信息 - （此处校验比较严格：要求当前门票必须处在有效期中，但是一些异常情况，要求管理员即使超出了有效期也要能进行核验。所以这里暂且注释）
//        Integer scenicSpotTicketId = ticketOrder.getScenicSpotTicketId();
//        ScenicSpotTicket scenicSpotTicket = scenicSpotTicketService.getById(scenicSpotTicketId);
//        AssertUtils.notNull(scenicSpotTicket, "订单关联门票查询异常");
//        AssertUtils.isTrue(
//                scenicSpotTicket.getEndDate().isAfter(LocalDate.now()),
//                "门票已过有效期，核验失败"
//        );
        // 状态更改为已核验状态
        ScenicSpotTicketOrder scenicSpotTicketOrder = new ScenicSpotTicketOrder();
        scenicSpotTicketOrder.setId(id);
        scenicSpotTicketOrder.setStatus(TicketOrderStatusEnum.VERIFIED.getStatus()); // 设置为已核验状态
        scenicSpotTicketOrder.setUseTime(LocalDateTime.now()); // 核验时间
        updateById(scenicSpotTicketOrder);
    }

    /**
     * 删除订单
     * 待付款以及已取消状态，可删除
     *
     * @param id 订单ID
     */
    private void removeOrders(Integer id) {
        // 查询订单信息
        ScenicSpotTicketOrder ticketOrder = getById(id);
        AssertUtils.notNull(ticketOrder, "订单查询异常");
        AssertUtils.isTrue(
                TicketOrderStatusEnum.AWAITING_PAYMENT.getStatus().equals(
                        ticketOrder.getStatus()
                ) || TicketOrderStatusEnum.CANCEL.getStatus().equals(
                        ticketOrder.getStatus()
                ),
                "当前订单状态不允许删除"
        );
        // 如果是带付款状态，需要还库存
        if (TicketOrderStatusEnum.AWAITING_PAYMENT.getStatus().equals(
                ticketOrder.getStatus()
        )) {
            Integer scenicSpotTicketId = ticketOrder.getScenicSpotTicketId();
            ScenicSpotTicket scenicSpotTicket = scenicSpotTicketService.getById(scenicSpotTicketId);
            AssertUtils.notNull(scenicSpotTicket, "订单关联门票查询异常");
            // 修改景点门票数量
            ScenicSpotTicket scenicSpotTicketUpdateEntity = new ScenicSpotTicket();
            scenicSpotTicketUpdateEntity.setId(scenicSpotTicketId);
            scenicSpotTicketUpdateEntity.setTotalNumber(scenicSpotTicket.getTotalNumber() + ticketOrder.getBuyNumber());
            scenicSpotTicketService.updateById(scenicSpotTicketUpdateEntity);
            // 如果是管理员删除
            if (RoleEnum.ADMIN.getRole().equals(LocalThreadHolder.getRoleId())){
                removeById(id);
                return;
            }
            // 删除订单 - 用户删除
            remove(
                    new LambdaUpdateWrapper<ScenicSpotTicketOrder>()
                            .eq(ScenicSpotTicketOrder::getId, id)
                            .eq(ScenicSpotTicketOrder::getUserId, ticketOrder.getUserId())
                            .eq(ScenicSpotTicketOrder::getStatus, TicketOrderStatusEnum.AWAITING_PAYMENT.getStatus())
            );
            return;
        }
        // 如果是已经取消状态，直接删除
        if (TicketOrderStatusEnum.CANCEL.getStatus().equals(
                ticketOrder.getStatus()
        )) {
            // 如果是管理员删除
            if (RoleEnum.ADMIN.getRole().equals(LocalThreadHolder.getRoleId())){
                removeById(id);
                return;
            }
            remove(
                    new LambdaUpdateWrapper<ScenicSpotTicketOrder>()
                            .eq(ScenicSpotTicketOrder::getId, id)
                            .eq(ScenicSpotTicketOrder::getUserId, ticketOrder.getUserId())
                            .eq(ScenicSpotTicketOrder::getStatus, TicketOrderStatusEnum.CANCEL.getStatus())
            );
        }

    }

    /**
     * 订单退款申请
     *
     * @param id 订单ID
     */
    private void cancelOrders(Integer id) {
        // 查询订单信息
        ScenicSpotTicketOrder ticketOrder = getById(id);
        AssertUtils.notNull(ticketOrder, "订单查询异常");
        // 查询门票信息
        Integer scenicSpotTicketId = ticketOrder.getScenicSpotTicketId();
        ScenicSpotTicket scenicSpotTicket = scenicSpotTicketService.getById(scenicSpotTicketId);
        AssertUtils.notNull(scenicSpotTicket, "订单关联门票查询异常");
        // 1. 修改景点门票数量
        ScenicSpotTicket scenicSpotTicketUpdateEntity = new ScenicSpotTicket();
        scenicSpotTicketUpdateEntity.setId(scenicSpotTicketId);
        scenicSpotTicketUpdateEntity.setTotalNumber(scenicSpotTicket.getTotalNumber() + ticketOrder.getBuyNumber());
        scenicSpotTicketService.updateById(scenicSpotTicketUpdateEntity);
        // 2. 修改景点门票订单的状态 - 取消状态
        ScenicSpotTicketOrder scenicSpotTicketOrder = new ScenicSpotTicketOrder();
        scenicSpotTicketOrder.setId(id);
        scenicSpotTicketOrder.setStatus(TicketOrderStatusEnum.CANCEL.getStatus()); // 订单状态变为“已取消”
        scenicSpotTicketOrder.setCancelTime(LocalDateTime.now()); // 设置取消时间
        updateById(scenicSpotTicketOrder);
    }


    /**
     * 订单退款申请
     *
     * @param id 订单ID
     */
    private void refundReply(Integer id) {
        ScenicSpotTicketOrder ticketOrder = getById(id);
        AssertUtils.notNull(ticketOrder, "订单查询异常");
        // 校验当前名下是不是存在未审核的退款审核
        List<OrderRefundInfo> orderRefundInfos = orderRefundInfoService.list(
                new LambdaQueryWrapper<OrderRefundInfo>()
                        .eq(OrderRefundInfo::getTicketOrderId, ticketOrder.getId())
        );
        if (!CollectionUtils.isEmpty(orderRefundInfos)) {
            for (OrderRefundInfo orderRefundInfo : orderRefundInfos) {
                AssertUtils.isTrue(!OrderRefundStatusEnum.REFUNDING.getStatus().equals(orderRefundInfo.getStatus()), "您的退款申请正在审核中，请耐心等待");
            }
        }
        // 新增退款申请 - 等待审核
        OrderRefundInfo orderRefundInfo = new OrderRefundInfo();
        orderRefundInfo.setTicketOrderId(id);
        orderRefundInfo.setCreateTime(LocalDateTime.now());
        orderRefundInfo.setStatus(OrderRefundStatusEnum.REFUNDING.getStatus());
        orderRefundInfoService.save(orderRefundInfo);
    }

    /**
     * 订单支付
     * 校验：订单处在待付款状态、门票有效期问题
     *
     * @param id 订单ID
     */
    private void payOrder(Integer id) {
        // 查询订单数据
        ScenicSpotTicketOrder ticketOrder = getById(id);
        AssertUtils.notNull(ticketOrder, "订单查询异常");
        Integer scenicSpotTicketId = ticketOrder.getScenicSpotTicketId();
        ScenicSpotTicket scenicSpotTicket = scenicSpotTicketService.getById(scenicSpotTicketId);
        AssertUtils.notNull(scenicSpotTicket, "订单关联门票查询异常");

        // 订单要求处在待付款状态
        // 获取订单创建时间
        LocalDateTime orderCreateTime = ticketOrder.getCreateTime();
        // 获取当前系统时间
        LocalDateTime currentTime = LocalDateTime.now();
        // 计算订单创建时间与当前时间的时间差
        Duration duration = Duration.between(orderCreateTime, currentTime);
        // 转换时间差为分钟数（向下取整）
        long minutesDiff = duration.toMinutes();
        // 订单超过15分钟未付款 - 已超时
        if (minutesDiff > 15) {
            ScenicSpotTicketOrder scenicSpotTicketOrder = new ScenicSpotTicketOrder();
            scenicSpotTicketOrder.setId(id);
            scenicSpotTicketOrder.setStatus(TicketOrderStatusEnum.CANCEL.getStatus()); // 设置为已取消状态
            scenicSpotTicketOrder.setCancelTime(LocalDateTime.now()); // 设置取消时间
            updateById(scenicSpotTicketOrder);
            throw new BusinessException("订单已超时，请重新下单");
        }

        // 门票有效期
        LocalDate endDate = scenicSpotTicket.getEndDate();
        LocalDate nowDate = LocalDate.now();

        if (nowDate.isAfter(endDate)) {
            ScenicSpotTicketOrder scenicSpotTicketOrder = new ScenicSpotTicketOrder();
            scenicSpotTicketOrder.setId(id);
            scenicSpotTicketOrder.setStatus(TicketOrderStatusEnum.CANCEL.getStatus()); // 设置为已取消状态
            scenicSpotTicketOrder.setCancelTime(LocalDateTime.now()); // 设置取消时间
            updateById(scenicSpotTicketOrder);
            throw new BusinessException("门票有效期已过,下单异常");
        }

        ScenicSpotTicketOrder scenicSpotTicketOrder = new ScenicSpotTicketOrder();
        scenicSpotTicketOrder.setId(id);
        scenicSpotTicketOrder.setStatus(TicketOrderStatusEnum.AWAITING_USE.getStatus()); // 设置为已使用状态
        scenicSpotTicketOrder.setPayTime(LocalDateTime.now()); // 设置支付时间
        updateById(scenicSpotTicketOrder);

    }

}

