<template>
  <div class="peony-3d-container" ref="containerRef">
    <div v-if="loading" class="loading-overlay">
      <div class="loading-spinner"></div>
    </div>
    <div class="interaction-hint" v-if="showHint">
      <span>🖱️ 拖动旋转 · 滚轮缩放</span>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import * as THREE from 'three'
import { GLTFLoader } from 'three/addons/loaders/GLTFLoader.js'
import { DRACOLoader } from 'three/addons/loaders/DRACOLoader.js'
import { OrbitControls } from 'three/addons/controls/OrbitControls.js'

const props = withDefaults(defineProps<{
  modelUrl?: string
  autoRotate?: boolean
  rotateSpeed?: number
}>(), {
  modelUrl: '/models/peony.glb',
  autoRotate: true,
  rotateSpeed: 0.003,
})

const containerRef = ref<HTMLElement>()
const loading = ref(true)
const showHint = ref(true)
const isMounted = ref(false)

let scene: THREE.Scene
let camera: THREE.PerspectiveCamera
let renderer: THREE.WebGLRenderer
let controls: OrbitControls
let model: THREE.Group
let animationId: number
let hintTimer: ReturnType<typeof setTimeout>

const init = () => {
  if (!containerRef.value) return

  const container = containerRef.value
  const width = container.clientWidth
  const height = container.clientHeight

  scene = new THREE.Scene()

  camera = new THREE.PerspectiveCamera(35, width / height, 0.1, 1000)
  camera.position.set(0, 2, 6)

  renderer = new THREE.WebGLRenderer({
    antialias: true,
    alpha: true,
    powerPreference: 'high-performance',
  })
  renderer.setSize(width, height)
  renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))
  renderer.toneMapping = THREE.ACESFilmicToneMapping
  renderer.toneMappingExposure = 1.4
  renderer.outputColorSpace = THREE.SRGBColorSpace
  renderer.shadowMap.enabled = true
  renderer.shadowMap.type = THREE.PCFSoftShadowMap
  container.appendChild(renderer.domElement)

  controls = new OrbitControls(camera, renderer.domElement)
  controls.enableDamping = true
  controls.dampingFactor = 0.08
  controls.enablePan = false
  controls.minDistance = 2
  controls.maxDistance = 15
  controls.minPolarAngle = 0.2
  controls.maxPolarAngle = Math.PI - 0.2
  controls.autoRotate = props.autoRotate
  controls.autoRotateSpeed = 1.5
  controls.target.set(0, 0.5, 0)
  controls.update()

  controls.addEventListener('start', () => {
    showHint.value = false
  })

  const ambientLight = new THREE.AmbientLight(0xffffff, 0.8)
  scene.add(ambientLight)

  const mainLight = new THREE.DirectionalLight(0xfff5f0, 1.8)
  mainLight.position.set(4, 6, 5)
  mainLight.castShadow = true
  mainLight.shadow.mapSize.width = 1024
  mainLight.shadow.mapSize.height = 1024
  scene.add(mainLight)

  const fillLight = new THREE.DirectionalLight(0xE38995, 0.6)
  fillLight.position.set(-3, 3, 2)
  scene.add(fillLight)

  const rimLight = new THREE.DirectionalLight(0xC4364A, 0.5)
  rimLight.position.set(-2, 1, -4)
  scene.add(rimLight)

  const bottomLight = new THREE.PointLight(0xF1B7BE, 0.4, 8)
  bottomLight.position.set(0, -2, 2)
  scene.add(bottomLight)

  hintTimer = setTimeout(() => {
    showHint.value = false
  }, 5000)

  loadModel()
}

