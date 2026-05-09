export const NotificationPlugin = async ({ project, client, $, directory, worktree }) => {
  return {
    event: async ({ event }) => {
      if (event.type === "session.idle") {
        await $`~/bin/ai-notify done "Session completed" opencode`
      }
    },
  }
}
