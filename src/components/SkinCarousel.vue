<template>
  <section id="carousel" class="carousel-section section-mystery-decoration">
    <div class="carousel-container fade-in-up">
      <div class="carousel-header">
        <div class="section-tag">
          <el-icon><Picture /></el-icon>
          <span>皮肤展示</span>
        </div>
        <h2 class="section-title">
          <span class="gold-gradient-text">华丽皮肤</span>
          <span class="section-sub">· 每一张都是艺术品</span>
        </h2>
      </div>

      <div class="carousel-wrapper">
        <div class="carousel-main">
          <transition name="fade" mode="out-in">
            <div :key="currentIndex" class="carousel-slide">
              <div class="slide-image-wrapper">
                <img
                  :src="currentSkin.src"
                  :alt="currentSkin.name"
                  class="slide-image"
                  loading="lazy"
                />
                <div class="slide-overlay"></div>
                <div class="slide-info">
                  <div class="skin-name">{{ currentSkin.name }}</div>
                  <div class="skin-type" :class="currentSkin.class">{{ currentSkin.type }}</div>
                </div>
              </div>
            </div>
          </transition>

          <button
            class="carousel-nav nav-prev"
            @click="prevSlide"
            @mouseenter="pauseAutoPlay"
            @mouseleave="resumeAutoPlay"
          >
            <el-icon :size="24"><ArrowLeft /></el-icon>
          </button>
          <button
            class="carousel-nav nav-next"
            @click="nextSlide"
            @mouseenter="pauseAutoPlay"
            @mouseleave="resumeAutoPlay"
          >
            <el-icon :size="24"><ArrowRight /></el-icon>
          </button>

          <div class="carousel-progress">
            <div
              class="progress-bar"
              :style="{ width: progressWidth + '%' }"
            ></div>
          </div>
        </div>

        <div class="carousel-thumbnails">
          <button
            v-for="(skin, index) in skins"
            :key="'thumb-' + skin.name"
            class="thumbnail"
            :class="{ active: currentIndex === index }"
            @click="goToSlide(index)"
            @mouseenter="pauseAutoPlay"
            @mouseleave="resumeAutoPlay"
          >
            <img :src="skin.src" :alt="skin.name" loading="lazy" />
            <div class="thumbnail-label">{{ skin.name }}</div>
          </button>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, onMounted, onUnmounted, computed } from 'vue'
import { Picture, ArrowLeft, ArrowRight } from '@element-plus/icons-vue'

import skinRC from '@/R-C.png'
import skinYunJian from '@/云间偶戏.webp'
import skinOuXiang from '@/偶像歌剧院.webp'
import skinWuXin from '@/无心.webp'
import skinGuiMi from '@/诡秘之主.png'

const skins = [
  { name: '午夜歌剧院', type: '史诗', class: 'epic', src: skinRC },
  { name: '云间偶戏', type: '战令限定', class: 'limited', src: skinYunJian },
  { name: '偶像歌剧院', type: '传说', class: 'legend', src: skinOuXiang },
  { name: '无心', type: '史诗', class: 'epic', src: skinWuXin },
  { name: '诡秘之主', type: '联动限定', class: 'special', src: skinGuiMi }
]

const currentIndex = ref(0)
const progressWidth = ref(0)
const currentSkin = computed(() => skins[currentIndex.value])
const autoPlayInterval = ref(null)
const progressInterval = ref(null)
const isPaused = ref(false)
const autoPlayDuration = 5000

const goToSlide = (index) => {
  currentIndex.value = index
  resetProgress()
}

const nextSlide = () => {
  currentIndex.value = (currentIndex.value + 1) % skins.length
  resetProgress()
}

const prevSlide = () => {
  currentIndex.value = (currentIndex.value - 1 + skins.length) % skins.length
  resetProgress()
}

const resetProgress = () => {
  progressWidth.value = 0
  if (progressInterval.value) {
    clearInterval(progressInterval.value)
  }
  startProgress()
}

