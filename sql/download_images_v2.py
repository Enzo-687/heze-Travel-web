import requests
import re
import time
import os
import urllib.parse
import pymysql
import urllib3

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

SAVE_DIR = r"e:\桌面\HNTY-travel-system\source code ai\api\file"
BASE_URL = "http://localhost:21090/api/v1.0/online-travel-api/file/getFile?fileName="

headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
    "Accept-Language": "zh-CN,zh;q=0.9,en;q=0.8",
}

SPOT_SEARCH_QUERIES = {
    7: "曹州牡丹园 菏泽 牡丹花海",
    9: "浮龙湖 单县 湖景 湿地",
    16: "孙膑旅游城 鄄城 亿城寺",
    18: "水浒好汉城 郓城 古建筑",
    19: "单县百狮坊 石雕牌坊",
    20: "菏泽古今园 古桩牡丹盆景",
    21: "中国牡丹园 菏泽 牡丹",
    22: "冠宇牡丹园 菏泽",
    23: "国花牡丹园 菏泽 牡丹",
    24: "曹州百花园 菏泽 牡丹",
    25: "冀鲁豫边区革命纪念馆 菏泽",
    26: "老城曹州 永安塔 夜景",
    27: "菏泽动植物园",
    28: "泉水叮咚水世界 菏泽 水上乐园",
    29: "仿山旅游区 定陶",
    30: "法源寺 菏泽 古寺",
    31: "菏曹运河湿地公园 菏泽",
    32: "鲁西南记忆景区",
    33: "曹县黄河故道湿地",
    34: "曹县汉服小镇 e裳小镇",
    35: "鲁西南红色教育基地",
    36: "幵山景区 单县",
    37: "单县科技馆",
    38: "四君子诗酒文化园",
    39: "林台古镇 曹县",
    40: "文亭湖景区 成武",
    41: "周自齐风景区 成武",
    42: "巨野金山 秦王避暑洞",
    43: "巨野青龙山景区",
    44: "巨野白虎山景区",
    45: "前王庄石头寨 巨野 古村落",
    46: "巨野县博物馆",
    47: "巨野县书画院 工笔牡丹",
    48: "巨野鲁润阿胶文化园",
    49: "巨野文庙永丰塔",
    50: "宋江湖景区 郓城",
    51: "鲁西南战役指挥部旧址 郓城",
    52: "郓州博物馆",
    53: "郓城唐塔 观音寺塔",
    54: "水浒酒文化园 郓城",
    55: "东山禅寺 鄄城",
    56: "尧陵 鄄城 帝尧",
    57: "鄄城濮水湿地公园",
    58: "东明黄河国家湿地公园",
    59: "庄子文化湿地公园 东明",
    60: "玉皇生态文化园 东明",
    61: "东明黄河森林公园",
    62: "天香公园 菏泽 牡丹",
    63: "赵王河公园 菏泽",
    64: "凝香园 菏泽",
    65: "菏泽天主堂 教堂",
    66: "青年湖公园 菏泽",
    67: "环城公园 菏泽",
    68: "曹州书画院 菏泽",
    69: "穆李生态文化旅游村 菏泽",
    70: "安邱堌堆遗址 菏泽",
    71: "范蠡湖 定陶",
    72: "定陶玫瑰园",
    73: "西周曹国古墓群 定陶",
    74: "八里湾风景区 曹县",
    75: "伊尹公园 曹县",
    76: "故道七十二塘 曹县",
    77: "汤陵 曹县 商汤",
    78: "湖西公园 单县",
    79: "百狮坊百寿坊 单县 石雕",
    80: "吉祥寺 单县",
    81: "伯乐墓 曹县",
    82: "蚩尤墓 巨野",
    83: "麒麟台 巨野",
    84: "昌邑故城址 巨野",
    85: "国花酒庄 菏泽",
    86: "夏公馆 菏泽",
    87: "肖堌堆遗址 鄄城",
    88: "庄子钓鱼台 东明",
    89: "历山舜王庙 鄄城",
    90: "葵堌堆村 鄄城",
    91: "黄河高村抢险纪念碑 东明",
    92: "东明万福河景观带",
    93: "长兴集黄河观景台 东明",
    94: "菏泽市博物馆",
    95: "菏泽市抗日纪念馆",
    96: "鲁西南民俗博物馆",
    97: "定陶博物馆",
    98: "定陶革命烈士陵园",
    99: "曹县博物馆",
    100: "曹县木艺文化博物馆 江米人",
    101: "红三村 曹县 革命",
    102: "单县博物馆",
    103: "湖西革命烈士陵园 单县",
    104: "湖西人民抗日武装起义纪念地 单县",
    105: "单县牌坊街 古街",
    106: "成武县博物馆",
    107: "成武红旗剧院",
    108: "巨野革命烈士陵园",
    109: "巨野洙水河公园",
    110: "郓城革命烈士陵园",
    111: "郓城传递红色文化博物馆",
    112: "鄄城县博物馆",
    113: "鄄城黄河滩区迁建展览馆",
    114: "东明县博物馆",
    115: "东明黄河历史文化博物馆",
    116: "东明烈士陵园",
}

