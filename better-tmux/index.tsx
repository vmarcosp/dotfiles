import { Box, BetterTmuxConfig, WindowConfig } from 'better-tmux'

const Window = ({ type, number, name }: WindowConfig) => {
  return (
    <Box padding={1} bg={type === 'active' ? '#151515' : '#000000'}>
      {number}: {name}
    </Box>
  )
}

const StatusLeft = () => <Box> </Box>

export default {
  statusLeft: <StatusLeft />,
  window: (window) => <Window {...window} />
} satisfies BetterTmuxConfig
