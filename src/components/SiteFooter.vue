<template>
  <footer class="site-footer fade-in-up mystery-pattern-bg">
    <div class="container footer-inner">
      <div class="footer-info">
        <div class="footer-logo">
          <span class="gold-gradient-text">元歌 · 无间傀儡</span>
        </div>
        <p class="footer-desc">
          王者荣耀英雄专题站 | 汇集元歌完整改动历史与皮肤展示
        </p>
      </div>
      <div class="footer-meta">
        <p>© 2018-2026 王者荣耀元歌专题</p>
        <p class="footer-tip">本站仅作英雄历史资料整理，非官方站点</p>
      </div>
    </div>
  </footer>
</template>

<style scoped lang="scss">
.site-footer {
  margin-top: 120px;
  padding: 50px 0 40px;
  background: linear-gradient(180deg, transparent 0%, rgba(26, 26, 46, 0.6) 100%);
  border-top: 1px solid var(--border-color);
  position: relative;
  z-index: 1;
  overflow: hidden;

  &::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 1px;
    background: linear-gradient(90deg, transparent, rgba(168, 85, 247, 0.25), rgba(199, 164, 84, 0.35), rgba(168, 85, 247, 0.25), transparent);
  }

  .footer-inner {
    position: relative;
    z-index: 2;
  }
}

.footer-inner {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 24px;
}

.footer-logo {
  font-size: 20px;
  font-weight: 700;
  letter-spacing: 2px;
  margin-bottom: 8px;
}

.footer-desc {
  color: var(--text-muted);
  font-size: 13px;
}

.footer-meta {
  text-align: right;
  color: var(--text-muted);
  font-size: 12px;
  line-height: 1.8;
}

.footer-tip {
  opacity: 0.7;
}

@media (max-width: 768px) {
  .footer-inner {
    flex-direction: column;
    text-align: center;
  }

  .footer-meta {
    text-align: center;
  }
}
</style>