FOOD_SEARCH_QUERIES = {
    17: "单县羊肉汤 乳白 鲜美",
    18: "曹州烧饼 吊炉烧饼 芝麻",
    19: "菏泽牡丹宴 牡丹花菜",
    20: "郓城壮馍 大肉饼",
    21: "曹县烧牛肉 酱牛肉",
    22: "菏泽水煎包 底脆",
    23: "东明粉肚 香肚 切片",
    24: "巨野罐子汤 陶罐 羊汤",
    25: "鄄城烧羊肉",
    26: "成武酱大头 酱菜",
    27: "黄河鲤鱼 红烧",
    28: "鄄城糟鱼",
    29: "黄安驴肉 郓城",
    30: "面泡子 菏泽 油炸",
    31: "郓城西瓜酱",
    32: "胡辣汤 菏泽 早餐",
    33: "绿豆糊涂 菏泽",
    34: "曹县羊肉垛",
    35: "谢集烧鸡 单县",
    36: "定陶焖子 煎焖子",
    37: "单县吊炉烧饼",
    38: "巨野杂拌",
    39: "成武白酥鸡",
    40: "东明集烧鸡",
    41: "曹县蒸碗 扣碗",
    42: "菏泽糁汤",
    43: "单县油酥火烧",
    44: "郓城皮家烧鸡",
    45: "陈集山药 定陶",
    46: "沙土瓜子 菏泽",
    47: "菏泽糖糕 油炸",
    48: "曹县王光烧牛肉",
    49: "鄄城金蝉 炸金蝉",
    50: "菏泽芝麻糖 麦芽糖",
    51: "东明卤猪肉",
    52: "巨野烤花搅糕",
    53: "曹县麻辣猪肉",
    54: "菏泽炸串 街头小吃",
    55: "单县罗汉参",
}

def search_bing_images(query, num=8):
    try:
        url = f"https://www.bing.com/images/search?q={urllib.parse.quote(query)}&first=1&count={num}&qft=+filterui:photo-photo+filterui:imagesize-medium"
        resp = requests.get(url, headers=headers, timeout=15)
        if resp.status_code == 200:
            text = resp.text
            matches = re.findall(r'murl&quot;:&quot;(https?://[^&]+?)&quot;', text)
            if matches:
                return matches[:num]
            matches = re.findall(r'src="(https?://[^"]+\.(?:jpg|jpeg|png)[^"]*)"', text)
            return [m for m in matches if 'bing.com' not in m and 'microsoft.com' not in m][:num]
    except Exception as e:
        print(f"  Bing search error: {e}")
    return []

