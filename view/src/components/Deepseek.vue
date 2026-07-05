<template>
    <div class="chat-wrapper">
        <div>
            <template v-if="!messages.length">
                <el-empty description="开启你的对话吧"></el-empty>
            </template>
        </div>
        <!-- 消息列表 -->
        <div class="message-list" ref="messageList">
            <div v-for="msg in messages" :key="msg.id" class="message-item"
                :class="{ 'message-right': msg.position === 'right', 'message-left': msg.position === 'left' }">
                <div class="message-bubble">

                    <!-- 用户消息：纯文本 -->
                    <template v-if="msg.position === 'right'">
                        <div class="right-container">
                            <div>
                                <img style="width: 30px;height: 30px;" :src="userAvatar" alt="" srcset="">
                            </div>
                            <div class="message-content">{{ msg.content }}</div>
                        </div>
                    </template>
                    <!-- AI消息：Markdown 渲染 -->
                    <template v-else>
                        <div class="left-container">
                            <div>
                                <img src="/ai.png" alt="" srcset="">
                            </div>
                            <!-- 占位 -->
                            <div class="message-content">
                                <div class="markdown-content" v-html="msg.renderedContent">
                                </div>
                            </div>
                        </div>
                    </template>
                </div>
            </div>
            <div class="typing-indicator" v-if="isTyping">
                <div class="dot"></div>
                <div class="dot"></div>
                <div class="dot"></div>
                <div class="text">正在思考中，请稍等</div>
            </div>
        </div>

        <!-- 输入区域 -->
        <div class="input-area">
            <div>
                <textarea v-model="inputValue" class="input-textarea" :placeholder="placeholder" :disabled="isLoading"
                    @keydown.enter.prevent="handleSend" rows="3"></textarea>
            </div>

            <div class="operation-container">
                <div class="model">
                    <el-icon>
                        <TurnOff />
                    </el-icon>
                    AI模型·DeepSeek
                </div>


                <button class="send-btn" :disabled="!isLoading && !inputValue.trim()"
                    @click="isLoading ? stopChat() : handleSend()">
                    <div class="btn-hover">
                        <el-icon>
                            <top />
                        </el-icon>
                        {{ isLoading ? '结束对话' : '发送' }}
                    </div>
                </button>

            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, nextTick, onUnmounted, onMounted } from 'vue'
import MarkdownIt from 'markdown-it'
import { ElMessage } from 'element-plus'
import { getToken } from '@/utils/storage'

import Prism from 'prismjs'
import 'prismjs/themes/prism-tomorrow.css'   // 深色主题
import 'prismjs/components/prism-c'          // 示例：C 语言
import 'prismjs/components/prism-java'
import 'prismjs/components/prism-python'
import 'prismjs/components/prism-javascript'
import 'prismjs/components/prism-typescript'
import type { Grammar } from 'prismjs'
import Clipboard from 'clipboard'

/* -------------------- 类型 -------------------- */
interface Message {
    id: string
    content: string
    renderedContent: string
    position: 'left' | 'right'
    timestamp: number
    isStreaming?: boolean
}

interface SSEData {
    content: string
    type: 'chunk'
    isTable?: boolean,
    isCodeBlock?: boolean
}

interface RequestParams {
    question: string
}

/* -------------------- 配置 -------------------- */
const TYPE_SPEED = 5
const API_URL = 'http://localhost:21090/api/v1.0/online-travel-api/ask/seek'
const placeholder = ref('请输入您的问题...')

/* -------------------- 状态 -------------------- */
const messages = ref<Message[]>([])
const inputValue = ref('')
const isLoading = ref(false)
const isTyping = ref(false)
const abortController = ref<AbortController | null>(null)
const typeTimer = ref<any>(null)
const messageList = ref<HTMLElement | null>(null)
const lineBuffer = ref('') // 行缓冲

const tableBuffer = ref('')



const props = defineProps({
    // 用户头像地址,传入
    userAvatar: {
        type: String,
        required: false, // 设为 true 表示父组件必须传
        default: '' // 默认值，父组件没传时使用
    },
})

