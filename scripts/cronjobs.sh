LOGSEQ_AUTOSAVE="*/60 * * * * ~/projects/dotfiles/logseq/autosave.sh"
CURRENT_CRONS="current_crons"

crontab -l > "$CURRENT_CRONS" 

echo "$LOGSEQ_AUTOSAVE" >> "$CURRENT_CRONS"

crontab "$CURRENT_CRONS"

rm "$CURRENT_CRONS"
