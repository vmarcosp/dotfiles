import { Box } from 'better-tmux'

const MyStatusLeft = () => (
  <Box bg="#000000" gap={1}>
  <Box bg="#fafafa" fg="#000000" padding={1}>🚀</Box>
  <Box bg="#fafafa" fg="#000000" padding={1}>🚀</Box>
  </Box>
)

export default {
  statusLeft: <MyStatusLeft />,
  statusRight: <MyStatusLeft />
}
