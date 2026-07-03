<template>
  <div class="home-page">
    <SiteHeader />
    <main>
      <section class="top-split-section">
        <div class="container split-container">
          <div class="split-col left-col">
            <SkinCarousel />
          </div>
          <div class="split-col right-col">
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
import { onMounted, onUnmounted } from 'vue'
import SiteHeader from '../components/SiteHeader.vue'
import SkinCarousel from '../components/SkinCarousel.vue'
import NewsPanel from '../components/NewsPanel.vue'
import HistoryTimeline from '../components/HistoryTimeline.vue'
import VideoPlayerSection from '../components/VideoPlayerSection.vue'
import SiteFooter from '../components/SiteFooter.vue'

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

onMounted(() => {
  window.addEventListener('scroll', handleScroll, { passive: true })
  handleScroll()
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
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
  align-items: stretch;
  padding-top: 140px;
  padding-bottom: 80px;
}

.split-col {
  flex: 1 1 0;
  width: 50%;
  min-width: 0;
  display: flex;
}

.split-col > * {
  width: 100%;
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
