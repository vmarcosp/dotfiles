import { Box, WindowConfig } from 'better-tmux'

/** Everforest light (medium) — macOS option via `theme everforest-light`. */
export const colors = {
  bg0: '#fdf6e3',
  fg0: '#5c6a72',
  fg1: '#5c6a72',
  fg2: '#bdc3af',
}

export const status = {
  bg: 'default',
  fg: colors.fg0,
  position: 'bottom' as const,
}

export const Window = ({ type, number, name }: WindowConfig) => (
  <Box padding={1} bg={'default'} fg={type === 'active' ? colors.fg1 : colors.fg2} bold>
    {number}: {name}
  </Box>
)
