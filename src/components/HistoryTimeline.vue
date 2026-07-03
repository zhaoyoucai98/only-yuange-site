<template>
  <section id="history" class="history-section mystery-pattern-bg section-mystery-decoration">
    <div class="container">
      <div class="history-header fade-in-up">
        <div class="section-tag">
          <el-icon><Clock /></el-icon>
          <span>核心改动历史</span>
        </div>
        <h2 class="section-title">
          <span class="gold-gradient-text">九年蜕变</span>
          <span class="section-sub">· 从庞统到元歌的完整历程</span>
        </h2>
        <p class="section-desc">
          点击年份标题可折叠/展开对应板块，查看每个版本的详细改动记录
        </p>
      </div>

      <div class="summary-cards fade-in-up">
        <div
          v-for="(item, index) in historySummary"
          :key="index"
          class="summary-card"
        >
          <div class="summary-stage">{{ item.stage }}</div>
          <div class="summary-desc">{{ item.desc }}</div>
        </div>
      </div>

      <div class="timeline-wrapper fade-in-up">
        <div class="timeline-line"></div>

        <TransitionGroup name="timeline-list">
          <div
            v-for="(yearBlock, yIndex) in yearBlocks"
            :key="yearBlock.year"
            class="timeline-year-block"
            :class="{ expanded: yearBlock.expanded, 'is-even': yIndex % 2 === 0 }"
          >
            <div class="timeline-dot-wrapper">
              <div class="timeline-dot" :class="{ active: yearBlock.expanded }">
                <el-icon v-if="yearBlock.expanded" :size="14"><Minus /></el-icon>
                <el-icon v-else :size="14"><Plus /></el-icon>
              </div>
            </div>

            <div class="year-card glow-border" @click="toggleYear(yIndex)">
              <div class="year-header">
                <div class="year-badge">
                  <span class="year-number gold-gradient-text">{{ yearBlock.year }}</span>
                </div>
                <div class="year-info">
                  <h3 class="year-title">{{ yearBlock.title }}</h3>
                  <div class="year-meta">
                    <el-icon><Flag /></el-icon>
                    <span>{{ yearBlock.events.length }} 次重要改动</span>
                  </div>
                </div>
                <div class="toggle-icon" :class="{ rotated: yearBlock.expanded }">
                  <el-icon :size="20"><ArrowDown /></el-icon>
                </div>
              </div>

              <Transition name="collapse">
                <div v-show="yearBlock.expanded" class="year-events">
                  <div
                    v-for="(event, eIndex) in yearBlock.events"
                    :key="eIndex"
                    class="event-item"
                  >
                    <div class="event-marker"></div>
                    <div class="event-content">
                      <div class="event-head">
                        <span class="event-date">{{ event.date }}</span>
                        <span class="event-title">{{ event.title }}</span>
                      </div>
                      <div class="event-body">
                        <p
                          v-for="(line, lIndex) in event.content"
                          :key="lIndex"
                          class="event-line"
                        >
                          {{ line }}
                        </p>
                      </div>
                    </div>
                  </div>
                </div>
              </Transition>
            </div>
          </div>
        </TransitionGroup>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref } from 'vue'
import { Clock, Flag, ArrowDown, Plus, Minus } from '@element-plus/icons-vue'
import { historyData, historySummary } from '../data/history.js'

const yearBlocks = ref(JSON.parse(JSON.stringify(historyData)))

const toggleYear = (index) => {
  yearBlocks.value[index].expanded = !yearBlocks.value[index].expanded
}
</script>

<style scoped lang="scss">
.history-section {
  padding: 80px 0;
  position: relative;
  z-index: 1;
}

.history-section > .container {
  position: relative;
  z-index: 2;
}

.history-header {
  text-align: center;
  margin-bottom: 56px;
}

.section-tag {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 6px 16px;
  background: rgba(157, 78, 221, 0.1);
  border: 1px solid rgba(157, 78, 221, 0.3);
  border-radius: 999px;
  font-size: 12px;
  color: var(--accent-purple);
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

.summary-cards {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
  margin-bottom: 64px;
}

.summary-card {
  padding: 20px;
  background: var(--bg-card);
  border: 1px solid var(--border-color);
  border-radius: 12px;
  transition: var(--transition-smooth);

  &:hover {
    transform: translateY(-4px);
    border-color: var(--accent-gold);
    box-shadow: var(--shadow-gold);
  }
}

.summary-stage {
  font-size: 13px;
  font-weight: 700;
  color: var(--accent-gold);
  margin-bottom: 8px;
  letter-spacing: 1px;
}

.summary-desc {
  font-size: 13px;
  color: var(--text-secondary);
  line-height: 1.7;
}

.timeline-wrapper {
  position: relative;
  max-width: 1000px;
  margin: 0 auto;
  padding: 20px 0;
}

.timeline-line {
  position: absolute;
  left: 50%;
  top: 0;
  bottom: 0;
  width: 2px;
  transform: translateX(-50%);
  background: linear-gradient(
    180deg,
    var(--accent-gold) 0%,
    var(--accent-purple) 50%,
    var(--accent-cyan) 100%
  );
  opacity: 0.4;
}

.timeline-year-block {
  position: relative;
  display: flex;
  margin-bottom: 32px;

  &.is-even {
    flex-direction: row-reverse;

    .year-card {
      margin-right: calc(50% - 30px);
      margin-left: 0;
    }

    .timeline-dot-wrapper {
      right: calc(50% - 16px);
      left: auto;
    }
  }
}

.timeline-dot-wrapper {
  position: absolute;
  left: calc(50% - 16px);
  top: 28px;
  z-index: 5;
}

.timeline-dot {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: var(--bg-tertiary);
  border: 2px solid var(--accent-gold);
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--accent-gold);
  cursor: pointer;
  transition: var(--transition-smooth);

  &:hover {
    transform: scale(1.15);
    box-shadow: 0 0 20px rgba(199, 164, 84, 0.5);
  }

  &.active {
    background: linear-gradient(135deg, var(--accent-gold), var(--accent-primary));
    color: var(--bg-primary);
    transform: scale(1.1);
    box-shadow: 0 0 25px rgba(199, 164, 84, 0.6);
  }
}

