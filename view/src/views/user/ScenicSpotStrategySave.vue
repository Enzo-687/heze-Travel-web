<template>
    <div class="strategy-save-page">
        <div class="save-container">
            <div class="page-header">
                <span class="section-badge">PUBLISH</span>
                <h2 class="header-title">发布攻略</h2>
                <p class="header-sub">分享你的旅行故事，让更多人发现菏泽之美</p>
            </div>

            <div class="steps-bar">
                <div
                    v-for="(step, index) in steps"
                    :key="index"
                    class="step-item"
                    :class="{ active: activeStepIndex === index + 1, done: activeStepIndex > index + 1 }"
                    @click="activeStepIndex = index + 1"
                >
                    <div class="step-num">{{ index + 1 }}</div>
                    <span class="step-label">{{ step.label }}</span>
                    <div class="step-line" v-if="index < steps.length - 1"></div>
                </div>
            </div>

            <div class="form-card">
                <div class="form-section" v-if="activeStepIndex === 1">
                    <div class="section-title">
                        <span class="title-icon">✏️</span>
                        基本信息
                    </div>

                    <div class="form-group">
                        <label class="form-label">攻略标题 <span class="required">*</span></label>
                        <el-input
                            v-model="scenicSpotStraegy.title"
                            placeholder="请输入景点攻略标题（100字以内）"
                            maxlength="100"
                            show-word-limit
                            size="large"
                            class="form-input"
                        />
                    </div>

                    <div class="form-group">
                        <label class="form-label">封面图片 <span class="required">*</span></label>
                        <div class="upload-area">
                            <div class="cover-preview" v-if="cover">
                                <img :src="cover" alt="封面预览" />
                                <div class="cover-actions">
                                    <div class="cover-btn" @click="cover = ''">
                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                            <line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/>
                                        </svg>
                                        <span>移除</span>
                                    </div>
                                </div>
                            </div>
                            <el-upload
                                v-else
                                class="cover-uploader"
                                :action="uploadApi"
                                :show-file-list="false"
                                :on-success="handleImageSuccess"
                                :before-upload="beforeCoverUpload"
                                drag
                            >
                                <div class="upload-placeholder">
                                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                                        <rect x="3" y="3" width="18" height="18" rx="2" ry="2"/>
                                        <circle cx="8.5" cy="8.5" r="1.5"/>
                                        <polyline points="21 15 16 10 5 21"/>
                                    </svg>
                                    <div class="upload-text">点击或拖拽上传封面</div>
                                    <div class="upload-hint">支持 JPG/PNG，不超过 2MB</div>
                                </div>
                            </el-upload>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">攻略摘要 <span class="required">*</span></label>
                        <el-input
                            type="textarea"
                            :rows="4"
                            placeholder="请输入景点攻略摘要（200字以内）"
                            v-model="scenicSpotStraegy.summary"
                            maxlength="200"
                            show-word-limit
                            size="large"
                            class="form-textarea"
                        />
                    </div>
                </div>

                <div class="form-section" v-if="activeStepIndex === 2">
                    <div class="section-title">
                        <span class="title-icon">📝</span>
                        攻略内容
                    </div>
                    <WangEditor
                        :receive-content="contentWithImage"
                        height="500px"
                        :api="uploadApi"
                        @on-listener="handleContentWithImageChange"
                        class="editor-wrapper"
                    />
                </div>

                <div class="form-section" v-if="activeStepIndex === 3">
                    <div class="section-title">
                        <span class="title-icon">🔗</span>
                        关联景点
                    </div>
                    <div class="linked-spot" v-if="scenicSpot.scenicSpotId">
                        <div class="linked-badge">已关联</div>
                        <span class="linked-name">{{ scenicSpot.scenicSpotTitle }}</span>
                        <div class="linked-remove" @click="scenicSpot.scenicSpotId = null; scenicSpot.scenicSpotTitle = ''; searchKey = ''">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/>
                            </svg>
                        </div>
                    </div>
                    <el-autocomplete
                        style="width: 100%;"
                        v-model="searchKey"
                        :fetch-suggestions="querySearchAsync"
                        placeholder="输入景点名称搜索关联..."
                        @select="handleSelect"
                        size="large"
                    />
                </div>
            </div>

            <div class="action-bar">
                <div
                    class="action-btn prev"
                    :class="{ disabled: activeStepIndex === 1 }"
                    @click="last"
                >
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M19 12H5M12 19l-7-7 7-7"/>
                    </svg>
                    上一步
                </div>
                <div class="action-right">
                    <div
                        class="action-btn next"
                        :class="{ disabled: activeStepIndex === 3 }"
                        @click="next"
                    >
                        下一步
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M5 12h14M12 5l7 7-7 7"/>
                        </svg>
                    </div>
                    <div
                        class="action-btn submit"
                        v-if="activeStepIndex === 3"
                        @click="saveScenicSpotStraegy"
                    >
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="20 6 9 17 4 12"/>
                        </svg>
                        发布攻略
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ElMessage, ElNotification } from "element-plus"
import { ref, reactive } from "vue"
import WangEditor from '@/components/Editor.vue'
import type { ScenicSpotStrategy } from "@/types/scenic-spot-strategy"
import { addScenciSpotStrategyApi } from "@/api/scenic-spot-strategy-api"
import { queryScenicSpotApi } from "@/api/scenic-spot-api"
import router from "@/router"

