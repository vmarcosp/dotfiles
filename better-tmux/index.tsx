import { Box, BetterTmuxConfig, WindowConfig } from 'better-tmux'

const Window = ({ type, number, name }: WindowConfig) => {
  return (
    <Box padding={1} bg={type === 'active' ? '#151515' : '#000000'}>
      {number}: {name}
    </Box>
  )
}


export default {
  options: {
    defaultTerminal: "xterm-256color",
    terminalOverrides: ",xterm-256color:Tc",
    escapeTime: 0,
    baseIndex: 1,
    paneBaseIndex: 1,
    renumberWindows: "on",
    statusKeys: "vi",
    historyLimit: 10000,
    prefix: "C-a",
    setTitles: "on",
    setTitlesString: " ",
    modeKeys: "vi",
    mouse: "on",
  },
  status: {
    bg: '#000000',
    fg: '#fafafa',
    position: "top"
  },
  window: (window) => <Window {...window} />
} satisfies BetterTmuxConfig
