# Components

Start from these snippets; add classes when a mockup needs them, using the same tokens. Every page uses
the same tokens and type, so two runs produce sibling pages. All JS is vanilla, inline, in one `<script>` at
the end of `<body>`. No storage, no runtime capabilities, no library for these patterns.

## 1. Tokens, type and base

Fonts and viewport, in `<head>`:

```html
<meta name="claude:viewport-fit-sides" content="cover">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&family=Newsreader:opsz,wght@6..72,500&family=JetBrains+Mono:wght@400&display=swap" rel="stylesheet">
```

Palette roles. A pastel pairs a fill (`--x`) with an ink (`--x-ink`) for text on it.

| Token | Role in the architecture | Role in states and mockups |
|---|---|---|
| `--blue` | main process | active, generating, running |
| `--lilac` | renderer and preload | selected, focus in a mockup |
| `--mint` | domain (pure) | ready, done, ok |
| `--peach` | engine, agent, OpenCode | partial, incomplete, warning |
| `--rose` | failure paths only | failed, error |
| `--wash` + dashed border | gateway, external service, shared | waiting, idle, disabled |

```css
:root{
  --ink:#1b1b1f; --paper:#fbfbf8; --wash:#f2f2ee; --line:#e4e4df; --mute:#9a9a95; --soft:#66665f;
  --blue:#dce8f6; --blue-ink:#2c5a8c; --lilac:#e7e0f4; --lilac-ink:#5a4790;
  --mint:#d9efe3; --mint-ink:#2d6a4d; --peach:#fbe4d3; --peach-ink:#8c4e26;
  --rose:#f6dcdc; --rose-ink:#8e3535;
  --serif:"Newsreader",Georgia,serif; --sans:"Inter",system-ui,sans-serif;
  --mono:"JetBrains Mono",ui-monospace,monospace;
  color-scheme:light;
}
@media (prefers-color-scheme:dark){:root:not([data-theme="light"]){
  --ink:#e9e9e6; --paper:#141416; --wash:#1d1d20; --line:#2c2c30; --mute:#76767a; --soft:#a4a4a8;
  --blue:#1e2a38; --blue-ink:#9fc2ea; --lilac:#27223a; --lilac-ink:#c3b5ec;
  --mint:#1c2e25; --mint-ink:#9fd8b8; --peach:#33251b; --peach-ink:#f0b994;
  --rose:#361f20; --rose-ink:#f0a8a8; color-scheme:dark;
}}
:root[data-theme="dark"]{ /* the same values as the block above */ }

*{box-sizing:border-box}
body{margin:0;background:var(--paper);color:var(--ink);font:16px/1.65 var(--sans)}
main{max-width:780px;margin:0 auto;padding-top:56px;padding-bottom:96px;
  padding-left:max(16px,env(safe-area-inset-left,0px));padding-right:max(16px,env(safe-area-inset-right,0px))}
.wide{width:min(1040px,calc(100vw - 32px));margin-left:50%;transform:translateX(-50%)}
h1,h2{font-family:var(--serif);font-weight:500;letter-spacing:-.01em;line-height:1.2}
h1{font-size:2.4rem;margin:0 0 8px} h2{font-size:1.6rem;margin:88px 0 16px}
h3{font-size:1rem;font-weight:600;margin:32px 0 8px}
.lede{font-size:1.15rem;color:var(--soft)} .meta{font-size:.85rem;color:var(--mute)}
code{font:.86em var(--mono);background:var(--wash);padding:.1em .35em;border-radius:4px}
a{color:inherit;text-decoration-color:var(--mute);text-underline-offset:3px}
.why{border-left:2px solid var(--mute);padding:2px 0 2px 14px;color:var(--soft)}
.tag{display:inline-block;font-size:.72rem;font-weight:500;padding:1px 8px;border-radius:99px;
  background:var(--wash);color:var(--soft)}
.tag[data-tone=ok]{background:var(--mint);color:var(--mint-ink)}
.tag[data-tone=active]{background:var(--blue);color:var(--blue-ink)}
.tag[data-tone=partial]{background:var(--peach);color:var(--peach-ink)}
.tag[data-tone=fail]{background:var(--rose);color:var(--rose-ink)}
.tw{overflow-x:auto} table{border-collapse:collapse;width:100%;font-size:.92rem}
th{font-size:.75rem;font-weight:500;color:var(--mute);text-align:left;padding:6px 10px}
td{padding:8px 10px;border-top:1px solid var(--line);vertical-align:top}
button{font:inherit;color:inherit;cursor:pointer}
:focus-visible{outline:2px solid var(--ink);outline-offset:2px}
.dim{opacity:.32}
.node,.edges li,.steps li,.actors span,.sm-states button,.arch-wires path{transition:opacity .15s,background-color .15s}
@media (prefers-reduced-motion:reduce){*{transition:none!important;animation:none!important}}
```

