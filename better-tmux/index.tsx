import { Box, BetterTmuxConfig, WindowConfig, Bind } from 'better-tmux'

// Everforest Light Soft palette
const colors = {
  bg0: '#F3EAD3',
  bg1: '#EAE4CA',
  bg2: '#E5DFC5',
  fg: '#5C6A72',
  grey0: '#A6B0A0',
  grey1: '#939F91',
  grey2: '#829181',
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
