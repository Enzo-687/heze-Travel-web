/*
 Navicat Premium Dump SQL

 Source Server         : local_dev_db
 Source Server Type    : MySQL
 Source Server Version : 50743 (5.7.43-log)
 Source Host           : localhost:3306
 Source Schema         : online-travel-db

 Target Server Type    : MySQL
 Target Server Version : 50743 (5.7.43-log)
 File Encoding         : 65001

 Date: 19/01/2026 15:01:09
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for carousel
-- ----------------------------
DROP TABLE IF EXISTS `carousel`;
CREATE TABLE `carousel`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '轮播图信息表主键ID，自增',
  `scenic_spot_id` int(11) NULL DEFAULT NULL COMMENT '景点ID，外键，关联的是景点信息表',
  `cover_url` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '推荐图URL',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '标题',
  `recommend_detail` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '推荐语',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_scenic_spot_id`(`scenic_spot_id`) USING BTREE COMMENT '索引-景点ID'
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '轮播图信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of carousel
-- ----------------------------
INSERT INTO `carousel` VALUES (1, 20, 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=1768799609029IMG_20251220_032039.png', '11明朝 13 位皇帝及 23 位皇后、数十名殉葬宫人', '111明十三陵坐落于北京昌平区天寿山南麓，距市区约五十公里，是明朝 13 位皇帝及 23 位皇后、数十名殉葬宫人的陵寝群，也是世界上保存完整、埋葬帝王最多的皇家墓葬群', '2025-12-23 15:19:13');
INSERT INTO `carousel` VALUES (5, 16, 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=1768799615139IMG_20251220_032442.png', '北京紫禁城：明清皇家宫殿的千年回响', '红墙黄瓦映日月，殿宇巍峨藏乾坤。这里是明清两代皇宫，六百年风云变幻尽在其中，一砖一瓦皆诉说着华夏世界文化遗产天坛，是帝都北京的标志性地标。红墙映翠柏，穹顶接云天，在这里邂逅一场跨越古今的文化盛宴。', '2025-12-23 16:27:52');
INSERT INTO `carousel` VALUES (7, 20, 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=1768799623413IMG_20251220_032519.png', '天坛：明清祭天圣地 华夏建筑瑰宝', '明清两代皇家祭天之所，以圜丘坛、祈年殿为核心，融天地礼制与建筑美学于一体，一砖一瓦皆藏古人对苍穹的敬畏与智慧。', '2025-12-23 17:01:01');

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '景点类别表，主键，自增',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '名称',
  `level` int(2) NULL DEFAULT NULL COMMENT '层级',
  `parent_id` int(11) NULL DEFAULT NULL COMMENT '父级ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_parent_id`(`parent_id`) USING BTREE COMMENT '索引-父级ID'
) ENGINE = InnoDB AUTO_INCREMENT = 43 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '景点类别信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES (1, '自然景观', 1, -1);
INSERT INTO `category` VALUES (2, '人文古迹', 1, -1);
INSERT INTO `category` VALUES (3, '休闲娱乐', 1, -1);
INSERT INTO `category` VALUES (4, '特色体验', 1, -1);
INSERT INTO `category` VALUES (5, '研学旅行', 1, -1);
INSERT INTO `category` VALUES (6, '山岳景观', 2, 1);
INSERT INTO `category` VALUES (7, '水域景观', 2, 1);
INSERT INTO `category` VALUES (8, '森林草原', 2, 1);
INSERT INTO `category` VALUES (9, '地质奇观', 2, 1);
INSERT INTO `category` VALUES (10, '冰雪景观', 2, 1);
INSERT INTO `category` VALUES (11, '历史建筑', 2, 2);
INSERT INTO `category` VALUES (12, '宗教圣地', 2, 2);
INSERT INTO `category` VALUES (13, '民俗村落', 2, 2);
INSERT INTO `category` VALUES (14, '红色旅游', 2, 2);
INSERT INTO `category` VALUES (15, '主题乐园', 2, 3);
INSERT INTO `category` VALUES (16, '温泉度假', 2, 3);
INSERT INTO `category` VALUES (17, '亲子游乐', 2, 3);
INSERT INTO `category` VALUES (18, '露营野餐', 2, 3);
INSERT INTO `category` VALUES (19, '美食体验', 2, 4);
INSERT INTO `category` VALUES (20, '手工制作', 2, 4);
INSERT INTO `category` VALUES (21, '户外探险', 2, 4);
INSERT INTO `category` VALUES (22, '科普教育', 2, 5);
INSERT INTO `category` VALUES (23, '文化研学', 2, 5);
INSERT INTO `category` VALUES (24, '自然研学', 2, 5);
INSERT INTO `category` VALUES (25, '名山主峰', 3, 6);
INSERT INTO `category` VALUES (26, '徒步登山', 3, 6);
INSERT INTO `category` VALUES (27, '云海观日', 3, 6);
INSERT INTO `category` VALUES (28, '湖泊游船', 3, 7);
INSERT INTO `category` VALUES (29, '瀑布观赏', 3, 7);
INSERT INTO `category` VALUES (30, '海滨浴场', 3, 7);
INSERT INTO `category` VALUES (31, '滑雪场', 3, 10);
INSERT INTO `category` VALUES (32, '冰雕展', 3, 10);
INSERT INTO `category` VALUES (33, '雪地徒步', 3, 10);
INSERT INTO `category` VALUES (34, '古城墙', 3, 11);
INSERT INTO `category` VALUES (35, '古寺庙', 3, 11);
INSERT INTO `category` VALUES (36, '古民居', 3, 11);
INSERT INTO `category` VALUES (37, '过山车类', 3, 15);
INSERT INTO `category` VALUES (38, '水上乐园', 3, 15);
INSERT INTO `category` VALUES (39, '演艺秀场', 3, 15);
INSERT INTO `category` VALUES (40, '科技馆体验', 3, 22);
INSERT INTO `category` VALUES (41, '博物馆研学', 3, 22);
INSERT INTO `category` VALUES (42, '动植物科普', 3, 22);

-- ----------------------------
-- Table structure for comment
-- ----------------------------
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '评论表主键ID，自增',
  `parent_id` int(11) NULL DEFAULT NULL COMMENT '父级评论ID，构建评论的树形结构',
  `commenter_id` int(11) NULL DEFAULT NULL COMMENT '评论者ID',
  `replier_id` int(11) NULL DEFAULT NULL COMMENT '回复者ID',
  `content_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '内容类型，与内容ID配合使用',
  `content_id` int(11) NULL DEFAULT NULL COMMENT '内容ID，与内容类型配合使用',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL COMMENT '评论内容',
  `create_time` datetime NULL DEFAULT NULL COMMENT '评论时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 67 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of comment
-- ----------------------------
INSERT INTO `comment` VALUES (51, NULL, 60, NULL, 'SCENIC_SPOT', 16, 'zheshi', '2026-01-16 17:44:43');
INSERT INTO `comment` VALUES (53, NULL, 60, NULL, 'SCENIC_SPOT_STRATEGY', 4, '不仅是西藏的象征，更是世界屋脊上一颗璀璨的文化明珠。它始建于公元七世纪松赞干布时期，历经千年风雨和多次扩建', '2026-01-16 17:50:03');
INSERT INTO `comment` VALUES (54, NULL, 60, NULL, 'SCENIC_SPOT', 20, '陵区营建始于永乐七年（1409 年），历时 200 余年，总面积达 80 平方公里。布局以长陵（永乐皇帝陵）为核心居主峰中部，其余各陵分列两侧，遵循 “尊者居主脉” 的规制。各陵均采用 “前方后圆” 格局，中轴线上依次排布陵门、祾恩殿、明楼、宝城等建筑，尽显皇家威严。', '2026-01-17 21:48:06');
INSERT INTO `comment` VALUES (55, NULL, 60, NULL, 'SCENIC_SPOT', 20, '陵区营建始于永乐七年（1409 年），历时 200 余年，总面积达 80 平方公里。布局以长陵（永乐皇帝陵）为核心居主峰中部，其余各陵分列两侧，遵循 “尊者居主脉” 的规制。各陵均采用 “前方后圆” 格局，中轴线上依次排布陵门、祾恩殿、明楼、宝城等建筑，尽显皇家威严。', '2026-01-17 21:48:08');
INSERT INTO `comment` VALUES (56, 55, 60, NULL, 'SCENIC_SPOT', 20, '陵区营建始于永乐七年（1409 年），历时 200 余年，总面积达 80 平方公里。布局以长陵（永乐皇帝陵）为核心居主峰中部，其余各陵分列两侧，遵循 “尊者居主脉” 的规制。各陵均采用 “前方后圆” 格局，中轴线上依次排布陵门、祾恩殿、明楼、宝城等建筑，尽显皇家威严。', '2026-01-17 21:48:13');
INSERT INTO `comment` VALUES (57, NULL, 60, NULL, 'SCENIC_SPOT', 16, '这片秘境藏着大自然的鬼斧神工！青山叠翠间溪流潺潺，云海翻涌时宛如仙境，四季皆有别样风情 —— 春赏繁花似锦，夏沐清风避暑，秋观层林尽染，冬赏银装素裹。步道沿景延伸，既可徒步探秘原生植被，也能静坐观景台吸氧洗肺。配套设施完善，交通便捷，是远离尘嚣、沉浸式感受自然之美的绝佳旅游目的地，适合全家出游、好友结伴或独自放空。', '2026-01-17 21:48:25');
INSERT INTO `comment` VALUES (58, 57, 60, NULL, 'SCENIC_SPOT', 16, '这片秘境藏着大自然的鬼斧神工！青山叠翠间溪流潺潺，云海翻涌时宛如仙境，四季皆有别样风情 —— 春赏繁花似锦，夏沐清风避暑，秋观层林尽染，冬赏银装素裹。步道沿景延伸，既可徒步探秘原生植被，也能静坐观景台吸氧洗肺。配套设施完善，交通便捷，是远离尘嚣、沉浸式感受自然之美的绝佳旅游目的地，适合全家出游、好友结伴或独自放空。', '2026-01-17 21:48:30');
INSERT INTO `comment` VALUES (59, 55, 59, NULL, 'SCENIC_SPOT', 20, '主峰中部，其余各陵分列两侧，遵循 “尊者居主脉”', '2026-01-17 21:48:52');
INSERT INTO `comment` VALUES (60, 55, 59, 60, 'SCENIC_SPOT', 20, '主峰中部，其余各陵分列两侧，遵循 “尊者居主脉”', '2026-01-17 21:48:57');
INSERT INTO `comment` VALUES (61, NULL, 59, NULL, 'SCENIC_SPOT', 20, '主峰中部，其余各陵分列两侧，遵循 “尊者居主脉”', '2026-01-17 21:49:02');
INSERT INTO `comment` VALUES (64, NULL, 1, NULL, 'SCENIC_SPOT_STRATEGY', 4, '不仅是西藏的象征，更', '2026-01-19 13:39:03');

-- ----------------------------
-- Table structure for comment_like
-- ----------------------------
DROP TABLE IF EXISTS `comment_like`;
CREATE TABLE `comment_like`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '评论点赞表ID',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户ID，外键，关联用户表',
  `comment_id` int(11) NULL DEFAULT NULL COMMENT '评论ID，外键，关联评论表',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 88 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of comment_like
-- ----------------------------
INSERT INTO `comment_like` VALUES (85, 60, 49);
INSERT INTO `comment_like` VALUES (86, 60, 61);
INSERT INTO `comment_like` VALUES (87, 1, 64);

-- ----------------------------
-- Table structure for order_refund_info
-- ----------------------------
DROP TABLE IF EXISTS `order_refund_info`;
CREATE TABLE `order_refund_info`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '景点门票订单退款申请表，主键ID，自增',
  `ticket_order_id` int(11) NULL DEFAULT NULL COMMENT '景点门票订单ID',
  `status` int(2) NULL DEFAULT NULL COMMENT '退款状态（1：申请中；2：已退款；3：拒绝退款）',
  `reject_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '拒绝退款原因（只有当拒绝退款时需要填写）',
  `refund_time` datetime NULL DEFAULT NULL COMMENT '退款时间（退款成功时设置）',
  `reject_refund_time` datetime NULL DEFAULT NULL COMMENT '拒绝退款时间',
  `create_time` datetime NULL DEFAULT NULL COMMENT '申请退款时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_order_id`(`ticket_order_id`) USING BTREE COMMENT '索引-订单ID'
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '景点门票订单退款申请信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order_refund_info
-- ----------------------------
INSERT INTO `order_refund_info` VALUES (2, 4, 3, '系统异常，请稍后再试', NULL, '2026-01-10 17:55:43', '2026-01-10 17:26:42');
INSERT INTO `order_refund_info` VALUES (3, 4, 2, NULL, '2026-01-10 18:09:46', NULL, '2026-01-10 17:55:51');
INSERT INTO `order_refund_info` VALUES (4, 6, 3, '测试', NULL, '2026-01-10 18:25:02', '2026-01-10 18:19:09');
INSERT INTO `order_refund_info` VALUES (5, 6, 2, NULL, '2026-01-11 16:25:34', NULL, '2026-01-10 18:26:09');
INSERT INTO `order_refund_info` VALUES (6, 7, 3, '财务系统维护中，请稍后再试', NULL, '2026-01-11 17:05:54', '2026-01-10 18:27:03');
INSERT INTO `order_refund_info` VALUES (7, 11, 2, NULL, '2026-01-11 16:21:05', NULL, '2026-01-11 15:23:31');
INSERT INTO `order_refund_info` VALUES (8, 14, 3, '1122121', NULL, '2026-01-11 17:08:58', '2026-01-11 17:08:44');
INSERT INTO `order_refund_info` VALUES (9, 14, 2, NULL, '2026-01-11 17:09:22', NULL, '2026-01-11 17:09:06');
INSERT INTO `order_refund_info` VALUES (10, 7, 1, NULL, NULL, NULL, '2026-01-17 16:34:11');
INSERT INTO `order_refund_info` VALUES (11, 16, 3, '财务系统维护中，请稍后再试', NULL, '2026-01-18 22:29:11', '2026-01-18 22:28:38');
INSERT INTO `order_refund_info` VALUES (12, 16, 2, NULL, '2026-01-18 22:29:35', NULL, '2026-01-18 22:29:28');

-- ----------------------------
-- Table structure for region
-- ----------------------------
DROP TABLE IF EXISTS `region`;
CREATE TABLE `region`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '地区信息表，主键，自增',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '名称',
  `level` int(2) NULL DEFAULT NULL COMMENT '层级',
  `parent_id` int(11) NULL DEFAULT NULL COMMENT '父级ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_parent_id`(`parent_id`) USING BTREE COMMENT '索引-父级ID'
) ENGINE = InnoDB AUTO_INCREMENT = 782 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '地区信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of region
-- ----------------------------
INSERT INTO `region` VALUES (1, '北京市', 1, -1);
INSERT INTO `region` VALUES (2, '天津市', 1, -1);
INSERT INTO `region` VALUES (3, '河北省', 1, -1);
INSERT INTO `region` VALUES (4, '山西省', 1, -1);
INSERT INTO `region` VALUES (5, '内蒙古自治区', 1, -1);
INSERT INTO `region` VALUES (6, '辽宁省', 1, -1);
INSERT INTO `region` VALUES (7, '吉林省', 1, -1);
INSERT INTO `region` VALUES (8, '黑龙江省', 1, -1);
INSERT INTO `region` VALUES (9, '上海市', 1, -1);
INSERT INTO `region` VALUES (10, '江苏省', 1, -1);
INSERT INTO `region` VALUES (11, '浙江省', 1, -1);
INSERT INTO `region` VALUES (12, '安徽省', 1, -1);
INSERT INTO `region` VALUES (13, '福建省', 1, -1);
INSERT INTO `region` VALUES (14, '江西省', 1, -1);
INSERT INTO `region` VALUES (15, '山东省', 1, -1);
INSERT INTO `region` VALUES (16, '河南省', 1, -1);
INSERT INTO `region` VALUES (17, '湖北省', 1, -1);
INSERT INTO `region` VALUES (18, '湖南省', 1, -1);
INSERT INTO `region` VALUES (19, '广东省', 1, -1);
INSERT INTO `region` VALUES (20, '广西壮族自治区', 1, -1);
INSERT INTO `region` VALUES (21, '海南省', 1, -1);
INSERT INTO `region` VALUES (22, '重庆市', 1, -1);
INSERT INTO `region` VALUES (23, '四川省', 1, -1);
INSERT INTO `region` VALUES (24, '贵州省', 1, -1);
INSERT INTO `region` VALUES (25, '云南省', 1, -1);
INSERT INTO `region` VALUES (26, '西藏自治区', 1, -1);
INSERT INTO `region` VALUES (27, '陕西省', 1, -1);
INSERT INTO `region` VALUES (28, '甘肃省', 1, -1);
INSERT INTO `region` VALUES (29, '青海省', 1, -1);
INSERT INTO `region` VALUES (30, '宁夏回族自治区', 1, -1);
INSERT INTO `region` VALUES (31, '新疆维吾尔自治区', 1, -1);
INSERT INTO `region` VALUES (32, '香港特别行政区', 1, -1);
INSERT INTO `region` VALUES (33, '澳门特别行政区', 1, -1);
INSERT INTO `region` VALUES (34, '台湾省', 1, -1);
INSERT INTO `region` VALUES (35, '东城区', 2, 1);
INSERT INTO `region` VALUES (36, '西城区', 2, 1);
INSERT INTO `region` VALUES (37, '朝阳区', 2, 1);
INSERT INTO `region` VALUES (38, '丰台区', 2, 1);
INSERT INTO `region` VALUES (39, '石景山区', 2, 1);
INSERT INTO `region` VALUES (40, '海淀区', 2, 1);
INSERT INTO `region` VALUES (41, '门头沟区', 2, 1);
INSERT INTO `region` VALUES (42, '房山区', 2, 1);
INSERT INTO `region` VALUES (43, '通州区', 2, 1);
INSERT INTO `region` VALUES (44, '顺义区', 2, 1);
INSERT INTO `region` VALUES (45, '昌平区', 2, 1);
INSERT INTO `region` VALUES (46, '大兴区', 2, 1);
INSERT INTO `region` VALUES (47, '怀柔区', 2, 1);
INSERT INTO `region` VALUES (48, '平谷区', 2, 1);
INSERT INTO `region` VALUES (49, '密云区', 2, 1);
INSERT INTO `region` VALUES (50, '延庆区', 2, 1);
INSERT INTO `region` VALUES (51, '和平区', 2, 2);
INSERT INTO `region` VALUES (52, '河东区', 2, 2);
INSERT INTO `region` VALUES (53, '河西区', 2, 2);
INSERT INTO `region` VALUES (54, '南开区', 2, 2);
INSERT INTO `region` VALUES (55, '河北区', 2, 2);
INSERT INTO `region` VALUES (56, '红桥区', 2, 2);
INSERT INTO `region` VALUES (57, '东丽区', 2, 2);
INSERT INTO `region` VALUES (58, '西青区', 2, 2);
INSERT INTO `region` VALUES (59, '津南区', 2, 2);
INSERT INTO `region` VALUES (60, '北辰区', 2, 2);
INSERT INTO `region` VALUES (61, '武清区', 2, 2);
INSERT INTO `region` VALUES (62, '宝坻区', 2, 2);
INSERT INTO `region` VALUES (63, '滨海新区', 2, 2);
INSERT INTO `region` VALUES (64, '宁河区', 2, 2);
INSERT INTO `region` VALUES (65, '静海区', 2, 2);
INSERT INTO `region` VALUES (66, '蓟州区', 2, 2);
INSERT INTO `region` VALUES (67, '石家庄市', 2, 3);
INSERT INTO `region` VALUES (68, '唐山市', 2, 3);
INSERT INTO `region` VALUES (69, '秦皇岛市', 2, 3);
INSERT INTO `region` VALUES (70, '邯郸市', 2, 3);
INSERT INTO `region` VALUES (71, '邢台市', 2, 3);
INSERT INTO `region` VALUES (72, '保定市', 2, 3);
INSERT INTO `region` VALUES (73, '张家口市', 2, 3);
INSERT INTO `region` VALUES (74, '承德市', 2, 3);
INSERT INTO `region` VALUES (75, '沧州市', 2, 3);
INSERT INTO `region` VALUES (76, '廊坊市', 2, 3);
INSERT INTO `region` VALUES (77, '衡水市', 2, 3);
INSERT INTO `region` VALUES (78, '长安区', 3, 51);
INSERT INTO `region` VALUES (79, '桥西区', 3, 51);
INSERT INTO `region` VALUES (80, '新华区', 3, 51);
INSERT INTO `region` VALUES (81, '裕华区', 3, 51);
INSERT INTO `region` VALUES (82, '藁城区', 3, 51);
INSERT INTO `region` VALUES (83, '鹿泉区', 3, 51);
INSERT INTO `region` VALUES (84, '栾城区', 3, 51);
INSERT INTO `region` VALUES (85, '正定县', 3, 51);
INSERT INTO `region` VALUES (86, '平山县', 3, 51);
INSERT INTO `region` VALUES (87, '赵县', 3, 51);
INSERT INTO `region` VALUES (88, '太原市', 2, 4);
INSERT INTO `region` VALUES (89, '大同市', 2, 4);
INSERT INTO `region` VALUES (90, '阳泉市', 2, 4);
INSERT INTO `region` VALUES (91, '长治市', 2, 4);
INSERT INTO `region` VALUES (92, '晋城市', 2, 4);
INSERT INTO `region` VALUES (93, '朔州市', 2, 4);
INSERT INTO `region` VALUES (94, '晋中市', 2, 4);
INSERT INTO `region` VALUES (95, '运城市', 2, 4);
INSERT INTO `region` VALUES (96, '忻州市', 2, 4);
INSERT INTO `region` VALUES (97, '临汾市', 2, 4);
INSERT INTO `region` VALUES (98, '吕梁市', 2, 4);
INSERT INTO `region` VALUES (99, '小店区', 3, 73);
INSERT INTO `region` VALUES (100, '迎泽区', 3, 73);
INSERT INTO `region` VALUES (101, '杏花岭区', 3, 73);
INSERT INTO `region` VALUES (102, '尖草坪区', 3, 73);
INSERT INTO `region` VALUES (103, '万柏林区', 3, 73);
INSERT INTO `region` VALUES (104, '晋源区', 3, 73);
INSERT INTO `region` VALUES (105, '清徐县', 3, 73);
INSERT INTO `region` VALUES (106, '阳曲县', 3, 73);
INSERT INTO `region` VALUES (107, '娄烦县', 3, 73);
INSERT INTO `region` VALUES (108, '古交市', 3, 73);
INSERT INTO `region` VALUES (109, '呼和浩特市', 2, 5);
INSERT INTO `region` VALUES (110, '包头市', 2, 5);
INSERT INTO `region` VALUES (111, '乌海市', 2, 5);
INSERT INTO `region` VALUES (112, '赤峰市', 2, 5);
INSERT INTO `region` VALUES (113, '通辽市', 2, 5);
INSERT INTO `region` VALUES (114, '鄂尔多斯市', 2, 5);
INSERT INTO `region` VALUES (115, '呼伦贝尔市', 2, 5);
INSERT INTO `region` VALUES (116, '巴彦淖尔市', 2, 5);
INSERT INTO `region` VALUES (117, '乌兰察布市', 2, 5);
INSERT INTO `region` VALUES (118, '兴安盟', 2, 5);
INSERT INTO `region` VALUES (119, '锡林郭勒盟', 2, 5);
INSERT INTO `region` VALUES (120, '阿拉善盟', 2, 5);
INSERT INTO `region` VALUES (121, '新城区', 3, 96);
INSERT INTO `region` VALUES (122, '回民区', 3, 96);
INSERT INTO `region` VALUES (123, '玉泉区', 3, 96);
INSERT INTO `region` VALUES (124, '赛罕区', 3, 96);
INSERT INTO `region` VALUES (125, '土默特左旗', 3, 96);
INSERT INTO `region` VALUES (126, '托克托县', 3, 96);
INSERT INTO `region` VALUES (127, '和林格尔县', 3, 96);
INSERT INTO `region` VALUES (128, '清水河县', 3, 96);
INSERT INTO `region` VALUES (129, '武川县', 3, 96);
INSERT INTO `region` VALUES (130, '沈阳市', 2, 6);
INSERT INTO `region` VALUES (131, '大连市', 2, 6);
INSERT INTO `region` VALUES (132, '鞍山市', 2, 6);
INSERT INTO `region` VALUES (133, '抚顺市', 2, 6);
INSERT INTO `region` VALUES (134, '本溪市', 2, 6);
INSERT INTO `region` VALUES (135, '丹东市', 2, 6);
INSERT INTO `region` VALUES (136, '锦州市', 2, 6);
INSERT INTO `region` VALUES (137, '营口市', 2, 6);
INSERT INTO `region` VALUES (138, '阜新市', 2, 6);
INSERT INTO `region` VALUES (139, '辽阳市', 2, 6);
INSERT INTO `region` VALUES (140, '盘锦市', 2, 6);
INSERT INTO `region` VALUES (141, '铁岭市', 2, 6);
INSERT INTO `region` VALUES (142, '朝阳市', 2, 6);
INSERT INTO `region` VALUES (143, '葫芦岛市', 2, 6);
INSERT INTO `region` VALUES (144, '和平区', 3, 119);
INSERT INTO `region` VALUES (145, '沈河区', 3, 119);
INSERT INTO `region` VALUES (146, '大东区', 3, 119);
INSERT INTO `region` VALUES (147, '皇姑区', 3, 119);
INSERT INTO `region` VALUES (148, '铁西区', 3, 119);
INSERT INTO `region` VALUES (149, '苏家屯区', 3, 119);
INSERT INTO `region` VALUES (150, '浑南区', 3, 119);
INSERT INTO `region` VALUES (151, '沈北新区', 3, 119);
INSERT INTO `region` VALUES (152, '于洪区', 3, 119);
INSERT INTO `region` VALUES (153, '辽中区', 3, 119);
INSERT INTO `region` VALUES (154, '康平县', 3, 119);
INSERT INTO `region` VALUES (155, '法库县', 3, 119);
INSERT INTO `region` VALUES (156, '新民市', 3, 119);
INSERT INTO `region` VALUES (157, '长春市', 2, 7);
INSERT INTO `region` VALUES (158, '吉林市', 2, 7);
INSERT INTO `region` VALUES (159, '四平市', 2, 7);
INSERT INTO `region` VALUES (160, '辽源市', 2, 7);
INSERT INTO `region` VALUES (161, '通化市', 2, 7);
INSERT INTO `region` VALUES (162, '白山市', 2, 7);
INSERT INTO `region` VALUES (163, '松原市', 2, 7);
INSERT INTO `region` VALUES (164, '白城市', 2, 7);
INSERT INTO `region` VALUES (165, '延边朝鲜族自治州', 2, 7);
INSERT INTO `region` VALUES (166, '南关区', 3, 146);
INSERT INTO `region` VALUES (167, '宽城区', 3, 146);
INSERT INTO `region` VALUES (168, '朝阳区', 3, 146);
INSERT INTO `region` VALUES (169, '二道区', 3, 146);
INSERT INTO `region` VALUES (170, '绿园区', 3, 146);
INSERT INTO `region` VALUES (171, '双阳区', 3, 146);
INSERT INTO `region` VALUES (172, '九台区', 3, 146);
INSERT INTO `region` VALUES (173, '农安县', 3, 146);
INSERT INTO `region` VALUES (174, '榆树市', 3, 146);
INSERT INTO `region` VALUES (175, '德惠市', 3, 146);
INSERT INTO `region` VALUES (176, '公主岭市', 3, 146);
INSERT INTO `region` VALUES (177, '哈尔滨市', 2, 8);
INSERT INTO `region` VALUES (178, '齐齐哈尔市', 2, 8);
INSERT INTO `region` VALUES (179, '鸡西市', 2, 8);
INSERT INTO `region` VALUES (180, '鹤岗市', 2, 8);
INSERT INTO `region` VALUES (181, '双鸭山市', 2, 8);
INSERT INTO `region` VALUES (182, '大庆市', 2, 8);
INSERT INTO `region` VALUES (183, '伊春市', 2, 8);
INSERT INTO `region` VALUES (184, '佳木斯市', 2, 8);
INSERT INTO `region` VALUES (185, '七台河市', 2, 8);
INSERT INTO `region` VALUES (186, '牡丹江市', 2, 8);
INSERT INTO `region` VALUES (187, '黑河市', 2, 8);
INSERT INTO `region` VALUES (188, '绥化市', 2, 8);
INSERT INTO `region` VALUES (189, '大兴安岭地区', 2, 8);
INSERT INTO `region` VALUES (190, '道里区', 3, 169);
INSERT INTO `region` VALUES (191, '南岗区', 3, 169);
INSERT INTO `region` VALUES (192, '道外区', 3, 169);
INSERT INTO `region` VALUES (193, '平房区', 3, 169);
INSERT INTO `region` VALUES (194, '松北区', 3, 169);
INSERT INTO `region` VALUES (195, '香坊区', 3, 169);
INSERT INTO `region` VALUES (196, '呼兰区', 3, 169);
INSERT INTO `region` VALUES (197, '阿城区', 3, 169);
INSERT INTO `region` VALUES (198, '双城区', 3, 169);
INSERT INTO `region` VALUES (199, '依兰县', 3, 169);
INSERT INTO `region` VALUES (200, '方正县', 3, 169);
INSERT INTO `region` VALUES (201, '宾县', 3, 169);
INSERT INTO `region` VALUES (202, '巴彦县', 3, 169);
INSERT INTO `region` VALUES (203, '木兰县', 3, 169);
INSERT INTO `region` VALUES (204, '通河县', 3, 169);
INSERT INTO `region` VALUES (205, '延寿县', 3, 169);
INSERT INTO `region` VALUES (206, '尚志市', 3, 169);
INSERT INTO `region` VALUES (207, '五常市', 3, 169);
INSERT INTO `region` VALUES (208, '黄浦区', 2, 9);
INSERT INTO `region` VALUES (209, '徐汇区', 2, 9);
INSERT INTO `region` VALUES (210, '长宁区', 2, 9);
INSERT INTO `region` VALUES (211, '静安区', 2, 9);
INSERT INTO `region` VALUES (212, '普陀区', 2, 9);
INSERT INTO `region` VALUES (213, '虹口区', 2, 9);
INSERT INTO `region` VALUES (214, '杨浦区', 2, 9);
INSERT INTO `region` VALUES (215, '闵行区', 2, 9);
INSERT INTO `region` VALUES (216, '宝山区', 2, 9);
INSERT INTO `region` VALUES (217, '嘉定区', 2, 9);
INSERT INTO `region` VALUES (218, '浦东新区', 2, 9);
INSERT INTO `region` VALUES (219, '金山区', 2, 9);
INSERT INTO `region` VALUES (220, '松江区', 2, 9);
INSERT INTO `region` VALUES (221, '青浦区', 2, 9);
INSERT INTO `region` VALUES (222, '奉贤区', 2, 9);
INSERT INTO `region` VALUES (223, '崇明区', 2, 9);
INSERT INTO `region` VALUES (224, '南京市', 2, 10);
INSERT INTO `region` VALUES (225, '无锡市', 2, 10);
INSERT INTO `region` VALUES (226, '徐州市', 2, 10);
INSERT INTO `region` VALUES (227, '常州市', 2, 10);
INSERT INTO `region` VALUES (228, '苏州市', 2, 10);
INSERT INTO `region` VALUES (229, '南通市', 2, 10);
INSERT INTO `region` VALUES (230, '连云港市', 2, 10);
INSERT INTO `region` VALUES (231, '淮安市', 2, 10);
INSERT INTO `region` VALUES (232, '盐城市', 2, 10);
INSERT INTO `region` VALUES (233, '扬州市', 2, 10);
INSERT INTO `region` VALUES (234, '镇江市', 2, 10);
INSERT INTO `region` VALUES (235, '泰州市', 2, 10);
INSERT INTO `region` VALUES (236, '宿迁市', 2, 10);
INSERT INTO `region` VALUES (237, '玄武区', 3, 219);
INSERT INTO `region` VALUES (238, '秦淮区', 3, 219);
INSERT INTO `region` VALUES (239, '建邺区', 3, 219);
INSERT INTO `region` VALUES (240, '鼓楼区', 3, 219);
INSERT INTO `region` VALUES (241, '浦口区', 3, 219);
INSERT INTO `region` VALUES (242, '栖霞区', 3, 219);
INSERT INTO `region` VALUES (243, '雨花台区', 3, 219);
INSERT INTO `region` VALUES (244, '江宁区', 3, 219);
INSERT INTO `region` VALUES (245, '六合区', 3, 219);
INSERT INTO `region` VALUES (246, '溧水区', 3, 219);
INSERT INTO `region` VALUES (247, '高淳区', 3, 219);
INSERT INTO `region` VALUES (248, '杭州市', 2, 11);
INSERT INTO `region` VALUES (249, '宁波市', 2, 11);
INSERT INTO `region` VALUES (250, '温州市', 2, 11);
INSERT INTO `region` VALUES (251, '嘉兴市', 2, 11);
INSERT INTO `region` VALUES (252, '湖州市', 2, 11);
INSERT INTO `region` VALUES (253, '绍兴市', 2, 11);
INSERT INTO `region` VALUES (254, '金华市', 2, 11);
INSERT INTO `region` VALUES (255, '衢州市', 2, 11);
INSERT INTO `region` VALUES (256, '舟山市', 2, 11);
INSERT INTO `region` VALUES (257, '台州市', 2, 11);
INSERT INTO `region` VALUES (258, '丽水市', 2, 11);
INSERT INTO `region` VALUES (259, '上城区', 3, 243);
INSERT INTO `region` VALUES (260, '拱墅区', 3, 243);
INSERT INTO `region` VALUES (261, '西湖区', 3, 243);
INSERT INTO `region` VALUES (262, '滨江区', 3, 243);
INSERT INTO `region` VALUES (263, '萧山区', 3, 243);
INSERT INTO `region` VALUES (264, '余杭区', 3, 243);
INSERT INTO `region` VALUES (265, '富阳区', 3, 243);
INSERT INTO `region` VALUES (266, '临安区', 3, 243);
INSERT INTO `region` VALUES (267, '临平区', 3, 243);
INSERT INTO `region` VALUES (268, '钱塘区', 3, 243);
INSERT INTO `region` VALUES (269, '桐庐县', 3, 243);
INSERT INTO `region` VALUES (270, '淳安县', 3, 243);
INSERT INTO `region` VALUES (271, '建德市', 3, 243);
INSERT INTO `region` VALUES (272, '合肥市', 2, 12);
INSERT INTO `region` VALUES (273, '芜湖市', 2, 12);
INSERT INTO `region` VALUES (274, '蚌埠市', 2, 12);
INSERT INTO `region` VALUES (275, '淮南市', 2, 12);
INSERT INTO `region` VALUES (276, '马鞍山市', 2, 12);
INSERT INTO `region` VALUES (277, '淮北市', 2, 12);
INSERT INTO `region` VALUES (278, '铜陵市', 2, 12);
INSERT INTO `region` VALUES (279, '安庆市', 2, 12);
INSERT INTO `region` VALUES (280, '黄山市', 2, 12);
INSERT INTO `region` VALUES (281, '滁州市', 2, 12);
INSERT INTO `region` VALUES (282, '阜阳市', 2, 12);
INSERT INTO `region` VALUES (283, '宿州市', 2, 12);
INSERT INTO `region` VALUES (284, '六安市', 2, 12);
INSERT INTO `region` VALUES (285, '亳州市', 2, 12);
INSERT INTO `region` VALUES (286, '池州市', 2, 12);
INSERT INTO `region` VALUES (287, '宣城市', 2, 12);
INSERT INTO `region` VALUES (288, '瑶海区', 3, 268);
INSERT INTO `region` VALUES (289, '庐阳区', 3, 268);
INSERT INTO `region` VALUES (290, '蜀山区', 3, 268);
INSERT INTO `region` VALUES (291, '包河区', 3, 268);
INSERT INTO `region` VALUES (292, '长丰县', 3, 268);
INSERT INTO `region` VALUES (293, '肥东县', 3, 268);
INSERT INTO `region` VALUES (294, '肥西县', 3, 268);
INSERT INTO `region` VALUES (295, '庐江县', 3, 268);
INSERT INTO `region` VALUES (296, '巢湖市', 3, 268);
INSERT INTO `region` VALUES (297, '福州市', 2, 13);
INSERT INTO `region` VALUES (298, '厦门市', 2, 13);
INSERT INTO `region` VALUES (299, '莆田市', 2, 13);
INSERT INTO `region` VALUES (300, '三明市', 2, 13);
INSERT INTO `region` VALUES (301, '泉州市', 2, 13);
INSERT INTO `region` VALUES (302, '漳州市', 2, 13);
INSERT INTO `region` VALUES (303, '南平市', 2, 13);
INSERT INTO `region` VALUES (304, '龙岩市', 2, 13);
INSERT INTO `region` VALUES (305, '宁德市', 2, 13);
INSERT INTO `region` VALUES (306, '鼓楼区', 3, 287);
INSERT INTO `region` VALUES (307, '台江区', 3, 287);
INSERT INTO `region` VALUES (308, '仓山区', 3, 287);
INSERT INTO `region` VALUES (309, '马尾区', 3, 287);
INSERT INTO `region` VALUES (310, '晋安区', 3, 287);
INSERT INTO `region` VALUES (311, '长乐区', 3, 287);
INSERT INTO `region` VALUES (312, '闽侯县', 3, 287);
INSERT INTO `region` VALUES (313, '连江县', 3, 287);
INSERT INTO `region` VALUES (314, '罗源县', 3, 287);
INSERT INTO `region` VALUES (315, '闽清县', 3, 287);
INSERT INTO `region` VALUES (316, '永泰县', 3, 287);
INSERT INTO `region` VALUES (317, '平潭县', 3, 287);
INSERT INTO `region` VALUES (318, '福清市', 3, 287);
INSERT INTO `region` VALUES (319, '南昌市', 2, 14);
INSERT INTO `region` VALUES (320, '景德镇市', 2, 14);
INSERT INTO `region` VALUES (321, '萍乡市', 2, 14);
INSERT INTO `region` VALUES (322, '九江市', 2, 14);
INSERT INTO `region` VALUES (323, '新余市', 2, 14);
INSERT INTO `region` VALUES (324, '鹰潭市', 2, 14);
INSERT INTO `region` VALUES (325, '赣州市', 2, 14);
INSERT INTO `region` VALUES (326, '吉安市', 2, 14);
INSERT INTO `region` VALUES (327, '宜春市', 2, 14);
INSERT INTO `region` VALUES (328, '抚州市', 2, 14);
INSERT INTO `region` VALUES (329, '上饶市', 2, 14);
INSERT INTO `region` VALUES (330, '东湖区', 3, 309);
INSERT INTO `region` VALUES (331, '西湖区', 3, 309);
INSERT INTO `region` VALUES (332, '青云谱区', 3, 309);
INSERT INTO `region` VALUES (333, '青山湖区', 3, 309);
INSERT INTO `region` VALUES (334, '新建区', 3, 309);
INSERT INTO `region` VALUES (335, '红谷滩区', 3, 309);
INSERT INTO `region` VALUES (336, '南昌县', 3, 309);
INSERT INTO `region` VALUES (337, '安义县', 3, 309);
INSERT INTO `region` VALUES (338, '进贤县', 3, 309);
INSERT INTO `region` VALUES (339, '济南市', 2, 15);
INSERT INTO `region` VALUES (340, '青岛市', 2, 15);
INSERT INTO `region` VALUES (341, '淄博市', 2, 15);
INSERT INTO `region` VALUES (342, '枣庄市', 2, 15);
INSERT INTO `region` VALUES (343, '东营市', 2, 15);
INSERT INTO `region` VALUES (344, '烟台市', 2, 15);
INSERT INTO `region` VALUES (345, '潍坊市', 2, 15);
INSERT INTO `region` VALUES (346, '济宁市', 2, 15);
INSERT INTO `region` VALUES (347, '泰安市', 2, 15);
INSERT INTO `region` VALUES (348, '威海市', 2, 15);
INSERT INTO `region` VALUES (349, '日照市', 2, 15);
INSERT INTO `region` VALUES (350, '临沂市', 2, 15);
INSERT INTO `region` VALUES (351, '德州市', 2, 15);
INSERT INTO `region` VALUES (352, '聊城市', 2, 15);
INSERT INTO `region` VALUES (353, '滨州市', 2, 15);
INSERT INTO `region` VALUES (354, '菏泽市', 2, 15);
INSERT INTO `region` VALUES (355, '历下区', 3, 331);
INSERT INTO `region` VALUES (356, '市中区', 3, 331);
INSERT INTO `region` VALUES (357, '槐荫区', 3, 331);
INSERT INTO `region` VALUES (358, '天桥区', 3, 331);
INSERT INTO `region` VALUES (359, '历城区', 3, 331);
INSERT INTO `region` VALUES (360, '长清区', 3, 331);
INSERT INTO `region` VALUES (361, '章丘区', 3, 331);
INSERT INTO `region` VALUES (362, '济阳区', 3, 331);
INSERT INTO `region` VALUES (363, '莱芜区', 3, 331);
INSERT INTO `region` VALUES (364, '钢城区', 3, 331);
INSERT INTO `region` VALUES (365, '平阴县', 3, 331);
INSERT INTO `region` VALUES (366, '商河县', 3, 331);
INSERT INTO `region` VALUES (367, '郑州市', 2, 16);
INSERT INTO `region` VALUES (368, '开封市', 2, 16);
INSERT INTO `region` VALUES (369, '洛阳市', 2, 16);
INSERT INTO `region` VALUES (370, '平顶山市', 2, 16);
INSERT INTO `region` VALUES (371, '安阳市', 2, 16);
INSERT INTO `region` VALUES (372, '鹤壁市', 2, 16);
INSERT INTO `region` VALUES (373, '新乡市', 2, 16);
INSERT INTO `region` VALUES (374, '焦作市', 2, 16);
INSERT INTO `region` VALUES (375, '濮阳市', 2, 16);
INSERT INTO `region` VALUES (376, '许昌市', 2, 16);
INSERT INTO `region` VALUES (377, '漯河市', 2, 16);
INSERT INTO `region` VALUES (378, '三门峡市', 2, 16);
INSERT INTO `region` VALUES (379, '南阳市', 2, 16);
INSERT INTO `region` VALUES (380, '商丘市', 2, 16);
INSERT INTO `region` VALUES (381, '信阳市', 2, 16);
INSERT INTO `region` VALUES (382, '周口市', 2, 16);
INSERT INTO `region` VALUES (383, '驻马店市', 2, 16);
INSERT INTO `region` VALUES (384, '中原区', 3, 360);
INSERT INTO `region` VALUES (385, '二七区', 3, 360);
INSERT INTO `region` VALUES (386, '管城回族区', 3, 360);
INSERT INTO `region` VALUES (387, '金水区', 3, 360);
INSERT INTO `region` VALUES (388, '上街区', 3, 360);
INSERT INTO `region` VALUES (389, '惠济区', 3, 360);
INSERT INTO `region` VALUES (390, '中牟县', 3, 360);
INSERT INTO `region` VALUES (391, '巩义市', 3, 360);
INSERT INTO `region` VALUES (392, '荥阳市', 3, 360);
INSERT INTO `region` VALUES (393, '新密市', 3, 360);
INSERT INTO `region` VALUES (394, '新郑市', 3, 360);
INSERT INTO `region` VALUES (395, '登封市', 3, 360);
INSERT INTO `region` VALUES (396, '武汉市', 2, 17);
INSERT INTO `region` VALUES (397, '黄石市', 2, 17);
INSERT INTO `region` VALUES (398, '十堰市', 2, 17);
INSERT INTO `region` VALUES (399, '宜昌市', 2, 17);
INSERT INTO `region` VALUES (400, '襄阳市', 2, 17);
INSERT INTO `region` VALUES (401, '鄂州市', 2, 17);
INSERT INTO `region` VALUES (402, '荆门市', 2, 17);
INSERT INTO `region` VALUES (403, '孝感市', 2, 17);
INSERT INTO `region` VALUES (404, '荆州市', 2, 17);
INSERT INTO `region` VALUES (405, '黄冈市', 2, 17);
INSERT INTO `region` VALUES (406, '咸宁市', 2, 17);
INSERT INTO `region` VALUES (407, '随州市', 2, 17);
INSERT INTO `region` VALUES (408, '恩施土家族苗族自治州', 2, 17);
INSERT INTO `region` VALUES (409, '江岸区', 3, 390);
INSERT INTO `region` VALUES (410, '江汉区', 3, 390);
INSERT INTO `region` VALUES (411, '硚口区', 3, 390);
INSERT INTO `region` VALUES (412, '汉阳区', 3, 390);
INSERT INTO `region` VALUES (413, '武昌区', 3, 390);
INSERT INTO `region` VALUES (414, '青山区', 3, 390);
INSERT INTO `region` VALUES (415, '洪山区', 3, 390);
INSERT INTO `region` VALUES (416, '东西湖区', 3, 390);
INSERT INTO `region` VALUES (417, '汉南区', 3, 390);
INSERT INTO `region` VALUES (418, '蔡甸区', 3, 390);
INSERT INTO `region` VALUES (419, '江夏区', 3, 390);
INSERT INTO `region` VALUES (420, '黄陂区', 3, 390);
INSERT INTO `region` VALUES (421, '新洲区', 3, 390);
INSERT INTO `region` VALUES (422, '长沙市', 2, 18);
INSERT INTO `region` VALUES (423, '株洲市', 2, 18);
INSERT INTO `region` VALUES (424, '湘潭市', 2, 18);
INSERT INTO `region` VALUES (425, '衡阳市', 2, 18);
INSERT INTO `region` VALUES (426, '邵阳市', 2, 18);
INSERT INTO `region` VALUES (427, '岳阳市', 2, 18);
INSERT INTO `region` VALUES (428, '常德市', 2, 18);
INSERT INTO `region` VALUES (429, '张家界市', 2, 18);
INSERT INTO `region` VALUES (430, '益阳市', 2, 18);
INSERT INTO `region` VALUES (431, '郴州市', 2, 18);
INSERT INTO `region` VALUES (432, '永州市', 2, 18);
INSERT INTO `region` VALUES (433, '怀化市', 2, 18);
INSERT INTO `region` VALUES (434, '娄底市', 2, 18);
INSERT INTO `region` VALUES (435, '湘西土家族苗族自治州', 2, 18);
INSERT INTO `region` VALUES (436, '芙蓉区', 3, 416);
INSERT INTO `region` VALUES (437, '天心区', 3, 416);
INSERT INTO `region` VALUES (438, '岳麓区', 3, 416);
INSERT INTO `region` VALUES (439, '开福区', 3, 416);
INSERT INTO `region` VALUES (440, '雨花区', 3, 416);
INSERT INTO `region` VALUES (441, '望城区', 3, 416);
INSERT INTO `region` VALUES (442, '长沙县', 3, 416);
INSERT INTO `region` VALUES (443, '浏阳市', 3, 416);
INSERT INTO `region` VALUES (444, '宁乡市', 3, 416);
INSERT INTO `region` VALUES (445, '广州市', 2, 19);
INSERT INTO `region` VALUES (446, '韶关市', 2, 19);
INSERT INTO `region` VALUES (447, '深圳市', 2, 19);
INSERT INTO `region` VALUES (448, '珠海市', 2, 19);
INSERT INTO `region` VALUES (449, '汕头市', 2, 19);
INSERT INTO `region` VALUES (450, '佛山市', 2, 19);
INSERT INTO `region` VALUES (451, '江门市', 2, 19);
INSERT INTO `region` VALUES (452, '湛江市', 2, 19);
INSERT INTO `region` VALUES (453, '茂名市', 2, 19);
INSERT INTO `region` VALUES (454, '肇庆市', 2, 19);
INSERT INTO `region` VALUES (455, '惠州市', 2, 19);
INSERT INTO `region` VALUES (456, '梅州市', 2, 19);
INSERT INTO `region` VALUES (457, '汕尾市', 2, 19);
INSERT INTO `region` VALUES (458, '河源市', 2, 19);
INSERT INTO `region` VALUES (459, '阳江市', 2, 19);
INSERT INTO `region` VALUES (460, '清远市', 2, 19);
INSERT INTO `region` VALUES (461, '东莞市', 2, 19);
INSERT INTO `region` VALUES (462, '中山市', 2, 19);
INSERT INTO `region` VALUES (463, '潮州市', 2, 19);
INSERT INTO `region` VALUES (464, '揭阳市', 2, 19);
INSERT INTO `region` VALUES (465, '云浮市', 2, 19);
INSERT INTO `region` VALUES (466, '荔湾区', 3, 443);
INSERT INTO `region` VALUES (467, '越秀区', 3, 443);
INSERT INTO `region` VALUES (468, '海珠区', 3, 443);
INSERT INTO `region` VALUES (469, '天河区', 3, 443);
INSERT INTO `region` VALUES (470, '白云区', 3, 443);
INSERT INTO `region` VALUES (471, '黄埔区', 3, 443);
INSERT INTO `region` VALUES (472, '番禺区', 3, 443);
INSERT INTO `region` VALUES (473, '花都区', 3, 443);
INSERT INTO `region` VALUES (474, '南沙区', 3, 443);
INSERT INTO `region` VALUES (475, '从化区', 3, 443);
INSERT INTO `region` VALUES (476, '增城区', 3, 443);
INSERT INTO `region` VALUES (477, '南宁市', 2, 20);
INSERT INTO `region` VALUES (478, '柳州市', 2, 20);
INSERT INTO `region` VALUES (479, '桂林市', 2, 20);
INSERT INTO `region` VALUES (480, '梧州市', 2, 20);
INSERT INTO `region` VALUES (481, '北海市', 2, 20);
INSERT INTO `region` VALUES (482, '防城港市', 2, 20);
INSERT INTO `region` VALUES (483, '钦州市', 2, 20);
INSERT INTO `region` VALUES (484, '贵港市', 2, 20);
INSERT INTO `region` VALUES (485, '玉林市', 2, 20);
INSERT INTO `region` VALUES (486, '百色市', 2, 20);
INSERT INTO `region` VALUES (487, '贺州市', 2, 20);
INSERT INTO `region` VALUES (488, '河池市', 2, 20);
INSERT INTO `region` VALUES (489, '来宾市', 2, 20);
INSERT INTO `region` VALUES (490, '崇左市', 2, 20);
INSERT INTO `region` VALUES (491, '兴宁区', 3, 477);
INSERT INTO `region` VALUES (492, '青秀区', 3, 477);
INSERT INTO `region` VALUES (493, '江南区', 3, 477);
INSERT INTO `region` VALUES (494, '西乡塘区', 3, 477);
INSERT INTO `region` VALUES (495, '良庆区', 3, 477);
INSERT INTO `region` VALUES (496, '邕宁区', 3, 477);
INSERT INTO `region` VALUES (497, '武鸣区', 3, 477);
INSERT INTO `region` VALUES (498, '隆安县', 3, 477);
INSERT INTO `region` VALUES (499, '马山县', 3, 477);
INSERT INTO `region` VALUES (500, '上林县', 3, 477);
INSERT INTO `region` VALUES (501, '宾阳县', 3, 477);
INSERT INTO `region` VALUES (502, '横州市', 3, 477);
INSERT INTO `region` VALUES (503, '海口市', 2, 21);
INSERT INTO `region` VALUES (504, '三亚市', 2, 21);
INSERT INTO `region` VALUES (505, '三沙市', 2, 21);
INSERT INTO `region` VALUES (506, '儋州市', 2, 21);
INSERT INTO `region` VALUES (507, '五指山市', 2, 21);
INSERT INTO `region` VALUES (508, '琼海市', 2, 21);
INSERT INTO `region` VALUES (509, '文昌市', 2, 21);
INSERT INTO `region` VALUES (510, '万宁市', 2, 21);
INSERT INTO `region` VALUES (511, '东方市', 2, 21);
INSERT INTO `region` VALUES (512, '定安县', 2, 21);
INSERT INTO `region` VALUES (513, '屯昌县', 2, 21);
INSERT INTO `region` VALUES (514, '澄迈县', 2, 21);
INSERT INTO `region` VALUES (515, '临高县', 2, 21);
INSERT INTO `region` VALUES (516, '白沙黎族自治县', 2, 21);
INSERT INTO `region` VALUES (517, '昌江黎族自治县', 2, 21);
INSERT INTO `region` VALUES (518, '乐东黎族自治县', 2, 21);
INSERT INTO `region` VALUES (519, '陵水黎族自治县', 2, 21);
INSERT INTO `region` VALUES (520, '保亭黎族苗族自治县', 2, 21);
INSERT INTO `region` VALUES (521, '琼中黎族苗族自治县', 2, 21);
INSERT INTO `region` VALUES (522, '秀英区', 3, 504);
INSERT INTO `region` VALUES (523, '龙华区', 3, 504);
INSERT INTO `region` VALUES (524, '琼山区', 3, 504);
INSERT INTO `region` VALUES (525, '美兰区', 3, 504);
INSERT INTO `region` VALUES (526, '万州区', 2, 22);
INSERT INTO `region` VALUES (527, '涪陵区', 2, 22);
INSERT INTO `region` VALUES (528, '渝中区', 2, 22);
INSERT INTO `region` VALUES (529, '大渡口区', 2, 22);
INSERT INTO `region` VALUES (530, '江北区', 2, 22);
INSERT INTO `region` VALUES (531, '沙坪坝区', 2, 22);
INSERT INTO `region` VALUES (532, '九龙坡区', 2, 22);
INSERT INTO `region` VALUES (533, '南岸区', 2, 22);
INSERT INTO `region` VALUES (534, '北碚区', 2, 22);
INSERT INTO `region` VALUES (535, '綦江区', 2, 22);
INSERT INTO `region` VALUES (536, '大足区', 2, 22);
INSERT INTO `region` VALUES (537, '渝北区', 2, 22);
INSERT INTO `region` VALUES (538, '巴南区', 2, 22);
INSERT INTO `region` VALUES (539, '黔江区', 2, 22);
INSERT INTO `region` VALUES (540, '长寿区', 2, 22);
INSERT INTO `region` VALUES (541, '江津区', 2, 22);
INSERT INTO `region` VALUES (542, '合川区', 2, 22);
INSERT INTO `region` VALUES (543, '永川区', 2, 22);
INSERT INTO `region` VALUES (544, '南川区', 2, 22);
INSERT INTO `region` VALUES (545, '璧山区', 2, 22);
INSERT INTO `region` VALUES (546, '铜梁区', 2, 22);
INSERT INTO `region` VALUES (547, '潼南区', 2, 22);
INSERT INTO `region` VALUES (548, '荣昌区', 2, 22);
INSERT INTO `region` VALUES (549, '开州区', 2, 22);
INSERT INTO `region` VALUES (550, '梁平区', 2, 22);
INSERT INTO `region` VALUES (551, '武隆区', 2, 22);
INSERT INTO `region` VALUES (552, '解放碑街道', 3, 526);
INSERT INTO `region` VALUES (553, '朝天门街道', 3, 526);
INSERT INTO `region` VALUES (554, '七星岗街道', 3, 526);
INSERT INTO `region` VALUES (555, '菜园坝街道', 3, 526);
INSERT INTO `region` VALUES (556, '南纪门街道', 3, 526);
INSERT INTO `region` VALUES (557, '成都市', 2, 23);
INSERT INTO `region` VALUES (558, '自贡市', 2, 23);
INSERT INTO `region` VALUES (559, '攀枝花市', 2, 23);
INSERT INTO `region` VALUES (560, '泸州市', 2, 23);
INSERT INTO `region` VALUES (561, '德阳市', 2, 23);
INSERT INTO `region` VALUES (562, '绵阳市', 2, 23);
INSERT INTO `region` VALUES (563, '广元市', 2, 23);
INSERT INTO `region` VALUES (564, '遂宁市', 2, 23);
INSERT INTO `region` VALUES (565, '内江市', 2, 23);
INSERT INTO `region` VALUES (566, '乐山市', 2, 23);
INSERT INTO `region` VALUES (567, '南充市', 2, 23);
INSERT INTO `region` VALUES (568, '眉山市', 2, 23);
INSERT INTO `region` VALUES (569, '宜宾市', 2, 23);
INSERT INTO `region` VALUES (570, '广安市', 2, 23);
INSERT INTO `region` VALUES (571, '达州市', 2, 23);
INSERT INTO `region` VALUES (572, '雅安市', 2, 23);
INSERT INTO `region` VALUES (573, '巴中市', 2, 23);
INSERT INTO `region` VALUES (574, '资阳市', 2, 23);
INSERT INTO `region` VALUES (575, '阿坝藏族羌族自治州', 2, 23);
INSERT INTO `region` VALUES (576, '甘孜藏族自治州', 2, 23);
INSERT INTO `region` VALUES (577, '凉山彝族自治州', 2, 23);
INSERT INTO `region` VALUES (578, '锦江区', 3, 585);
INSERT INTO `region` VALUES (579, '青羊区', 3, 585);
INSERT INTO `region` VALUES (580, '金牛区', 3, 585);
INSERT INTO `region` VALUES (581, '武侯区', 3, 585);
INSERT INTO `region` VALUES (582, '成华区', 3, 585);
INSERT INTO `region` VALUES (583, '龙泉驿区', 3, 585);
INSERT INTO `region` VALUES (584, '青白江区', 3, 585);
INSERT INTO `region` VALUES (585, '新都区', 3, 585);
INSERT INTO `region` VALUES (586, '温江区', 3, 585);
INSERT INTO `region` VALUES (587, '双流区', 3, 585);
INSERT INTO `region` VALUES (588, '郫都区', 3, 585);
INSERT INTO `region` VALUES (589, '新津区', 3, 585);
INSERT INTO `region` VALUES (590, '金堂县', 3, 585);
INSERT INTO `region` VALUES (591, '大邑县', 3, 585);
INSERT INTO `region` VALUES (592, '蒲江县', 3, 585);
INSERT INTO `region` VALUES (593, '都江堰市', 3, 585);
INSERT INTO `region` VALUES (594, '彭州市', 3, 585);
INSERT INTO `region` VALUES (595, '邛崃市', 3, 585);
INSERT INTO `region` VALUES (596, '崇州市', 3, 585);
INSERT INTO `region` VALUES (597, '简阳市', 3, 585);
INSERT INTO `region` VALUES (598, '贵阳市', 2, 24);
INSERT INTO `region` VALUES (599, '六盘水市', 2, 24);
INSERT INTO `region` VALUES (600, '遵义市', 2, 24);
INSERT INTO `region` VALUES (601, '安顺市', 2, 24);
INSERT INTO `region` VALUES (602, '毕节市', 2, 24);
INSERT INTO `region` VALUES (603, '铜仁市', 2, 24);
INSERT INTO `region` VALUES (604, '黔西南布依族苗族自治州', 2, 24);
INSERT INTO `region` VALUES (605, '黔东南苗族侗族自治州', 2, 24);
INSERT INTO `region` VALUES (606, '黔南布依族苗族自治州', 2, 24);
INSERT INTO `region` VALUES (607, '南明区', 3, 629);
INSERT INTO `region` VALUES (608, '云岩区', 3, 629);
INSERT INTO `region` VALUES (609, '花溪区', 3, 629);
INSERT INTO `region` VALUES (610, '乌当区', 3, 629);
INSERT INTO `region` VALUES (611, '白云区', 3, 629);
INSERT INTO `region` VALUES (612, '观山湖区', 3, 629);
INSERT INTO `region` VALUES (613, '开阳县', 3, 629);
INSERT INTO `region` VALUES (614, '息烽县', 3, 629);
INSERT INTO `region` VALUES (615, '修文县', 3, 629);
INSERT INTO `region` VALUES (616, '清镇市', 3, 629);
INSERT INTO `region` VALUES (617, '昆明市', 2, 25);
INSERT INTO `region` VALUES (618, '曲靖市', 2, 25);
INSERT INTO `region` VALUES (619, '玉溪市', 2, 25);
INSERT INTO `region` VALUES (620, '保山市', 2, 25);
INSERT INTO `region` VALUES (621, '昭通市', 2, 25);
INSERT INTO `region` VALUES (622, '丽江市', 2, 25);
INSERT INTO `region` VALUES (623, '普洱市', 2, 25);
INSERT INTO `region` VALUES (624, '临沧市', 2, 25);
INSERT INTO `region` VALUES (625, '楚雄彝族自治州', 2, 25);
INSERT INTO `region` VALUES (626, '红河哈尼族彝族自治州', 2, 25);
INSERT INTO `region` VALUES (627, '文山壮族苗族自治州', 2, 25);
INSERT INTO `region` VALUES (628, '西双版纳傣族自治州', 2, 25);
INSERT INTO `region` VALUES (629, '大理白族自治州', 2, 25);
INSERT INTO `region` VALUES (630, '德宏傣族景颇族自治州', 2, 25);
INSERT INTO `region` VALUES (631, '怒江傈僳族自治州', 2, 25);
INSERT INTO `region` VALUES (632, '迪庆藏族自治州', 2, 25);
INSERT INTO `region` VALUES (633, '五华区', 3, 652);
INSERT INTO `region` VALUES (634, '盘龙区', 3, 652);
INSERT INTO `region` VALUES (635, '官渡区', 3, 652);
INSERT INTO `region` VALUES (636, '西山区', 3, 652);
INSERT INTO `region` VALUES (637, '东川区', 3, 652);
INSERT INTO `region` VALUES (638, '呈贡区', 3, 652);
INSERT INTO `region` VALUES (639, '晋宁区', 3, 652);
INSERT INTO `region` VALUES (640, '富民县', 3, 652);
INSERT INTO `region` VALUES (641, '宜良县', 3, 652);
INSERT INTO `region` VALUES (642, '石林彝族自治县', 3, 652);
INSERT INTO `region` VALUES (643, '嵩明县', 3, 652);
INSERT INTO `region` VALUES (644, '禄劝彝族苗族自治县', 3, 652);
INSERT INTO `region` VALUES (645, '寻甸回族彝族自治县', 3, 652);
INSERT INTO `region` VALUES (646, '安宁市', 3, 652);
INSERT INTO `region` VALUES (647, '拉萨市', 2, 26);
INSERT INTO `region` VALUES (648, '日喀则市', 2, 26);
INSERT INTO `region` VALUES (649, '昌都市', 2, 26);
INSERT INTO `region` VALUES (650, '林芝市', 2, 26);
INSERT INTO `region` VALUES (651, '山南市', 2, 26);
INSERT INTO `region` VALUES (652, '那曲市', 2, 26);
INSERT INTO `region` VALUES (653, '阿里地区', 2, 26);
INSERT INTO `region` VALUES (654, '城关区', 3, 682);
INSERT INTO `region` VALUES (655, '堆龙德庆区', 3, 682);
INSERT INTO `region` VALUES (656, '达孜区', 3, 682);
INSERT INTO `region` VALUES (657, '林周县', 3, 682);
INSERT INTO `region` VALUES (658, '当雄县', 3, 682);
INSERT INTO `region` VALUES (659, '尼木县', 3, 682);
INSERT INTO `region` VALUES (660, '曲水县', 3, 682);
INSERT INTO `region` VALUES (661, '墨竹工卡县', 3, 682);
INSERT INTO `region` VALUES (662, '西安市', 2, 27);
INSERT INTO `region` VALUES (663, '铜川市', 2, 27);
INSERT INTO `region` VALUES (664, '宝鸡市', 2, 27);
INSERT INTO `region` VALUES (665, '咸阳市', 2, 27);
INSERT INTO `region` VALUES (666, '渭南市', 2, 27);
INSERT INTO `region` VALUES (667, '延安市', 2, 27);
INSERT INTO `region` VALUES (668, '汉中市', 2, 27);
INSERT INTO `region` VALUES (669, '榆林市', 2, 27);
INSERT INTO `region` VALUES (670, '安康市', 2, 27);
INSERT INTO `region` VALUES (671, '商洛市', 2, 27);
INSERT INTO `region` VALUES (672, '新城区', 3, 703);
INSERT INTO `region` VALUES (673, '碑林区', 3, 703);
INSERT INTO `region` VALUES (674, '莲湖区', 3, 703);
INSERT INTO `region` VALUES (675, '灞桥区', 3, 703);
INSERT INTO `region` VALUES (676, '未央区', 3, 703);
INSERT INTO `region` VALUES (677, '雁塔区', 3, 703);
INSERT INTO `region` VALUES (678, '阎良区', 3, 703);
INSERT INTO `region` VALUES (679, '临潼区', 3, 703);
INSERT INTO `region` VALUES (680, '长安区', 3, 703);
INSERT INTO `region` VALUES (681, '高陵区', 3, 703);
INSERT INTO `region` VALUES (682, '鄠邑区', 3, 703);
INSERT INTO `region` VALUES (683, '蓝田县', 3, 703);
INSERT INTO `region` VALUES (684, '周至县', 3, 703);
INSERT INTO `region` VALUES (685, '兰州市', 2, 28);
INSERT INTO `region` VALUES (686, '嘉峪关市', 2, 28);
INSERT INTO `region` VALUES (687, '金昌市', 2, 28);
INSERT INTO `region` VALUES (688, '白银市', 2, 28);
INSERT INTO `region` VALUES (689, '天水市', 2, 28);
INSERT INTO `region` VALUES (690, '武威市', 2, 28);
INSERT INTO `region` VALUES (691, '张掖市', 2, 28);
INSERT INTO `region` VALUES (692, '平凉市', 2, 28);
INSERT INTO `region` VALUES (693, '酒泉市', 2, 28);
INSERT INTO `region` VALUES (694, '庆阳市', 2, 28);
INSERT INTO `region` VALUES (695, '定西市', 2, 28);
INSERT INTO `region` VALUES (696, '陇南市', 2, 28);
INSERT INTO `region` VALUES (697, '临夏回族自治州', 2, 28);
INSERT INTO `region` VALUES (698, '甘南藏族自治州', 2, 28);
INSERT INTO `region` VALUES (699, '城关区', 3, 729);
INSERT INTO `region` VALUES (700, '七里河区', 3, 729);
INSERT INTO `region` VALUES (701, '西固区', 3, 729);
INSERT INTO `region` VALUES (702, '安宁区', 3, 729);
INSERT INTO `region` VALUES (703, '红古区', 3, 729);
INSERT INTO `region` VALUES (704, '永登县', 3, 729);
INSERT INTO `region` VALUES (705, '皋兰县', 3, 729);
INSERT INTO `region` VALUES (706, '榆中县', 3, 729);
INSERT INTO `region` VALUES (707, '西宁市', 2, 29);
INSERT INTO `region` VALUES (708, '海东市', 2, 29);
INSERT INTO `region` VALUES (709, '海北藏族自治州', 2, 29);
INSERT INTO `region` VALUES (710, '黄南藏族自治州', 2, 29);
INSERT INTO `region` VALUES (711, '海南藏族自治州', 2, 29);
INSERT INTO `region` VALUES (712, '果洛藏族自治州', 2, 29);
INSERT INTO `region` VALUES (713, '玉树藏族自治州', 2, 29);
INSERT INTO `region` VALUES (714, '海西蒙古族藏族自治州', 2, 29);
INSERT INTO `region` VALUES (715, '城东区', 3, 750);
INSERT INTO `region` VALUES (716, '城中区', 3, 750);
INSERT INTO `region` VALUES (717, '城西区', 3, 750);
INSERT INTO `region` VALUES (718, '城北区', 3, 750);
INSERT INTO `region` VALUES (719, '湟中区', 3, 750);
INSERT INTO `region` VALUES (720, '大通回族土族自治县', 3, 750);
INSERT INTO `region` VALUES (721, '湟源县', 3, 750);
INSERT INTO `region` VALUES (722, '银川市', 2, 30);
INSERT INTO `region` VALUES (723, '石嘴山市', 2, 30);
INSERT INTO `region` VALUES (724, '吴忠市', 2, 30);
INSERT INTO `region` VALUES (725, '固原市', 2, 30);
INSERT INTO `region` VALUES (726, '中卫市', 2, 30);
INSERT INTO `region` VALUES (727, '兴庆区', 3, 770);
INSERT INTO `region` VALUES (728, '西夏区', 3, 770);
INSERT INTO `region` VALUES (729, '金凤区', 3, 770);
INSERT INTO `region` VALUES (730, '永宁县', 3, 770);
INSERT INTO `region` VALUES (731, '贺兰县', 3, 770);
INSERT INTO `region` VALUES (732, '灵武市', 3, 770);
INSERT INTO `region` VALUES (733, '乌鲁木齐市', 2, 31);
INSERT INTO `region` VALUES (734, '克拉玛依市', 2, 31);
INSERT INTO `region` VALUES (735, '吐鲁番市', 2, 31);
INSERT INTO `region` VALUES (736, '哈密市', 2, 31);
INSERT INTO `region` VALUES (737, '昌吉回族自治州', 2, 31);
INSERT INTO `region` VALUES (738, '博尔塔拉蒙古自治州', 2, 31);
INSERT INTO `region` VALUES (739, '巴音郭楞蒙古自治州', 2, 31);
INSERT INTO `region` VALUES (740, '阿克苏地区', 2, 31);
INSERT INTO `region` VALUES (741, '克孜勒苏柯尔克孜自治州', 2, 31);
INSERT INTO `region` VALUES (742, '喀什地区', 2, 31);
INSERT INTO `region` VALUES (743, '和田地区', 2, 31);
INSERT INTO `region` VALUES (744, '伊犁哈萨克自治州', 2, 31);
INSERT INTO `region` VALUES (745, '塔城地区', 2, 31);
INSERT INTO `region` VALUES (746, '阿勒泰地区', 2, 31);
INSERT INTO `region` VALUES (747, '天山区', 3, 788);
INSERT INTO `region` VALUES (748, '沙依巴克区', 3, 788);
INSERT INTO `region` VALUES (749, '新市区', 3, 788);
INSERT INTO `region` VALUES (750, '水磨沟区', 3, 788);
INSERT INTO `region` VALUES (751, '头屯河区', 3, 788);
INSERT INTO `region` VALUES (752, '达坂城区', 3, 788);
INSERT INTO `region` VALUES (753, '米东区', 3, 788);
INSERT INTO `region` VALUES (754, '乌鲁木齐县', 3, 788);
INSERT INTO `region` VALUES (755, '香港岛', 2, 32);
INSERT INTO `region` VALUES (756, '九龙', 2, 32);
INSERT INTO `region` VALUES (757, '新界', 2, 32);
INSERT INTO `region` VALUES (758, '中西区', 3, 813);
INSERT INTO `region` VALUES (759, '湾仔区', 3, 813);
INSERT INTO `region` VALUES (760, '东区', 3, 813);
INSERT INTO `region` VALUES (761, '南区', 3, 813);
INSERT INTO `region` VALUES (762, '澳门半岛', 2, 33);
INSERT INTO `region` VALUES (763, '氹仔岛', 2, 33);
INSERT INTO `region` VALUES (764, '路环岛', 2, 33);
INSERT INTO `region` VALUES (765, '花地玛堂区', 3, 820);
INSERT INTO `region` VALUES (766, '圣安多尼堂区', 3, 820);
INSERT INTO `region` VALUES (767, '大堂区', 3, 820);
INSERT INTO `region` VALUES (768, '望德堂区', 3, 820);
INSERT INTO `region` VALUES (769, '风顺堂区', 3, 820);
INSERT INTO `region` VALUES (770, '台北市', 2, 34);
INSERT INTO `region` VALUES (771, '高雄市', 2, 34);
INSERT INTO `region` VALUES (772, '基隆市', 2, 34);
INSERT INTO `region` VALUES (773, '台中市', 2, 34);
INSERT INTO `region` VALUES (774, '台南市', 2, 34);
INSERT INTO `region` VALUES (775, '新竹市', 2, 34);
INSERT INTO `region` VALUES (776, '嘉义市', 2, 34);
INSERT INTO `region` VALUES (777, '中正区', 3, 828);
INSERT INTO `region` VALUES (778, '大同区', 3, 828);
INSERT INTO `region` VALUES (779, '中山区', 3, 828);
INSERT INTO `region` VALUES (780, '松山区', 3, 828);
INSERT INTO `region` VALUES (781, '大安区', 3, 828);

-- ----------------------------
-- Table structure for scenic_spot
-- ----------------------------
DROP TABLE IF EXISTS `scenic_spot`;
CREATE TABLE `scenic_spot`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '景点ID，主键自增',
  `region_id` int(11) NULL DEFAULT NULL COMMENT '地区ID，外键，关联的是地区信息表',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '标题',
  `cover` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '封面',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL COMMENT '内容',
  `summary` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '摘要',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_region_id`(`region_id`) USING BTREE COMMENT '索引-地区ID',
  INDEX `idx_title`(`title`) USING BTREE COMMENT '索引-标题'
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '景点信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of scenic_spot
-- ----------------------------
INSERT INTO `scenic_spot` VALUES (7, 622, '景区配有专业讲解，非遗体验项目丰富，交通与食宿便利，是文化研学', 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=176879955100712.png', '<p>一、历史瑰宝：世界文化遗产的恢弘气势<br></p><p>故宫，旧称紫禁城，是世界上现存规模最大、保存最完整的木质结构古建筑群。这座建于明永乐四年（1406年）的皇家宫殿，历经明清两代24位皇帝，承载着中国近六百年的历史记忆。1987年，故宫被联合国教科文组织列入《世界文化遗产名录》，成为中华文明的重要象征。<br></p><p><br></p><p>故宫占地72万平方米，建筑面积约15万平方米，拥有大小宫殿七十多座，房屋九千余间。整个建筑群以中轴线对称布局，分为外朝和内廷两部分。外朝以太和殿、中和殿、保和殿为中心，是皇帝举行重大典礼和朝会议政的场所；内廷以乾清宫、交泰殿、坤宁宫为中心，是皇帝与后妃居住生活的地方。<br></p><p><br></p><p>二、必看亮点：不可错过的六大经典<br></p><p>1. 太和殿：金銮宝殿的皇家气派<br></p><p>太和殿俗称“金銮殿”，是故宫等级最高的建筑。殿内金砖铺地，蟠龙金柱巍然屹立，正中的金龙宝座象征着皇权的至高无上。这里曾是皇帝登基、大婚、册立皇后等重大典礼的举行地。<br></p><p><br></p><p>2. 珍宝馆：皇家奢侈品的视觉盛宴<br></p><p>位于宁寿宫区域的珍宝馆收藏着清宫珍宝数千件，包括金器、玉器、宝石、珍珠等。其中最引人注目的是乾隆皇帝的金瓯永固杯、孝端皇后的凤冠、以及用一整块和田玉雕琢的“大禹治水”玉山。<br></p><p><br></p><p>3. 钟表馆：中西合璧的计时艺术<br></p><p>奉先殿内的钟表馆陈列着清代宫廷收藏的各类钟表。这些钟表不仅计时精准，更融入了机械人偶、音乐、喷泉等复杂功能，展现了18-19世纪中西钟表制造的最高水平。<br></p><p><br></p><p>4. 御花园：皇家园林的精致美学<br></p><p>位于故宫北端的御花园占地1.2万平方米，园内古树参天，奇石林立，亭台楼阁错落有致。堆秀山上的御景亭是重阳节皇帝登高之处，园内的连理柏、诸葛拜北斗石等奇景都值得细细观赏。<br></p><p><br></p><p>5. 武英殿：书画珍品的艺术殿堂<br></p><p>近年来开放的武英殿区常设“故宫藏历代书画展”，展出晋唐宋元明清各代书画精品。王羲之《兰亭序》摹本、张择端《清明上河图》等国之重宝曾在此亮相。<br></p><p><br></p><p>6. 角楼：建筑艺术的巅峰之作<br></p><p>故宫四角的角楼被称为“九梁十八柱七十二条脊”，其复杂的木结构堪称中国古代建筑智慧的结晶。西北角楼是拍摄倒影的绝佳位置，清晨或黄昏时分光影最美。<br></p><p><br></p><p>三、游览路线：高效参观的智慧选择<br></p><p>经典半日游路线（3-4小时）<br></p><p>午门进→武英殿（书画馆）→太和门→太和殿→中和殿→保和殿→乾清宫→交泰殿→坤宁宫→御花园→神武门出<br></p><p><br></p><p>深度一日游路线（6-8小时）<br></p><p>午门进→文华殿（陶瓷馆）→太和门三大殿→乾清宫内廷→奉先殿（钟表馆）→宁寿宫区（珍宝馆、戏曲馆）→御花园→东六宫或西六宫→神武门出<br></p><p><br></p><p>摄影爱好者路线<br></p><p>清晨拍摄角楼倒影→上午太和殿广场→中午避开人流拍摄细节→下午宁寿宫花园→黄昏神武门角楼夜景<br></p><p><br></p><p>四、实用贴士：让游览更顺畅<br></p><p>最佳游览时间<br></p><p><br></p><p>季节：春秋两季最为舒适，4-5月春花烂漫，9-10月秋高气爽<br></p><p><br></p><p>时间：工作日优于周末，早晨8:30开馆即入可避开大部分旅行团<br></p><p><br></p><p>特殊时段：雪后故宫美如画卷，需关注天气预报提前预约<br></p><p><br></p><p>购票与预约<br></p><p>故宫实行全网实名制预约，需提前1-7天在官网或微信公众号预约。旺季（4-10月）建议提前3天以上预约。门票分上午场和下午场，按预约时段入场。<br></p><p><br></p><p>交通指南<br></p><p><br></p><p>地铁：1号线天安门东站或西站下车<br></p><p><br></p><p>公交：多条线路可达故宫周边<br></p><p><br></p><p>注意事项：故宫南门（午门）为唯一入口，北门（神武门）和东门（东华门）为出口<br></p><p><br></p><p>游览建议<br></p><p><br></p><p>穿着舒适平底鞋，故宫步行距离约3-5公里<br></p><p><br></p><p>自备饮用水和简单食物，宫内餐饮选择有限<br></p><p><br></p><p>租用电子讲解器（20元）或参加导游讲解，深度了解历史文化<br></p><p><br></p><p>遵守参观秩序，室内展馆禁止使用闪光灯<br></p><p><br></p><p>预留时间参观故宫文创店，精美文创产品值得收藏<br></p><p><br></p><p>五、延伸体验：发现故宫的另一面<br></p><p>角楼咖啡馆<br></p><p>神武门外的角楼咖啡馆提供故宫主题饮品和甜品，城墙下的用餐体验别具风味。<br></p><p><br></p><p>故宫文创<br></p><p>近年来故宫文创火爆出圈，从文具、服饰到彩妆、食品，将传统文化与现代生活完美结合。<br></p><p><br></p><p>数字故宫<br></p><p>“数字故宫”小程序提供720度全景游览、文物高清图片、线上展览等数字化服务，线下游览前后可线上预习复习。<br></p><p><br></p><p>夜场活动<br></p><p>特定节假日故宫会开放夜场，灯光映衬下的紫禁城更显神秘辉煌，需特别关注官方公告。<br></p><p><br></p><p>故宫不仅是一座博物馆，更是一本活的历史教科书。在这里，每一块砖瓦都诉说着故事，每一件文物都承载着记忆。放慢脚步，用心感受，您将在这座六百岁的宫殿里，遇见最中国的模样。</p>', '这片秘境藏着大自然的鬼斧神工！青山叠翠间溪流潺潺，云海翻涌时宛如仙境，四季皆有别样风情 —— 春赏繁花似锦，夏沐清风避暑，秋观层林尽染，冬赏银装素裹。步道沿景延伸，既可徒步探秘原生植被，也能静坐观景台吸氧洗肺。配套设施完善，交通便捷，是远离尘嚣、沉浸式感受自然之美的绝佳旅游目的地，适合全家出游、好友结伴或独自放空。', '2025-11-18 20:52:49');
INSERT INTO `scenic_spot` VALUES (9, 159, '这片秘境藏着大自然的鬼斧神工！青山叠翠间溪流潺潺', 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=176879952549713.png', '<p>一、历史瑰宝：世界文化遗产的恢弘气势<br></p><p>故宫，旧称紫禁城，是世界上现存规模最大、保存最完整的木质结构古建筑群。这座建于明永乐四年（1406年）的皇家宫殿，历经明清两代24位皇帝，承载着中国近六百年的历史记忆。1987年，故宫被联合国教科文组织列入《世界文化遗产名录》，成为中华文明的重要象征。<br></p><p><br></p><p>故宫占地72万平方米，建筑面积约15万平方米，拥有大小宫殿七十多座，房屋九千余间。整个建筑群以中轴线对称布局，分为外朝和内廷两部分。外朝以太和殿、中和殿、保和殿为中心，是皇帝举行重大典礼和朝会议政的场所；内廷以乾清宫、交泰殿、坤宁宫为中心，是皇帝与后妃居住生活的地方。<br></p><p><br></p><p>二、必看亮点：不可错过的六大经典<br></p><p>1. 太和殿：金銮宝殿的皇家气派<br></p><p>太和殿俗称“金銮殿”，是故宫等级最高的建筑。殿内金砖铺地，蟠龙金柱巍然屹立，正中的金龙宝座象征着皇权的至高无上。这里曾是皇帝登基、大婚、册立皇后等重大典礼的举行地。<br></p><p><br></p><p>2. 珍宝馆：皇家奢侈品的视觉盛宴<br></p><p>位于宁寿宫区域的珍宝馆收藏着清宫珍宝数千件，包括金器、玉器、宝石、珍珠等。其中最引人注目的是乾隆皇帝的金瓯永固杯、孝端皇后的凤冠、以及用一整块和田玉雕琢的“大禹治水”玉山。<br></p><p><br></p><p>3. 钟表馆：中西合璧的计时艺术<br></p><p>奉先殿内的钟表馆陈列着清代宫廷收藏的各类钟表。这些钟表不仅计时精准，更融入了机械人偶、音乐、喷泉等复杂功能，展现了18-19世纪中西钟表制造的最高水平。<br></p><p><br></p><p>4. 御花园：皇家园林的精致美学<br></p><p>位于故宫北端的御花园占地1.2万平方米，园内古树参天，奇石林立，亭台楼阁错落有致。堆秀山上的御景亭是重阳节皇帝登高之处，园内的连理柏、诸葛拜北斗石等奇景都值得细细观赏。<br></p><p><br></p><p>5. 武英殿：书画珍品的艺术殿堂<br></p><p>近年来开放的武英殿区常设“故宫藏历代书画展”，展出晋唐宋元明清各代书画精品。王羲之《兰亭序》摹本、张择端《清明上河图》等国之重宝曾在此亮相。<br></p><p><br></p><p>6. 角楼：建筑艺术的巅峰之作<br></p><p>故宫四角的角楼被称为“九梁十八柱七十二条脊”，其复杂的木结构堪称中国古代建筑智慧的结晶。西北角楼是拍摄倒影的绝佳位置，清晨或黄昏时分光影最美。<br></p><p><br></p><p>三、游览路线：高效参观的智慧选择<br></p><p>经典半日游路线（3-4小时）<br></p><p>午门进→武英殿（书画馆）→太和门→太和殿→中和殿→保和殿→乾清宫→交泰殿→坤宁宫→御花园→神武门出<br></p><p><br></p><p>深度一日游路线（6-8小时）<br></p><p>午门进→文华殿（陶瓷馆）→太和门三大殿→乾清宫内廷→奉先殿（钟表馆）→宁寿宫区（珍宝馆、戏曲馆）→御花园→东六宫或西六宫→神武门出<br></p><p><br></p><p>摄影爱好者路线<br></p><p>清晨拍摄角楼倒影→上午太和殿广场→中午避开人流拍摄细节→下午宁寿宫花园→黄昏神武门角楼夜景<br></p><p><br></p><p>四、实用贴士：让游览更顺畅<br></p><p>最佳游览时间<br></p><p><br></p><p>季节：春秋两季最为舒适，4-5月春花烂漫，9-10月秋高气爽<br></p><p><br></p><p>时间：工作日优于周末，早晨8:30开馆即入可避开大部分旅行团<br></p><p><br></p><p>特殊时段：雪后故宫美如画卷，需关注天气预报提前预约<br></p><p><br></p><p>购票与预约<br></p><p>故宫实行全网实名制预约，需提前1-7天在官网或微信公众号预约。旺季（4-10月）建议提前3天以上预约。门票分上午场和下午场，按预约时段入场。<br></p><p><br></p><p>交通指南<br></p><p><br></p><p>地铁：1号线天安门东站或西站下车<br></p><p><br></p><p>公交：多条线路可达故宫周边<br></p><p><br></p><p>注意事项：故宫南门（午门）为唯一入口，北门（神武门）和东门（东华门）为出口<br></p><p><br></p><p>游览建议<br></p><p><br></p><p>穿着舒适平底鞋，故宫步行距离约3-5公里<br></p><p><br></p><p>自备饮用水和简单食物，宫内餐饮选择有限<br></p><p><br></p><p>租用电子讲解器（20元）或参加导游讲解，深度了解历史文化<br></p><p><br></p><p>遵守参观秩序，室内展馆禁止使用闪光灯<br></p><p><br></p><p>预留时间参观故宫文创店，精美文创产品值得收藏<br></p><p><br></p><p>五、延伸体验：发现故宫的另一面<br></p><p>角楼咖啡馆<br></p><p>神武门外的角楼咖啡馆提供故宫主题饮品和甜品，城墙下的用餐体验别具风味。<br></p><p><br></p><p>故宫文创<br></p><p>近年来故宫文创火爆出圈，从文具、服饰到彩妆、食品，将传统文化与现代生活完美结合。<br></p><p><br></p><p>数字故宫<br></p><p>“数字故宫”小程序提供720度全景游览、文物高清图片、线上展览等数字化服务，线下游览前后可线上预习复习。<br></p><p><br></p><p>夜场活动<br></p><p>特定节假日故宫会开放夜场，灯光映衬下的紫禁城更显神秘辉煌，需特别关注官方公告。<br></p><p><br></p><p>故宫不仅是一座博物馆，更是一本活的历史教科书。在这里，每一块砖瓦都诉说着故事，每一件文物都承载着记忆。放慢脚步，用心感受，您将在这座六百岁的宫殿里，遇见最中国的模样。</p>', '这片秘境藏着大自然的鬼斧神工！青山叠翠间溪流潺潺，云海翻涌时宛如仙境，四季皆有别样风情 —— 春赏繁花似锦，夏沐清风避暑，秋观层林尽染，冬赏银装素裹。步道沿景延伸，既可徒步探秘原生植被，也能静坐观景台吸氧洗肺。配套设施完善，交通便捷，是远离尘嚣、沉浸式感受自然之美的绝佳旅游目的地，适合全家出游、好友结伴或独自放空。', '2025-12-18 20:54:43');
INSERT INTO `scenic_spot` VALUES (16, 222, '远离尘嚣、沉浸式感受自然之美的绝佳旅游目的地', 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=176879949915312.png', '<p>一、历史瑰宝：世界文化遗产的恢弘气势<br></p><p>故宫，旧称紫禁城，是世界上现存规模最大、保存最完整的木质结构古建筑群。这座建于明永乐四年（1406年）的皇家宫殿，历经明清两代24位皇帝，承载着中国近六百年的历史记忆。1987年，故宫被联合国教科文组织列入《世界文化遗产名录》，成为中华文明的重要象征。<br></p><p><br></p><p>故宫占地72万平方米，建筑面积约15万平方米，拥有大小宫殿七十多座，房屋九千余间。整个建筑群以中轴线对称布局，分为外朝和内廷两部分。外朝以太和殿、中和殿、保和殿为中心，是皇帝举行重大典礼和朝会议政的场所；内廷以乾清宫、交泰殿、坤宁宫为中心，是皇帝与后妃居住生活的地方。<br></p><p><br></p><p>二、必看亮点：不可错过的六大经典<br></p><p>1. 太和殿：金銮宝殿的皇家气派<br></p><p>太和殿俗称“金銮殿”，是故宫等级最高的建筑。殿内金砖铺地，蟠龙金柱巍然屹立，正中的金龙宝座象征着皇权的至高无上。这里曾是皇帝登基、大婚、册立皇后等重大典礼的举行地。<br></p><p><br></p><p>2. 珍宝馆：皇家奢侈品的视觉盛宴<br></p><p>位于宁寿宫区域的珍宝馆收藏着清宫珍宝数千件，包括金器、玉器、宝石、珍珠等。其中最引人注目的是乾隆皇帝的金瓯永固杯、孝端皇后的凤冠、以及用一整块和田玉雕琢的“大禹治水”玉山。<br></p><p><br></p><p>3. 钟表馆：中西合璧的计时艺术<br></p><p>奉先殿内的钟表馆陈列着清代宫廷收藏的各类钟表。这些钟表不仅计时精准，更融入了机械人偶、音乐、喷泉等复杂功能，展现了18-19世纪中西钟表制造的最高水平。<br></p><p><br></p><p>4. 御花园：皇家园林的精致美学<br></p><p>位于故宫北端的御花园占地1.2万平方米，园内古树参天，奇石林立，亭台楼阁错落有致。堆秀山上的御景亭是重阳节皇帝登高之处，园内的连理柏、诸葛拜北斗石等奇景都值得细细观赏。<br></p><p><br></p><p>5. 武英殿：书画珍品的艺术殿堂<br></p><p>近年来开放的武英殿区常设“故宫藏历代书画展”，展出晋唐宋元明清各代书画精品。王羲之《兰亭序》摹本、张择端《清明上河图》等国之重宝曾在此亮相。<br></p><p><br></p><p>6. 角楼：建筑艺术的巅峰之作<br></p><p>故宫四角的角楼被称为“九梁十八柱七十二条脊”，其复杂的木结构堪称中国古代建筑智慧的结晶。西北角楼是拍摄倒影的绝佳位置，清晨或黄昏时分光影最美。<br></p><p><br></p><p>三、游览路线：高效参观的智慧选择<br></p><p>经典半日游路线（3-4小时）<br></p><p>午门进→武英殿（书画馆）→太和门→太和殿→中和殿→保和殿→乾清宫→交泰殿→坤宁宫→御花园→神武门出<br></p><p><br></p><p>深度一日游路线（6-8小时）<br></p><p>午门进→文华殿（陶瓷馆）→太和门三大殿→乾清宫内廷→奉先殿（钟表馆）→宁寿宫区（珍宝馆、戏曲馆）→御花园→东六宫或西六宫→神武门出<br></p><p><br></p><p>摄影爱好者路线<br></p><p>清晨拍摄角楼倒影→上午太和殿广场→中午避开人流拍摄细节→下午宁寿宫花园→黄昏神武门角楼夜景<br></p><p><br></p><p>四、实用贴士：让游览更顺畅<br></p><p>最佳游览时间<br></p><p><br></p><p>季节：春秋两季最为舒适，4-5月春花烂漫，9-10月秋高气爽<br></p><p><br></p><p>时间：工作日优于周末，早晨8:30开馆即入可避开大部分旅行团<br></p><p><br></p><p>特殊时段：雪后故宫美如画卷，需关注天气预报提前预约<br></p><p><br></p><p>购票与预约<br></p><p>故宫实行全网实名制预约，需提前1-7天在官网或微信公众号预约。旺季（4-10月）建议提前3天以上预约。门票分上午场和下午场，按预约时段入场。<br></p><p><br></p><p>交通指南<br></p><p><br></p><p>地铁：1号线天安门东站或西站下车<br></p><p><br></p><p>公交：多条线路可达故宫周边<br></p><p><br></p><p>注意事项：故宫南门（午门）为唯一入口，北门（神武门）和东门（东华门）为出口<br></p><p><br></p><p>游览建议<br></p><p><br></p><p>穿着舒适平底鞋，故宫步行距离约3-5公里<br></p><p><br></p><p>自备饮用水和简单食物，宫内餐饮选择有限<br></p><p><br></p><p>租用电子讲解器（20元）或参加导游讲解，深度了解历史文化<br></p><p><br></p><p>遵守参观秩序，室内展馆禁止使用闪光灯<br></p><p><br></p><p>预留时间参观故宫文创店，精美文创产品值得收藏<br></p><p><br></p><p>五、延伸体验：发现故宫的另一面<br></p><p>角楼咖啡馆<br></p><p>神武门外的角楼咖啡馆提供故宫主题饮品和甜品，城墙下的用餐体验别具风味。<br></p><p><br></p><p>故宫文创<br></p><p>近年来故宫文创火爆出圈，从文具、服饰到彩妆、食品，将传统文化与现代生活完美结合。<br></p><p><br></p><p>数字故宫<br></p><p>“数字故宫”小程序提供720度全景游览、文物高清图片、线上展览等数字化服务，线下游览前后可线上预习复习。<br></p><p><br></p><p>夜场活动<br></p><p>特定节假日故宫会开放夜场，灯光映衬下的紫禁城更显神秘辉煌，需特别关注官方公告。<br></p><p><br></p><p>故宫不仅是一座博物馆，更是一本活的历史教科书。在这里，每一块砖瓦都诉说着故事，每一件文物都承载着记忆。放慢脚步，用心感受，您将在这座六百岁的宫殿里，遇见最中国的模样。</p>', '这片秘境藏着大自然的鬼斧神工！青山叠翠间溪流潺潺，云海翻涌时宛如仙境，四季皆有别样风情 —— 春赏繁花似锦，夏沐清风避暑，秋观层林尽染，冬赏银装素裹。步道沿景延伸，既可徒步探秘原生植被，也能静坐观景台吸氧洗肺。配套设施完善，交通便捷，是远离尘嚣、沉浸式感受自然之美的绝佳旅游目的地，适合全家出游、好友结伴或独自放空。', '2025-12-18 22:27:02');
INSERT INTO `scenic_spot` VALUES (18, 217, '人性化，步道平缓、休息区充足，适配各年龄段游客', 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=17687994542598.png', '<p>故宫，旧称紫禁城，是世界上现存规模最大、保存最完整的木质结构古建筑群。这座建于明永乐四年（1406年）的皇家宫殿，历经明清两代24位皇帝，承载着中国近六百年的历史记忆。1987年，故宫被联合国教科文组织列入《世界文化遗产名录》，成为中华文明的重要象征。</p>', '集休闲娱乐与沉浸式体验于一体的度假胜地！这里既有清新自然的生态风光，也有丰富多元的游玩项目，亲子游乐、户外露营、特色美食一应俱全。设施完善且人性化，步道平缓、休息区充足，适配各年龄段游客。白日可尽情嬉戏赏景，夜晚能伴着星光放松休憩，交通便捷且性价比高，无论是短途周末游还是家庭度假，都能让人卸下疲惫、收获满满欢乐与惬意。', '2025-12-19 15:26:42');
INSERT INTO `scenic_spot` VALUES (19, 726, '丰富多元的游玩项目，亲子游乐、户外露', 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=17687993477205.png', '<p>一、历史瑰宝：世界文化遗产的恢弘气势<br></p><p>故宫，旧称紫禁城，是世界上现存规模最大、保存最完整的木质结构古建筑群。这座建于明永乐四年（1406年）的皇家宫殿，历经明清两代24位皇帝，承载着中国近六百年的历史记忆。1987年，故宫被联合国教科文组织列入《世界文化遗产名录》，成为中华文明的重要象征。</p><p>故宫占地72万平方米，建筑面积约15万平方米，拥有大小宫殿七十多座，房屋九千余间。整个建筑群以中轴线对称布局，分为外朝和内廷两部分。外朝以太和殿、中和殿、保和殿为中心，是皇帝举行重大典礼和朝会议政的场所；内廷以乾清宫、交泰殿、坤宁宫为中心，是皇帝与后妃居住生活的地方。</p><p>二、必看亮点：不可错过的六大经典</p><p>1. 太和殿：金銮宝殿的皇家气派</p><p>太和殿俗称“金銮殿”，是故宫等级最高的建筑。殿内金砖铺地，蟠龙金柱巍然屹立，正中的金龙宝座象征着皇权的至高无上。这里曾是皇帝登基、大婚、册立皇后等重大典礼的举行地。</p><p>2. 珍宝馆：皇家奢侈品的视觉盛宴</p><p>位于宁寿宫区域的珍宝馆收藏着清宫珍宝数千件，包括金器、玉器、宝石、珍珠等。其中最引人注目的是乾隆皇帝的金瓯永固杯、孝端皇后的凤冠、以及用一整块和田玉雕琢的“大禹治水”玉山。</p><p>3. 钟表馆：中西合璧的计时艺术</p><p>奉先殿内的钟表馆陈列着清代宫廷收藏的各类钟表。这些钟表不仅计时精准，更融入了机械人偶、音乐、喷泉等复杂功能，展现了18-19世纪中西钟表制造的最高水平。</p><p>4. 御花园：皇家园林的精致美学</p><p>位于故北端的御花园占地1.2万平方米，园内古树参天，奇石林立，亭台楼阁错落有致。堆秀山上的御景亭是重阳节皇帝登高之处，园内的连理柏、诸葛拜北斗石等奇景都值得细细观赏。</p><p>5. 武英殿：书画珍品的艺术殿堂</p><p>近年来开放的武英殿区常设“故宫藏历代书画展”，展出晋唐宋元明清各代书画精品。王羲之《兰亭序》摹本、张择端《清明上河图》等国之重宝曾在此亮相。</p><p>6. 角楼：建筑艺术的巅峰之作</p><p>故宫四角的角楼被称为“九梁十八柱七十二条脊”，其复杂的木结构堪称中国古代建筑智慧的结晶。西北角楼是拍摄倒影的绝佳位置，清晨或黄昏时分光影最美。</p><p>三、游览路线：高效参观的智慧选择</p><p>经典半日游路线（3-4小时）</p><p>午门进→武英殿（书画馆）→太和门→太和殿→中和殿→保和殿→乾清宫→交泰殿→坤宁宫→御花园→神武门</p><p>深度一日游路线（6-8小时）</p><p>午门进→文华殿（陶瓷馆）→太和门三大殿→乾清宫内廷→奉先殿（钟表馆）→宁寿宫区（珍宝馆、戏曲馆）→御花园→东六宫或西六宫→神武门出</p><p>摄影爱好者路线</p><p>清晨拍摄角楼倒影→上午太和殿广场→中午避开人流拍摄细节→下午宁寿宫花园→黄昏神武门角楼夜景</p><p>四、实用贴士：让游览更顺畅</p><p>最佳游览时间节：春秋两季最为舒适，4-5月春花烂漫，9-10月秋高气爽</p><p>时间：工作日优于周末，早晨8:30开馆即入可避开大部分旅行团</p><p>特殊时段：雪后故宫美如画卷，需关注天气预报提前预约</p><p>购票与预约<br>实行全网实名制预约，需提前1-7天在官网或微信公众号预约。旺季（4-10月）建议提前3天以上预约。门票分上午场和下午场，按预约时段入场。</p><p>交通指南</p><p>地铁：1号线天安门东站或西站下车<br>交：多条线路可达故宫周边</p><p>注意事项：故宫南门（午门）为唯一入口，北门（神武门）和东门（东华门）为出口</p><p>游览建议</p><p>穿着舒适平底鞋，故宫步行距离约3-5公里</p><p>自备饮用水和简单食物，宫内餐饮选择有限</p><p>租用电子讲解器（20元）或参加导游讲解，深度了解历史文化</p><p>遵守参观秩序，室内展馆禁止使用闪光灯</p><p>预留时间参观故宫文创店，精美文创产品值得收藏</p><p>五、延伸体验：发现故宫的另一面</p><p>角楼咖啡馆</p><p>神武门外的角楼咖啡馆提供故宫主题饮品和甜品，城墙下的用餐体验别具风味。</p><p>故宫文创</p><p>近年来故宫文创火爆出圈，从文具、服饰到彩妆、食品，将传统文化与现代生活完美结合。</p><p>数字故宫</p><p>“数字故宫”小程序提供720度全景游览、文物高清图片、线上展览等数字化服务，线下游览前后可线上预习复习。</p><p>夜场活动</p><p>特定节假日故宫会开放夜场，灯光映衬下的紫禁城更显神秘辉煌，需特别关注官方公告。</p><p>故宫不仅是一座博物馆，更是一本活的历史教科书。在这里，每一块砖瓦都诉说着故事，每一件文物都承载着记忆。放慢脚步，用心感受，您将在这座六百岁的宫殿里，遇见最中国的模样。</p>', '集休闲娱乐与沉浸式体验于一体的度假胜地！这里既有清新自然的生态风光，也有丰富多元的游玩项目，亲子游乐、户外露营、特色美食一应俱全。设施完善且人性化，步道平缓、休息区充足，适配各年龄段游客。白日可尽情嬉戏赏景，夜晚能伴着星光放松休憩，交通便捷且性价比高，无论是短途周末游还是家庭度假，都能让人卸下疲惫、收获满满欢乐与惬意。', '2025-12-19 16:15:19');
INSERT INTO `scenic_spot` VALUES (20, 45, '明十三陵·长陵', 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=176879932035311.png', '<p>明长陵坐落于北京昌平区天寿山南麓，是<span style=\"color: rgb(0, 0, 0);\"><strong>明十三陵的首陵与核心陵寝，为明成祖朱棣与皇后徐氏的合</strong></span><strong>葬墓。</strong></p><p>作为十三陵中建筑规模最大、营建时间最早、保存最为完好的陵寝，长陵不仅奠定了明代皇家陵寝的规制基础，更以恢弘的建筑格局与深厚的历史底蕴，成为解读明代皇权礼制与建筑艺术的珍贵实证。其始建于永乐七年（1409年），历时十八年竣工，耗费海量人力物力，见证了永乐盛世的国力鼎盛，2003年随明十三陵一同被列入《世界遗产名录》。</p><p>长陵的选址与布局尽显皇家规制与风水智慧。朱棣登基后，摒弃南京孝陵周边区域，派专人遍寻京畿之地，最终选定天寿山这片“背山面水、藏风聚气”的风水宝地。陵区以天寿山主峰为靠山，前方开阔平坦，两侧山峦环抱，形成天然的风水屏障。整体布局遵循“居中为尊、长幼有序”的原则，以长陵为核心，其余十二座陵寝分列两侧，构成庞大的陵寝集群。长陵自身则采用“前方后圆”的经典格局，即前部为方形院落，供奉祭祀礼仪之用；后部为圆形宝城，安放帝后棺椁，暗合“天圆地方”的传统宇宙观，彰显帝王“承天受命”的至高地位。</p><p>长陵的建筑群落沿中轴线依次展开，由南至北分别为陵门、神道、棱恩门、棱恩殿、内红门、明楼、宝城等核心建筑，轴线长达1450米，气势磅礴。其中，神道作为十三陵的共同神道，从石牌坊延伸至长陵陵门，沿途分布着石象生、龙凤门等标志性景观，而长陵陵门则是进入陵寝核心区域的门户，门内便是第一进方形院落。</p><p><strong>棱恩殿是长陵的核心祭祀建筑，也是明代皇家建筑的巅峰之作</strong>。该殿始建于永乐十四年（1416年），原名“享殿”，嘉靖十七年（1538年）更名为“棱恩殿”，取“感恩受福”之意。大殿坐落在三层汉白玉石基之上，面阔九间、进深五间，符合“九五之尊”的皇权礼制，建筑面积达1956平方米，与故宫太和殿规制相当。殿内采用60根金丝楠木立柱支撑屋顶，其中最粗的四根立柱直径达1.17米、高14.3米，均为整根金丝楠木打造，历经六百年风雨仍完好无损，堪称“中国古代建筑的木材瑰宝”。殿内原供奉朱棣与徐皇后的神位，是明清两代皇帝祭祀先祖的重要场所，如今殿内陈列着明代宫廷器物与陵寝历史介绍，供游客探寻历史脉络。</p><p>穿过棱恩殿后侧的内红门，便进入陵寝的“后圆”区域，核心建筑为明楼与宝城。明楼是长陵的标志性建筑之一，坐落在宝城前端的方城之上，楼高15.38米，为重檐歇山顶，覆盖黄色琉璃瓦，檐下悬挂“长陵”匾额，字体苍劲有力。楼内竖有“大明成祖文皇帝之陵”的石碑，详细记载了朱棣的庙号与谥号。明楼之后的宝城为圆形城墙，直径约340米，墙体高7.3米，由砖石砌筑而成，宝城之内便是“宝顶”，即帝后棺椁的埋葬之处，宝顶之上草木丛生，历经数百年仍巍然矗立。</p><p>作为明十三陵的规制源头，长陵的建筑布局与礼制规范深刻影响了后续明代诸陵的营建。从金丝楠木的奢华用料到“前方后圆”的格局设计，从“九五之尊”的建筑规制到风水理念的融入，每一处细节都彰显着明代皇权的至高无上与古代工匠的卓越智慧。如今，长陵不仅是珍贵的世界文化遗产，更是连接古今的历史纽带，漫步其间，红墙黄瓦映照着岁月沧桑，殿宇巍峨诉说着帝国辉煌，让每一位游客都能沉浸式感受明代历史与建筑艺术的独特魅力。</p>', '陵区营建始于永乐七年（1409 年），历时 200 余年，总面积达 80 平方公里。布局以长陵（永乐皇帝陵）为核心居主峰中部，其余各陵分列两侧，遵循 “尊者居主脉” 的规制。各陵均采用 “前方后圆” 格局，中轴线上依次排布陵门、祾恩殿、明楼、宝城等建筑，尽显皇家威严。', '2025-12-19 18:20:05');

-- ----------------------------
-- Table structure for scenic_spot_brochure
-- ----------------------------
DROP TABLE IF EXISTS `scenic_spot_brochure`;
CREATE TABLE `scenic_spot_brochure`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '景点图册信息表ID，主键自增',
  `scenic_spot_id` int(11) NULL DEFAULT NULL COMMENT '景点ID，外键，关联的是景点信息表',
  `cover_url` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '图片URL地址',
  `order_number` int(11) NULL DEFAULT NULL COMMENT '排序序号',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_scenic_spot_id`(`scenic_spot_id`) USING BTREE COMMENT '索引-景点ID'
) ENGINE = InnoDB AUTO_INCREMENT = 59 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '景点图册信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of scenic_spot_brochure
-- ----------------------------
INSERT INTO `scenic_spot_brochure` VALUES (1, 1, 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=1766049067906Snipaste_2025-04-21_16-56-22.png', 1);
INSERT INTO `scenic_spot_brochure` VALUES (2, 1, 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=1766049069652Snipaste_2025-04-21_16-57-23.png', 2);
INSERT INTO `scenic_spot_brochure` VALUES (3, 2, 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=1766062014167Snipaste_2025-04-21_16-56-22.png', 1);
INSERT INTO `scenic_spot_brochure` VALUES (4, 2, 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=1766062016138Snipaste_2025-04-21_16-57-23.png', 2);
INSERT INTO `scenic_spot_brochure` VALUES (5, 6, 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=1766062204510Snipaste_2025-04-21_16-56-22.png', 1);
INSERT INTO `scenic_spot_brochure` VALUES (6, 6, 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=1766062206398Snipaste_2025-04-21_16-57-23.png', 2);
INSERT INTO `scenic_spot_brochure` VALUES (10, 8, 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=1766062363599Snipaste_2025-04-21_16-56-22.png', 1);
INSERT INTO `scenic_spot_brochure` VALUES (11, 8, 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=1766062365515Snipaste_2025-04-21_16-57-23.png', 2);
INSERT INTO `scenic_spot_brochure` VALUES (12, 8, 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=1766062367603Snipaste_2025-04-21_16-57-32.png', 3);
INSERT INTO `scenic_spot_brochure` VALUES (45, 20, 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=17687993340187.png', 1);
INSERT INTO `scenic_spot_brochure` VALUES (46, 20, 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=17687993360388.png', 2);
INSERT INTO `scenic_spot_brochure` VALUES (47, 19, 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=17687994348732.png', 1);
INSERT INTO `scenic_spot_brochure` VALUES (48, 19, 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=17687994369393.png', 2);
INSERT INTO `scenic_spot_brochure` VALUES (49, 18, 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=17687994674749.png', 1);
INSERT INTO `scenic_spot_brochure` VALUES (50, 18, 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=17687994696022.png', 2);
INSERT INTO `scenic_spot_brochure` VALUES (51, 18, 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=17687994726013.png', 3);
INSERT INTO `scenic_spot_brochure` VALUES (52, 16, 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=17687995112435.png', 1);
INSERT INTO `scenic_spot_brochure` VALUES (53, 16, 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=17687995135776.png', 2);
INSERT INTO `scenic_spot_brochure` VALUES (54, 16, 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=17687995155107.png', 3);
INSERT INTO `scenic_spot_brochure` VALUES (55, 9, 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=176879953956310.png', 1);
INSERT INTO `scenic_spot_brochure` VALUES (56, 9, 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=176879954389212.png', 2);
INSERT INTO `scenic_spot_brochure` VALUES (57, 7, 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=17687995647949.png', 1);
INSERT INTO `scenic_spot_brochure` VALUES (58, 7, 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=17687995666285.png', 2);

-- ----------------------------
-- Table structure for scenic_spot_category
-- ----------------------------
DROP TABLE IF EXISTS `scenic_spot_category`;
CREATE TABLE `scenic_spot_category`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '景点类别中间表，主键自增',
  `scenic_spot_id` int(11) NULL DEFAULT NULL COMMENT '景点ID',
  `category_id` int(11) NULL DEFAULT NULL COMMENT '类别ID',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_scenic_spot_id`(`scenic_spot_id`) USING BTREE COMMENT '索引-景点ID',
  INDEX `idx_category_id`(`category_id`) USING BTREE COMMENT '索引-类别ID'
) ENGINE = InnoDB AUTO_INCREMENT = 46 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '景点类别中间表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of scenic_spot_category
-- ----------------------------
INSERT INTO `scenic_spot_category` VALUES (37, 20, 11);
INSERT INTO `scenic_spot_category` VALUES (38, 20, 2);
INSERT INTO `scenic_spot_category` VALUES (39, 19, 9);
INSERT INTO `scenic_spot_category` VALUES (40, 19, 1);
INSERT INTO `scenic_spot_category` VALUES (41, 18, 7);
INSERT INTO `scenic_spot_category` VALUES (42, 18, 1);
INSERT INTO `scenic_spot_category` VALUES (43, 16, 35);
INSERT INTO `scenic_spot_category` VALUES (44, 16, 11);
INSERT INTO `scenic_spot_category` VALUES (45, 16, 2);

-- ----------------------------
-- Table structure for scenic_spot_route_item
-- ----------------------------
DROP TABLE IF EXISTS `scenic_spot_route_item`;
CREATE TABLE `scenic_spot_route_item`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '景点路线项主键ID，自增',
  `scenic_spot_id` int(11) NULL DEFAULT NULL COMMENT '景点ID，外键，关联的是景点信息表',
  `position_desc` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '路线定位',
  `times` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '时长',
  `intensity` int(1) NULL DEFAULT NULL COMMENT '强度（1-5级）',
  `focus_desc` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '核心看点',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_scenic_id`(`scenic_spot_id`) USING BTREE COMMENT '索引-景点ID'
) ENGINE = InnoDB AUTO_INCREMENT = 28 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '景点路线信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of scenic_spot_route_item
-- ----------------------------
INSERT INTO `scenic_spot_route_item` VALUES (7, 7, '午门→神武门', '3.5小时', 2, '太和殿、乾清宫、御花园，中轴线核心建筑全景');
INSERT INTO `scenic_spot_route_item` VALUES (8, 7, '午门→武英殿→三大殿→御花园→神武门', '4小时', 2, '书画馆、金銮宝殿、皇家园林精粹');
INSERT INTO `scenic_spot_route_item` VALUES (9, 9, '午门→文华殿→三大殿→珍宝馆→东六宫→神武门', '7小时', 3, '陶瓷馆、清宫珍宝、内廷生活区细节');
INSERT INTO `scenic_spot_route_item` VALUES (10, 9, '午门→奉先殿→宁寿宫→御花园→西六宫→神武门', '6.5小时', 3, '钟表馆、戏曲馆、皇家日常起居场景');
INSERT INTO `scenic_spot_route_item` VALUES (11, 16, '西北角楼→太和殿广场→宁寿宫花园→神武门角楼', '5小时', 2, '角楼倒影、宫殿光影、古建细节特写');
INSERT INTO `scenic_spot_route_item` VALUES (12, 16, '午门→御花园堆秀山→东六宫回廊→神武门', '4.5小时', 2, '皇家园林奇景、宫廷回廊建筑、春日繁花');
INSERT INTO `scenic_spot_route_item` VALUES (13, 18, '午门→太和门→御花园→角楼咖啡馆', '3小时', 1, '简化中轴线、亲子互动观景、文创体验');
INSERT INTO `scenic_spot_route_item` VALUES (14, 18, '午门→武英殿书画展→珍宝馆精选→神武门', '3.5小时', 1, '适合儿童的文物科普、轻松观景路线');
INSERT INTO `scenic_spot_route_item` VALUES (15, 19, '午门→三大殿→乾清宫→故宫文创馆', '5小时', 3, '皇权礼制建筑、非遗文创制作体验、历史典故讲解');
INSERT INTO `scenic_spot_route_item` VALUES (16, 21, '景区入口→溪流观景台→中心草坪→出口', '2.5小时', 1, '溪流潺潺、青山叠翠，轻松吸氧洗肺');
INSERT INTO `scenic_spot_route_item` VALUES (17, 21, '入口→繁花谷→观景台→休憩亭→出口', '2小时', 1, '四季花海、云海远眺、原生植被观赏');
INSERT INTO `scenic_spot_route_item` VALUES (18, 21, '入口→原生植被步道→山顶观景台→环线返回', '4小时', 3, '珍稀植物、山间溪流、全景云海仙境');
INSERT INTO `scenic_spot_route_item` VALUES (19, 21, '入口→露营基地→森林栈道→出口', '3小时', 2, '户外露营体验、森林氧吧、休闲漫步');
INSERT INTO `scenic_spot_route_item` VALUES (20, 21, '入口→亲子步道→嬉水浅滩→野餐区→出口', '3小时', 1, '平缓步道、安全嬉水区、亲子互动自然探索');
INSERT INTO `scenic_spot_route_item` VALUES (21, 20, '长陵入口→陵门→棱恩殿→明楼→宝城', '2.5小时', 2, '金丝楠木棱恩殿、明楼碑刻、帝后陵寝核心');
INSERT INTO `scenic_spot_route_item` VALUES (22, 20, '神道→长陵陵门→棱恩殿→宝顶→出口', '2.5小时', 3, '石象生、龙凤门、长陵规制典范景观');
INSERT INTO `scenic_spot_route_item` VALUES (23, 20, '长陵入口→棱恩殿→明楼→宝城→十三陵博物馆', '3.5小时', 3, '明代建筑工艺、朱棣历史、陵寝礼制文化');
INSERT INTO `scenic_spot_route_item` VALUES (24, 20, '长陵入口→陵门→棱恩殿→御路石→出口', '3.5小时', 1, '简化路线，重点观赏皇家陵寝建筑美学、古碑刻');
INSERT INTO `scenic_spot_route_item` VALUES (25, 20, '神道→长陵→景陵外围→长陵出口', '4小时', 3, '十三陵核心神道、长陵全景、邻陵规制对比');
INSERT INTO `scenic_spot_route_item` VALUES (26, 19, '入口→原生植被步道→山顶观景台→环线返回', '4小时', 3, '原生植被探秘，山顶云海仙境，吸氧洗肺');
INSERT INTO `scenic_spot_route_item` VALUES (27, 19, '入口→浅滩嬉水区→森林氧吧→出口', '3小时', 2, '自然生态风光，清凉嬉水体验，亲近自然');

-- ----------------------------
-- Table structure for scenic_spot_route_nodes
-- ----------------------------
DROP TABLE IF EXISTS `scenic_spot_route_nodes`;
CREATE TABLE `scenic_spot_route_nodes`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '景点路线节点信息表主键，自增',
  `scenic_spot_route_id` int(11) NULL DEFAULT NULL COMMENT '景点路线ID，外键，关联的是景点路线表',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '节点类型',
  `times` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '停留时长',
  `focus_desc` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '看点',
  `order_number` int(11) NULL DEFAULT NULL COMMENT '序号',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_scenic_spot_route_id`(`scenic_spot_route_id`) USING BTREE COMMENT '索引-景点路线ID'
) ENGINE = InnoDB AUTO_INCREMENT = 113 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '景点路线节点信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of scenic_spot_route_nodes
-- ----------------------------
INSERT INTO `scenic_spot_route_nodes` VALUES (1, 7, '入口', '10分钟', '午门，故宫正门，感受皇家规制入口气势', 1);
INSERT INTO `scenic_spot_route_nodes` VALUES (2, 7, '核心景点', '40分钟', '太和殿，金銮宝殿，欣赏蟠龙金柱与金龙宝座', 2);
INSERT INTO `scenic_spot_route_nodes` VALUES (3, 7, '核心景点', '30分钟', '乾清宫，明清皇帝寝宫，了解皇家起居规制', 3);
INSERT INTO `scenic_spot_route_nodes` VALUES (4, 7, '核心景点', '30分钟', '御花园，皇家园林精粹，观赏古树奇石与亭台楼阁', 4);
INSERT INTO `scenic_spot_route_nodes` VALUES (5, 7, '出口', '5分钟', '神武门，故宫北门，结束游览', 5);
INSERT INTO `scenic_spot_route_nodes` VALUES (6, 8, '入口', '10分钟', '午门，故宫正门，开启游览行程', 1);
INSERT INTO `scenic_spot_route_nodes` VALUES (7, 8, '核心景点', '40分钟', '武英殿（书画馆），观赏历代书画精品', 2);
INSERT INTO `scenic_spot_route_nodes` VALUES (8, 8, '核心景点', '20分钟', '太和门，故宫最大宫门，感受规制威严', 3);
INSERT INTO `scenic_spot_route_nodes` VALUES (9, 8, '核心景点', '45分钟', '三大殿（太和殿、中和殿、保和殿），皇家核心礼制建筑', 4);
INSERT INTO `scenic_spot_route_nodes` VALUES (10, 8, '核心景点', '30分钟', '御花园，休憩观景，欣赏皇家园林美学', 5);
INSERT INTO `scenic_spot_route_nodes` VALUES (11, 8, '出口', '5分钟', '神武门，结束游览', 6);
INSERT INTO `scenic_spot_route_nodes` VALUES (12, 9, '入口', '10分钟', '午门，故宫正门，进入景区', 1);
INSERT INTO `scenic_spot_route_nodes` VALUES (13, 9, '核心景点', '40分钟', '文华殿（陶瓷馆），观赏历代陶瓷珍品', 2);
INSERT INTO `scenic_spot_route_nodes` VALUES (14, 9, '核心景点', '50分钟', '三大殿，感受皇权至高无上的建筑规制', 3);
INSERT INTO `scenic_spot_route_nodes` VALUES (15, 9, '核心景点', '45分钟', '珍宝馆，欣赏金瓯永固杯、凤冠等清宫珍宝', 4);
INSERT INTO `scenic_spot_route_nodes` VALUES (16, 9, '核心景点', '40分钟', '东六宫，了解后妃居住生活场景', 5);
INSERT INTO `scenic_spot_route_nodes` VALUES (17, 9, '休憩点', '15分钟', '途中休憩区，补充体力', 6);
INSERT INTO `scenic_spot_route_nodes` VALUES (18, 9, '出口', '5分钟', '神武门，结束游览', 7);
INSERT INTO `scenic_spot_route_nodes` VALUES (19, 10, '入口', '10分钟', '午门，进入故宫核心区域', 1);
INSERT INTO `scenic_spot_route_nodes` VALUES (20, 10, '核心景点', '40分钟', '奉先殿（钟表馆），观赏中西合璧计时艺术珍品', 2);
INSERT INTO `scenic_spot_route_nodes` VALUES (21, 10, '核心景点', '45分钟', '宁寿宫，清代乾隆皇帝养老宫殿，感受皇家养老规制', 3);
INSERT INTO `scenic_spot_route_nodes` VALUES (22, 10, '核心景点', '25分钟', '御花园，休闲观景，缓解游览疲劳', 4);
INSERT INTO `scenic_spot_route_nodes` VALUES (23, 10, '核心景点', '40分钟', '西六宫，探访后妃日常起居场所', 5);
INSERT INTO `scenic_spot_route_nodes` VALUES (24, 10, '出口', '5分钟', '神武门，结束行程', 6);
INSERT INTO `scenic_spot_route_nodes` VALUES (25, 11, '摄影打卡点', '30分钟', '西北角楼，拍摄角楼倒影绝佳位置', 1);
INSERT INTO `scenic_spot_route_nodes` VALUES (26, 11, '核心景点', '40分钟', '太和殿广场，感受皇家宫殿群的恢弘气势', 2);
INSERT INTO `scenic_spot_route_nodes` VALUES (27, 11, '核心景点', '35分钟', '宁寿宫花园，精巧皇家园林，拍摄古建细节', 3);
INSERT INTO `scenic_spot_route_nodes` VALUES (28, 11, '摄影打卡点', '30分钟', '神武门角楼，黄昏光影最佳，拍摄角楼夜景前奏', 4);
INSERT INTO `scenic_spot_route_nodes` VALUES (29, 11, '休憩点', '15分钟', '周边观景平台，整理拍摄作品', 5);
INSERT INTO `scenic_spot_route_nodes` VALUES (30, 12, '入口', '10分钟', '午门，进入故宫', 1);
INSERT INTO `scenic_spot_route_nodes` VALUES (31, 12, '核心景点', '35分钟', '御花园堆秀山，重阳节皇帝登高之处，观赏御景亭', 2);
INSERT INTO `scenic_spot_route_nodes` VALUES (32, 12, '核心景点', '40分钟', '东六宫回廊，感受宫廷回廊建筑美学', 3);
INSERT INTO `scenic_spot_route_nodes` VALUES (33, 12, '观景休憩点', '20分钟', '东六宫周边观景台，欣赏春日繁花', 4);
INSERT INTO `scenic_spot_route_nodes` VALUES (34, 12, '出口', '5分钟', '神武门，结束游览', 5);
INSERT INTO `scenic_spot_route_nodes` VALUES (35, 13, '入口', '10分钟', '午门，亲子共同开启游览', 1);
INSERT INTO `scenic_spot_route_nodes` VALUES (36, 13, '核心景点', '20分钟', '太和门广场，亲子互动观景，感受皇家气派', 2);
INSERT INTO `scenic_spot_route_nodes` VALUES (37, 13, '核心景点', '30分钟', '御花园，亲子漫步，观赏连理柏等奇景', 3);
INSERT INTO `scenic_spot_route_nodes` VALUES (38, 13, '文创体验点', '40分钟', '角楼咖啡馆，品尝故宫主题饮品，体验文创产品', 4);
INSERT INTO `scenic_spot_route_nodes` VALUES (39, 13, '出口', '5分钟', '神武门方向，结束亲子行程', 5);
INSERT INTO `scenic_spot_route_nodes` VALUES (40, 14, '入口', '10分钟', '午门，进入景区', 1);
INSERT INTO `scenic_spot_route_nodes` VALUES (41, 14, '科普体验点', '35分钟', '武英殿书画展，儿童友好型书画科普讲解', 2);
INSERT INTO `scenic_spot_route_nodes` VALUES (42, 14, '科普体验点', '40分钟', '珍宝馆精选区域，观赏适合儿童的精美珍宝', 3);
INSERT INTO `scenic_spot_route_nodes` VALUES (43, 14, '休憩点', '15分钟', '亲子休憩区，补充水分与体力', 4);
INSERT INTO `scenic_spot_route_nodes` VALUES (44, 14, '出口', '5分钟', '神武门，结束科普游览', 5);
INSERT INTO `scenic_spot_route_nodes` VALUES (45, 15, '入口', '10分钟', '午门，开启文化研学之旅', 1);
INSERT INTO `scenic_spot_route_nodes` VALUES (46, 15, '核心景点', '45分钟', '三大殿，学习皇家礼制建筑知识', 2);
INSERT INTO `scenic_spot_route_nodes` VALUES (47, 15, '核心景点', '35分钟', '乾清宫，了解明代皇权历史典故', 3);
INSERT INTO `scenic_spot_route_nodes` VALUES (48, 15, '非遗体验点', '40分钟', '故宫文创馆，参与非遗文创制作体验', 4);
INSERT INTO `scenic_spot_route_nodes` VALUES (49, 15, '出口', '5分钟', '神武门，结束研学行程', 5);
INSERT INTO `scenic_spot_route_nodes` VALUES (50, 16, '入口', '5分钟', '景区正门，领取游览导览图', 1);
INSERT INTO `scenic_spot_route_nodes` VALUES (51, 16, '观景休憩点', '30分钟', '溪流观景台，观赏潺潺溪流，感受清新空气', 2);
INSERT INTO `scenic_spot_route_nodes` VALUES (52, 16, '休闲体验点', '40分钟', '中心草坪，休闲漫步或短暂休憩', 3);
INSERT INTO `scenic_spot_route_nodes` VALUES (53, 16, '出口', '5分钟', '景区出口，结束轻松游览', 4);
INSERT INTO `scenic_spot_route_nodes` VALUES (54, 17, '入口', '5分钟', '景区入口，开启花海游览', 1);
INSERT INTO `scenic_spot_route_nodes` VALUES (55, 17, '核心景点', '35分钟', '繁花谷，观赏四季繁花，拍照打卡', 2);
INSERT INTO `scenic_spot_route_nodes` VALUES (56, 17, '核心景点', '30分钟', '观景台，远眺云海与青山叠翠美景', 3);
INSERT INTO `scenic_spot_route_nodes` VALUES (57, 17, '休憩点', '15分钟', '休憩亭，休息补充体力', 4);
INSERT INTO `scenic_spot_route_nodes` VALUES (58, 17, '出口', '5分钟', '景区出口，结束行程', 5);
INSERT INTO `scenic_spot_route_nodes` VALUES (59, 18, '入口', '5分钟', '景区入口，做好徒步准备', 1);
INSERT INTO `scenic_spot_route_nodes` VALUES (60, 18, '徒步体验点', '60分钟', '原生植被步道，探秘珍稀原生植被', 2);
INSERT INTO `scenic_spot_route_nodes` VALUES (61, 18, '核心景点', '40分钟', '山顶观景台，观赏全景云海仙境', 3);
INSERT INTO `scenic_spot_route_nodes` VALUES (62, 18, '徒步体验点', '45分钟', '环线返回步道，继续欣赏沿途自然风光', 4);
INSERT INTO `scenic_spot_route_nodes` VALUES (63, 18, '出口', '5分钟', '景区出口，结束徒步探秘', 5);
INSERT INTO `scenic_spot_route_nodes` VALUES (64, 19, '入口', '5分钟', '景区入口，前往露营区域', 1);
INSERT INTO `scenic_spot_route_nodes` VALUES (65, 19, '休闲体验点', '50分钟', '露营基地，体验户外露营氛围', 2);
INSERT INTO `scenic_spot_route_nodes` VALUES (66, 19, '徒步体验点', '40分钟', '森林栈道，漫步森林氧吧，感受自然气息', 3);
INSERT INTO `scenic_spot_route_nodes` VALUES (67, 19, '休憩点', '15分钟', '栈道休憩区，休息放松', 4);
INSERT INTO `scenic_spot_route_nodes` VALUES (68, 19, '出口', '5分钟', '景区出口，结束休闲行程', 5);
INSERT INTO `scenic_spot_route_nodes` VALUES (69, 20, '入口', '5分钟', '景区入口，亲子集合出发', 1);
INSERT INTO `scenic_spot_route_nodes` VALUES (70, 20, '亲子体验点', '35分钟', '亲子步道，平缓安全，适合亲子漫步', 2);
INSERT INTO `scenic_spot_route_nodes` VALUES (71, 20, '亲子体验点', '40分钟', '嬉水浅滩，安全嬉水，享受清凉', 3);
INSERT INTO `scenic_spot_route_nodes` VALUES (72, 20, '休闲体验点', '30分钟', '野餐区，亲子共享野餐时光', 4);
INSERT INTO `scenic_spot_route_nodes` VALUES (73, 20, '出口', '5分钟', '景区出口，结束亲子行程', 5);
INSERT INTO `scenic_spot_route_nodes` VALUES (74, 21, '入口', '10分钟', '长陵入口，了解长陵历史背景', 1);
INSERT INTO `scenic_spot_route_nodes` VALUES (75, 21, '核心景点', '20分钟', '陵门，长陵正门，感受陵寝规制', 2);
INSERT INTO `scenic_spot_route_nodes` VALUES (76, 21, '核心景点', '45分钟', '棱恩殿，观赏金丝楠木立柱，感受明代建筑巅峰', 3);
INSERT INTO `scenic_spot_route_nodes` VALUES (77, 21, '核心景点', '30分钟', '明楼，查看朱棣庙号谥号碑刻', 4);
INSERT INTO `scenic_spot_route_nodes` VALUES (78, 21, '核心景点', '20分钟', '宝城，观赏帝后陵寝核心区域', 5);
INSERT INTO `scenic_spot_route_nodes` VALUES (79, 21, '出口', '5分钟', '长陵出口，结束游览', 6);
INSERT INTO `scenic_spot_route_nodes` VALUES (80, 22, '核心景点', '40分钟', '神道，观赏石象生、龙凤门等标志性景观', 1);
INSERT INTO `scenic_spot_route_nodes` VALUES (81, 22, '核心景点', '20分钟', '长陵陵门，进入陵寝核心区域', 2);
INSERT INTO `scenic_spot_route_nodes` VALUES (82, 22, '核心景点。核心景点。核心景点。', '40分钟', '棱恩殿，深入了解明代皇家建筑工艺', 3);
INSERT INTO `scenic_spot_route_nodes` VALUES (83, 22, '核心景点', '25分钟', '宝顶，帝后棺椁埋葬之处，感受陵寝威严', 4);
INSERT INTO `scenic_spot_route_nodes` VALUES (84, 22, '出口', '5分钟', '长陵出口，结束行程', 5);
INSERT INTO `scenic_spot_route_nodes` VALUES (85, 23, '入口', '10分钟', '长陵入口，领取研学导览资料', 20);
INSERT INTO `scenic_spot_route_nodes` VALUES (86, 23, '核心景点', '45分钟', '棱恩殿，学习金丝楠木建筑工艺知识', 2);
INSERT INTO `scenic_spot_route_nodes` VALUES (87, 23, '核心景点', '30分钟', '明楼，了解朱棣生平与历史功绩', 3);
INSERT INTO `scenic_spot_route_nodes` VALUES (88, 23, '核心景点', '20分钟', '宝城，学习明代陵寝礼制文化', 4);
INSERT INTO `scenic_spot_route_nodes` VALUES (89, 23, '科普体验点', '40分钟', '十三陵博物馆，观赏明代宫廷器物与历史展品', 5);
INSERT INTO `scenic_spot_route_nodes` VALUES (90, 23, '出口', '5分钟', '博物馆出口，结束研学游览', 1);
INSERT INTO `scenic_spot_route_nodes` VALUES (91, 24, '入口', '10分钟', '长陵入口，开启轻松游览', 1);
INSERT INTO `scenic_spot_route_nodes` VALUES (92, 24, '核心景点', '15分钟', '陵门，简单了解陵寝入口规制', 2);
INSERT INTO `scenic_spot_route_nodes` VALUES (93, 24, '核心景点', '35分钟', '棱恩殿，重点观赏皇家建筑美学', 3);
INSERT INTO `scenic_spot_route_nodes` VALUES (94, 24, '核心景点', '20分钟', '御路石，欣赏石刻工艺细节', 4);
INSERT INTO `scenic_spot_route_nodes` VALUES (95, 24, '休憩点', '15分钟', '陵内休憩区，休息放松', 5);
INSERT INTO `scenic_spot_route_nodes` VALUES (96, 24, '出口', '5分钟', '长陵出口，结束行程', 6);
INSERT INTO `scenic_spot_route_nodes` VALUES (97, 25, '核心景点', '40分钟', '神道，感受十三陵共同神道的恢弘气势', 1);
INSERT INTO `scenic_spot_route_nodes` VALUES (98, 25, '核心景点', '35分钟', '长陵核心区域，快速游览棱恩殿与明楼', 2);
INSERT INTO `scenic_spot_route_nodes` VALUES (99, 25, '核心景点', '30分钟', '景陵外围，对比了解明代不同陵寝规制差异', 3);
INSERT INTO `scenic_spot_route_nodes` VALUES (100, 25, '徒步体验点', '35分钟', '返回长陵步道，欣赏沿途陵寝周边风光', 4);
INSERT INTO `scenic_spot_route_nodes` VALUES (101, 25, '出口', '5分钟', '长陵出口，结束深度游览', 5);
INSERT INTO `scenic_spot_route_nodes` VALUES (102, 26, '入口', '5分钟', '景区入口，做好徒步探秘准备', 1);
INSERT INTO `scenic_spot_route_nodes` VALUES (103, 26, '徒步体验点', '60分钟', '原生植被步道，近距离观察原生植被', 2);
INSERT INTO `scenic_spot_route_nodes` VALUES (104, 26, '核心景点', '40分钟', '山顶观景台，观赏云海仙境与群山美景', 3);
INSERT INTO `scenic_spot_route_nodes` VALUES (105, 26, '徒步体验点', '45分钟', '环线返回，继续探秘自然生态风光', 4);
INSERT INTO `scenic_spot_route_nodes` VALUES (106, 26, '出口', '5分钟', '景区出口，结束行程', 5);
INSERT INTO `scenic_spot_route_nodes` VALUES (107, 27, '入口', '5分钟', '景区入口，前往嬉水区域', 1);
INSERT INTO `scenic_spot_route_nodes` VALUES (108, 27, '休闲体验点', '40分钟', '浅滩嬉水区，享受清凉嬉水体验', 2);
INSERT INTO `scenic_spot_route_nodes` VALUES (109, 27, '徒步体验点', '40分钟', '森林氧吧，漫步其中感受清新自然气息', 3);
INSERT INTO `scenic_spot_route_nodes` VALUES (110, 27, '休憩点', '15分钟', '森林休憩区，休息补充体力', 4);
INSERT INTO `scenic_spot_route_nodes` VALUES (111, 27, '出口', '5分钟', '景区出口，结束自然体验行程', 5);
INSERT INTO `scenic_spot_route_nodes` VALUES (112, 23, '补充节点：篝火晚会', '30分钟', '少数民族舞蹈', 1);

-- ----------------------------
-- Table structure for scenic_spot_strategy
-- ----------------------------
DROP TABLE IF EXISTS `scenic_spot_strategy`;
CREATE TABLE `scenic_spot_strategy`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '景点攻略信息表主键ID，自增',
  `scenic_spot_id` int(11) NULL DEFAULT NULL COMMENT '景点ID，外键，关联的是景点信息表',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户ID，外键，关联的是用户信息表',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '标题',
  `cover` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '封面',
  `summary` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '内容',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL COMMENT '摘要',
  `audit_status` tinyint(1) NULL DEFAULT NULL COMMENT '审核状态',
  `create_time` datetime NULL DEFAULT NULL COMMENT '发布时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_scenic_spot_id`(`scenic_spot_id`) USING BTREE COMMENT '索引-景点ID',
  INDEX `idx_user_id`(`user_id`) USING BTREE COMMENT '索引-用户ID'
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '景点攻略信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of scenic_spot_strategy
-- ----------------------------
INSERT INTO `scenic_spot_strategy` VALUES (1, 19, 64, '景区配有专业讲解，非遗体验项目丰富，交通与食宿便利，是文化研学', 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=176879995135712.png', '这片秘境藏着大自然的鬼斧神工！青山叠翠间溪流潺潺，云海翻涌时宛如仙境，四季皆有别样风情 —— 春赏繁花似锦，夏沐清风避暑，秋观层林尽染，冬赏银装素裹。步道沿景延伸，既可徒步探秘原生植被，也能静坐观景台吸氧洗肺。配套设施完善，交通便捷，是远离尘嚣、沉浸式感受自然之美的绝佳旅游目的地，适合全家出游、好友结伴或独自放空。', '<p><br></p><p>历史瑰宝：世界文化遗产的恢弘气势 故宫，旧称紫禁城，</p><p>是世界上现存规模最大、保存最完整的木质结构古建筑群。这座建于明永乐四年（1406年）的皇家宫殿，历经明清两代24位皇帝，承载着中国近六百年的历史记忆。1987年，故宫被联合国教科文组织列入《世界文化遗产名录》，成为中华文明的重要象征。</p><p> 故宫占地72万平方米，建筑面积约15万平方米，拥有大小宫殿七十多座，房屋九千余间。整个建筑群以中轴线对称布局，分为外朝和内廷两部分。外朝以太和殿、中和殿、保和殿为中心，是皇帝举行重大典礼和朝会议政的场所；内廷以乾清宫、交泰殿、坤宁宫为中心，</p><p>是皇帝与后妃居住生活的地方。 二、必看亮点：不可错过的六大经典 </p><p>1. 太和殿：金銮宝殿的皇家气派 太和殿俗称“金銮殿”，是故宫等级最高的建筑。殿内金砖铺地，蟠龙金柱巍然屹立，正中的金龙宝座象征着皇权的至高无上。这里曾是皇帝登基、大婚、册立皇后等重大典礼的举行地。 </p><p>2. 珍宝馆：皇家奢侈品的视觉盛宴 位于宁寿宫区域的珍宝馆收藏着清宫珍宝数千件，包括金器、玉器、宝石、珍珠等。其中最引人注目的是乾隆皇帝的金瓯永固杯、</p><p>孝端皇后的凤冠、以及用一整块和田玉雕琢的“大禹治水”玉山。 </p><p>3. 钟表馆：中西合璧的计时艺术 奉先殿内的钟表馆陈列着清代宫廷收藏的各类钟表。这些钟表不仅计时精准，更融入了机械人偶、音乐、喷泉等复杂功能，展现了18-19世纪中西钟表制造的最高水平。 </p><p>4. 御花园：皇家园林的精致美学 位于故宫北端的御花园占地1.2万平方米，园内古树参天，奇石林立，亭台楼阁错落有致。</p><p>堆秀山上的御景亭是重阳节皇帝登高之处，园内的连理柏、诸葛拜北斗石等奇景都值得细细观赏。 5. 武英殿：书画珍品的艺术殿堂 近年来开放的武英殿区常设“故宫藏历代书画展”，展出晋唐宋元明清各代书画精品。王羲之《兰亭序》摹本、张择端《清明上河图》等国之重宝曾在此亮相。 6. 角楼：建筑艺术的巅峰之作 故宫四角的角楼被称为“九梁十八柱七十二条脊”，其复杂的木结构堪称中国古代建筑智慧的结晶。西北角楼是拍摄倒影的绝佳位置，清晨或黄昏时分光影最美。 </p>', 1, '2025-11-25 15:25:28');
INSERT INTO `scenic_spot_strategy` VALUES (3, 19, 64, '日山上的宏伟建筑,日山上的宏伟建筑', 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=176879993851114.png', 'Day1：喀什老城逛巴扎，品尝烤包子+百年老茶馆。午后办边防证。\nDay2：沿中巴友谊公路直抵白沙湖，银沙碧水震撼出片；午后抵喀拉库勒湖，仰望“冰川之父”慕士塔格峰。夜宿塔县。\nDay3：探访盘龙古道，体验“今日走完所有弯路”；下午返程，途经塔合曼湿地观牧场景观。', '<p><span style=\"color: rgb(15, 17, 21); background-color: rgb(255, 255, 255); font-size: 16px;\">Day1：喀什老城逛巴扎，品尝烤包子+百年老茶馆。午后办边防证。<br>Day2：沿中巴友谊公路直抵白沙湖，银沙碧水震撼出片；午后抵喀拉库勒湖，仰望“冰川之父”慕士塔格峰。夜宿塔县。<br>Day3：探访盘龙古道，体验“今日走完所有弯路”；下午返程，途经塔合曼湿地观牧场景观。</span></p>', 1, '2025-12-26 14:53:29');
INSERT INTO `scenic_spot_strategy` VALUES (4, 19, 59, '布达拉宫，这座矗立在拉萨玛布日山上的宏伟建筑', 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=17687996689026.png', '不仅是西藏的象征，更是世界屋脊上一颗璀璨的文化明珠。它始建于公元七世纪松赞干布时期，历经千年风雨和多次扩建', '<p style=\"text-align: start;\">布达拉宫，这座矗立在拉萨玛布日山上的宏伟建筑，不仅是西藏的象征，更是世界屋脊上一颗璀璨的文化明珠。它始建于公元七世纪松赞干布时期，历经千年风雨和多次扩建，最终形成了今日这般巍峨壮丽的规模。整座宫殿依山而建，层层叠叠，气势恢宏，完美融合了宫殿、城堡和寺院的多重功能，体现了藏式建筑的巅峰成就。</p><p style=\"text-align: start;\">从远处眺望，布达拉宫仿佛一座从山体中生长出来的圣殿，红宫与白宫错落有致，在蓝天白云的映衬下显得格外庄严神圣。白宫是历代达赖喇嘛处理政务和生活的地方，而红宫内则供奉着历代达赖喇嘛的灵塔，收藏着无数珍贵的佛教文物、壁画和经卷。宫内错综复杂的殿堂、走廊和佛殿，宛如一座巨大的迷宫，每一处都散发着浓厚的宗教氛围和历史沧桑。</p><p style=\"text-align: start;\">作为世界文化遗产，布达拉宫不仅是一座建筑奇迹，更是藏族文化、艺术和信仰的集中体现。它见证了西藏历史的变迁，承载着藏传佛教的精神传承。每天，无数信徒和游客沿着蜿蜒的台阶虔诚攀登，在这座圣殿中寻找心灵的宁静与历史的共鸣。布达拉宫如同一部立体的史书，向世人无声诉说着雪域高原的古老故事和永恒信仰。</p>', 1, '2026-01-12 17:33:51');
INSERT INTO `scenic_spot_strategy` VALUES (5, 16, 60, '西湖十景深度游：一日尽览人间天堂', 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=17687997118998.png', '西湖，杭州的灵魂所在，春夏秋冬各有韵味。本攻略带你一天内打卡西湖十景，体验白堤苏堤的浪漫，品味雷峰夕照的壮美。', '<p>西湖是中国首批国家重点风景名胜区，被列入《世界遗产名录》。湖面面积6.38平方公里，环湖一周约15公里。建议游览路线：断桥残雪 → 平湖秋月 → 苏堤春晓 → 花港观鱼 → 雷峰夕照 → 三潭印月。</p><p>最佳游览时间：春季（3-5月）桃花盛开；秋季（9-11月）桂花飘香。交通：可乘坐地铁1号线至龙翔桥站，步行5分钟即达。</p>', 1, '2025-10-15 09:30:00');
INSERT INTO `scenic_spot_strategy` VALUES (6, 16, 61, '八达岭长城徒步全攻略：不到长城非好汉', 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=17687996689026.png', '长城，世界七大奇迹之一。本攻略详细讲解八达岭长城的游览路线、最佳拍照点、注意事项，助你完成\"好汉\"之旅。', '<p>八达岭长城位于北京市延庆区，是明长城中保存最完整、最具代表性的一段。建议游玩时间：3-4小时。</p><p>游览路线：北线（北一楼至北八楼）相对陡峭，挑战性大；南线（南一楼至南四楼）相对平缓，适合老人小孩。最佳拍照点：北四楼的好汉石、北八楼的制高点。</p><p>交通：德胜门乘坐877路公交车直达，或乘坐市郊铁路S2线。</p>', 1, '2025-11-05 14:20:00');
INSERT INTO `scenic_spot_strategy` VALUES (7, 16, 62, '秦始皇兵马俑参观指南：探秘地下军团', 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=17687996689026.png', '世界第八大奇迹，两千年前的军事博物馆。本攻略带你了解兵马俑的发现历程、三大坑看点、最佳参观时间。', '<p>兵马俑位于西安市临潼区，是秦始皇陵的陪葬坑。现已发掘三个俑坑，总面积达2万多平方米。</p><p>一号坑：规模最大，有6000多个兵马俑，以步兵为主；二号坑：兵种最全，有骑兵、战车、弩兵；三号坑：指挥部，规模最小但最重要。</p><p>讲解建议：建议租用讲解器或请导游，否则难以理解其历史文化价值。避开周末和节假日，早晨开馆时人最少。</p>', 1, '2025-09-22 11:45:00');
INSERT INTO `scenic_spot_strategy` VALUES (8, 16, 62, '漓江竹筏漂流全记录：人在画中游', 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=17687996689026.png', '桂林山水甲天下，漓江风光最精华。本攻略详细介绍漓江漂流的路线选择、价格参考、摄影技巧。', '<p>漓江精华段从杨堤到兴坪，全长约20公里，游览时间约4小时。沿途著名景点：九马画山、黄布倒影（20元人民币背面图案）、兴坪古镇。</p><p>竹筏选择：建议选择正规旅游公司的电动竹筏，安全有保障。最佳摄影时间：清晨7-9点，下午4-6点，光线柔和，水面平静。</p><p>美食推荐：漓江边的啤酒鱼、桂林米粉、荔浦芋头扣肉。</p>', 1, '2025-12-01 16:10:00');
INSERT INTO `scenic_spot_strategy` VALUES (9, 16, 62, '张家界国家森林公园三日游：仙境之旅', 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=17687996689026.png', '《阿凡达》取景地，三千奇峰，八百秀水。本攻略规划三天两晚的完美行程，包含交通、住宿、美食推荐。', '<p>张家界国家森林公园是中国第一个国家森林公园，核心景区包括：袁家界、天子山、金鞭溪、杨家界。</p><p>三日游推荐行程：第一天：金鞭溪徒步 → 黄石寨；第二天：百龙天梯 → 袁家界 → 天子山；第三天：十里画廊 → 天门山。</p><p>住宿建议：武陵源景区门口酒店较多，交通便利。特色美食：土家三下锅、岩耳炖土鸡、葛根粉。</p>', 1, '2025-08-18 10:05:00');
INSERT INTO `scenic_spot_strategy` VALUES (10, 16, 63, '九寨沟秋季摄影攻略：上帝的调色盘', 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=17688000311518.png', '九寨归来不看水，秋季的九寨沟色彩斑斓。本攻略重点介绍最佳摄影点、光线运用、器材建议。', '<p>九寨沟位于四川省阿坝州，因沟内有九个藏族村寨而得名。最佳游览季节：9月下旬至10月下旬，红叶最盛。</p><p>必拍景点：五花海（色彩最丰富）、镜海（倒影最美）、诺日朗瀑布（中国最宽瀑布）、长海（海拔最高）。</p><p>摄影器材：广角镜头（拍大场景）、偏振镜（消除水面反光）、三脚架（拍慢门流水）。早上7点前入园可避开人流，拍到晨雾。</p>', 1, '2025-10-08 08:15:00');
INSERT INTO `scenic_spot_strategy` VALUES (11, 16, 63, '鼓浪屿文艺漫步：钢琴岛上的慢生活', 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=17688000238384.png', '万国建筑博览，音乐之岛。本攻略带你走进鼓浪屿的百年老别墅、特色咖啡馆、最美转角。', '<p>鼓浪屿面积1.91平方公里，岛上无机动车，全靠步行。建议游览时间：一天一夜。</p><p>经典路线：钢琴码头 → 龙头路商业街 → 日光岩（俯瞰全岛） → 菽庄花园 → 皓月园 → 风琴博物馆。</p><p>特色体验：在老别墅改造的咖啡馆喝下午茶、听一场免费钢琴演奏会、收集各个景点的印章。岛上住宿多为特色民宿，需提前预订。</p>', 1, '2025-11-12 13:40:00');
INSERT INTO `scenic_spot_strategy` VALUES (12, 16, 63, '大理洱海环湖骑行攻略：风花雪月之旅', 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=17688000395255.png', '下关风，上关花，苍山雪，洱海月。本攻略详细规划洱海130公里环湖骑行路线，包含租车、住宿、餐饮信息。', '<p>洱海周长约130公里，环湖骑行是体验大理的最佳方式。建议分2天完成，每天骑行约65公里。</p><p>骑行路线：大理古城 → 才村码头 → 喜洲古镇（午餐） → 双廊古镇（住宿） → 挖色镇 → 小普陀 → 下关 → 大理古城。</p><p>租车指南：古城内有多家租车行，山地车约30-50元/天，电动车约80-120元/天。注意事项：做好防晒，准备雨具，避开中午最热时段。</p>', 1, '2025-09-05 15:55:00');
INSERT INTO `scenic_spot_strategy` VALUES (13, 16, 63, '黄山云海日出观看指南：五岳归来不看山', 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=17688000165411.png', '黄山四绝：奇松、怪石、云海、温泉。本攻略重点讲解如何增加看到云海日出的概率，以及山上住宿选择。', '<p>黄山位于安徽省黄山市，最高峰莲花峰海拔1864米。最佳观云海地点：排云亭、始信峰、光明顶、鳌鱼峰。</p><p>云海形成条件：雨后初晴、温差较大、湿度适宜。建议在山上住一晚，早晨5点前到达观景台等候日出。</p><p>山上住宿：北海宾馆、西海饭店、光明顶山庄等，价格较高需提前预订。也可选择床位房（100-200元/床）。</p><p>黄山位于安徽省黄山市，最高峰莲花峰海拔1864米。最佳观云海地点：排云亭、始信峰、光明顶、鳌鱼峰。</p><p>云海形成条件：雨后初晴、温差较大、湿度适宜。建议在山上住一晚，早晨5点前到达观景台等候日出。</p><p>山上住宿：北海宾馆、西海饭店、光明顶山庄等，价格较高需提前预订。也可选择床位房（100-200元/床）。</p><p>黄山位于安徽省黄山市，最高峰莲花峰海拔1864米。最佳观云海地点：排云亭、始信峰、光明顶、鳌鱼峰。</p><p>云海形成条件：雨后初晴、温差较大、湿度适宜。建议在山上住一晚，早晨5点前到达观景台等候日出。</p><p>山上住宿：北海宾馆、西海饭店、光明顶山庄等，价格较高需提前预订。也可选择床位房（100-200元/床）。</p>', 1, '2025-12-10 07:25:00');
INSERT INTO `scenic_spot_strategy` VALUES (14, 16, 60, '莫高窟文化之旅：千年壁画的艺术殿堂', 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=17687996689026.png', '东方卢浮宫，丝绸之路上的文化瑰宝。本攻略详细介绍莫高窟的参观流程、洞窟分类、文物保护知识。', '<p>莫高窟位于甘肃省敦煌市，始建于前秦时期，现存洞窟735个，壁画4.5万平方米，彩塑2400余身。</p><p>参观流程：先在数字展示中心观看两部电影（《千年莫高》和《梦幻佛宫》），然后乘坐摆渡车前往洞窟区。每组游客由专业讲解员带领参观8个普通洞窟。</p><p>特别提醒：洞窟内禁止拍照，为了保护珍贵的壁画。建议提前在官网预约，旺季门票紧张。可额外付费参观特窟（有更精美的壁画和雕塑）。</p>', 1, '2025-10-28 12:30:00');

-- ----------------------------
-- Table structure for scenic_spot_ticket
-- ----------------------------
DROP TABLE IF EXISTS `scenic_spot_ticket`;
CREATE TABLE `scenic_spot_ticket`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '景点门票表主键ID，自增',
  `scenic_id` int(11) NULL DEFAULT NULL COMMENT '景点ID，外键，关联的是景点信息表',
  `total_number` int(11) NULL DEFAULT NULL COMMENT '总门票数',
  `price` decimal(10, 2) NULL DEFAULT NULL COMMENT '价格',
  `detail` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL COMMENT '备注',
  `start_date` date NULL DEFAULT NULL COMMENT '有效期开始日期',
  `end_date` date NULL DEFAULT NULL COMMENT '有效期结束日期',
  `status` tinyint(1) NULL DEFAULT NULL COMMENT '状态（1-暂停预约；2-正常）',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_scenic_id`(`scenic_id`) USING BTREE COMMENT '索引-景点ID'
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '景点门票信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of scenic_spot_ticket
-- ----------------------------
INSERT INTO `scenic_spot_ticket` VALUES (1, 20, 34, 89.90, '1. 门票包含：黄山风景区入园资格\n2. 有效时间：购票日当天有效\n3. 使用方式：凭身份证原件或电子二维码在景区大门核验入园\n4. 优惠政策：身高1.2米以下儿童、70周岁以上老人凭有效证件免票\n5. 注意事项：\n   - 请勿在非指定区域吸烟\n   - 请勿攀爬危险区域\n   - 如遇恶劣天气，景区可能临时关闭\n6. 退改规则：未使用可提前一天免费退票，过期作废\n7. 景区开放时间：6:30-17:00（旺季），7:00-16:30（淡季）', '2026-01-19', '2026-01-21', 2, '2026-01-05 19:27:44');
INSERT INTO `scenic_spot_ticket` VALUES (2, 20, 68, 109.90, '1. 适用范围：一票通玩（不含特殊收费项目）\r\n2. 入园时间：9:00-17:00，最晚入园16:00\r\n3. 适用人群：身高1.5米以上成人及儿童\r\n4. 包含项目：过山车、大摆锤、旋转木马等30余项游乐设施\r\n5. 注意事项：\r\n   - 部分项目有身高体重要求\r\n   - 心脏病、高血压患者请谨慎选择刺激项目\r\n   - 请妥善保管个人物品\r\n6. 特殊说明：不可携带食物及饮料入园\r\n7. 停车服务：园区提供收费停车场', '2026-01-07', '2026-03-08', 2, '2026-01-05 19:31:22');

-- ----------------------------
-- Table structure for scenic_spot_ticket_order
-- ----------------------------
DROP TABLE IF EXISTS `scenic_spot_ticket_order`;
CREATE TABLE `scenic_spot_ticket_order`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '景点门票订单主键ID，自增',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户ID，外键，关联的是用户信息表',
  `scenic_spot_ticket_id` int(11) NULL DEFAULT NULL COMMENT '景点门票ID，外键，关联的是景点门票信息表',
  `status` tinyint(1) NULL DEFAULT NULL COMMENT '订单状态（1-待付款；2-已核销；3-待使用；4-已取消）',
  `buy_number` int(11) NULL DEFAULT NULL COMMENT '购买数量',
  `price` decimal(10, 2) NULL DEFAULT NULL COMMENT '价格',
  `concat_username` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '联系人',
  `concat_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '联系电话',
  `idcard` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '身份证号',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `pay_time` datetime NULL DEFAULT NULL COMMENT '支付时间',
  `use_time` datetime NULL DEFAULT NULL COMMENT '核销时间',
  `cancel_time` datetime NULL DEFAULT NULL COMMENT '取消时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE COMMENT '索引-用户ID',
  INDEX `idx_scenic_spot_ticket_id`(`scenic_spot_ticket_id`) USING BTREE COMMENT '索引-门票ID',
  INDEX `idx_status_user_id`(`user_id`, `status`) USING BTREE COMMENT '索引-状态、用户ID'
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '景点门票订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of scenic_spot_ticket_order
-- ----------------------------
INSERT INTO `scenic_spot_ticket_order` VALUES (1, 60, 1, 3, 2, 179.80, '张三先生', '16767675632', '432432', '2026-01-10 16:15:29', '2026-01-10 16:26:14', NULL, '2026-01-10 16:25:34');
INSERT INTO `scenic_spot_ticket_order` VALUES (2, 60, 2, 4, 2, 219.80, '张三先生', '14565552121', '45345327632632', '2026-01-09 16:02:11', NULL, NULL, NULL);
INSERT INTO `scenic_spot_ticket_order` VALUES (3, 60, 1, 4, 1, 89.90, '李四', '1567677880121', '344532543543', '2026-01-09 14:42:45', NULL, NULL, NULL);
INSERT INTO `scenic_spot_ticket_order` VALUES (4, 60, 1, 3, 4, 359.60, '张三', '14556553122', '423423432', '2025-08-10 16:27:47', '2026-01-10 16:29:01', NULL, NULL);
INSERT INTO `scenic_spot_ticket_order` VALUES (6, 60, 2, 3, 2, 219.80, '453543', '543534', '543534', '2026-01-10 18:17:51', '2026-01-10 18:17:53', NULL, NULL);
INSERT INTO `scenic_spot_ticket_order` VALUES (7, 60, 1, 3, 3, 269.70, '432423', '5543', '534543', '2026-01-10 18:26:57', '2026-01-10 18:27:00', NULL, NULL);
INSERT INTO `scenic_spot_ticket_order` VALUES (9, 60, 2, 2, 3, 329.70, '543543', '543543', '543534', '2026-01-10 20:48:16', NULL, NULL, NULL);
INSERT INTO `scenic_spot_ticket_order` VALUES (10, 60, 2, 2, 3, 329.70, '543543', '543543', '543534', '2026-01-10 20:49:23', NULL, NULL, NULL);
INSERT INTO `scenic_spot_ticket_order` VALUES (11, 60, 1, 3, 3, 269.70, '543543', '5435345', '543534534', '2026-01-10 20:49:39', '2026-01-10 20:50:09', NULL, NULL);
INSERT INTO `scenic_spot_ticket_order` VALUES (13, 59, 2, 2, 2, 219.80, '李春然', '13445677676', '321321321321', '2026-01-11 15:28:50', '2026-01-11 15:28:56', '2026-01-11 15:57:02', NULL);
INSERT INTO `scenic_spot_ticket_order` VALUES (14, 59, 1, 3, 1, 89.90, 'tangyiyi', '13467678989', '4534543534543', '2026-01-11 17:08:38', '2026-01-11 17:08:42', NULL, NULL);
INSERT INTO `scenic_spot_ticket_order` VALUES (16, 60, 1, 3, 2, 179.80, '张三', '16778787878', '432453534534543543', '2026-01-18 22:28:12', '2026-01-18 22:28:33', NULL, NULL);
INSERT INTO `scenic_spot_ticket_order` VALUES (17, 60, 2, 2, 4, 439.60, 'zhangsan', '16767676764', '43242432432432', '2026-01-18 22:31:43', '2026-01-18 22:31:46', '2026-01-18 22:31:55', NULL);

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用户主键ID，自增',
  `account` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '账号',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '昵称',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '密码',
  `avatar` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '头像',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `role` int(11) NULL DEFAULT NULL COMMENT '角色',
  `gender` tinyint(1) NULL DEFAULT NULL COMMENT '性别（1-女；2-男）',
  `birthday` date NULL DEFAULT NULL COMMENT '生日',
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '手机号',
  `login_status` tinyint(1) NULL DEFAULT NULL COMMENT '登录状态（0-正常；1-封号）',
  `speak_status` tinyint(1) NULL DEFAULT NULL COMMENT '禁言状态（0-正常；1-禁言）',
  `last_login_time` datetime NULL DEFAULT NULL COMMENT '上一次登录时间',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间/登录时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 65 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'admin', 'tangyiyi', '14e1b600b1fd579f47433b88e8d85291', 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=1768800739229Snipaste_2025-05-20_15-12-23.png', '1567643@qq.com', 1, 2, '1990-05-06', '16736666666', 0, 0, '2026-01-19 13:04:22', '2024-10-19 12:53:05');
INSERT INTO `user` VALUES (59, 'lrenzhenjiuhao', 'tangyiyi', '14e1b600b1fd579f47433b88e8d85291', 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=1768799257451Snipaste_2025-04-25_15-25-48.png', '123342@qq.com', 2, 1, '1985-07-11', '17687665323', 0, 0, '2026-01-17 21:48:43', '2025-05-28 17:54:48');
INSERT INTO `user` VALUES (60, 'zhouzhiruo', '周芷若', '14e1b600b1fd579f47433b88e8d85291', 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=1768799248321Snipaste_2025-05-20_15-13-00.png', '23124231@qq.com', 2, 1, '1991-07-11', '16576666666', 0, 1, '2026-01-19 14:46:12', '2025-05-28 18:06:43');
INSERT INTO `user` VALUES (61, 'guihua', '桂花', '14e1b600b1fd579f47433b88e8d85291', 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=1768799117248Snipaste_2025-05-08_21-39-19.png', '14324@qq.com', 2, 1, NULL, NULL, 0, 0, '2026-01-15 16:46:45', '2025-05-29 14:13:04');
INSERT INTO `user` VALUES (62, 'zhangsan', '晨晨晨', '14e1b600b1fd579f47433b88e8d85291', 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=17687991098069.png', NULL, 2, 1, NULL, NULL, 0, 0, '2025-11-16 17:56:33', '2025-05-29 15:39:59');
INSERT INTO `user` VALUES (63, 'zhangsan2', 'tangyiyi', '14e1b600b1fd579f47433b88e8d85291', 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=1768800662894Snipaste_2025-05-20_15-13-00.png', '432432@qq.com', 2, 2, '1996-07-17', '17612442010', 1, 0, '2026-01-19 13:20:04', '2025-05-29 15:41:04');
INSERT INTO `user` VALUES (64, 'fangdongdemao', '房东的猫', '14e1b600b1fd579f47433b88e8d85291', 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=1768799079913Snipaste_2025-05-20_15-12-41.png', NULL, 2, 2, NULL, NULL, 0, 0, '2026-01-19 13:17:06', '2025-11-15 14:34:45');

-- ----------------------------
-- Table structure for user_action_operation
-- ----------------------------
DROP TABLE IF EXISTS `user_action_operation`;
CREATE TABLE `user_action_operation`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '用户行为操作信息表主键ID，自增',
  `user_id` int(11) NULL DEFAULT NULL COMMENT '用户ID，外键，关联的是用户信息表',
  `content_module` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '内容模块',
  `content_id` int(11) NULL DEFAULT NULL COMMENT '内容ID',
  `type` tinyint(1) NULL DEFAULT NULL COMMENT '行为类型（1-收藏；2-点赞；3-浏览；4-停留）',
  `stay_time` bigint(20) NULL DEFAULT NULL COMMENT '停留时长（行为类型是“停留”时才需要设置）',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id_type`(`user_id`, `type`) USING BTREE COMMENT '索引-用户ID、类型'
) ENGINE = InnoDB AUTO_INCREMENT = 1312 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '用户行为操作信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_action_operation
-- ----------------------------
INSERT INTO `user_action_operation` VALUES (17, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-24 20:55:32');
INSERT INTO `user_action_operation` VALUES (18, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-24 20:55:32');
INSERT INTO `user_action_operation` VALUES (19, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-24 20:55:32');
INSERT INTO `user_action_operation` VALUES (20, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-24 20:55:32');
INSERT INTO `user_action_operation` VALUES (21, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-24 20:55:32');
INSERT INTO `user_action_operation` VALUES (22, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-24 20:55:32');
INSERT INTO `user_action_operation` VALUES (23, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-24 20:55:32');
INSERT INTO `user_action_operation` VALUES (24, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-24 20:55:33');
INSERT INTO `user_action_operation` VALUES (25, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-24 20:55:33');
INSERT INTO `user_action_operation` VALUES (26, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-24 20:55:33');
INSERT INTO `user_action_operation` VALUES (27, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-24 20:55:33');
INSERT INTO `user_action_operation` VALUES (28, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-24 20:55:34');
INSERT INTO `user_action_operation` VALUES (29, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-24 20:55:35');
INSERT INTO `user_action_operation` VALUES (30, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-24 20:55:53');
INSERT INTO `user_action_operation` VALUES (31, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-24 20:58:15');
INSERT INTO `user_action_operation` VALUES (32, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-24 21:11:49');
INSERT INTO `user_action_operation` VALUES (33, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-24 21:11:57');
INSERT INTO `user_action_operation` VALUES (34, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-24 21:12:00');
INSERT INTO `user_action_operation` VALUES (35, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-24 21:12:15');
INSERT INTO `user_action_operation` VALUES (36, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-24 21:12:53');
INSERT INTO `user_action_operation` VALUES (37, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-24 21:13:08');
INSERT INTO `user_action_operation` VALUES (38, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-24 21:13:22');
INSERT INTO `user_action_operation` VALUES (39, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-24 21:13:36');
INSERT INTO `user_action_operation` VALUES (40, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-24 21:13:52');
INSERT INTO `user_action_operation` VALUES (41, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-24 21:14:02');
INSERT INTO `user_action_operation` VALUES (42, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-24 21:14:08');
INSERT INTO `user_action_operation` VALUES (43, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-24 21:14:21');
INSERT INTO `user_action_operation` VALUES (44, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-24 21:14:30');
INSERT INTO `user_action_operation` VALUES (45, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-24 21:15:43');
INSERT INTO `user_action_operation` VALUES (46, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-24 21:16:23');
INSERT INTO `user_action_operation` VALUES (47, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-24 21:16:55');
INSERT INTO `user_action_operation` VALUES (48, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-24 21:17:17');
INSERT INTO `user_action_operation` VALUES (49, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-24 21:17:35');
INSERT INTO `user_action_operation` VALUES (50, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-24 21:17:59');
INSERT INTO `user_action_operation` VALUES (51, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-24 21:18:16');
INSERT INTO `user_action_operation` VALUES (52, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-24 21:18:51');
INSERT INTO `user_action_operation` VALUES (53, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-24 21:18:55');
INSERT INTO `user_action_operation` VALUES (54, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-24 21:19:12');
INSERT INTO `user_action_operation` VALUES (55, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-24 21:19:16');
INSERT INTO `user_action_operation` VALUES (56, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-24 21:19:53');
INSERT INTO `user_action_operation` VALUES (57, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-24 21:20:45');
INSERT INTO `user_action_operation` VALUES (58, 60, 'SCENIC_SPOT', 19, 4, 143669, '2025-12-24 21:23:08');
INSERT INTO `user_action_operation` VALUES (59, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-24 21:23:08');
INSERT INTO `user_action_operation` VALUES (60, 60, 'SCENIC_SPOT', 19, 4, 53, '2025-12-24 21:24:02');
INSERT INTO `user_action_operation` VALUES (61, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-24 21:24:02');
INSERT INTO `user_action_operation` VALUES (62, 60, 'SCENIC_SPOT', 19, 4, 18, '2025-12-24 21:24:21');
INSERT INTO `user_action_operation` VALUES (63, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-24 21:24:21');
INSERT INTO `user_action_operation` VALUES (64, 60, 'SCENIC_SPOT', 19, 4, 20, '2025-12-24 21:24:41');
INSERT INTO `user_action_operation` VALUES (65, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-24 21:24:41');
INSERT INTO `user_action_operation` VALUES (66, 60, 'SCENIC_SPOT', 19, 4, 5, '2025-12-24 21:24:46');
INSERT INTO `user_action_operation` VALUES (67, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-24 21:24:46');
INSERT INTO `user_action_operation` VALUES (68, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-24 21:24:51');
INSERT INTO `user_action_operation` VALUES (69, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-24 21:25:09');
INSERT INTO `user_action_operation` VALUES (70, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-24 21:25:22');
INSERT INTO `user_action_operation` VALUES (71, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-24 21:25:46');
INSERT INTO `user_action_operation` VALUES (72, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-24 21:25:57');
INSERT INTO `user_action_operation` VALUES (73, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-24 21:28:06');
INSERT INTO `user_action_operation` VALUES (74, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-24 21:28:13');
INSERT INTO `user_action_operation` VALUES (75, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-24 21:28:29');
INSERT INTO `user_action_operation` VALUES (76, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-24 21:29:12');
INSERT INTO `user_action_operation` VALUES (77, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-24 21:32:10');
INSERT INTO `user_action_operation` VALUES (78, 60, 'SCENIC_SPOT', 20, 4, 3909, '2025-12-24 21:32:14');
INSERT INTO `user_action_operation` VALUES (79, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-24 21:32:21');
INSERT INTO `user_action_operation` VALUES (80, 60, 'SCENIC_SPOT', 19, 4, 4471, '2025-12-24 21:32:26');
INSERT INTO `user_action_operation` VALUES (81, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-24 21:32:37');
INSERT INTO `user_action_operation` VALUES (82, 60, 'SCENIC_SPOT', 19, 4, 9436, '2025-12-24 21:32:46');
INSERT INTO `user_action_operation` VALUES (83, 60, 'SCENIC_SPOT', 19, 4, 55090, '2025-12-24 21:33:32');
INSERT INTO `user_action_operation` VALUES (84, 60, 'SCENIC_SPOT', 19, 4, 86568, '2025-12-24 21:34:03');
INSERT INTO `user_action_operation` VALUES (85, 60, 'SCENIC_SPOT', 19, 4, 126559, '2025-12-24 21:34:43');
INSERT INTO `user_action_operation` VALUES (86, 60, 'SCENIC_SPOT', 19, 4, 139443, '2025-12-24 21:34:56');
INSERT INTO `user_action_operation` VALUES (87, 60, 'SCENIC_SPOT', 19, 4, 161418, '2025-12-24 21:35:18');
INSERT INTO `user_action_operation` VALUES (88, 60, 'SCENIC_SPOT', 19, 4, 168300, '2025-12-24 21:35:25');
INSERT INTO `user_action_operation` VALUES (89, 60, 'SCENIC_SPOT', 19, 4, 197514, '2025-12-24 21:35:54');
INSERT INTO `user_action_operation` VALUES (90, 60, 'SCENIC_SPOT', 19, 4, 205190, '2025-12-24 21:36:02');
INSERT INTO `user_action_operation` VALUES (91, 60, 'SCENIC_SPOT', 19, 4, 219816, '2025-12-24 21:36:16');
INSERT INTO `user_action_operation` VALUES (92, 60, 'SCENIC_SPOT', 19, 4, 244756, '2025-12-24 21:36:41');
INSERT INTO `user_action_operation` VALUES (93, 60, 'SCENIC_SPOT', 19, 4, 256995, '2025-12-24 21:36:53');
INSERT INTO `user_action_operation` VALUES (94, 60, 'SCENIC_SPOT', 19, 4, 278816, '2025-12-24 21:37:15');
INSERT INTO `user_action_operation` VALUES (95, 60, 'SCENIC_SPOT', 19, 4, 298681, '2025-12-24 21:37:35');
INSERT INTO `user_action_operation` VALUES (96, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-24 21:37:40');
INSERT INTO `user_action_operation` VALUES (97, 60, 'SCENIC_SPOT', 19, 4, 1223, '2025-12-24 21:37:41');
INSERT INTO `user_action_operation` VALUES (98, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-24 21:37:43');
INSERT INTO `user_action_operation` VALUES (99, 60, 'SCENIC_SPOT', 19, 4, 1552, '2025-12-24 21:37:44');
INSERT INTO `user_action_operation` VALUES (100, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-24 21:37:46');
INSERT INTO `user_action_operation` VALUES (102, 60, 'SCENIC_SPOT', 20, 4, 22221, '2025-12-24 21:38:08');
INSERT INTO `user_action_operation` VALUES (103, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-24 21:59:48');
INSERT INTO `user_action_operation` VALUES (104, 60, 'SCENIC_SPOT', 20, 4, 8822, '2025-12-24 21:59:56');
INSERT INTO `user_action_operation` VALUES (105, 60, 'SCENIC_SPOT', 20, 4, 68531, '2025-12-24 22:00:56');
INSERT INTO `user_action_operation` VALUES (106, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-24 22:00:56');
INSERT INTO `user_action_operation` VALUES (107, 60, 'SCENIC_SPOT', 20, 4, 1636, '2025-12-24 22:00:57');
INSERT INTO `user_action_operation` VALUES (108, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-24 22:00:57');
INSERT INTO `user_action_operation` VALUES (109, 60, 'SCENIC_SPOT', 20, 4, 59291, '2025-12-24 22:01:57');
INSERT INTO `user_action_operation` VALUES (110, 60, 'SCENIC_SPOT', 20, 4, 66853, '2025-12-24 22:02:04');
INSERT INTO `user_action_operation` VALUES (111, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-25 14:36:20');
INSERT INTO `user_action_operation` VALUES (112, 60, 'SCENIC_SPOT', 20, 4, 1188, '2025-12-25 14:36:21');
INSERT INTO `user_action_operation` VALUES (113, 60, 'SCENIC_SPOT', 20, 4, 1226, '2025-12-25 14:36:22');
INSERT INTO `user_action_operation` VALUES (114, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-25 14:37:02');
INSERT INTO `user_action_operation` VALUES (115, 60, 'SCENIC_SPOT', 19, 4, 1294, '2025-12-25 14:37:03');
INSERT INTO `user_action_operation` VALUES (116, 60, 'SCENIC_SPOT', 19, 4, 1333, '2025-12-25 14:37:03');
INSERT INTO `user_action_operation` VALUES (117, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-25 17:13:14');
INSERT INTO `user_action_operation` VALUES (118, 60, 'SCENIC_SPOT', 19, 4, 6121, '2025-12-25 17:13:20');
INSERT INTO `user_action_operation` VALUES (119, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-25 17:15:22');
INSERT INTO `user_action_operation` VALUES (120, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-25 17:26:55');
INSERT INTO `user_action_operation` VALUES (121, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-25 17:26:58');
INSERT INTO `user_action_operation` VALUES (122, 60, 'SCENIC_SPOT', 1, 3, NULL, '2025-12-26 15:02:14');
INSERT INTO `user_action_operation` VALUES (123, 60, 'SCENIC_SPOT', 1, 4, 12806, '2025-12-26 15:02:27');
INSERT INTO `user_action_operation` VALUES (124, 60, 'SCENIC_SPOT', 1, 4, 33947, '2025-12-26 15:02:48');
INSERT INTO `user_action_operation` VALUES (125, 60, 'SCENIC_SPOT', 1, 4, 48042, '2025-12-26 15:03:02');
INSERT INTO `user_action_operation` VALUES (126, 60, 'SCENIC_SPOT', 1, 4, 67695, '2025-12-26 15:03:22');
INSERT INTO `user_action_operation` VALUES (127, 60, 'SCENIC_SPOT', 1, 4, 81610, '2025-12-26 15:03:36');
INSERT INTO `user_action_operation` VALUES (128, 60, 'SCENIC_SPOT_STRATEGY', 1, 3, NULL, '2025-12-26 15:03:36');
INSERT INTO `user_action_operation` VALUES (130, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 11418, '2025-12-26 15:03:47');
INSERT INTO `user_action_operation` VALUES (131, 60, 'SCENIC_SPOT_STRATEGY', 1, 3, NULL, '2025-12-26 15:03:47');
INSERT INTO `user_action_operation` VALUES (132, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 1516, '2025-12-26 15:03:49');
INSERT INTO `user_action_operation` VALUES (133, 60, 'SCENIC_SPOT_STRATEGY', 3, 3, NULL, '2025-12-26 15:03:51');
INSERT INTO `user_action_operation` VALUES (135, 60, 'SCENIC_SPOT_STRATEGY', 3, 2, NULL, '2025-12-26 15:03:52');
INSERT INTO `user_action_operation` VALUES (136, 60, 'SCENIC_SPOT_STRATEGY', 3, 4, 2815, '2025-12-26 15:03:54');
INSERT INTO `user_action_operation` VALUES (137, 60, 'SCENIC_SPOT_STRATEGY', 1, 3, NULL, '2025-12-26 15:03:56');
INSERT INTO `user_action_operation` VALUES (139, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 13960, '2025-12-26 15:04:10');
INSERT INTO `user_action_operation` VALUES (140, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 25445, '2025-12-26 15:04:22');
INSERT INTO `user_action_operation` VALUES (141, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 36409, '2025-12-26 15:04:33');
INSERT INTO `user_action_operation` VALUES (142, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 62731, '2025-12-26 15:04:59');
INSERT INTO `user_action_operation` VALUES (143, 60, 'SCENIC_SPOT_STRATEGY', 1, 3, NULL, '2025-12-26 15:04:59');
INSERT INTO `user_action_operation` VALUES (144, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 58122, '2025-12-26 15:05:57');
INSERT INTO `user_action_operation` VALUES (145, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 72659, '2025-12-26 15:06:12');
INSERT INTO `user_action_operation` VALUES (146, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 79008, '2025-12-26 15:06:18');
INSERT INTO `user_action_operation` VALUES (147, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 95266, '2025-12-26 15:06:34');
INSERT INTO `user_action_operation` VALUES (148, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 144174, '2025-12-26 15:07:23');
INSERT INTO `user_action_operation` VALUES (149, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 149438, '2025-12-26 15:07:29');
INSERT INTO `user_action_operation` VALUES (150, 60, 'SCENIC_SPOT_STRATEGY', 1, 3, NULL, '2025-12-26 15:07:29');
INSERT INTO `user_action_operation` VALUES (151, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 14726, '2025-12-26 15:07:44');
INSERT INTO `user_action_operation` VALUES (152, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 90054, '2025-12-26 15:08:59');
INSERT INTO `user_action_operation` VALUES (153, 60, 'SCENIC_SPOT_STRATEGY', 1, 3, NULL, '2025-12-26 15:08:59');
INSERT INTO `user_action_operation` VALUES (154, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 3106, '2025-12-26 15:09:02');
INSERT INTO `user_action_operation` VALUES (155, 60, 'SCENIC_SPOT_STRATEGY', 1, 3, NULL, '2025-12-26 15:09:02');
INSERT INTO `user_action_operation` VALUES (156, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 21898, '2025-12-26 15:09:24');
INSERT INTO `user_action_operation` VALUES (157, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 53033, '2025-12-26 15:09:55');
INSERT INTO `user_action_operation` VALUES (158, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 66645, '2025-12-26 15:10:09');
INSERT INTO `user_action_operation` VALUES (159, 60, 'SCENIC_SPOT_STRATEGY', 1, 3, NULL, '2025-12-26 15:10:09');
INSERT INTO `user_action_operation` VALUES (160, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 33311, '2025-12-26 15:10:42');
INSERT INTO `user_action_operation` VALUES (161, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 47352, '2025-12-26 15:10:56');
INSERT INTO `user_action_operation` VALUES (162, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 55323, '2025-12-26 15:11:04');
INSERT INTO `user_action_operation` VALUES (163, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 68797, '2025-12-26 15:11:17');
INSERT INTO `user_action_operation` VALUES (164, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 95057, '2025-12-26 15:11:44');
INSERT INTO `user_action_operation` VALUES (165, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 146416, '2025-12-26 15:12:35');
INSERT INTO `user_action_operation` VALUES (166, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 178976, '2025-12-26 15:13:08');
INSERT INTO `user_action_operation` VALUES (167, 60, 'SCENIC_SPOT_STRATEGY', 1, 3, NULL, '2025-12-26 15:13:08');
INSERT INTO `user_action_operation` VALUES (168, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 56561, '2025-12-26 15:14:04');
INSERT INTO `user_action_operation` VALUES (169, 60, 'SCENIC_SPOT_STRATEGY', 1, 3, NULL, '2025-12-26 15:14:04');
INSERT INTO `user_action_operation` VALUES (170, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 17251, '2025-12-26 15:14:21');
INSERT INTO `user_action_operation` VALUES (171, 60, 'SCENIC_SPOT_STRATEGY', 1, 3, NULL, '2025-12-26 15:14:21');
INSERT INTO `user_action_operation` VALUES (172, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 4290, '2025-12-26 15:14:26');
INSERT INTO `user_action_operation` VALUES (173, 60, 'SCENIC_SPOT_STRATEGY', 1, 3, NULL, '2025-12-26 15:14:26');
INSERT INTO `user_action_operation` VALUES (174, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 2301, '2025-12-26 15:14:28');
INSERT INTO `user_action_operation` VALUES (175, 60, 'SCENIC_SPOT_STRATEGY', 3, 3, NULL, '2025-12-26 15:14:30');
INSERT INTO `user_action_operation` VALUES (176, 60, 'SCENIC_SPOT_STRATEGY', 3, 4, 3312, '2025-12-26 15:14:34');
INSERT INTO `user_action_operation` VALUES (177, 1, 'SCENIC_SPOT_STRATEGY', 3, 3, NULL, '2025-12-26 15:43:25');
INSERT INTO `user_action_operation` VALUES (178, 1, 'SCENIC_SPOT_STRATEGY', 3, 4, 25749, '2025-12-26 15:43:51');
INSERT INTO `user_action_operation` VALUES (179, 1, 'SCENIC_SPOT_STRATEGY', 3, 4, 49787, '2025-12-26 15:44:15');
INSERT INTO `user_action_operation` VALUES (180, 1, 'SCENIC_SPOT_STRATEGY', 3, 4, 56567, '2025-12-26 15:44:22');
INSERT INTO `user_action_operation` VALUES (181, 1, 'SCENIC_SPOT_STRATEGY', 3, 4, 67220, '2025-12-26 15:44:32');
INSERT INTO `user_action_operation` VALUES (182, 1, 'SCENIC_SPOT_STRATEGY', 3, 4, 73417, '2025-12-26 15:44:39');
INSERT INTO `user_action_operation` VALUES (183, 1, 'SCENIC_SPOT_STRATEGY', 3, 4, 85580, '2025-12-26 15:44:51');
INSERT INTO `user_action_operation` VALUES (184, 1, 'SCENIC_SPOT_STRATEGY', 3, 4, 94740, '2025-12-26 15:45:00');
INSERT INTO `user_action_operation` VALUES (185, 1, 'SCENIC_SPOT_STRATEGY', 3, 4, 167215, '2025-12-26 15:46:12');
INSERT INTO `user_action_operation` VALUES (186, 1, 'SCENIC_SPOT_STRATEGY', 3, 4, 191157, '2025-12-26 15:46:36');
INSERT INTO `user_action_operation` VALUES (187, 1, 'SCENIC_SPOT_STRATEGY', 3, 4, 199355, '2025-12-26 15:46:45');
INSERT INTO `user_action_operation` VALUES (188, 1, 'SCENIC_SPOT_STRATEGY', 3, 4, 199382, '2025-12-26 15:46:45');
INSERT INTO `user_action_operation` VALUES (189, 1, 'SCENIC_SPOT_STRATEGY', 3, 3, NULL, '2025-12-26 15:46:47');
INSERT INTO `user_action_operation` VALUES (190, 1, 'SCENIC_SPOT_STRATEGY', 3, 4, 5032, '2025-12-26 15:46:52');
INSERT INTO `user_action_operation` VALUES (191, 1, 'SCENIC_SPOT_STRATEGY', 3, 4, 20353, '2025-12-26 15:47:07');
INSERT INTO `user_action_operation` VALUES (192, 1, 'SCENIC_SPOT_STRATEGY', 3, 3, NULL, '2025-12-26 15:47:07');
INSERT INTO `user_action_operation` VALUES (193, 1, 'SCENIC_SPOT_STRATEGY', 3, 4, 28016, '2025-12-26 15:47:35');
INSERT INTO `user_action_operation` VALUES (194, 60, 'SCENIC_SPOT_STRATEGY', 1, 3, NULL, '2025-12-26 16:51:00');
INSERT INTO `user_action_operation` VALUES (195, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 2052, '2025-12-26 16:51:02');
INSERT INTO `user_action_operation` VALUES (196, 60, 'SCENIC_SPOT_STRATEGY', 1, 3, NULL, '2025-12-26 16:51:04');
INSERT INTO `user_action_operation` VALUES (197, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 1334, '2025-12-26 16:51:05');
INSERT INTO `user_action_operation` VALUES (198, 60, 'SCENIC_SPOT_STRATEGY', 1, 3, NULL, '2025-12-26 17:11:30');
INSERT INTO `user_action_operation` VALUES (199, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 1901, '2025-12-26 17:11:31');
INSERT INTO `user_action_operation` VALUES (200, 60, 'SCENIC_SPOT_STRATEGY', 1, 3, NULL, '2025-12-26 17:33:03');
INSERT INTO `user_action_operation` VALUES (201, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 1381, '2025-12-26 17:33:04');
INSERT INTO `user_action_operation` VALUES (202, 60, 'SCENIC_SPOT_STRATEGY', 1, 3, NULL, '2025-12-26 17:33:11');
INSERT INTO `user_action_operation` VALUES (203, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 2864, '2025-12-26 17:33:14');
INSERT INTO `user_action_operation` VALUES (204, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-26 17:57:21');
INSERT INTO `user_action_operation` VALUES (205, 60, 'SCENIC_SPOT', 19, 4, 3494, '2025-12-26 17:57:25');
INSERT INTO `user_action_operation` VALUES (206, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-26 17:57:40');
INSERT INTO `user_action_operation` VALUES (208, 60, 'SCENIC_SPOT', 19, 4, 1735, '2025-12-26 17:57:42');
INSERT INTO `user_action_operation` VALUES (209, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-26 18:00:19');
INSERT INTO `user_action_operation` VALUES (210, 60, 'SCENIC_SPOT', 19, 2, NULL, '2025-12-26 18:00:22');
INSERT INTO `user_action_operation` VALUES (211, 60, 'SCENIC_SPOT', 19, 4, 5090, '2025-12-26 18:00:24');
INSERT INTO `user_action_operation` VALUES (212, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-26 18:00:25');
INSERT INTO `user_action_operation` VALUES (213, 60, 'SCENIC_SPOT', 19, 4, 2109, '2025-12-26 18:00:27');
INSERT INTO `user_action_operation` VALUES (214, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-26 18:00:28');
INSERT INTO `user_action_operation` VALUES (215, 60, 'SCENIC_SPOT', 19, 4, 6973, '2025-12-26 18:00:35');
INSERT INTO `user_action_operation` VALUES (216, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-26 18:00:36');
INSERT INTO `user_action_operation` VALUES (217, 60, 'SCENIC_SPOT', 19, 4, 3083, '2025-12-26 18:00:39');
INSERT INTO `user_action_operation` VALUES (218, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-26 18:01:18');
INSERT INTO `user_action_operation` VALUES (219, 60, 'SCENIC_SPOT', 19, 4, 1532, '2025-12-26 18:01:19');
INSERT INTO `user_action_operation` VALUES (220, 60, 'SCENIC_SPOT', 9, 3, NULL, '2025-12-26 18:01:23');
INSERT INTO `user_action_operation` VALUES (222, 60, 'SCENIC_SPOT', 9, 4, 3391, '2025-12-26 18:01:26');
INSERT INTO `user_action_operation` VALUES (223, 60, 'SCENIC_SPOT', 19, 3, NULL, '2025-12-26 18:03:19');
INSERT INTO `user_action_operation` VALUES (224, 60, 'SCENIC_SPOT', 19, 4, 2608, '2025-12-26 18:03:21');
INSERT INTO `user_action_operation` VALUES (225, 60, 'SCENIC_SPOT', 9, 3, NULL, '2025-12-26 18:03:23');
INSERT INTO `user_action_operation` VALUES (226, 60, 'SCENIC_SPOT', 9, 4, 1191, '2025-12-26 18:03:24');
INSERT INTO `user_action_operation` VALUES (227, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-26 18:03:25');
INSERT INTO `user_action_operation` VALUES (228, 60, 'SCENIC_SPOT', 20, 4, 1902, '2025-12-26 18:03:27');
INSERT INTO `user_action_operation` VALUES (229, 60, 'SCENIC_SPOT', 9, 4, 5247, '2025-12-26 18:03:28');
INSERT INTO `user_action_operation` VALUES (230, 60, 'SCENIC_SPOT', 19, 4, 9917, '2025-12-26 18:03:29');
INSERT INTO `user_action_operation` VALUES (231, 60, 'SCENIC_SPOT', 20, 4, 4446, '2025-12-26 18:03:30');
INSERT INTO `user_action_operation` VALUES (232, 60, 'SCENIC_SPOT', 9, 3, NULL, '2025-12-26 20:31:13');
INSERT INTO `user_action_operation` VALUES (233, 60, 'SCENIC_SPOT', 9, 4, 3549, '2025-12-26 20:31:16');
INSERT INTO `user_action_operation` VALUES (234, 60, 'SCENIC_SPOT_STRATEGY', 1, 3, NULL, '2025-12-26 20:42:08');
INSERT INTO `user_action_operation` VALUES (235, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 2282, '2025-12-26 20:42:10');
INSERT INTO `user_action_operation` VALUES (236, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 4084, '2025-12-26 20:42:12');
INSERT INTO `user_action_operation` VALUES (237, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 7495, '2025-12-26 20:42:15');
INSERT INTO `user_action_operation` VALUES (238, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 10344, '2025-12-26 20:42:18');
INSERT INTO `user_action_operation` VALUES (239, 60, 'SCENIC_SPOT_STRATEGY', 1, 3, NULL, '2025-12-26 20:42:49');
INSERT INTO `user_action_operation` VALUES (240, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 1147, '2025-12-26 20:42:51');
INSERT INTO `user_action_operation` VALUES (241, 60, 'SCENIC_SPOT_STRATEGY', 1, 3, NULL, '2025-12-26 20:43:10');
INSERT INTO `user_action_operation` VALUES (242, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 1930, '2025-12-26 20:43:12');
INSERT INTO `user_action_operation` VALUES (243, 60, 'SCENIC_SPOT_STRATEGY', 1, 3, NULL, '2025-12-26 20:43:21');
INSERT INTO `user_action_operation` VALUES (244, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 1875, '2025-12-26 20:43:23');
INSERT INTO `user_action_operation` VALUES (245, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-26 20:43:32');
INSERT INTO `user_action_operation` VALUES (246, 60, 'SCENIC_SPOT', 20, 4, 1801, '2025-12-26 20:43:34');
INSERT INTO `user_action_operation` VALUES (247, 60, 'SCENIC_SPOT_STRATEGY', 1, 3, NULL, '2025-12-26 20:44:34');
INSERT INTO `user_action_operation` VALUES (249, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 1823, '2025-12-26 20:44:36');
INSERT INTO `user_action_operation` VALUES (250, 60, 'SCENIC_SPOT_STRATEGY', 3, 3, NULL, '2025-12-26 20:44:42');
INSERT INTO `user_action_operation` VALUES (251, 60, 'SCENIC_SPOT_STRATEGY', 3, 4, 17697, '2025-12-26 20:45:00');
INSERT INTO `user_action_operation` VALUES (252, 60, 'SCENIC_SPOT_STRATEGY', 3, 4, 25498, '2025-12-26 20:45:08');
INSERT INTO `user_action_operation` VALUES (253, 60, 'SCENIC_SPOT_STRATEGY', 3, 4, 43921, '2025-12-26 20:45:26');
INSERT INTO `user_action_operation` VALUES (254, 60, 'SCENIC_SPOT_STRATEGY', 3, 4, 124275, '2025-12-26 20:46:47');
INSERT INTO `user_action_operation` VALUES (255, 60, 'SCENIC_SPOT_STRATEGY', 3, 3, NULL, '2025-12-26 20:46:47');
INSERT INTO `user_action_operation` VALUES (256, 60, 'SCENIC_SPOT_STRATEGY', 3, 4, 112, '2025-12-26 20:46:47');
INSERT INTO `user_action_operation` VALUES (257, 60, 'SCENIC_SPOT_STRATEGY', 1, 3, NULL, '2025-12-26 20:48:01');
INSERT INTO `user_action_operation` VALUES (258, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 1680, '2025-12-26 20:48:03');
INSERT INTO `user_action_operation` VALUES (259, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 3251, '2025-12-26 20:48:05');
INSERT INTO `user_action_operation` VALUES (260, 60, 'SCENIC_SPOT_STRATEGY', 1, 3, NULL, '2025-12-26 20:49:56');
INSERT INTO `user_action_operation` VALUES (262, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 1627, '2025-12-26 20:49:58');
INSERT INTO `user_action_operation` VALUES (263, 60, 'SCENIC_SPOT', 18, 3, NULL, '2025-12-29 17:39:39');
INSERT INTO `user_action_operation` VALUES (264, 60, 'SCENIC_SPOT', 18, 4, 3589, '2025-12-29 17:39:42');
INSERT INTO `user_action_operation` VALUES (265, 60, 'SCENIC_SPOT', 18, 3, NULL, '2025-12-29 17:41:12');
INSERT INTO `user_action_operation` VALUES (266, 60, 'SCENIC_SPOT', 18, 4, 4233, '2025-12-29 17:41:16');
INSERT INTO `user_action_operation` VALUES (267, 60, 'SCENIC_SPOT', 18, 3, NULL, '2025-12-29 18:52:53');
INSERT INTO `user_action_operation` VALUES (268, 60, 'SCENIC_SPOT', 18, 4, 47746, '2025-12-29 18:53:41');
INSERT INTO `user_action_operation` VALUES (269, 60, 'SCENIC_SPOT', 18, 4, 79881, '2025-12-29 18:54:13');
INSERT INTO `user_action_operation` VALUES (270, 60, 'SCENIC_SPOT', 18, 4, 88581, '2025-12-29 18:54:22');
INSERT INTO `user_action_operation` VALUES (271, 60, 'SCENIC_SPOT', 18, 4, 123860, '2025-12-29 18:54:57');
INSERT INTO `user_action_operation` VALUES (272, 60, 'SCENIC_SPOT', 18, 4, 129163, '2025-12-29 18:55:02');
INSERT INTO `user_action_operation` VALUES (273, 60, 'SCENIC_SPOT', 18, 4, 145158, '2025-12-29 18:55:18');
INSERT INTO `user_action_operation` VALUES (274, 60, 'SCENIC_SPOT', 18, 4, 167149, '2025-12-29 18:55:40');
INSERT INTO `user_action_operation` VALUES (275, 60, 'SCENIC_SPOT', 18, 4, 172624, '2025-12-29 18:55:46');
INSERT INTO `user_action_operation` VALUES (276, 60, 'SCENIC_SPOT', 18, 4, 179281, '2025-12-29 18:55:52');
INSERT INTO `user_action_operation` VALUES (277, 60, 'SCENIC_SPOT', 18, 4, 190802, '2025-12-29 18:56:04');
INSERT INTO `user_action_operation` VALUES (278, 60, 'SCENIC_SPOT', 18, 4, 195007, '2025-12-29 18:56:08');
INSERT INTO `user_action_operation` VALUES (279, 60, 'SCENIC_SPOT', 18, 4, 198771, '2025-12-29 18:56:12');
INSERT INTO `user_action_operation` VALUES (280, 60, 'SCENIC_SPOT', 18, 3, NULL, '2025-12-29 18:56:12');
INSERT INTO `user_action_operation` VALUES (281, 60, 'SCENIC_SPOT', 18, 4, 2765, '2025-12-29 18:56:15');
INSERT INTO `user_action_operation` VALUES (282, 60, 'SCENIC_SPOT', 18, 4, 7070, '2025-12-29 18:56:19');
INSERT INTO `user_action_operation` VALUES (283, 60, 'SCENIC_SPOT', 18, 4, 15469, '2025-12-29 18:56:27');
INSERT INTO `user_action_operation` VALUES (284, 60, 'SCENIC_SPOT', 18, 4, 32667, '2025-12-29 18:56:44');
INSERT INTO `user_action_operation` VALUES (285, 60, 'SCENIC_SPOT', 18, 4, 49984, '2025-12-29 18:57:02');
INSERT INTO `user_action_operation` VALUES (286, 60, 'SCENIC_SPOT', 18, 4, 53448, '2025-12-29 18:57:05');
INSERT INTO `user_action_operation` VALUES (287, 60, 'SCENIC_SPOT', 18, 4, 57829, '2025-12-29 18:57:10');
INSERT INTO `user_action_operation` VALUES (288, 60, 'SCENIC_SPOT', 18, 4, 72621, '2025-12-29 18:57:24');
INSERT INTO `user_action_operation` VALUES (289, 60, 'SCENIC_SPOT', 18, 4, 84111, '2025-12-29 18:57:36');
INSERT INTO `user_action_operation` VALUES (290, 60, 'SCENIC_SPOT', 18, 4, 106062, '2025-12-29 18:57:58');
INSERT INTO `user_action_operation` VALUES (291, 60, 'SCENIC_SPOT', 18, 4, 118747, '2025-12-29 18:58:11');
INSERT INTO `user_action_operation` VALUES (292, 60, 'SCENIC_SPOT', 18, 4, 131980, '2025-12-29 18:58:24');
INSERT INTO `user_action_operation` VALUES (293, 60, 'SCENIC_SPOT', 18, 4, 144733, '2025-12-29 18:58:37');
INSERT INTO `user_action_operation` VALUES (294, 60, 'SCENIC_SPOT', 18, 3, NULL, '2025-12-29 18:58:37');
INSERT INTO `user_action_operation` VALUES (295, 60, 'SCENIC_SPOT', 18, 4, 1064, '2025-12-29 18:58:38');
INSERT INTO `user_action_operation` VALUES (296, 60, 'SCENIC_SPOT', 18, 4, 7707, '2025-12-29 18:58:44');
INSERT INTO `user_action_operation` VALUES (297, 60, 'SCENIC_SPOT', 18, 4, 22296, '2025-12-29 18:58:59');
INSERT INTO `user_action_operation` VALUES (298, 60, 'SCENIC_SPOT', 18, 4, 64091, '2025-12-29 18:59:41');
INSERT INTO `user_action_operation` VALUES (299, 60, 'SCENIC_SPOT', 18, 4, 75656, '2025-12-29 18:59:52');
INSERT INTO `user_action_operation` VALUES (300, 60, 'SCENIC_SPOT', 18, 4, 83462, '2025-12-29 19:00:00');
INSERT INTO `user_action_operation` VALUES (301, 60, 'SCENIC_SPOT', 18, 4, 87824, '2025-12-29 19:00:04');
INSERT INTO `user_action_operation` VALUES (302, 60, 'SCENIC_SPOT', 18, 4, 103628, '2025-12-29 19:00:20');
INSERT INTO `user_action_operation` VALUES (303, 60, 'SCENIC_SPOT', 18, 4, 110165, '2025-12-29 19:00:27');
INSERT INTO `user_action_operation` VALUES (304, 60, 'SCENIC_SPOT', 18, 4, 121376, '2025-12-29 19:00:38');
INSERT INTO `user_action_operation` VALUES (305, 60, 'SCENIC_SPOT', 18, 4, 125957, '2025-12-29 19:00:43');
INSERT INTO `user_action_operation` VALUES (306, 60, 'SCENIC_SPOT', 18, 4, 162855, '2025-12-29 19:01:20');
INSERT INTO `user_action_operation` VALUES (307, 60, 'SCENIC_SPOT', 18, 4, 187032, '2025-12-29 19:01:44');
INSERT INTO `user_action_operation` VALUES (308, 60, 'SCENIC_SPOT', 18, 4, 320107, '2025-12-29 19:03:57');
INSERT INTO `user_action_operation` VALUES (309, 60, 'SCENIC_SPOT', 18, 3, NULL, '2025-12-29 19:03:57');
INSERT INTO `user_action_operation` VALUES (310, 60, 'SCENIC_SPOT', 18, 4, 8705, '2025-12-29 19:04:05');
INSERT INTO `user_action_operation` VALUES (311, 60, 'SCENIC_SPOT', 18, 3, NULL, '2025-12-29 19:04:06');
INSERT INTO `user_action_operation` VALUES (312, 60, 'SCENIC_SPOT', 18, 4, 161383, '2025-12-29 19:06:47');
INSERT INTO `user_action_operation` VALUES (313, 60, 'SCENIC_SPOT', 18, 4, 214963, '2025-12-29 19:07:40');
INSERT INTO `user_action_operation` VALUES (314, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 19:07:46');
INSERT INTO `user_action_operation` VALUES (315, 60, 'SCENIC_SPOT', 20, 4, 23898, '2025-12-29 19:08:10');
INSERT INTO `user_action_operation` VALUES (316, 60, 'SCENIC_SPOT', 20, 4, 69887, '2025-12-29 19:08:56');
INSERT INTO `user_action_operation` VALUES (317, 60, 'SCENIC_SPOT', 20, 4, 125127, '2025-12-29 19:09:51');
INSERT INTO `user_action_operation` VALUES (318, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 19:09:51');
INSERT INTO `user_action_operation` VALUES (319, 60, 'SCENIC_SPOT', 20, 4, 5412, '2025-12-29 19:09:57');
INSERT INTO `user_action_operation` VALUES (320, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 19:09:57');
INSERT INTO `user_action_operation` VALUES (321, 60, 'SCENIC_SPOT', 20, 4, 15578, '2025-12-29 19:10:12');
INSERT INTO `user_action_operation` VALUES (322, 60, 'SCENIC_SPOT', 20, 4, 77001, '2025-12-29 19:11:14');
INSERT INTO `user_action_operation` VALUES (323, 60, 'SCENIC_SPOT', 20, 4, 112874, '2025-12-29 19:11:50');
INSERT INTO `user_action_operation` VALUES (324, 60, 'SCENIC_SPOT', 20, 4, 141634, '2025-12-29 19:12:18');
INSERT INTO `user_action_operation` VALUES (325, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 19:12:18');
INSERT INTO `user_action_operation` VALUES (326, 60, 'SCENIC_SPOT', 20, 4, 5818, '2025-12-29 19:12:24');
INSERT INTO `user_action_operation` VALUES (327, 60, 'SCENIC_SPOT', 20, 4, 43760, '2025-12-29 19:13:02');
INSERT INTO `user_action_operation` VALUES (328, 60, 'SCENIC_SPOT', 20, 4, 128398, '2025-12-29 19:14:27');
INSERT INTO `user_action_operation` VALUES (329, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 19:14:27');
INSERT INTO `user_action_operation` VALUES (330, 60, 'SCENIC_SPOT', 20, 4, 5504, '2025-12-29 19:14:32');
INSERT INTO `user_action_operation` VALUES (331, 60, 'SCENIC_SPOT', 20, 4, 23418, '2025-12-29 19:14:50');
INSERT INTO `user_action_operation` VALUES (332, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 19:16:38');
INSERT INTO `user_action_operation` VALUES (333, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 19:16:40');
INSERT INTO `user_action_operation` VALUES (334, 60, 'SCENIC_SPOT', 20, 4, 15700, '2025-12-29 19:16:55');
INSERT INTO `user_action_operation` VALUES (335, 60, 'SCENIC_SPOT', 20, 4, 15712, '2025-12-29 19:16:55');
INSERT INTO `user_action_operation` VALUES (336, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 19:17:09');
INSERT INTO `user_action_operation` VALUES (337, 60, 'SCENIC_SPOT', 20, 4, 4664, '2025-12-29 19:17:13');
INSERT INTO `user_action_operation` VALUES (338, 60, 'SCENIC_SPOT', 20, 4, 14934, '2025-12-29 19:17:23');
INSERT INTO `user_action_operation` VALUES (339, 60, 'SCENIC_SPOT', 20, 4, 17769, '2025-12-29 19:17:26');
INSERT INTO `user_action_operation` VALUES (340, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 19:17:26');
INSERT INTO `user_action_operation` VALUES (341, 60, 'SCENIC_SPOT', 20, 4, 5554, '2025-12-29 19:17:32');
INSERT INTO `user_action_operation` VALUES (342, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 19:17:45');
INSERT INTO `user_action_operation` VALUES (343, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 19:18:24');
INSERT INTO `user_action_operation` VALUES (344, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 19:18:26');
INSERT INTO `user_action_operation` VALUES (345, 60, 'SCENIC_SPOT', 20, 4, 17151, '2025-12-29 19:18:43');
INSERT INTO `user_action_operation` VALUES (346, 60, 'SCENIC_SPOT', 20, 4, 19100, '2025-12-29 19:18:45');
INSERT INTO `user_action_operation` VALUES (347, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 19:18:45');
INSERT INTO `user_action_operation` VALUES (348, 60, 'SCENIC_SPOT', 20, 4, 4386, '2025-12-29 19:18:49');
INSERT INTO `user_action_operation` VALUES (349, 60, 'SCENIC_SPOT', 20, 4, 67248, '2025-12-29 19:19:52');
INSERT INTO `user_action_operation` VALUES (350, 60, 'SCENIC_SPOT', 20, 4, 220233, '2025-12-29 19:22:25');
INSERT INTO `user_action_operation` VALUES (352, 60, 'SCENIC_SPOT', 20, 4, 252612, '2025-12-29 19:22:58');
INSERT INTO `user_action_operation` VALUES (353, 60, 'SCENIC_SPOT', 20, 4, 254506, '2025-12-29 19:22:59');
INSERT INTO `user_action_operation` VALUES (354, 60, 'SCENIC_SPOT', 20, 4, 858576, '2025-12-29 19:33:04');
INSERT INTO `user_action_operation` VALUES (355, 60, 'SCENIC_SPOT', 20, 4, 1370389, '2025-12-29 19:41:35');
INSERT INTO `user_action_operation` VALUES (356, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 19:42:38');
INSERT INTO `user_action_operation` VALUES (357, 60, 'SCENIC_SPOT', 20, 4, 5572, '2025-12-29 19:42:43');
INSERT INTO `user_action_operation` VALUES (358, 60, 'SCENIC_SPOT', 20, 4, 5579, '2025-12-29 19:42:43');
INSERT INTO `user_action_operation` VALUES (359, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 19:42:45');
INSERT INTO `user_action_operation` VALUES (361, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 19:44:14');
INSERT INTO `user_action_operation` VALUES (362, 60, 'SCENIC_SPOT', 20, 4, 140848, '2025-12-29 19:46:35');
INSERT INTO `user_action_operation` VALUES (363, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 19:46:35');
INSERT INTO `user_action_operation` VALUES (364, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 19:49:22');
INSERT INTO `user_action_operation` VALUES (367, 60, 'SCENIC_SPOT', 20, 4, 152165, '2025-12-29 19:51:54');
INSERT INTO `user_action_operation` VALUES (368, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 19:51:54');
INSERT INTO `user_action_operation` VALUES (369, 60, 'SCENIC_SPOT', 18, 3, NULL, '2025-12-29 19:52:15');
INSERT INTO `user_action_operation` VALUES (370, 60, 'SCENIC_SPOT', 18, 4, 83609, '2025-12-29 19:53:38');
INSERT INTO `user_action_operation` VALUES (371, 60, 'SCENIC_SPOT', 18, 3, NULL, '2025-12-29 19:53:38');
INSERT INTO `user_action_operation` VALUES (375, 60, 'SCENIC_SPOT', 18, 3, NULL, '2025-12-29 19:59:53');
INSERT INTO `user_action_operation` VALUES (377, 60, 'SCENIC_SPOT', 18, 4, 160398, '2025-12-29 20:02:34');
INSERT INTO `user_action_operation` VALUES (378, 60, 'SCENIC_SPOT', 18, 3, NULL, '2025-12-29 20:02:34');
INSERT INTO `user_action_operation` VALUES (380, 60, 'SCENIC_SPOT', 18, 1, NULL, '2025-12-29 20:03:23');
INSERT INTO `user_action_operation` VALUES (381, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 20:03:26');
INSERT INTO `user_action_operation` VALUES (382, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 20:04:13');
INSERT INTO `user_action_operation` VALUES (383, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 20:04:40');
INSERT INTO `user_action_operation` VALUES (384, 60, 'SCENIC_SPOT', 20, 4, 264473, '2025-12-29 20:09:05');
INSERT INTO `user_action_operation` VALUES (385, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 20:09:05');
INSERT INTO `user_action_operation` VALUES (386, 60, 'SCENIC_SPOT', 20, 4, 256534, '2025-12-29 20:13:21');
INSERT INTO `user_action_operation` VALUES (387, 60, 'SCENIC_SPOT', 20, 4, 307571, '2025-12-29 20:14:12');
INSERT INTO `user_action_operation` VALUES (388, 60, 'SCENIC_SPOT', 20, 4, 322882, '2025-12-29 20:14:28');
INSERT INTO `user_action_operation` VALUES (389, 60, 'SCENIC_SPOT', 20, 4, 370375, '2025-12-29 20:15:15');
INSERT INTO `user_action_operation` VALUES (390, 60, 'SCENIC_SPOT', 20, 4, 430919, '2025-12-29 20:16:16');
INSERT INTO `user_action_operation` VALUES (391, 60, 'SCENIC_SPOT', 20, 4, 469912, '2025-12-29 20:16:55');
INSERT INTO `user_action_operation` VALUES (392, 60, 'SCENIC_SPOT', 20, 4, 526990, '2025-12-29 20:17:52');
INSERT INTO `user_action_operation` VALUES (393, 60, 'SCENIC_SPOT', 20, 4, 538456, '2025-12-29 20:18:03');
INSERT INTO `user_action_operation` VALUES (394, 60, 'SCENIC_SPOT', 20, 4, 546894, '2025-12-29 20:18:12');
INSERT INTO `user_action_operation` VALUES (395, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 20:18:12');
INSERT INTO `user_action_operation` VALUES (396, 60, 'SCENIC_SPOT', 20, 4, 8611, '2025-12-29 20:18:20');
INSERT INTO `user_action_operation` VALUES (397, 60, 'SCENIC_SPOT', 20, 4, 67553, '2025-12-29 20:19:19');
INSERT INTO `user_action_operation` VALUES (398, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 20:19:19');
INSERT INTO `user_action_operation` VALUES (399, 60, 'SCENIC_SPOT', 20, 4, 2071, '2025-12-29 20:19:21');
INSERT INTO `user_action_operation` VALUES (400, 60, 'SCENIC_SPOT', 20, 4, 51442, '2025-12-29 20:20:11');
INSERT INTO `user_action_operation` VALUES (401, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 20:20:11');
INSERT INTO `user_action_operation` VALUES (402, 60, 'SCENIC_SPOT', 20, 4, 2110, '2025-12-29 20:20:13');
INSERT INTO `user_action_operation` VALUES (403, 60, 'SCENIC_SPOT', 20, 4, 6453, '2025-12-29 20:20:17');
INSERT INTO `user_action_operation` VALUES (404, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 20:20:17');
INSERT INTO `user_action_operation` VALUES (405, 60, 'SCENIC_SPOT', 20, 4, 29536, '2025-12-29 20:20:47');
INSERT INTO `user_action_operation` VALUES (406, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 20:20:47');
INSERT INTO `user_action_operation` VALUES (407, 60, 'SCENIC_SPOT', 20, 4, 4247, '2025-12-29 20:20:51');
INSERT INTO `user_action_operation` VALUES (408, 60, 'SCENIC_SPOT', 20, 4, 10917, '2025-12-29 20:20:58');
INSERT INTO `user_action_operation` VALUES (409, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 20:20:58');
INSERT INTO `user_action_operation` VALUES (410, 60, 'SCENIC_SPOT', 20, 4, 9858, '2025-12-29 20:21:08');
INSERT INTO `user_action_operation` VALUES (411, 60, 'SCENIC_SPOT', 20, 4, 34813, '2025-12-29 20:21:33');
INSERT INTO `user_action_operation` VALUES (412, 60, 'SCENIC_SPOT', 20, 4, 38358, '2025-12-29 20:21:36');
INSERT INTO `user_action_operation` VALUES (413, 60, 'SCENIC_SPOT', 20, 4, 74265, '2025-12-29 20:22:12');
INSERT INTO `user_action_operation` VALUES (414, 60, 'SCENIC_SPOT', 20, 4, 91559, '2025-12-29 20:22:29');
INSERT INTO `user_action_operation` VALUES (415, 60, 'SCENIC_SPOT', 20, 4, 107601, '2025-12-29 20:22:45');
INSERT INTO `user_action_operation` VALUES (416, 60, 'SCENIC_SPOT', 20, 4, 130072, '2025-12-29 20:23:08');
INSERT INTO `user_action_operation` VALUES (417, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 20:23:08');
INSERT INTO `user_action_operation` VALUES (418, 60, 'SCENIC_SPOT', 20, 4, 46864, '2025-12-29 20:23:55');
INSERT INTO `user_action_operation` VALUES (419, 60, 'SCENIC_SPOT', 20, 4, 61551, '2025-12-29 20:24:09');
INSERT INTO `user_action_operation` VALUES (420, 60, 'SCENIC_SPOT', 20, 4, 71306, '2025-12-29 20:24:19');
INSERT INTO `user_action_operation` VALUES (421, 60, 'SCENIC_SPOT', 20, 4, 94318, '2025-12-29 20:24:42');
INSERT INTO `user_action_operation` VALUES (422, 60, 'SCENIC_SPOT', 20, 4, 120727, '2025-12-29 20:25:09');
INSERT INTO `user_action_operation` VALUES (423, 60, 'SCENIC_SPOT', 20, 4, 146119, '2025-12-29 20:25:34');
INSERT INTO `user_action_operation` VALUES (424, 60, 'SCENIC_SPOT', 20, 4, 163631, '2025-12-29 20:25:52');
INSERT INTO `user_action_operation` VALUES (425, 60, 'SCENIC_SPOT', 20, 4, 178538, '2025-12-29 20:26:06');
INSERT INTO `user_action_operation` VALUES (426, 60, 'SCENIC_SPOT', 20, 4, 199908, '2025-12-29 20:26:28');
INSERT INTO `user_action_operation` VALUES (427, 60, 'SCENIC_SPOT', 20, 4, 206666, '2025-12-29 20:26:35');
INSERT INTO `user_action_operation` VALUES (429, 60, 'SCENIC_SPOT', 20, 4, 235372, '2025-12-29 20:27:03');
INSERT INTO `user_action_operation` VALUES (430, 60, 'SCENIC_SPOT', 20, 4, 289848, '2025-12-29 20:27:58');
INSERT INTO `user_action_operation` VALUES (431, 60, 'SCENIC_SPOT', 20, 4, 319348, '2025-12-29 20:28:27');
INSERT INTO `user_action_operation` VALUES (432, 60, 'SCENIC_SPOT', 20, 4, 339910, '2025-12-29 20:28:48');
INSERT INTO `user_action_operation` VALUES (433, 60, 'SCENIC_SPOT', 20, 4, 346916, '2025-12-29 20:28:55');
INSERT INTO `user_action_operation` VALUES (434, 60, 'SCENIC_SPOT', 20, 4, 368651, '2025-12-29 20:29:17');
INSERT INTO `user_action_operation` VALUES (435, 60, 'SCENIC_SPOT', 20, 4, 386944, '2025-12-29 20:29:35');
INSERT INTO `user_action_operation` VALUES (436, 60, 'SCENIC_SPOT', 20, 4, 426008, '2025-12-29 20:30:14');
INSERT INTO `user_action_operation` VALUES (437, 60, 'SCENIC_SPOT', 20, 4, 452146, '2025-12-29 20:30:40');
INSERT INTO `user_action_operation` VALUES (438, 60, 'SCENIC_SPOT', 20, 4, 468170, '2025-12-29 20:30:56');
INSERT INTO `user_action_operation` VALUES (439, 60, 'SCENIC_SPOT', 20, 4, 479853, '2025-12-29 20:31:08');
INSERT INTO `user_action_operation` VALUES (440, 60, 'SCENIC_SPOT', 20, 4, 502887, '2025-12-29 20:31:31');
INSERT INTO `user_action_operation` VALUES (441, 60, 'SCENIC_SPOT', 20, 4, 513636, '2025-12-29 20:31:42');
INSERT INTO `user_action_operation` VALUES (442, 60, 'SCENIC_SPOT', 20, 4, 548211, '2025-12-29 20:32:16');
INSERT INTO `user_action_operation` VALUES (443, 60, 'SCENIC_SPOT', 20, 4, 563153, '2025-12-29 20:32:31');
INSERT INTO `user_action_operation` VALUES (444, 60, 'SCENIC_SPOT', 20, 4, 600319, '2025-12-29 20:33:08');
INSERT INTO `user_action_operation` VALUES (445, 60, 'SCENIC_SPOT', 20, 4, 649232, '2025-12-29 20:33:57');
INSERT INTO `user_action_operation` VALUES (446, 60, 'SCENIC_SPOT', 20, 4, 668069, '2025-12-29 20:34:16');
INSERT INTO `user_action_operation` VALUES (447, 60, 'SCENIC_SPOT', 20, 4, 677031, '2025-12-29 20:34:25');
INSERT INTO `user_action_operation` VALUES (448, 60, 'SCENIC_SPOT', 20, 4, 680367, '2025-12-29 20:34:28');
INSERT INTO `user_action_operation` VALUES (449, 60, 'SCENIC_SPOT', 20, 4, 695746, '2025-12-29 20:34:44');
INSERT INTO `user_action_operation` VALUES (450, 60, 'SCENIC_SPOT', 20, 4, 709395, '2025-12-29 20:34:57');
INSERT INTO `user_action_operation` VALUES (451, 60, 'SCENIC_SPOT', 20, 4, 729372, '2025-12-29 20:35:17');
INSERT INTO `user_action_operation` VALUES (452, 60, 'SCENIC_SPOT', 20, 4, 783365, '2025-12-29 20:36:11');
INSERT INTO `user_action_operation` VALUES (453, 60, 'SCENIC_SPOT', 20, 4, 802405, '2025-12-29 20:36:30');
INSERT INTO `user_action_operation` VALUES (454, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 20:36:30');
INSERT INTO `user_action_operation` VALUES (455, 60, 'SCENIC_SPOT', 20, 4, 21555, '2025-12-29 20:36:52');
INSERT INTO `user_action_operation` VALUES (456, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 20:36:52');
INSERT INTO `user_action_operation` VALUES (457, 60, 'SCENIC_SPOT', 20, 4, 4990, '2025-12-29 20:36:57');
INSERT INTO `user_action_operation` VALUES (458, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 20:36:57');
INSERT INTO `user_action_operation` VALUES (459, 60, 'SCENIC_SPOT', 20, 4, 5419, '2025-12-29 20:37:02');
INSERT INTO `user_action_operation` VALUES (460, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 20:37:02');
INSERT INTO `user_action_operation` VALUES (461, 60, 'SCENIC_SPOT', 20, 4, 31953, '2025-12-29 20:37:34');
INSERT INTO `user_action_operation` VALUES (462, 60, 'SCENIC_SPOT', 20, 4, 69789, '2025-12-29 20:38:12');
INSERT INTO `user_action_operation` VALUES (463, 60, 'SCENIC_SPOT', 20, 4, 82377, '2025-12-29 20:38:25');
INSERT INTO `user_action_operation` VALUES (464, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 20:38:25');
INSERT INTO `user_action_operation` VALUES (465, 60, 'SCENIC_SPOT', 20, 4, 46610, '2025-12-29 20:39:11');
INSERT INTO `user_action_operation` VALUES (466, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 20:39:11');
INSERT INTO `user_action_operation` VALUES (467, 60, 'SCENIC_SPOT', 20, 4, 4063, '2025-12-29 20:39:15');
INSERT INTO `user_action_operation` VALUES (468, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 20:39:15');
INSERT INTO `user_action_operation` VALUES (469, 60, 'SCENIC_SPOT', 20, 4, 1524, '2025-12-29 20:39:17');
INSERT INTO `user_action_operation` VALUES (470, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 20:39:17');
INSERT INTO `user_action_operation` VALUES (471, 60, 'SCENIC_SPOT', 20, 4, 19760, '2025-12-29 20:39:37');
INSERT INTO `user_action_operation` VALUES (472, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 20:39:37');
INSERT INTO `user_action_operation` VALUES (473, 60, 'SCENIC_SPOT', 20, 4, 3859, '2025-12-29 20:39:41');
INSERT INTO `user_action_operation` VALUES (474, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 20:39:41');
INSERT INTO `user_action_operation` VALUES (475, 60, 'SCENIC_SPOT', 20, 4, 64304, '2025-12-29 20:40:45');
INSERT INTO `user_action_operation` VALUES (476, 60, 'SCENIC_SPOT', 20, 4, 77880, '2025-12-29 20:40:58');
INSERT INTO `user_action_operation` VALUES (477, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 20:40:58');
INSERT INTO `user_action_operation` VALUES (478, 60, 'SCENIC_SPOT', 20, 4, 7628, '2025-12-29 20:41:06');
INSERT INTO `user_action_operation` VALUES (479, 60, 'SCENIC_SPOT', 20, 4, 41164, '2025-12-29 20:41:40');
INSERT INTO `user_action_operation` VALUES (480, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 20:41:40');
INSERT INTO `user_action_operation` VALUES (481, 60, 'SCENIC_SPOT', 20, 4, 3525, '2025-12-29 20:41:43');
INSERT INTO `user_action_operation` VALUES (482, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 20:41:43');
INSERT INTO `user_action_operation` VALUES (483, 60, 'SCENIC_SPOT', 20, 4, 2616, '2025-12-29 20:41:46');
INSERT INTO `user_action_operation` VALUES (484, 60, 'SCENIC_SPOT', 20, 4, 27769, '2025-12-29 20:42:11');
INSERT INTO `user_action_operation` VALUES (485, 60, 'SCENIC_SPOT', 20, 4, 58207, '2025-12-29 20:42:41');
INSERT INTO `user_action_operation` VALUES (486, 60, 'SCENIC_SPOT', 20, 4, 66147, '2025-12-29 20:42:49');
INSERT INTO `user_action_operation` VALUES (487, 60, 'SCENIC_SPOT', 20, 4, 73212, '2025-12-29 20:42:56');
INSERT INTO `user_action_operation` VALUES (488, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 20:42:56');
INSERT INTO `user_action_operation` VALUES (489, 60, 'SCENIC_SPOT', 20, 4, 5322, '2025-12-29 20:43:02');
INSERT INTO `user_action_operation` VALUES (490, 60, 'SCENIC_SPOT', 20, 4, 17252, '2025-12-29 20:43:14');
INSERT INTO `user_action_operation` VALUES (491, 60, 'SCENIC_SPOT', 20, 4, 50560, '2025-12-29 20:43:47');
INSERT INTO `user_action_operation` VALUES (492, 60, 'SCENIC_SPOT', 20, 4, 61550, '2025-12-29 20:43:58');
INSERT INTO `user_action_operation` VALUES (493, 60, 'SCENIC_SPOT', 20, 4, 93766, '2025-12-29 20:44:30');
INSERT INTO `user_action_operation` VALUES (494, 60, 'SCENIC_SPOT', 20, 4, 131321, '2025-12-29 20:45:08');
INSERT INTO `user_action_operation` VALUES (495, 60, 'SCENIC_SPOT', 20, 4, 172350, '2025-12-29 20:45:49');
INSERT INTO `user_action_operation` VALUES (496, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 20:45:49');
INSERT INTO `user_action_operation` VALUES (497, 60, 'SCENIC_SPOT', 20, 4, 37369, '2025-12-29 20:46:26');
INSERT INTO `user_action_operation` VALUES (498, 60, 'SCENIC_SPOT', 20, 4, 55982, '2025-12-29 20:46:45');
INSERT INTO `user_action_operation` VALUES (499, 60, 'SCENIC_SPOT', 20, 4, 64544, '2025-12-29 20:46:53');
INSERT INTO `user_action_operation` VALUES (500, 60, 'SCENIC_SPOT', 20, 4, 77935, '2025-12-29 20:47:07');
INSERT INTO `user_action_operation` VALUES (501, 60, 'SCENIC_SPOT', 20, 4, 110564, '2025-12-29 20:47:39');
INSERT INTO `user_action_operation` VALUES (502, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 20:47:40');
INSERT INTO `user_action_operation` VALUES (503, 60, 'SCENIC_SPOT', 20, 4, 5690, '2025-12-29 20:47:45');
INSERT INTO `user_action_operation` VALUES (504, 60, 'SCENIC_SPOT', 20, 4, 24529, '2025-12-29 20:48:04');
INSERT INTO `user_action_operation` VALUES (505, 60, 'SCENIC_SPOT', 20, 4, 42137, '2025-12-29 20:48:22');
INSERT INTO `user_action_operation` VALUES (506, 60, 'SCENIC_SPOT', 20, 4, 78457, '2025-12-29 20:48:58');
INSERT INTO `user_action_operation` VALUES (507, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 20:48:58');
INSERT INTO `user_action_operation` VALUES (508, 60, 'SCENIC_SPOT', 20, 4, 6000, '2025-12-29 20:49:04');
INSERT INTO `user_action_operation` VALUES (509, 60, 'SCENIC_SPOT', 20, 4, 18624, '2025-12-29 20:49:17');
INSERT INTO `user_action_operation` VALUES (510, 60, 'SCENIC_SPOT', 20, 4, 36735, '2025-12-29 20:49:35');
INSERT INTO `user_action_operation` VALUES (511, 60, 'SCENIC_SPOT', 20, 4, 44237, '2025-12-29 20:49:42');
INSERT INTO `user_action_operation` VALUES (512, 60, 'SCENIC_SPOT', 20, 4, 51017, '2025-12-29 20:49:49');
INSERT INTO `user_action_operation` VALUES (513, 60, 'SCENIC_SPOT', 20, 4, 56042, '2025-12-29 20:49:54');
INSERT INTO `user_action_operation` VALUES (514, 60, 'SCENIC_SPOT', 20, 4, 76815, '2025-12-29 20:50:15');
INSERT INTO `user_action_operation` VALUES (515, 60, 'SCENIC_SPOT', 20, 4, 82619, '2025-12-29 20:50:21');
INSERT INTO `user_action_operation` VALUES (516, 60, 'SCENIC_SPOT', 20, 4, 97207, '2025-12-29 20:50:35');
INSERT INTO `user_action_operation` VALUES (517, 60, 'SCENIC_SPOT', 20, 4, 103831, '2025-12-29 20:50:42');
INSERT INTO `user_action_operation` VALUES (518, 60, 'SCENIC_SPOT', 20, 4, 115644, '2025-12-29 20:50:54');
INSERT INTO `user_action_operation` VALUES (519, 60, 'SCENIC_SPOT', 20, 4, 139730, '2025-12-29 20:51:18');
INSERT INTO `user_action_operation` VALUES (520, 60, 'SCENIC_SPOT', 20, 4, 172696, '2025-12-29 20:51:51');
INSERT INTO `user_action_operation` VALUES (521, 60, 'SCENIC_SPOT', 20, 4, 190343, '2025-12-29 20:52:08');
INSERT INTO `user_action_operation` VALUES (522, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 20:52:08');
INSERT INTO `user_action_operation` VALUES (523, 60, 'SCENIC_SPOT', 20, 4, 11470, '2025-12-29 20:52:20');
INSERT INTO `user_action_operation` VALUES (524, 60, 'SCENIC_SPOT', 20, 3, NULL, '2025-12-29 20:52:20');
INSERT INTO `user_action_operation` VALUES (525, 60, 'SCENIC_SPOT', 20, 4, 982491, '2025-12-29 21:08:42');
INSERT INTO `user_action_operation` VALUES (526, 60, 'SCENIC_SPOT', 20, 4, 1069193, '2025-12-29 21:10:09');
INSERT INTO `user_action_operation` VALUES (527, 60, 'SCENIC_SPOT', 20, 4, 1075815, '2025-12-29 21:10:16');
INSERT INTO `user_action_operation` VALUES (528, 60, 'SCENIC_SPOT', 20, 4, 1084391, '2025-12-29 21:10:24');
INSERT INTO `user_action_operation` VALUES (529, 60, 'SCENIC_SPOT', 20, 4, 1117414, '2025-12-29 21:10:57');
INSERT INTO `user_action_operation` VALUES (530, 60, 'SCENIC_SPOT', 20, 4, 1145846, '2025-12-29 21:11:26');
INSERT INTO `user_action_operation` VALUES (531, 60, 'SCENIC_SPOT', 20, 4, 11275728, '2025-12-30 00:00:16');
INSERT INTO `user_action_operation` VALUES (532, 60, 'SCENIC_SPOT', 20, 4, 60978536, '2025-12-30 13:48:38');
INSERT INTO `user_action_operation` VALUES (533, 60, 'SCENIC_SPOT', 20, 4, 61018404, '2025-12-30 13:49:18');
INSERT INTO `user_action_operation` VALUES (534, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-05 14:06:42');
INSERT INTO `user_action_operation` VALUES (535, 60, 'SCENIC_SPOT', 20, 4, 33672, '2026-01-05 14:07:15');
INSERT INTO `user_action_operation` VALUES (536, 60, 'SCENIC_SPOT', 20, 4, 285854, '2026-01-05 14:11:28');
INSERT INTO `user_action_operation` VALUES (537, 60, 'SCENIC_SPOT', 20, 4, 544519, '2026-01-05 14:15:46');
INSERT INTO `user_action_operation` VALUES (538, 60, 'SCENIC_SPOT', 20, 4, 550321, '2026-01-05 14:15:52');
INSERT INTO `user_action_operation` VALUES (539, 60, 'SCENIC_SPOT', 20, 4, 3979002, '2026-01-05 15:13:01');
INSERT INTO `user_action_operation` VALUES (540, 60, 'SCENIC_SPOT', 20, 4, 6144013, '2026-01-05 15:49:06');
INSERT INTO `user_action_operation` VALUES (541, 60, 'SCENIC_SPOT', 20, 4, 11637898, '2026-01-05 17:20:40');
INSERT INTO `user_action_operation` VALUES (542, 60, 'SCENIC_SPOT', 20, 4, 11642556, '2026-01-05 17:20:44');
INSERT INTO `user_action_operation` VALUES (543, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-06 15:18:01');
INSERT INTO `user_action_operation` VALUES (544, 60, 'SCENIC_SPOT', 20, 4, 11334, '2026-01-06 15:18:12');
INSERT INTO `user_action_operation` VALUES (545, 60, 'SCENIC_SPOT', 20, 4, 83688, '2026-01-06 15:19:24');
INSERT INTO `user_action_operation` VALUES (546, 60, 'SCENIC_SPOT', 20, 4, 173122, '2026-01-06 15:20:54');
INSERT INTO `user_action_operation` VALUES (547, 60, 'SCENIC_SPOT', 20, 4, 199838, '2026-01-06 15:21:20');
INSERT INTO `user_action_operation` VALUES (548, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-06 15:21:20');
INSERT INTO `user_action_operation` VALUES (549, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-06 15:22:17');
INSERT INTO `user_action_operation` VALUES (550, 60, 'SCENIC_SPOT', 20, 4, 21135, '2026-01-06 15:22:38');
INSERT INTO `user_action_operation` VALUES (551, 60, 'SCENIC_SPOT', 20, 4, 71179, '2026-01-06 15:23:28');
INSERT INTO `user_action_operation` VALUES (552, 60, 'SCENIC_SPOT', 20, 4, 122773, '2026-01-06 15:24:19');
INSERT INTO `user_action_operation` VALUES (553, 60, 'SCENIC_SPOT', 20, 4, 185473, '2026-01-06 15:25:22');
INSERT INTO `user_action_operation` VALUES (554, 60, 'SCENIC_SPOT', 20, 4, 214363, '2026-01-06 15:25:51');
INSERT INTO `user_action_operation` VALUES (555, 60, 'SCENIC_SPOT', 20, 4, 248095, '2026-01-06 15:26:25');
INSERT INTO `user_action_operation` VALUES (556, 60, 'SCENIC_SPOT', 20, 4, 257497, '2026-01-06 15:26:34');
INSERT INTO `user_action_operation` VALUES (557, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-06 15:26:34');
INSERT INTO `user_action_operation` VALUES (558, 60, 'SCENIC_SPOT', 20, 4, 19659, '2026-01-06 15:26:54');
INSERT INTO `user_action_operation` VALUES (559, 60, 'SCENIC_SPOT', 20, 4, 59481, '2026-01-06 15:27:34');
INSERT INTO `user_action_operation` VALUES (560, 60, 'SCENIC_SPOT', 20, 4, 64922, '2026-01-06 15:27:39');
INSERT INTO `user_action_operation` VALUES (561, 60, 'SCENIC_SPOT', 20, 4, 78140, '2026-01-06 15:27:52');
INSERT INTO `user_action_operation` VALUES (562, 60, 'SCENIC_SPOT', 20, 4, 220670, '2026-01-06 15:30:15');
INSERT INTO `user_action_operation` VALUES (564, 60, 'SCENIC_SPOT', 20, 4, 1198182, '2026-01-06 15:46:32');
INSERT INTO `user_action_operation` VALUES (565, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-06 15:46:33');
INSERT INTO `user_action_operation` VALUES (566, 60, 'SCENIC_SPOT', 20, 4, 14634, '2026-01-06 15:46:47');
INSERT INTO `user_action_operation` VALUES (567, 60, 'SCENIC_SPOT', 20, 4, 73944, '2026-01-06 15:47:47');
INSERT INTO `user_action_operation` VALUES (568, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-06 15:47:47');
INSERT INTO `user_action_operation` VALUES (569, 60, 'SCENIC_SPOT', 20, 4, 7522, '2026-01-06 15:47:54');
INSERT INTO `user_action_operation` VALUES (570, 60, 'SCENIC_SPOT', 20, 4, 1255209, '2026-01-06 16:08:42');
INSERT INTO `user_action_operation` VALUES (571, 60, 'SCENIC_SPOT', 20, 4, 1286856, '2026-01-06 16:09:13');
INSERT INTO `user_action_operation` VALUES (572, 60, 'SCENIC_SPOT', 20, 4, 1794851, '2026-01-06 16:17:41');
INSERT INTO `user_action_operation` VALUES (573, 60, 'SCENIC_SPOT', 20, 4, 1826604, '2026-01-06 16:18:13');
INSERT INTO `user_action_operation` VALUES (574, 60, 'SCENIC_SPOT', 20, 4, 2019896, '2026-01-06 16:21:26');
INSERT INTO `user_action_operation` VALUES (575, 60, 'SCENIC_SPOT', 20, 4, 2072857, '2026-01-06 16:22:19');
INSERT INTO `user_action_operation` VALUES (576, 60, 'SCENIC_SPOT', 20, 4, 2141998, '2026-01-06 16:23:29');
INSERT INTO `user_action_operation` VALUES (577, 60, 'SCENIC_SPOT', 20, 4, 2209325, '2026-01-06 16:24:36');
INSERT INTO `user_action_operation` VALUES (578, 60, 'SCENIC_SPOT', 20, 4, 2234000, '2026-01-06 16:25:01');
INSERT INTO `user_action_operation` VALUES (579, 60, 'SCENIC_SPOT', 20, 4, 2273551, '2026-01-06 16:25:40');
INSERT INTO `user_action_operation` VALUES (580, 60, 'SCENIC_SPOT', 20, 4, 2352588, '2026-01-06 16:26:59');
INSERT INTO `user_action_operation` VALUES (581, 60, 'SCENIC_SPOT', 20, 4, 2384579, '2026-01-06 16:27:31');
INSERT INTO `user_action_operation` VALUES (582, 60, 'SCENIC_SPOT', 20, 4, 2412138, '2026-01-06 16:27:59');
INSERT INTO `user_action_operation` VALUES (583, 60, 'SCENIC_SPOT', 20, 4, 2428028, '2026-01-06 16:28:15');
INSERT INTO `user_action_operation` VALUES (584, 60, 'SCENIC_SPOT', 20, 4, 2440286, '2026-01-06 16:28:27');
INSERT INTO `user_action_operation` VALUES (585, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-06 16:28:28');
INSERT INTO `user_action_operation` VALUES (586, 60, 'SCENIC_SPOT', 20, 4, 9295, '2026-01-06 16:28:37');
INSERT INTO `user_action_operation` VALUES (587, 60, 'SCENIC_SPOT', 20, 4, 26734, '2026-01-06 16:28:55');
INSERT INTO `user_action_operation` VALUES (588, 60, 'SCENIC_SPOT', 20, 4, 42885, '2026-01-06 16:29:11');
INSERT INTO `user_action_operation` VALUES (589, 60, 'SCENIC_SPOT', 20, 4, 56716, '2026-01-06 16:29:25');
INSERT INTO `user_action_operation` VALUES (590, 60, 'SCENIC_SPOT', 20, 4, 81552, '2026-01-06 16:29:50');
INSERT INTO `user_action_operation` VALUES (591, 60, 'SCENIC_SPOT', 20, 4, 95459, '2026-01-06 16:30:04');
INSERT INTO `user_action_operation` VALUES (592, 60, 'SCENIC_SPOT', 20, 4, 104551, '2026-01-06 16:30:13');
INSERT INTO `user_action_operation` VALUES (593, 60, 'SCENIC_SPOT', 20, 4, 118619, '2026-01-06 16:30:27');
INSERT INTO `user_action_operation` VALUES (594, 60, 'SCENIC_SPOT', 20, 4, 145364, '2026-01-06 16:30:54');
INSERT INTO `user_action_operation` VALUES (595, 60, 'SCENIC_SPOT', 20, 4, 171573, '2026-01-06 16:31:20');
INSERT INTO `user_action_operation` VALUES (596, 60, 'SCENIC_SPOT', 20, 4, 308216, '2026-01-06 16:33:36');
INSERT INTO `user_action_operation` VALUES (597, 60, 'SCENIC_SPOT', 20, 4, 342799, '2026-01-06 16:34:11');
INSERT INTO `user_action_operation` VALUES (598, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-06 16:34:11');
INSERT INTO `user_action_operation` VALUES (599, 60, 'SCENIC_SPOT', 20, 4, 9861, '2026-01-06 16:34:21');
INSERT INTO `user_action_operation` VALUES (600, 60, 'SCENIC_SPOT', 20, 4, 57584, '2026-01-06 16:35:09');
INSERT INTO `user_action_operation` VALUES (601, 60, 'SCENIC_SPOT', 20, 4, 72847, '2026-01-06 16:35:24');
INSERT INTO `user_action_operation` VALUES (602, 60, 'SCENIC_SPOT', 20, 4, 78818, '2026-01-06 16:35:30');
INSERT INTO `user_action_operation` VALUES (603, 60, 'SCENIC_SPOT', 20, 4, 93947, '2026-01-06 16:35:45');
INSERT INTO `user_action_operation` VALUES (604, 60, 'SCENIC_SPOT', 20, 4, 131793, '2026-01-06 16:36:23');
INSERT INTO `user_action_operation` VALUES (605, 60, 'SCENIC_SPOT', 20, 4, 142187, '2026-01-06 16:36:33');
INSERT INTO `user_action_operation` VALUES (606, 60, 'SCENIC_SPOT', 20, 4, 164958, '2026-01-06 16:36:56');
INSERT INTO `user_action_operation` VALUES (607, 60, 'SCENIC_SPOT', 20, 4, 254058, '2026-01-06 16:38:25');
INSERT INTO `user_action_operation` VALUES (608, 60, 'SCENIC_SPOT', 20, 4, 275871, '2026-01-06 16:38:47');
INSERT INTO `user_action_operation` VALUES (609, 60, 'SCENIC_SPOT', 20, 4, 571747, '2026-01-06 16:43:43');
INSERT INTO `user_action_operation` VALUES (610, 60, 'SCENIC_SPOT', 20, 4, 613355, '2026-01-06 16:44:24');
INSERT INTO `user_action_operation` VALUES (611, 60, 'SCENIC_SPOT', 20, 4, 762012, '2026-01-06 16:46:53');
INSERT INTO `user_action_operation` VALUES (612, 60, 'SCENIC_SPOT', 20, 4, 812426, '2026-01-06 16:47:43');
INSERT INTO `user_action_operation` VALUES (613, 60, 'SCENIC_SPOT', 20, 4, 845273, '2026-01-06 16:48:16');
INSERT INTO `user_action_operation` VALUES (614, 60, 'SCENIC_SPOT', 20, 4, 861966, '2026-01-06 16:48:33');
INSERT INTO `user_action_operation` VALUES (615, 60, 'SCENIC_SPOT', 20, 4, 980689, '2026-01-06 16:50:32');
INSERT INTO `user_action_operation` VALUES (616, 60, 'SCENIC_SPOT', 20, 4, 1000380, '2026-01-06 16:50:51');
INSERT INTO `user_action_operation` VALUES (617, 60, 'SCENIC_SPOT', 20, 4, 1020245, '2026-01-06 16:51:11');
INSERT INTO `user_action_operation` VALUES (618, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-09 14:38:39');
INSERT INTO `user_action_operation` VALUES (619, 60, 'SCENIC_SPOT', 20, 4, 6091, '2026-01-09 14:38:44');
INSERT INTO `user_action_operation` VALUES (620, 60, 'SCENIC_SPOT', 20, 4, 142390, '2026-01-09 14:41:01');
INSERT INTO `user_action_operation` VALUES (621, 60, 'SCENIC_SPOT', 20, 4, 190992, '2026-01-09 14:41:49');
INSERT INTO `user_action_operation` VALUES (622, 60, 'SCENIC_SPOT', 20, 4, 212477, '2026-01-09 14:42:11');
INSERT INTO `user_action_operation` VALUES (623, 60, 'SCENIC_SPOT', 20, 4, 212495, '2026-01-09 14:42:11');
INSERT INTO `user_action_operation` VALUES (624, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-09 14:42:28');
INSERT INTO `user_action_operation` VALUES (625, 60, 'SCENIC_SPOT', 20, 4, 16992, '2026-01-09 14:42:45');
INSERT INTO `user_action_operation` VALUES (626, 60, 'SCENIC_SPOT', 20, 4, 17428, '2026-01-09 14:42:45');
INSERT INTO `user_action_operation` VALUES (627, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-10 16:27:32');
INSERT INTO `user_action_operation` VALUES (628, 60, 'SCENIC_SPOT', 20, 4, 15169, '2026-01-10 16:27:47');
INSERT INTO `user_action_operation` VALUES (629, 60, 'SCENIC_SPOT', 20, 4, 15226, '2026-01-10 16:27:47');
INSERT INTO `user_action_operation` VALUES (630, 60, 'SCENIC_SPOT', 19, 3, NULL, '2026-01-10 16:29:59');
INSERT INTO `user_action_operation` VALUES (631, 60, 'SCENIC_SPOT', 19, 4, 4089, '2026-01-10 16:30:03');
INSERT INTO `user_action_operation` VALUES (632, 60, 'SCENIC_SPOT', 18, 3, NULL, '2026-01-10 16:30:04');
INSERT INTO `user_action_operation` VALUES (633, 60, 'SCENIC_SPOT', 18, 4, 2880, '2026-01-10 16:30:07');
INSERT INTO `user_action_operation` VALUES (634, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-10 16:30:08');
INSERT INTO `user_action_operation` VALUES (635, 60, 'SCENIC_SPOT', 20, 4, 14131, '2026-01-10 16:30:22');
INSERT INTO `user_action_operation` VALUES (636, 60, 'SCENIC_SPOT', 20, 4, 14500, '2026-01-10 16:30:23');
INSERT INTO `user_action_operation` VALUES (637, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-10 18:17:43');
INSERT INTO `user_action_operation` VALUES (638, 60, 'SCENIC_SPOT', 20, 4, 8162, '2026-01-10 18:17:51');
INSERT INTO `user_action_operation` VALUES (639, 60, 'SCENIC_SPOT', 20, 4, 8282, '2026-01-10 18:17:51');
INSERT INTO `user_action_operation` VALUES (640, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-10 18:26:48');
INSERT INTO `user_action_operation` VALUES (641, 60, 'SCENIC_SPOT', 20, 4, 9643, '2026-01-10 18:26:57');
INSERT INTO `user_action_operation` VALUES (642, 60, 'SCENIC_SPOT', 20, 4, 9697, '2026-01-10 18:26:57');
INSERT INTO `user_action_operation` VALUES (643, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-10 20:44:15');
INSERT INTO `user_action_operation` VALUES (644, 60, 'SCENIC_SPOT', 20, 4, 12379, '2026-01-10 20:44:27');
INSERT INTO `user_action_operation` VALUES (645, 60, 'SCENIC_SPOT', 20, 4, 12757, '2026-01-10 20:44:28');
INSERT INTO `user_action_operation` VALUES (646, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-10 20:46:30');
INSERT INTO `user_action_operation` VALUES (647, 60, 'SCENIC_SPOT', 20, 4, 12554, '2026-01-10 20:46:42');
INSERT INTO `user_action_operation` VALUES (648, 60, 'SCENIC_SPOT', 20, 4, 106542, '2026-01-10 20:49:10');
INSERT INTO `user_action_operation` VALUES (649, 60, 'SCENIC_SPOT', 20, 4, 173209, '2026-01-10 20:49:23');
INSERT INTO `user_action_operation` VALUES (650, 60, 'SCENIC_SPOT', 20, 4, 173687, '2026-01-10 20:49:23');
INSERT INTO `user_action_operation` VALUES (651, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-10 20:49:27');
INSERT INTO `user_action_operation` VALUES (652, 60, 'SCENIC_SPOT', 20, 4, 12178, '2026-01-10 20:49:39');
INSERT INTO `user_action_operation` VALUES (653, 60, 'SCENIC_SPOT', 20, 4, 12543, '2026-01-10 20:49:39');
INSERT INTO `user_action_operation` VALUES (654, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-10 20:49:44');
INSERT INTO `user_action_operation` VALUES (655, 60, 'SCENIC_SPOT', 20, 4, 8044, '2026-01-10 20:49:52');
INSERT INTO `user_action_operation` VALUES (656, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-11 15:00:49');
INSERT INTO `user_action_operation` VALUES (657, 60, 'SCENIC_SPOT', 20, 4, 19881, '2026-01-11 15:01:08');
INSERT INTO `user_action_operation` VALUES (658, 60, 'SCENIC_SPOT', 20, 4, 20059, '2026-01-11 15:01:09');
INSERT INTO `user_action_operation` VALUES (659, 60, 'SCENIC_SPOT', 18, 3, NULL, '2026-01-11 15:22:58');
INSERT INTO `user_action_operation` VALUES (660, 60, 'SCENIC_SPOT', 18, 4, 2392, '2026-01-11 15:23:00');
INSERT INTO `user_action_operation` VALUES (661, 59, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-11 15:28:31');
INSERT INTO `user_action_operation` VALUES (662, 59, 'SCENIC_SPOT', 20, 4, 19385, '2026-01-11 15:28:50');
INSERT INTO `user_action_operation` VALUES (663, 59, 'SCENIC_SPOT', 20, 4, 19443, '2026-01-11 15:28:50');
INSERT INTO `user_action_operation` VALUES (664, 59, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-11 17:08:17');
INSERT INTO `user_action_operation` VALUES (665, 59, 'SCENIC_SPOT', 20, 4, 21937, '2026-01-11 17:08:38');
INSERT INTO `user_action_operation` VALUES (666, 59, 'SCENIC_SPOT', 20, 4, 22001, '2026-01-11 17:08:39');
INSERT INTO `user_action_operation` VALUES (667, 59, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-11 17:48:02');
INSERT INTO `user_action_operation` VALUES (668, 59, 'SCENIC_SPOT', 20, 4, 9328, '2026-01-11 17:48:11');
INSERT INTO `user_action_operation` VALUES (669, 59, 'SCENIC_SPOT', 20, 4, 9524, '2026-01-11 17:48:11');
INSERT INTO `user_action_operation` VALUES (670, 59, 'SCENIC_SPOT', 19, 3, NULL, '2026-01-11 17:53:59');
INSERT INTO `user_action_operation` VALUES (671, 59, 'SCENIC_SPOT', 19, 1, NULL, '2026-01-11 17:54:00');
INSERT INTO `user_action_operation` VALUES (672, 59, 'SCENIC_SPOT', 19, 4, 2228, '2026-01-11 17:54:01');
INSERT INTO `user_action_operation` VALUES (673, 59, 'SCENIC_SPOT', 19, 4, 3648, '2026-01-11 17:54:03');
INSERT INTO `user_action_operation` VALUES (674, 59, 'SCENIC_SPOT', 18, 3, NULL, '2026-01-13 17:06:31');
INSERT INTO `user_action_operation` VALUES (675, 59, 'SCENIC_SPOT', 18, 4, 1651, '2026-01-13 17:06:32');
INSERT INTO `user_action_operation` VALUES (676, 59, 'SCENIC_SPOT', 18, 3, NULL, '2026-01-13 17:15:09');
INSERT INTO `user_action_operation` VALUES (677, 59, 'SCENIC_SPOT', 18, 4, 537, '2026-01-13 17:15:09');
INSERT INTO `user_action_operation` VALUES (678, 59, 'SCENIC_SPOT', 18, 3, NULL, '2026-01-13 17:23:08');
INSERT INTO `user_action_operation` VALUES (679, 59, 'SCENIC_SPOT', 18, 4, 563, '2026-01-13 17:23:09');
INSERT INTO `user_action_operation` VALUES (680, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-13 21:12:57');
INSERT INTO `user_action_operation` VALUES (681, 60, 'SCENIC_SPOT', 16, 1, NULL, '2026-01-13 21:12:58');
INSERT INTO `user_action_operation` VALUES (682, 60, 'SCENIC_SPOT', 16, 2, NULL, '2026-01-13 21:12:58');
INSERT INTO `user_action_operation` VALUES (683, 60, 'SCENIC_SPOT', 16, 4, 3009, '2026-01-13 21:12:59');
INSERT INTO `user_action_operation` VALUES (684, 60, 'SCENIC_SPOT', 9, 3, NULL, '2026-01-13 21:13:02');
INSERT INTO `user_action_operation` VALUES (685, 60, 'SCENIC_SPOT', 9, 2, NULL, '2026-01-13 21:13:04');
INSERT INTO `user_action_operation` VALUES (686, 60, 'SCENIC_SPOT', 9, 4, 2193, '2026-01-13 21:13:05');
INSERT INTO `user_action_operation` VALUES (687, 60, 'SCENIC_SPOT', 19, 3, NULL, '2026-01-13 21:13:07');
INSERT INTO `user_action_operation` VALUES (689, 60, 'SCENIC_SPOT', 19, 4, 2006, '2026-01-13 21:13:09');
INSERT INTO `user_action_operation` VALUES (690, 60, 'SCENIC_SPOT', 19, 4, 4117, '2026-01-13 21:13:11');
INSERT INTO `user_action_operation` VALUES (691, 60, 'SCENIC_SPOT_STRATEGY', 3, 3, NULL, '2026-01-15 15:49:16');
INSERT INTO `user_action_operation` VALUES (692, 60, 'SCENIC_SPOT_STRATEGY', 3, 4, 3810, '2026-01-15 15:49:20');
INSERT INTO `user_action_operation` VALUES (693, 60, 'SCENIC_SPOT_STRATEGY', 4, 3, NULL, '2026-01-15 15:49:40');
INSERT INTO `user_action_operation` VALUES (694, 60, 'SCENIC_SPOT_STRATEGY', 4, 4, 1604, '2026-01-15 15:49:42');
INSERT INTO `user_action_operation` VALUES (695, 60, 'SCENIC_SPOT_STRATEGY', 13, 3, NULL, '2026-01-15 15:49:44');
INSERT INTO `user_action_operation` VALUES (697, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 3474, '2026-01-15 15:49:47');
INSERT INTO `user_action_operation` VALUES (698, 60, 'SCENIC_SPOT_STRATEGY', 4, 3, NULL, '2026-01-15 16:34:13');
INSERT INTO `user_action_operation` VALUES (699, 60, 'SCENIC_SPOT_STRATEGY', 4, 4, 905, '2026-01-15 16:34:14');
INSERT INTO `user_action_operation` VALUES (700, 60, 'SCENIC_SPOT_STRATEGY', 4, 3, NULL, '2026-01-15 16:34:16');
INSERT INTO `user_action_operation` VALUES (703, 60, 'SCENIC_SPOT_STRATEGY', 4, 4, 1654, '2026-01-15 16:34:18');
INSERT INTO `user_action_operation` VALUES (704, 60, 'SCENIC_SPOT_STRATEGY', 13, 3, NULL, '2026-01-15 16:34:20');
INSERT INTO `user_action_operation` VALUES (705, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 1259, '2026-01-15 16:34:21');
INSERT INTO `user_action_operation` VALUES (706, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 9036, '2026-01-15 16:34:29');
INSERT INTO `user_action_operation` VALUES (707, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 26053, '2026-01-15 16:34:46');
INSERT INTO `user_action_operation` VALUES (708, 60, 'SCENIC_SPOT_STRATEGY', 13, 3, NULL, '2026-01-15 16:34:46');
INSERT INTO `user_action_operation` VALUES (710, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 1582, '2026-01-15 16:34:47');
INSERT INTO `user_action_operation` VALUES (711, 60, 'SCENIC_SPOT_STRATEGY', 4, 4, 51681, '2026-01-15 16:35:05');
INSERT INTO `user_action_operation` VALUES (712, 59, 'SCENIC_SPOT_STRATEGY', 3, 3, NULL, '2026-01-15 16:46:11');
INSERT INTO `user_action_operation` VALUES (713, 59, 'SCENIC_SPOT_STRATEGY', 3, 1, NULL, '2026-01-15 16:46:12');
INSERT INTO `user_action_operation` VALUES (714, 59, 'SCENIC_SPOT_STRATEGY', 3, 2, NULL, '2026-01-15 16:46:13');
INSERT INTO `user_action_operation` VALUES (715, 59, 'SCENIC_SPOT_STRATEGY', 3, 4, 2100, '2026-01-15 16:46:13');
INSERT INTO `user_action_operation` VALUES (716, 59, 'SCENIC_SPOT_STRATEGY', 8, 3, NULL, '2026-01-15 16:46:15');
INSERT INTO `user_action_operation` VALUES (717, 59, 'SCENIC_SPOT_STRATEGY', 8, 1, NULL, '2026-01-15 16:46:16');
INSERT INTO `user_action_operation` VALUES (718, 59, 'SCENIC_SPOT_STRATEGY', 8, 2, NULL, '2026-01-15 16:46:17');
INSERT INTO `user_action_operation` VALUES (719, 59, 'SCENIC_SPOT_STRATEGY', 8, 4, 2912, '2026-01-15 16:46:18');
INSERT INTO `user_action_operation` VALUES (720, 59, 'SCENIC_SPOT_STRATEGY', 5, 3, NULL, '2026-01-15 16:46:20');
INSERT INTO `user_action_operation` VALUES (721, 59, 'SCENIC_SPOT_STRATEGY', 5, 1, NULL, '2026-01-15 16:46:21');
INSERT INTO `user_action_operation` VALUES (722, 59, 'SCENIC_SPOT_STRATEGY', 5, 2, NULL, '2026-01-15 16:46:21');
INSERT INTO `user_action_operation` VALUES (723, 59, 'SCENIC_SPOT_STRATEGY', 5, 4, 1941, '2026-01-15 16:46:22');
INSERT INTO `user_action_operation` VALUES (724, 59, 'SCENIC_SPOT_STRATEGY', 7, 3, NULL, '2026-01-15 16:46:24');
INSERT INTO `user_action_operation` VALUES (725, 59, 'SCENIC_SPOT_STRATEGY', 7, 1, NULL, '2026-01-15 16:46:26');
INSERT INTO `user_action_operation` VALUES (726, 59, 'SCENIC_SPOT_STRATEGY', 7, 2, NULL, '2026-01-15 16:46:28');
INSERT INTO `user_action_operation` VALUES (727, 59, 'SCENIC_SPOT_STRATEGY', 7, 4, 3996, '2026-01-15 16:46:28');
INSERT INTO `user_action_operation` VALUES (728, 59, 'SCENIC_SPOT_STRATEGY', 1, 3, NULL, '2026-01-15 16:46:31');
INSERT INTO `user_action_operation` VALUES (729, 59, 'SCENIC_SPOT_STRATEGY', 1, 1, NULL, '2026-01-15 16:46:32');
INSERT INTO `user_action_operation` VALUES (730, 59, 'SCENIC_SPOT_STRATEGY', 1, 2, NULL, '2026-01-15 16:46:32');
INSERT INTO `user_action_operation` VALUES (731, 59, 'SCENIC_SPOT_STRATEGY', 1, 4, 1812, '2026-01-15 16:46:33');
INSERT INTO `user_action_operation` VALUES (732, 61, 'SCENIC_SPOT_STRATEGY', 4, 3, NULL, '2026-01-15 16:46:51');
INSERT INTO `user_action_operation` VALUES (733, 61, 'SCENIC_SPOT_STRATEGY', 4, 2, NULL, '2026-01-15 16:46:52');
INSERT INTO `user_action_operation` VALUES (734, 61, 'SCENIC_SPOT_STRATEGY', 4, 1, NULL, '2026-01-15 16:46:52');
INSERT INTO `user_action_operation` VALUES (735, 61, 'SCENIC_SPOT_STRATEGY', 4, 4, 2038, '2026-01-15 16:46:53');
INSERT INTO `user_action_operation` VALUES (736, 61, 'SCENIC_SPOT_STRATEGY', 5, 3, NULL, '2026-01-15 16:46:55');
INSERT INTO `user_action_operation` VALUES (737, 61, 'SCENIC_SPOT_STRATEGY', 5, 1, NULL, '2026-01-15 16:46:56');
INSERT INTO `user_action_operation` VALUES (738, 61, 'SCENIC_SPOT_STRATEGY', 5, 2, NULL, '2026-01-15 16:46:56');
INSERT INTO `user_action_operation` VALUES (739, 61, 'SCENIC_SPOT_STRATEGY', 5, 4, 2148, '2026-01-15 16:46:57');
INSERT INTO `user_action_operation` VALUES (740, 61, 'SCENIC_SPOT_STRATEGY', 6, 3, NULL, '2026-01-15 16:46:59');
INSERT INTO `user_action_operation` VALUES (741, 61, 'SCENIC_SPOT_STRATEGY', 6, 1, NULL, '2026-01-15 16:47:00');
INSERT INTO `user_action_operation` VALUES (742, 61, 'SCENIC_SPOT_STRATEGY', 6, 2, NULL, '2026-01-15 16:47:00');
INSERT INTO `user_action_operation` VALUES (743, 61, 'SCENIC_SPOT_STRATEGY', 6, 4, 2237, '2026-01-15 16:47:01');
INSERT INTO `user_action_operation` VALUES (744, 61, 'SCENIC_SPOT_STRATEGY', 10, 3, NULL, '2026-01-15 16:47:06');
INSERT INTO `user_action_operation` VALUES (745, 61, 'SCENIC_SPOT_STRATEGY', 10, 1, NULL, '2026-01-15 16:47:07');
INSERT INTO `user_action_operation` VALUES (746, 61, 'SCENIC_SPOT_STRATEGY', 10, 2, NULL, '2026-01-15 16:47:07');
INSERT INTO `user_action_operation` VALUES (747, 61, 'SCENIC_SPOT_STRATEGY', 10, 4, 1803, '2026-01-15 16:47:08');
INSERT INTO `user_action_operation` VALUES (748, 61, 'SCENIC_SPOT_STRATEGY', 1, 3, NULL, '2026-01-15 16:47:10');
INSERT INTO `user_action_operation` VALUES (749, 61, 'SCENIC_SPOT_STRATEGY', 1, 1, NULL, '2026-01-15 16:47:11');
INSERT INTO `user_action_operation` VALUES (750, 61, 'SCENIC_SPOT_STRATEGY', 1, 2, NULL, '2026-01-15 16:47:11');
INSERT INTO `user_action_operation` VALUES (751, 61, 'SCENIC_SPOT_STRATEGY', 1, 4, 1890, '2026-01-15 16:47:12');
INSERT INTO `user_action_operation` VALUES (752, 60, 'SCENIC_SPOT_STRATEGY', 4, 3, NULL, '2026-01-15 18:02:18');
INSERT INTO `user_action_operation` VALUES (753, 60, 'SCENIC_SPOT_STRATEGY', 4, 4, 1870, '2026-01-15 18:02:20');
INSERT INTO `user_action_operation` VALUES (754, 60, 'SCENIC_SPOT', 19, 3, NULL, '2026-01-15 19:04:15');
INSERT INTO `user_action_operation` VALUES (755, 60, 'SCENIC_SPOT', 19, 4, 2432, '2026-01-15 19:04:18');
INSERT INTO `user_action_operation` VALUES (756, 60, 'SCENIC_SPOT_STRATEGY', 4, 3, NULL, '2026-01-15 19:07:11');
INSERT INTO `user_action_operation` VALUES (757, 60, 'SCENIC_SPOT_STRATEGY', 4, 4, 12913, '2026-01-15 19:07:24');
INSERT INTO `user_action_operation` VALUES (758, 60, 'SCENIC_SPOT_STRATEGY', 4, 4, 27686, '2026-01-15 19:07:39');
INSERT INTO `user_action_operation` VALUES (759, 60, 'SCENIC_SPOT_STRATEGY', 4, 4, 79460, '2026-01-15 19:08:31');
INSERT INTO `user_action_operation` VALUES (760, 60, 'SCENIC_SPOT_STRATEGY', 13, 3, NULL, '2026-01-15 19:08:33');
INSERT INTO `user_action_operation` VALUES (761, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 10393, '2026-01-15 19:08:44');
INSERT INTO `user_action_operation` VALUES (762, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 39301, '2026-01-15 19:09:13');
INSERT INTO `user_action_operation` VALUES (763, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 51893, '2026-01-15 19:09:25');
INSERT INTO `user_action_operation` VALUES (764, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 97560, '2026-01-15 19:10:11');
INSERT INTO `user_action_operation` VALUES (765, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 116568, '2026-01-15 19:10:30');
INSERT INTO `user_action_operation` VALUES (766, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 129271, '2026-01-15 19:10:43');
INSERT INTO `user_action_operation` VALUES (767, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 137908, '2026-01-15 19:10:51');
INSERT INTO `user_action_operation` VALUES (768, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 147761, '2026-01-15 19:11:01');
INSERT INTO `user_action_operation` VALUES (769, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 158517, '2026-01-15 19:11:12');
INSERT INTO `user_action_operation` VALUES (770, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 174771, '2026-01-15 19:11:28');
INSERT INTO `user_action_operation` VALUES (771, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 188188, '2026-01-15 19:11:42');
INSERT INTO `user_action_operation` VALUES (772, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 199403, '2026-01-15 19:11:53');
INSERT INTO `user_action_operation` VALUES (773, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 206051, '2026-01-15 19:11:59');
INSERT INTO `user_action_operation` VALUES (774, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 214203, '2026-01-15 19:12:08');
INSERT INTO `user_action_operation` VALUES (775, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 217924, '2026-01-15 19:12:11');
INSERT INTO `user_action_operation` VALUES (776, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 270100, '2026-01-15 19:13:03');
INSERT INTO `user_action_operation` VALUES (777, 60, 'SCENIC_SPOT_STRATEGY', 13, 3, NULL, '2026-01-15 19:13:03');
INSERT INTO `user_action_operation` VALUES (778, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 8245, '2026-01-15 19:13:12');
INSERT INTO `user_action_operation` VALUES (779, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 23931, '2026-01-15 19:13:27');
INSERT INTO `user_action_operation` VALUES (780, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 51616, '2026-01-15 19:13:55');
INSERT INTO `user_action_operation` VALUES (781, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 81679, '2026-01-15 19:14:25');
INSERT INTO `user_action_operation` VALUES (782, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 92068, '2026-01-15 19:14:36');
INSERT INTO `user_action_operation` VALUES (783, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 97346, '2026-01-15 19:14:41');
INSERT INTO `user_action_operation` VALUES (784, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 110773, '2026-01-15 19:14:54');
INSERT INTO `user_action_operation` VALUES (785, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 128127, '2026-01-15 19:15:12');
INSERT INTO `user_action_operation` VALUES (786, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 142797, '2026-01-15 19:15:26');
INSERT INTO `user_action_operation` VALUES (787, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 158389, '2026-01-15 19:15:42');
INSERT INTO `user_action_operation` VALUES (788, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 167720, '2026-01-15 19:15:51');
INSERT INTO `user_action_operation` VALUES (789, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 182298, '2026-01-15 19:16:06');
INSERT INTO `user_action_operation` VALUES (790, 60, 'SCENIC_SPOT_STRATEGY', 13, 3, NULL, '2026-01-15 19:16:06');
INSERT INTO `user_action_operation` VALUES (791, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 13284, '2026-01-15 19:16:19');
INSERT INTO `user_action_operation` VALUES (792, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 38274, '2026-01-15 19:16:44');
INSERT INTO `user_action_operation` VALUES (793, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 50172, '2026-01-15 19:16:56');
INSERT INTO `user_action_operation` VALUES (794, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 83576, '2026-01-15 19:17:29');
INSERT INTO `user_action_operation` VALUES (795, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-15 19:17:39');
INSERT INTO `user_action_operation` VALUES (796, 60, 'SCENIC_SPOT', 20, 4, 5119, '2026-01-15 19:17:44');
INSERT INTO `user_action_operation` VALUES (797, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 99780, '2026-01-15 19:17:46');
INSERT INTO `user_action_operation` VALUES (798, 60, 'SCENIC_SPOT', 20, 4, 9280, '2026-01-15 19:17:48');
INSERT INTO `user_action_operation` VALUES (799, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 105692, '2026-01-15 19:17:51');
INSERT INTO `user_action_operation` VALUES (800, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 179382, '2026-01-15 19:19:05');
INSERT INTO `user_action_operation` VALUES (801, 60, 'SCENIC_SPOT_STRATEGY', 13, 3, NULL, '2026-01-15 19:19:05');
INSERT INTO `user_action_operation` VALUES (802, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 52336, '2026-01-15 19:19:57');
INSERT INTO `user_action_operation` VALUES (803, 60, 'SCENIC_SPOT_STRATEGY', 13, 3, NULL, '2026-01-15 19:19:58');
INSERT INTO `user_action_operation` VALUES (804, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 18471, '2026-01-15 19:20:16');
INSERT INTO `user_action_operation` VALUES (805, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 51435, '2026-01-15 19:20:49');
INSERT INTO `user_action_operation` VALUES (806, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 84944, '2026-01-15 19:21:22');
INSERT INTO `user_action_operation` VALUES (807, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 103217, '2026-01-15 19:21:41');
INSERT INTO `user_action_operation` VALUES (808, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 120643, '2026-01-15 19:21:58');
INSERT INTO `user_action_operation` VALUES (809, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 164062, '2026-01-15 19:22:42');
INSERT INTO `user_action_operation` VALUES (810, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 179554, '2026-01-15 19:22:57');
INSERT INTO `user_action_operation` VALUES (811, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 192547, '2026-01-15 19:23:10');
INSERT INTO `user_action_operation` VALUES (812, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 199211, '2026-01-15 19:23:17');
INSERT INTO `user_action_operation` VALUES (813, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 204716, '2026-01-15 19:23:22');
INSERT INTO `user_action_operation` VALUES (814, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 228828, '2026-01-15 19:23:46');
INSERT INTO `user_action_operation` VALUES (817, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 277255, '2026-01-15 19:24:35');
INSERT INTO `user_action_operation` VALUES (818, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 294837, '2026-01-15 19:24:52');
INSERT INTO `user_action_operation` VALUES (819, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 302043, '2026-01-15 19:25:00');
INSERT INTO `user_action_operation` VALUES (820, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 331050, '2026-01-15 19:25:29');
INSERT INTO `user_action_operation` VALUES (821, 60, 'SCENIC_SPOT_STRATEGY', 13, 3, NULL, '2026-01-15 19:25:29');
INSERT INTO `user_action_operation` VALUES (822, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 1245, '2026-01-15 19:25:30');
INSERT INTO `user_action_operation` VALUES (823, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 17429, '2026-01-15 19:25:46');
INSERT INTO `user_action_operation` VALUES (825, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 36556, '2026-01-15 19:26:05');
INSERT INTO `user_action_operation` VALUES (826, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 48400, '2026-01-15 19:26:17');
INSERT INTO `user_action_operation` VALUES (827, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 61040, '2026-01-15 19:26:30');
INSERT INTO `user_action_operation` VALUES (828, 60, 'SCENIC_SPOT_STRATEGY', 13, 3, NULL, '2026-01-15 19:26:30');
INSERT INTO `user_action_operation` VALUES (830, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 60166, '2026-01-15 19:27:30');
INSERT INTO `user_action_operation` VALUES (831, 60, 'SCENIC_SPOT_STRATEGY', 13, 3, NULL, '2026-01-15 19:27:30');
INSERT INTO `user_action_operation` VALUES (834, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 20771, '2026-01-15 19:27:51');
INSERT INTO `user_action_operation` VALUES (836, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 43933, '2026-01-15 19:28:14');
INSERT INTO `user_action_operation` VALUES (837, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 75855, '2026-01-15 19:28:46');
INSERT INTO `user_action_operation` VALUES (841, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 100771, '2026-01-15 19:29:11');
INSERT INTO `user_action_operation` VALUES (842, 60, 'SCENIC_SPOT_STRATEGY', 13, 3, NULL, '2026-01-15 19:29:11');
INSERT INTO `user_action_operation` VALUES (843, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 16591, '2026-01-15 19:29:27');
INSERT INTO `user_action_operation` VALUES (844, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 26672, '2026-01-15 19:29:37');
INSERT INTO `user_action_operation` VALUES (845, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 45554, '2026-01-15 19:29:56');
INSERT INTO `user_action_operation` VALUES (846, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 54696, '2026-01-15 19:30:05');
INSERT INTO `user_action_operation` VALUES (848, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 101123, '2026-01-15 19:30:52');
INSERT INTO `user_action_operation` VALUES (849, 60, 'SCENIC_SPOT_STRATEGY', 13, 3, NULL, '2026-01-15 19:33:21');
INSERT INTO `user_action_operation` VALUES (851, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 863020, '2026-01-15 19:47:44');
INSERT INTO `user_action_operation` VALUES (852, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 891209, '2026-01-15 19:48:12');
INSERT INTO `user_action_operation` VALUES (853, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 929690, '2026-01-15 19:48:50');
INSERT INTO `user_action_operation` VALUES (854, 60, 'SCENIC_SPOT_STRATEGY', 13, 3, NULL, '2026-01-15 19:48:51');
INSERT INTO `user_action_operation` VALUES (855, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 10168, '2026-01-15 19:49:01');
INSERT INTO `user_action_operation` VALUES (856, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 34397, '2026-01-15 19:49:25');
INSERT INTO `user_action_operation` VALUES (857, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 352606, '2026-01-15 19:54:44');
INSERT INTO `user_action_operation` VALUES (858, 60, 'SCENIC_SPOT_STRATEGY', 13, 3, NULL, '2026-01-15 19:54:44');
INSERT INTO `user_action_operation` VALUES (859, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 12007, '2026-01-15 19:54:55');
INSERT INTO `user_action_operation` VALUES (860, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 79433, '2026-01-15 19:56:03');
INSERT INTO `user_action_operation` VALUES (861, 60, 'SCENIC_SPOT_STRATEGY', 13, 3, NULL, '2026-01-15 19:56:03');
INSERT INTO `user_action_operation` VALUES (862, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 4818, '2026-01-15 19:56:08');
INSERT INTO `user_action_operation` VALUES (863, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 23983, '2026-01-15 19:56:27');
INSERT INTO `user_action_operation` VALUES (864, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 39617, '2026-01-15 19:56:42');
INSERT INTO `user_action_operation` VALUES (865, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 97057, '2026-01-15 19:57:40');
INSERT INTO `user_action_operation` VALUES (866, 60, 'SCENIC_SPOT_STRATEGY', 13, 3, NULL, '2026-01-15 19:57:40');
INSERT INTO `user_action_operation` VALUES (867, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 1885, '2026-01-15 19:57:42');
INSERT INTO `user_action_operation` VALUES (868, 60, 'SCENIC_SPOT_STRATEGY', 13, 3, NULL, '2026-01-15 19:57:42');
INSERT INTO `user_action_operation` VALUES (869, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 4430, '2026-01-15 19:57:46');
INSERT INTO `user_action_operation` VALUES (870, 60, 'SCENIC_SPOT_STRATEGY', 13, 3, NULL, '2026-01-15 19:57:46');
INSERT INTO `user_action_operation` VALUES (872, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 4297, '2026-01-15 19:57:51');
INSERT INTO `user_action_operation` VALUES (873, 60, 'SCENIC_SPOT_STRATEGY', 13, 3, NULL, '2026-01-15 19:57:51');
INSERT INTO `user_action_operation` VALUES (874, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 3069, '2026-01-15 19:57:54');
INSERT INTO `user_action_operation` VALUES (875, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 52381, '2026-01-15 19:58:43');
INSERT INTO `user_action_operation` VALUES (876, 60, 'SCENIC_SPOT_STRATEGY', 13, 3, NULL, '2026-01-15 19:58:43');
INSERT INTO `user_action_operation` VALUES (877, 60, 'SCENIC_SPOT_STRATEGY', 13, 2, NULL, '2026-01-15 19:58:48');
INSERT INTO `user_action_operation` VALUES (878, 60, 'SCENIC_SPOT_STRATEGY', 13, 1, NULL, '2026-01-15 19:58:50');
INSERT INTO `user_action_operation` VALUES (879, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 12615, '2026-01-15 19:58:56');
INSERT INTO `user_action_operation` VALUES (880, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 72899775, '2026-01-16 16:13:43');
INSERT INTO `user_action_operation` VALUES (881, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 72926134, '2026-01-16 16:14:09');
INSERT INTO `user_action_operation` VALUES (882, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 72953664, '2026-01-16 16:14:37');
INSERT INTO `user_action_operation` VALUES (883, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 72966932, '2026-01-16 16:14:50');
INSERT INTO `user_action_operation` VALUES (884, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 73013116, '2026-01-16 16:15:36');
INSERT INTO `user_action_operation` VALUES (885, 60, 'SCENIC_SPOT', 20, 4, 75478317, '2026-01-16 16:15:37');
INSERT INTO `user_action_operation` VALUES (886, 60, 'SCENIC_SPOT', 20, 4, 75568554, '2026-01-16 16:17:07');
INSERT INTO `user_action_operation` VALUES (887, 60, 'SCENIC_SPOT', 20, 4, 75573504, '2026-01-16 16:17:12');
INSERT INTO `user_action_operation` VALUES (888, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 73112647, '2026-01-16 16:17:16');
INSERT INTO `user_action_operation` VALUES (889, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 73133834, '2026-01-16 16:17:37');
INSERT INTO `user_action_operation` VALUES (890, 60, 'SCENIC_SPOT', 20, 4, 75610746, '2026-01-16 16:17:50');
INSERT INTO `user_action_operation` VALUES (891, 60, 'SCENIC_SPOT', 20, 4, 75669756, '2026-01-16 16:18:49');
INSERT INTO `user_action_operation` VALUES (892, 60, 'SCENIC_SPOT', 20, 4, 75678616, '2026-01-16 16:18:57');
INSERT INTO `user_action_operation` VALUES (893, 60, 'SCENIC_SPOT', 20, 4, 75709808, '2026-01-16 16:19:29');
INSERT INTO `user_action_operation` VALUES (894, 60, 'SCENIC_SPOT', 20, 4, 75722109, '2026-01-16 16:19:41');
INSERT INTO `user_action_operation` VALUES (895, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 73263298, '2026-01-16 16:19:46');
INSERT INTO `user_action_operation` VALUES (896, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 73280755, '2026-01-16 16:20:04');
INSERT INTO `user_action_operation` VALUES (897, 60, 'SCENIC_SPOT', 20, 4, 75749321, '2026-01-16 16:20:08');
INSERT INTO `user_action_operation` VALUES (898, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-16 16:23:19');
INSERT INTO `user_action_operation` VALUES (899, 60, 'SCENIC_SPOT', 20, 4, 4959, '2026-01-16 16:23:23');
INSERT INTO `user_action_operation` VALUES (900, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-16 16:23:23');
INSERT INTO `user_action_operation` VALUES (901, 60, 'SCENIC_SPOT', 20, 4, 14018, '2026-01-16 16:23:37');
INSERT INTO `user_action_operation` VALUES (902, 60, 'SCENIC_SPOT', 20, 4, 146644, '2026-01-16 16:25:50');
INSERT INTO `user_action_operation` VALUES (903, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-16 16:25:50');
INSERT INTO `user_action_operation` VALUES (904, 60, 'SCENIC_SPOT', 20, 4, 11670, '2026-01-16 16:26:01');
INSERT INTO `user_action_operation` VALUES (905, 60, 'SCENIC_SPOT', 20, 4, 28800, '2026-01-16 16:26:18');
INSERT INTO `user_action_operation` VALUES (906, 60, 'SCENIC_SPOT', 20, 4, 41489, '2026-01-16 16:26:31');
INSERT INTO `user_action_operation` VALUES (907, 60, 'SCENIC_SPOT', 20, 4, 49456, '2026-01-16 16:26:39');
INSERT INTO `user_action_operation` VALUES (908, 60, 'SCENIC_SPOT', 20, 4, 63217, '2026-01-16 16:26:53');
INSERT INTO `user_action_operation` VALUES (909, 60, 'SCENIC_SPOT', 20, 4, 79706, '2026-01-16 16:27:09');
INSERT INTO `user_action_operation` VALUES (911, 60, 'SCENIC_SPOT', 20, 4, 103134, '2026-01-16 16:27:33');
INSERT INTO `user_action_operation` VALUES (912, 60, 'SCENIC_SPOT', 20, 4, 127290, '2026-01-16 16:27:57');
INSERT INTO `user_action_operation` VALUES (913, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-16 16:27:57');
INSERT INTO `user_action_operation` VALUES (914, 60, 'SCENIC_SPOT', 20, 4, 13098, '2026-01-16 16:28:10');
INSERT INTO `user_action_operation` VALUES (915, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-16 16:28:10');
INSERT INTO `user_action_operation` VALUES (916, 60, 'SCENIC_SPOT', 20, 4, 3920, '2026-01-16 16:28:14');
INSERT INTO `user_action_operation` VALUES (917, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-16 16:28:14');
INSERT INTO `user_action_operation` VALUES (920, 60, 'SCENIC_SPOT', 20, 4, 10224, '2026-01-16 16:28:24');
INSERT INTO `user_action_operation` VALUES (921, 60, 'SCENIC_SPOT', 20, 4, 29925, '2026-01-16 16:28:44');
INSERT INTO `user_action_operation` VALUES (922, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-16 16:28:44');
INSERT INTO `user_action_operation` VALUES (923, 60, 'SCENIC_SPOT', 20, 4, 2384, '2026-01-16 16:28:46');
INSERT INTO `user_action_operation` VALUES (924, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-16 16:28:47');
INSERT INTO `user_action_operation` VALUES (925, 60, 'SCENIC_SPOT', 20, 4, 7610, '2026-01-16 16:28:54');
INSERT INTO `user_action_operation` VALUES (926, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-16 16:28:54');
INSERT INTO `user_action_operation` VALUES (927, 60, 'SCENIC_SPOT', 20, 1, NULL, '2026-01-16 16:28:57');
INSERT INTO `user_action_operation` VALUES (928, 60, 'SCENIC_SPOT', 20, 2, NULL, '2026-01-16 16:29:00');
INSERT INTO `user_action_operation` VALUES (929, 60, 'SCENIC_SPOT', 20, 4, 34567, '2026-01-16 16:29:29');
INSERT INTO `user_action_operation` VALUES (930, 60, 'SCENIC_SPOT', 20, 4, 717836, '2026-01-16 16:40:52');
INSERT INTO `user_action_operation` VALUES (931, 60, 'SCENIC_SPOT', 20, 4, 727504, '2026-01-16 16:41:02');
INSERT INTO `user_action_operation` VALUES (932, 60, 'SCENIC_SPOT', 20, 4, 731151, '2026-01-16 16:41:05');
INSERT INTO `user_action_operation` VALUES (933, 60, 'SCENIC_SPOT', 20, 4, 761457, '2026-01-16 16:41:36');
INSERT INTO `user_action_operation` VALUES (934, 60, 'SCENIC_SPOT', 20, 4, 790266, '2026-01-16 16:42:04');
INSERT INTO `user_action_operation` VALUES (935, 60, 'SCENIC_SPOT', 20, 4, 830862, '2026-01-16 16:42:45');
INSERT INTO `user_action_operation` VALUES (936, 60, 'SCENIC_SPOT', 20, 4, 843770, '2026-01-16 16:42:58');
INSERT INTO `user_action_operation` VALUES (937, 60, 'SCENIC_SPOT', 20, 4, 860898, '2026-01-16 16:43:15');
INSERT INTO `user_action_operation` VALUES (938, 60, 'SCENIC_SPOT', 20, 4, 874885, '2026-01-16 16:43:29');
INSERT INTO `user_action_operation` VALUES (939, 60, 'SCENIC_SPOT', 20, 4, 916324, '2026-01-16 16:44:10');
INSERT INTO `user_action_operation` VALUES (940, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-16 16:44:10');
INSERT INTO `user_action_operation` VALUES (941, 60, 'SCENIC_SPOT', 20, 4, 69081, '2026-01-16 16:45:19');
INSERT INTO `user_action_operation` VALUES (942, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-16 16:45:20');
INSERT INTO `user_action_operation` VALUES (943, 60, 'SCENIC_SPOT', 20, 4, 32487, '2026-01-16 16:45:52');
INSERT INTO `user_action_operation` VALUES (944, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-16 16:45:52');
INSERT INTO `user_action_operation` VALUES (945, 60, 'SCENIC_SPOT', 20, 4, 2290, '2026-01-16 16:45:54');
INSERT INTO `user_action_operation` VALUES (946, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-16 16:45:54');
INSERT INTO `user_action_operation` VALUES (947, 60, 'SCENIC_SPOT', 20, 4, 115740, '2026-01-16 16:47:50');
INSERT INTO `user_action_operation` VALUES (948, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-16 16:47:50');
INSERT INTO `user_action_operation` VALUES (949, 60, 'SCENIC_SPOT', 20, 4, 7339, '2026-01-16 16:47:57');
INSERT INTO `user_action_operation` VALUES (950, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-16 16:47:57');
INSERT INTO `user_action_operation` VALUES (951, 60, 'SCENIC_SPOT', 20, 4, 18570, '2026-01-16 16:48:16');
INSERT INTO `user_action_operation` VALUES (952, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-16 16:48:16');
INSERT INTO `user_action_operation` VALUES (953, 60, 'SCENIC_SPOT', 20, 4, 4187, '2026-01-16 16:48:20');
INSERT INTO `user_action_operation` VALUES (954, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-16 16:48:20');
INSERT INTO `user_action_operation` VALUES (955, 60, 'SCENIC_SPOT', 20, 4, 18723, '2026-01-16 16:48:39');
INSERT INTO `user_action_operation` VALUES (956, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-16 16:48:39');
INSERT INTO `user_action_operation` VALUES (957, 60, 'SCENIC_SPOT', 20, 4, 6509, '2026-01-16 16:48:45');
INSERT INTO `user_action_operation` VALUES (958, 60, 'SCENIC_SPOT', 20, 4, 43679, '2026-01-16 16:49:23');
INSERT INTO `user_action_operation` VALUES (959, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-16 16:49:23');
INSERT INTO `user_action_operation` VALUES (960, 60, 'SCENIC_SPOT', 20, 4, 4599, '2026-01-16 16:49:27');
INSERT INTO `user_action_operation` VALUES (961, 60, 'SCENIC_SPOT', 20, 4, 30251, '2026-01-16 16:49:53');
INSERT INTO `user_action_operation` VALUES (962, 60, 'SCENIC_SPOT', 19, 3, NULL, '2026-01-16 16:49:57');
INSERT INTO `user_action_operation` VALUES (963, 60, 'SCENIC_SPOT', 19, 4, 4091, '2026-01-16 16:50:01');
INSERT INTO `user_action_operation` VALUES (964, 60, 'SCENIC_SPOT', 19, 3, NULL, '2026-01-16 16:50:29');
INSERT INTO `user_action_operation` VALUES (965, 60, 'SCENIC_SPOT', 19, 4, 6354, '2026-01-16 16:50:35');
INSERT INTO `user_action_operation` VALUES (966, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-16 16:50:39');
INSERT INTO `user_action_operation` VALUES (967, 60, 'SCENIC_SPOT', 16, 4, 5630, '2026-01-16 16:50:44');
INSERT INTO `user_action_operation` VALUES (968, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-16 16:50:45');
INSERT INTO `user_action_operation` VALUES (969, 60, 'SCENIC_SPOT', 16, 4, 14645, '2026-01-16 16:50:59');
INSERT INTO `user_action_operation` VALUES (970, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 75360375, '2026-01-16 16:54:44');
INSERT INTO `user_action_operation` VALUES (971, 60, 'SCENIC_SPOT', 16, 4, 238837, '2026-01-16 16:54:44');
INSERT INTO `user_action_operation` VALUES (972, 60, 'SCENIC_SPOT_STRATEGY', 13, 3, NULL, '2026-01-16 16:54:44');
INSERT INTO `user_action_operation` VALUES (973, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-16 16:54:44');
INSERT INTO `user_action_operation` VALUES (974, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 25261, '2026-01-16 16:55:09');
INSERT INTO `user_action_operation` VALUES (975, 60, 'SCENIC_SPOT', 16, 4, 25296, '2026-01-16 16:55:09');
INSERT INTO `user_action_operation` VALUES (976, 60, 'SCENIC_SPOT_STRATEGY', 13, 3, NULL, '2026-01-16 16:55:09');
INSERT INTO `user_action_operation` VALUES (977, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-16 16:55:09');
INSERT INTO `user_action_operation` VALUES (978, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 10028, '2026-01-16 16:55:19');
INSERT INTO `user_action_operation` VALUES (979, 60, 'SCENIC_SPOT', 16, 4, 10045, '2026-01-16 16:55:19');
INSERT INTO `user_action_operation` VALUES (980, 60, 'SCENIC_SPOT_STRATEGY', 13, 3, NULL, '2026-01-16 16:55:19');
INSERT INTO `user_action_operation` VALUES (981, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-16 16:55:19');
INSERT INTO `user_action_operation` VALUES (982, 60, 'SCENIC_SPOT', 16, 4, 25860, '2026-01-16 16:55:45');
INSERT INTO `user_action_operation` VALUES (983, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-16 16:55:45');
INSERT INTO `user_action_operation` VALUES (984, 60, 'SCENIC_SPOT', 16, 4, 4878, '2026-01-16 16:55:49');
INSERT INTO `user_action_operation` VALUES (985, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-16 16:55:50');
INSERT INTO `user_action_operation` VALUES (986, 60, 'SCENIC_SPOT', 16, 4, 3794, '2026-01-16 16:55:53');
INSERT INTO `user_action_operation` VALUES (987, 60, 'SCENIC_SPOT', 16, 4, 7820, '2026-01-16 16:55:57');
INSERT INTO `user_action_operation` VALUES (988, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 38750, '2026-01-16 16:55:57');
INSERT INTO `user_action_operation` VALUES (989, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-16 16:55:58');
INSERT INTO `user_action_operation` VALUES (990, 60, 'SCENIC_SPOT_STRATEGY', 13, 3, NULL, '2026-01-16 16:55:58');
INSERT INTO `user_action_operation` VALUES (991, 60, 'SCENIC_SPOT', 16, 4, 12993, '2026-01-16 16:56:10');
INSERT INTO `user_action_operation` VALUES (992, 60, 'SCENIC_SPOT', 16, 4, 71144, '2026-01-16 16:57:09');
INSERT INTO `user_action_operation` VALUES (993, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-16 16:57:09');
INSERT INTO `user_action_operation` VALUES (994, 60, 'SCENIC_SPOT', 16, 4, 21317, '2026-01-16 16:57:30');
INSERT INTO `user_action_operation` VALUES (995, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-16 16:57:30');
INSERT INTO `user_action_operation` VALUES (996, 60, 'SCENIC_SPOT', 16, 4, 22293, '2026-01-16 16:57:52');
INSERT INTO `user_action_operation` VALUES (997, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-16 16:57:52');
INSERT INTO `user_action_operation` VALUES (998, 60, 'SCENIC_SPOT', 16, 4, 20063, '2026-01-16 16:58:12');
INSERT INTO `user_action_operation` VALUES (999, 60, 'SCENIC_SPOT', 16, 4, 47297, '2026-01-16 16:58:39');
INSERT INTO `user_action_operation` VALUES (1000, 60, 'SCENIC_SPOT', 16, 4, 63946, '2026-01-16 16:58:56');
INSERT INTO `user_action_operation` VALUES (1001, 60, 'SCENIC_SPOT', 16, 4, 68593, '2026-01-16 16:59:01');
INSERT INTO `user_action_operation` VALUES (1002, 60, 'SCENIC_SPOT', 16, 4, 74852, '2026-01-16 16:59:07');
INSERT INTO `user_action_operation` VALUES (1003, 60, 'SCENIC_SPOT', 16, 4, 122664, '2026-01-16 16:59:55');
INSERT INTO `user_action_operation` VALUES (1004, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-16 16:59:55');
INSERT INTO `user_action_operation` VALUES (1005, 60, 'SCENIC_SPOT', 16, 4, 6067, '2026-01-16 17:00:01');
INSERT INTO `user_action_operation` VALUES (1006, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-16 17:00:01');
INSERT INTO `user_action_operation` VALUES (1007, 60, 'SCENIC_SPOT', 16, 4, 27025, '2026-01-16 17:00:28');
INSERT INTO `user_action_operation` VALUES (1008, 60, 'SCENIC_SPOT', 16, 4, 53176, '2026-01-16 17:00:54');
INSERT INTO `user_action_operation` VALUES (1009, 60, 'SCENIC_SPOT', 16, 4, 62749, '2026-01-16 17:01:04');
INSERT INTO `user_action_operation` VALUES (1010, 60, 'SCENIC_SPOT', 16, 4, 70855, '2026-01-16 17:01:12');
INSERT INTO `user_action_operation` VALUES (1011, 60, 'SCENIC_SPOT', 16, 4, 81633, '2026-01-16 17:01:23');
INSERT INTO `user_action_operation` VALUES (1012, 60, 'SCENIC_SPOT', 16, 4, 94708, '2026-01-16 17:01:36');
INSERT INTO `user_action_operation` VALUES (1013, 60, 'SCENIC_SPOT', 16, 4, 140071, '2026-01-16 17:02:21');
INSERT INTO `user_action_operation` VALUES (1014, 60, 'SCENIC_SPOT', 16, 4, 151799, '2026-01-16 17:02:33');
INSERT INTO `user_action_operation` VALUES (1015, 60, 'SCENIC_SPOT_STRATEGY', 13, 3, NULL, '2026-01-16 17:02:33');
INSERT INTO `user_action_operation` VALUES (1016, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 2082, '2026-01-16 17:02:35');
INSERT INTO `user_action_operation` VALUES (1017, 60, 'SCENIC_SPOT', 16, 4, 157013, '2026-01-16 17:02:38');
INSERT INTO `user_action_operation` VALUES (1018, 60, 'SCENIC_SPOT', 16, 4, 160933, '2026-01-16 17:02:42');
INSERT INTO `user_action_operation` VALUES (1019, 60, 'SCENIC_SPOT', 16, 4, 196690, '2026-01-16 17:03:18');
INSERT INTO `user_action_operation` VALUES (1020, 60, 'SCENIC_SPOT', 16, 4, 306729, '2026-01-16 17:05:08');
INSERT INTO `user_action_operation` VALUES (1021, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 554158, '2026-01-16 17:05:12');
INSERT INTO `user_action_operation` VALUES (1022, 60, 'SCENIC_SPOT', 16, 4, 310840, '2026-01-16 17:05:12');
INSERT INTO `user_action_operation` VALUES (1023, 60, 'SCENIC_SPOT_STRATEGY', 13, 3, NULL, '2026-01-16 17:05:12');
INSERT INTO `user_action_operation` VALUES (1024, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-16 17:05:12');
INSERT INTO `user_action_operation` VALUES (1025, 60, 'SCENIC_SPOT', 16, 4, 7188, '2026-01-16 17:05:19');
INSERT INTO `user_action_operation` VALUES (1026, 60, 'SCENIC_SPOT', 16, 4, 14656, '2026-01-16 17:05:26');
INSERT INTO `user_action_operation` VALUES (1027, 60, 'SCENIC_SPOT', 16, 4, 17185, '2026-01-16 17:05:29');
INSERT INTO `user_action_operation` VALUES (1028, 60, 'SCENIC_SPOT', 16, 4, 404797, '2026-01-16 17:11:57');
INSERT INTO `user_action_operation` VALUES (1029, 60, 'SCENIC_SPOT', 16, 4, 536448, '2026-01-16 17:14:08');
INSERT INTO `user_action_operation` VALUES (1030, 60, 'SCENIC_SPOT_STRATEGY', 13, 3, NULL, '2026-01-16 17:26:20');
INSERT INTO `user_action_operation` VALUES (1031, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-16 17:26:20');
INSERT INTO `user_action_operation` VALUES (1032, 60, 'SCENIC_SPOT_STRATEGY', 13, 3, NULL, '2026-01-16 17:26:21');
INSERT INTO `user_action_operation` VALUES (1033, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-16 17:26:21');
INSERT INTO `user_action_operation` VALUES (1034, 60, 'SCENIC_SPOT', 16, 4, 14089, '2026-01-16 17:26:35');
INSERT INTO `user_action_operation` VALUES (1035, 60, 'SCENIC_SPOT_STRATEGY', 13, 3, NULL, '2026-01-16 17:27:07');
INSERT INTO `user_action_operation` VALUES (1036, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-16 17:27:07');
INSERT INTO `user_action_operation` VALUES (1037, 60, 'SCENIC_SPOT_STRATEGY', 13, 3, NULL, '2026-01-16 17:27:22');
INSERT INTO `user_action_operation` VALUES (1038, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-16 17:27:22');
INSERT INTO `user_action_operation` VALUES (1039, 60, 'SCENIC_SPOT', 16, 4, 115990, '2026-01-16 17:29:18');
INSERT INTO `user_action_operation` VALUES (1040, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-16 17:29:18');
INSERT INTO `user_action_operation` VALUES (1041, 60, 'SCENIC_SPOT', 16, 4, 72098, '2026-01-16 17:30:30');
INSERT INTO `user_action_operation` VALUES (1042, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-16 17:30:30');
INSERT INTO `user_action_operation` VALUES (1043, 60, 'SCENIC_SPOT', 16, 4, 4493, '2026-01-16 17:30:35');
INSERT INTO `user_action_operation` VALUES (1044, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-16 17:30:35');
INSERT INTO `user_action_operation` VALUES (1045, 60, 'SCENIC_SPOT', 16, 4, 7358, '2026-01-16 17:30:42');
INSERT INTO `user_action_operation` VALUES (1046, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-16 17:30:42');
INSERT INTO `user_action_operation` VALUES (1047, 60, 'SCENIC_SPOT', 16, 4, 3208, '2026-01-16 17:30:46');
INSERT INTO `user_action_operation` VALUES (1048, 60, 'SCENIC_SPOT', 16, 4, 37848, '2026-01-16 17:31:20');
INSERT INTO `user_action_operation` VALUES (1049, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-16 17:31:20');
INSERT INTO `user_action_operation` VALUES (1050, 60, 'SCENIC_SPOT', 16, 4, 5830, '2026-01-16 17:31:26');
INSERT INTO `user_action_operation` VALUES (1051, 60, 'SCENIC_SPOT', 16, 4, 21219, '2026-01-16 17:31:42');
INSERT INTO `user_action_operation` VALUES (1052, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-16 17:31:42');
INSERT INTO `user_action_operation` VALUES (1053, 60, 'SCENIC_SPOT', 16, 4, 7073, '2026-01-16 17:31:49');
INSERT INTO `user_action_operation` VALUES (1054, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-16 17:31:49');
INSERT INTO `user_action_operation` VALUES (1055, 60, 'SCENIC_SPOT', 16, 4, 25156, '2026-01-16 17:32:14');
INSERT INTO `user_action_operation` VALUES (1056, 60, 'SCENIC_SPOT', 16, 4, 27843, '2026-01-16 17:32:16');
INSERT INTO `user_action_operation` VALUES (1057, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-16 17:32:17');
INSERT INTO `user_action_operation` VALUES (1058, 60, 'SCENIC_SPOT', 16, 4, 4449, '2026-01-16 17:32:21');
INSERT INTO `user_action_operation` VALUES (1059, 60, 'SCENIC_SPOT', 16, 4, 6657, '2026-01-16 17:32:23');
INSERT INTO `user_action_operation` VALUES (1060, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-16 17:32:23');
INSERT INTO `user_action_operation` VALUES (1061, 60, 'SCENIC_SPOT', 16, 4, 9047, '2026-01-16 17:32:32');
INSERT INTO `user_action_operation` VALUES (1062, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-16 17:32:32');
INSERT INTO `user_action_operation` VALUES (1063, 60, 'SCENIC_SPOT', 16, 4, 5242, '2026-01-16 17:32:37');
INSERT INTO `user_action_operation` VALUES (1064, 60, 'SCENIC_SPOT', 16, 4, 8839, '2026-01-16 17:32:41');
INSERT INTO `user_action_operation` VALUES (1065, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-16 17:32:41');
INSERT INTO `user_action_operation` VALUES (1066, 60, 'SCENIC_SPOT', 16, 4, 8500, '2026-01-16 17:32:50');
INSERT INTO `user_action_operation` VALUES (1067, 60, 'SCENIC_SPOT_STRATEGY', 13, 3, NULL, '2026-01-16 17:34:09');
INSERT INTO `user_action_operation` VALUES (1068, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-16 17:34:10');
INSERT INTO `user_action_operation` VALUES (1069, 60, 'SCENIC_SPOT', 16, 4, 69058, '2026-01-16 17:35:19');
INSERT INTO `user_action_operation` VALUES (1070, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-16 17:35:19');
INSERT INTO `user_action_operation` VALUES (1071, 60, 'SCENIC_SPOT', 16, 4, 51374, '2026-01-16 17:36:10');
INSERT INTO `user_action_operation` VALUES (1072, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-16 17:40:49');
INSERT INTO `user_action_operation` VALUES (1073, 60, 'SCENIC_SPOT', 16, 4, 5662, '2026-01-16 17:40:54');
INSERT INTO `user_action_operation` VALUES (1074, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-16 17:40:55');
INSERT INTO `user_action_operation` VALUES (1075, 60, 'SCENIC_SPOT', 16, 4, 9344, '2026-01-16 17:41:04');
INSERT INTO `user_action_operation` VALUES (1076, 60, 'SCENIC_SPOT', 16, 4, 25797, '2026-01-16 17:41:20');
INSERT INTO `user_action_operation` VALUES (1077, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-16 17:41:20');
INSERT INTO `user_action_operation` VALUES (1078, 60, 'SCENIC_SPOT', 16, 4, 6042, '2026-01-16 17:41:26');
INSERT INTO `user_action_operation` VALUES (1079, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-16 17:41:27');
INSERT INTO `user_action_operation` VALUES (1080, 60, 'SCENIC_SPOT', 16, 4, 5344, '2026-01-16 17:41:32');
INSERT INTO `user_action_operation` VALUES (1081, 60, 'SCENIC_SPOT', 16, 4, 81469, '2026-01-16 17:42:48');
INSERT INTO `user_action_operation` VALUES (1082, 60, 'SCENIC_SPOT', 16, 4, 94862, '2026-01-16 17:43:01');
INSERT INTO `user_action_operation` VALUES (1083, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-16 17:43:02');
INSERT INTO `user_action_operation` VALUES (1084, 60, 'SCENIC_SPOT', 16, 4, 11482, '2026-01-16 17:43:13');
INSERT INTO `user_action_operation` VALUES (1085, 60, 'SCENIC_SPOT', 16, 4, 20111, '2026-01-16 17:43:22');
INSERT INTO `user_action_operation` VALUES (1086, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-16 17:43:22');
INSERT INTO `user_action_operation` VALUES (1087, 60, 'SCENIC_SPOT', 16, 4, 25962, '2026-01-16 17:43:48');
INSERT INTO `user_action_operation` VALUES (1088, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-16 17:43:48');
INSERT INTO `user_action_operation` VALUES (1089, 60, 'SCENIC_SPOT', 16, 4, 32377, '2026-01-16 17:44:20');
INSERT INTO `user_action_operation` VALUES (1090, 60, 'SCENIC_SPOT', 16, 4, 41643, '2026-01-16 17:44:29');
INSERT INTO `user_action_operation` VALUES (1091, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-16 17:44:29');
INSERT INTO `user_action_operation` VALUES (1092, 60, 'SCENIC_SPOT', 16, 4, 5427, '2026-01-16 17:44:35');
INSERT INTO `user_action_operation` VALUES (1093, 60, 'SCENIC_SPOT', 16, 4, 17941, '2026-01-16 17:44:47');
INSERT INTO `user_action_operation` VALUES (1094, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 688197, '2026-01-16 17:45:37');
INSERT INTO `user_action_operation` VALUES (1095, 60, 'SCENIC_SPOT_STRATEGY', 13, 3, NULL, '2026-01-16 17:45:37');
INSERT INTO `user_action_operation` VALUES (1096, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 1764, '2026-01-16 17:45:39');
INSERT INTO `user_action_operation` VALUES (1097, 60, 'SCENIC_SPOT_STRATEGY', 13, 3, NULL, '2026-01-16 17:45:39');
INSERT INTO `user_action_operation` VALUES (1098, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 14454, '2026-01-16 17:45:53');
INSERT INTO `user_action_operation` VALUES (1099, 60, 'SCENIC_SPOT_STRATEGY', 13, 3, NULL, '2026-01-16 17:45:53');
INSERT INTO `user_action_operation` VALUES (1100, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 14597, '2026-01-16 17:46:08');
INSERT INTO `user_action_operation` VALUES (1101, 60, 'SCENIC_SPOT_STRATEGY', 13, 3, NULL, '2026-01-16 17:46:08');
INSERT INTO `user_action_operation` VALUES (1102, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 9305, '2026-01-16 17:46:17');
INSERT INTO `user_action_operation` VALUES (1103, 60, 'SCENIC_SPOT_STRATEGY', 13, 3, NULL, '2026-01-16 17:46:17');
INSERT INTO `user_action_operation` VALUES (1104, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 20641, '2026-01-16 17:46:38');
INSERT INTO `user_action_operation` VALUES (1105, 60, 'SCENIC_SPOT_STRATEGY', 13, 3, NULL, '2026-01-16 17:46:38');
INSERT INTO `user_action_operation` VALUES (1106, 60, 'SCENIC_SPOT', 16, 4, 131614, '2026-01-16 17:46:41');
INSERT INTO `user_action_operation` VALUES (1107, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-16 17:46:41');
INSERT INTO `user_action_operation` VALUES (1108, 60, 'SCENIC_SPOT', 16, 4, 4358, '2026-01-16 17:46:45');
INSERT INTO `user_action_operation` VALUES (1109, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 10276, '2026-01-16 17:46:48');
INSERT INTO `user_action_operation` VALUES (1110, 60, 'SCENIC_SPOT_STRATEGY', 13, 3, NULL, '2026-01-16 17:46:48');
INSERT INTO `user_action_operation` VALUES (1111, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 3558, '2026-01-16 17:46:52');
INSERT INTO `user_action_operation` VALUES (1112, 60, 'SCENIC_SPOT_STRATEGY', 13, 3, NULL, '2026-01-16 17:46:52');
INSERT INTO `user_action_operation` VALUES (1113, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 3827, '2026-01-16 17:46:56');
INSERT INTO `user_action_operation` VALUES (1114, 60, 'SCENIC_SPOT_STRATEGY', 13, 4, 6907, '2026-01-16 17:46:59');
INSERT INTO `user_action_operation` VALUES (1115, 60, 'SCENIC_SPOT_STRATEGY', 3, 3, NULL, '2026-01-16 17:47:02');
INSERT INTO `user_action_operation` VALUES (1116, 60, 'SCENIC_SPOT_STRATEGY', 3, 4, 13381, '2026-01-16 17:47:15');
INSERT INTO `user_action_operation` VALUES (1117, 60, 'SCENIC_SPOT_STRATEGY', 3, 4, 38493, '2026-01-16 17:47:40');
INSERT INTO `user_action_operation` VALUES (1118, 60, 'SCENIC_SPOT_STRATEGY', 3, 3, NULL, '2026-01-16 17:47:41');
INSERT INTO `user_action_operation` VALUES (1119, 60, 'SCENIC_SPOT_STRATEGY', 3, 4, 5792, '2026-01-16 17:47:46');
INSERT INTO `user_action_operation` VALUES (1120, 60, 'SCENIC_SPOT_STRATEGY', 3, 3, NULL, '2026-01-16 17:47:46');
INSERT INTO `user_action_operation` VALUES (1121, 60, 'SCENIC_SPOT_STRATEGY', 3, 4, 3372, '2026-01-16 17:47:50');
INSERT INTO `user_action_operation` VALUES (1122, 60, 'SCENIC_SPOT_STRATEGY', 3, 4, 17128, '2026-01-16 17:48:04');
INSERT INTO `user_action_operation` VALUES (1123, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-16 17:48:10');
INSERT INTO `user_action_operation` VALUES (1124, 60, 'SCENIC_SPOT', 20, 4, 4509, '2026-01-16 17:48:15');
INSERT INTO `user_action_operation` VALUES (1125, 60, 'SCENIC_SPOT_STRATEGY', 4, 3, NULL, '2026-01-16 17:48:19');
INSERT INTO `user_action_operation` VALUES (1126, 60, 'SCENIC_SPOT_STRATEGY', 4, 4, 8930, '2026-01-16 17:48:27');
INSERT INTO `user_action_operation` VALUES (1127, 60, 'SCENIC_SPOT_STRATEGY', 4, 3, NULL, '2026-01-16 17:48:28');
INSERT INTO `user_action_operation` VALUES (1128, 60, 'SCENIC_SPOT_STRATEGY', 4, 4, 5706, '2026-01-16 17:48:33');
INSERT INTO `user_action_operation` VALUES (1129, 60, 'SCENIC_SPOT_STRATEGY', 4, 4, 23678, '2026-01-16 17:48:51');
INSERT INTO `user_action_operation` VALUES (1130, 60, 'SCENIC_SPOT_STRATEGY', 4, 3, NULL, '2026-01-16 17:48:51');
INSERT INTO `user_action_operation` VALUES (1131, 60, 'SCENIC_SPOT_STRATEGY', 4, 4, 6039, '2026-01-16 17:48:57');
INSERT INTO `user_action_operation` VALUES (1132, 60, 'SCENIC_SPOT_STRATEGY', 4, 3, NULL, '2026-01-16 17:48:57');
INSERT INTO `user_action_operation` VALUES (1133, 60, 'SCENIC_SPOT_STRATEGY', 4, 4, 4551, '2026-01-16 17:49:02');
INSERT INTO `user_action_operation` VALUES (1134, 60, 'SCENIC_SPOT_STRATEGY', 4, 4, 16481, '2026-01-16 17:49:14');
INSERT INTO `user_action_operation` VALUES (1135, 60, 'SCENIC_SPOT_STRATEGY', 4, 3, NULL, '2026-01-16 17:49:14');
INSERT INTO `user_action_operation` VALUES (1136, 60, 'SCENIC_SPOT_STRATEGY', 4, 4, 2340, '2026-01-16 17:49:16');
INSERT INTO `user_action_operation` VALUES (1137, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-16 17:49:19');
INSERT INTO `user_action_operation` VALUES (1138, 60, 'SCENIC_SPOT', 20, 4, 2781, '2026-01-16 17:49:22');
INSERT INTO `user_action_operation` VALUES (1139, 60, 'SCENIC_SPOT_STRATEGY', 4, 4, 12236, '2026-01-16 17:49:26');
INSERT INTO `user_action_operation` VALUES (1140, 60, 'SCENIC_SPOT_STRATEGY', 4, 4, 36417, '2026-01-16 17:49:50');
INSERT INTO `user_action_operation` VALUES (1141, 60, 'SCENIC_SPOT_STRATEGY', 4, 3, NULL, '2026-01-16 17:49:50');
INSERT INTO `user_action_operation` VALUES (1142, 60, 'SCENIC_SPOT_STRATEGY', 4, 4, 22257, '2026-01-16 17:50:13');
INSERT INTO `user_action_operation` VALUES (1143, 60, 'SCENIC_SPOT_STRATEGY', 4, 4, 344320, '2026-01-16 17:55:35');
INSERT INTO `user_action_operation` VALUES (1144, 60, 'SCENIC_SPOT_STRATEGY', 4, 4, 79256226, '2026-01-17 15:50:47');
INSERT INTO `user_action_operation` VALUES (1145, 60, 'SCENIC_SPOT', 20, 4, 79302513, '2026-01-17 15:51:02');
INSERT INTO `user_action_operation` VALUES (1146, 60, 'SCENIC_SPOT', 20, 4, 79343556, '2026-01-17 15:51:43');
INSERT INTO `user_action_operation` VALUES (1147, 60, 'SCENIC_SPOT', 20, 4, 79393434, '2026-01-17 15:52:33');
INSERT INTO `user_action_operation` VALUES (1148, 60, 'SCENIC_SPOT', 20, 4, 79423950, '2026-01-17 15:53:03');
INSERT INTO `user_action_operation` VALUES (1149, 60, 'SCENIC_SPOT', 20, 4, 79436391, '2026-01-17 15:53:16');
INSERT INTO `user_action_operation` VALUES (1150, 60, 'SCENIC_SPOT', 20, 4, 79461145, '2026-01-17 15:53:40');
INSERT INTO `user_action_operation` VALUES (1151, 60, 'SCENIC_SPOT', 20, 4, 79476262, '2026-01-17 15:53:55');
INSERT INTO `user_action_operation` VALUES (1152, 60, 'SCENIC_SPOT', 20, 4, 79482358, '2026-01-17 15:54:01');
INSERT INTO `user_action_operation` VALUES (1153, 60, 'SCENIC_SPOT', 20, 4, 79499153, '2026-01-17 15:54:18');
INSERT INTO `user_action_operation` VALUES (1154, 60, 'SCENIC_SPOT_STRATEGY', 4, 4, 79491648, '2026-01-17 15:54:42');
INSERT INTO `user_action_operation` VALUES (1155, 60, 'SCENIC_SPOT', 20, 4, 79527000, '2026-01-17 15:54:46');
INSERT INTO `user_action_operation` VALUES (1156, 60, 'SCENIC_SPOT', 20, 4, 79555354, '2026-01-17 15:55:14');
INSERT INTO `user_action_operation` VALUES (1157, 60, 'SCENIC_SPOT', 20, 4, 79585216, '2026-01-17 15:55:44');
INSERT INTO `user_action_operation` VALUES (1158, 60, 'SCENIC_SPOT', 20, 4, 79626546, '2026-01-17 15:56:26');
INSERT INTO `user_action_operation` VALUES (1159, 60, 'SCENIC_SPOT', 20, 4, 79640879, '2026-01-17 15:56:40');
INSERT INTO `user_action_operation` VALUES (1160, 60, 'SCENIC_SPOT', 20, 4, 79665416, '2026-01-17 15:57:05');
INSERT INTO `user_action_operation` VALUES (1161, 60, 'SCENIC_SPOT', 20, 4, 79688816, '2026-01-17 15:57:28');
INSERT INTO `user_action_operation` VALUES (1162, 60, 'SCENIC_SPOT', 20, 4, 79714726, '2026-01-17 15:57:54');
INSERT INTO `user_action_operation` VALUES (1163, 60, 'SCENIC_SPOT', 20, 4, 79723040, '2026-01-17 15:58:02');
INSERT INTO `user_action_operation` VALUES (1164, 60, 'SCENIC_SPOT', 20, 4, 79731778, '2026-01-17 15:58:11');
INSERT INTO `user_action_operation` VALUES (1165, 60, 'SCENIC_SPOT', 20, 4, 79783107, '2026-01-17 15:59:02');
INSERT INTO `user_action_operation` VALUES (1166, 60, 'SCENIC_SPOT', 20, 4, 79794540, '2026-01-17 15:59:14');
INSERT INTO `user_action_operation` VALUES (1167, 60, 'SCENIC_SPOT', 20, 4, 79816679, '2026-01-17 15:59:36');
INSERT INTO `user_action_operation` VALUES (1168, 60, 'SCENIC_SPOT', 20, 4, 79829770, '2026-01-17 15:59:49');
INSERT INTO `user_action_operation` VALUES (1169, 60, 'SCENIC_SPOT', 20, 4, 79846458, '2026-01-17 16:00:06');
INSERT INTO `user_action_operation` VALUES (1170, 60, 'SCENIC_SPOT', 20, 4, 79868148, '2026-01-17 16:00:27');
INSERT INTO `user_action_operation` VALUES (1171, 60, 'SCENIC_SPOT', 20, 4, 79884891, '2026-01-17 16:00:44');
INSERT INTO `user_action_operation` VALUES (1172, 60, 'SCENIC_SPOT', 20, 4, 79979335, '2026-01-17 16:02:18');
INSERT INTO `user_action_operation` VALUES (1173, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-17 21:47:56');
INSERT INTO `user_action_operation` VALUES (1174, 60, 'SCENIC_SPOT', 20, 4, 17930, '2026-01-17 21:48:14');
INSERT INTO `user_action_operation` VALUES (1175, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-17 21:48:19');
INSERT INTO `user_action_operation` VALUES (1176, 60, 'SCENIC_SPOT', 16, 4, 11605, '2026-01-17 21:48:31');
INSERT INTO `user_action_operation` VALUES (1177, 59, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-17 21:48:45');
INSERT INTO `user_action_operation` VALUES (1178, 59, 'SCENIC_SPOT', 20, 4, 18770, '2026-01-17 21:49:03');
INSERT INTO `user_action_operation` VALUES (1179, 60, 'SCENIC_SPOT_STRATEGY', 1, 3, NULL, '2026-01-18 16:02:17');
INSERT INTO `user_action_operation` VALUES (1180, 60, 'SCENIC_SPOT_STRATEGY', 1, 4, 2892, '2026-01-18 16:02:20');
INSERT INTO `user_action_operation` VALUES (1181, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-18 17:19:15');
INSERT INTO `user_action_operation` VALUES (1182, 60, 'SCENIC_SPOT', 16, 4, 8926, '2026-01-18 17:19:24');
INSERT INTO `user_action_operation` VALUES (1183, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-18 17:19:24');
INSERT INTO `user_action_operation` VALUES (1184, 60, 'SCENIC_SPOT', 16, 4, 50080, '2026-01-18 17:20:14');
INSERT INTO `user_action_operation` VALUES (1185, 60, 'SCENIC_SPOT', 16, 4, 292413, '2026-01-18 17:24:17');
INSERT INTO `user_action_operation` VALUES (1186, 60, 'SCENIC_SPOT', 16, 3, NULL, '2026-01-18 17:42:58');
INSERT INTO `user_action_operation` VALUES (1187, 60, 'SCENIC_SPOT', 16, 4, 567, '2026-01-18 17:42:59');
INSERT INTO `user_action_operation` VALUES (1188, 60, 'SCENIC_SPOT', 19, 3, NULL, '2026-01-18 20:10:51');
INSERT INTO `user_action_operation` VALUES (1189, 60, 'SCENIC_SPOT', 19, 4, 4873, '2026-01-18 20:10:56');
INSERT INTO `user_action_operation` VALUES (1190, 60, 'SCENIC_SPOT', 19, 4, 409826, '2026-01-18 20:17:41');
INSERT INTO `user_action_operation` VALUES (1191, 60, 'SCENIC_SPOT', 19, 4, 413530, '2026-01-18 20:17:45');
INSERT INTO `user_action_operation` VALUES (1192, 60, 'SCENIC_SPOT', 19, 4, 701408, '2026-01-18 20:22:33');
INSERT INTO `user_action_operation` VALUES (1193, 60, 'SCENIC_SPOT', 19, 3, NULL, '2026-01-18 20:22:33');
INSERT INTO `user_action_operation` VALUES (1194, 60, 'SCENIC_SPOT', 19, 4, 8386, '2026-01-18 20:22:41');
INSERT INTO `user_action_operation` VALUES (1195, 60, 'SCENIC_SPOT', 19, 3, NULL, '2026-01-18 20:22:41');
INSERT INTO `user_action_operation` VALUES (1196, 60, 'SCENIC_SPOT', 19, 4, 24609, '2026-01-18 20:23:05');
INSERT INTO `user_action_operation` VALUES (1197, 60, 'SCENIC_SPOT', 19, 3, NULL, '2026-01-18 20:23:06');
INSERT INTO `user_action_operation` VALUES (1198, 60, 'SCENIC_SPOT', 19, 4, 44228, '2026-01-18 20:23:50');
INSERT INTO `user_action_operation` VALUES (1199, 60, 'SCENIC_SPOT', 19, 3, NULL, '2026-01-18 20:23:50');
INSERT INTO `user_action_operation` VALUES (1200, 60, 'SCENIC_SPOT', 19, 4, 10044, '2026-01-18 20:24:00');
INSERT INTO `user_action_operation` VALUES (1201, 60, 'SCENIC_SPOT', 19, 3, NULL, '2026-01-18 20:24:00');
INSERT INTO `user_action_operation` VALUES (1202, 60, 'SCENIC_SPOT', 19, 4, 7101, '2026-01-18 20:24:07');
INSERT INTO `user_action_operation` VALUES (1203, 60, 'SCENIC_SPOT', 19, 3, NULL, '2026-01-18 20:24:07');
INSERT INTO `user_action_operation` VALUES (1204, 60, 'SCENIC_SPOT', 19, 4, 12236, '2026-01-18 20:24:19');
INSERT INTO `user_action_operation` VALUES (1205, 60, 'SCENIC_SPOT', 19, 3, NULL, '2026-01-18 20:24:19');
INSERT INTO `user_action_operation` VALUES (1206, 60, 'SCENIC_SPOT', 19, 4, 3758, '2026-01-18 20:24:23');
INSERT INTO `user_action_operation` VALUES (1207, 60, 'SCENIC_SPOT', 19, 3, NULL, '2026-01-18 20:24:23');
INSERT INTO `user_action_operation` VALUES (1208, 60, 'SCENIC_SPOT', 19, 4, 42525, '2026-01-18 20:25:05');
INSERT INTO `user_action_operation` VALUES (1209, 60, 'SCENIC_SPOT', 19, 4, 82081, '2026-01-18 20:25:45');
INSERT INTO `user_action_operation` VALUES (1210, 60, 'SCENIC_SPOT', 19, 4, 97170, '2026-01-18 20:26:00');
INSERT INTO `user_action_operation` VALUES (1211, 60, 'SCENIC_SPOT', 19, 4, 116189, '2026-01-18 20:26:19');
INSERT INTO `user_action_operation` VALUES (1212, 60, 'SCENIC_SPOT', 19, 4, 135406, '2026-01-18 20:26:38');
INSERT INTO `user_action_operation` VALUES (1213, 60, 'SCENIC_SPOT', 19, 4, 170678, '2026-01-18 20:27:13');
INSERT INTO `user_action_operation` VALUES (1214, 60, 'SCENIC_SPOT', 19, 4, 184418, '2026-01-18 20:27:27');
INSERT INTO `user_action_operation` VALUES (1215, 60, 'SCENIC_SPOT', 19, 4, 193339, '2026-01-18 20:27:36');
INSERT INTO `user_action_operation` VALUES (1216, 60, 'SCENIC_SPOT', 19, 4, 250093, '2026-01-18 20:28:33');
INSERT INTO `user_action_operation` VALUES (1217, 60, 'SCENIC_SPOT', 19, 3, NULL, '2026-01-18 20:28:33');
INSERT INTO `user_action_operation` VALUES (1218, 60, 'SCENIC_SPOT', 19, 4, 1408, '2026-01-18 20:28:34');
INSERT INTO `user_action_operation` VALUES (1219, 60, 'SCENIC_SPOT', 19, 4, 18791, '2026-01-18 20:28:52');
INSERT INTO `user_action_operation` VALUES (1220, 60, 'SCENIC_SPOT', 19, 4, 27088, '2026-01-18 20:29:00');
INSERT INTO `user_action_operation` VALUES (1221, 60, 'SCENIC_SPOT', 19, 4, 49819, '2026-01-18 20:29:23');
INSERT INTO `user_action_operation` VALUES (1222, 60, 'SCENIC_SPOT', 19, 3, NULL, '2026-01-18 20:29:23');
INSERT INTO `user_action_operation` VALUES (1223, 60, 'SCENIC_SPOT', 19, 4, 1261, '2026-01-18 20:29:24');
INSERT INTO `user_action_operation` VALUES (1224, 60, 'SCENIC_SPOT', 19, 4, 29674, '2026-01-18 20:29:53');
INSERT INTO `user_action_operation` VALUES (1225, 60, 'SCENIC_SPOT', 19, 3, NULL, '2026-01-18 20:29:53');
INSERT INTO `user_action_operation` VALUES (1226, 60, 'SCENIC_SPOT', 19, 4, 5862, '2026-01-18 20:29:59');
INSERT INTO `user_action_operation` VALUES (1227, 60, 'SCENIC_SPOT', 19, 3, NULL, '2026-01-18 20:29:59');
INSERT INTO `user_action_operation` VALUES (1228, 60, 'SCENIC_SPOT', 19, 4, 24932, '2026-01-18 20:30:24');
INSERT INTO `user_action_operation` VALUES (1229, 60, 'SCENIC_SPOT', 19, 4, 32587, '2026-01-18 20:30:31');
INSERT INTO `user_action_operation` VALUES (1230, 60, 'SCENIC_SPOT', 19, 4, 64223, '2026-01-18 20:31:03');
INSERT INTO `user_action_operation` VALUES (1231, 60, 'SCENIC_SPOT', 19, 3, NULL, '2026-01-18 20:31:03');
INSERT INTO `user_action_operation` VALUES (1232, 60, 'SCENIC_SPOT', 19, 4, 3197, '2026-01-18 20:31:06');
INSERT INTO `user_action_operation` VALUES (1233, 60, 'SCENIC_SPOT', 19, 4, 18364, '2026-01-18 20:31:21');
INSERT INTO `user_action_operation` VALUES (1234, 60, 'SCENIC_SPOT', 19, 3, NULL, '2026-01-18 20:31:21');
INSERT INTO `user_action_operation` VALUES (1235, 60, 'SCENIC_SPOT', 19, 4, 6477, '2026-01-18 20:31:28');
INSERT INTO `user_action_operation` VALUES (1236, 60, 'SCENIC_SPOT', 19, 4, 141914, '2026-01-18 20:33:43');
INSERT INTO `user_action_operation` VALUES (1237, 60, 'SCENIC_SPOT', 19, 3, NULL, '2026-01-18 21:05:14');
INSERT INTO `user_action_operation` VALUES (1238, 60, 'SCENIC_SPOT', 19, 4, 8395, '2026-01-18 21:05:22');
INSERT INTO `user_action_operation` VALUES (1239, 60, 'SCENIC_SPOT', 19, 4, 21910, '2026-01-18 21:05:35');
INSERT INTO `user_action_operation` VALUES (1240, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-18 21:05:59');
INSERT INTO `user_action_operation` VALUES (1241, 60, 'SCENIC_SPOT', 20, 4, 6070, '2026-01-18 21:06:05');
INSERT INTO `user_action_operation` VALUES (1242, 60, 'SCENIC_SPOT', 19, 4, 52100, '2026-01-18 21:06:06');
INSERT INTO `user_action_operation` VALUES (1243, 60, 'SCENIC_SPOT', 20, 4, 7457, '2026-01-18 21:06:06');
INSERT INTO `user_action_operation` VALUES (1244, 60, 'SCENIC_SPOT', 19, 4, 78371, '2026-01-18 21:06:32');
INSERT INTO `user_action_operation` VALUES (1245, 60, 'SCENIC_SPOT', 19, 4, 92681, '2026-01-18 21:06:46');
INSERT INTO `user_action_operation` VALUES (1246, 60, 'SCENIC_SPOT', 19, 4, 115215, '2026-01-18 21:07:09');
INSERT INTO `user_action_operation` VALUES (1247, 60, 'SCENIC_SPOT', 19, 4, 131357, '2026-01-18 21:07:25');
INSERT INTO `user_action_operation` VALUES (1248, 60, 'SCENIC_SPOT_STRATEGY', 3, 3, NULL, '2026-01-18 21:07:25');
INSERT INTO `user_action_operation` VALUES (1249, 60, 'SCENIC_SPOT_STRATEGY', 3, 4, 3237, '2026-01-18 21:07:29');
INSERT INTO `user_action_operation` VALUES (1250, 60, 'SCENIC_SPOT', 19, 4, 137221, '2026-01-18 21:07:31');
INSERT INTO `user_action_operation` VALUES (1251, 60, 'SCENIC_SPOT_STRATEGY', 4, 3, NULL, '2026-01-18 21:07:31');
INSERT INTO `user_action_operation` VALUES (1252, 60, 'SCENIC_SPOT_STRATEGY', 4, 4, 4241, '2026-01-18 21:07:35');
INSERT INTO `user_action_operation` VALUES (1253, 60, 'SCENIC_SPOT_STRATEGY', 4, 4, 19071, '2026-01-18 21:07:50');
INSERT INTO `user_action_operation` VALUES (1254, 60, 'SCENIC_SPOT_STRATEGY', 4, 4, 40170, '2026-01-18 21:08:11');
INSERT INTO `user_action_operation` VALUES (1255, 60, 'SCENIC_SPOT', 19, 4, 181958, '2026-01-18 21:08:16');
INSERT INTO `user_action_operation` VALUES (1256, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-18 21:08:18');
INSERT INTO `user_action_operation` VALUES (1257, 60, 'SCENIC_SPOT', 20, 4, 7731, '2026-01-18 21:08:26');
INSERT INTO `user_action_operation` VALUES (1258, 60, 'SCENIC_SPOT', 20, 4, 19159, '2026-01-18 21:08:37');
INSERT INTO `user_action_operation` VALUES (1259, 60, 'SCENIC_SPOT', 20, 4, 166682, '2026-01-18 21:08:46');
INSERT INTO `user_action_operation` VALUES (1260, 60, 'SCENIC_SPOT', 20, 4, 49379, '2026-01-18 21:09:08');
INSERT INTO `user_action_operation` VALUES (1261, 60, 'SCENIC_SPOT', 20, 4, 92398, '2026-01-18 21:09:51');
INSERT INTO `user_action_operation` VALUES (1262, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-18 22:27:01');
INSERT INTO `user_action_operation` VALUES (1263, 60, 'SCENIC_SPOT', 20, 4, 25821, '2026-01-18 22:27:27');
INSERT INTO `user_action_operation` VALUES (1264, 60, 'SCENIC_SPOT', 20, 4, 71623, '2026-01-18 22:28:12');
INSERT INTO `user_action_operation` VALUES (1265, 60, 'SCENIC_SPOT', 20, 4, 72081, '2026-01-18 22:28:13');
INSERT INTO `user_action_operation` VALUES (1266, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-18 22:31:26');
INSERT INTO `user_action_operation` VALUES (1267, 60, 'SCENIC_SPOT', 20, 4, 16728, '2026-01-18 22:31:43');
INSERT INTO `user_action_operation` VALUES (1268, 60, 'SCENIC_SPOT', 20, 4, 16794, '2026-01-18 22:31:43');
INSERT INTO `user_action_operation` VALUES (1269, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-18 22:34:18');
INSERT INTO `user_action_operation` VALUES (1270, 60, 'SCENIC_SPOT', 20, 4, 102746, '2026-01-18 22:36:01');
INSERT INTO `user_action_operation` VALUES (1271, 60, 'SCENIC_SPOT', 20, 4, 124346, '2026-01-18 22:36:22');
INSERT INTO `user_action_operation` VALUES (1272, 60, 'SCENIC_SPOT', 19, 3, NULL, '2026-01-18 22:36:29');
INSERT INTO `user_action_operation` VALUES (1273, 60, 'SCENIC_SPOT', 19, 4, 14445, '2026-01-18 22:36:43');
INSERT INTO `user_action_operation` VALUES (1274, 60, 'SCENIC_SPOT_STRATEGY', 4, 3, NULL, '2026-01-18 22:36:44');
INSERT INTO `user_action_operation` VALUES (1275, 60, 'SCENIC_SPOT_STRATEGY', 4, 1, NULL, '2026-01-18 22:36:46');
INSERT INTO `user_action_operation` VALUES (1276, 60, 'SCENIC_SPOT_STRATEGY', 4, 2, NULL, '2026-01-18 22:36:47');
INSERT INTO `user_action_operation` VALUES (1277, 60, 'SCENIC_SPOT_STRATEGY', 4, 4, 14133, '2026-01-18 22:36:58');
INSERT INTO `user_action_operation` VALUES (1278, 60, 'SCENIC_SPOT', 19, 4, 36339, '2026-01-18 22:37:05');
INSERT INTO `user_action_operation` VALUES (1279, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-18 22:37:07');
INSERT INTO `user_action_operation` VALUES (1280, 60, 'SCENIC_SPOT', 20, 4, 3699, '2026-01-18 22:37:11');
INSERT INTO `user_action_operation` VALUES (1281, 60, 'SCENIC_SPOT', 20, 4, 26289, '2026-01-18 22:37:33');
INSERT INTO `user_action_operation` VALUES (1282, 60, 'SCENIC_SPOT', 20, 4, 52229, '2026-01-18 22:37:59');
INSERT INTO `user_action_operation` VALUES (1283, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-18 22:38:54');
INSERT INTO `user_action_operation` VALUES (1284, 60, 'SCENIC_SPOT', 20, 4, 2733, '2026-01-18 22:38:57');
INSERT INTO `user_action_operation` VALUES (1285, 60, 'SCENIC_SPOT_STRATEGY', 14, 3, NULL, '2026-01-18 22:41:02');
INSERT INTO `user_action_operation` VALUES (1286, 60, 'SCENIC_SPOT_STRATEGY', 14, 4, 3183, '2026-01-18 22:41:05');
INSERT INTO `user_action_operation` VALUES (1287, 60, 'SCENIC_SPOT_STRATEGY', 4, 3, NULL, '2026-01-18 22:41:36');
INSERT INTO `user_action_operation` VALUES (1288, 60, 'SCENIC_SPOT_STRATEGY', 4, 4, 9667, '2026-01-18 22:41:46');
INSERT INTO `user_action_operation` VALUES (1289, 60, 'SCENIC_SPOT_STRATEGY', 4, 3, NULL, '2026-01-18 22:42:04');
INSERT INTO `user_action_operation` VALUES (1290, 60, 'SCENIC_SPOT_STRATEGY', 4, 4, 15592, '2026-01-18 22:42:19');
INSERT INTO `user_action_operation` VALUES (1291, 60, 'SCENIC_SPOT', 9, 3, NULL, '2026-01-18 22:42:41');
INSERT INTO `user_action_operation` VALUES (1292, 60, 'SCENIC_SPOT', 9, 4, 2996, '2026-01-18 22:42:44');
INSERT INTO `user_action_operation` VALUES (1293, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-18 22:46:45');
INSERT INTO `user_action_operation` VALUES (1294, 60, 'SCENIC_SPOT', 20, 4, 17350, '2026-01-18 22:47:02');
INSERT INTO `user_action_operation` VALUES (1295, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-19 13:51:36');
INSERT INTO `user_action_operation` VALUES (1296, 60, 'SCENIC_SPOT', 20, 4, 7770, '2026-01-19 13:51:43');
INSERT INTO `user_action_operation` VALUES (1297, 60, 'SCENIC_SPOT', 20, 4, 73103, '2026-01-19 13:52:49');
INSERT INTO `user_action_operation` VALUES (1298, 60, 'SCENIC_SPOT', 20, 4, 95604, '2026-01-19 13:53:11');
INSERT INTO `user_action_operation` VALUES (1299, 60, 'SCENIC_SPOT', 20, 4, 811161, '2026-01-19 14:05:07');
INSERT INTO `user_action_operation` VALUES (1300, 60, 'SCENIC_SPOT', 20, 4, 813107, '2026-01-19 14:05:09');
INSERT INTO `user_action_operation` VALUES (1301, 60, 'SCENIC_SPOT', 20, 4, 817276, '2026-01-19 14:05:13');
INSERT INTO `user_action_operation` VALUES (1302, 60, 'SCENIC_SPOT', 20, 3, NULL, '2026-01-19 14:24:27');
INSERT INTO `user_action_operation` VALUES (1303, 60, 'SCENIC_SPOT', 20, 4, 3743, '2026-01-19 14:24:31');
INSERT INTO `user_action_operation` VALUES (1304, 60, 'SCENIC_SPOT', 20, 4, 15977, '2026-01-19 14:24:43');
INSERT INTO `user_action_operation` VALUES (1305, 60, 'SCENIC_SPOT', 20, 4, 26244, '2026-01-19 14:24:53');
INSERT INTO `user_action_operation` VALUES (1306, 60, 'SCENIC_SPOT_STRATEGY', 3, 3, NULL, '2026-01-19 14:24:58');
INSERT INTO `user_action_operation` VALUES (1307, 60, 'SCENIC_SPOT_STRATEGY', 3, 4, 2828, '2026-01-19 14:25:00');
INSERT INTO `user_action_operation` VALUES (1308, 60, 'SCENIC_SPOT_STRATEGY', 3, 4, 14704, '2026-01-19 14:25:12');
INSERT INTO `user_action_operation` VALUES (1309, 60, 'SCENIC_SPOT_STRATEGY', 3, 4, 19335, '2026-01-19 14:25:17');
INSERT INTO `user_action_operation` VALUES (1310, 60, 'SCENIC_SPOT_STRATEGY', 3, 4, 35546, '2026-01-19 14:25:33');
INSERT INTO `user_action_operation` VALUES (1311, 60, 'SCENIC_SPOT_STRATEGY', 3, 4, 254646, '2026-01-19 14:29:12');

SET FOREIGN_KEY_CHECKS = 1;