const startProgress = () => {
  const step = 100 / (autoPlayDuration / 50)
  progressInterval.value = setInterval(() => {
    if (!isPaused.value) {
      progressWidth.value = Math.min(progressWidth.value + step, 100)
    }
  }, 50)
}

const pauseAutoPlay = () => {
  isPaused.value = true
}

const resumeAutoPlay = () => {
  isPaused.value = false
}

onMounted(() => {
  autoPlayInterval.value = setInterval(() => {
    if (!isPaused.value) {
      nextSlide()
    }
  }, autoPlayDuration)
  startProgress()
})

onUnmounted(() => {
  if (autoPlayInterval.value) clearInterval(autoPlayInterval.value)
  if (progressInterval.value) clearInterval(progressInterval.value)
})
</script>

<style scoped lang="scss">
.carousel-section {
  padding: 0;
  position: relative;
  z-index: 1;
  display: flex;
  flex-direction: column;
  min-height: 100%;
  width: 100%;
}

.carousel-container {
  position: relative;
  z-index: 2;
  display: flex;
  flex-direction: column;
  width: 100%;
  height: 100%;
}

.carousel-section::before {
  content: '';
  position: absolute;
  top: 40px;
  right: -10px;
  width: 280px;
  height: 280px;
  background-image: url('../诡秘之主.png');
  background-size: contain;
  background-repeat: no-repeat;
  background-position: center;
  opacity: 0.22;
  filter: blur(0px) drop-shadow(0 0 20px rgba(168, 85, 247, 0.2));
  pointer-events: none;
  z-index: 1;
}

.carousel-header {
  text-align: center;
  margin-bottom: 28px;
}

.section-tag {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 6px 16px;
  background: rgba(199, 164, 84, 0.1);
  border: 1px solid var(--border-color);
  border-radius: 999px;
  font-size: 12px;
  color: var(--accent-gold);
  margin-bottom: 16px;
  letter-spacing: 1px;
}

.section-title {
  font-size: 36px;
  font-weight: 800;
  letter-spacing: 2px;
}

.section-sub {
  color: var(--text-muted);
  font-weight: 400;
  font-size: 18px;
  margin-left: 8px;
}

.carousel-wrapper {
  position: relative;
  flex: 1;
  display: flex;
  flex-direction: column;
}

.carousel-main {
  position: relative;
  width: 100%;
  aspect-ratio: 16 / 7;
  border-radius: 20px;
  overflow: hidden;
  box-shadow: var(--shadow-card), var(--shadow-gold);
  margin-bottom: 24px;
}

.carousel-slide {
  position: absolute;
  inset: 0;
}

.slide-image-wrapper {
  position: relative;
  width: 100%;
  height: 100%;
  overflow: hidden;
  cursor: pointer;
}

.slide-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.8s cubic-bezier(0.4, 0, 0.2, 1), filter 0.5s ease;
  filter: brightness(0.95);
}

.slide-image-wrapper:hover .slide-image {
  transform: scale(1.08);
  filter: brightness(1.05);
}

.slide-overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(
    180deg,
    transparent 40%,
    rgba(10, 10, 15, 0.4) 70%,
    rgba(10, 10, 15, 0.9) 100%
  );
  pointer-events: none;
}

.slide-info {
  position: absolute;
  left: 48px;
  bottom: 48px;
  z-index: 2;
}

.skin-name {
  font-size: 40px;
  font-weight: 800;
  letter-spacing: 4px;
  margin-bottom: 12px;
  text-shadow: 0 2px 20px rgba(0, 0, 0, 0.8);
  color: #fff;
}

