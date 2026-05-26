// aicodemetrics opencode plugin — do not edit (managed by aicodemetricsd)
import { spawn } from "node:child_process";

const BINARY_PATH = "/usr/local/bin/aicodemetricsd";

function sendToHook(payload) {
  try {
    const child = spawn(
      BINARY_PATH,
      ["hook", "opencode", "--hook-input", "stdin"],
      {
        stdio: ["pipe", "ignore", "ignore"],
      },
    );
    child.on("error", () => {});
    child.stdin.on("error", () => {});
    child.stdin.end(payload);
  } catch {
    // Ignore errors so telemetry never disrupts the user's session.
  }
}

async function getAttribution(client, sessionID) {
  if (!sessionID) return { version: "", model: "" };
  try {
    const [sessionResp, messagesResp] = await Promise.all([
      client.session.get({ path: { id: sessionID } }),
      client.session.messages({ path: { id: sessionID } }),
    ]);
    const messages = messagesResp?.data ?? [];
    const lastInfo = messages[messages.length - 1]?.info;
    return {
      version: sessionResp?.data?.version ?? "",
      model: lastInfo?.modelID ?? "",
    };
  } catch {
    return { version: "", model: "" };
  }
}

export const AiCodeMetricsPlugin = async ({ client, directory }) => ({
  event: async ({ event }) => {
    if (event.type !== "session.idle" && event.type !== "session.compacted")
      return;
    const sessionID = event.properties?.sessionID;
    if (!sessionID) return;

    try {
      const sessionResp = await client.session.get({ path: { id: sessionID } });
      const session = sessionResp?.data;
      if (!session || session.parentID) return;

      const messagesResp = await client.session.messages({
        path: { id: sessionID },
      });
      const messages = messagesResp?.data ?? [];

      sendToHook(
        JSON.stringify({
          event_type: "session",
          session,
          messages,
          directory,
        }),
      );
    } catch {
      // Ignore errors so telemetry never disrupts the user's session.
    }
  },

  "tool.execute.before": async (input, output) => {
    const sessionID = input?.sessionID;
    const attr = await getAttribution(client, sessionID);
    sendToHook(
      JSON.stringify({
        event_type: "tool",
        phase: "pre",
        tool: input?.tool,
        session_id: sessionID,
        tool_version: attr.version,
        model: attr.model,
        args: output?.args,
        directory,
      }),
    );
  },

  "tool.execute.after": async (input) => {
    const sessionID = input?.sessionID;
    const attr = await getAttribution(client, sessionID);
    sendToHook(
      JSON.stringify({
        event_type: "tool",
        phase: "post",
        tool: input?.tool,
        session_id: sessionID,
        tool_version: attr.version,
        model: attr.model,
        args: input?.args,
        directory,
      }),
    );
  },
});
