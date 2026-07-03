<template>
  <section id="video" class="video-section section-mystery-decoration">
    <div class="container">
      <div class="video-header fade-in-up">
        <div class="section-tag">
          <el-icon><VideoPlay /></el-icon>
          <span>视频攻略</span>
        </div>
        <h2 class="section-title">
          <span class="gold-gradient-text">操作集锦</span>
          <span class="section-sub">· 绝活哥的连招艺术</span>
        </h2>
        <p class="section-desc">
          精选元歌国服绝活哥精彩操作视频，可在下方列表切换主播内容
        </p>
      </div>

      <div class="video-main fade-in-up">
        <div class="video-player-wrapper glow-border">
          <div v-if="allVideos.length === 0" class="video-placeholder">
            <div class="placeholder-icon">
              <el-icon :size="64"><Film /></el-icon>
            </div>
            <h3 class="placeholder-title">暂无视频文件</h3>
            <p class="placeholder-desc">
              请将您的元歌操作视频放入项目 <span>src/video/</span> 文件夹
            </p>
            <div class="placeholder-tips">
              <div class="tip-item">
                <el-icon><CircleCheck /></el-icon>
                <span>支持 MP4 格式</span>
              </div>
              <div class="tip-item">
                <el-icon><CircleCheck /></el-icon>
                <span>支持 WebM 格式</span>
              </div>
              <div class="tip-item">
                <el-icon><CircleCheck /></el-icon>
                <span>B站嵌入视频自动加载</span>
              </div>
            </div>
          </div>

          <div v-else class="video-container" :class="{ 'bili-mode': currentVideo?.type === 'bili' }">
            <template v-if="currentVideo?.type === 'bili'">
              <iframe
                :key="currentVideo.bvid"
                class="bili-iframe"
                :src="currentVideo.url"
                :title="currentVideo.name"
                scrolling="no"
                frameborder="no"
                framespacing="0"
                allowfullscreen="true"
                allow="autoplay; fullscreen; encrypted-media"
                referrerpolicy="no-referrer-when-downgrade"
              ></iframe>
              <div class="bili-video-info">
                <div class="bili-author">
                  <el-icon><User /></el-icon>
                  <span>主播：{{ currentVideo.author }}</span>
                </div>
                <div class="bili-source">
                  <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 24 24' fill='%2300A1D6'%3E%3Cpath d='M17.813 4.653h.854c1.51.054 2.769.578 3.773 1.574 1.004.995 1.524 2.249 1.56 3.76v7.36c-.036 1.51-.556 2.769-1.56 3.773s-2.262 1.524-3.773 1.56H5.333c-1.51-.036-2.769-.556-3.773-1.56S.036 18.858 0 17.347v-7.36c.036-1.511.556-2.765 1.56-3.76 1.004-.996 2.262-1.52 3.773-1.574h.774l-1.174-1.12a1.234 1.234 0 0 1-.373-.906c0-.356.124-.659.373-.907l.027-.027c.267-.249.573-.373.92-.373.347 0 .653.124.92.373L9.653 4.44c.071.071.134.142.187.213h4.267a.836.836 0 0 1 .16-.213l2.853-2.747c.267-.249.573-.373.92-.373.347 0 .662.151.929.4.267.249.391.551.391.907 0 .355-.124.657-.373.906zM5.333 7.24c-.746.018-1.373.276-1.88.773-.506.498-.769 1.13-.786 1.894v7.52c.017.764.28 1.395.786 1.893.507.498 1.134.756 1.88.773h13.334c.746-.017 1.373-.275 1.88-.773.506-.498.769-1.129.786-1.893v-7.52c-.017-.765-.28-1.396-.786-1.894-.507-.497-1.134-.755-1.88-.773zM8 11.107c.373 0 .684.124.933.373.25.249.383.569.4.96v1.173c-.017.391-.15.711-.4.96-.249.25-.56.374-.933.374s-.684-.125-.933-.374c-.25-.249-.383-.569-.4-.96V12.44c0-.373.129-.689.386-.947.258-.257.574-.386.947-.386zm8 0c.373 0 .684.124.933.373.25.249.383.569.4.96v1.173c-.017.391-.15.711-.4.96-.249.25-.56.374-.933.374s-.684-.125-.933-.374c-.25-.249-.383-.569-.4-.96V12.44c.017-.391.15-.711.4-.96.249-.249.56-.373.933-.373z'/%3E%3C/svg%3E" alt="bilibili" style="vertical-align:middle;margin-right:4px" />
                  <span>哔哩哔哩</span>
                </div>
              </div>
            </template>

            <template v-else>
              <video
                ref="videoRef"
                class="video-element"
                :src="currentVideo?.url"
                :poster="videoPoster"
                :autoplay="true"
                :muted="isMuted"
                :loop="isLooping"
                :playsinline="true"
                preload="metadata"
                @loadedmetadata="onLoadedMetadata"
                @timeupdate="onTimeUpdate"
                @play="onPlay"
                @pause="onPause"
                @ended="onEnded"
                @click="togglePlay"
              ></video>

              <div
                class="video-overlay"
                :class="{ hidden: isPlaying && !showControls }"
                @click="togglePlay"
              >
                <div v-if="!isPlaying" class="play-button">
                  <el-icon :size="48"><VideoPlay /></el-icon>
                </div>
              </div>

              <div
                class="video-controls"
                :class="{ visible: showControls || !isPlaying }"
                @mouseenter="showControls = true"
                @mouseleave="onControlsLeave"
              >
                <div class="progress-bar-wrap" @click="seekVideo" @mousemove="onProgressMouseMove" @mouseleave="onProgressMouseLeave">
                  <div class="progress-bg">
                    <div class="progress-buffer" :style="{ width: bufferPercent + '%' }"></div>
                    <div class="progress-fill" :style="{ width: playPercent + '%' }">
                      <div class="progress-thumb"></div>
                    </div>
                  </div>
                  <div
                    class="progress-tooltip"
                    :style="{ left: progressTooltipX + 'px', opacity: progressTooltipOpacity }"
                  >
                    {{ formatTime(progressTooltipTime) }}
                  </div>
                </div>

                <div class="controls-row">
                  <div class="controls-left">
                    <button class="ctrl-btn" @click="togglePlay">
                      <el-icon v-if="!isPlaying" :size="20"><VideoPlay /></el-icon>
                      <el-icon v-else :size="20"><VideoPause /></el-icon>
                    </button>

                    <button class="ctrl-btn" @click="skipBackward">
                      <el-icon :size="18"><ArrowLeft /></el-icon>
                    </button>

                    <button class="ctrl-btn" @click="skipForward">
                      <el-icon :size="18"><ArrowRight /></el-icon>
                    </button>

                    <div class="volume-wrap">
                      <button class="ctrl-btn" @click="toggleMute">
                        <el-icon v-if="isMuted || volume === 0" :size="18"><Hide /></el-icon>
                        <el-icon v-else :size="18"><View /></el-icon>
                      </button>
                      <div class="volume-slider-wrap">
                        <input
                          type="range"
                          class="volume-slider"
                          min="0"
                          max="1"
                          step="0.01"
                          v-model.number="volume"
                          @input="onVolumeChange"
                        />
                      </div>
                    </div>

                    <div class="time-display">
                      <span>{{ formatTime(currentTime) }}</span>
                      <span class="time-sep">/</span>
                      <span>{{ formatTime(duration) }}</span>
                    </div>
                  </div>

                  <div class="controls-right">
                    <div class="playback-wrap">
                      <el-dropdown trigger="click" @command="onPlaybackRateChange">
                        <button class="ctrl-btn ctrl-btn-text">
                          {{ playbackRate }}x
                          <el-icon class="dropdown-icon"><ArrowDown /></el-icon>
                        </button>
                        <template #dropdown>
                          <el-dropdown-menu>
                            <el-dropdown-item :command="0.5">0.5x</el-dropdown-item>
                            <el-dropdown-item :command="0.75">0.75x</el-dropdown-item>
                            <el-dropdown-item :command="1">1x 正常</el-dropdown-item>
                            <el-dropdown-item :command="1.25">1.25x</el-dropdown-item>
                            <el-dropdown-item :command="1.5">1.5x</el-dropdown-item>
                            <el-dropdown-item :command="2">2x</el-dropdown-item>
                          </el-dropdown-menu>
                        </template>
                      </el-dropdown>
                    </div>

                    <button
                      class="ctrl-btn"
                      :class="{ active: isLooping }"
                      @click="toggleLoop"
                    >
                      <el-icon :size="18"><Refresh /></el-icon>
                    </button>

                    <button class="ctrl-btn" @click="toggleFullscreen">
                      <el-icon v-if="!isFullscreen" :size="18"><FullScreen /></el-icon>
                      <el-icon v-else :size="18"><Close /></el-icon>
                    </button>
                  </div>
                </div>
              </div>
            </template>
          </div>
        </div>

        <div v-if="allVideos.length > 1" class="video-playlist">
          <div class="playlist-header">
            <el-icon><List /></el-icon>
            <span>视频列表 ({{ allVideos.length }})</span>
          </div>
          <div class="playlist-items">
            <div
              v-for="(video, index) in allVideos"
              :key="video.name + '-' + index"
              class="playlist-item"
              :class="{ active: currentVideoIndex === index }"
              @click="selectVideo(index)"
            >
              <div class="playlist-num">{{ index + 1 }}</div>
              <div class="playlist-info">
                <div class="playlist-name">{{ video.name }}</div>
                <div class="playlist-meta">
                  <span v-if="video.type === 'bili'" class="meta-tag bili-tag">
                    <el-icon><VideoPlay /></el-icon>
                    B站 · {{ video.author }}
                  </span>
                  <span v-else class="meta-tag local-tag">
                    <el-icon><Folder /></el-icon>
                    本地视频
                  </span>
                </div>
              </div>
              <div v-if="currentVideoIndex === index" class="playlist-indicator">
                <el-icon><VideoPlay /></el-icon>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted, watch, nextTick } from 'vue'
