<template>
    <div class="comment-container">
        <!-- 评论头部 -->
        <div class="comment-header">
            <div class="header-title">
                <h2>评论&nbsp;·&nbsp;{{ totalComments }}</h2>
            </div>
        </div>

        <!-- 评论输入区域 -->
        <div class="comment-input-area">
            <div class="user-avatar">
                <img :src="userAvatar" alt="用户头像">
            </div>
            <div class="comment-form" :class="{ focused: isFocused }">
                <textarea v-model="content" placeholder="分享你的想法..." @focus="onFocus" @blur="onBlur"
                    maxlength="300"></textarea>
                <div class="comment-actions">
                    <span class="char-count">{{ content.length }}/300</span>
                    <button class="submit-btn" @click="commentClick" :disabled="content.length === 0"
                        :class="{ disabled: content.length === 0 }">
                        立即评论
                    </button>
                </div>
            </div>
        </div>

        <!-- 评论列表 -->
        <div class="comment-list">
            <div v-for="(comment, index) in commentList" :key="comment.id" class="comment-item"
                :class="{ highlighted: comment.userId === currentUserId }">
                <!-- 评论主体 -->
                <div class="comment-main">
                    <div class="comment-avatar">
                        <img :src="comment.avatar" :alt="comment.username">
                        <div v-if="comment.userId === currentUserId" class="user-badge">我</div>
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
                            <span class="time" @click="toggleReplyInput(comment)">
                                <el-icon>
                                    <chat-dot-square />
                                </el-icon>
                                {{ !comment.showReplyInput ? '回复' : '取消' }}
                            </span>
                            <span class="time" v-if="comment.userId === currentUserId"
                                @click="showDeleteConfirm(comment)">
                                <el-icon>
                                    <delete />
                                </el-icon>
                                删除
                            </span>
                            <span class="time">
                                <!-- 未点赞 -->
                                <span @click="handleUpvote(comment.id)" v-if="!comment.upvoteFlag">
                                    <img style="width: 15px;height: 15px;margin-top: 4px;" src="/upvote_default.png"
                                        alt="">
                                    {{ comment.upvoteCount }}
                                </span>
                                <!-- 已点赞 -->
                                <span v-else @click="handleUpvote(comment.id)">
                                    <img style="width: 15px;height: 15px;margin-top: 4px;" src="/upvote_active.png"
                                        alt="">
                                    {{ comment.upvoteCount }}
                                </span>
                            </span>
                        </div>
                    </div>
                </div>

                <!-- 回复输入框 -->
                <div v-if="comment.showReplyInput" class="reply-input-container">
                    <div class="reply-form">
                        <textarea v-model="replyContent" placeholder="写下你的回复..." maxlength="300"></textarea>
                        <div class="reply-actions">
                            <span class="char-count">{{ replyContent.length }}/300</span>
                            <button class="submit-btn small" @click="submitReply(comment)"
                                :disabled="replyContent.length === 0" :class="{ disabled: replyContent.length === 0 }">
                                回复
                            </button>
                        </div>
                    </div>
                </div>

                <!-- 子评论 -->
                <div class="child-comments">
                    <div v-for="child in comment.commentChildVOS" :key="child.id" class="child-comment"
                        :class="{ highlighted: child.userId === currentUserId }">
                        <div class="comment-main">
                            <div class="comment-avatar">
                                <img :src="child.avatar" :alt="child.username">
                                <div v-if="child.userId === currentUserId" class="user-badge">我</div>
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
                                    <span class="time" @click="toggleChildReplyInput(child)">
                                        <el-icon>
                                            <chat-dot-square />
                                        </el-icon>
                                        {{ !child.replyInputStatus ? '回复' : '取消' }}
                                    </span>
                                    <span class="time" v-if="child.userId === currentUserId"
                                        @click="showDeleteConfirm(child)">
                                        <el-icon>
                                            <delete />
                                        </el-icon>
                                        删除
                                    </span>
                                    <span class="time">
                                        <!-- 未点赞 -->
                                        <span @click="handleUpvote(child.id)" v-if="!child.upvoteFlag">
                                            <img style="width: 15px;height: 15px;margin-top: 4px;"
                                                src="/upvote_default.png" alt="">
                                            {{ child.upvoteCount }}
                                        </span>
                                        <!-- 已点赞 -->
                                        <span v-else @click="handleUpvote(child.id)">
                                            <img style="width: 15px;height: 15px;margin-top: 4px;"
                                                src="/upvote_active.png" alt="">
                                            {{ child.upvoteCount }}
                                        </span>
                                    </span>
                                </div>
                            </div>
                        </div>

                        <!-- 子评论的回复输入框 -->
                        <div v-if="child.replyInputStatus" class="reply-input-container">
                            <div class="reply-form">
                                <textarea v-model="replyChildContent" placeholder="写下你的回复..."
                                    maxlength="300"></textarea>
                                <div class="reply-actions">
                                    <span class="char-count">{{ replyChildContent.length }}/300</span>
                                    <button class="submit-btn small" @click="submitReply1(child)"
                                        :disabled="replyChildContent.length === 0"
                                        :class="{ disabled: replyChildContent.length === 0 }">
                                        回复
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 删除确认弹窗 -->
        <div v-if="showDeleteModal" class="modal-overlay">
            <div class="modal-content">
                <div class="modal-icon">⚠️</div>
                <h3>确认删除</h3>
                <p>删除后无法恢复，确定要删除这条评论吗？</p>
                <div class="modal-actions">
                    <button class="modal-btn cancel" @click="showDeleteModal = false">取消</button>
                    <button class="modal-btn confirm" @click="confirmDelete">删除</button>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, watch, onMounted, computed } from 'vue'