.skin-type {
  display: inline-block;
  padding: 6px 18px;
  border-radius: 6px;
  font-size: 13px;
  font-weight: 600;
  letter-spacing: 2px;

  &.legend {
    background: linear-gradient(135deg, #d4af37, #c7a454);
    color: #1a1a2e;
  }

  &.epic {
    background: linear-gradient(135deg, #9d4edd, #7b2cbf);
    color: #fff;
  }

  &.limited {
    background: linear-gradient(135deg, #00d4ff, #0096c7);
    color: #0a0a0f;
  }

  &.special {
    background: linear-gradient(135deg, #ff6b6b, #c92a2a);
    color: #fff;
  }
}

.carousel-nav {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  width: 52px;
  height: 52px;
  border-radius: 50%;
  background: rgba(10, 10, 15, 0.6);
  backdrop-filter: blur(10px);
  border: 1px solid var(--border-color);
  color: var(--text-primary);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: var(--transition-smooth);
  z-index: 10;

  &:hover {
    background: rgba(199, 164, 84, 0.2);
    border-color: var(--accent-gold);
    color: var(--accent-gold);
    transform: translateY(-50%) scale(1.1);
  }
}

.nav-prev {
  left: 24px;
}

.nav-next {
  right: 24px;
}

.carousel-progress {
  position: absolute;
  left: 0;
  right: 0;
  bottom: 0;
  height: 3px;
  background: rgba(255, 255, 255, 0.1);
  z-index: 5;
}

.progress-bar {
  height: 100%;
  background: linear-gradient(90deg, var(--accent-gold), var(--accent-cyan));
  transition: width 0.05s linear;
  box-shadow: 0 0 10px rgba(199, 164, 84, 0.6);
}

.carousel-thumbnails {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 16px;
}

.thumbnail {
  position: relative;
  aspect-ratio: 16 / 10;
  border-radius: 12px;
  overflow: hidden;
  border: 2px solid transparent;
  cursor: pointer;
  background: var(--bg-tertiary);
  padding: 0;
  transition: var(--transition-smooth);

  img {
    width: 100%;
    height: calc(100% - 32px);
    object-fit: cover;
    transition: transform 0.4s ease;
  }

  &:hover img {
    transform: scale(1.06);
  }

  &.active {
    border-color: var(--accent-gold);
    box-shadow: 0 0 20px rgba(199, 164, 84, 0.3);
  }
}

.thumbnail-label {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(10, 10, 15, 0.9);
  font-size: 12px;
  color: var(--text-secondary);
  letter-spacing: 1px;
  border-top: 1px solid var(--border-color);
}

.thumbnail.active .thumbnail-label {
  color: var(--accent-gold);
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.8s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

@media (max-width: 992px) {
  .carousel-main {
    aspect-ratio: 16 / 9;
  }

  .slide-info {
    left: 24px;
    bottom: 24px;
  }

  .skin-name {
    font-size: 24px;
  }

  .carousel-thumbnails {
    grid-template-columns: repeat(5, 1fr);
    gap: 8px;
  }

  .thumbnail-label {
    font-size: 10px;
  }
}

@media (max-width: 600px) {
  .carousel-section {
    padding: 0;
  }

  .section-title {
    font-size: 24px;
  }

  .section-sub {
    display: block;
    margin: 8px 0 0 0;
    font-size: 14px;
  }

  .carousel-main {
    aspect-ratio: 4 / 3;
    border-radius: 12px;
  }

  .carousel-nav {
    width: 40px;
    height: 40px;

    &.nav-prev {
      left: 12px;
    }
    &.nav-next {
      right: 12px;
    }
  }

  .slide-info {
    left: 16px;
    bottom: 16px;
  }

  .skin-name {
    font-size: 18px;
    letter-spacing: 2px;
    margin-bottom: 6px;
  }

  .skin-type {
    font-size: 10px;
    padding: 4px 10px;
  }

  .carousel-thumbnails {
    grid-template-columns: repeat(5, 1fr);
    gap: 6px;
  }

  .thumbnail-label {
    display: none;
  }

  .thumbnail {
    aspect-ratio: 1;
    border-radius: 8px;

    img {
      height: 100%;
    }
  }
}
</style>