const searchKey = ref('')
const scenicSpot = ref({
    scenicSpotId: null as number | null,
    scenicSpotTitle: ''
})
const activeStepIndex = ref(1)
const scenicSpotStraegy = reactive<Partial<ScenicSpotStrategy>>({})
const cover = ref('')
const steps = [
    { label: "基本信息" },
    { label: "攻略内容" },
    { label: "关联景点" }
]

const uploadApi = ref('http://localhost:21090/api/v1.0/online-travel-api/file/upload')
const contentWithImage = ref('<p>介绍景点攻略吧</p>')

const handleSelect = (item: any) => {
    scenicSpot.value.scenicSpotId = item.id
    scenicSpot.value.scenicSpotTitle = item.value
}

const querySearchAsync = async (queryString: string, cb: any) => {
    try {
        const { data } = await queryScenicSpotApi({
            title: queryString,
            current: 1,
            size: 100
        } as any)
        const suggestions = (data || []).map((item: any) => ({
            value: item.title,
            id: item.id,
            ...item
        }))
        cb(suggestions)
    } catch (error) {
        console.log("查询景点数据异常")
    }
}

const next = () => {
    if (activeStepIndex.value < 3) activeStepIndex.value++
}
const last = () => {
    if (activeStepIndex.value > 1) activeStepIndex.value--
}

const beforeCoverUpload = (file: File) => {
    const isJPGOrPNG = file.type === 'image/jpeg' || file.type === 'image/png'
    const isLt2M = file.size / 1024 / 1024 < 2
    if (!isJPGOrPNG) {
        ElMessage.error('封面只能是 JPG/PNG 格式!')
        return false
    }
    if (!isLt2M) {
        ElMessage.error('封面大小不能超过 2MB!')
        return false
    }
    return true
}

const handleImageSuccess = (response: any) => {
    if (response.code === 200) {
        cover.value = response.data
        ElMessage.success('封面上传成功')
    } else {
        ElMessage.error(response.message || '封面上传失败')
    }
}

const handleContentWithImageChange = (newContent: string) => {
    contentWithImage.value = newContent
}

const saveScenicSpotStraegy = async () => {
    if (!scenicSpotStraegy.title) {
        ElNotification.warning({ title: '参数校验', message: '标题不为空', duration: 1500, position: 'bottom-right' })
        return
    }
    if (!cover.value) {
        ElNotification.warning({ title: '封面检验', message: '请上传封面', duration: 1500, position: 'bottom-right' })
        return
    }
    if (!scenicSpotStraegy.summary) {
        ElNotification.warning({ title: '参数校验', message: '请补充摘要', duration: 1500, position: 'bottom-right' })
        return
    }
    if (!contentWithImage.value) {
        ElNotification.warning({ title: '参数校验', message: '请补充景点攻略介绍', duration: 1500, position: 'bottom-right' })
        return
    }
    scenicSpotStraegy.cover = cover.value
    scenicSpotStraegy.content = contentWithImage.value
    if (!scenicSpot.value.scenicSpotId) {
        ElNotification.warning({ title: '参数校验', message: '请选择关联景点', duration: 1500, position: 'bottom-right' })
        return
    }
    scenicSpotStraegy.scenicSpotId = scenicSpot.value.scenicSpotId
    try {
        await addScenciSpotStrategyApi(scenicSpotStraegy as any)
        ElMessage.success('景点攻略新增成功')
        router.push('/user')
    } catch (error: any) {
        console.log('景点攻略新增异常：', error)
        ElMessage.error(`景点攻略新增异常： ${error}`)
    }
}
</script>

