import { Box, BetterTmuxConfig, WindowConfig, Bind } from 'better-tmux'

// Everforest palette
const colors = {
  bg0: '#272E33',
  bg1: '#2E383C',
  bg2: '#374145',
  fg: '#D3C6AA',
  grey0: '#859289',
  grey1: '#9DA9A0',
  grey2: '#D3C6AA',
}

const Window = ({ type, number, name }: WindowConfig) => {
  return (
    <Box padding={1} bg={'default'} fg={type === 'active' ? colors.fg : colors.grey1} bold>
      {number}: {name}
    </Box>
  )
}

const bindings = [
  {
    key: `\\\\`,
    command: 'split-window',
    options: ['-h', '-c', '"#{pane_current_path}"']
  },
  {
    key: '-',
    command: 'split-window',
    options: ['-v', '-c', '"#{pane_current_path}"']
  },
  {
    key: 'h',
    command: 'select-pane',
    options: ['-L']
  },
  {
    key: 'l',
    command: 'select-pane',
    options: ['-R']
  },
  {
    key: 'k',
    command: 'select-pane',
    options: ['-U']
  },
  {
    key: 'j',
    command: 'select-pane',
    options: ['-D']
  },
  {
    key: 'H',
    command: 'resize-pane',
    options: ['-L', '15']
  },
  {
    key: 'L',
    command: 'resize-pane',
    options: ['-R', '15']
  },
] satisfies Bind[]

export default {
  bindings,
  options: {
    defaultTerminal: "xterm-256color",
    terminalOverrides: ",xterm-256color:Tc",
    escapeTime: 0,
    baseIndex: 1,
    paneBaseIndex: 1,
    renumberWindows: "on",
    statusKeys: "vi",
    historyLimit: 10000,
    prefix: "C-d",
    setTitles: "on",
    setTitlesString: " ",
    modeKeys: "vi",
    mouse: "on",
  },
  status: {
    bg: colors.bg0,
    fg: colors.fg,
    position: "bottom"
  },
  window: (window) => <Window {...window} />
} satisfies BetterTmuxConfig
