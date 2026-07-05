package com.kmbeast.controller;

import com.kmbeast.aop.Pager;
import com.kmbeast.pojo.api.ApiResult;
import com.kmbeast.pojo.api.Result;
import com.kmbeast.pojo.dto.*;
import com.kmbeast.pojo.entity.*;
import com.kmbeast.pojo.vo.*;
import com.kmbeast.service.ViewerService;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 游客控制器
 */
@RestController
@RequestMapping(value = "/viewer")
public class ViewerController {

    @Resource
    private ViewerService viewerService;

    /**
     * 轮播图查询
     * POST /api/v1.0/online-travel-api/viewer/carousel/query
     *
     * @param carouselQueryDTO 查询条件类
     * @return Result<List < Carousel>> 后台通用返回封装类
     */
    @Pager
    @PostMapping("/carousel/query")
    public Result<List<Carousel>> carouselQuery(@RequestBody CarouselQueryDTO carouselQueryDTO) {
        List<Carousel> carouselList = viewerService.carouselQuery(carouselQueryDTO);
        Integer count = viewerService.carouselQueryCount(carouselQueryDTO);
        return ApiResult.success(carouselList,count);
    }

    /**
     * 通过ID查询景点详情
     * GET /api/v1.0/online-travel-api/scenic-spot/{id}/detail
     *
     * @param id 景点主键ID
     * @return Result<ScenicSpotVO> 后台通用返回封装类
     */
    @GetMapping("/scenic-spot/{id}/detail")
    public Result<ScenicSpotVO> listPage(@PathVariable Integer id) {
        ScenicSpotVO scenicSpotVO = viewerService.detail(id);
        return ApiResult.success(scenicSpotVO);
    }

    /**
     * 景点路线项查询
     * POST /api/v1.0/online-travel-api/scenic-spot-route-item/query
     *
     * @param scenicSpotRouteItemQueryDTO 查询条件类
     * @return Result<List < ScenicSpotRouteItem>> 后台通用返回封装类
     */
    @Pager
    @PostMapping("/scenic-spot-route-item/query")
    public Result<List<ScenicSpotRouteItem>> routeItemQuery(@RequestBody ScenicSpotRouteItemQueryDTO scenicSpotRouteItemQueryDTO) {
        List<ScenicSpotRouteItem> scenicSpotRouteItems = viewerService.routeItemQuery(scenicSpotRouteItemQueryDTO);
        return ApiResult.success(scenicSpotRouteItems);
    }

    /**
     * 通过景点路线ID查询景点路线详情
     * POST /api/v1.0/online-travel-api/viewer/scenic-spot-route-item/{id}/detail
     *
     * @param id 主键ID
     * @return Result<ScenicSpotRouteItem> 后台通用返回封装类
     */
    @GetMapping("/scenic-spot-route-item/{id}/detail")
    public Result<ScenicSpotRouteItem> routeItemDetail(@PathVariable Integer id) {
        ScenicSpotRouteItem scenicSpotRouteItem = viewerService.routeItemDetail(id);
        return ApiResult.success(scenicSpotRouteItem);
    }

    /**
     * 景点路线项节点查询
     * POST /api/v1.0/online-travel-api/viewer/scenic-spot-route-nodes/query
     *
     * @param id 景点路线项ID
     * @return Result<List < ScenicSpotRouteNodes>> 后台通用返回封装类
     */
    @GetMapping("/scenic-spot-route-nodes/{id}/list")
    public Result<List<ScenicSpotRouteNodes>> nodesList(@PathVariable Integer id) {
        List<ScenicSpotRouteNodes> scenicSpotRouteNodes = viewerService.nodesList(id);
        return ApiResult.success(scenicSpotRouteNodes);
    }

    /**
     * 查询景点关联的全部景点攻略
     * GET /api/v1.0/online-travel-api/viewer/scenic-spot-strategy/{scenicSpotId}/all
     *
     * @param scenicSpotId 景点ID
     * @return Result<List < ScenicSpotStrategyListVO>> 后台通用返回封装类
     */
    @GetMapping("/scenic-spot-strategy/{scenicSpotId}/all")
    public Result<List<ScenicSpotStrategyListVO>> strategyByScenicSpotId(@PathVariable Integer scenicSpotId) {
        List<ScenicSpotStrategyListVO> scenicSpotStrategyListVOS = viewerService.strategyByScenicSpotId(scenicSpotId);
        return ApiResult.success(scenicSpotStrategyListVOS);
    }

