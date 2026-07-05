package com.kmbeast.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.kmbeast.mapper.FoodMapper;
import com.kmbeast.mapper.ScenicSpotMapper;
import com.kmbeast.mapper.ScenicSpotStrategyMapper;
import com.kmbeast.pojo.entity.Food;
import com.kmbeast.pojo.entity.ScenicSpot;
import com.kmbeast.pojo.entity.ScenicSpotStrategy;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@Service
public class KnowledgeService {

    @Autowired
    private ScenicSpotMapper scenicSpotMapper;

    @Autowired
    private FoodMapper foodMapper;

    @Autowired
    private ScenicSpotStrategyMapper strategyMapper;

    private static final int MAX_CONTEXT_LENGTH = 4000;

    private static final String SYSTEM_PROMPT_TEMPLATE =
            "你是菏泽旅游票务平台的AI客服，名字叫「AI客服」。你的职责是基于以下参考资料回答用户关于菏泽旅游的问题。\n\n" +
            "【重要规则】\n" +
            "1. 必须基于下方参考资料回答，如果参考资料中没有相关信息，请诚实说明\n" +
            "2. 不要编造不存在的景点、美食或信息\n" +
            "3. 回答时使用合适的Markdown格式，包括标题、列表、加粗等，让回答更易读\n" +
            "4. 语气友好专业，像一位热情的菏泽旅游顾问\n" +
            "5. 如果用户问的不是菏泽旅游相关问题，礼貌引导回旅游话题\n\n" +
            "【参考资料】\n%s\n\n" +
            "请基于以上参考资料回答用户的问题。";

    private static final List<String> STOP_WORDS = Arrays.asList(
            "的", "了", "在", "是", "我", "有", "和", "就", "不", "人", "都", "一", "一个",
            "上", "也", "很", "到", "说", "要", "去", "你", "会", "着", "没有", "看", "好",
            "自己", "这", "他", "她", "它", "吗", "呢", "吧", "啊", "哦", "嗯", "那", "什么",
            "怎么", "如何", "哪", "哪里", "几个", "多少", "可以", "能", "应该", "还是",
            "或者", "而且", "但是", "不过", "因为", "所以", "如果", "虽然", "已经",
            "请", "问", "想", "知道", "推荐", "介绍", "告诉", "一下", "有点",
            "比较", "最", "更", "非常", "特别", "真的", "确实", "大概", "可能"
    );

    private static final Pattern CN_PATTERN = Pattern.compile("[\\u4e00-\\u9fa5]+");

    public String buildSystemPrompt(String question) {
        List<String> keywords = extractKeywords(question);
        String context = retrieveContext(keywords, question);
        return String.format(SYSTEM_PROMPT_TEMPLATE, context);
    }

    private List<String> extractKeywords(String question) {
        List<String> keywords = new ArrayList<>();
        Matcher matcher = CN_PATTERN.matcher(question);
        StringBuilder sb = new StringBuilder();
        while (matcher.find()) {
            sb.append(matcher.group()).append(" ");
        }
        String[] tokens = sb.toString().trim().split("\\s+");

        for (String token : tokens) {
            if (token.length() >= 2 && !STOP_WORDS.contains(token)) {
                keywords.add(token);
            }
        }

        for (int len = 2; len <= 4; len++) {
            for (String token : tokens) {
                if (token.length() > len) {
                    for (int i = 0; i <= token.length() - len; i++) {
                        String sub = token.substring(i, i + len);
                        if (!STOP_WORDS.contains(sub) && !keywords.contains(sub)) {
                            keywords.add(sub);
                        }
                    }
                }
            }
        }

        return keywords.stream().distinct().collect(Collectors.toList());
    }

    private String retrieveContext(List<String> keywords, String question) {
        StringBuilder context = new StringBuilder();
        int currentLength = 0;

        List<KnowledgeItem> allItems = new ArrayList<>();

        List<ScenicSpot> spots = scenicSpotMapper.selectList(
                new QueryWrapper<ScenicSpot>().select("id", "title", "summary", "content"));
        for (ScenicSpot spot : spots) {
            String text = (spot.getTitle() != null ? spot.getTitle() : "") + " " +
                    (spot.getSummary() != null ? spot.getSummary() : "");
            int score = calculateScore(keywords, text);
            if (score > 0) {
                String content = "【景点】" + spot.getTitle() + "：" +
                        (spot.getSummary() != null ? spot.getSummary() : "");
                allItems.add(new KnowledgeItem(content, score));
            }
        }

        List<Food> foods = foodMapper.selectList(
                new QueryWrapper<Food>().select("id", "name", "description", "tag", "address"));
        for (Food food : foods) {
            String text = (food.getName() != null ? food.getName() : "") + " " +
                    (food.getDescription() != null ? food.getDescription() : "") + " " +
                    (food.getTag() != null ? food.getTag() : "") + " " +
                    (food.getAddress() != null ? food.getAddress() : "");
            int score = calculateScore(keywords, text);
            if (score > 0) {
                String content = "【美食】" + food.getName() + "：" +
                        (food.getDescription() != null ? food.getDescription() : "") +
                        "（" + (food.getTag() != null ? food.getTag() : "") + "，" +
                        (food.getAddress() != null ? food.getAddress() : "") + "）";
                allItems.add(new KnowledgeItem(content, score));
            }
        }

        List<ScenicSpotStrategy> strategies = strategyMapper.selectList(
                new QueryWrapper<ScenicSpotStrategy>().select("id", "title", "summary", "content"));
        for (ScenicSpotStrategy strategy : strategies) {
            String text = (strategy.getTitle() != null ? strategy.getTitle() : "") + " " +
                    (strategy.getSummary() != null ? strategy.getSummary() : "");
            int score = calculateScore(keywords, text);
            if (score > 0) {
                String content = "【攻略】" + strategy.getTitle() + "：" +
                        (strategy.getSummary() != null ? strategy.getSummary() : "");
                allItems.add(new KnowledgeItem(content, score));
            }
        }

        allItems.sort((a, b) -> Integer.compare(b.score, a.score));

        for (KnowledgeItem item : allItems) {
            if (currentLength + item.content.length() > MAX_CONTEXT_LENGTH) break;
            context.append(item.content).append("\n\n");
            currentLength += item.content.length();
        }

        if (context.length() == 0) {
            context.append("菏泽市位于山东省西南部，是著名的牡丹之都。下辖牡丹区、定陶区、曹县、单县、成武县、巨野县、郓城县、鄄城县、东明县共9个区县。")
                    .append("菏泽拥有丰富的旅游资源，包括牡丹园、水浒好汉城、孙膑旅游城等知名景点，以及单县羊肉汤、曹县烧牛肉等特色美食。")
                    .append("如需了解具体景点或美食信息，请告诉我您感兴趣的方面。");
        }

        return context.toString();
    }

    private int calculateScore(List<String> keywords, String text) {
        int score = 0;
        String lowerText = text.toLowerCase();
        for (String keyword : keywords) {
            if (lowerText.contains(keyword.toLowerCase())) {
                score += keyword.length();
                int idx = 0;
                while ((idx = lowerText.indexOf(keyword.toLowerCase(), idx)) != -1) {
                    score += 1;
                    idx++;
                }
            }
        }
        return score;
    }

    private static class KnowledgeItem {
        String content;
        int score;

        KnowledgeItem(String content, int score) {
            this.content = content;
            this.score = score;
        }
    }
}