/* -------------------- Markdown-it -------------------- */
const md = new MarkdownIt('default', {
    html: true,
    linkify: true,
    breaks: true,
    typographer: true,
    highlight(str, lang) {
        return `<div class="code-block"><pre class="language-${lang}"><code>${escapeHtml(str)}</code></pre></div>`
    }
})

/* -------------------- 工具 -------------------- */
const escapeHtml = (text: string): string => {
    const div = document.createElement('div')
    div.textContent = text
    return div.innerHTML
}

let clipboard: Clipboard | null = null

/* ---------- 新增：手动中断 ---------- */
const stopChat = () => {
    // 1. 打断 fetch
    abortController.value?.abort()
    // 2. 状态立即复位（finally 里会再复位一次，重复赋值无妨）
    isLoading.value = false
    isTyping.value = false
}

const sanitizeHtml = (html: string): string =>
    html
        .replace(/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi, '')
        .replace(/on\w+="[^"]*"/g, '')
        .replace(/on\w+='[^']*'/g, '')
        .replace(/javascript:/gi, '')

/* 统一渲染：给表格/代码块/引用加类 */
const renderMarkdown = (src: string) => {
    let html = md.render(src)

    /* 1. 给 <table> 加类 */
    html = html.replace(/<table>/g, '<table class="ui-table">')

    /* 2. 给 <blockquote> 加类 */
    html = html.replace(/<blockquote>/g, '<blockquote class="ui-quote">')

    /* 3. 代码块增强：语言标签 + 复制按钮 + 行号 */
    html = html.replace(
        /<div class="code-block"><pre class="language-(\w+)"><code>(.*?)<\/code><\/pre><\/div>/gs,
        (match, lang, code) => {
            /* 转义还原 */
            const raw = code.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&quot;/g, '"').replace(/&#039;/g, "'").replace(/&amp;/g, '&')

            /* 关键：在 Prism 高亮之前，将 Tab 字符转换为空格 */
            const codeWithSpaces = raw.replace(/\t/g, '    ') // 将 Tab 转换为 4 个空格

            /* 高亮 */
            const grammar = (Prism.languages[lang] ?? Prism.languages.clike ?? Prism.languages.javascript) as Grammar
            const highlighted = Prism.highlight(codeWithSpaces, grammar, lang)

            /* 行号 */
            const lines = highlighted.split('\n').map((l, i) => `<span class="line">${i + 1}</span>${l}`).join('\n')

            /* 组装 */
            return `<div class="code-wrapper">
                    <div class="code-header">
                    <span class="code-lang">${lang}</span>
                    <button class="copy-btn" data-clipboard-text="${raw.replace(/"/g, '&quot;')}">复制</button>
                    </div>
                    <pre class="code-block language-${lang}"><code>${lines}</code></pre>
                    </div>`
        }
    )

    return sanitizeHtml(html)
}
/* -------------------- 业务 -------------------- */
/* -------------------- 业务 -------------------- */
const handleSend = async () => {
    const question = inputValue.value.trim()
    if (!question || isLoading.value) return
    inputValue.value = ''

    /* 1. 先压入用户消息 */
    const userMsg: Message = {
        id: generateId(),
        content: question,
        renderedContent: question,
        position: 'right',
        timestamp: Date.now()
    }
    messages.value.push(userMsg)

    /* 2. ***** 关键：提问后立即滚到底 ***** */
    await nextTick()          // 等 DOM 更新完
    scrollToBottom()          // 滚到最底部

    /* 3. 再压入 AI 占位消息，后续逻辑保持不变…… */
    const aiMsgId = generateId()
    const aiMsg: Message = {
        id: aiMsgId,
        content: '',
        renderedContent: '',
        position: 'left',
        timestamp: Date.now(),
        isStreaming: true
    }
    messages.value.push(aiMsg)

    isLoading.value = true
    isTyping.value = true
    abortController.value = new AbortController()

    try {
        await fetchStream(question, aiMsgId)
    } catch (error: any) {
        // ElMessage.error(error.message || '请求失败')
        const idx = messages.value.findIndex(m => m.id === aiMsgId)
        if (idx > -1) messages.value.splice(idx, 1)
    } finally {
        isLoading.value = false
        isTyping.value = false
        abortController.value = null
        const aiMsg = messages.value.find(m => m.id === aiMsgId)
        if (aiMsg) {
            aiMsg.isStreaming = false
            aiMsg.renderedContent = renderMarkdown(aiMsg.content)
            messages.value = [...messages.value]
        }
    }
}