import {
  VideoPlay,
  VideoPause,
  Film,
  CircleCheck,
  ArrowLeft,
  ArrowRight,
  Refresh,
  FullScreen,
  Close,
  ArrowDown,
  List,
  User,
  Folder,
  View,
  Hide
} from '@element-plus/icons-vue'
import skinGuiMi from '@/诡秘之主.png'
import { biliVideos } from '@/video/biliVideos.js'

const videoRef = ref(null)
const isPlaying = ref(false)
const isMuted = ref(true)
const isLooping = ref(true)
const isFullscreen = ref(false)
const volume = ref(0)
const currentTime = ref(0)
const duration = ref(0)
const playbackRate = ref(1)
const bufferPercent = ref(0)
const showControls = ref(true)
const currentVideoIndex = ref(0)

const progressTooltipX = ref(0)
const progressTooltipTime = ref(0)
const progressTooltipOpacity = ref(0)

let controlsHideTimer = null

const localVideoModules = import.meta.glob(['@/video/*.{mp4,webm,ogg,mov}', '!@/video/*.js'], {
  eager: true,
  query: '?url',
  import: 'default'
})

const localVideos = computed(() => {
  const videos = []
  for (const [path, url] of Object.entries(localVideoModules)) {
    const fileName = path.split('/').pop() || path
    const nameWithoutExt = fileName.replace(/\.(mp4|webm|ogg|mov)$/i, '')
    videos.push({
      type: 'local',
      name: nameWithoutExt,
      fileName,
      url: url
    })
  }
  return videos
})

