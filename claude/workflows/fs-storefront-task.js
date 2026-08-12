export const meta = {
  name: 'fs-storefront-task',
  description: 'Spec, implement, and locally verify one roadmap task, then open a single PR',
  phases: [
    { title: 'Spec', detail: 'fs-specifier writes and commits the spec' },
    { title: 'Implement', detail: 'fs-implementer writes code + tests locally' },
    { title: 'Verify', detail: 'fs-reviewer + fs-smoke-tester run in parallel; findings loop back' },
    { title: 'Deliver', detail: 'push branch, open one non-draft PR' },
  ],
};

// args: { taskId, taskTitle, goal, scope, rootBranch, remote, specPath, carryOverPath,
//         normativeReferences, maxVerifyRounds }

const RESULT_SCHEMA = {
  type: 'object',
  properties: {
    status: { enum: ['ok', 'blocked'] },
    reason: { type: 'string' },
  },
  required: ['status'],
};

const FINDING_SCHEMA = {
  type: 'object',
  properties: {
    summary: { type: 'string' },
    file: { type: 'string' },
    line: { type: 'integer' },
    repro: { type: 'string' },
  },
  required: ['summary'],
};

const REVIEW_SCHEMA = {
  type: 'object',
  properties: {
    verdict: { enum: ['pass', 'changes_requested', 'blocked'] },
    findings: { type: 'array', items: FINDING_SCHEMA },
    followUps: { type: 'array', items: { type: 'string' } },
  },
  required: ['verdict'],
};

const DELIVER_SCHEMA = {
  type: 'object',
  properties: {
    status: { enum: ['ok', 'blocked'] },
    prUrl: { type: 'string' },
    reason: { type: 'string' },
  },
  required: ['status'],
};

function collectFollowUps(...results) {
  return results.flatMap((r) => r?.followUps || []);
}

function formatFinding(f) {
  if (typeof f === 'string') return f;
  const loc = f.file ? `${f.file}${f.line ? `:${f.line}` : ''} — ` : '';
  const repro = f.repro ? ` (repro: ${f.repro})` : '';
  return `${loc}${f.summary}${repro}`;
}

// Defensive: some callers stringify the packet before passing it as `args` to the
// Workflow tool, even though the tool contract expects a real object.
const task = typeof args === 'string' ? JSON.parse(args) : args;
const maxRounds = task.maxVerifyRounds || 3;

function packet(extra) {
  return `Task ${task.taskId} — ${task.taskTitle}\nGoal: ${task.goal}\nScope: ${task.scope}\nRoot branch: ${task.rootBranch} (remote: ${task.remote})\nSpec path: ${task.specPath}\nCarry-over: ${task.carryOverPath || 'none'}\nNormative references: ${JSON.stringify(task.normativeReferences || [])}\n${extra || ''}`;
}

phase('Spec');
const specResult = await agent(`${packet()}\n\nAction: WRITE_SPEC.`, {
  label: 'fs-specifier',
  agentType: 'fs-specifier',
  schema: RESULT_SCHEMA,
});

if (!specResult || specResult.status === 'blocked') {
  return { status: 'blocked', stage: 'spec', reason: specResult?.reason || 'specifier failed to return' };
}

phase('Implement');
let implResult = await agent(`${packet()}\n\nAction: IMPLEMENT.`, {
  label: 'fs-implementer',
  agentType: 'fs-implementer',
  schema: RESULT_SCHEMA,
});

if (!implResult || implResult.status === 'blocked') {
  return { status: 'blocked', stage: 'implement', reason: implResult?.reason || 'implementer failed to return' };
}

phase('Verify');
let round = 0;
let allFindings = [];
const followUps = [];
const priorFindings = [];
while (round < maxRounds) {
  round++;
  const delta = priorFindings.length
    ? `Re-verification round ${round}. Findings below were already reported and fixed — do not re-report them or a reworded variant unless the fix is demonstrably wrong:\n${priorFindings.map((f) => `- ${f}`).join('\n')}\nFocus this round on (1) confirming each fixed finding is actually resolved and (2) regressions introduced by the fix commits since the last round. Don't re-review or re-test unchanged areas already covered in round 1.`
    : '';
  const [review, smoke] = await parallel([
    () =>
      agent(`${packet(delta)}\n\nAction: REVIEW.`, {
        label: `fs-reviewer-r${round}`,
        agentType: 'fs-reviewer',
        phase: 'Verify',
        schema: REVIEW_SCHEMA,
      }),
    () =>
      agent(`${packet(delta)}\n\nAction: TEST.`, {
        label: `fs-smoke-r${round}`,
        agentType: 'fs-smoke-tester',
        phase: 'Verify',
        schema: REVIEW_SCHEMA,
      }),
  ]);

  if (review?.verdict === 'blocked' || smoke?.verdict === 'blocked') {
    return {
      status: 'blocked',
      stage: 'verify',
      reason: [review, smoke]
        .filter((v) => v?.verdict === 'blocked')
        .flatMap((v) => v.findings || [])
        .map(formatFinding)
        .join('; '),
    };
  }

  followUps.push(...collectFollowUps(review, smoke));

  const findings = [...(review?.findings || []), ...(smoke?.findings || [])];
  if (findings.length === 0) {
    allFindings = [];
    break;
  }

  allFindings = findings;
  const formatted = findings.map(formatFinding);
  log(`Verify round ${round}: ${findings.length} finding(s), routing to implementer`);

  implResult = await agent(
    `${packet(`Findings to fix:\n${formatted.map((f) => `- ${f}`).join('\n')}`)}\n\nAction: FIX_FINDINGS.`,
    { label: `fs-implementer-fix-r${round}`, agentType: 'fs-implementer', phase: 'Verify', schema: RESULT_SCHEMA },
  );
  priorFindings.push(...formatted);

  if (!implResult || implResult.status === 'blocked') {
    return { status: 'blocked', stage: 'verify-fix', reason: implResult?.reason || 'fix attempt failed' };
  }
}

if (allFindings.length > 0) {
  return {
    status: 'blocked',
    stage: 'verify',
    reason: `Max verify rounds (${maxRounds}) reached with open findings: ${allFindings.map(formatFinding).join('; ')}`,
  };
}

phase('Deliver');
const uniqueFollowUps = [...new Set(followUps)];
const deliverExtra = uniqueFollowUps.length
  ? `\n\nFollow-ups to post as a PR comment (mention @vmarcosp):\n${uniqueFollowUps.map((f) => `- ${f}`).join('\n')}`
  : '';
// Deliver is mechanical (push, open PR, write body) — no need for the implementer's default model.
const deliver = await agent(`${packet(deliverExtra)}\n\nAction: DELIVER.`, {
  label: 'fs-deliver',
  agentType: 'fs-implementer',
  model: 'sonnet',
  schema: DELIVER_SCHEMA,
});

if (!deliver || deliver.status === 'blocked') {
  return { status: 'blocked', stage: 'deliver', reason: deliver?.reason || 'delivery failed' };
}

return { status: 'delivered', prUrl: deliver.prUrl, taskId: task.taskId, followUps: uniqueFollowUps };
