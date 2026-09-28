import { BetterTmuxConfig } from 'better-tmux'
import { bindings, options } from './shared'
import { macTheme } from './lib/mac-theme'
import * as everforestLight from './themes/everforest-light'
import * as macos from './themes/macos'
import * as omarchy from './themes/omarchy'

const macThemes = { yugen: macos, 'everforest-light': everforestLight }
const theme = process.platform === 'darwin' ? macThemes[macTheme()] : omarchy
const Window = theme.Window

export default {
  bindings,
  options,
  status: theme.status,
  window: (window) => <Window {...window} />,
} satisfies BetterTmuxConfig