    /**
     * 通过景点攻略ID查询详情信息
     * POST /api/v1.0/online-travel-api/viewer/scenic-spot-strategy/query
     *
     * @param id 主键ID
     * @return Result<List < ScenicSpotStrategyListVO>> 后台通用返回封装类
     */
    @GetMapping("/scenic-spot-strategy/{id}/detail")
    public Result<ScenicSpotStrategyDetailVO> strategyDetail(@PathVariable Integer id) {
        ScenicSpotStrategyDetailVO scenicSpotStrategyDetailVO = viewerService.strategyDetail(id);
        return ApiResult.success(scenicSpotStrategyDetailVO);
    }

    /**
     * 景点门票查询
     * POST /api/v1.0/online-travel-api/viewer/scenic-spot-ticket/query
     *
     * @param scenicSpotTicketQueryDTO 查询条件类
     * @return Result<List < ScenicSpotTicket>> 后台通用返回封装类
     */
    @Pager
    @PostMapping("/scenic-spot-ticket/query")
    public Result<List<ScenicSpotTicket>> ticketsQuery(@RequestBody ScenicSpotTicketQueryDTO scenicSpotTicketQueryDTO) {
        List<ScenicSpotTicket> scenicSpotTickets = viewerService.ticketsQuery(scenicSpotTicketQueryDTO);
        Integer count = viewerService.queryPageCount(scenicSpotTicketQueryDTO);
        return ApiResult.success(scenicSpotTickets, count);
    }

    /**
     * 查询内容下的全部评论
     * GET /api/v1.0/online-travel-api/viewer/comment/list/{contentId}/{contentType}
     *
     * @return Result<String>
     */
    @GetMapping(value = "/comment/list/{contentId}/{contentType}")
    @ResponseBody
    public Result<Object> commentList(@PathVariable Integer contentId,
                               @PathVariable String contentType) {
        List<CommentParentVO> commentParentVOS = viewerService.commentList(contentId, contentType);
        return ApiResult.success(commentParentVOS);
    }

    /**
     * 景点攻略查询
     * POST /api/v1.0/online-travel-api/scenic-spot-strategy/queryList
     *
     * @param scenicSpotStrategyQueryDTO 查询条件类
     * @return Result<List < ScenicSpotStrategyListVO>> 后台通用返回封装类
     */
    @Pager
    @PostMapping("/scenic-spot-strategy/queryList")
    public Result<List<ScenicSpotStrategyListVO>> strategyQueryList(@RequestBody ScenicSpotStrategyQueryDTO scenicSpotStrategyQueryDTO) {
        List<ScenicSpotStrategyListVO> scenicSpotStrategyListVOS = viewerService.strategyQueryList(scenicSpotStrategyQueryDTO);
        Integer count = viewerService.strategyQueryListCount(scenicSpotStrategyQueryDTO);
        return ApiResult.success(scenicSpotStrategyListVOS, count);
    }

    /**
     * 查询景点列表
     * POST /api/v1.0/online-travel-api/viewer/scenic-spot/listPage
     *
     * @param scenicSpotQueryDTO 查询条件类
     * @return Result<List < ScenicSpotListVO>> 后台通用返回封装类
     */
    @Pager
    @PostMapping("/scenic-spot/listPage")
    public Result<List<ScenicSpotListVO>> scenicSpotListPage(@RequestBody ScenicSpotQueryDTO scenicSpotQueryDTO) {
        List<ScenicSpotListVO> scenicSpotListVOS = viewerService.scenicSpotListPage(scenicSpotQueryDTO);
        Integer count = viewerService.scenicSpotListPageCount(scenicSpotQueryDTO);
        return ApiResult.success(scenicSpotListVOS, count);
    }

    /**
     * 地区查询
     * POST /api/v1.0/travel-platform-api/viewer/region/query
     *
     * @param regionQueryDTO 查询条件类
     * @return Result<List < RegionVO>> 后台通用返回封装类
     */
    @Pager
    @PostMapping("/region/pageList")
    public Result<List<RegionVO>> regionPageList(@RequestBody RegionQueryDTO regionQueryDTO) {
        List<RegionVO> regionVOS = viewerService.regionPageList(regionQueryDTO);
        Integer count = viewerService.regionPageListCount(regionQueryDTO);
        return ApiResult.success(regionVOS, count);
    }

    /**
     * 通过景点ID查询其关联的类别信息
     * GET /api/v1.0/online-travel-api/viewer/category/{scenicSpotId}/query
     *
     * @param scenicSpotId 景点ID
     * @return Result<List < CategoryVO>> 后台通用返回封装类
     */
    @GetMapping("/category/{scenicSpotId}/query")
    public Result<List<Category>> queryCategoryByScenicSpotId(@PathVariable Integer scenicSpotId) {
        List<Category> categories =  viewerService.queryCategoryByScenicSpotId(scenicSpotId);
        return ApiResult.success(categories);
    }


}
