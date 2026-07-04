<template>
  <div class="home-page">
    <SiteHeader />
    <main>
      <section class="top-split-section">
        <div class="container split-container">
          <div class="split-col left-col" ref="leftColRef">
            <SkinCarousel />
          </div>
          <div class="split-col right-col" ref="rightColRef">
            <NewsPanel />
          </div>
        </div>
      </section>
      <HistoryTimeline />
      <VideoPlayerSection />
    </main>
    <SiteFooter />
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, nextTick } from 'vue'
import SiteHeader from '../components/SiteHeader.vue'
import SkinCarousel from '../components/SkinCarousel.vue'
import NewsPanel from '../components/NewsPanel.vue'
import HistoryTimeline from '../components/HistoryTimeline.vue'
import VideoPlayerSection from '../components/VideoPlayerSection.vue'
import SiteFooter from '../components/SiteFooter.vue'

const DESKTOP_BREAKPOINT = 1200
const leftColRef = ref(null)
const rightColRef = ref(null)
let ro = null
let resizeTimer = null

const syncRightHeight = () => {
  if (!leftColRef.value || !rightColRef.value) return
  const isDesktop = window.innerWidth >= DESKTOP_BREAKPOINT
  if (!isDesktop) {
    rightColRef.value.style.height = ''
    return
  }
  const leftH = leftColRef.value.getBoundingClientRect().height
  if (leftH > 0) {
    rightColRef.value.style.height = `${leftH}px`
  }
}

const handleScroll = () => {
  const elements = document.querySelectorAll('.fade-in-up')
  const windowHeight = window.innerHeight
  elements.forEach((el) => {
    const rect = el.getBoundingClientRect()
    if (rect.top < windowHeight - 100) {
      el.classList.add('visible')
    }
  })
}

const handleResize = () => {
  if (resizeTimer) clearTimeout(resizeTimer)
  resizeTimer = setTimeout(() => {
    syncRightHeight()
    handleScroll()
  }, 120)
}

onMounted(async () => {
  await nextTick()
  window.addEventListener('scroll', handleScroll, { passive: true })
  window.addEventListener('resize', handleResize, { passive: true })
  if (typeof ResizeObserver !== 'undefined' && leftColRef.value) {
    ro = new ResizeObserver(() => syncRightHeight())
    ro.observe(leftColRef.value)
  }
  syncRightHeight()
  handleScroll()
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
  window.removeEventListener('resize', handleResize)
  if (ro) ro.disconnect()
  if (resizeTimer) clearTimeout(resizeTimer)
})
</script>

<style scoped lang="scss">
.home-page {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

main {
  flex: 1;
}

.top-split-section {
  position: relative;
  padding-top: 0;
}

.split-container {
  display: flex;
  gap: 28px;
  align-items: flex-start;
  justify-content: space-between;
  padding-top: 140px;
  padding-bottom: 80px;
}

.split-col {
  flex: 1 1 0;
  width: 50%;
  min-width: 0;
  display: flex;
  align-items: stretch;
  overflow: visible;
}

.split-col.left-col {
  flex-shrink: 0;
}

.split-col.right-col {
  min-height: 0;
}

.split-col > * {
  width: 100%;
  min-width: 0;
}

@media (max-width: 1200px) {
  .split-container {
    flex-direction: column;
    gap: 20px;
    padding-top: 120px;
    padding-bottom: 60px;
  }

  .split-col {
    width: 100%;
  }
}

@media (max-width: 768px) {
  .split-container {
    padding-top: 100px;
    padding-bottom: 40px;
  }
}
</style>