const generateId = () => Date.now() + '-' + Math.random().toString(36).slice(2, 11)

const fetchStream = async (question: string, aiMsgId: string) => {
    const response = await fetch(API_URL, {
        method: 'POST',
        headers: {
            Authorization: `Bearer ${getToken()}`,
            'Content-Type': 'application/json',
            Accept: 'text/event-stream'
        },
        body: JSON.stringify({ question }),
        signal: abortController.value?.signal
    })

    if (!response.ok) throw new Error(`HTTP ${response.status}`)
    if (!response.body) throw new Error('无流式响应体')

    const reader = response.body.getReader()
    const decoder = new TextDecoder('utf-8')
    let buffer = ''

    try {
        while (true) {
            const { done, value } = await reader.read()
            if (done) {
                // 流结束：冲刷表格缓冲区
                if (tableBuffer.value) {
                    await flushTableBuffer(aiMsgId)
                }
                break
            }

            buffer += decoder.decode(value, { stream: true })
            const lines = buffer.split('\n')
            buffer = lines.pop() || ''

            for (const line of lines) {
                const str = line.trim()
                if (!str.startsWith('data:')) continue
                const jsonStr = str.slice(5).trim()
                if (jsonStr === '' || jsonStr === '[DONE]') continue
                try {
                    const sse: SSEData = JSON.parse(jsonStr)

                    // ★★★ 就在这里做分支 ★★★
                    if (sse.isCodeBlock) {
                        updateAiMessage(aiMsgId, sse.content, true)
                    } else if (sse.isTable) {
                        updateAiMessage(aiMsgId, sse.content, true)
                    } else {
                        await typeCharByChar(aiMsgId, sse.content)
                    }
                } catch (err: any) {
                    // 1. 主动中断 & 2. 浏览器底层抛错 → 静默返回，不弹窗
                    if (err.name === 'AbortError' || err.message?.includes('aborted')) {
                        return          // ✅ 静默结束
                    }
                    // 3. 其他异常继续抛，让外层统一提示
                    throw err
                    // 非 JSON  fallback
                    // await typeCharByChar(aiMsgId, jsonStr)
                }
            }
        }
    } finally {
        reader.releaseLock()
        // 最终冲刷：行缓冲 + 表格缓冲
        const aiMsg = messages.value.find(m => m.id === aiMsgId)
        if (aiMsg && lineBuffer.value) {
            aiMsg.content += lineBuffer.value
            aiMsg.renderedContent = renderMarkdown(aiMsg.content)
            lineBuffer.value = ''
            messages.value = [...messages.value]
        }
    }
}

/**
 * 冲刷表格缓冲区：合并完整表格结构后一次性渲染
 */
const flushTableBuffer = async (aiMsgId: string) => {
    if (!tableBuffer.value) return

    const aiMsg = messages.value.find(m => m.id === aiMsgId)
    if (!aiMsg) return

    // 关键处理：合并零散的分隔线，修复表格格式
    let completeTable = tableBuffer.value
        // 合并表格分隔线（处理后端拆分的多个"---"）
        .replace(/(\|.*?)(---)+(?=\|)/g, (match, prefix) => {
            // 为每个列生成完整的分隔线（至少3个"-"）
            const colCount = (prefix.match(/\|/g) || []).length
            return prefix + Array(colCount).fill('---').join('|')
        })
        // 确保每行末尾有"|"，补全不完整行
        .replace(/\|([^\|]*)$/gm, '|$1|')

    // 一次性追加完整表格内容
    aiMsg.content += completeTable
    // 渲染完整表格（此时MarkdownIt能正确解析出<table>）
    aiMsg.renderedContent = renderMarkdown(aiMsg.content)

    messages.value = [...messages.value]
    nextTick(scrollToBottom)

    // 清空表格缓冲区
    tableBuffer.value = ''
}

