<template>
    <div class="wang-editor-container">
        <div ref="toolbarRef" class="toolbar"></div>
        <div ref="editorRef" class="editor" :style="{ height: props.height }"></div>
    </div>
</template>

<script setup>
import { ref, watch, onBeforeUnmount, onMounted, nextTick, computed, defineExpose } from 'vue'
import { createEditor, createToolbar } from '@wangeditor/editor'
import '@wangeditor/editor/dist/css/style.css'

// 定义 props
const props = defineProps({
    receiveContent: {
        type: String,
        default: '<p>创作内容</p>',
        required: true
    },
    height: {
        type: String,
        default: '500px'
    },
    api: {
        type: String,
        default: '',
    }
})

// 定义 emits
const emit = defineEmits(['on-listener'])

// 响应式数据
const editorRef = ref(null)
const toolbarRef = ref(null)
const editorInstance = ref(null)
const contentHtml = ref('')
const isEditorReady = ref(false)

// 工具栏配置 - 简化配置
const toolbarConfig = {
    excludeKeys: [
        'group-video',
        'codeBlock',
        'todo',
        'insertTable',
        'group-more-style',
        'bgColor',
        'bold',
        'underline',
        'italic',
        'insertLink',
        'divider',
        'blockquote'
    ]
}

// 编辑器配置
const editorConfig = {
    placeholder: '请输入内容...',
    MENU_CONF: {
        uploadImage: {
            server: props.api,
            fieldName: 'file',
            maxFileSize: 10 * 1024 * 1024,
            maxNumberOfFiles: 10,
            metaWithUrl: false,
            withCredentials: false,
            timeout: 10 * 1000,
            customInsert: (res, insertFn) => {
                if (res.code === 200) {
                    insertFn(res.data, res.data, res.data)
                } else {
                    throw new Error(res.message || '上传失败')
                }
            },
        },
    }
}

// 初始化编辑器
const initEditor = () => {
    if (!editorRef.value || !toolbarRef.value) {
        console.warn('编辑器容器未找到')
        return
    }
    
    try {
        // 如果已存在编辑器实例，先销毁
        if (editorInstance.value) {
            editorInstance.value.destroy()
            editorInstance.value = null
        }
        
        // 创建编辑器
        editorInstance.value = createEditor({
            selector: editorRef.value,
            config: editorConfig,
            mode: 'default',
            html: props.receiveContent || '<p>创作内容</p>'
        })
        
        // 创建工具栏
        createToolbar({
            editor: editorInstance.value,
            selector: toolbarRef.value,
            config: toolbarConfig,
            mode: 'default'
        })
        
        // 设置初始内容
        contentHtml.value = props.receiveContent || '<p>创作内容</p>'
        
        // 监听内容变化
        editorInstance.value.on('change', () => {
            const newContent = editorInstance.value.getHtml()
            contentHtml.value = newContent
            emit('on-listener', newContent)
        })
        
        // 标记编辑器已就绪
        isEditorReady.value = true
        
        // 应用默认样式
        setTimeout(() => {
            applyDefaultStyles()
        }, 50)
        
        console.log('WangEditor 初始化成功')
    } catch (error) {
        console.error('WangEditor 初始化失败:', error)
        showFallbackEditor()
    }
}

// 强制设置编辑器内容
const setEditorContent = (content) => {
    if (!editorInstance.value) return
    
    try {
        // 保存当前选区（光标位置）
        const selection = editorInstance.value.selection.saveSelection()
        
        // 设置内容
        editorInstance.value.setHtml(content || '<p>创作内容</p>')
        contentHtml.value = content || '<p>创作内容</p>'
        
        // 恢复选区
        if (selection) {
            editorInstance.value.selection.restoreSelection(selection)
        }
        
        console.log('编辑器内容设置成功')
    } catch (error) {
        console.error('设置编辑器内容失败:', error)
    }
}

// 应用默认样式
const applyDefaultStyles = () => {
    if (!editorInstance.value) return
    
    // 获取编辑器DOM元素
    const textContainer = editorRef.value?.querySelector('.w-e-text-container')
    if (textContainer) {
        // 设置编辑器内容区域的默认样式
        const contentArea = textContainer.querySelector('.w-e-text')
        if (contentArea) {
            contentArea.style.fontSize = '18px'
            contentArea.style.fontFamily = '仿宋, FangSong, serif'
            contentArea.style.lineHeight = '1.6'
        }
    }
}

// 降级方案
const showFallbackEditor = () => {
    if (editorRef.value) {
        editorRef.value.innerHTML = `
            <div style="padding: 20px; text-align: center; color: #666;">
                <p>编辑器加载失败，请刷新页面重试</p>
                <textarea 
                    style="width: 100%; height: 200px; padding: 10px; border: 1px solid #ddd; border-radius: 4px; font-size: 18px; font-family: 仿宋, FangSong, serif;" 
                    placeholder="请输入内容..."
                >${props.receiveContent}</textarea>
            </div>
        `
    }
}

// 监听 props.receiveContent 变化
watch(() => props.receiveContent, (newVal, oldVal) => {
    console.log('收到新内容:', newVal ? newVal.substring(0, 100) : '空内容')
    console.log('旧内容:', oldVal ? oldVal.substring(0, 100) : '空内容')
    
    if (newVal === oldVal) {
        console.log('内容未变化，跳过设置')
        return
    }
    
    if (editorInstance.value) {
        console.log('编辑器已就绪，设置新内容')
        setEditorContent(newVal)
    } else {
        console.log('编辑器未就绪，等待初始化')
        // 如果编辑器未就绪，等待一下再设置
        setTimeout(() => {
            if (editorInstance.value) {
                setEditorContent(newVal)
            }
        }, 100)
    }
}, { immediate: true, deep: true })

// 组件挂载时初始化编辑器
onMounted(() => {
    console.log('Editor 组件挂载，开始初始化')
    initEditor()
})

// 组件卸载前销毁编辑器
onBeforeUnmount(() => {
    if (editorInstance.value) {
        editorInstance.value.destroy()
        editorInstance.value = null
    }
})

// 暴露方法给父组件
defineExpose({
    setEditorContent
})
</script>

<style scoped>

</style>