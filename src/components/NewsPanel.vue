<template>
  <section id="news-panel" class="news-panel section-mystery-decoration fade-in-up">
    <div class="news-inner">
      <div class="news-header">
        <div class="section-tag">
          <el-icon><Reading /></el-icon>
          <span>新闻资料</span>
        </div>
        <h2 class="section-title">
          <span class="mystery-gradient-text">最新资讯</span>
          <span class="section-sub">· 攻略与情报中心</span>
        </h2>
      </div>

      <el-tabs v-model="activeTab" class="news-tabs" @tab-change="handleTabChange">
        <el-tab-pane label="版本资讯" name="updates">
          <div class="news-list">
            <article
              v-for="(item, idx) in updates"
              :key="'update-' + idx"
              class="news-card"
              :class="{ featured: idx === 0 }"
              @click="selectNews(item)"
            >
              <div class="news-badge" v-if="idx === 0">
                <el-icon><Star /></el-icon>
                <span>HOT</span>
              </div>
              <div class="news-date">{{ item.date }}</div>
              <h3 class="news-title">{{ item.title }}</h3>
              <p class="news-excerpt">{{ item.excerpt }}</p>
              <div class="news-footer">
                <span class="news-tag" :class="item.tagClass">{{ item.tag }}</span>
                <span class="news-read-more">
                  查看详情
                  <el-icon><ArrowRight /></el-icon>
                </span>
              </div>
            </article>
          </div>
        </el-tab-pane>

        <el-tab-pane label="出装攻略" name="guides">
          <div class="news-list">
            <article
              v-for="(item, idx) in guides"
              :key="'guide-' + idx"
              class="news-card"
              :class="{ featured: idx === 0 }"
              @click="selectNews(item)"
            >
              <div class="news-badge gold" v-if="idx === 0">
                <el-icon><CircleCheck /></el-icon>
                <span>推荐</span>
              </div>
              <div class="guide-stats" v-if="item.stats">
                <div class="stat-item">
                  <span class="stat-label">胜率</span>
                  <span class="stat-value win">{{ item.stats.winRate }}</span>
                </div>
                <div class="stat-item">
                  <span class="stat-label">热度</span>
                  <span class="stat-value hot">{{ item.stats.popularity }}</span>
                </div>
                <div class="stat-item">
                  <span class="stat-label">难度</span>
                  <span class="stat-value">{{ item.stats.difficulty }}</span>
                </div>
              </div>
              <h3 class="news-title">{{ item.title }}</h3>
              <p class="news-excerpt">{{ item.excerpt }}</p>
              <div class="news-footer">
                <div class="build-preview">
                  <span
                    v-for="(eq, i) in item.previewItems"
                    :key="i"
                    class="eq-icon"
                    :title="eq"
                  >{{ eq.slice(0, 2) }}</span>
                </div>
                <span class="news-read-more">
                  查看详情
                  <el-icon><ArrowRight /></el-icon>
                </span>
              </div>
            </article>
          </div>
        </el-tab-pane>

        <el-tab-pane label="玩法技巧" name="tips">
          <div class="tips-list">
            <div
              v-for="(tip, idx) in tips"
              :key="'tip-' + idx"
              class="tip-item"
              :class="'level-' + tip.level"
            >
              <div class="tip-number">{{ String(idx + 1).padStart(2, '0') }}</div>
              <div class="tip-content">
                <h4 class="tip-title">
                  <el-tag :type="tip.tagType" size="small" effect="dark" round>
                    {{ tip.category }}
                  </el-tag>
                  {{ tip.title }}
                </h4>
                <p class="tip-desc">{{ tip.description }}</p>
              </div>
            </div>
          </div>
        </el-tab-pane>

        <el-tab-pane label="赛事数据" name="stats">
          <div class="stats-container">
            <div class="stat-card-group">
              <div class="big-stat-card">
                <div class="stat-icon gold">
                  <el-icon :size="28"><Trophy /></el-icon>
                </div>
                <div class="stat-info">
                  <div class="big-stat-value">52.6<span>%</span></div>
                  <div class="stat-label">KPL 赛事胜率</div>
                  <div class="stat-trend up">
                    <el-icon><Top /></el-icon>
                    +3.2% 本赛季
                  </div>
                </div>
              </div>
              <div class="big-stat-card purple">
                <div class="stat-icon">
                  <el-icon :size="28"><DataLine /></el-icon>
                </div>
                <div class="stat-info">
                  <div class="big-stat-value">1,847</div>
                  <div class="stat-label">职业赛场出场数</div>
                  <div class="stat-trend up">
                    <el-icon><Top /></el-icon>
                    T1 法师梯队
                  </div>
                </div>
              </div>
            </div>

            <div class="skill-hero-list">
              <h4 class="list-title">
                <el-icon><User /></el-icon>
                顶尖操作选手
              </h4>
              <div class="player-row" v-for="(p, i) in topPlayers" :key="i">
                <div class="player-rank">{{ i + 1 }}</div>
                <div class="player-info">
                  <div class="player-name">{{ p.name }} <span class="team-tag">[{{ p.team }}]</span></div>
                  <div class="player-meta">胜率 {{ p.winRate }} · 登场 {{ p.games }}场</div>
                </div>
                <div class="player-rate-bar">
                  <div class="rate-fill" :style="{ width: p.rate }"></div>
                </div>
              </div>
            </div>
          </div>
        </el-tab-pane>
      </el-tabs>
    </div>
  </section>