<style lang="scss" scoped>
.strategy-save-page {
    min-height: 100vh;
    background: #FAFAFA;
    padding: 32px 0 60px;
}

.save-container {
    max-width: 860px;
    margin: 0 auto;
    padding: 0 24px;
}

.page-header {
    margin-bottom: 32px;

    .section-badge {
        display: inline-block;
        width: fit-content;
        padding: 4px 14px;
        background: rgba(166, 27, 46, 0.08);
        color: var(--primary-color);
        font-size: 11px;
        font-weight: 700;
        letter-spacing: 3px;
        border-radius: 100px;
        margin-bottom: 12px;
    }

    .header-title {
        font-family: var(--font-serif);
        font-size: 28px;
        font-weight: 700;
        color: var(--text-main);
        letter-spacing: 2px;
        margin-bottom: 8px;
    }

    .header-sub {
        font-size: 14px;
        color: var(--text-light);
        letter-spacing: 1px;
    }
}

.steps-bar {
    display: flex;
    align-items: center;
    margin-bottom: 32px;
    background: white;
    border: 1px solid rgba(0, 0, 0, 0.06);
    border-radius: 16px;
    padding: 20px 32px;

    .step-item {
        display: flex;
        align-items: center;
        gap: 10px;
        cursor: pointer;
        flex: 1;

        .step-num {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            font-weight: 700;
            background: #F0F1F3;
            color: var(--text-light);
            transition: all 0.3s;
            flex-shrink: 0;
        }

        .step-label {
            font-size: 14px;
            font-weight: 500;
            color: var(--text-light);
            transition: all 0.3s;
            white-space: nowrap;
        }

        .step-line {
            flex: 1;
            height: 2px;
            background: #ECEEF0;
            margin: 0 16px;
            border-radius: 1px;
        }

        &.active {
            .step-num {
                background: var(--primary-color);
                color: white;
                box-shadow: 0 4px 12px rgba(166, 27, 46, 0.3);
            }
            .step-label {
                color: var(--text-main);
                font-weight: 600;
            }
        }

        &.done {
            .step-num {
                background: rgba(166, 27, 46, 0.1);
                color: var(--primary-color);
            }
            .step-label {
                color: var(--primary-color);
            }
            .step-line {
                background: var(--primary-color);
            }
        }
    }
}

.form-card {
    background: white;
    border: 1px solid rgba(0, 0, 0, 0.06);
    border-radius: 16px;
    padding: 32px;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.03);
}

.form-section {
    .section-title {
        display: flex;
        align-items: center;
        gap: 8px;
        font-family: var(--font-serif);
        font-size: 18px;
        font-weight: 600;
        color: var(--text-main);
        letter-spacing: 1px;
        margin-bottom: 24px;
        padding-bottom: 16px;
        border-bottom: 1px solid #ECEEF0;

        .title-icon { font-size: 18px; }
    }
}

.form-group {
    margin-bottom: 24px;

    .form-label {
        display: block;
        font-size: 14px;
        font-weight: 600;
        color: var(--text-main);
        margin-bottom: 8px;

        .required {
            color: var(--primary-color);
            margin-left: 2px;
        }
    }

    .form-input, .form-textarea {
        width: 100%;
    }
}

