import { BetterTmuxConfig } from 'better-tmux'
import { bindings, options } from './shared'
import * as macos from './themes/macos'
import * as omarchy from './themes/omarchy'

const theme = process.platform === 'darwin' ? macos : omarchy
const Window = theme.Window

export default {
  bindings,
  options,
  status: theme.status,
  window: (window) => <Window {...window} />,
} satisfies BetterTmuxConfig
