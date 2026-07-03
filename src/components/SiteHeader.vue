<template>
  <header class="site-header" :class="{ scrolled: isScrolled }">
    <div class="container header-inner">
      <div class="logo">
        <div class="logo-icon">
          <el-icon :size="28"><Cpu /></el-icon>
        </div>
        <div class="logo-text">
          <span class="logo-title gold-gradient-text">元歌</span>
          <span class="logo-subtitle">无间傀儡</span>
        </div>
      </div>
      <nav class="nav-links">
        <a href="#carousel" class="nav-link">皮肤展示</a>
        <a href="#history" class="nav-link">改动历史</a>
        <a href="#video" class="nav-link">视频攻略</a>
      </nav>
    </div>
  </header>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { Cpu } from '@element-plus/icons-vue'

const isScrolled = ref(false)

const handleScroll = () => {
  isScrolled.value = window.scrollY > 60
}

onMounted(() => {
  window.addEventListener('scroll', handleScroll, { passive: true })
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})
</script>

<style scoped lang="scss">
.site-header {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 100;
  padding: 20px 0;
  transition: var(--transition-smooth);
  background: transparent;

  &.scrolled {
    padding: 12px 0;
    background: rgba(10, 10, 15, 0.92);
    backdrop-filter: blur(20px) saturate(1.2);
    border-bottom: 1px solid var(--border-color);
    box-shadow: 0 4px 30px rgba(0, 0, 0, 0.5), 0 1px 0 rgba(168, 85, 247, 0.15);
  }

  &::after {
    content: '';
    position: absolute;
    left: 0;
    right: 0;
    bottom: 0;
    height: 1px;
    background: linear-gradient(90deg, transparent, rgba(168, 85, 247, 0.3), rgba(199, 164, 84, 0.4), rgba(168, 85, 247, 0.3), transparent);
    opacity: 0;
    transition: opacity 0.4s ease;
  }

  &.scrolled::after {
    opacity: 1;
  }
}

.header-inner {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.logo {
  display: flex;
  align-items: center;
  gap: 12px;
  cursor: pointer;
}

.logo-icon {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  background: linear-gradient(135deg, var(--accent-gold), var(--accent-primary));
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--bg-primary);
  box-shadow: 0 4px 15px rgba(199, 164, 84, 0.3);
}

.logo-text {
  display: flex;
  flex-direction: column;
  line-height: 1.2;
}

.logo-title {
  font-size: 22px;
  font-weight: 800;
  letter-spacing: 2px;
}

.logo-subtitle {
  font-size: 11px;
  color: var(--text-muted);
  letter-spacing: 3px;
  text-transform: uppercase;
}

.nav-links {
  display: flex;
  gap: 8px;
}

.nav-link {
  position: relative;
  padding: 10px 20px;
  color: var(--text-secondary);
  text-decoration: none;
  font-size: 14px;
  font-weight: 500;
  border-radius: 8px;
  transition: var(--transition-smooth);

  &::after {
    content: '';
    position: absolute;
    bottom: 4px;
    left: 50%;
    width: 0;
    height: 2px;
    background: linear-gradient(90deg, var(--accent-gold), var(--accent-primary));
    transition: var(--transition-smooth);
    transform: translateX(-50%);
  }

  &:hover {
    color: var(--accent-gold);
    background: rgba(199, 164, 84, 0.08);

    &::after {
      width: 60%;
    }
  }
}

@media (max-width: 768px) {
  .nav-links {
    display: none;
  }

  .logo-title {
    font-size: 18px;
  }

  .logo-subtitle {
    font-size: 10px;
  }

  .logo-icon {
    width: 40px;
    height: 40px;
  }
}
</style>