.upload-area {
    .cover-preview {
        position: relative;
        width: 280px;
        height: 180px;
        border-radius: 12px;
        overflow: hidden;
        border: 2px solid rgba(0, 0, 0, 0.06);

        img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .cover-actions {
            position: absolute;
            inset: 0;
            background: rgba(0, 0, 0, 0.4);
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 0;
            transition: opacity 0.3s;

            .cover-btn {
                display: flex;
                align-items: center;
                gap: 6px;
                padding: 8px 20px;
                background: white;
                border-radius: 100px;
                font-size: 13px;
                font-weight: 500;
                color: var(--text-main);
                cursor: pointer;
                transition: all 0.2s;

                &:hover { background: #F5F5F5; }
            }
        }

        &:hover .cover-actions { opacity: 1; }
    }

    .cover-uploader {
        width: 100%;

        :deep(.el-upload-dragger) {
            border: 2px dashed rgba(0, 0, 0, 0.1);
            border-radius: 12px;
            background: #FAFAFA;
            padding: 40px;
            transition: all 0.3s;

            &:hover {
                border-color: var(--primary-color);
                background: rgba(166, 27, 46, 0.02);
            }
        }

        .upload-placeholder {
            text-align: center;

            svg { color: var(--text-light); margin-bottom: 12px; }

            .upload-text {
                font-size: 14px;
                font-weight: 500;
                color: var(--text-secondary);
                margin-bottom: 4px;
            }

            .upload-hint {
                font-size: 12px;
                color: var(--text-light);
            }
        }
    }
}

.linked-spot {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 12px 16px;
    background: rgba(166, 27, 46, 0.04);
    border: 1px solid rgba(166, 27, 46, 0.12);
    border-radius: 10px;
    margin-bottom: 16px;

    .linked-badge {
        padding: 2px 10px;
        background: var(--primary-color);
        color: white;
        font-size: 11px;
        font-weight: 600;
        border-radius: 100px;
        letter-spacing: 1px;
    }

    .linked-name {
        font-size: 14px;
        font-weight: 500;
        color: var(--text-main);
        flex: 1;
    }

    .linked-remove {
        width: 28px;
        height: 28px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        color: var(--text-light);
        cursor: pointer;
        transition: all 0.2s;

        &:hover { background: rgba(0, 0, 0, 0.06); color: var(--text-main); }
    }
}

.editor-wrapper {
    border: 1px solid rgba(0, 0, 0, 0.08);
    border-radius: 12px;
    overflow: hidden;
}

.action-bar {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-top: 28px;

    .action-btn {
        display: flex;
        align-items: center;
        gap: 8px;
        padding: 12px 28px;
        border-radius: 100px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
        letter-spacing: 0.5px;

        &.prev {
            background: white;
            border: 1px solid rgba(0, 0, 0, 0.1);
            color: var(--text-secondary);

            &:hover { border-color: rgba(0, 0, 0, 0.2); color: var(--text-main); }
            &.disabled { opacity: 0.4; cursor: not-allowed; pointer-events: none; }
        }

        &.next {
            background: white;
            border: 1px solid rgba(0, 0, 0, 0.1);
            color: var(--text-secondary);

            &:hover { border-color: var(--primary-color); color: var(--primary-color); }
            &.disabled { opacity: 0.4; cursor: not-allowed; pointer-events: none; }
        }

        &.submit {
            background: var(--primary-color);
            color: white;
            border: none;
            box-shadow: 0 4px 16px rgba(166, 27, 46, 0.3);

            &:hover { background: var(--primary-light); transform: translateY(-1px); box-shadow: 0 6px 20px rgba(166, 27, 46, 0.35); }
        }
    }

    .action-right {
        display: flex;
        gap: 12px;
    }
}

:deep(.el-input__wrapper) {
    border-radius: 10px;
    box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.1) inset;

    &:hover { box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.2) inset; }
    &.is-focus { box-shadow: 0 0 0 1px var(--primary-color) inset; }
}

:deep(.el-textarea__inner) {
    border-radius: 10px;
    border-color: rgba(0, 0, 0, 0.1);

    &:hover { border-color: rgba(0, 0, 0, 0.2); }
    &:focus { border-color: var(--primary-color); }
}

@media (max-width: 768px) {
    .save-container { padding: 0 16px; }
    .form-card { padding: 20px; }
    .steps-bar { padding: 16px; }
    .steps-bar .step-item .step-label { display: none; }
    .steps-bar .step-item .step-line { margin: 0 8px; }
    .action-bar { flex-direction: column; gap: 12px; }
    .action-right { width: 100%; justify-content: flex-end; }
}
</style>
