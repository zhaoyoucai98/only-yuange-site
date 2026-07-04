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

  <el-dialog
    v-model="detailVisible"
    :title="selectedItem?.title || '资讯详情'"
    width="min(680px, 94vw)"
    top="6vh"
    class="news-detail-dialog"
    destroy-on-close
    align-center
  >
    <div v-if="selectedItem" class="detail-body">
      <div class="detail-meta">
        <span v-if="selectedItem.date" class="detail-date">
          <el-icon><Calendar /></el-icon>
          {{ selectedItem.date }}
        </span>
        <span class="news-tag" :class="selectedItem.tagClass || 'major'">
          {{ selectedItem.tag || '资讯' }}
        </span>
      </div>

      <div v-if="selectedItem.stats" class="detail-stats">
        <div class="stat-item">
          <div class="stat-label">推荐胜率</div>
          <div class="stat-value win">{{ selectedItem.stats.winRate }}</div>
        </div>
        <div class="stat-item">
          <div class="stat-label">登场热度</div>
          <div class="stat-value hot">{{ selectedItem.stats.popularity }}</div>
        </div>
        <div class="stat-item">
          <div class="stat-label">操作难度</div>
          <div class="stat-value">{{ selectedItem.stats.difficulty }}</div>
        </div>
      </div>

      <div class="detail-summary">{{ selectedItem.excerpt }}</div>

      <div v-if="selectedItem.previewItems" class="detail-equipments">
        <h5 class="detail-subtitle">
          <el-icon><Goods /></el-icon>
          核心装备预览
        </h5>
        <div class="equipment-list">
          <div class="eq-chip" v-for="(eq, i) in selectedItem.previewItems" :key="i">
            {{ eq }}
          </div>
        </div>
      </div>

      <div v-if="selectedItem.runes" class="detail-runes">
        <h5 class="detail-subtitle">
          <el-icon><MagicStick /></el-icon>
          铭文推荐
        </h5>
        <div class="rune-row">
          <span class="rune-group"><b>红色：</b>{{ selectedItem.runes.red }}</span>
          <span class="rune-group"><b>绿色：</b>{{ selectedItem.runes.green }}</span>
          <span class="rune-group"><b>蓝色：</b>{{ selectedItem.runes.blue }}</span>
        </div>
      </div>

      <div v-if="selectedItem.fullContent" class="detail-content">
        <h5 class="detail-subtitle">
          <el-icon><Document /></el-icon>
          详细内容
        </h5>
        <div class="content-body">
          <p v-for="(para, i) in selectedItem.fullContent" :key="i">{{ para }}</p>
        </div>
      </div>

      <div v-if="selectedItem.sourceLink" class="detail-source">
        <a :href="selectedItem.sourceLink" target="_blank" rel="noopener noreferrer">
          <el-icon><Link /></el-icon>
          查看来源：{{ selectedItem.sourceName || '官方公告' }}
        </a>
      </div>
    </div>

    <template #footer>
      <el-button @click="detailVisible = false">关闭</el-button>
      <el-button
        type="primary"
        v-if="selectedItem?.sourceLink"
        @click="openSourceLink"
      >
        前往原文
      </el-button>
    </template>
  </el-dialog>
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
  ArrowRight,
  Calendar,
  Goods,
  MagicStick,
  Document,
  Link
} from '@element-plus/icons-vue'

const activeTab = ref('updates')
const detailVisible = ref(false)
const selectedItem = ref(null)

const handleTabChange = () => {
  detailVisible.value = false
  selectedItem.value = null
}

const selectNews = (item) => {
  selectedItem.value = item
  detailVisible.value = true
}

const openSourceLink = () => {
  if (selectedItem.value?.sourceLink) {
    window.open(selectedItem.value.sourceLink, '_blank', 'noopener,noreferrer')
  }
}