## 2. Interactive architecture

The edge list is the data and stays visible at rest. JS draws the wires from it and filters it on a
click. Each `<template data-for>` holds the panel for one component.

```html
<figure class="arch wide" id="arch">
  <div class="arch-stage">
    <svg class="arch-wires" aria-hidden="true"></svg>
    <div class="band" data-layer="main"><span class="band-name">Main process</span>
      <button class="node is-new" data-id="loop">GenerationLoop<small>roda a geração</small></button>
      <button class="node" data-id="store">FileStore<small>grava no disco</small></button>
    </div>
    <div class="band" data-layer="renderer"><span class="band-name">Renderer</span>
      <button class="node" data-id="side">FilesSidebar<small>lista os arquivos</small></button>
    </div>
  </div>
  <div class="arch-panel" aria-live="polite">
    <div class="arch-detail"><p class="meta">Toque um componente: o que muda nele e quais decisões o tocam.</p></div>
    <ul class="edges">
      <li data-from="loop" data-to="store"><b>GenerationLoop</b> → <b>FileStore</b>: grava cada arquivo</li>
      <li data-from="loop" data-to="side"><b>GenerationLoop</b> → <b>FilesSidebar</b>: evento de estado</li>
    </ul>
  </div>
  <template data-for="loop"><h3><code>GenerationLoop</code> <span class="tag">novo</span></h3>
    <ul><li>O que muda, um a três bullets.</li></ul><p class="meta">Decisões: 2, 5</p></template>
</figure>
```

```css
.arch-stage{position:relative;display:grid;gap:18px}
.arch-wires{position:absolute;inset:0;width:100%;height:100%;pointer-events:none;overflow:visible}
.arch-wires path{fill:none;stroke:var(--mute);stroke-width:1.2;opacity:.5}
.arch-wires path.on{stroke:var(--ink);stroke-width:2;opacity:1}
.band{position:relative;z-index:1;display:flex;flex-wrap:wrap;gap:10px;padding:30px 14px 14px;
  border-radius:16px;background:var(--band)}
.band-name{position:absolute;top:8px;left:14px;font-size:.72rem;font-weight:600;color:var(--band-ink)}
[data-layer=main]{--band:var(--blue);--band-ink:var(--blue-ink)}
[data-layer=renderer],[data-layer=preload]{--band:var(--lilac);--band-ink:var(--lilac-ink)}
[data-layer=domain]{--band:var(--mint);--band-ink:var(--mint-ink)}
[data-layer=engine]{--band:var(--peach);--band-ink:var(--peach-ink)}
[data-layer=external]{--band:transparent;--band-ink:var(--soft);border:1px dashed var(--mute)}
.node{position:relative;text-align:left;background:var(--paper);border:1px solid var(--line);
  border-radius:10px;padding:8px 12px;font-weight:500;font-size:.9rem}
.node small{display:block;font-weight:400;color:var(--soft);font-size:.78rem}
.node.is-new{border:1.5px solid var(--ink)}
.node.is-new::after{content:"novo";position:absolute;top:-9px;right:8px;font-size:.65rem;
  padding:0 6px;border-radius:99px;background:var(--ink);color:var(--paper)}
.node.sel{outline:2px solid var(--ink);outline-offset:2px}
.arch-panel{margin-top:20px} .edges{padding-left:18px;font-size:.9rem;color:var(--soft)}
.arch.has-sel .edges li:not(.on){display:none}
```

