import { existsSync, readFileSync } from 'node:fs'
import { homedir } from 'node:os'
import { join } from 'node:path'

export type OmarchyPalette = {
  background: string
  darkerBackground: string
  foreground: string
  muted: string
  accent: string
}

/** Miasma — used if colors.toml is missing. */
const fallback: OmarchyPalette = {
  background: '#222222',
  darkerBackground: '#121212',
  foreground: '#c2c2b0',
  muted: '#666666',
  accent: '#78824b',
}

function tomlString(text: string, key: string): string | undefined {
  const match = text.match(new RegExp(`^${key}\\s*=\\s*"([^"]+)"`, 'm'))
  return match?.[1]
}

/** Live Omarchy theme: ~/.local/state/omarchy/current/theme/colors.toml */
export function omarchyPalette(): OmarchyPalette {
  const file = join(homedir(), '.local/state/omarchy/current/theme/colors.toml')
  if (!existsSync(file)) return fallback

  const text = readFileSync(file, 'utf8')
  return {
    background: tomlString(text, 'background') ?? fallback.background,
    darkerBackground: tomlString(text, 'darker_background') ?? fallback.darkerBackground,
    foreground: tomlString(text, 'foreground') ?? fallback.foreground,
    muted: tomlString(text, 'muted') ?? fallback.muted,
    accent: tomlString(text, 'accent') ?? fallback.accent,
  }
}
