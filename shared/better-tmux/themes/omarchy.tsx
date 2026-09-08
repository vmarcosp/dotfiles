import { Box, WindowConfig } from 'better-tmux'
import { omarchyPalette } from '../lib/omarchy-colors'

const palette = omarchyPalette()

export const colors = {
  bg0: palette.darkerBackground,
  fg0: palette.foreground,
  fg1: palette.accent,
  fg2: palette.muted,
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