const biliVideosFormatted = computed(() => {
  return biliVideos.map((v) => ({
    type: 'bili',
    name: v.name,
    author: v.author,
    url: v.url,
    bvid: v.bvid
  }))
})

const allVideos = computed(() => {
  return [...biliVideosFormatted.value, ...localVideos.value]
})

const currentVideo = computed(() => {
  return allVideos.value[currentVideoIndex.value] || null
})

const videoPoster = computed(() => {
  return skinGuiMi
})

const playPercent = computed(() => {
  if (duration.value === 0) return 0
  return (currentTime.value / duration.value) * 100
})

const formatTime = (seconds) => {
  if (isNaN(seconds) || !isFinite(seconds)) return '00:00'
  const h = Math.floor(seconds / 3600)
  const m = Math.floor((seconds % 3600) / 60)
  const s = Math.floor(seconds % 60)
  const pad = (n) => String(n).padStart(2, '0')
  if (h > 0) return `${pad(h)}:${pad(m)}:${pad(s)}`
  return `${pad(m)}:${pad(s)}`
}

const togglePlay = () => {
  if (!videoRef.value || currentVideo.value?.type === 'bili') return
  if (videoRef.value.paused) {
    videoRef.value.play()
  } else {
    videoRef.value.pause()
  }
}

