# Armadilhas de uma run (aprendidas na prática)

Leia antes de aceitar o "verde" de uma fase.

- **O e2e de uma fase é auto-reportado.** O gate do Yokai roda os sensores (lint, typecheck, unit); o
  judge não roda nada. Confira no transcript do Build (`~/.claude/projects/<worktree-slug>/<session>.jsonl`;
  os ids estão no log do Yokai, linha `claude session …`) o reporter de cada spec do Verify.
- **Build velho.** Num monorepo, o script de e2e do pacote pode não recompilar (no vtex-studio, só a
  raiz recompila). Um e2e "verde" sobre build velho não prova nada.
- **Specs que pulam em silêncio** por falta de env var contam como "passed" no resumo. Leia a linha
  `N passed, M skipped`.
- **Asserção movida para uma fase futura** (ex.: a P5 tirou checagens que a P7 recolocou): anote no
  log e confira na fase que deve restaurar.
- **Não editar o BACKLOG com a run viva**: o driver reescreve. Espere o halt.
- **Commit do orquestrador no meio de uma fase**: só com `git commit -- <arquivo>`, para não levar o
  trabalho da fase junto. Dispara o NEW_COMMIT do watchdog.
- **Dependência local linkada** (symlink para um build de outro repo): `pnpm install` desfaz; um
  precheck no watchdog religa. Versão do pacote linkado pode vir `0.0.0` e quebrar o que a lê.
- **Recursos compartilhados**: porta do live session (9222), gateway local (:8009), `apps/*/out` de
  build. Dois agentes de e2e ou live no mesmo worktree se atropelam; use outro worktree e outra porta.
- **Login e budget**: rode o preflight do QA (token válido, budget do modelo) antes de disparar QA ao
  vivo; o token do CLI expira.
- **Conflito com a main** trava o CI de PR em silêncio (GitHub não roda o workflow). Veja
  `gh pr view --json mergeable` depois de cada push.
