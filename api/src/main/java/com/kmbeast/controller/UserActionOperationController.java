package com.kmbeast.controller;

import com.kmbeast.aop.Pager;
import com.kmbeast.context.LocalThreadHolder;
import com.kmbeast.pojo.api.ApiResult;
import com.kmbeast.pojo.api.Result;
import com.kmbeast.pojo.dto.UserActionOperationQueryDTO;
import com.kmbeast.pojo.entity.UserActionOperation;
import com.kmbeast.service.UserActionOperationService;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 用户行为操作控制器
 */
@RestController
@RequestMapping("/user-action-operation")
public class UserActionOperationController {

    @Resource
    private UserActionOperationService userActionOperationService;

    /**
     * 用户行为操作新增
     * POST /api/v1.0/online-travel-api/user-action-operation
     *
     * @param userActionOperation 用户行为操作实体
     * @return Result<Void> 后台通用返回封装类
     */
    @PostMapping
    public Result<Void> addAction(@RequestBody UserActionOperation userActionOperation) {
        userActionOperation.setUserId(LocalThreadHolder.getUserId());
        userActionOperationService.addAction(userActionOperation);
        return ApiResult.success();
    }

    /**
     * 收藏或取消收藏
     * POST /api/v1.0/online-travel-api/user-action-operation/collection
     *
     * @param userActionOperation 用户行为操作实体
     * @return Result<Void> 后台通用返回封装类
     */
    @PostMapping(value = "/collection")
    public Result<Void> collection(@RequestBody UserActionOperation userActionOperation) {
        userActionOperationService.collection(userActionOperation);
        return ApiResult.success();
    }

    /**
     * 点赞或取消点赞
     * POST /api/v1.0/online-travel-api/user-action-operation/upvote
     *
     * @param userActionOperation 用户行为操作实体
     * @return Result<Void> 后台通用返回封装类
     */
    @PostMapping(value = "/upvote")
    public Result<Void> upvote(@RequestBody UserActionOperation userActionOperation) {
        userActionOperationService.upvote(userActionOperation);
        return ApiResult.success();
    }

    /**
     * 用户行为操作删除
     * DELETE /api/v1.0/online-travel-api/user-action-operation/{id}
     *
     * @param id 用户行为操作主键ID
     * @return Result<Void> 后台通用返回封装类
     */
    @DeleteMapping("/{id}")
    public Result<Void> delAction(@PathVariable Integer id) {
        userActionOperationService.delAction(id);
        return ApiResult.success();
    }

    /**
     * 用户行为操作查询
     * POST /api/v1.0/online-travel-api/user-action-operation/query
     *
     * @param queryDTO 查询条件类
     * @return Result<List < UserActionOperation>> 后台通用返回封装类
     */
    @Pager
    @PostMapping("/query")
    public Result<List<UserActionOperation>> queryPage(@RequestBody UserActionOperationQueryDTO queryDTO) {
        queryDTO.setUserId(LocalThreadHolder.getUserId());
        List<UserActionOperation> actionOperationList = userActionOperationService.queryPage(queryDTO);
        return ApiResult.success(actionOperationList);
    }

}