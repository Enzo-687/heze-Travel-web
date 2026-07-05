package com.kmbeast.service.impl;

import com.kmbeast.mapper.CategoryMapper;
import com.kmbeast.pojo.dto.*;
import com.kmbeast.pojo.entity.*;
import com.kmbeast.pojo.vo.*;
import com.kmbeast.service.*;
import com.kmbeast.utils.AssertUtils;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 游客业务逻辑实现类
 */
@Service
public class ViewerServiceImpl implements ViewerService {

    @Resource
    private CarouselService carouselService;
    @Resource
    private ScenicSpotService scenicSpotService;
    @Resource
    private ScenicSpotRouteItemService scenicSpotRouteItemService;
    @Resource
    private ScenicSpotRouteNodesService scenicSpotRouteNodesService;
    @Resource
    private ScenicSpotStrategyService scenicSpotStrategyService;
    @Resource
    private ScenicSpotTicketService scenicSpotTicketService;
    @Resource
    private CommentService commentService;
    @Resource
    private RegionService regionService;
    @Resource
    private CategoryService categoryService;

    /**
     * 游客 - 查询轮播图数据
     *
     * @param carouselQueryDTO 查询条件类
     * @return List<Carousel>
     */
    @Override
    public List<Carousel> carouselQuery(CarouselQueryDTO carouselQueryDTO) {
        return carouselService.queryPage(carouselQueryDTO);
    }

    /**
     * 游客 - 查询轮播图数量
     *
     * @param carouselQueryDTO 查询条件类
     * @return Integer
     */
    @Override
    public Integer carouselQueryCount(CarouselQueryDTO carouselQueryDTO) {
        return carouselService.queryPageCount(carouselQueryDTO);
    }

    /**
     * 游客 - 通过ID查询景点详情
     *
     * @param id 景点ID
     * @return Integer
     */
    @Override
    public ScenicSpotVO detail(Integer id) {
        AssertUtils.notNull(id, "景点ID不为空");
        return scenicSpotService.detail(id);
    }

    /**
     * 景点路线项查询
     *
     * @param scenicSpotRouteItemQueryDTO 查询条件类
     * @return Result<List < ScenicSpotRouteItem>> 后台通用返回封装类
     */
    @Override
    public List<ScenicSpotRouteItem> routeItemQuery(ScenicSpotRouteItemQueryDTO scenicSpotRouteItemQueryDTO) {
        return scenicSpotRouteItemService.queryPage(scenicSpotRouteItemQueryDTO);
    }

    /**
     * 通过景点路线ID查询景点路线详情
     *
     * @param id 主键ID
     * @return ScenicSpotRouteItem
     */
    @Override
    public ScenicSpotRouteItem routeItemDetail(Integer id) {
        return scenicSpotRouteItemService.detail(id);
    }

    /**
     * 景点路线项查询
     *
     * @param id 主键ID
     * @return Result<List < ScenicSpotRouteItem>> 后台通用返回封装类
     */
    @Override
    public List<ScenicSpotRouteNodes> nodesList(Integer id) {
        return scenicSpotRouteNodesService.nodes(id);
    }

    /**
     * 查询景点关联的全部景点攻略
     *
     * @param scenicSpotId 景点ID
     * @return Result<List < ScenicSpotStrategyListVO>> 后台通用返回封装类
     */
    @Override
    public List<ScenicSpotStrategyListVO> strategyByScenicSpotId(Integer scenicSpotId) {
        return scenicSpotStrategyService.all(scenicSpotId);
    }

    /**
     * 通过景点攻略ID查询详情信息
     *
     * @param id 主键ID
     * @return Result<List < ScenicSpotStrategyListVO>> 后台通用返回封装类
     */
    @Override
    public ScenicSpotStrategyDetailVO strategyDetail(Integer id) {
        return scenicSpotStrategyService.detail(id);
    }