.year-card {
  width: calc(50% - 60px);
  margin-left: calc(50% - 30px);
  background: var(--bg-card);
  border-radius: 16px;
  overflow: hidden;
  cursor: pointer;
  transition: var(--transition-slower);
  backdrop-filter: blur(10px);

  &:hover {
    box-shadow: 0 8px 40px rgba(0, 0, 0, 0.5), var(--shadow-gold);
  }
}

.year-header {
  display: flex;
  align-items: center;
  padding: 24px;
  gap: 20px;
}

.year-badge {
  flex-shrink: 0;
}

.year-number {
  font-size: 36px;
  font-weight: 900;
  letter-spacing: 2px;
  line-height: 1;
}

.year-info {
  flex: 1;
  min-width: 0;
}

.year-title {
  font-size: 17px;
  font-weight: 700;
  color: var(--text-primary);
  margin-bottom: 6px;
  line-height: 1.3;
}

.year-meta {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 12px;
  color: var(--text-muted);
}

.toggle-icon {
  flex-shrink: 0;
  width: 36px;
  height: 36px;
  border-radius: 50%;
  background: rgba(199, 164, 84, 0.1);
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--accent-gold);
  transition: transform 0.4s cubic-bezier(0.4, 0, 0.2, 1);

  &.rotated {
    transform: rotate(180deg);
  }
}

.year-events {
  padding: 0 24px 24px 84px;
  border-top: 1px solid var(--border-color);
  padding-top: 20px;
  margin-top: -4px;
}

.event-item {
  position: relative;
  padding-left: 20px;
  margin-bottom: 24px;

  &:last-child {
    margin-bottom: 0;
  }
}

.event-marker {
  position: absolute;
  left: -1px;
  top: 10px;
  width: 10px;
  height: 10px;
  border-radius: 50%;
  background: var(--accent-cyan);
  box-shadow: 0 0 10px rgba(0, 212, 255, 0.5);

  &::before {
    content: '';
    position: absolute;
    left: 4px;
    top: 5px;
    width: 1px;
    height: calc(100% + 30px);
    background: linear-gradient(180deg, var(--accent-cyan), transparent);
    opacity: 0.3;
  }
}

.event-content {
  background: rgba(0, 0, 0, 0.25);
  border-radius: 10px;
  padding: 14px 18px;
  border-left: 3px solid var(--accent-cyan);
}

.event-head {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 10px;
  flex-wrap: wrap;
}

.event-date {
  flex-shrink: 0;
  padding: 4px 10px;
  background: rgba(0, 212, 255, 0.12);
  color: var(--accent-cyan);
  border-radius: 6px;
  font-size: 12px;
  font-weight: 600;
  font-family: 'Courier New', monospace;
}

.event-title {
  font-size: 15px;
  font-weight: 700;
  color: var(--text-primary);
}

.event-body {
  padding-left: 2px;
}

.event-line {
  font-size: 13px;
  color: var(--text-secondary);
  line-height: 1.85;
  margin-bottom: 4px;

  &:last-child {
    margin-bottom: 0;
  }
}

.collapse-enter-active,
.collapse-leave-active {
  transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
  overflow: hidden;
}

.collapse-enter-from,
.collapse-leave-to {
  opacity: 0;
  max-height: 0;
  padding-top: 0 !important;
  padding-bottom: 0 !important;
}

.collapse-enter-to,
.collapse-leave-from {
  max-height: 2000px;
}

.timeline-list-enter-active,
.timeline-list-leave-active {
  transition: all 0.6s ease;
}

.timeline-list-enter-from {
  opacity: 0;
  transform: translateY(30px);
}

@media (max-width: 992px) {
  .summary-cards {
    grid-template-columns: repeat(2, 1fr);
  }

  .timeline-line {
    left: 20px;
  }

  .timeline-year-block,
  .timeline-year-block.is-even {
    flex-direction: row;
  }

  .timeline-dot-wrapper,
  .timeline-year-block.is-even .timeline-dot-wrapper {
    left: 4px;
    right: auto;
  }

  .year-card,
  .timeline-year-block.is-even .year-card {
    width: calc(100% - 64px);
    margin-left: 64px;
    margin-right: 0;
  }
}

@media (max-width: 600px) {
  .history-section {
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

  .summary-cards {
    grid-template-columns: 1fr;
    gap: 12px;
    margin-bottom: 40px;
  }

  .year-header {
    padding: 16px;
    gap: 12px;
  }

  .year-number {
    font-size: 26px;
  }

  .year-title {
    font-size: 14px;
  }

  .year-events {
    padding: 16px 16px 16px 64px;
  }

  .toggle-icon {
    width: 32px;
    height: 32px;
  }
}
</style>