def download_image(url, save_path, timeout=20):
    try:
        dl_headers = {
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
            "Accept": "image/webp,image/apng,image/*,*/*;q=0.8",
        }
        resp = requests.get(url, headers=dl_headers, timeout=timeout, stream=True, verify=False)
        if resp.status_code == 200 and len(resp.content) > 5000:
            with open(save_path, "wb") as f:
                f.write(resp.content)
            return True
    except:
        pass
    return False

def process_items(items_dict, prefix, force_redownload=False):
    results = []
    for item_id, search_query in items_dict.items():
        filename = f"{prefix}-{item_id}.jpg"
        save_path = os.path.join(SAVE_DIR, filename)
        
        if not force_redownload and os.path.exists(save_path) and os.path.getsize(save_path) > 5000:
            print(f"  [SKIP] {prefix}-{item_id}: {search_query} (exists, {os.path.getsize(save_path)//1024}KB)")
            results.append((item_id, search_query, filename, True))
            continue
        
        print(f"  {prefix}-{item_id}: {search_query}...", end=" ", flush=True)
        
        search_terms = [search_query, search_query.split()[0]]
        downloaded = False
        
        for term in search_terms:
            if downloaded:
                break
            urls = search_bing_images(term, 8)
            for url in urls:
                if download_image(url, save_path):
                    if os.path.exists(save_path) and os.path.getsize(save_path) > 5000:
                        print(f"OK ({os.path.getsize(save_path)//1024}KB)")
                        downloaded = True
                        break
        
        if not downloaded:
            print("FAILED")
        
        results.append((item_id, search_query, filename, downloaded))
        time.sleep(2)
    
    return results

def update_database(spot_results, food_results):
    conn = pymysql.connect(
        host='localhost', port=3306, user='root', password='123456',
        database='online-travel-db', charset='utf8mb4'
    )
    cursor = conn.cursor()
    
    updated_spots = 0
    for item_id, name, filename, ok in spot_results:
        if ok and os.path.exists(os.path.join(SAVE_DIR, filename)):
            url = BASE_URL + filename
            cursor.execute("UPDATE scenic_spot SET cover = %s WHERE id = %s", (url, item_id))
            updated_spots += 1
    
    updated_foods = 0
    for item_id, name, filename, ok in food_results:
        if ok and os.path.exists(os.path.join(SAVE_DIR, filename)):
            url = BASE_URL + filename
            cursor.execute("UPDATE food SET cover_url = %s WHERE id = %s", (url, item_id))
            updated_foods += 1
    
    conn.commit()
    cursor.close()
    conn.close()
    
    return updated_spots, updated_foods

if __name__ == "__main__":
    print("=" * 60)
    print("Downloading scenic spot images from Bing Images...")
    print(f"Total: {len(SPOT_SEARCH_QUERIES)} scenic spots")
    print("=" * 60)
    spot_results = process_items(SPOT_SEARCH_QUERIES, "spot")
    
    print("\n" + "=" * 60)
    print("Downloading food images from Bing Images...")
    print(f"Total: {len(FOOD_SEARCH_QUERIES)} food items")
    print("=" * 60)
    food_results = process_items(FOOD_SEARCH_QUERIES, "food")
    
    print("\n" + "=" * 60)
    print("Updating database...")
    print("=" * 60)
    updated_spots, updated_foods = update_database(spot_results, food_results)
    
    success_spots = sum(1 for _, _, _, ok in spot_results if ok)
    success_foods = sum(1 for _, _, _, ok in food_results if ok)
    
    print(f"\nResults:")
    print(f"  Scenic spots: {success_spots}/{len(spot_results)} downloaded, {updated_spots} DB updated")
    print(f"  Foods: {success_foods}/{len(food_results)} downloaded, {updated_foods} DB updated")
    print(f"  Failed spots: {[f'spot-{r[0]}' for r in spot_results if not r[3]]}")
    print(f"  Failed foods: {[f'food-{r[0]}' for r in food_results if not r[3]]}")