const onPlay = () => {
  isPlaying.value = true
  scheduleHideControls()
}

const onPause = () => {
  isPlaying.value = false
  showControls.value = true
}

const onEnded = () => {
  isPlaying.value = false
  if (allVideos.value.length > 1) {
    const nextIndex = (currentVideoIndex.value + 1) % allVideos.value.length
    selectVideo(nextIndex)
  }
}

const onLoadedMetadata = () => {
  duration.value = videoRef.value?.duration || 0
  if (videoRef.value) {
    videoRef.value.playbackRate = playbackRate.value
  }
}

const onTimeUpdate = () => {
  currentTime.value = videoRef.value?.currentTime || 0
  if (videoRef.value?.buffered?.length > 0) {
    const bufferedEnd = videoRef.value.buffered.end(videoRef.value.buffered.length - 1)
    bufferPercent.value = duration.value > 0 ? (bufferedEnd / duration.value) * 100 : 0
  }
}

const seekVideo = (e) => {
  if (!videoRef.value || !duration.value) return
  const rect = e.currentTarget.getBoundingClientRect()
  const percent = Math.max(0, Math.min(1, (e.clientX - rect.left) / rect.width))
  videoRef.value.currentTime = percent * duration.value
}

const onProgressMouseMove = (e) => {
  if (!duration.value) return
  const rect = e.currentTarget.getBoundingClientRect()
  const percent = Math.max(0, Math.min(1, (e.clientX - rect.left) / rect.width))
  progressTooltipX.value = e.clientX - rect.left
  progressTooltipTime.value = percent * duration.value
  progressTooltipOpacity.value = 1
}

const onProgressMouseLeave = () => {
  progressTooltipOpacity.value = 0
}

const toggleMute = () => {
  if (!videoRef.value) return
  isMuted.value = !isMuted.value
  videoRef.value.muted = isMuted.value
  if (!isMuted.value && volume.value === 0) {
    volume.value = 0.5
    videoRef.value.volume = 0.5
  }
}

const onVolumeChange = () => {
  if (!videoRef.value) return
  videoRef.value.volume = volume.value
  isMuted.value = volume.value === 0
  videoRef.value.muted = isMuted.value
}

const toggleLoop = () => {
  isLooping.value = !isLooping.value
  if (videoRef.value) {
    videoRef.value.loop = isLooping.value
  }
}

const toggleFullscreen = async () => {
  const el = videoRef.value?.parentElement || document.querySelector('.video-container')
  if (!el) return
  if (!document.fullscreenElement) {
    await el.requestFullscreen()
    isFullscreen.value = true
  } else {
    await document.exitFullscreen()
    isFullscreen.value = false
  }
}

const onPlaybackRateChange = (rate) => {
  playbackRate.value = rate
  if (videoRef.value) {
    videoRef.value.playbackRate = rate
  }
}

const skipBackward = () => {
  if (!videoRef.value) return
  videoRef.value.currentTime = Math.max(0, videoRef.value.currentTime - 10)
}

const skipForward = () => {
  if (!videoRef.value) return
  videoRef.value.currentTime = Math.min(duration.value, videoRef.value.currentTime + 10)
}

const selectVideo = (index) => {
  currentVideoIndex.value = index
  isPlaying.value = false
  showControls.value = true
  currentTime.value = 0
  duration.value = 0
  bufferPercent.value = 0
  nextTick(() => {
    if (videoRef.value && allVideos.value[index]?.type !== 'bili') {
      videoRef.value.load()
      videoRef.value.muted = true
      setTimeout(() => {
        videoRef.value.play().catch(() => {})
      }, 300)
    }
  })
}

const scheduleHideControls = () => {
  if (controlsHideTimer) clearTimeout(controlsHideTimer)
  controlsHideTimer = setTimeout(() => {
    if (isPlaying.value) {
      showControls.value = false
    }
  }, 3000)
}

