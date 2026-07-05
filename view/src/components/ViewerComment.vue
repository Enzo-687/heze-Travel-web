<template>
    <div class="comment-container">

        <div v-if="!totalComments">
            <el-empty description="暂无评论数据"></el-empty>
        </div>

        <!-- 评论头部 -->
        <div v-else class="comment-header">
            <div class="header-title">
                <h2>评论&nbsp;·&nbsp;{{ totalComments }}</h2>
            </div>
        </div>

        <!-- 评论列表 -->
        <div class="comment-list">
            <div v-for="(comment, index) in commentList" :key="comment.id" class="comment-item">
                <!-- 评论主体 -->
                <div class="comment-main">
                    <div class="comment-avatar">
                        <img :src="comment.avatar" :alt="comment.username">
                    </div>
                    <div class="comment-content">
                        <div class="comment-meta">
                            <span class="username">{{ comment.username }}</span>
                        </div>
                        <div class="comment-text">{{ comment.content }}</div>
                        <div class="comment-actions-bar">
                            <span class="time">
                                <span class="time-icon">发布于</span>
                                {{ comment.time }}
                            </span>
                            <span class="time">
                                <span>
                                    <img style="width: 15px;height: 15px;margin-top: 4px;" src="/upvote_default.png"
                                        alt="">
                                    {{ comment.upvoteCount }}
                                </span>
                            </span>
                        </div>
                    </div>
                </div>

                <!-- 子评论 -->
                <div class="child-comments">
                    <div v-for="child in comment.commentChildVOS" :key="child.id" class="child-comment">
                        <div class="comment-main">
                            <div class="comment-avatar">
                                <img :src="child.avatar" :alt="child.username">
                            </div>
                            <div class="comment-content">
                                <div class="comment-meta">
                                    <span class="username">{{ child.username }}</span>
                                    <span v-if="child.replierName" class="reply-text">回复</span>
                                    <span v-if="child.replierName" class="reply-info">
                                        <span class="replier-name">{{ child.replierName }}</span>
                                    </span>
                                </div>
                                <div class="comment-text">{{ child.content }}</div>
                                <div class="comment-actions-bar">
                                    <span class="time">
                                        <span class="time-icon">发布于</span>
                                        {{ child.time }}
                                    </span>
                                    <span class="time">
                                        <span>
                                            <img style="width: 15px;height: 15px;margin-top: 4px;"
                                                src="/upvote_default.png" alt="">
                                            {{ comment.upvoteCount }}
                                        </span>
                                    </span>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>

    </div>
</template>

<script setup lang="ts">
import { ref, watch, onMounted } from 'vue'
import { timeAgo } from '@/utils/date'
import { post, del } from "@/utils/request"
import { queryCommentListByViewerApi } from "@/api/viewer-api"
import { ElNotification } from 'element-plus'

interface CommentChild {
    id: number
    userId: number
    username: string
    avatar: string
    content: string
    createTime: string
    time: string
    upvoteCount: number
    upvoteFlag: boolean
    replyInputStatus?: boolean
    parentId?: number
    replierId?: number
    replierName?: string
    replierAvatar?: string
    commentChildVOS?: CommentChild[]
}

interface Comment extends CommentChild {
    showReplyInput?: boolean
    commentChildVOS: CommentChild[]
}

interface Props {
    contentId: number
    contentType: string
}

const props = defineProps<Props>()

// 响应式数据
const commentList = ref<Comment[]>([])
const content = ref('')
const replyContent = ref('')
const replyChildContent = ref('')
const isFocused = ref(false)
const evaluationsCount = ref(0)
const showDeleteModal = ref(false)
const commentToDelete = ref<Comment | CommentChild | null>(null)
const totalComments = ref(0)

// 监听器
watch(() => props.contentId, (newVal, oldVal) => {
    if (newVal !== oldVal) {
        loadCommentList()
    }
})

watch(content, (newVal) => {
    if (newVal === '') {
        isFocused.value = false
    }
})

// 生命周期
onMounted(() => {
    loadCommentList()
})


const loadCommentList = async () => {
    try {
        const response = await queryCommentListByViewerApi(props.contentId, props.contentType)
        if (response.code === 200) {
            commentList.value = response.data
            evaluationsCount.value = response.data.evaluationsCount
            commentList.value.forEach(entity => {
                entity.time = timeAgo(entity.createTime)
                entity.commentChildVOS.forEach(child => {
                    child.time = timeAgo(child.createTime)
                })
            })

            // 计算总评论数
            totalComments.value = response.data.reduce((total: number, parentComment: any) => {
                return total + 1 + (parentComment.commentChildVOS?.length || 0)
            }, 0)

        }
    } catch (error) {
        console.error('评论查询异常 ->', error)
    }
}