const typeCharByChar = async (aiMsgId: string, content: string) => {
    if (!content) return
    const chars = content.split('')
    for (const ch of chars) {
        await new Promise<void>(resolve => {
            typeTimer.value = setTimeout(() => {
                updateAiMessage(aiMsgId, ch, false)
                resolve()
            }, TYPE_SPEED)
        })
    }
}

const updateAiMessage = (aiMsgId: string, content: string, immediate = false) => {
    const aiMsg = messages.value.find(m => m.id === aiMsgId)
    if (!aiMsg) return

    if (immediate) {
        aiMsg.content += content
        aiMsg.renderedContent = renderMarkdown(aiMsg.content)
    } else {
        lineBuffer.value += content
        const lastLF = lineBuffer.value.lastIndexOf('\n')
        if (lastLF >= 0) {
            const ready = lineBuffer.value.slice(0, lastLF + 1)
            lineBuffer.value = lineBuffer.value.slice(lastLF + 1)
            aiMsg.content += ready
            aiMsg.renderedContent = renderMarkdown(aiMsg.content)
        }
    }
    messages.value = [...messages.value]
    nextTick(scrollToBottom)
}

const scrollToBottom = () => {
    if (messageList.value) messageList.value.scrollTop = messageList.value.scrollHeight
}



onUnmounted(() => {
    clipboard?.destroy()   // 关键！
    clipboard = null
    abortController.value?.abort()
    if (typeTimer.value) clearTimeout(typeTimer.value)
})

onMounted(() => {
    clipboard = new Clipboard('.copy-btn')

    clipboard.on('success', () => ElMessage.success('已复制到剪贴板'))
    clipboard.on('error', () => ElMessage.error('复制失败'))
})
</script>

<style scoped lang="scss">
.chat-wrapper {
    width: 100%;
    height: 70vh;
    max-width: 1200px;
    margin: 0 auto;
    background: #fff;
    border-radius: 12px;
    // box-shadow: 0 2px 16px rgba(0, 0, 0, 0.08);
    display: flex;
    flex-direction: column;
    overflow: hidden;
}

.message-list {
    flex: 1;
    padding: 24px;
    overflow-y: auto;
    background-color: #fff;
    scroll-behavior: smooth;

    &::-webkit-scrollbar {
        width: 6px;
    }

    &::-webkit-scrollbar-thumb {
        background-color: #e5e7eb;
        border-radius: 3px;
    }
}

.message-item {
    display: flex;
    margin-bottom: 16px;
    align-items: flex-start;

    &.message-right {
        justify-content: flex-end;
    }

    &.message-left {
        justify-content: flex-start;
    }
}

.message-bubble {
    max-width: 70%;
    padding: 12px 26px;
    border-radius: 18px;
    line-height: 1.7;
    font-size: 15px;

    .left-container {
        display: flex;
        justify-content: left;
        gap: 10px;

        img {
            width: 30px;
            height: 30px;
            margin-top: 20px;
            border-radius: 50%;
        }
    }
}

.right-container {
    display: flex;
    justify-content: flex-end;
    flex-direction: row-reverse;
    gap: 8px;

    img {
        width: 30px;
        height: 30px;
        border-radius: 50%;
    }

    .message-content {
        background-color: rgb(246, 246, 246);
        border: rgb(232, 232, 232);
        text-align: center;
        padding: 10px;
        box-sizing: border-box;
        border-radius: 10px;
    }
}

.message-right .message-bubble {
    border-bottom-right-radius: 4px;
    color: #333;
}

