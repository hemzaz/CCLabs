/*
 * Claude Code Gamification — client-side progress tracker.
 * Everything lives in localStorage; anonymous, per-browser.
 *
 * What it does:
 *   - Renders a floating HUD on every page (points, streak, badges, % complete)
 *   - Adds checkboxes next to every Task heading, persists state
 *   - Wires up .ccg-quiz blocks: radio answers → Check button → feedback + explanation
 *   - Awards points for task completion, quiz correctness, lab completion, streak days
 *   - Fires a first-visit walkthrough overlay
 *   - Celebratory toast on big milestones (badge earned, lab complete, etc.)
 *
 * Scoring:
 *   - Each task checked:      10 pts
 *   - Each quiz answered:      5 pts (regardless of correctness — trying counts)
 *   - Each quiz correct:     +15 pts (bonus)
 *   - Each lab completed:    100 pts (all tasks + all quiz attempted)
 *   - Daily streak ≥ 3 days: +50 pts bonus on the third day and up
 *
 * Badges awarded:
 *   - First Step       — lab 001 complete
 *   - Part I Finisher  — labs 001-005 complete
 *   - Part II Finisher — labs 006-010 complete
 *   - Part III Finisher — labs 011-015 complete
 *   - Part IV Finisher — labs 016-020 complete
 *   - Part V Finisher  — labs 021-025 complete
 *   - Part VI Finisher — labs 026-030 complete
 *   - Capstone         — Capstone lab complete
 *   - Perfect Quiz     — scored 100% on any single-lab quiz
 *   - Streak 7         — 7-day learning streak
 */

