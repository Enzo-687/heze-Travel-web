CREATE TABLE IF NOT EXISTS `food` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '美食ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '美食名称',
  `cover_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '封面图URL',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '简短介绍',
  `tag` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '特色标签',
  `detail` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL COMMENT '详细介绍(HTML)',
  `longitude` double NULL DEFAULT NULL COMMENT '经度',
  `latitude` double NULL DEFAULT NULL COMMENT '纬度',
  `address` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '地址',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '美食信息表' ROW_FORMAT = Dynamic;

INSERT INTO `food` (`name`, `cover_url`, `description`, `tag`, `detail`, `longitude`, `latitude`, `address`, `create_time`) VALUES
('单县羊肉汤', '/file/food-yangrou.jpg', '中华第一汤，色白似奶、鲜而不膻', '招牌必点', '<p>单县羊肉汤，选用当地优质青山羊，经数小时慢火熬制，汤色乳白、鲜香浓郁。已有200多年历史，被载入中华名食谱，是菏泽最具代表性的美食名片。</p>', 116.087, 34.795, '菏泽市单县舜师路', NOW()),
('曹州烧饼', '/file/food-shaobing.jpg', '外酥里嫩、层次分明，曹州传统名吃', '本地特色', '<p>曹州烧饼是菏泽传统面食，以精面粉为主料，经多道工序精心制作。外层金黄酥脆，内里柔软多层，配以芝麻增香，是菏泽人早餐的首选。</p>', 115.469, 35.256, '菏泽市牡丹区中华路', NOW()),
('菏泽牡丹宴', '/file/food-mudan.jpg', '以牡丹入馔，国色天香的味觉盛宴', '招牌必点', '<p>牡丹宴是菏泽独创的主题宴席，将牡丹花瓣、牡丹籽油等融入菜品，打造出牡丹醉鸡、花瓣沙拉、牡丹羹等特色菜肴，色香味俱全，堪称舌尖上的牡丹文化。</p>', 115.480, 35.260, '菏泽市牡丹区曹州牡丹园附近', NOW()),
('郓城壮馍', '/file/food-zhuangmo.jpg', '皮薄馅多、外焦里嫩，鲁西南硬核面食', '人气爆款', '<p>壮馍是郓城传统名吃，直径可达尺余，厚约寸许。以精面粉为皮，猪肉、粉条、大葱等为馅，在鏊子上煎至两面金黄，外皮焦脆、内馅鲜美，一个就能吃饱。</p>', 115.944, 35.600, '菏泽市郓城县唐塔路', NOW()),
('曹县烧牛肉', '/file/food-niurou.jpg', '色红味美、肉烂筋酥，百年卤制工艺', '本地特色', '<p>曹县烧牛肉选用鲁西黄牛，配以二十余种香料，经腌制、煮制、烧制等多道工序精制而成。色泽红润、肉质酥烂、香气四溢，是鲁西南地区最具特色的牛肉制品。</p>', 115.832, 34.742, '菏泽市曹县青菏路', NOW()),
('菏泽水煎包', '/file/food-shuijian.jpg', '底脆面软、馅鲜汁多，早餐之王', '人气爆款', '<p>菏泽水煎包以发酵面团包裹猪肉韭菜馅，在平底锅中加水煎制，形成底部金黄酥脆、上部松软的口感。一口咬下，鲜汁四溢，是菏泽街头巷尾最常见的美味。</p>', 115.469, 35.256, '菏泽市牡丹区人民路', NOW()),
('东明粉肚', '/file/food-fendu.jpg', '柔韧爽滑、鲜香可口，传统卤味珍品', '本地特色', '<p>东明粉肚是菏泽东明县的传统名吃，以猪肉、淀粉为主要原料，配以多种调料灌制而成。切片后色泽红亮、口感柔韧，是下酒佐餐的佳品。</p>', 115.090, 35.290, '菏泽市东明县五四路', NOW()),
('巨野罐子汤', '/file/food-guanzi.jpg', '汤浓味醇、料足味美，鲁西南暖胃汤', '招牌必点', '<p>巨野罐子汤源于清朝末年，以猪骨、老母鸡熬制高汤，加入肉片、丸子、豆腐、粉条等丰富配料，在陶罐中慢炖而成。汤色浓白、味道醇厚，一碗下肚暖胃又暖心。</p>', 115.939, 35.386, '菏泽市巨野县文昌路', NOW());