</script>

<style scoped>
* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

.comment-container {
    width: 100%;
    max-width: 800px;
    margin: 0 auto;
    padding: 24px;
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    background: #fff;
}

/* 评论头部 */
.comment-header {
    margin-bottom: 24px;
}

.header-title {
    display: flex;
    align-items: center;
    gap: 12px;
}

.header-title .icon {
    font-size: 1.5rem;
}

.header-title h2 {
    font-size: 1.5rem;
    font-weight: 700;
    color: #1a1a1a;
    margin: 0;
}

/* 评论输入区域 */
.comment-input-area {
    display: flex;
    gap: 16px;
    margin-bottom: 12px;
}

.user-avatar {
    width: 48px;
    height: 48px;
    flex-shrink: 0;
}

.user-avatar img {
    width: 100%;
    height: 100%;
    border-radius: 50%;
    object-fit: cover;
    border: 2px solid #e8e8e8;
}

.comment-form {
    flex: 1;
    border: 1px solid #f0f0f0;
    border-radius: 16px;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    background: #fafafa;
    overflow: hidden;
}

.comment-form textarea {
    width: 100%;
    min-height: 50px;
    padding: 20px;
    border: none;
    background: transparent;
    resize: none;
    font-size: 1rem;
    line-height: 1.6;
    color: #333;
    background-color: #fff;
    outline: none;
    font-family: inherit;
}

.comment-actions {
    display: flex;
    justify-content: left;
    gap: 8px;
    align-items: center;
    padding: 8px 20px;
    background: #f8f9fa;
    border-top: 1px solid #f0f0f0;
}

.char-count {
    font-size: 0.875rem;
    color: #6c757d;
    font-weight: 500;
}

.submit-btn {
    display: flex;
    align-items: center;
    padding: 8px 20px;
    background-color: rgb(103, 75, 196);
    color: white;
    border: none;
    border-radius: 20px;
    font-size: 0.675rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
}

.submit-btn:hover:not(.disabled) {
    transform: translateY(-1px);

}

.submit-btn.disabled {
    background: #6c757d;
    cursor: not-allowed;
    transform: none;
    box-shadow: none;
}

.submit-btn.small {
    padding: 6px 20px;
    font-size: 0.8rem;
}

.btn-icon {
    font-size: 1rem;
}

/* 评论列表 */
.comment-list {
    display: flex;
    flex-direction: column;
    gap: 0;
}

.comment-item {
    padding: 12px 0;
    transition: background-color 0.2s ease;
}

.comment-item:last-child {
    border-bottom: none;
}

.comment-item.highlighted {
    margin: 0 -12px;
    padding: 12px 24px;
    border-radius: 12px;
}

.comment-main {
    display: flex;
    gap: 16px;
}

.comment-avatar {
    position: relative;
    width: 36px;
    height: 36px;
    flex-shrink: 0;
}

.comment-avatar img {
    width: 100%;
    height: 100%;
    border-radius: 50%;
    object-fit: cover;
    border: 2px solid #e8e8e8;
}