(function () {
  'use strict';

  const KEY = 'ccg-progress-v1';
  const WALKTHROUGH_SEEN_KEY = 'ccg-walkthrough-seen-v1';
  const TOTAL_LABS = 31; // 30 numbered + Capstone
  const BADGES = {
    'first-step': { name: 'First Step', desc: 'Completed Lab 001', emoji: '👣' },
    'part-1': { name: 'Part I Finisher', desc: 'Labs 001–005 complete', emoji: '🟢' },
    'part-2': { name: 'Part II Finisher', desc: 'Labs 006–010 complete', emoji: '🔵' },
    'part-3': { name: 'Part III Finisher', desc: 'Labs 011–015 complete', emoji: '🟣' },
    'part-4': { name: 'Part IV Finisher', desc: 'Labs 016–020 complete', emoji: '🟠' },
    'part-5': { name: 'Part V Finisher', desc: 'Labs 021–025 complete', emoji: '🔴' },
    'part-6': { name: 'Part VI Finisher', desc: 'Labs 026–030 complete', emoji: '🟡' },
    'capstone': { name: 'Capstone Hero', desc: 'Capstone complete', emoji: '🏆' },
    'perfect-quiz': { name: 'Perfect Quiz', desc: 'Aced a lab quiz', emoji: '💯' },
    'streak-7': { name: 'On Fire', desc: '7-day learning streak', emoji: '🔥' },
    'prompting-sensei': { name: 'Prompting Sensei', desc: 'Lab 031 (Prompting Workshop) complete', emoji: '🥋' },
    'checkpoint-sweep': { name: 'Checkpoint Sweep', desc: 'Aced all six Part checkpoints', emoji: '🎯' }
  };
  const PART_LABS = {
    'part-1': ['001', '002', '003', '004', '005'],
    'part-2': ['006', '007', '008', '009', '010'],
    'part-3': ['011', '012', '013', '014', '015'],
    'part-4': ['016', '017', '018', '019', '020'],
    'part-5': ['021', '022', '023', '024', '025'],
    'part-6': ['026', '027', '028', '029', '030']
  };

  function load() {
    try {
      const raw = localStorage.getItem(KEY);
      if (!raw) return defaults();
      const parsed = JSON.parse(raw);
      return Object.assign(defaults(), parsed);
    } catch (e) {
      return defaults();
    }
  }

  function defaults() {
    return {
      tasks: {},          // { "001": { "task-1": true, ... }, ... }
      quiz: {},           // { "001": { "q1": { picked: "b", correct: true }, ... }, ... }
      labsComplete: [],   // ["001", "002", ...]
      points: 0,
      streak: 0,
      lastActive: null,   // "YYYY-MM-DD"
      badges: []
    };
  }

  function save(state) {
    try {
      localStorage.setItem(KEY, JSON.stringify(state));
    } catch (e) { /* quota full or private mode — ignore */ }
  }

  function todayISO() {
    return new Date().toISOString().slice(0, 10);
  }

  function daysBetween(a, b) {
    if (!a || !b) return Infinity;
    return Math.round((new Date(b) - new Date(a)) / 86400000);
  }

  function updateStreak(state) {
    const today = todayISO();
    if (state.lastActive === today) return;
    const gap = daysBetween(state.lastActive, today);
    if (gap === 1) state.streak += 1;
    else if (gap > 1) state.streak = 1;
    else if (!state.lastActive) state.streak = 1;
    state.lastActive = today;
    if (state.streak >= 7 && !state.badges.includes('streak-7')) {
      awardBadge(state, 'streak-7');
    }
    if (state.streak >= 3) state.points += 50;
  }

  function awardBadge(state, id) {
    if (!state.badges.includes(id)) {
      state.badges.push(id);
      toast(`Badge earned: ${BADGES[id].emoji} ${BADGES[id].name}`, 'gold');
    }
  }

  function currentLabId() {
    // Derive from URL:
    //   /CCLabs/001-InstallAuth/           → "001"
    //   /CCLabs/_CAPSTONE/                 → "capstone"
    //   /CCLabs/_CHECKPOINTS/A/            → "checkpoint-a"
    const path = window.location.pathname;
    const match = path.match(/\/(\d{3})-[A-Za-z]/);
    if (match) return match[1];
    if (/_CAPSTONE/.test(path)) return 'capstone';
    const cp = path.match(/_CHECKPOINTS\/([A-Fa-f])/);
    if (cp) return 'checkpoint-' + cp[1].toLowerCase();
    return null;
  }

  // ------- TASKS --------
  function initTasks(state) {
    const lab = currentLabId();
    if (!lab) return;
    // mkdocs' baselevel bumps headings, so Task titles can land at h3/h4/h5.
    // Match on text, not on tag.
    const headings = document.querySelectorAll('article h3, article h4, article h5, article h6');
    headings.forEach((h) => {
      const text = (h.textContent || '').trim();
      const m = text.match(/^Task\s+(\d+)/i);
      if (!m) return;
      const taskId = 'task-' + m[1];
      state.tasks[lab] = state.tasks[lab] || {};
      // Inject checkbox at the start of the heading (only once)
      if (h.querySelector('.ccg-task-check')) return;
      const cb = document.createElement('input');
      cb.type = 'checkbox';
      cb.className = 'ccg-task-check';
      cb.dataset.lab = lab;
      cb.dataset.task = taskId;
      cb.checked = !!state.tasks[lab][taskId];
      cb.setAttribute('aria-label', 'Mark task complete');
      h.insertBefore(cb, h.firstChild);
      cb.addEventListener('change', () => onTaskToggle(cb));
    });
  }

  function onTaskToggle(cb) {
    const state = load();
    const lab = cb.dataset.lab;
    const task = cb.dataset.task;
    state.tasks[lab] = state.tasks[lab] || {};
    if (cb.checked) {
      if (!state.tasks[lab][task]) state.points += 10;
      state.tasks[lab][task] = true;
    } else {
      if (state.tasks[lab][task]) state.points = Math.max(0, state.points - 10);
      delete state.tasks[lab][task];
    }
    updateStreak(state);
    maybeMarkLabComplete(state, lab);
    save(state);
    renderHud();
    renderLabProgress();
  }

  // ------- QUIZ --------
  function initQuiz(state) {
    const lab = currentLabId();
    if (!lab) return;
    const quizzes = document.querySelectorAll('.ccg-quiz');
    quizzes.forEach((quiz) => {
      const qs = quiz.querySelectorAll('.ccg-q');
      qs.forEach((q, idx) => {
        const qid = 'q' + (idx + 1);
        state.quiz[lab] = state.quiz[lab] || {};
        const stored = state.quiz[lab][qid];
        const btn = q.querySelector('.ccg-check');
        const explain = q.querySelector('.ccg-explain');
        if (explain) explain.style.display = 'none';
        if (stored) {
          // Restore state: pick the radio, reveal feedback
          const input = q.querySelector(`input[value="${stored.picked}"]`);
          if (input) input.checked = true;
          q.classList.add(stored.correct ? 'ccg-correct' : 'ccg-wrong');
          if (explain) explain.style.display = 'block';
          if (btn) btn.disabled = true;
        }
        if (btn) {
          btn.addEventListener('click', (e) => {
            e.preventDefault();
            onQuizCheck(q, lab, qid);
          });
        }
      });
    });
  }

  function onQuizCheck(q, lab, qid) {
    const picked = q.querySelector('input[type="radio"]:checked');
    if (!picked) {
      toast('Pick an answer first.', 'hint');
      return;
    }
    const state = load();
    const answer = q.getAttribute('data-answer');
    const correct = picked.value === answer;
    state.quiz[lab] = state.quiz[lab] || {};
    const first = !state.quiz[lab][qid];
    state.quiz[lab][qid] = { picked: picked.value, correct };
    if (first) {
      state.points += 5;
      if (correct) state.points += 15;
    }
    q.classList.remove('ccg-correct', 'ccg-wrong');
    q.classList.add(correct ? 'ccg-correct' : 'ccg-wrong');
    const explain = q.querySelector('.ccg-explain');
    if (explain) explain.style.display = 'block';
    const btn = q.querySelector('.ccg-check');
    if (btn) btn.disabled = true;
    if (correct) toast('Correct! +20 points', 'good');
    else toast('Not quite — read the explanation.', 'hint');
    // Perfect quiz badge
    const allQs = Array.from(q.closest('.ccg-quiz').querySelectorAll('.ccg-q'));
    const allAnswered = allQs.every((el, i) => state.quiz[lab]['q' + (i + 1)]);
    const allCorrect = allQs.every((el, i) => state.quiz[lab]['q' + (i + 1)] && state.quiz[lab]['q' + (i + 1)].correct);
    if (allAnswered && allCorrect) awardBadge(state, 'perfect-quiz');
    updateStreak(state);
    maybeMarkLabComplete(state, lab);
    save(state);
    renderHud();
    renderLabProgress();
  }

  // ------- LAB COMPLETE --------
  function maybeMarkLabComplete(state, lab) {
    const tasks = state.tasks[lab] || {};
    const quiz = state.quiz[lab] || {};
    const tasksDone = Object.values(tasks).filter(Boolean).length;
    const quizDone = Object.keys(quiz).length;
    if (tasksDone >= 5 && quizDone >= 3) {
      if (!state.labsComplete.includes(lab)) {
        state.labsComplete.push(lab);
        state.points += 100;
        toast(`Lab ${lab} complete! +100 points`, 'good');
        confetti();
      }
    }
    // Badges per part
    Object.keys(PART_LABS).forEach((part) => {
      const need = PART_LABS[part];
      const have = need.filter((l) => state.labsComplete.includes(l));
      if (have.length === need.length) awardBadge(state, part);
    });
    if (state.labsComplete.includes('001') && !state.badges.includes('first-step')) {
      awardBadge(state, 'first-step');
    }
    if (state.labsComplete.includes('capstone')) awardBadge(state, 'capstone');
    if (state.labsComplete.includes('031')) awardBadge(state, 'prompting-sensei');
    const checkpointIds = ['checkpoint-a', 'checkpoint-b', 'checkpoint-c', 'checkpoint-d', 'checkpoint-e', 'checkpoint-f'];
    if (checkpointIds.every((id) => state.labsComplete.includes(id))) awardBadge(state, 'checkpoint-sweep');
  }

  // ------- HUD --------
  function renderHud() {
    const state = load();
    let hud = document.getElementById('ccg-hud');
    if (!hud) {
      hud = document.createElement('div');
      hud.id = 'ccg-hud';
      hud.innerHTML = `
        <button class="ccg-hud-toggle" aria-label="Toggle progress HUD">📊</button>
        <div class="ccg-hud-body">
          <h3>Your Claude Labs Journey</h3>
          <div class="ccg-hud-stats">
            <div class="ccg-stat"><span class="ccg-stat-label">Labs</span><span class="ccg-stat-value" id="ccg-labs">0/${TOTAL_LABS}</span></div>
            <div class="ccg-stat"><span class="ccg-stat-label">Points</span><span class="ccg-stat-value" id="ccg-points">0</span></div>
            <div class="ccg-stat"><span class="ccg-stat-label">Streak</span><span class="ccg-stat-value" id="ccg-streak">0 days</span></div>
          </div>
          <div class="ccg-progress-bar"><div class="ccg-progress-fill" id="ccg-bar"></div></div>
          <div class="ccg-badges" id="ccg-badges"></div>
          <p class="ccg-hud-cta"><a href="#" id="ccg-reset">reset progress</a></p>
        </div>`;
      document.body.appendChild(hud);
      hud.querySelector('.ccg-hud-toggle').addEventListener('click', () => {
        hud.classList.toggle('ccg-open');
      });
      hud.querySelector('#ccg-reset').addEventListener('click', (e) => {
        e.preventDefault();
        if (confirm('Reset all progress? This clears your points, streak, and task/quiz state for all labs.')) {
          localStorage.removeItem(KEY);
          localStorage.removeItem(WALKTHROUGH_SEEN_KEY);
          window.location.reload();
        }
      });
    }
    const done = state.labsComplete.length;
    const pct = Math.round((done / TOTAL_LABS) * 100);
    hud.querySelector('#ccg-labs').textContent = `${done}/${TOTAL_LABS}`;
    hud.querySelector('#ccg-points').textContent = state.points.toLocaleString();
    hud.querySelector('#ccg-streak').textContent = state.streak + (state.streak === 1 ? ' day' : ' days');
    hud.querySelector('#ccg-bar').style.width = pct + '%';
    const badgesEl = hud.querySelector('#ccg-badges');
    badgesEl.innerHTML = '';
    Object.keys(BADGES).forEach((id) => {
      const earned = state.badges.includes(id);
      const b = BADGES[id];
      const el = document.createElement('span');
      el.className = 'ccg-badge' + (earned ? ' earned' : '');
      el.title = `${b.name} — ${b.desc}`;
      el.textContent = b.emoji;
      badgesEl.appendChild(el);
    });
  }

  function renderLabProgress() {
    const lab = currentLabId();
    if (!lab) return;
    const state = load();
    const tasks = state.tasks[lab] || {};
    const quiz = state.quiz[lab] || {};
    const tasksDone = Object.values(tasks).filter(Boolean).length;
    const totalTasks = Array.from(
      document.querySelectorAll('article h3, article h4, article h5, article h6')
    ).filter((h) => /^Task\s+\d+/i.test((h.textContent || '').trim())).length;
    const quizDone = Object.keys(quiz).length;
    const totalQuiz = document.querySelectorAll('.ccg-quiz .ccg-q').length;
    let banner = document.getElementById('ccg-lab-banner');
    if (!banner) {
      banner = document.createElement('div');
      banner.id = 'ccg-lab-banner';
      const article = document.querySelector('article');
      if (article && article.firstChild) article.insertBefore(banner, article.firstChild);
    }
    const complete = state.labsComplete.includes(lab);
    const emoji = complete ? '✅' : tasksDone > 0 || quizDone > 0 ? '🚧' : '👋';
    banner.innerHTML = `
      <span class="ccg-banner-emoji">${emoji}</span>
      <span class="ccg-banner-text">
        <strong>Lab ${lab === 'capstone' ? 'Capstone' : lab}</strong>
        — Tasks <b>${tasksDone}/${totalTasks}</b> · Quiz <b>${quizDone}/${totalQuiz}</b>
        ${complete ? ' · <span class="ccg-complete">Complete</span>' : ''}
      </span>`;
  }

  // ------- CONFETTI --------
  // A tiny canvas-less confetti burst: 60 absolutely-positioned colored squares
  // that fall and fade. No deps, no Canvas, respects prefers-reduced-motion.
  function confetti() {
    if (window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;
    const colors = ['#8b5cf6', '#22c55e', '#f59e0b', '#ef4444', '#3b82f6', '#ec4899'];
    const N = 60;
    for (let i = 0; i < N; i++) {
      const piece = document.createElement('div');
      piece.className = 'ccg-confetti-piece';
      piece.style.left = Math.random() * 100 + 'vw';
      piece.style.background = colors[i % colors.length];
      piece.style.animationDelay = (Math.random() * 0.4) + 's';
      piece.style.animationDuration = (2 + Math.random() * 1.5) + 's';
      piece.style.transform = 'rotate(' + (Math.random() * 360) + 'deg)';
      document.body.appendChild(piece);
      setTimeout(() => piece.remove(), 4000);
    }
  }

  // ------- TOAST --------
  function toast(text, kind) {
    kind = kind || 'info';
    const t = document.createElement('div');
    t.className = 'ccg-toast ccg-toast-' + kind;
    t.textContent = text;
    document.body.appendChild(t);
    requestAnimationFrame(() => t.classList.add('show'));
    setTimeout(() => {
      t.classList.remove('show');
      setTimeout(() => t.remove(), 300);
    }, 2400);
  }

  // ------- WALKTHROUGH --------
  function maybeWalkthrough() {
    if (localStorage.getItem(WALKTHROUGH_SEEN_KEY)) return;
    const steps = [
      { title: 'Welcome, future Claude whisperer 👋', body: '30 labs + Capstone + an optional prompting workshop take you from zero to shipping features with Claude Code. You\'re already doing the hardest part: showing up.' },
      { title: 'Your progress is yours', body: 'Everything is saved locally in this browser. No account, no tracking, no login. Click the 📊 button in the bottom-right to see your stats any time.' },
      { title: 'Tasks and quizzes earn points', body: 'Each task = 10 pts. Each quiz question attempted = 5 pts, correct = +15 pts. Finish a lab = 100 pts. Seven-day streak = a shiny 🔥 badge.' },
      { title: 'You don\'t have to be perfect', body: 'Get answers wrong, peek at solutions, replay labs. This is a learning environment, not a judgment environment. Trying > hesitating.' },
      { title: 'Checkpoints close each Part', body: 'After every 5 labs you\'ll hit a Checkpoint — a short quiz plus a small integration task. Earn the 🎯 Checkpoint Sweep badge by acing all six.' },
      { title: 'Start anywhere', body: 'Lab 001 is the on-ramp. You can also jump to whichever part looks interesting. Let\'s go.' }
    ];
    let i = 0;
    const modal = document.createElement('div');
    modal.className = 'ccg-walkthrough';
    modal.innerHTML = `
      <div class="ccg-walkthrough-card">
        <h2 class="ccg-wt-title"></h2>
        <p class="ccg-wt-body"></p>
        <div class="ccg-wt-dots"></div>
        <div class="ccg-wt-actions">
          <button class="ccg-wt-skip">Skip</button>
          <button class="ccg-wt-next">Next →</button>
        </div>
      </div>`;
    document.body.appendChild(modal);
    const render = () => {
      modal.querySelector('.ccg-wt-title').textContent = steps[i].title;
      modal.querySelector('.ccg-wt-body').textContent = steps[i].body;
      const dots = modal.querySelector('.ccg-wt-dots');
      dots.innerHTML = steps.map((_, j) => `<span class="ccg-wt-dot${j === i ? ' active' : ''}"></span>`).join('');
      modal.querySelector('.ccg-wt-next').textContent = i === steps.length - 1 ? 'Start →' : 'Next →';
    };
    const close = () => {
      localStorage.setItem(WALKTHROUGH_SEEN_KEY, '1');
      modal.classList.remove('show');
      setTimeout(() => modal.remove(), 300);
    };
    modal.querySelector('.ccg-wt-skip').addEventListener('click', close);
    modal.querySelector('.ccg-wt-next').addEventListener('click', () => {
      if (i === steps.length - 1) close();
      else { i++; render(); }
    });
    render();
    requestAnimationFrame(() => modal.classList.add('show'));
  }

  // ------- BOOT --------
  function boot() {
    const state = load();
    updateStreak(state);
    save(state);
    initTasks(state);
    initQuiz(state);
    renderHud();
    renderLabProgress();
    maybeWalkthrough();
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', boot);
  } else {
    boot();
  }
})();