const onControlsLeave = () => {
  if (isPlaying.value) {
    scheduleHideControls()
  }
}

const onFullscreenChange = () => {
  isFullscreen.value = !!document.fullscreenElement
}

watch(volume, (val) => {
  if (videoRef.value) {
    videoRef.value.volume = val
  }
})

onMounted(() => {
  document.addEventListener('fullscreenchange', onFullscreenChange)
  if (allVideos.value.length > 0 && allVideos.value[0]?.type !== 'bili' && videoRef.value) {
    videoRef.value.volume = 0
    videoRef.value.muted = true
    setTimeout(() => {
      videoRef.value.play().catch(() => {})
    }, 800)
  }
})

onUnmounted(() => {
  document.removeEventListener('fullscreenchange', onFullscreenChange)
  if (controlsHideTimer) clearTimeout(controlsHideTimer)
})
</script>

<style scoped lang="scss">
.video-section {
  padding: 80px 0;
  position: relative;
  z-index: 1;
}

.video-section > .container {
  position: relative;
  z-index: 2;
}

.video-section::before {
  content: '';
  position: absolute;
  bottom: 100px;
  left: 3%;
  width: 350px;
  height: 350px;
  background-image: url('../诡秘之主.png');
  background-size: contain;
  background-repeat: no-repeat;
  background-position: center;
  opacity: 0.2;
  filter: blur(0px) hue-rotate(20deg) drop-shadow(0 0 20px rgba(199, 164, 84, 0.15));
  pointer-events: none;
  z-index: 1;
}

.video-header {
  text-align: center;
  margin-bottom: 48px;
}

.section-tag {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 6px 16px;
  background: rgba(0, 212, 255, 0.1);
  border: 1px solid rgba(0, 212, 255, 0.3);
  border-radius: 999px;
  font-size: 12px;
  color: var(--accent-cyan);
  margin-bottom: 16px;
  letter-spacing: 1px;
}

.section-title {
  font-size: 36px;
  font-weight: 800;
  letter-spacing: 2px;
  margin-bottom: 12px;
}

.section-sub {
  color: var(--text-muted);
  font-weight: 400;
  font-size: 18px;
  margin-left: 8px;
}

.section-desc {
  color: var(--text-muted);
  font-size: 14px;
  max-width: 600px;
  margin: 0 auto;
}

.video-main {
  max-width: 1100px;
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.video-player-wrapper {
  position: relative;
  border-radius: 20px;
  overflow: hidden;
  background: var(--bg-secondary);
  box-shadow: var(--shadow-card);
}

.video-placeholder {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  aspect-ratio: 16 / 9;
  padding: 60px 40px;
  text-align: center;
  background:
    radial-gradient(circle at 50% 30%, rgba(157, 78, 221, 0.1) 0%, transparent 50%),
    linear-gradient(180deg, var(--bg-tertiary) 0%, var(--bg-secondary) 100%);
}

.placeholder-icon {
  width: 120px;
  height: 120px;
  border-radius: 50%;
  background: linear-gradient(135deg, rgba(199, 164, 84, 0.15), rgba(157, 78, 221, 0.15));
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--accent-gold);
  margin-bottom: 28px;
  border: 2px dashed var(--border-color);
}

.placeholder-title {
  font-size: 22px;
  font-weight: 700;
  margin-bottom: 12px;
  color: var(--text-primary);
}

.placeholder-desc {
  color: var(--text-secondary);
  font-size: 14px;
  margin-bottom: 28px;
  max-width: 400px;
  line-height: 1.7;

  span {
    color: var(--accent-gold);
    font-family: 'Courier New', monospace;
  }
}

.placeholder-tips {
  display: flex;
  gap: 24px;
  flex-wrap: wrap;
  justify-content: center;
}

.tip-item {
  display: flex;
  align-items: center;
  gap: 8px;
  color: var(--text-muted);
  font-size: 13px;

  :deep(.el-icon) {
    color: #10b981;
  }
}

.video-container {
  position: relative;
  aspect-ratio: 16 / 9;
  background: #000;

  &.bili-mode {
    cursor: default;
  }
}

.bili-iframe {
  width: 100%;
  height: 100%;
  border: none;
  display: block;
}