.message-left .message-bubble {

    ::v-deep(h1) {
        margin: 12px 0;
        font-weight: 600;
    }

    ::v-deep(h2) {
        margin: 12px 0;
        font-weight: 600;
    }

    ::v-deep(h3) {
        margin: 12px 0;
        font-weight: 600;
    }

    ::v-deep(h4) {
        margin: 12px 0;
        font-weight: 600;
    }

    ::v-deep(p) {
        margin: 12px 0;
        font-family: 'Gill Sans', 'Gill Sans MT', Calibri, 'Trebuchet MS', sans-serif;
    }

    ::v-deep(hr) {
        display: none;
    }

    .message-content {
        padding-inline: 12px;
        box-sizing: border-box;
        color: #333;
        max-width: 100%;
        /* 不超过气泡宽度 */
        overflow-x: auto;
        /* 横向滚动 */
        overflow-y: hidden;
        /* 不允许多余纵向滚动 */
        padding: 0.5em 0;
        /* 留一点呼吸空间 */
    }

    /* 美化横向滚动条（WebKit 内核） */
    .message-content::-webkit-scrollbar {
        height: 6px;
    }

    .message-content::-webkit-scrollbar-track {
        background: #f1f1f1;
        border-radius: 3px;
    }

    .message-content::-webkit-scrollbar-thumb {
        background: #888;
        border-radius: 3px;
    }

    .message-content::-webkit-scrollbar-thumb:hover {
        background: #555;
    }

    overflow-x: auto; // 新增：允许表格横向滚动

    /* -------------------- 代码块操作头 -------------------- */
    ::v-deep(.code-header) {
        display: flex;
        justify-content: space-between;
        align-items: center;
        background: rgb(43, 45, 48);
        padding: 0.5em 1em;
        /* 减少内边距 */
        margin: 0;
        /* 确保外边距为0 */
        border-radius: 8px 8px 0 0;
        border-bottom: 1px solid #3e3e3e;

        .code-lang {
            font-weight: 600;
            color: #fff;
            text-transform: uppercase;
            font-size: 0.85em;
        }

        .copy-btn {
            background: rgb(43, 45, 48);
            color: #fff;
            border: none;
            border-radius: 4px;
            padding: 0.4em 0.8em;
            font-size: 0.8em;
            cursor: pointer;
            transition: background 0.2s;

            &:hover {
                background: #4a4d52;
            }
        }
    }

    /* -------------------- 代码块容器 -------------------- */
    ::v-deep(.code-wrapper) {
        all: initial !important;
        display: block !important;
        border: 1px solid #3e3e3e !important;
        border-radius: 8px !important;
        margin: 0 !important;
        padding: 0 !important;
        overflow-y: auto;
        line-height: 1.2 !important;
        background: #1e1e1e !important;
        box-sizing: border-box !important;
    }

    /* -------------------- 代码块主体 -------------------- */
    ::v-deep(.code-block) {
        background: #1e1e1e;
        color: #d4d4d4;
        padding: 0;
        /* 移除内边距，让内容紧贴 */
        margin: 0;
        /* 移除外边距 */
        overflow-x: auto;
        counter-reset: line;
        border-radius: 8px;
        border-top: none;
        font-family: 'SF Mono', 'Monaco', 'Inconsolata', 'Roboto Mono', 'Consolas', monospace;
        line-height: 1.5em;
        font-size: 14px;
        /* 移除上边框，因为头部已经有下边框了 */

        /* 重点：清除 pre 元素的所有默认样式 */
        &,
        &[class*="language-"] {
            margin: 0 !important;
            padding: 0 !important;
            border: none !important;
            background: #1e1e1e !important;
        }

        code {
            white-space: pre;
            /* 保留所有空白字符 */
            tab-size: 4;
            /* 设置 Tab 宽度 */
            -moz-tab-size: 4;
            /* Firefox 兼容 */
            display: block;
            padding: 1em;
            /* 在code内部设置内边距 */

            .line {
                display: inline-block;
                width: 3em;
                text-align: center;
                margin-right: 1.2em;
                color: #cecfc9;
                user-select: none;
                border-right: 1px solid #3e3e3e;
                padding: 0.5em;
            }

            /* 保留原文缩进 */
            white-space: pre;
        }
    }

    ::v-deep(ul),
    ::v-deep(ol) {
        margin: 1em 0;
        padding-left: 2em;
        line-height: 1.7;

        li {
            margin: 0.5em 0;
            color: #2d3748;

            /* 英文列表项优化 */
            text-align: left;

            p {
                margin: 0.3em 0;
            }
        }
    }

    ::v-deep(.ui-table) {
        width: 100%;
        border-collapse: collapse;
        /* 合并边框 */
        margin: 1.2em 0;
        border: 1px solid rgb(232, 232, 232);
        /* 外框 */
        border-radius: 8px;
        /* 整体圆角 */
        overflow: hidden;
        /* 圆角裁剪 */
        font-size: 0.9em;

        th,
        td {
            border: 1px solid rgb(232, 232, 232);
            /* 单元格四边线 */
            padding: 0.8em 1em;
            text-align: left;
        }

        th {
            background: rgb(242, 242, 242);
            font-weight: 600;
        }

        tr:nth-child(even) td {
            background: rgb(250, 250, 250);
        }
    }

}

