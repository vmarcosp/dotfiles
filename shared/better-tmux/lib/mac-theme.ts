import { existsSync, readFileSync } from 'node:fs'
import { homedir } from 'node:os'
import { join } from 'node:path'

export type MacTheme = 'yugen' | 'everforest-light'

/** Written by macos/bin/theme: ~/.local/state/dotfiles/theme */
export function macTheme(): MacTheme {
  const state = process.env.XDG_STATE_HOME || join(homedir(), '.local/state')
  const file = join(state, 'dotfiles/theme')
  if (!existsSync(file)) return 'yugen'

  const name = readFileSync(file, 'utf8').trim()
  return name === 'everforest-light' ? name : 'yugen'
}
