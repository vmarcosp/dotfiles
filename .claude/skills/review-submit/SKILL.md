---
name: review-submit
description: Submits code review comments to a GitHub PR based on a previously generated review file. Reads the triage file (review-pr-{number}.md), filters approved issues, and posts comments via gh CLI. Usage - /review-submit <pr-url-or-number> [path-to-review-file]
---

# Review Submit

Skill para enviar os comentários de code review para o GitHub PR, baseado no arquivo de triagem gerado pelo `/review`.

## Invocation

```
/review-submit <pr-url-or-number> [path-to-review-file]
```

- Se o path do arquivo não for especificado, procurar `review-pr-{number}.md` no diretório atual.
- Se o arquivo não existir, informar o usuário e sugerir rodar `/review` primeiro.

## Workflow

### Step 1 — Read the review file

Ler o arquivo `review-pr-{number}.md` e parsear as issues.

Cada issue tem:
- Arquivo e linha
- Severidade
- Comentário
- Sugestão de código (opcional)

### Step 2 — Confirm with user

Mostrar um resumo das issues que serão enviadas:

```
Issues para enviar no PR #{number}:
1. [critica] arquivo.ts:42 — Título
2. [importante] outro.ts:10 — Título
3. [sugestão] mais.ts:5 — Título

Enviar todas? (s/n) ou liste os números para enviar apenas algumas (ex: 1,3)
```

Aguardar confirmação do usuário. O usuário pode:
- Confirmar todas (`s`)
- Selecionar quais enviar (ex: `1,3,5`)
- Cancelar (`n`)

### Step 3 — Submit comments

Para cada issue aprovada, postar como review comment inline no PR usando `gh api`:

```bash
gh api repos/{owner}/{repo}/pulls/{number}/reviews \
  --method POST \
  -f event="COMMENT" \
  -f body="" \
  --jq '.id'
```

Para comments inline, usar a API de pull request reviews com comments:

```bash
gh api repos/{owner}/{repo}/pulls/{number}/comments \
  --method POST \
  -f body="{comment_body}" \
  -f commit_id="{latest_commit_sha}" \
  -f path="{file_path}" \
  -f line={line_number} \
  -f side="RIGHT"
```

#### Formatação do comment body

O comentário deve ser enviado EXATAMENTE como está no arquivo de review — pt-BR, direto, no tom do usuário.

Se houver sugestão de código, usar o formato de GitHub suggestion:

````
{comentário texto}

```suggestion
{código sugerido}
```
````

Se não houver sugestão de código, enviar só o texto do comentário.

### Step 4 — Report results

Após enviar todos os comentários, mostrar:

```
Review enviado no PR #{number}:
- {N} comentários postados
- {N} falhas (se houver)

Link: {pr_url}
```

## Error Handling

- Se o `gh` não estiver autenticado, informar o usuário.
- Se um comentário falhar (ex: linha não existe no diff), reportar qual issue falhou e continuar com as demais.
- Se o arquivo de review não for encontrado, sugerir `/review` primeiro.

## Important Notes

- Nunca enviar comentários sem confirmação explícita do usuário.
- Preservar o tom e estilo exato dos comentários — não "melhorar" ou formalizar.
- Se o diff mudou desde o review (novos commits), avisar o usuário que as linhas podem ter mudado.
