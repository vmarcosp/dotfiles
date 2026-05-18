/*
 * to-html.js — micro-framework for /to-html artifacts.
 *
 * Load order in template.html (matters):
 *   1. <script src="https://cdn.tailwindcss.com">        (Tailwind Play CDN — must be first)
 *   2. <script>tailwind.config = { ... }</script>        (inline, sets palette — see template.html)
 *   3. <link  rel="stylesheet" href=".../to-html.css">   (th-* primitives)
 *   4. <script src=".../to-html.js">                     (this file: Alpine components)
 *   5. <script defer ...alpine collapse plugin>
 *   6. <script defer ...alpinejs>
 *
 * The Tailwind config is intentionally NOT in this file. Tailwind Play CDN
 * reads it from a synchronous inline assignment AFTER the CDN tag executes;
 * setting it via an external file (this one) does not work reliably.
 *
 * Plain ES2020. No modules. No build step.
 */

// ---------- Alpine components ----------

document.addEventListener('alpine:init', () => {
  // Copy a <pre><code> block's text content. Place on the wrapper around
  // <pre><code> (NOT on <pre> itself — the wrapper holds the copy button).
  // If highlight.js is loaded, this also auto-highlights the <code> on init.
  Alpine.data('codeBlock', () => ({
    copied: false,
    init() {
      if (!window.hljs) return;
      this.$el.querySelectorAll('pre code').forEach((el) => {
        try { window.hljs.highlightElement(el); } catch (_) {}
      });
    },
    copy() {
      const code = this.$el.querySelector('code');
      if (!code) return;
      navigator.clipboard.writeText(code.innerText);
      this.copied = true;
      setTimeout(() => (this.copied = false), 1200);
    },
  }));

  // Copy a fixed string. Usage: x-data="copyValue('text-to-copy', 'Button label')".
  Alpine.data('copyValue', (value, label = 'Copy') => ({
    copied: false,
    label,
    copy() {
      navigator.clipboard.writeText(value);
      this.copied = true;
      setTimeout(() => (this.copied = false), 1200);
    },
  }));

  // Live-config block. `initial` is an object of named values bound via x-model.
  // Call copy('postgresql://{{user}}@host:{{port}}/{{db}}') to fill placeholders.
  Alpine.data('configBlock', (initial) => ({
    ...initial,
    copy(template) {
      const filled = template.replace(/\{\{(\w+)\}\}/g, (_, key) => {
        const v = this[key];
        return v == null ? '' : String(v);
      });
      navigator.clipboard.writeText(filled);
      this.copied = true;
      setTimeout(() => (this.copied = false), 1200);
    },
    copied: false,
  }));

  // Collapsible prompt box. Defaults to collapsed when textContent > 200 chars.
  Alpine.data('promptBox', () => ({
    expanded: false,
    init() {
      const len = (this.$el.textContent || '').trim().length;
      this.expanded = len <= 200;
    },
    toggle() {
      this.expanded = !this.expanded;
    },
  }));

  // Scenario wrapper. Native <details> handles open state; this exists as a
  // scope for future per-scenario logic (analytics, deep-link, etc.).
  Alpine.data('scenario', () => ({}));

  // Walks descendant [x-data] scopes, collects each scope's plain reactive
  // state, and copies the union as JSON. Use `data-th-key="name"` on each
  // child scope to name it; otherwise scopes are labeled `scope_<index>`.
  Alpine.data('stateExport', () => ({
    copied: false,
    exportJSON() {
      const scopes = this.$root.querySelectorAll('[x-data]');
      const out = {};
      scopes.forEach((el, i) => {
        const data = Alpine.$data(el);
        const label = el.dataset.thKey || `scope_${i}`;
        const plain = {};
        for (const k in data) {
          const v = data[k];
          if (typeof v === 'function') continue;
          if (k.startsWith('$') || k.startsWith('_')) continue;
          plain[k] = v;
        }
        out[label] = plain;
      });
      navigator.clipboard.writeText(JSON.stringify(out, null, 2));
      this.copied = true;
      setTimeout(() => (this.copied = false), 1200);
    },
  }));

  // Active-tab tracker. `initial` is the default tab name; if omitted, the
  // first descendant [data-th-tab] is selected at init.
  Alpine.data('tabs', (initial = null) => ({
    active: initial,
    init() {
      if (!this.active) {
        const first = this.$root.querySelector('[data-th-tab]');
        if (first) this.active = first.dataset.thTab;
      }
    },
    is(name) {
      return this.active === name;
    },
    set(name) {
      this.active = name;
    },
  }));

  // Free-text filter over <tr> contents in <tbody>, plus sort-by-column on
  // <th> click for columns marked [data-th-sort]. Cells declare their key via
  // [data-th-cell="key"]; numeric columns should also set [data-th-value].
  Alpine.data('filterableTable', () => ({
    q: '',
    sortKey: null,
    sortDir: 'asc',
    init() {
      this._rows = Array.from(this.$root.querySelectorAll('tbody tr'));
    },
    matches(row) {
      if (!this.q) return true;
      return row.textContent.toLowerCase().includes(this.q.toLowerCase());
    },
    applyFilter() {
      this._rows.forEach((r) => {
        r.style.display = this.matches(r) ? '' : 'none';
      });
    },
    sortBy(key, type = 'string') {
      if (this.sortKey === key) {
        this.sortDir = this.sortDir === 'asc' ? 'desc' : 'asc';
      } else {
        this.sortKey = key;
        this.sortDir = 'asc';
      }
      const tbody = this.$root.querySelector('tbody');
      const sorted = [...this._rows].sort((a, b) => {
        const av = a.querySelector(`[data-th-cell="${key}"]`)?.dataset.thValue
                ?? a.querySelector(`[data-th-cell="${key}"]`)?.textContent
                ?? '';
        const bv = b.querySelector(`[data-th-cell="${key}"]`)?.dataset.thValue
                ?? b.querySelector(`[data-th-cell="${key}"]`)?.textContent
                ?? '';
        const cmp = type === 'number'
          ? (parseFloat(av) - parseFloat(bv))
          : String(av).localeCompare(String(bv));
        return this.sortDir === 'asc' ? cmp : -cmp;
      });
      sorted.forEach((r) => tbody.appendChild(r));
    },
    arrow(key) {
      if (this.sortKey !== key) return '';
      return this.sortDir === 'asc' ? ' ↑' : ' ↓';
    },
  }));

  // Free-text filter over a grid of cards (or any [data-th-card] children).
  // Each card may declare [data-th-search] with searchable keywords; otherwise
  // the card's full text content is searched.
  Alpine.data('searchableCards', () => ({
    q: '',
    init() {
      this._cards = Array.from(this.$root.querySelectorAll('[data-th-card]'));
    },
    applyFilter() {
      const needle = this.q.toLowerCase();
      this._cards.forEach((c) => {
        const hay = (c.dataset.thSearch || c.textContent).toLowerCase();
        c.style.display = !needle || hay.includes(needle) ? '' : 'none';
      });
    },
  }));

  // Inline SVG sparkline. Reads comma-separated values from [data-th-values];
  // optional [data-th-width] / [data-th-height] (default 80x20). Pink stroke.
  Alpine.data('sparkline', () => ({
    init() {
      const raw = this.$el.dataset.thValues || '';
      const values = raw.split(',').map((s) => parseFloat(s.trim())).filter((n) => !isNaN(n));
      if (!values.length) return;
      const w = parseInt(this.$el.dataset.thWidth || '80', 10);
      const h = parseInt(this.$el.dataset.thHeight || '20', 10);
      const min = Math.min(...values);
      const max = Math.max(...values);
      const range = max - min || 1;
      const stepX = w / Math.max(1, values.length - 1);
      const points = values
        .map((v, i) => {
          const x = i * stepX;
          const y = h - ((v - min) / range) * h;
          return `${x.toFixed(1)},${y.toFixed(1)}`;
        })
        .join(' ');
      this.$el.innerHTML = `<svg width="${w}" height="${h}" viewBox="0 0 ${w} ${h}" style="vertical-align:middle">
        <polyline fill="none" stroke="#F8C8D8" stroke-width="1.5" points="${points}"></polyline>
      </svg>`;
    },
  }));

  // Click-driven node explorer for SVG diagrams. Each <g data-th-node="key">
  // becomes a clickable node; side-panel blocks use <template x-if="is('key')">
  // to swap content. Mirrors the tabs() API (active / is / set) for symmetry.
  // Pair with the .th-node-active CSS rule for the highlighted stroke.
  Alpine.data('interactiveNodes', (initial = null) => ({
    active: initial,
    init() {
      if (!this.active) {
        const first = this.$root.querySelector('[data-th-node]');
        if (first) this.active = first.dataset.thNode;
      }
    },
    is(k) { return this.active === k; },
    set(k) { this.active = k; },
  }));

  // Anchor-jump highlighter. Briefly outlines the target card when any
  // descendant <a data-th-jump href="#target"> is clicked. Use to draw the
  // eye after a jump from a risk map, ToC, or summary chip.
  Alpine.data('jumpFlash', () => ({
    init() {
      this.$root.querySelectorAll('a[data-th-jump]').forEach((a) => {
        a.addEventListener('click', () => {
          const target = document.querySelector(a.getAttribute('href'));
          if (!target) return;
          target.classList.add('th-flash');
          setTimeout(() => target.classList.remove('th-flash'), 1400);
        });
      });
    },
  }));

  // Magic helper: $clipboard('text') from any x-data scope.
  Alpine.magic('clipboard', () => async (text) => {
    await navigator.clipboard.writeText(text);
  });
});