const loadModel = () => {
  const loader = new GLTFLoader()

  const dracoLoader = new DRACOLoader()
  dracoLoader.setDecoderPath('https://www.gstatic.com/draco/versioned/decoders/1.5.6/')
  loader.setDRACOLoader(dracoLoader)

  loader.load(
    props.modelUrl,
    (gltf) => {
      if (!isMounted.value) return
      
      model = gltf.scene

      const box = new THREE.Box3().setFromObject(model)
      const size = box.getSize(new THREE.Vector3())
      const center = box.getCenter(new THREE.Vector3())

      const maxDim = Math.max(size.x, size.y, size.z)
      const targetSize = 5
      const scale = targetSize / maxDim
      model.scale.setScalar(scale)

      model.position.sub(center.multiplyScalar(scale))
      model.position.y += 0.5

      model.traverse((child) => {
        if ((child as THREE.Mesh).isMesh) {
          child.castShadow = true
          child.receiveShadow = true

          const mesh = child as THREE.Mesh
          if (mesh.material) {
            const materials = Array.isArray(mesh.material)
              ? mesh.material
              : [mesh.material]

            materials.forEach((mat) => {
              if (mat instanceof THREE.MeshStandardMaterial) {
                mat.envMapIntensity = 1.0
              }
            })
          }
        }
      })

      scene.add(model)
      loading.value = false

      const newBox = new THREE.Box3().setFromObject(model)
      const newCenter = newBox.getCenter(new THREE.Vector3())
      controls.target.copy(newCenter)
      controls.update()

      animate()
    },
    (progress) => {
      if (progress.total > 0) {
        const percent = (progress.loaded / progress.total) * 100
        console.log(`牡丹模型加载: ${percent.toFixed(1)}%`)
      }
    },
    (error) => {
      if (!isMounted.value) return
      console.warn('GLB 模型加载失败，使用备用几何形状:', error.message)
      loading.value = false
      createFallbackPeony()
    }
  )
}

const createFallbackPeony = () => {
  const group = new THREE.Group()

  const petalShape = new THREE.Shape()
  petalShape.moveTo(0, 0)
  petalShape.bezierCurveTo(0.5, 0.3, 0.4, 0.7, 0, 1)
  petalShape.bezierCurveTo(-0.4, 0.7, -0.5, 0.3, 0, 0)

  const petalGeometry = new THREE.ShapeGeometry(petalShape, 32)
  const petalMaterial = new THREE.MeshPhysicalMaterial({
    color: 0xC4364A,
    side: THREE.DoubleSide,
    transparent: true,
    opacity: 0.85,
    roughness: 0.35,
    clearcoat: 0.5,
  })

  for (let i = 0; i < 8; i++) {
    const petal = new THREE.Mesh(petalGeometry, petalMaterial.clone())
    petal.rotation.y = (i / 8) * Math.PI * 2
    petal.rotation.x = -0.4
    petal.position.y = 0.2
    group.add(petal)
  }

  group.position.y = 0.5
  model = group
  scene.add(model)
  animate()
}

const animate = () => {
  animationId = requestAnimationFrame(animate)
  controls.update()
  renderer.render(scene, camera)
}

const handleResize = () => {
  if (!containerRef.value) return
  const width = containerRef.value.clientWidth
  const height = containerRef.value.clientHeight
  camera.aspect = width / height
  camera.updateProjectionMatrix()
  renderer.setSize(width, height)
}

onMounted(() => {
  isMounted.value = true
  init()
  window.addEventListener('resize', handleResize)
})

onUnmounted(() => {
  isMounted.value = false
  window.removeEventListener('resize', handleResize)
  if (hintTimer) clearTimeout(hintTimer)
  if (animationId) cancelAnimationFrame(animationId)
  if (controls) controls.dispose()
  if (renderer) {
    renderer.dispose()
    containerRef.value?.removeChild(renderer.domElement)
  }
  if (model) {
    model.traverse((child) => {
      if ((child as THREE.Mesh).isMesh) {
        const mesh = child as THREE.Mesh
        mesh.geometry?.dispose()
        if (mesh.material) {
          const materials = Array.isArray(mesh.material)
            ? mesh.material
            : [mesh.material]
          materials.forEach((m) => m.dispose())
        }
      }
    })
  }
})
</script>

<style scoped>
.peony-3d-container {
  width: 100%;
  height: 100%;
  position: relative;
  cursor: grab;

  &:active {
    cursor: grabbing;
  }
}

.loading-overlay {
  position: absolute;
  inset: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  background: transparent;
}

.loading-spinner {
  width: 40px;
  height: 40px;
  border: 3px solid rgba(166, 27, 46, 0.2);
  border-top-color: #A61B2E;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

.interaction-hint {
  position: absolute;
  bottom: 20px;
  left: 50%;
  transform: translateX(-50%);
  padding: 8px 20px;
  background: rgba(0, 0, 0, 0.5);
  backdrop-filter: blur(10px);
  border-radius: 100px;
  color: rgba(255, 255, 255, 0.7);
  font-size: 13px;
  letter-spacing: 1px;
  pointer-events: none;
  animation: hintFadeIn 0.6s ease, hintFadeOut 0.6s ease 4.4s forwards;
  white-space: nowrap;
}

@keyframes hintFadeIn {
  from { opacity: 0; transform: translateX(-50%) translateY(10px); }
  to { opacity: 1; transform: translateX(-50%) translateY(0); }
}

@keyframes hintFadeOut {
  from { opacity: 1; }
  to { opacity: 0; }
}
</style>