</template>

<script setup>
import { ref } from 'vue'
import {
  Reading,
  Star,
  CircleCheck,
  Trophy,
  DataLine,
  Top,
  User,
  ArrowRight
} from '@element-plus/icons-vue'

const activeTab = ref('updates')

const handleTabChange = () => {}
const selectNews = (item) => {
  console.log('Selected news:', item.title)
}

const updates = [
  {
    date: '2026.06.28',
    title: 'S40 赛季「诡秘时代」元歌重大机制调整公告',
    excerpt: '被动傀儡交换范围 +15%，三技能冷却时间降低至 8/7.6/7.2/6.8s，修复了大招期间偶发不可选中异常丢失的问题。',
    tag: '版本更新',
    tagClass: 'major'
  },
  {
    date: '2026.06.15',
    title: '联动皮肤「诡秘之主·克莱恩」特效升级上线',
    excerpt: '新增专属技能音效和击杀播报，三技能新增愚者塔罗牌特效，大招期间背景同步切换诡秘迷雾场景。',
    tag: '皮肤资讯',
    tagClass: 'skin'
  },
  {
    date: '2026.06.02',
    title: '体验服 6.2 调整：二技能控制时长微增',
    excerpt: '二技能束缚时长由 1s 上调至 1.2s，前摇降低 50ms，整体连招流畅度显著提升。',
    tag: '体验服',
    tagClass: 'test'
  },
  {
    date: '2026.05.21',
    title: '巅峰赛高端局数据：元歌禁用率回落至 42%',
    excerpt: '随着版本趋于稳定，元歌在巅峰赛 2000+ 分段的 BP 率趋向合理，预计下版本继续观察表现。',
    tag: '数据报告',
    tagClass: 'data'
  }
]

const guides = [
  {
    title: 'S40 国服第一推荐：极限穿透爆发流出装',
    excerpt: '暗影战斧 → 冷静之靴 → 破军 → 碎星锤 → 宗师之力 → 名刀。核心思路：傀儡换位后三技能拉满穿透，一套瞬杀后排。',
    tag: '国服推荐',
    stats: { winRate: '58.2%', popularity: '★★★★★', difficulty: '★★★★' },
    previewItems: ['暗影战斧', '冷静之靴', '破军']
  },
  {
    title: '稳定上分型：半肉控制流出装指南',
    excerpt: '暗影战斧 → 抵抗之靴 → 冰痕之握 → 永夜守护 → 破军 → 贤者庇护。团战容错率更高，适合中高分段节奏。',
    tag: '稳健出装',
    stats: { winRate: '54.7%', popularity: '★★★★☆', difficulty: '★★★' },
    previewItems: ['暗影战斧', '冰痕之握', '永夜守护']
  },
  {
    title: '打野位元歌新玩法：野区入侵流思路',
    excerpt: '一级傀儡探草，二技能快速清野，3分钟抢夺河道之灵节奏点。铭文搭配：5异变+5红月、10鹰眼、6隐匿+4狩猎。',
    tag: '非主流',
    stats: { winRate: '51.3%', popularity: '★★★', difficulty: '★★★★★' },
    previewItems: ['追击刀锋', '暗影战斧', '破军']
  }
]