    /**
     * 景点门票查询
     *
     * @param scenicSpotTicketQueryDTO 查询条件类
     * @return Result<List < ScenicSpotTicket>> 后台通用返回封装类
     */
    @Override
    public List<ScenicSpotTicket> ticketsQuery(ScenicSpotTicketQueryDTO scenicSpotTicketQueryDTO) {
        return scenicSpotTicketService.queryPage(scenicSpotTicketQueryDTO);
    }

    /**
     * 查询景点门票数量
     *
     * @param scenicSpotTicketQueryDTO 查询条件类
     * @return Result<List < ScenicSpotTicket>> 后台通用返回封装类
     */
    @Override
    public Integer queryPageCount(ScenicSpotTicketQueryDTO scenicSpotTicketQueryDTO) {
        return scenicSpotTicketService.queryPageCount(scenicSpotTicketQueryDTO);
    }

    /**
     * 查询内容下的全部评论
     *
     * @param contentId   内容ID
     * @param contentType 内容类型
     * @return Result<String>
     */
    @Override
    public List<CommentParentVO> commentList(Integer contentId, String contentType) {
        return commentService.listWithViewer(contentId, contentType);
    }

    /**
     * 景点攻略查询
     *
     * @param scenicSpotStrategyQueryDTO 查询条件类
     * @return Result<List < ScenicSpotStrategyListVO>> 后台通用返回封装类
     */
    @Override
    public List<ScenicSpotStrategyListVO> strategyQueryList(ScenicSpotStrategyQueryDTO scenicSpotStrategyQueryDTO) {
        return scenicSpotStrategyService.queryList(scenicSpotStrategyQueryDTO);
    }

    /**
     * 查询景点攻略数量
     *
     * @param scenicSpotStrategyQueryDTO 查询条件类
     * @return Result<List < ScenicSpotStrategyListVO>> 后台通用返回封装类
     */
    @Override
    public Integer strategyQueryListCount(ScenicSpotStrategyQueryDTO scenicSpotStrategyQueryDTO) {
        return scenicSpotStrategyService.queryListCount(scenicSpotStrategyQueryDTO);
    }

    /**
     * 查询景点列表
     *
     * @param scenicSpotQueryDTO 查询条件类
     * @return Result<List < ScenicSpotListVO>> 后台通用返回封装类
     */
    @Override
    public List<ScenicSpotListVO> scenicSpotListPage(ScenicSpotQueryDTO scenicSpotQueryDTO) {
        return scenicSpotService.listPage(scenicSpotQueryDTO);
    }

    /**
     * 查询景点数量
     *
     * @param scenicSpotQueryDTO 查询条件类
     * @return Result<List < ScenicSpotListVO>> 后台通用返回封装类
     */
    @Override
    public Integer scenicSpotListPageCount(ScenicSpotQueryDTO scenicSpotQueryDTO) {
        return scenicSpotService.listPageCount(scenicSpotQueryDTO);
    }

    /**
     * 地区查询
     *
     * @param regionQueryDTO 查询条件类
     * @return Result<List < RegionVO>> 后台通用返回封装类
     */
    @Override
    public List<RegionVO> regionPageList(RegionQueryDTO regionQueryDTO) {
        return regionService.pageList(regionQueryDTO);
    }

    /**
     * 查询地区数量
     *
     * @param regionQueryDTO 查询条件类
     * @return Result<List < RegionVO>> 后台通用返回封装类
     */
    @Override
    public Integer regionPageListCount(RegionQueryDTO regionQueryDTO) {
        return regionService.pageListCount(regionQueryDTO);
    }

    /**
     * 通过景点ID查询其关联的类别信息
     *
     * @param scenicSpotId 景点ID
     * @return Result<List < CategoryVO>> 后台通用返回封装类
     */
    @Override
    public List<Category> queryCategoryByScenicSpotId(Integer scenicSpotId) {
        AssertUtils.notNull(scenicSpotId,"景点ID不为空");
        return categoryService.queryCategoryByScenicSpotId(scenicSpotId);
    }
}
