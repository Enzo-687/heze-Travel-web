// router/index.ts
import { createRouter, createWebHistory, type RouteRecordRaw } from 'vue-router'
import { setLastVisitedPath } from "@/utils/storage"
import { authGuard } from './guards'

declare module 'vue-router' {
  interface RouteMeta {
    requireAuth?: boolean
    icon?: string
    iconType?: 'el' | 'custom'
    showInMenu?: boolean
    menuOrder?: number
    roles?: number[]
    keepAlive?: boolean
    breadcrumb?: boolean
  }
}

const routes: RouteRecordRaw[] = [
  {
    path: '/',
    name: 'Root',
    redirect: '/viewer',
  },

  {
    path: '/viewer',
    name: 'Viewer',
    component: () => import('../views/viewer/Index.vue'),
    meta: {
      requireAuth: false,
    },
  },

  {
    path: '/viewer-scenic-spot-info', // 游客 - 景点详情页
    name: 'ViewerScenicSpotInfo',
    component: () => import('@/views/viewer/ViewerScenicSpotInfo.vue'),
    meta: {
      requireAuth: false,
    },
  },

  {
    path: '/scenic-spot-route-nodes-viewer', // 景点路线节点列表 - 游客
    name: 'ViewerRouteItems',
    component: () => import('@/views/viewer/ViewerScenicSpotRouteNodes.vue'),
    meta: {
      requireAuth: false,
    },
  },

  {
    path: '/viewer-scenic-spot-strategy-detail', // 景点攻略详情页 - 游客
    name: 'ViewerScenicSpotStrategyDetail',
    component: () => import('@/views/viewer/ViewerScenicSpotStrategyDetail.vue'),
    meta: {
      requireAuth: false,
    },
  },

  {
    path: '/viewer-scenic-spot-search-list', // 景点信息搜索页 - 游客
    name: 'ViewerScenicSpotSearchList',
    component: () => import('@/views/viewer/ViewerScenicSpotList.vue'),
    meta: {
      requireAuth: false,
    },
  },

  {
    path: '/viewer-scenic-spot-strategy-list', // 景点攻略信息查询页 - 游客
    name: 'ViewerScenicSpotStrategyListHome',
    component: () => import('@/views/viewer/ViewerScenicSpotStrategyHome.vue'),
    meta: {
      requireAuth: false,
    },
  },

  {
    path: '/viewer-themes',
    name: 'ViewerThemes',
    component: () => import('@/views/viewer/ViewerThemes.vue'),
    meta: {
      requireAuth: false,
    },
  },

  {
    path: '/viewer-food',
    name: 'ViewerFood',
    component: () => import('@/views/viewer/ViewerFood.vue'),
    meta: {
      requireAuth: false,
    },
  },

  {
    path: '/viewer-food-detail',
    name: 'ViewerFoodDetail',
    component: () => import('@/views/viewer/ViewerFoodDetail.vue'),
    meta: {
      requireAuth: false,
    },
  },

  {
    path: '/login',
    name: 'Login',
    component: () => import('../views/login/Index.vue'),
    meta: {
      requireAuth: false,
    },
  },

  {
    path: '/register',
    name: 'Register',
    component: () => import('../views/register/Index.vue'),
    meta: {
      requireAuth: false,
    },
  },

  // 法律与信息页面
  {
    path: '/privacy',
    name: 'PrivacyPolicy',
    component: () => import('@/views/pages/PrivacyPolicy.vue'),
    meta: { requireAuth: false, title: '隐私政策' }
  },
  {
    path: '/terms',
    name: 'TermsOfUse',
    component: () => import('@/views/pages/TermsOfUse.vue'),
    meta: { requireAuth: false, title: '使用条款' }
  },
  {
    path: '/disclaimer',
    name: 'Disclaimer',
    component: () => import('@/views/pages/Disclaimer.vue'),
    meta: { requireAuth: false, title: '免责声明' }
  },
  {
    path: '/copyright',
    name: 'Copyright',
    component: () => import('@/views/pages/Copyright.vue'),
    meta: { requireAuth: false, title: '版权声明' }
  },
  {
    path: '/sitemap',
    name: 'SiteMap',
    component: () => import('@/views/pages/SiteMap.vue'),
    meta: { requireAuth: false, title: '网站地图' }
  },
  {
    path: '/about',
    name: 'About',
    component: () => import('@/views/pages/About.vue'),
    meta: { requireAuth: false, title: '平台简介' }
  },
  {
    path: '/contact',
    name: 'Contact',
    component: () => import('@/views/pages/Contact.vue'),
    meta: { requireAuth: false, title: '联系我们' }
  },
  {
    path: '/join',
    name: 'JoinUs',
    component: () => import('@/views/pages/JoinUs.vue'),
    meta: { requireAuth: false, title: '加入我们' }
  },
  {
    path: '/partners',
    name: 'Partners',
    component: () => import('@/views/pages/Partners.vue'),
    meta: { requireAuth: false, title: '合作伙伴' }
  },
  {
    path: '/scenic-spot-info', // 景点详情页
    name: 'ScenicSpotInfo',
    component: () => import('@/views/user/ScenicSpotInfo.vue'),
    meta: {
      requireAuth: false,
    },
  },
  {
    path: '/home-scenic-spot-list', // 景点查询页
    name: 'HomeScenicSpotList',
    component: () => import('@/views/user/HomeScenicSpotList.vue'),
    meta: {
      requireAuth: false,
    },
  },
  {
    path: '/home-scenic-spot-strategy-list', // 景点攻略查询页
    name: 'ScenicSpotStrategyListHome',
    component: () => import('@/views/user/ScenicSpotStrategyHome.vue'),
    meta: {
      requireAuth: false,
    },
  },
  {
    path: '/scenic-spot-strategy-detail', // 景点攻略详情页
    name: 'ScenicSpotStrategyDetail',
    component: () => import('@/views/user/ScenicSpotStrategyDetail.vue'),
    meta: {
      requireAuth: false,
    },
  },
  {
    path: '/scenic-spot-strategy-save', // 景点攻略新增页
    name: 'ScenicSpotStrategySave',
    component: () => import('@/views/user/ScenicSpotStrategySave.vue'),
    meta: {
      requireAuth: false,
    },
  },
  {
    path: '/scenic-spot-strategy-edit', // 景点攻略修改页
    name: 'ScenicSpotStrategyEdit',
    component: () => import('@/views/user/ScenicSpotStrategyEdit.vue'),
    meta: {
      requireAuth: false,
    },
  },
  {
    path: '/scenic-spot-strategy', // 用户景点攻略列表页
    name: 'ScenicSpotStrategy',
    component: () => import('@/views/user/ScenicSpotStrategy.vue'),
    meta: {
      requireAuth: false,
    },
  },
  {
    path: '/scenic-spot-route-nodes-user', // 用户景点攻略列表页
    name: '用户景点路线项节点',
    component: () => import('@/views/user/UserScenicSpotRouteNodes.vue'),
    meta: {
      requireAuth: false,
    },
  },
  {
    path: '/admin',
    component: () => import('@/views/admin/Home.vue'),
    meta: {
      requireAuth: true,
      roles: [1],
      showInMenu: false,
    },
    redirect: '/admin/dashboard', // 简化为直接重定向
    children: [
      {
        path: 'dashboard',
        name: '仪表盘',
        component: () => import('@/views/admin/Dashboard.vue'),
        meta: {
          requireAuth: true,
          showInMenu: true,
          menuOrder: 1,
          icon: 'DataBoard',
          iconType: 'el',
          breadcrumb: true,
          roles: [1],
          keepAlive: true
        }
      },
      {
        path: 'user-manage',
        name: '用户管理',
        component: () => import('@/views/admin/UserManage.vue'),
        meta: {
          requireAuth: true,
          showInMenu: true,
          menuOrder: 2,
          icon: 'User',
          iconType: 'el',
          breadcrumb: true,
          roles: [1],
          keepAlive: true
        }
      },
      {
        path: 'category-manage',
        name: '景点类别管理',
        component: () => import('@/views/admin/CategoryManage.vue'),
        meta: {
          requireAuth: true,
          showInMenu: true,
          menuOrder: 3,
          icon: 'Document',
          iconType: 'el',
          breadcrumb: true,
          roles: [1],
          keepAlive: true
        }
      },
      {
        path: 'region-manage',
        name: '地区管理',
        component: () => import('@/views/admin/RegionManage.vue'),
        meta: {
          requireAuth: true,
          showInMenu: true,
          menuOrder: 4,
          icon: 'LocationFilled',
          iconType: 'el',
          breadcrumb: true,
          roles: [1],
          keepAlive: true
        }
      },
      {
        path: 'scenic-spot-manage',
        name: '景点管理',
        component: () => import('@/views/admin/ScenicSpotManage.vue'),
        meta: {
          requireAuth: true,
          showInMenu: true,
          menuOrder: 5,
          icon: 'MapLocation',
          iconType: 'el',
          breadcrumb: true,
          roles: [1],
          keepAlive: true
        }
      },
      {
        path: 'carousel-manage',
        name: '轮播图管理',
        component: () => import('@/views/admin/CarouselManage.vue'),
        meta: {
          requireAuth: true,
          showInMenu: true,
          menuOrder: 6,
          icon: 'CameraFilled',
          iconType: 'el',
          breadcrumb: true,
          roles: [1],
          keepAlive: true
        }
      },
      {
        path: 'food-manage',
        name: '美食管理',
        component: () => import('@/views/admin/FoodManage.vue'),
        meta: {
          requireAuth: true,
          showInMenu: true,
          menuOrder: 7,
          icon: 'Bowl',
          iconType: 'el',
          breadcrumb: true,
          roles: [1],
          keepAlive: true
        }
      },
      {
        path: 'scenic-spot-strategy-manage',
        name: '景点攻略管理',
        component: () => import('@/views/admin/ScenicSpotStrategyManage.vue'),
        meta: {
          requireAuth: true,
          showInMenu: true,
          menuOrder: 8,
          icon: 'Cloudy',
          iconType: 'el',
          breadcrumb: true,
          roles: [1],
          keepAlive: true
        }
      },
      {
        path: 'scenic-spot-ticket-order-manage',
        name: '门票订单管理',
        component: () => import('@/views/admin/ScenicSpotOrderTicketManage.vue'),
        meta: {
          requireAuth: true,
          showInMenu: true,
          menuOrder: 9,
          icon: 'ScaleToOriginal',
          iconType: 'el',
          breadcrumb: true,
          roles: [1],
          keepAlive: true
        }
      },
      {
        path: 'comment-manage',
        name: '评论管理',
        component: () => import('@/views/admin/CommentManage.vue'),
        meta: {
          requireAuth: true,
          showInMenu: true,
          menuOrder: 10,
          icon: 'ChatLineRound',
          iconType: 'el',
          breadcrumb: true,
          roles: [1],
          keepAlive: true
        }
      },
      {
        path: 'scenic-spot-save',
        name: '景点新增',
        component: () => import('@/views/admin/ScenicSpotSave.vue'),
        meta: {
          requireAuth: true,
          showInMenu: false,
          menuOrder: 5,
          icon: 'MapLocation',
          iconType: 'el',
          breadcrumb: true,
          roles: [1],
          keepAlive: true
        }
      },
      {
        path: 'scenic-spot-strategy-detail-admin',
        name: '景点攻略详情',
        component: () => import('@/views/admin/ScenicSpotStrategyAdminDetail.vue'),
        meta: {
          requireAuth: true,
          showInMenu: false,
          menuOrder: 5,
          icon: 'MapLocation',
          iconType: 'el',
          breadcrumb: true,
          roles: [1],
          keepAlive: true
        }
      },
      {
        path: 'scenic-spot-route-item-admin',
        name: '景点路线项',
        component: () => import('@/views/admin/ScenicSpotRouteItem.vue'),
        meta: {
          requireAuth: true,
          showInMenu: false,
          menuOrder: 5,
          icon: 'MapLocation',
          iconType: 'el',
          breadcrumb: true,
          roles: [1],
          keepAlive: true
        }
      },
      {
        path: 'scenic-spot-tickets-admin',
        name: '景点门票',
        component: () => import('@/views/admin/ScenicSpotTickets.vue'),
        meta: {
          requireAuth: true,
          showInMenu: false,
          menuOrder: 5,
          icon: 'MapLocation',
          iconType: 'el',
          breadcrumb: true,
          roles: [1],
          keepAlive: true
        }
      },
      {
        path: 'scenic-spot-route-nodes-admin',
        name: '景点路线项节点',
        component: () => import('@/views/admin/ScenicSpotRouteNodes.vue'),
        meta: {
          requireAuth: true,
          showInMenu: false,
          menuOrder: 5,
          icon: 'MapLocation',
          iconType: 'el',
          breadcrumb: true,
          roles: [1],
          keepAlive: true
        }
      },
      {
        path: 'scenic-spot-edit',
        name: '景点修改',
        component: () => import('@/views/admin/ScenicSpotEdit.vue'),
        meta: {
          requireAuth: true,
          showInMenu: false,
          menuOrder: 5,
          icon: 'MapLocation',
          iconType: 'el',
          breadcrumb: true,
          roles: [1],
          keepAlive: true
        }
      },
      {
        path: 'scenic-spot-detail',
        name: '景点详情',
        component: () => import('@/views/admin/ScenicSpotDetail.vue'),
        meta: {
          requireAuth: true,
          showInMenu: false,
          menuOrder: 5,
          icon: 'MapLocation',
          iconType: 'el',
          breadcrumb: true,
          roles: [1],
          keepAlive: true
        }
      },
    ]
  },
  {
    path: '/user',
    component: () => import('@/views/user/UserHome.vue'),
    meta: {
      requireAuth: true,
      roles: [2],
      showInMenu: false,
    },
    redirect: '/user/user-main', // 简化为直接重定向
    children: [
      {
        path: 'user-main',
        name: '首页',
        component: () => import('@/views/user/UserMain.vue'),
        meta: {
          requireAuth: true,
          showInMenu: true,
          menuOrder: 1,
          icon: 'HomeFilled',
          iconType: 'el',
          breadcrumb: true,
          roles: [2],
          keepAlive: true
        }
      },
      {
        path: 'user-themes',
        name: '四大主题',
        component: () => import('@/views/viewer/ViewerThemes.vue'),
        meta: {
          requireAuth: true,
          showInMenu: true,
          menuOrder: 2,
          icon: 'Collection',
          iconType: 'el',
          breadcrumb: true,
          roles: [2],
          keepAlive: true
        }
      },
      {
        path: 'user-food',
        name: '特色美食',
        component: () => import('@/views/viewer/ViewerFood.vue'),
        meta: {
          requireAuth: true,
          showInMenu: true,
          menuOrder: 3,
          icon: 'Bowl',
          iconType: 'el',
          breadcrumb: true,
          roles: [2],
          keepAlive: true
        }
      },
      {
        path: 'home-scenic-spot-strategy-list-top',
        name: '景点攻略',
        component: () => import('@/views/user/HomeScenicSpotStrategyListTop.vue'),
        meta: {
          requireAuth: true,
          showInMenu: true,
          menuOrder: 4,
          icon: 'HomeFilled',
          iconType: 'el',
          breadcrumb: true,
          roles: [2],
          keepAlive: true
        }
      },
      {
        path: 'scenic-spot-order-ticket-list',
        name: '我的订单',
        component: () => import('@/views/user/ScenicSpotOrderTicketList.vue'),
        meta: {
          requireAuth: true,
          showInMenu: true,
          menuOrder: 5,
          icon: 'HomeFilled',
          iconType: 'el',
          breadcrumb: true,
          roles: [2],
          keepAlive: true
        }
      },
      {
        path: 'my-collection',
        name: '我的收藏',
        component: () => import('@/views/user/MyCollection.vue'),
        meta: {
          requireAuth: true,
          showInMenu: true,
          menuOrder: 6,
          icon: 'HomeFilled',
          iconType: 'el',
          breadcrumb: true,
          roles: [2],
          keepAlive: true
        }
      },
      {
        path: 'user-food-detail',
        name: '美食详情',
        component: () => import('@/views/viewer/ViewerFoodDetail.vue'),
        meta: {
          requireAuth: true,
          showInMenu: false,
          menuOrder: 99,
          icon: 'Bowl',
          iconType: 'el',
          breadcrumb: true,
          roles: [2],
          keepAlive: false
        }
      },
    ]
  },

]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes
})

// 路由全局前置守卫 - 权限验证
router.beforeEach((to, from, next) => {
  console.log('🚀 Router beforeEach - from:', from.path, 'to:', to.path)
  const result = authGuard(to)
  if (result === true) {
    next()
  } else {
    console.log('🔀 Router redirecting to:', result)
    next(result)
  }
})

// 路由守卫 - 记录访问路径
router.afterEach((to) => {
  console.log('✅ Route changed to:', to.fullPath)
  if (to.meta.requireAuth) {
    setLastVisitedPath(to.fullPath)
  }
})

export default router