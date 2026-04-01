---
name: pr-respond
description: Responde comentários de review e endereça feedback em PRs. Lê comments pendentes, categoriza, ajuda a escrever respostas na voz do usuário, faz mudanças de código/docs quando necessário, e posta via gh CLI. Funciona com PRs de código e de documentos (RFCs, ADRs). Usage - /pr-respond <pr-url-or-number>
user-invocable: true
---

# PR Respond

Skill para responder comentários de review e endereçar feedback em PRs do usuário. Funciona com PRs de código e de documentos (RFCs, ADRs).

## Voz

Todas as respostas DEVEM seguir o estilo definido na skill `my-voice` (`.claude/skills/my-voice/SKILL.md`).
Ler e aplicar todas as regras de tom, fraseamento e linguagem definidas lá.

## Invocation

```
/pr-respond <pr-url-or-number>
```

- Aceita URL completa do GitHub ou `owner/repo#number`.
- Se não for passado, perguntar.

## Contexto de execução

A skill é SEMPRE chamada dentro do repositório do PR, na branch do PR. Ou seja:
- O código está disponível localmente. Ler arquivos diretamente com Read.
- Não é necessário clonar, fazer checkout, ou mudar de branch.

## Workflow

### Step 1: Fetch PR context

Buscar metadata e todos os comentários pendentes:

```bash
# Metadata do PR
gh pr view <number> --json title,body,baseRefName,number,url,state,headRefName

# Comentários de review inline (com threads)
gh api repos/{owner}/{repo}/pulls/{number}/comments --paginate

# Comentários gerais do PR (conversation tab)
gh api repos/{owner}/{repo}/issues/{number}/comments --paginate

# Reviews (summaries)
gh api repos/{owner}/{repo}/pulls/{number}/reviews --paginate
```

Coletar: todos os comentários de review, threads de discussão, comments inline.

### Step 2: Categorizar comments

Para cada comentário/thread, classificar:

| Tag | Descrição | Ação esperada |
|-----|-----------|---------------|
| `[CODE]` | Pedido de mudança em código | Alterar código + responder |
| `[DOC]` | Pedido de mudança em documento (RFC/ADR/README) | Alterar doc + responder |
| `[DISCUSS]` | Ponto que precisa de resposta/discussão | Responder com reasoning |
| `[QUESTION]` | Pergunta que precisa de resposta | Responder diretamente |
| `[NIT]` | Estilo, formatação, minor | Fix rápido + "Feito" |

Ignorar:
- Comentários já respondidos pelo usuário
- Threads já resolvidas
- Comentários do próprio usuário

### Step 3: Apresentar triagem ao usuário

```
PR #{number} - {title}

Comentários pendentes:

[CODE] 1. @reviewer em arquivo.ts:42
       "Sugiro usar X ao invés de Y"
       -> Ação: mudar código

[DISCUSS] 2. @reviewer em arquivo.ts:10
          "Não entendi a motivação..."
          -> Ação: responder explicando

[NIT] 3. @reviewer em styles.css:5
      "Faltou ponto e vírgula"
      -> Ação: fix rápido

Como quer proceder? (todos / lista de números / pular)
```

Aguardar resposta do usuário.

### Step 4: Endereçar cada item selecionado

Para cada item, na ordem:

**`[CODE]` e `[DOC]`**: Mudanças em arquivos
1. Ler o arquivo completo localmente com Read
2. Entender o contexto ao redor da mudança pedida
3. Fazer a alteração
4. Draftar uma resposta breve confirmando a mudança
5. Mostrar o draft pro usuário

**`[DISCUSS]` e `[QUESTION]`**: Respostas textuais
1. Ler o contexto completo da thread
2. Se for sobre código, ler o arquivo relevante
3. Draftar a resposta na voz do usuário
4. Mostrar o draft pro usuário aprovar/editar antes de postar

**`[NIT]`**: Fixes rápidos
1. Fazer o fix
2. Resposta automática: "Feito" ou "Ajustado"

### Step 5: Postar respostas

Para cada item endereçado, responder na thread específica:

```bash
# Reply em thread de review comment inline
gh api repos/{owner}/{repo}/pulls/{number}/comments/{comment_id}/replies \
  --method POST \
  -f body="{response}"

# Reply em comment geral do PR
gh api repos/{owner}/{repo}/issues/{number}/comments \
  --method POST \
  -f body="{response}"
```

Nunca postar respostas de `[DISCUSS]` ou `[QUESTION]` sem aprovação explícita do usuário.

### Step 6: Commit e push

Se houve mudanças de código/doc:
1. Mostrar ao usuário os arquivos alterados
2. Perguntar se quer commitar e pushar agora
3. Se sim, usar o flow de commit (stage, commit com mensagem descritiva, push)

### Step 7: Resumo

```
PR #{number} atualizado:
- {N} mudanças de código/doc feitas
- {N} respostas postadas
- {N} items pulados

Link: {pr_url}
```

## Padrões de resposta para PRs

Complementam as regras gerais de `my-voice` com padrões específicos de resposta a feedback:

### Concordando com feedback
- "Faz sentido, ajustei."
- "Boa, mudei."
- "Concordo, feito."

### Concordando parcialmente
- "Entendo o ponto, mas [razão]. Ajustei [parte que faz sentido] e mantive [parte] porque [motivo]."
- "Faz sentido pra [caso X], ajustei. Pra [caso Y] eu preferi manter porque [razão]."

### Pushback (discordando respeitosamente)
- "Eu pensei nisso, mas [razão para a escolha atual]. O que acha?"
- "Nesse caso eu prefiro manter porque [razão]. Mas se insistir eu mudo."
- "Entendo a preocupação, mas [contexto que o reviewer talvez não tenha]. Faz sentido?"

### Oversight (reviewer pegou algo que escapou)
- "Boa catch, corrigido."
- "Escapou, valeu. Ajustado."
- "Boa, nem tinha visto. Feito."

### Nits
- "Feito."
- "Ajustado."

### Para RFCs e ADRs
Respostas tendem a ser mais longas e com mais reasoning:
- "Bom ponto. A motivação era [X]. Uma alternativa seria [Y], mas eu descartei porque [Z]. Faz sentido ou tu vê algo que eu não tô vendo?"
- "Concordo que [observação do reviewer]. Atualizei a seção [X] pra refletir isso."
- "Isso é uma trade-off consciente. [Explicação]. Se quiser eu documento melhor na seção de trade-offs."

## Error handling

- Se `gh` não estiver autenticado, informar o usuário.
- Se um comment thread não for encontrado (deletado/outdated), pular e reportar.
- Se houver conflito com mudanças recentes, avisar o usuário.
- Nunca postar resposta de discussão sem aprovação do usuário.
