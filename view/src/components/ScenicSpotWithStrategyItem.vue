<template>
    <div class="strategy-section">
        <div class="section-header">
            <div class="header-line"></div>
            <div class="header-center">
                <h3 class="header-title">{{ title }}</h3>
                <p class="header-sub">{{ subTitle }}</p>
            </div>
            <div class="header-line"></div>
        </div>
        <div class="strategy-grid">
            <div v-for="strategy in scenicSpotStrategyList" :key="strategy.id" class="strategy-card" @click="view(strategy.id)">
                <div class="card-cover">
                    <img :src="strategy.cover" :alt="strategy.title" />
                    <div class="cover-overlay">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2">
                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>
                        </svg>
                    </div>
                    <div class="user-badge">
                        <img :src="strategy.avatar" :alt="strategy.username" class="user-avatar" />
                        <span class="user-name">{{ strategy.username }}</span>
                    </div>
                </div>
                <div class="card-body">
                    <h4 class="card-title">{{ strategy.title }}</h4>
                    <p class="card-summary" v-if="strategy.summary">{{ strategy.summary }}</p>
                </div>
            </div>
        </div>
        <div class="section-footer">
            <div class="search-btn" @click.stop="handleScenicSpotStrategySearch">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/>
                </svg>
                查看更多攻略
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
const props = defineProps<{
    scenicSpotStrategyList: Array<{
        id?: number
        title?: string
        cover?: string
        summary?: string
        createTime?: Date
        avatar?: string
        username?: string
        auditStatus?: boolean
    }>;
    title: string;
    subTitle: string;
}>()

const emit = defineEmits<{
    (e: 'view', id: number): void,
    (e: 'search', id: number | null): void,
}>()

const view = (id: number | undefined) => {
    if (!id) return
    emit('view', id)
}

const handleScenicSpotStrategySearch = () => {
    emit('search', null)
}
</script>

<style lang="scss" scoped>
.strategy-section {
    padding: 20px 0;
}

.section-header {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 20px;
    margin-bottom: 28px;

    .header-line {
        width: 60px;
        height: 1px;
        background: rgba(0, 0, 0, 0.1);
    }

    .header-center {
        text-align: center;
    }

    .header-title {
        font-family: var(--font-serif);
        font-size: 20px;
        font-weight: 700;
        color: var(--text-main);
        letter-spacing: 2px;
        margin-bottom: 4px;
    }

    .header-sub {
        font-size: 13px;
        color: var(--text-light);
        letter-spacing: 1px;
    }
}

.strategy-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 20px;
}

.strategy-card {
    background: white;
    border: 1px solid rgba(0, 0, 0, 0.06);
    border-radius: 14px;
    overflow: hidden;
    cursor: pointer;
    transition: all 0.35s cubic-bezier(0.16, 1, 0.3, 1);

    &:hover {
        transform: translateY(-4px);
        box-shadow: 0 12px 36px rgba(0, 0, 0, 0.08);
        border-color: rgba(166, 27, 46, 0.12);

        .card-cover img {
            transform: scale(1.05);
        }

        .cover-overlay {
            opacity: 1;
        }
    }

    .card-cover {
        position: relative;
        height: 180px;
        overflow: hidden;

        img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }

        .cover-overlay {
            position: absolute;
            inset: 0;
            background: rgba(0, 0, 0, 0.3);
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 0;
            transition: opacity 0.3s;
        }

        .user-badge {
            position: absolute;
            top: 10px;
            left: 10px;
            display: flex;
            align-items: center;
            gap: 6px;
            padding: 4px 12px 4px 4px;
            background: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(8px);
            border-radius: 100px;

            .user-avatar {
                width: 22px;
                height: 22px;
                border-radius: 50%;
                object-fit: cover;
                border: 1.5px solid rgba(255, 255, 255, 0.4);
            }

            .user-name {
                font-size: 12px;
                color: rgba(255, 255, 255, 0.9);
                font-weight: 500;
            }
        }
    }

    .card-body {
        padding: 16px;

        .card-title {
            font-size: 15px;
            font-weight: 600;
            color: var(--text-main);
            letter-spacing: 0.5px;
            margin-bottom: 6px;
            display: -webkit-box;
            -webkit-box-orient: vertical;
            -webkit-line-clamp: 2;
            overflow: hidden;
            text-overflow: ellipsis;
            line-height: 1.5;
            transition: color 0.2s;
        }

        .card-summary {
            font-size: 13px;
            color: var(--text-light);
            line-height: 1.6;
            display: -webkit-box;
            -webkit-box-orient: vertical;
            -webkit-line-clamp: 2;
            overflow: hidden;
            text-overflow: ellipsis;
        }
    }

    &:hover .card-title {
        color: var(--primary-color);
    }
}

.section-footer {
    display: flex;
    justify-content: center;
    margin-top: 24px;

    .search-btn {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 8px 24px;
        border-radius: 100px;
        font-size: 14px;
        font-weight: 500;
        color: var(--text-secondary);
        background: #F5F5F5;
        cursor: pointer;
        transition: all 0.3s;
        letter-spacing: 1px;

        &:hover {
            background: rgba(166, 27, 46, 0.06);
            color: var(--primary-color);
        }
    }
}

@media (max-width: 768px) {
    .strategy-grid {
        grid-template-columns: repeat(2, 1fr);
        gap: 14px;
    }

    .strategy-card .card-cover {
        height: 140px;
    }
}

@media (max-width: 480px) {
    .strategy-grid {
        grid-template-columns: 1fr;
    }
}
</style>