```js
(function(){
  const fig=document.getElementById('arch'); if(!fig) return;
  const stage=fig.querySelector('.arch-stage'), svg=fig.querySelector('.arch-wires');
  const detail=fig.querySelector('.arch-detail'), hint=detail.innerHTML;
  const edges=[...fig.querySelectorAll('.edges li')], nodes=[...fig.querySelectorAll('.node')];
  const node=id=>fig.querySelector(`.node[data-id="${id}"]`); let sel=null;
  function mid(el,r){const b=el.getBoundingClientRect();return[b.left+b.width/2-r.left,b.top+b.height/2-r.top]}
  function draw(){const r=stage.getBoundingClientRect();
    svg.innerHTML=edges.map(e=>{const[a,b]=[mid(node(e.dataset.from),r),mid(node(e.dataset.to),r)],m=(a[1]+b[1])/2;
      return`<path d="M${a} C${a[0]},${m} ${b[0]},${m} ${b}"/>`}).join('');paint()}
  function paint(){const paths=[...svg.children];fig.classList.toggle('has-sel',!!sel);
    const near=new Set([sel]);edges.forEach((e,i)=>{const on=!!sel&&(e.dataset.from===sel||e.dataset.to===sel);
      e.classList.toggle('on',on);paths[i]&&paths[i].classList.toggle('on',on);
      if(on){near.add(e.dataset.from);near.add(e.dataset.to)}});
    nodes.forEach(n=>{n.classList.toggle('sel',n.dataset.id===sel);n.classList.toggle('dim',!!sel&&!near.has(n.dataset.id));
      n.setAttribute('aria-pressed',n.dataset.id===sel)});
    const t=sel&&fig.querySelector(`template[data-for="${sel}"]`);detail.innerHTML=t?t.innerHTML:hint}
  nodes.forEach(n=>n.addEventListener('click',()=>{sel=sel===n.dataset.id?null:n.dataset.id;paint()}));
  document.addEventListener('keydown',e=>{if(e.key==='Escape'&&sel){sel=null;paint()}});
  new ResizeObserver(draw).observe(stage);document.fonts.ready.then(draw);
})();
```

## 3. Step-through for a flow

Every step stays visible at rest; the active one is marked. Elements with `data-k` (actors, or parts
of a small diagram inside the same root) light up when the active step lists them in `data-hl`.

```html
<div class="steps" data-steps>
  <div class="actors"><span data-k="ui">Renderer</span><span data-k="loop">GenerationLoop</span><span data-k="fs">Disco</span></div>
  <ol>
    <li data-hl="ui loop"><b>Pedido.</b> O renderer pede a geração.</li>
    <li data-hl="loop fs"><b>Gravação.</b> O loop grava cada arquivo.</li>
  </ol>
  <div class="steps-nav"><button data-prev>← Voltar</button><span data-count></span><button data-next>Próximo →</button></div>
</div>
```

```css
.actors{display:flex;flex-wrap:wrap;gap:8px;margin-bottom:12px}
.actors span{font-size:.82rem;padding:4px 10px;border-radius:99px;border:1px solid var(--line)}
.actors span.on{background:var(--blue);color:var(--blue-ink);border-color:transparent}
.steps ol{padding-left:22px} .steps li{padding:6px 10px;border-radius:8px;cursor:pointer;color:var(--soft)}
.steps li.on{background:var(--wash);color:var(--ink)}
.steps-nav{display:flex;align-items:center;gap:12px;font-size:.85rem;color:var(--mute)}
.steps-nav button{background:none;border:1px solid var(--line);border-radius:99px;padding:4px 12px}
.steps-nav button:disabled{opacity:.35;cursor:default}
```