.user-badge {
    position: absolute;
    top: -10px;
    right: -10px;
    background: linear-gradient(135deg, #ff6b6b, #ee5a52);
    color: white;
    font-size: 0.6rem;
    padding: 2px 6px;
    border-radius: 8px
}

.comment-content {
    flex: 1;
    min-width: 0;
}

.comment-meta {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 12px;
    margin-bottom: 12px;
}

.username {
    font-size: 16px;
    color: #2c3e50;
}

.reply-info {
    font-size: 0.85rem;
    color: #6c757d;
}

.replier-name {
    font-size: 16px;
    color: #2c3e50;
}

.reply-text {
    display: flex;
    padding: 2px 10px;
    border-radius: 10px;
    font-size: 10px;
    background-color: rgb(242, 242, 242);
    border: 1px solid rgb(232, 232, 232);
    color: #2c3e50;
}

.time {
    display: flex;
    align-items: center;
    gap: 4px;
    font-size: 0.8rem;
    color: #8e9a9d;
    cursor: pointer;

    &:hover {
        color: #333;
    }
}

.time-icon {
    font-size: 0.7rem;
}

.comment-text {
    font-size: 16px;
    line-height: 1;
    color: #4a5568;
    margin-bottom: 6px;
    padding: 6px 0;
    /* background-color: rgb(250, 250, 250); */
}

.comment-actions-bar {
    display: flex;
    gap: 16px;
    align-items: center;
}

.action-btn {
    display: flex;
    align-items: center;
    gap: 6px;
    padding: 8px 16px;
    background: transparent;
    border: 1px solid #e0e0e0;
    border-radius: 8px;
    font-size: 0.8rem;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.2s ease;
    color: #6c757d;
}

.action-btn:hover {
    transform: translateY(-1px);
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.reply-btn:hover {
    border-color: #007bff;
    color: #007bff;
}

.delete-btn:hover {
    border-color: #dc3545;
    color: #dc3545;
}

.action-icon {
    font-size: 0.9rem;
}

/* 子评论 */
.child-comments {
    margin-top: 20px;
    margin-left: 60px;
}

.child-comment {
    margin-bottom: 20px;
}

.child-comment:last-child {
    margin-bottom: 0;
}

/* 回复输入框 */
.reply-input-container {
    margin-top: 16px;
    margin-left: 60px;
}

.reply-form {
    border: 1px solid #f1f1f1;
    border-radius: 12px;
    overflow: hidden;
}

.reply-form textarea {
    width: 100%;
    min-height: 60px;
    padding: 16px;
    border: none;
    background: transparent;
    resize: none;
    font-size: 0.9rem;
    line-height: 1.5;
    color: #333;
    outline: none;
    font-family: inherit;
}

.reply-actions {
    display: flex;
    justify-content: left;
    gap: 8px;
    align-items: center;
    padding: 6px 16px;
    background: #fafafa;
    border-top: 1px solid #f1f1f1;
}

/* 删除确认弹窗 */
.modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.5);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 1000;
    backdrop-filter: blur(4px);
}

.modal-content {
    background: white;
    padding: 32px;
    border-radius: 20px;
    max-width: 400px;
    width: 90%;
    text-align: center;
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2);
}

.modal-icon {
    font-size: 3rem;
    margin-bottom: 16px;
}

.modal-content h3 {
    font-size: 1.25rem;
    font-weight: 700;
    color: #2c3e50;
    margin-bottom: 8px;
}

.modal-content p {
    color: #6c757d;
    margin-bottom: 24px;
    line-height: 1.5;
}

.modal-actions {
    display: flex;
    gap: 12px;
    justify-content: center;
}

.modal-btn {
    padding: 12px 24px;
    border: none;
    border-radius: 12px;
    font-size: 0.9rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    min-width: 100px;
}

.modal-btn.cancel {
    background: #f8f9fa;
    color: #6c757d;
    border: 2px solid #e9ecef;
}

.modal-btn.cancel:hover {
    background: #e9ecef;
    transform: translateY(-1px);
}

.modal-btn.confirm {
    background: linear-gradient(135deg, #dc3545, #c82333);
    color: white;
    box-shadow: 0 2px 8px rgba(220, 53, 69, 0.3);
}

.modal-btn.confirm:hover {
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(220, 53, 69, 0.4);
}

/* 响应式设计 */
@media (max-width: 768px) {
    .comment-container {
        padding: 20px;
        border-radius: 12px;
    }

    .comment-input-area {
        gap: 12px;
    }

    .user-avatar,
    .comment-avatar {
        width: 40px;
        height: 40px;
    }

    .child-comments {
        margin-left: 40px;
        padding-left: 16px;
    }

    .reply-input-container {
        margin-left: 40px;
    }

    .comment-actions-bar {
        flex-wrap: wrap;
        gap: 8px;
    }

    .action-btn {
        padding: 6px 12px;
        font-size: 0.75rem;
    }
}

@media (max-width: 480px) {
    .comment-container {
        padding: 16px;
    }

    .header-title h2 {
        font-size: 1.25rem;
    }

    .comment-main {
        flex-direction: column;
        gap: 12px;
    }

    .comment-avatar {
        align-self: flex-start;
    }

    .child-comments {
        margin-left: 20px;
        padding-left: 12px;
    }

    .reply-input-container {
        margin-left: 20px;
    }

    .modal-content {
        padding: 24px;
        margin: 20px;
    }

    .modal-actions {
        flex-direction: column;
    }

    .modal-btn {
        width: 100%;
    }
}
</style>