.bili-video-info {
  position: absolute;
  left: 0;
  right: 0;
  top: 0;
  padding: 14px 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: linear-gradient(180deg, rgba(0, 0, 0, 0.7) 0%, transparent 100%);
  pointer-events: none;
  z-index: 2;
}

.bili-author,
.bili-source {
  display: flex;
  align-items: center;
  gap: 6px;
  color: #fff;
  font-size: 13px;
  opacity: 0.95;

  :deep(.el-icon) {
    color: var(--accent-cyan);
  }
}

.bili-source {
  color: #00a1d6;
}

.video-element {
  width: 100%;
  height: 100%;
  object-fit: contain;
  display: block;
  background: #000;
  cursor: pointer;
}

.video-overlay {
  position: absolute;
  inset: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(0, 0, 0, 0.3);
  transition: opacity 0.4s ease;
  z-index: 2;

  &.hidden {
    opacity: 0;
    pointer-events: none;
  }
}

.play-button {
  width: 100px;
  height: 100px;
  border-radius: 50%;
  background: linear-gradient(135deg, var(--accent-gold), var(--accent-primary));
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--bg-primary);
  box-shadow: 0 0 50px rgba(199, 164, 84, 0.5);
  transition: var(--transition-smooth);

  &:hover {
    transform: scale(1.1);
    box-shadow: 0 0 70px rgba(199, 164, 84, 0.7);
  }
}

.video-controls {
  position: absolute;
  left: 0;
  right: 0;
  bottom: 0;
  padding: 40px 20px 16px;
  background: linear-gradient(180deg, transparent 0%, rgba(0, 0, 0, 0.85) 100%);
  z-index: 3;
  opacity: 0;
  transition: opacity 0.3s ease;

  &.visible {
    opacity: 1;
  }
}

.progress-bar-wrap {
  position: relative;
  margin-bottom: 14px;
  padding: 10px 0;
  cursor: pointer;
}

.progress-bg {
  position: relative;
  height: 4px;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 4px;
  transition: height 0.2s ease;
}

.progress-bar-wrap:hover .progress-bg {
  height: 6px;
}

.progress-buffer {
  position: absolute;
  left: 0;
  top: 0;
  height: 100%;
  background: rgba(255, 255, 255, 0.3);
  border-radius: 4px;
}

.progress-fill {
  position: relative;
  height: 100%;
  background: linear-gradient(90deg, var(--accent-gold), var(--accent-cyan));
  border-radius: 4px;
  box-shadow: 0 0 10px rgba(199, 164, 84, 0.5);
}

.progress-thumb {
  position: absolute;
  right: -7px;
  top: 50%;
  transform: translateY(-50%) scale(0);
  width: 14px;
  height: 14px;
  border-radius: 50%;
  background: var(--accent-gold);
  box-shadow: 0 0 10px var(--accent-gold);
  transition: transform 0.2s ease;
}

.progress-bar-wrap:hover .progress-thumb {
  transform: translateY(-50%) scale(1);
}

.progress-tooltip {
  position: absolute;
  top: -28px;
  transform: translateX(-50%);
  padding: 4px 8px;
  background: rgba(0, 0, 0, 0.85);
  border-radius: 4px;
  font-size: 12px;
  color: #fff;
  font-family: 'Courier New', monospace;
  pointer-events: none;
  transition: opacity 0.2s ease;
}

.controls-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
}

.controls-left,
.controls-right {
  display: flex;
  align-items: center;
  gap: 4px;
}

.ctrl-btn {
  width: 38px;
  height: 38px;
  border: none;
  background: transparent;
  color: #fff;
  border-radius: 8px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: var(--transition-smooth);

  &:hover {
    background: rgba(255, 255, 255, 0.15);
    color: var(--accent-gold);
  }

  &.active {
    color: var(--accent-gold);
    background: rgba(199, 164, 84, 0.15);
  }

  &.ctrl-btn-text {
    width: auto;
    padding: 0 10px;
    font-size: 13px;
    font-weight: 600;
    gap: 4px;
  }
}

.dropdown-icon {
  font-size: 12px;
}

.volume-wrap {
  display: flex;
  align-items: center;
}

.volume-slider-wrap {
  width: 0;
  overflow: hidden;
  transition: width 0.3s ease;
}

