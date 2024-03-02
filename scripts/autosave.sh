cd ~/projects/memos/

git add .
git commit -m "logseq: autosync with remote"
git fetch origin
git pull --rebase
git push origin
