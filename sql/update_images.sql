-- ============================================================
-- 更新图片URL - 将占位符路径替换为真实文件路径
-- ============================================================

SET NAMES utf8mb4;

-- 美食图片更新
UPDATE `food` SET `cover_url` = 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=food-yangrou.jpg' WHERE `name` = '单县羊肉汤';
UPDATE `food` SET `cover_url` = 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=food-shaobing.jpg' WHERE `name` = '曹州烧饼';
UPDATE `food` SET `cover_url` = 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=food-mudan.jpg' WHERE `name` = '菏泽牡丹宴';
UPDATE `food` SET `cover_url` = 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=food-zhuangmo.jpg' WHERE `name` = '郓城壮馍';
UPDATE `food` SET `cover_url` = 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=food-niurou.jpg' WHERE `name` = '曹县烧牛肉';
UPDATE `food` SET `cover_url` = 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=food-shuijian.jpg' WHERE `name` = '菏泽水煎包';
UPDATE `food` SET `cover_url` = 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=food-fendu.jpg' WHERE `name` = '东明粉肚';
UPDATE `food` SET `cover_url` = 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=food-guanzi.jpg' WHERE `name` = '巨野罐子汤';

-- 轮播图更新 - 替换为菏泽相关图片
UPDATE `carousel` SET `cover_url` = 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=carousel-mudan1.jpg', `title` = '曹州牡丹园：国色天香 花开时节动京城', `recommend_detail` = '世界最大牡丹观赏基地，九大色系十大花型，千余品种竞相绽放，每年四月花开如海，吸引全球游客慕名而来。' WHERE `id` = 1;
UPDATE `carousel` SET `cover_url` = 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=carousel-mudan2.jpg', `title` = '菏泽牡丹：唯有牡丹真国色', `recommend_detail` = '菏泽是世界最大的牡丹种植基地，拥有1237个品种，种植面积48.6万亩，是名副其实的中国牡丹之都。' WHERE `id` = 5;
UPDATE `carousel` SET `cover_url` = 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=carousel-gucheng.jpg', `title` = '曹州古城：千年古韵 岁月沉淀', `recommend_detail` = '菏泽古称曹州，拥有数千年建城史。漫步古城街巷，青砖黛瓦间尽是岁月痕迹，每一处都在诉说悠远故事。' WHERE `id` = 7;

-- 景点封面图更新
UPDATE `scenic_spot` SET `cover` = 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=spot-mudanyuan.jpg' WHERE `id` = 7;
UPDATE `scenic_spot` SET `cover` = 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=spot-gucheng.jpg' WHERE `id` = 9;
UPDATE `scenic_spot` SET `cover` = 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=spot-baishifang.jpg' WHERE `id` = 16;
UPDATE `scenic_spot` SET `cover` = 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=spot-hongse.jpg' WHERE `id` = 20;

-- 用户头像更新
UPDATE `user` SET `avatar` = 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=avatar-default1.jpg' WHERE `role` = 1 AND (`avatar` IS NULL OR `avatar` = '');
UPDATE `user` SET `avatar` = 'http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName=avatar-default2.jpg' WHERE `role` = 2 AND (`avatar` IS NULL OR `avatar` = '');
