import { Box, BetterTmuxConfig, WindowConfig } from 'better-tmux'

const Window = ({ type, number, name }: WindowConfig) => {
  return (
    <Box padding={1} bg={type === 'active' ? '#151515' : '#000000'}>
      {number}: {name}
    </Box>
  )
}

export default {
  status: {
    bg: '#000000',
    fg: '#fafafa'
  },
  window: (window) => <Window {...window} />
} satisfies BetterTmuxConfig
