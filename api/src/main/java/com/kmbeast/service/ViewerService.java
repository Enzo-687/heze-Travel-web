package com.kmbeast.service;

import com.kmbeast.pojo.api.Result;
import com.kmbeast.pojo.dto.*;
import com.kmbeast.pojo.entity.*;
import com.kmbeast.pojo.vo.*;

import java.util.List;

/**
 * 游客业务逻辑接口
 */
public interface ViewerService {

    /**
     * 游客 - 查询轮播图数据
     *
     * @param carouselQueryDTO 查询条件类
     * @return List<Carousel>
     */
    List<Carousel> carouselQuery(CarouselQueryDTO carouselQueryDTO);

    /**
     * 游客 - 查询轮播图数量
     *
     * @param carouselQueryDTO 查询条件类
     * @return Integer
     */
    Integer carouselQueryCount(CarouselQueryDTO carouselQueryDTO);

    /**
     * 游客 - 通过ID查询景点详情
     *
     * @param id 景点ID
     * @return Integer
     */
    ScenicSpotVO detail(Integer id);

    /**
     * 景点路线项查询
     *
     * @param scenicSpotRouteItemQueryDTO 查询条件类
     * @return Result<List < ScenicSpotRouteItem>> 后台通用返回封装类
     */
    List<ScenicSpotRouteItem> routeItemQuery(ScenicSpotRouteItemQueryDTO scenicSpotRouteItemQueryDTO);

    /**
     * 通过景点路线ID查询景点路线详情
     *
     * @param id 主键ID
     * @return ScenicSpotRouteItem
     */
    ScenicSpotRouteItem routeItemDetail(Integer id);

    /**
     * 景点路线项查询
     *
     * @param id 主键ID
     * @return Result<List < ScenicSpotRouteItem>> 后台通用返回封装类
     */
    List<ScenicSpotRouteNodes> nodesList(Integer id);

    /**
     * 查询景点关联的全部景点攻略
     *
     * @param scenicSpotId 景点ID
     * @return Result<List < ScenicSpotStrategyListVO>> 后台通用返回封装类
     */
    List<ScenicSpotStrategyListVO> strategyByScenicSpotId(Integer scenicSpotId);

    /**
     * 通过景点攻略ID查询详情信息
     *
     * @param id 主键ID
     * @return Result<List < ScenicSpotStrategyListVO>> 后台通用返回封装类
     */
    ScenicSpotStrategyDetailVO strategyDetail(Integer id);

    /**
     * 景点门票查询
     *
     * @param scenicSpotTicketQueryDTO 查询条件类
     * @return Result<List < ScenicSpotTicket>> 后台通用返回封装类
     */
    List<ScenicSpotTicket> ticketsQuery(ScenicSpotTicketQueryDTO scenicSpotTicketQueryDTO);

    /**
     * 查询景点门票数量
     *
     * @param scenicSpotTicketQueryDTO 查询条件类
     * @return Result<List < ScenicSpotTicket>> 后台通用返回封装类
     */
    Integer queryPageCount(ScenicSpotTicketQueryDTO scenicSpotTicketQueryDTO);

    /**
     * 查询内容下的全部评论
     *
     * @param contentId 内容ID
     * @param contentType 内容类型
     * @return Result<String>
     */
    List<CommentParentVO> commentList(Integer contentId, String contentType);

    /**
     * 景点攻略查询
     *
     * @param scenicSpotStrategyQueryDTO 查询条件类
     * @return Result<List < ScenicSpotStrategyListVO>> 后台通用返回封装类
     */
    List<ScenicSpotStrategyListVO> strategyQueryList(ScenicSpotStrategyQueryDTO scenicSpotStrategyQueryDTO);

    /**
     * 查询景点攻略数量
     *
     * @param scenicSpotStrategyQueryDTO 查询条件类
     * @return Result<List < ScenicSpotStrategyListVO>> 后台通用返回封装类
     */
    Integer strategyQueryListCount(ScenicSpotStrategyQueryDTO scenicSpotStrategyQueryDTO);

    /**
     * 查询景点列表
     *
     * @param scenicSpotQueryDTO 查询条件类
     * @return Result<List < ScenicSpotListVO>> 后台通用返回封装类
     */
    List<ScenicSpotListVO> scenicSpotListPage(ScenicSpotQueryDTO scenicSpotQueryDTO);

    /**
     * 查询景点数量
     *
     * @param scenicSpotQueryDTO 查询条件类
     * @return Result<List < ScenicSpotListVO>> 后台通用返回封装类
     */
    Integer scenicSpotListPageCount(ScenicSpotQueryDTO scenicSpotQueryDTO);

    /**
     * 地区查询
     *
     * @param regionQueryDTO 查询条件类
     * @return Result<List < RegionVO>> 后台通用返回封装类
     */
    List<RegionVO> regionPageList(RegionQueryDTO regionQueryDTO);

    /**
     * 查询地区数量
     *
     * @param regionQueryDTO 查询条件类
     * @return Result<List < RegionVO>> 后台通用返回封装类
     */
    Integer regionPageListCount(RegionQueryDTO regionQueryDTO);

    /**
     * 通过景点ID查询其关联的类别信息
     *
     * @param scenicSpotId 景点ID
     * @return Result<List < CategoryVO>> 后台通用返回封装类
     */
    List<Category> queryCategoryByScenicSpotId(Integer scenicSpotId);

}