import { timeAgo } from '@/utils/date'
import { post, get, del } from "@/utils/request"
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
    // 从父组件传入的用户信息
    currentUserId: number
    userAvatar: string
    username: string
}

const props = defineProps<Props>()

// 直接使用props中的用户信息
const currentUserId = computed(() => props.currentUserId)
const userAvatar = computed(() => props.userAvatar)
const username = computed(() => props.username)

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

// 点赞处理
const handleUpvote = async (commentId: number) => {
    try {
        const response = await post('comment/upvoteOperation', { id: commentId })
        if (response.code === 200) {
            const rep = response.data

            // 更新父评论
            const parentComment = commentList.value.find(c => c.id === commentId)
            if (parentComment) {
                parentComment.upvoteCount = Number(rep.count)
                parentComment.upvoteFlag = Boolean(rep.haveUpvote)
            }

            // 更新子评论
            commentList.value.forEach(comment => {
                const childComment = comment.commentChildVOS.find(child => child.id === commentId)
                if (childComment) {
                    childComment.upvoteCount = Number(rep.count)
                    childComment.upvoteFlag = Boolean(rep.haveUpvote)
                }
            })
        }
    } catch (error) {
        console.error('点赞操作异常 ->', error)
        showToast('点赞失败', 'error')
    }
}

const showDeleteConfirm = (comment: Comment | CommentChild) => {
    commentToDelete.value = comment
    showDeleteModal.value = true
}

const confirmDelete = () => {
    if (commentToDelete.value) {
        deleteComment(commentToDelete.value)
    }
    showDeleteModal.value = false
}

const deleteComment = async (comment: Comment | CommentChild) => {
    try {
        const response = await del(`comment/${comment.id}`)
        if (response.code === 200) {
            showToast('删除成功', 'success')
            loadCommentList()
        }
    } catch (error) {
        console.error('评论异常 ->', error)
    }
}

const onFocus = () => {
    isFocused.value = true
}

const onBlur = () => {
    if (content.value === '') {
        isFocused.value = false
    }
}

const commentClick = async () => {
    if (content.value === '') {
        showToast('评论内容为空', 'info')
        return
    }

    const evaluations = {
        userId: props.currentUserId, // 使用父组件传入的userId
        username: props.username,    // 使用父组件传入的username
        avatar: props.userAvatar,    // 使用父组件传入的avatar
        contentType: props.contentType,
        content: content.value,
        contentId: props.contentId,
    }

    try {
        const response = await post('comment/insert', evaluations)
        if (response.code === 200) {
            content.value = ''
            showToast(response.message, 'success')
            setTimeout(() => {
                loadCommentList()
            }, 1100)
        } else {
            showToast(response.message, 'error')
        }
    } catch (error: any) {
        showToast(error.message, 'error')
    }
}