/* ---------- 引用 ---------- */
.ui-quote {
    border-left: 4px solid #667eea;
    margin: 1.2em 0;
    padding: 1em 1.2em;
    color: #6b7280;
    background: #f8fafc;
    border-radius: 0 8px 8px 0;
    font-style: italic;
}

.typing-indicator {
    display: flex;
    align-items: center;
    justify-content: left;
    gap: 8px;
    padding: 12px 16px;
    margin-inline: 55px;
    border-radius: 18px;
    border-bottom-left-radius: 4px;

    .dot {
        width: 20px;
        height: 20px;
        border-radius: 50%;
        background: #667eea;
        margin: 0 2px;
        animation: bounce 1.4s infinite ease-in-out both;
    }

    .text {
        font-size: 12px;
        color: #c1c1c1;
    }

    .dot:nth-child(1) {
        animation-delay: -0.32s;
    }

    .dot:nth-child(2) {
        animation-delay: -0.16s;
    }
}

@keyframes bounce {

    0%,
    80%,
    100% {
        transform: scale(0);
    }

    40% {
        transform: scale(1);
    }
}

.input-area {
    gap: 12px;
    padding: 6px;
    margin: 0 auto;
    margin-inline: 30px;

    border: 1px solid rgb(232, 232, 232);
    box-shadow: 0 5px 16px -4px #00000012;

    border-radius: 20px;
}

.operation-container {
    padding-inline: 10px;
    display: flex;
    justify-content: space-between;
}

.model {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 6px;
    border: 1px solid rgb(232, 232, 232);
    text-align: center;
    padding: 4px 10px;
    border-radius: 20px;
    font-size: 12px;
    color: #a4a2a2;
}

.input-textarea {
    flex: 1;
    padding: 12px 16px;
    // border: 1px solid #e5e7eb;
    border-radius: 8px;
    border: none;
    font-size: 15px;
    width: 100%;
    resize: none;
    transition: all 0.3s ease;

    &:focus {
        outline: none;
        // border-color: #667eea;
        // box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.1);
    }

    &:disabled {
        background: rgb(252, 252, 252);
        cursor: not-allowed;
    }
}

.send-btn {
    padding: 4px 10px;
    background: #667eea;
    color: #fff;
    border: none;
    border-radius: 20px;
    font-size: 15px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.3s ease;

    .btn-hover {
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 6px;
        text-align: center;
        padding: 4px 10px;
        border-radius: 20px;
        font-size: 12px;
    }

    &:hover:not(:disabled) {
        background: #5a67d8;
        transform: translateY(-1px);
        box-shadow: 0 2px 8px rgba(102, 126, 234, 0.3);
    }

    &:disabled {
        background: #c1c1c1;
        cursor: not-allowed;
        transform: none;
        box-shadow: none;
    }
}

@media (max-width: 768px) {
    .chat-wrapper {
        width: 95%;
        height: 80vh;
    }

    .message-bubble {
        max-width: 85%;
    }

    .input-area {
        padding: 15px;
    }

    .send-btn {
        padding: 0 16px;
    }

    .ui-table {
        font-size: 0.8em;
    }

    .ui-table th,
    .ui-table td {
        padding: 0.6em 0.8em;
    }
}
</style>