```js
document.querySelectorAll('[data-steps]').forEach(root=>{
  const items=[...root.querySelectorAll('ol>li')],prev=root.querySelector('[data-prev]'),next=root.querySelector('[data-next]');let i=0;
  function show(n){i=Math.max(0,Math.min(items.length-1,n));const keys=(items[i].dataset.hl||'').split(' ');
    items.forEach((li,k)=>{li.classList.toggle('on',k===i);li.setAttribute('aria-current',k===i?'step':'false')});
    root.querySelectorAll('[data-k]').forEach(el=>el.classList.toggle('on',keys.includes(el.dataset.k)));
    root.querySelector('[data-count]').textContent=`${i+1} / ${items.length}`;prev.disabled=i===0;next.disabled=i===items.length-1}
  prev.addEventListener('click',()=>show(i-1));next.addEventListener('click',()=>show(i+1));
  items.forEach((li,k)=>li.addEventListener('click',()=>show(k)));show(0);
});
```

## 4. State-machine explorer

The transitions table is the data and is complete at rest. A click on a state keeps its outgoing rows
and marks the states it can reach.

```html
<div class="sm" data-sm>
  <div class="sm-states">
    <button data-s="waiting">waiting</button><button data-s="generating" data-tone="active">generating</button>
    <button data-s="ready" data-tone="ok">ready</button><button data-s="failed" data-tone="fail">failed</button>
  </div>
  <div class="tw"><table><thead><tr><th>De</th><th>Para</th><th>Gatilho</th></tr></thead><tbody>
    <tr data-from="waiting" data-to="generating"><td><code>waiting</code></td><td><code>generating</code></td><td>o loop pega o arquivo</td></tr>
  </tbody></table></div>
</div>
```

```css
.sm-states{display:flex;flex-wrap:wrap;gap:8px;margin-bottom:12px}
.sm-states button{font:.85rem var(--mono);padding:6px 12px;border-radius:99px;border:1px solid var(--line);background:var(--wash)}
.sm-states [data-tone=ok]{background:var(--mint);color:var(--mint-ink)}
.sm-states [data-tone=active]{background:var(--blue);color:var(--blue-ink)}
.sm-states [data-tone=partial]{background:var(--peach);color:var(--peach-ink)}
.sm-states [data-tone=fail]{background:var(--rose);color:var(--rose-ink)}
.sm-states button.sel{outline:2px solid var(--ink);outline-offset:2px}
.sm-states button.to{border:1.5px dashed var(--ink)}
```

```js
document.querySelectorAll('[data-sm]').forEach(root=>{
  const btns=[...root.querySelectorAll('[data-s]')],rows=[...root.querySelectorAll('tr[data-from]')];let sel=null;
  btns.forEach(b=>b.addEventListener('click',()=>{sel=sel===b.dataset.s?null:b.dataset.s;
    const to=new Set(rows.filter(r=>r.dataset.from===sel).map(r=>r.dataset.to));
    btns.forEach(x=>{x.classList.toggle('sel',x.dataset.s===sel);x.classList.toggle('to',to.has(x.dataset.s));
      x.setAttribute('aria-pressed',x.dataset.s===sel)});
    rows.forEach(r=>r.hidden=!!sel&&r.dataset.from!==sel)}));
});
```

## 5. UI mockup with a state toggle

The mockup is illustrative: the caption says so and names the source. The first panel shows at rest;
the section's state table lists every state, so no fact lives only behind a tab.

```html
<figure class="mock wide" data-mock>
  <figcaption class="meta"><span class="tag">ilustrativo</span> Sidebar de arquivos · fonte: handoff</figcaption>
  <div class="seg" role="tablist" aria-label="Estado">
    <button role="tab" data-p="ready" aria-selected="true">ready</button><button role="tab" data-p="failed">failed</button>
  </div>
  <div class="ui">
    <div data-panel="ready"><div class="ui-row"><i class="dot" data-tone="ok"></i>home.json<span>Pronto</span></div></div>
    <div data-panel="failed"><div class="ui-row"><i class="dot" data-tone="fail"></i>home.json<span>Falhou</span>
      <button class="ui-btn">Tentar de novo</button></div></div>
  </div>
</figure>
```

