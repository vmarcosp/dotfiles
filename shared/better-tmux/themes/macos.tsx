import { Box, WindowConfig } from 'better-tmux'

/** yugen — macOS default. */
export const colors = {
  bg0: '#000000',
  fg0: '#fafafa',
  fg1: '#878787',
  fg2: '#3D3D3D',
}

export const status = {
  bg: colors.bg0,
  fg: colors.fg0,
  position: 'bottom' as const,
}

export const Window = ({ type, number, name }: WindowConfig) => (
  <Box padding={1} bg={'default'} fg={type === 'active' ? colors.fg1 : colors.fg2} bold>
    {number}: {name}
  </Box>
)