const tips = [
  {
    category: '基础连招',
    tagType: 'success',
    level: 1,
    title: '「1433223」基础爆发连招',
    description: '先一技能丢出傀儡 → 四技能与傀儡交换位置 → 三技能两段命中打满束缚 → 二技能两次输出 → 再三技能收尾。新手必须先练熟此基础连招。'
  },
  {
    category: '进阶技巧',
    tagType: 'warning',
    level: 2,
    title: '傀儡假身骗技能：诱导对手交出关键技能',
    description: '将傀儡放置在草丛边缘假装本体走位，等对手交出闪现/净化/控制后，本体从侧翼切入。注意傀儡血量较低时不要深追。'
  },
  {
    category: '高阶思路',
    tagType: 'danger',
    level: 3,
    title: 'KPL 职业技巧：无视野盲推三角度预判',
    description: '在已知敌方打野红开情况下，2分15秒左右在中路右侧草丛预判三技能束缚，配合打野成功率超过 70%。需结合小地图整体判断。'
  },
  {
    category: '生存意识',
    tagType: 'info',
    level: 2,
    title: '大招保命双用：不只是击杀，更是撤退神技',
    description: '大招无法选中期间可以等队友支援，也可以规避防御塔最后一下伤害。切记：大招冷却时不要贸然深追。'
  }
]

const topPlayers = [
  { name: '听安', team: 'MD', winRate: '67.3%', games: 142, rate: '92%' },
  { name: '枷锁', team: 'KSG', winRate: '64.1%', games: 128, rate: '86%' },
  { name: '桑杰', team: '自由人', winRate: '61.8%', games: 95, rate: '80%' },
  { name: '云天河', team: 'ESTAR', winRate: '59.5%', games: 176, rate: '74%' },
  { name: '小七', team: 'LGD', winRate: '57.2%', games: 83, rate: '68%' }
]
</script>

<style scoped lang="scss">
.news-panel {
  position: relative;
  z-index: 1;
  padding: 0;
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
}

.news-inner {
  position: relative;
  z-index: 2;
  display: flex;
  flex-direction: column;
  flex: 1;
  min-height: 0;
}

.news-header {
  text-align: center;
  margin-bottom: 20px;
}

.section-tag {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 6px 16px;
  background: rgba(168, 85, 247, 0.1);
  border: 1px solid rgba(168, 85, 247, 0.25);
  border-radius: 999px;
  font-size: 12px;
  color: var(--accent-mystery-light);
  margin-bottom: 12px;
  letter-spacing: 1px;
}

.section-title {
  font-size: 28px;
  font-weight: 800;
  letter-spacing: 2px;
  margin: 0;
}

.section-sub {
  color: var(--text-muted);
  font-weight: 400;
  font-size: 14px;
  margin-left: 6px;
}

.news-tabs {
  flex: 1;
  display: flex;
  flex-direction: column;

  :deep(.el-tabs__header) {
    margin: 0 0 20px 0;
    border-bottom: 1px solid rgba(168, 85, 247, 0.15);

    .el-tabs__nav-wrap::after {
      background-color: transparent;
    }

    .el-tabs__item {
      color: var(--text-secondary);
      font-size: 14px;
      padding: 0 16px;
      height: 40px;
      line-height: 40px;

      &.is-active {
        color: var(--accent-gold);
        font-weight: 600;
      }
    }

    .el-tabs__active-bar {
      background: linear-gradient(90deg, var(--accent-gold), var(--accent-mystery-light));
      height: 2px;
    }
  }

  :deep(.el-tabs__content) {
    flex: 1;
    overflow-y: auto;
    padding-right: 8px;

    &::-webkit-scrollbar {
      width: 4px;
    }

    &::-webkit-scrollbar-thumb {
      background: linear-gradient(180deg, var(--accent-gold), var(--accent-mystery-light));
      border-radius: 2px;
    }
  }

  :deep(.el-tab-pane) {
    height: 100%;
  }
}