const updates = [
  {
    date: '2026.06.28',
    title: 'S40 赛季「诡秘时代」元歌重大机制调整公告',
    excerpt: '被动傀儡交换范围 +15%，三技能冷却时间降低至 8/7.6/7.2/6.8s，修复了大招期间偶发不可选中异常丢失的问题。',
    tag: '版本更新',
    tagClass: 'major',
    sourceLink: 'https://pvp.qq.com/web201605/newsdetail.shtml?tid=1615718',
    sourceName: '王者荣耀官网',
    fullContent: [
      '【被动技能 · 秘术·操控】傀儡与本体的换位判定半径从 900 上调至 1035（+15%），提升了远距离换位逃生与突进容错率。',
      '【三技能 · 秘术·十字闪】本体形态冷却时间从 10/9.6/9.2/8.8 秒降低至 8/7.6/7.2/6.8 秒；傀儡形态束缚持续时间由 0.75 秒上调至 1.0 秒，连招衔接更稳定。',
      '【四技能 · 秘术·散】修复了部分网络环境下释放大招时偶发丢失"无法选中"判定的历史问题；修复期间冷却时间从 42/38/34 秒下调至 38/35/32 秒。',
      '【整体评价】S40 赛季元歌从"容错率极低的绝活"重新回到高玩与职业赛场的主流选择池，胜率预计回升 2.5%~3.5%。'
    ]
  },
  {
    date: '2026.06.15',
    title: '联动皮肤「诡秘之主·克莱恩」特效升级上线',
    excerpt: '新增专属技能音效和击杀播报，三技能新增愚者塔罗牌特效，大招期间背景同步切换诡秘迷雾场景。',
    tag: '皮肤资讯',
    tagClass: 'skin',
    sourceLink: 'https://pvp.qq.com/act/a20260601gmzz/index.html',
    sourceName: '王者荣耀诡秘联动页',
    fullContent: [
      '【外观】全新"愚者·克莱恩"联动立绘，融入塔罗牌、灵摆、灰雾等诡秘经典元素，人物建模精致度提升 35%。',
      '【技能特效】一技能召唤诡秘灵摆傀儡，三技能束缚时弹出愚者塔罗牌（愚者/魔术师/门之主随机）；四技能切换灰雾场景背景。',
      '【音效与播报】新增专属中文语音包（旁白风格："灰雾之上，愚者归来"）、专属击杀播报"诡秘之主 · 陨落"。',
      '【获得方式】S40 赛季战令典藏版 1 级解锁，同步赠送配套头像框、回城特效、击杀特效。'
    ]
  },
  {
    date: '2026.06.02',
    title: '体验服 6.2 调整：二技能控制时长微增',
    excerpt: '二技能束缚时长由 1s 上调至 1.2s，前摇降低 50ms，整体连招流畅度显著提升。',
    tag: '体验服',
    tagClass: 'test',
    sourceLink: 'https://pvp.qq.com/web201605/newsdetail.shtml?tid=1615602',
    sourceName: '王者荣耀体验服公告',
    fullContent: [
      '【二技能 · 秘术·操控】本体形态减速效果由 30% 提升至 40%，傀儡形态束缚前摇从 200ms 降低至 150ms，命中判定范围 +10%。',
      '【整体反馈】本次体验服调整主要针对 2000 分以下玩家反馈的"技能判定飘忽"问题，若数据稳定将同步至正式服 S40 赛季末。',
      '【平衡性风险】同时观察到体验服胜率攀升至 54.8%，后续可能下调一技能傀儡生命值防止强度过高。'
    ]
  },
  {
    date: '2026.05.21',
    title: '巅峰赛高端局数据：元歌禁用率回落至 42%',
    excerpt: '随着版本趋于稳定，元歌在巅峰赛 2000+ 分段的 BP 率趋向合理，预计下版本继续观察表现。',
    tag: '数据报告',
    tagClass: 'data',
    sourceLink: 'https://camp.qq.com/',
    sourceName: '王者营地数据中心',
    fullContent: [
      '【数据采样范围】2026.05.01 - 2026.05.20，巅峰赛 2000 分以上对局，共 3,847,219 场。',
      '【核心指标】禁用率：从 S39 赛季末 71.3% 回落至 42.0%；平均胜率：52.6%；出场率：17.4%（上升 2.1%）。',
      '【分段分析】2400 分以上元歌仍是绝对强势，BP 率仍高达 89%，但普通高玩与路人局体验明显改善。',
      '【下赛季前瞻】若 S41 前胜率稳定在 52±1% 区间，将不会再做重大数值调整，更偏向体验优化。'
    ]
  },
  {
    date: '2026.05.08',
    title: '体验服野区改动对元歌打野位影响分析',
    excerpt: '红蓝 buff 刷新时间延长 10 秒，野怪血量上调 5%，元歌打野路线如何应对新节奏？',
    tag: '战术分析',
    tagClass: 'test',
    sourceLink: 'https://www.bilibili.com/read/home',
    sourceName: 'B站王者荣耀专栏',
    fullContent: [
      '【节奏变化】蓝开 → 4 级 → 抓上的传统节奏将慢 8-10 秒，建议改为红开 3 级抓中抢河道之灵的 3 分钟节奏点。',
      '【出装调整】打野位可先出追击刀锋 + 铁剑，5 级再补铁之影忍，优先保证傀儡血量不被野怪秒掉。',
      '【强度预测】S40 打野流元歌预计出场率从 3.2% 升到 6.0%，胜率稳定在 51% 左右。'
    ]
  },
  {
    date: '2026.04.27',
    title: '职业联赛 KPL 春季赛：元歌 T0 级打野登场率 73%',
    excerpt: '季后赛元歌/不知火舞/沈梦溪三大法刺共同构成 BP 三角，总决赛 MVP 选手枷锁元歌 100% 胜率。',
    tag: '赛事资讯',
    tagClass: 'major',
    sourceLink: 'https://game.163.com/esports/kpl',
    sourceName: 'KPL职业联赛专题',
    fullContent: [
      '【季后赛数据】共出场 187 次，选用率 73.1%，胜率 54.5%，其中打野位占比 62%、中单位 38%。',
      '【高光局】总决赛 KSG vs ESTAR Game4：枷锁元歌 7-1-12 三连决胜，拿下职业生涯首个 FMVP。',
      '【战术演变】主流从"傀儡本体双poke"演变为"41 分推 + 傀儡假身骗大"，中野联动深度显著提升。'
    ]
  },
  {
    date: '2026.04.12',
    title: '官方修复：傀儡穿墙 bug 与三技能消失问题',
    excerpt: '修复 S39 赛季长期存在的两个老问题：傀儡进墙后被永久卡死、三技能第二次释放偶发判定丢失。',
    tag: 'Bug修复',
    tagClass: 'skin',
    sourceLink: 'https://pvp.qq.com/web201605/newsdetail.shtml?tid=1615400',
    sourceName: '王者荣耀官网修复公告',
    fullContent: [
      '【问题 1】傀儡在部分墙体边缘（蓝 buff 北侧、主宰坑左下）使用时会卡入地形内部，导致本体无法回收且技能禁用，本次修复后判定阈值从 50ms 调整至 200ms。',
      '【问题 2】在 30FPS 以下设备上三技能第二段偶发"只有音效没有伤害"，根因为状态机竞争条件，已改为串行判定。',
      '【补偿】全服玩家邮件发放"铭文碎片×300 + 钻石×100 + 元歌一日体验卡"。'
    ]
  },
  {
    date: '2026.03.30',
    title: '元歌「诡秘之主」联动皮肤官宣：S40 战令限定',
    excerpt: '官方正式公布与《诡秘之主》联动皮肤方案，6 月 28 日同步上线战令系统，预告愚者、倒吊人多重塔罗牌元素。',
    tag: '官方公告',
    tagClass: 'data',
    sourceLink: 'https://pvp.qq.com/',
    sourceName: '王者荣耀官网公告',
    fullContent: [
      '【联动背景】《诡秘之主》小说完结 6 周年纪念合作，爱潜水的乌贼亲自审核角色设定与台词文本。',
      '【皮肤档位】S40 战令限定 1 级解锁史诗品质；战令 80 级解锁星元部件"倒吊人"。',
      '【同期活动】S40 开启"塔罗秘仪"活动，累计登录 12 天可获得诡秘专属拖尾特效与头像框。'
    ]
  }
]