.volume-wrap:hover .volume-slider-wrap {
  width: 80px;
  margin-right: 8px;
}

.volume-slider {
  -webkit-appearance: none;
  appearance: none;
  width: 80px;
  height: 4px;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 4px;
  outline: none;

  &::-webkit-slider-thumb {
    -webkit-appearance: none;
    appearance: none;
    width: 12px;
    height: 12px;
    border-radius: 50%;
    background: var(--accent-gold);
    cursor: pointer;
    box-shadow: 0 0 8px var(--accent-gold);
  }
}

.time-display {
  font-size: 13px;
  font-family: 'Courier New', monospace;
  color: rgba(255, 255, 255, 0.85);
  margin-left: 8px;
  white-space: nowrap;
}

.time-sep {
  margin: 0 4px;
  opacity: 0.5;
}

.video-playlist {
  background: var(--bg-card);
  border: 1px solid var(--border-color);
  border-radius: 16px;
  overflow: hidden;
  backdrop-filter: blur(10px);
}

.playlist-header {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 16px 20px;
  border-bottom: 1px solid var(--border-color);
  color: var(--accent-gold);
  font-size: 14px;
  font-weight: 600;
  letter-spacing: 1px;
}

.playlist-items {
  max-height: 300px;
  overflow-y: auto;
}

.playlist-item {
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 14px 20px;
  cursor: pointer;
  transition: var(--transition-smooth);
  border-bottom: 1px solid rgba(255, 255, 255, 0.04);

  &:last-child {
    border-bottom: none;
  }

  &:hover {
    background: rgba(199, 164, 84, 0.06);
  }

  &.active {
    background: rgba(199, 164, 84, 0.12);

    .playlist-name {
      color: var(--accent-gold);
    }

    .playlist-num {
      background: linear-gradient(135deg, var(--accent-gold), var(--accent-primary));
      color: var(--bg-primary);
    }
  }
}

.playlist-num {
  flex-shrink: 0;
  width: 28px;
  height: 28px;
  border-radius: 8px;
  background: var(--bg-tertiary);
  color: var(--text-muted);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  font-weight: 700;
  transition: var(--transition-smooth);
}

.playlist-info {
  flex: 1;
  min-width: 0;
}

.playlist-name {
  font-size: 14px;
  color: var(--text-secondary);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  transition: var(--transition-smooth);
  margin-bottom: 4px;
}

.playlist-meta {
  display: flex;
  align-items: center;
}

.meta-tag {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  font-size: 11px;
  padding: 2px 8px;
  border-radius: 4px;

  &.bili-tag {
    background: rgba(0, 161, 214, 0.1);
    color: #00a1d6;
  }

  &.local-tag {
    background: rgba(16, 185, 129, 0.1);
    color: #10b981;
  }
}

.playlist-indicator {
  color: var(--accent-gold);
  display: flex;
  align-items: center;
  animation: pulse 1.5s ease-in-out infinite;
}

@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.5; }
}

@media (max-width: 768px) {
  .video-section {
    padding: 40px 0;
  }

  .section-title {
    font-size: 24px;
  }

  .section-sub {
    display: block;
    margin: 8px 0 0 0;
    font-size: 14px;
  }

  .video-player-wrapper {
    border-radius: 12px;
  }

  .video-placeholder {
    padding: 40px 20px;

    .placeholder-icon {
      width: 80px;
      height: 80px;
      margin-bottom: 20px;

      :deep(.el-icon) {
        font-size: 40px;
      }
    }

    .placeholder-title {
      font-size: 18px;
    }
  }

  .placeholder-tips {
    flex-direction: column;
    gap: 12px;
    align-items: center;
  }

  .bili-video-info {
    padding: 10px 14px;
    flex-direction: column;
    gap: 4px;
    align-items: flex-start;
  }

  .bili-author,
  .bili-source {
    font-size: 11px;
  }

  .controls-row {
    gap: 4px;
  }

  .time-display {
    font-size: 11px;
    margin-left: 4px;
  }

  .ctrl-btn {
    width: 32px;
    height: 32px;
  }

  .video-controls {
    padding: 30px 12px 10px;
  }

  .volume-wrap:hover .volume-slider-wrap {
    width: 60px;
  }
}
</style>