.news-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.news-card {
  position: relative;
  background: var(--bg-card);
  border: 1px solid var(--border-color);
  border-radius: 14px;
  padding: 16px 18px;
  cursor: pointer;
  transition: var(--transition-smooth);
  overflow: hidden;

  &::before {
    content: '';
    position: absolute;
    left: 0;
    top: 0;
    bottom: 0;
    width: 3px;
    background: linear-gradient(180deg, var(--accent-gold), transparent);
    transform: scaleY(0);
    transform-origin: top;
    transition: transform 0.3s ease;
  }

  &:hover {
    transform: translateY(-3px);
    border-color: var(--border-glow);
    box-shadow: var(--shadow-card), 0 6px 24px rgba(199, 164, 84, 0.1);

    &::before {
      transform: scaleY(1);
    }

    .news-read-more {
      color: var(--accent-gold);
      transform: translateX(3px);
    }
  }

  &.featured {
    background: linear-gradient(
      135deg,
      rgba(26, 26, 46, 0.95) 0%,
      rgba(107, 33, 168, 0.15) 100%
    );
    border-color: rgba(168, 85, 247, 0.35);
  }
}

.news-badge {
  position: absolute;
  top: 12px;
  right: 12px;
  display: flex;
  align-items: center;
  gap: 4px;
  padding: 3px 10px;
  background: linear-gradient(135deg, #ff6b6b, #c92a2a);
  color: #fff;
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 1px;
  border-radius: 999px;
  box-shadow: 0 4px 12px rgba(201, 42, 42, 0.4);

  &.gold {
    background: linear-gradient(135deg, var(--accent-gold), var(--accent-primary));
    color: #1a1a2e;
    box-shadow: 0 4px 12px rgba(212, 175, 55, 0.4);
  }
}

.news-date {
  font-size: 11px;
  color: var(--text-muted);
  letter-spacing: 1px;
  margin-bottom: 6px;
}

.news-title {
  font-size: 15px;
  font-weight: 700;
  color: var(--text-primary);
  line-height: 1.5;
  margin: 0 0 6px 0;
}

.news-excerpt {
  font-size: 12.5px;
  color: var(--text-secondary);
  line-height: 1.7;
  margin: 0 0 12px 0;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.news-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.news-tag {
  padding: 3px 10px;
  border-radius: 6px;
  font-size: 11px;
  font-weight: 600;

  &.major {
    background: rgba(201, 42, 42, 0.15);
    color: #ff6b6b;
    border: 1px solid rgba(201, 42, 42, 0.3);
  }

  &.skin {
    background: rgba(212, 175, 55, 0.15);
    color: var(--accent-gold);
    border: 1px solid rgba(212, 175, 55, 0.3);
  }

  &.test {
    background: rgba(0, 212, 255, 0.12);
    color: var(--accent-cyan);
    border: 1px solid rgba(0, 212, 255, 0.3);
  }

  &.data {
    background: rgba(168, 85, 247, 0.12);
    color: var(--accent-mystery-light);
    border: 1px solid rgba(168, 85, 247, 0.3);
  }
}

.news-read-more {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  font-size: 12px;
  color: var(--text-muted);
  transition: var(--transition-smooth);
}

.guide-stats {
  display: flex;
  gap: 12px;
  margin-bottom: 8px;
  padding: 8px 10px;
  background: rgba(0, 0, 0, 0.3);
  border-radius: 8px;
}

.stat-item {
  display: flex;
  flex-direction: column;
  gap: 2px;
  flex: 1;
  text-align: center;
}

.stat-label {
  font-size: 10px;
  color: var(--text-muted);
  letter-spacing: 1px;
}

.stat-value {
  font-size: 13px;
  font-weight: 700;
  color: var(--text-primary);

  &.win {
    color: var(--accent-gold);
  }

  &.hot {
    color: #ff6b6b;
  }
}

.build-preview {
  display: flex;
  gap: 6px;
}

.eq-icon {
  width: 26px;
  height: 26px;
  border-radius: 6px;
  background: linear-gradient(135deg, #2d2d44, #1a1a2e);
  border: 1px solid var(--border-color);
  font-size: 9px;
  font-weight: 700;
  color: var(--accent-gold);
  display: flex;
  align-items: center;
  justify-content: center;
}

.tips-list {
  display: flex;
  flex-direction: column;
  gap: 14px;
}

.tip-item {
  display: flex;
  gap: 16px;
  padding: 14px 16px;
  background: var(--bg-card);
  border: 1px solid var(--border-color);
  border-radius: 12px;
  position: relative;
  overflow: hidden;
  transition: var(--transition-smooth);

  &::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    width: 4px;
    height: 100%;
    background: linear-gradient(180deg, var(--accent-gold), var(--accent-mystery-light));
  }

  &:hover {
    transform: translateX(4px);
    border-color: var(--border-glow);
    box-shadow: var(--shadow-card);
  }
}

.tip-number {
  min-width: 36px;
  height: 36px;
  border-radius: 10px;
  background: linear-gradient(135deg, var(--accent-gold), var(--accent-mystery-light));
  color: #0a0a0f;
  font-size: 15px;
  font-weight: 800;
  display: flex;
  align-items: center;
  justify-content: center;
  letter-spacing: 1px;
  flex-shrink: 0;
}

.tip-content {
  flex: 1;
  min-width: 0;
}

.tip-title {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 14px;
  font-weight: 700;
  color: var(--text-primary);
  margin: 0 0 6px 0;
  line-height: 1.4;
}

.tip-desc {
  font-size: 12.5px;
  color: var(--text-secondary);
  line-height: 1.7;
  margin: 0;
}

.stats-container {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.stat-card-group {
  display: flex;
  gap: 12px;
}

.big-stat-card {
  flex: 1;
  display: flex;
  gap: 14px;
  align-items: center;
  padding: 16px;
  background: var(--bg-card);
  border: 1px solid var(--border-color);
  border-radius: 14px;
  transition: var(--transition-smooth);

  &:hover {
    transform: translateY(-2px);
    border-color: var(--accent-gold);
    box-shadow: 0 8px 24px rgba(199, 164, 84, 0.15);
  }

  &.purple:hover {
    border-color: var(--accent-mystery-light);
    box-shadow: 0 8px 24px rgba(168, 85, 247, 0.2);
  }
}

.stat-icon {
  width: 52px;
  height: 52px;
  border-radius: 14px;
  background: linear-gradient(135deg, rgba(212, 175, 55, 0.2), rgba(212, 175, 55, 0.05));
  border: 1px solid rgba(212, 175, 55, 0.3);
  color: var(--accent-gold);
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;

  &.gold {
    background: linear-gradient(135deg, rgba(212, 175, 55, 0.25), rgba(212, 175, 55, 0.05));
  }
}

.stat-info {
  flex: 1;
  min-width: 0;
}

.big-stat-value {
  font-size: 26px;
  font-weight: 800;
  color: var(--text-primary);
  line-height: 1.2;
  margin-bottom: 4px;

  span {
    font-size: 14px;
    color: var(--accent-gold);
    font-weight: 700;
    margin-left: 2px;
  }
}

.stat-label {
  font-size: 12px;
  color: var(--text-muted);
  letter-spacing: 1px;
  margin-bottom: 4px;
}

.stat-trend {
  display: inline-flex;
  align-items: center;
  gap: 3px;
  font-size: 11px;
  font-weight: 600;
  color: var(--accent-gold);

  &.up {
    color: #51cf66;
  }
}

.skill-hero-list {
  background: var(--bg-card);
  border: 1px solid var(--border-color);
  border-radius: 14px;
  padding: 16px;
}

.list-title {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
  font-weight: 700;
  color: var(--text-primary);
  margin: 0 0 14px 0;
  padding-bottom: 10px;
  border-bottom: 1px solid var(--border-color);
}

.player-row {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 8px 0;
}

.player-rank {
  width: 24px;
  height: 24px;
  border-radius: 6px;
  background: rgba(168, 85, 247, 0.15);
  color: var(--accent-mystery-light);
  font-size: 12px;
  font-weight: 800;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.player-row:nth-child(-n+3) .player-rank {
  background: linear-gradient(135deg, var(--accent-gold), var(--accent-primary));
  color: #1a1a2e;
}

.player-info {
  width: 140px;
  flex-shrink: 0;
}

.player-name {
  font-size: 13px;
  font-weight: 700;
  color: var(--text-primary);
  margin-bottom: 2px;
}

.team-tag {
  color: var(--text-muted);
  font-weight: 500;
  font-size: 11px;
}

.player-meta {
  font-size: 11px;
  color: var(--text-muted);
}

.player-rate-bar {
  flex: 1;
  height: 6px;
  background: rgba(0, 0, 0, 0.4);
  border-radius: 999px;
  overflow: hidden;
}

.rate-fill {
  height: 100%;
  background: linear-gradient(90deg, var(--accent-mystery-light), var(--accent-gold));
  border-radius: 999px;
  box-shadow: 0 0 8px rgba(212, 175, 55, 0.5);
  transition: width 0.6s ease;
}

@media (max-width: 1200px) {
  .news-panel {
    padding: 0;
  }
}
</style>