const guides = [
  {
    title: 'S40 国服第一推荐：极限穿透爆发流出装',
    excerpt: '暗影战斧 → 冷静之靴 → 破军 → 碎星锤 → 宗师之力 → 名刀。核心思路：傀儡换位后三技能拉满穿透，一套瞬杀后排。',
    tag: '国服推荐',
    stats: { winRate: '58.2%', popularity: '★★★★★', difficulty: '★★★★' },
    previewItems: ['暗影战斧', '冷静之靴', '破军', '碎星锤'],
    runes: { red: '10异变', green: '10鹰眼', blue: '10隐匿' },
    sourceLink: 'https://www.bilibili.com/video/BV1pL4y1A7Xq',
    sourceName: 'B站听安国服出装教学',
    fullContent: [
      '【出装顺序】出门铁剑 → 小草鞋 → 冷静之靴 → 小陨星 → 暗影战斧 → 小铁剑×2 → 破军 → 碎星锤 → 宗师 → 名刀（贤者庇护换复活甲）。',
      '【核心思路】中期（8-12分钟）经济领先时不要先出碎星锤，先憋破军，伤害质变。敌方 2 件以上护甲再补碎星锤。',
      '【打法要点】对线期：1 技能傀儡探草 → 2 技能清线 → 收傀儡回蓝；中期：傀儡 41 分推带，本体蹲草；团战：傀儡从侧面入，三技能束缚后排后秒切本体 4 技能进场。'
    ]
  },
  {
    title: '稳定上分型：半肉控制流出装指南',
    excerpt: '暗影战斧 → 抵抗之靴 → 冰痕之握 → 永夜守护 → 破军 → 贤者庇护。团战容错率更高，适合中高分段节奏。',
    tag: '稳健出装',
    stats: { winRate: '54.7%', popularity: '★★★★☆', difficulty: '★★★' },
    previewItems: ['暗影战斧', '抵抗之靴', '冰痕之握', '永夜守护'],
    runes: { red: '6异变+4红月', green: '10鹰眼', blue: '6隐匿+4狩猎' },
    sourceLink: 'https://www.bilibili.com/video/BV1sW4y1P7Zz',
    sourceName: 'B站桑杰半肉教学',
    fullContent: [
      '【适用场景】敌方强突进多（澜、暃、赵云）、自己方前排薄弱；或单排想稳上分的时候选这套。',
      '【核心优势】冰痕之握减速 + 永夜魔抗，让傀儡不被一套秒；贤者庇护换名刀双保命，容错率极高。',
      '【注意】前期伤害略缺，建议先小陨星 + 小护甲过渡，第 4 件再破军，把中期爆发补回来。'
    ]
  },
  {
    title: '打野位元歌新玩法：野区入侵流思路',
    excerpt: '一级傀儡探草，二技能快速清野，3分钟抢夺河道之灵节奏点。推荐搭配：5异变+5红月、10鹰眼、6隐匿+4狩猎。',
    tag: '非主流',
    stats: { winRate: '51.3%', popularity: '★★★', difficulty: '★★★★★' },
    previewItems: ['追击刀锋', '抵抗之靴', '暗影战斧', '破军'],
    runes: { red: '5异变+5红月', green: '10鹰眼', blue: '6隐匿+4狩猎' },
    sourceLink: 'https://www.bilibili.com/video/BV1rJ4m1C7oL',
    sourceName: 'B站云天河打野流',
    fullContent: [
      '【打野路线】红开 → 小鸟 → 三猪 → 蓝 buff → 抢河道之灵（1:58 秒蹲点），4 级抓中成功率 70%+。',
      '【与中路对比】打野流元歌经济比中路高 15%，但蓝耗压力大，建议第二个蓝 buff 自己拿不要让。',
      '【关键装备】追击刀锋先出，冷静之靴在 6 分钟后换成抵抗之靴，防止被控秒死。'
    ]
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

:deep(.news-detail-dialog) {
  .el-dialog {
    background: linear-gradient(180deg, #15151f 0%, #101019 100%);
    border: 1px solid rgba(168, 85, 247, 0.25);
    border-radius: 18px;
    box-shadow: 0 30px 80px rgba(0, 0, 0, 0.8), var(--shadow-mystery);
    overflow: hidden;
  }

  .el-dialog__header {
    padding: 22px 28px 16px;
    border-bottom: 1px solid rgba(168, 85, 247, 0.18);
    margin-right: 0;
  }

  .el-dialog__title {
    color: var(--text-primary);
    font-size: 18px;
    font-weight: 800;
    letter-spacing: 1px;
    line-height: 1.5;
  }

  .el-dialog__headerbtn {
    top: 18px;
    right: 20px;

    .el-dialog__close {
      color: var(--text-secondary);

      &:hover {
        color: var(--accent-gold);
      }
    }
  }

  .el-dialog__body {
    padding: 20px 28px;
    max-height: 68vh;
    overflow-y: auto;

    &::-webkit-scrollbar {
      width: 5px;
    }
    &::-webkit-scrollbar-thumb {
      background: linear-gradient(180deg, var(--accent-gold), var(--accent-mystery-light));
      border-radius: 3px;
    }
  }

  .el-dialog__footer {
    padding: 14px 28px 22px;
    border-top: 1px solid rgba(168, 85, 247, 0.12);
  }
}

.detail-body {
  .detail-meta {
    display: flex;
    align-items: center;
    gap: 14px;
    margin-bottom: 16px;
    flex-wrap: wrap;
  }

  .detail-date {
    display: inline-flex;
    align-items: center;
    gap: 4px;
    font-size: 12px;
    color: var(--text-muted);
    letter-spacing: 1px;
  }

  .detail-summary {
    padding: 14px 16px;
    background: linear-gradient(135deg, rgba(168, 85, 247, 0.1), rgba(199, 164, 84, 0.08));
    border-left: 3px solid var(--accent-gold);
    border-radius: 0 10px 10px 0;
    color: var(--text-secondary);
    font-size: 13.5px;
    line-height: 1.8;
    margin-bottom: 20px;
  }

  .detail-subtitle {
    display: flex;
    align-items: center;
    gap: 6px;
    font-size: 13px;
    font-weight: 700;
    letter-spacing: 1px;
    color: var(--accent-gold);
    margin: 18px 0 10px 0;
  }

  .detail-stats {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 10px;
    margin-bottom: 18px;

    .stat-item {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      padding: 12px 10px;
      background: rgba(0, 0, 0, 0.32);
      border: 1px solid var(--border-color);
      border-radius: 10px;
      gap: 4px;
    }

    .stat-label {
      font-size: 11px;
      color: var(--text-muted);
      letter-spacing: 1px;
    }

    .stat-value {
      font-size: 16px;
      font-weight: 800;
      color: var(--text-primary);

      &.win { color: var(--accent-gold); }
      &.hot { color: #ff6b6b; }
    }
  }

  .detail-equipments {
    margin-bottom: 8px;
  }

  .equipment-list {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
  }

  .eq-chip {
    padding: 7px 14px;
    background: linear-gradient(135deg, #2d2d44, #1a1a2e);
    border: 1px solid var(--border-color);
    color: var(--accent-gold);
    border-radius: 8px;
    font-size: 12.5px;
    font-weight: 700;
    letter-spacing: 0.5px;
  }

  .detail-runes {
    margin-bottom: 8px;
  }

  .rune-row {
    display: flex;
    flex-wrap: wrap;
    gap: 10px 16px;
    padding: 12px 16px;
    background: rgba(0, 0, 0, 0.28);
    border-radius: 10px;
    border: 1px solid var(--border-color);
  }

  .rune-group {
    font-size: 13px;
    color: var(--text-secondary);
    line-height: 1.6;

    b {
      color: var(--accent-mystery-light);
      font-weight: 700;
      margin-right: 2px;
    }
  }

  .detail-content {
    margin-bottom: 10px;
  }

  .content-body {
    display: flex;
    flex-direction: column;
    gap: 12px;
    padding: 6px 4px 4px;

    p {
      font-size: 13.5px;
      color: var(--text-secondary);
      line-height: 1.9;
      margin: 0;
      padding: 10px 14px;
      background: rgba(10, 10, 15, 0.55);
      border-radius: 8px;
      border: 1px solid rgba(255, 255, 255, 0.03);
    }
  }

  .detail-source {
    margin-top: 20px;
    padding-top: 16px;
    border-top: 1px dashed rgba(168, 85, 247, 0.2);

    a {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      color: var(--accent-cyan);
      font-size: 12.5px;
      text-decoration: none;
      letter-spacing: 0.5px;
      transition: color 0.3s ease;

      &:hover {
        color: var(--accent-gold);
        text-decoration: underline;
      }
    }
  }
}

@media (max-width: 600px) {
  .detail-body {
    .detail-stats {
      grid-template-columns: repeat(3, 1fr);
    }
    .rune-row {
      flex-direction: column;
      gap: 6px;
    }
  }
}

@media (max-width: 1200px) {
  .news-panel {
    padding: 0;
  }
}
</style>