const toggleReplyInput = (comment: Comment) => {
    replyContent.value = ''

    // 关闭其他回复框
    commentList.value.forEach(entity => {
        if (entity.id !== comment.id && entity.showReplyInput) {
            entity.showReplyInput = false
        }
    })

    if (comment.showReplyInput === undefined) {
        comment.showReplyInput = false
    }
    comment.showReplyInput = !comment.showReplyInput
}

const toggleChildReplyInput = (comment: CommentChild) => {
    replyChildContent.value = ''
    comment.replyInputStatus = !comment.replyInputStatus
    closeOtherReplyInputs(comment.id)
}

const closeOtherReplyInputs = (currentCommentId: number) => {
    commentList.value.forEach(parentComment => {
        if (parentComment.id !== currentCommentId && parentComment.showReplyInput) {
            parentComment.showReplyInput = false
        }

        if (parentComment.commentChildVOS) {
            parentComment.commentChildVOS.forEach(childComment => {
                if (childComment.id !== currentCommentId && childComment.replyInputStatus) {
                    childComment.replyInputStatus = false
                }
            })
        }
    })
}

const submitReply = async (comment: Comment) => {
    if (replyContent.value === '') {
        showToast('评论内容不能为空', 'info')
        return
    }

    const evaluationsDTO = {
        userId: props.currentUserId, // 使用父组件传入的userId
        username: props.username,    // 使用父组件传入的username
        avatar: props.userAvatar,    // 使用父组件传入的avatar
        contentType: props.contentType,
        content: replyContent.value,
        contentId: props.contentId,
        parentId: comment.id
    }

    try {
        const response = await post('comment/insert', evaluationsDTO)
        if (response.code === 200) {
            replyContent.value = ''
            comment.showReplyInput = false
            showToast('回复成功', 'success')
            setTimeout(() => {
                loadCommentList()
            }, 1300)
        } else {
            showToast(response.message, 'error')
        }
    } catch (error: any) {
        showToast(error.message, 'error')
    }
}

const submitReply1 = async (comment: CommentChild) => {
    if (replyChildContent.value === '') {
        showToast('评论内容不能为空', 'info')
        return
    }

    const evaluationsDTO = {
        userId: props.currentUserId, // 使用父组件传入的userId
        username: props.username,    // 使用父组件传入的username
        avatar: props.userAvatar,    // 使用父组件传入的avatar
        replierId: comment.userId,
        contentType: props.contentType,
        content: replyChildContent.value,
        contentId: props.contentId,
        parentId: comment.parentId
    }

    try {
        const response = await post('comment/insert', evaluationsDTO)
        if (response.code === 200) {
            replyChildContent.value = ''
            comment.replyInputStatus = false
            showToast('回复成功', 'success')
            setTimeout(() => {
                loadCommentList()
            }, 1300)
        } else {
            showToast(response.message, 'error')
        }
    } catch (error: any) {
        showToast(error.message, 'success')
    }
}

const loadCommentList = async () => {
    try {
        const response = await get(`comment/list/${props.contentId}/${props.contentType}`)
        if (response.code === 200) {
            commentList.value = response.data.data
            evaluationsCount.value = response.data.evaluationsCount

            commentList.value.forEach(entity => {
                entity.time = timeAgo(entity.createTime)
                entity.commentChildVOS.forEach(child => {
                    child.time = timeAgo(child.createTime)
                })
            })

            // 计算总评论数
            totalComments.value = response.data.data.reduce((total: number, parentComment: any) => {
                return total + 1 + (parentComment.commentChildVOS?.length || 0)
            }, 0)

        }
    } catch (error) {
        console.error('评论查询异常 ->', error)
    }
}

const showToast = (message: string, type: 'success' | 'warning' | 'info' | 'error') => {
    ElNotification({
        type,
        title: '评论',
        message,
        duration: 1000,
        position: 'bottom-right'
    })
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