```css
.seg{display:inline-flex;gap:2px;padding:3px;border-radius:99px;background:var(--wash);margin:10px 0}
.seg button{border:0;background:none;padding:4px 12px;border-radius:99px;font-size:.82rem;color:var(--soft)}
.seg button[aria-selected=true]{background:var(--paper);color:var(--ink)}
.ui{border:1px solid var(--line);border-radius:12px;padding:12px;background:var(--paper);font-size:.88rem;max-width:420px}
.ui-row{display:flex;align-items:center;gap:10px;padding:8px;border-radius:8px}
.ui-row span{margin-left:auto;color:var(--mute);font-size:.8rem}
.ui-btn{border:1px solid var(--line);background:var(--wash);border-radius:6px;padding:3px 10px;font-size:.8rem}
.dot{width:8px;height:8px;border-radius:50%;background:var(--mute);flex:none}
.dot[data-tone=ok]{background:var(--mint-ink)} .dot[data-tone=active]{background:var(--blue-ink)}
.dot[data-tone=partial]{background:var(--peach-ink)} .dot[data-tone=fail]{background:var(--rose-ink)}
```

```js
document.querySelectorAll('[data-mock]').forEach(root=>{
  const tabs=[...root.querySelectorAll('[data-p]')],panels=[...root.querySelectorAll('[data-panel]')];
  function show(p){tabs.forEach(t=>t.setAttribute('aria-selected',t.dataset.p===p));panels.forEach(x=>x.hidden=x.dataset.panel!==p)}
  tabs.forEach(t=>t.addEventListener('click',()=>show(t.dataset.p)));show(tabs[0].dataset.p);
});
```

## 6. Decisions with reasons and an origin filter

Number, decision and origin are visible at rest. The reason opens per row or all at once. The filter
groups origins by kind: `Marcos`, `regra`, `orquestrador`, `revisor`, `autor`.

```html
<div class="dec" data-dec>
  <div class="dec-bar"><span class="chips"></span><button data-all>Abrir todas</button></div>
  <details data-kind="regra"><summary><span class="n">1</span><span>Decisão em uma linha</span>
    <span class="o">regra (PRD L764)</span></summary><p>Razão.</p></details>
</div>
```

```css
.dec-bar{display:flex;flex-wrap:wrap;justify-content:space-between;gap:8px;margin-bottom:8px}
.chips{display:flex;flex-wrap:wrap;gap:6px}
.chips button,.dec-bar>button{border:1px solid var(--line);background:none;border-radius:99px;padding:2px 10px;font-size:.8rem}
.chips button[aria-pressed=true]{background:var(--ink);color:var(--paper);border-color:var(--ink)}
.dec details{border-top:1px solid var(--line)} .dec details p{margin:0 0 12px 36px;color:var(--soft)}
.dec summary{display:grid;grid-template-columns:28px 1fr auto;gap:8px;padding:10px 0;cursor:pointer;list-style:none}
.dec .n{color:var(--mute)} .dec .o{font-size:.75rem;color:var(--soft)}
@media (max-width:560px){.dec summary{grid-template-columns:28px 1fr}.dec .o{grid-column:2}}
```

```js
document.querySelectorAll('[data-dec]').forEach(root=>{
  const rows=[...root.querySelectorAll('details')],chips=root.querySelector('.chips');
  const kinds=['todas',...new Set(rows.map(r=>r.dataset.kind))];
  chips.innerHTML=kinds.map((k,i)=>`<button data-k="${k}" aria-pressed="${i===0}">${k}</button>`).join('');
  chips.addEventListener('click',e=>{const k=e.target.dataset.k;if(!k)return;
    chips.querySelectorAll('button').forEach(b=>b.setAttribute('aria-pressed',b.dataset.k===k));
    rows.forEach(r=>r.hidden=k!=='todas'&&r.dataset.kind!==k)});
  const all=root.querySelector('[data-all]');all.addEventListener('click',()=>{const open=!rows.every(r=>r.open);
    rows.forEach(r=>r.open=open);all.textContent=open?'Fechar todas':'Abrir todas'});
});
```
