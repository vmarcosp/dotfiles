---
name: review
description: Code review skill that analyzes PRs and generates an issues list for triage. Supports three review levels (low, mid, high). Triggers when the user wants to review a PR, says "/review", or asks for code review. Usage - /review [low|mid|high] <pr-url-or-number>
---

# Code Review

Skill de code review que pensa como o usuário. Programação funcional, type-safety, simplicidade, e comentários em pt-BR direto ao ponto.

## Invocation

```
/review [low|mid|high] <pr-url-or-number>
```

- Se o nível não for especificado, usar `mid` como padrão.
- Se a URL/número não for passada, perguntar.
- O argumento pode ser uma URL completa do GitHub ou `owner/repo#number`.

## Review Levels

### low — Bug fixes e PRs pequenos
- Foco em bugs, erros de lógica, typos, regressões óbvias.
- Não comentar sobre estilo, organização ou naming.
- Máximo ~5 issues. Ser rápido e pragmático.

### mid — Qualidade + velocidade (padrão)
- Tudo do `low` +
- Type-safety: uso de `any`, castings ruins, `interface` onde `type` bastaria.
- Simplicidade: código imperativo que poderia ser funcional, mutabilidade desnecessária.
- Colocation: tipos separados sem necessidade, imports desnecessários.
- Testes: cobertura faltando, testes que poderiam ser mais eficientes.
- Não rushar, mas não ser perfeccionista. Bom senso.

### high — Qualidade máxima
- Tudo do `mid` +
- Arquitetura: acoplamento, responsabilidade, organização de módulos.
- Performance: loops desnecessários, Promise.all vs allSettled, alocações dentro de loops.
- Segurança: path traversal, input validation em boundaries.
- Documentação: README vs ADR vs JSDoc, docs que envelhecem mal.
- Exhaustive checks com `never` em switches.
- Sugestões de bibliotecas leves se resolverem o problema melhor.
- Cobertura de edge cases nos testes.

## Contexto de execução

A skill é SEMPRE chamada dentro do repositório do PR, na branch que será revisada. Ou seja:
- O código está disponível localmente. Ler arquivos diretamente com Read ao invés de depender só do diff.
- Não é necessário clonar, fazer checkout, ou mudar de branch.
- Isso permite análise mais profunda: entender o contexto ao redor do código alterado, verificar se tipos existem, se convenções do projeto estão sendo seguidas, etc.

## Workflow

### Step 1 — Fetch PR metadata and identify changes

Usar `gh` CLI para buscar metadata e lista de arquivos alterados:

```bash
# PR metadata (título, descrição, base branch)
gh pr view --json title,body,baseRefName,number,url

# Lista de arquivos alterados com status (added/modified/removed)
gh pr diff --name-only

# Diff completo para mapear linhas alteradas
gh pr diff
```

Extrair: título, descrição, arquivos alterados, diff completo.

### Step 2 — Read and analyze changed files

Para cada arquivo alterado:
1. **Ler o arquivo completo localmente** com Read — não só o diff. Isso dá contexto do código ao redor.
2. **Ler o diff do arquivo** para focar nas linhas que mudaram.
3. **Analisar aplicando o checklist** do nível selecionado.

Ler o arquivo local permite:
- Verificar se tipos/imports referenciados existem de fato
- Entender o padrão do projeto (convenções, estilo existente)
- Checar se há código duplicado que poderia ser reutilizado (ou vice-versa)
- Avaliar o contexto completo de funções alteradas

#### Checklist universal (todos os níveis)

- [ ] Bugs, erros de lógica, off-by-one, null/undefined não tratado
- [ ] Regressões óbvias

#### Checklist mid+

- [ ] `interface` usada onde `type` bastaria. Preferir `type` SEMPRE, exceto para interface augmentation
- [ ] `any` ou castings ruins (`as unknown as X`, etc.)
- [ ] Código imperativo que seria mais limpo como funcional (map/filter/reduce vs for loops)
- [ ] Mutabilidade desnecessária (let onde const basta, push em array que poderia ser map)
- [ ] Tipos em arquivo separado sem necessidade. Colocation é melhor
- [ ] Testes faltando para código novo
- [ ] Testes que chamam a mesma função N vezes quando uma chamada + N expects bastaria

#### Checklist high

- [ ] Switch sem exhaustive check (`default: { const _exhaustive: never = x; }`)
- [ ] Tipagem ampla demais (string onde union type bastaria)
- [ ] Promise.all onde Promise.allSettled faria mais sentido
- [ ] Path traversal ou input não validado em system boundaries
- [ ] Instanciação de objetos dentro de loops (TextDecoder, RegExp, etc.)
- [ ] README com informação que envelhece rápido. Sugerir ADR ou JSDoc
- [ ] Documentação de decisão técnica que deveria ser ADR
- [ ] Acoplamento desnecessário, às vezes duplicar é melhor que acoplar
- [ ] Biblioteca leve que resolveria o problema sem reinventar

### Step 3 — Generate issues list

Gerar um arquivo `.md` com as issues encontradas, formatado para triagem:

```markdown
# Code Review — PR #{number}: {title}

**Nível**: {low|mid|high}
**Arquivos analisados**: {count}

## Issues

### 1. [arquivo:linha] — Título curto da issue
**Severidade**: critica | importante | sugestão | pergunta
**Comentário**:
> {comentário no estilo do usuário, em pt-BR}

**Sugestão de código** (se aplicável):
\`\`\`typescript
// código sugerido
\`\`\`

---

### 2. [arquivo:linha] — ...

---

## Resumo
- {N} issues encontradas
- {N} criticas, {N} importantes, {N} sugestões, {N} perguntas
```

Salvar o arquivo como `review-pr-{number}.md` no diretório atual.

Ao final, exibir um resumo para o usuário e perguntar se quer editar/remover alguma issue antes de submeter com `/review-submit`.

## Estilo de Escrita dos Comentários

Seguir EXATAMENTE o estilo definido na skill `my-voice` (`.claude/skills/my-voice/SKILL.md`).
Ler e aplicar todas as regras de tom, fraseamento, e linguagem definidas lá.

## Princípios do Reviewer

Estes são os valores técnicos que guiam o review:

1. **FP > OO/Imperativo**: Preferir map/filter/reduce, imutabilidade, composição de funções. Evitar classes, loops imperativos, mutação.
2. **Type-safety**: `type` > `interface`. Exhaustive checks. Evitar `any`. Tipagem precisa (union types > string).
3. **Simplicidade**: Código deve ser fácil de ler. Quebrar funções grandes. Colocation de tipos.
4. **Duplicar > Acoplar**: Quando fizer sentido, duplicar é melhor que criar abstração prematura.
5. **Bibliotecas leves**: Se uma lib leve resolve o problema sem pesar o bundle, adotar.
6. **Convenções do projeto**: Seguir o que o projeto já faz. Não impor estilo externo.
7. **Testes eficientes**: Uma chamada + N expects > N chamadas redundantes.
8. **Documentação que dura**: JSDoc > README para APIs. ADR para decisões. Evitar docs que envelhecem.
9. **Segurança em boundaries**: Validar em system boundaries, não em código interno.
