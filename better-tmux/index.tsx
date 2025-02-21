import { Box, BetterTmuxConfig, WindowConfig, Bind } from 'better-tmux'

const Window = ({ type, number, name }: WindowConfig) => {
  return (
    <Box paddingLeft={1} bg='#0B0B13' fg={type === 'active' ? '#7D8297' : '#494B58'} bold>
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
    bg: '#0B0B13',
    fg: '#7D8297',
    position: "top"
  },
  window: (window) => <Window {...window} />
} satisfies BetterTmuxConfig
