#!/usr/bin/env bash
# Run this on a remote machine to generate slop forever.
#
# Setup:
#   git clone https://github.com/jshchnz/codemaxxed.git
#   git clone https://github.com/jshchnz/codemaxxing.git
#   cd codemaxxing && pip install -e . && cd ../codemaxxed
#   chmod +x run-forever.sh
#   nohup ./run-forever.sh > slop.log 2>&1 &
#
# Or with screen/tmux:
#   screen -S slop ./run-forever.sh

set -e

SANITY="${SANITY:-30}"
BATCH_SIZE="${BATCH_SIZE:-25}"
PUSH_EVERY="${PUSH_EVERY:-50}"

git config user.name "codemaxxing-bot"
git config user.email "codemaxxing-bot@users.noreply.github.com"

fmt_num() { echo "$1" | sed -e :a -e 's/\(.*[0-9]\)\([0-9]\{3\}\)/\1,\2/;ta'; }

update_stats() {
  LINES=$(find . -type f \( -name '*.py' -o -name '*.java' -o -name '*.js' -o -name '*.ts' -o -name '*.go' \) -not -path './.codemaxxing-tool/*' | xargs wc -l 2>/dev/null | tail -1 | awk '{print $1}')
  FILES=$(find . -type f \( -name '*.py' -o -name '*.java' -o -name '*.js' -o -name '*.ts' -o -name '*.go' \) -not -path './.codemaxxing-tool/*' | wc -l | tr -d ' ')
  COMMITS=$(git rev-list --count HEAD)
  LINES_FMT=$(fmt_num "$LINES")
  FILES_FMT=$(fmt_num "$FILES")
  COMMITS_FMT=$(fmt_num "$COMMITS")
  LINES_URL=$(echo "$LINES_FMT" | sed 's/,/%2C/g')
  FILES_URL=$(echo "$FILES_FMT" | sed 's/,/%2C/g')
  COMMITS_URL=$(echo "$COMMITS_FMT" | sed 's/,/%2C/g')

  # update README badges (img tags)
  sed -i.bak "s|<img src=\"https://img.shields.io/badge/lines%20of%20code-[^\"]*\" alt=\"Lines of Code\">|<img src=\"https://img.shields.io/badge/lines%20of%20code-${LINES_URL}%20and%20counting-brightgreen?style=for-the-badge\" alt=\"Lines of Code\">|" README.md
  sed -i.bak "s|<img src=\"https://img.shields.io/badge/files-[^\"]*\" alt=\"Files\">|<img src=\"https://img.shields.io/badge/files-${FILES_URL}-blue?style=for-the-badge\" alt=\"Files\">|" README.md
  sed -i.bak "s|<img src=\"https://img.shields.io/badge/commits-[^\"]*\" alt=\"Commits\">|<img src=\"https://img.shields.io/badge/commits-${COMMITS_URL}-orange?style=for-the-badge\" alt=\"Commits\">|" README.md
  rm -f README.md.bak

  echo "{\"lines\": $LINES, \"files\": $FILES, \"commits\": $COMMITS, \"lines_fmt\": \"$LINES_FMT\", \"files_fmt\": \"$FILES_FMT\", \"commits_fmt\": \"$COMMITS_FMT\"}" > stats.json
  git add stats.json README.md
  git commit -m "update stats: ${LINES_FMT} lines, ${FILES_FMT} files, ${COMMITS_FMT} commits" 2>/dev/null || true
}

echo "=== CODEMAXXING FOREVER MODE ==="
echo "Sanity: $SANITY | Batch: $BATCH_SIZE | Push every: $PUSH_EVERY commits"
echo "Started: $(date)"
echo ""

# Run in chunks so we can update stats periodically
while true; do
  codemaxxing \
    --turbo \
    --lines 500000 \
    --sanity "$SANITY" \
    --batch-size "$BATCH_SIZE" \
    --branch main \
    --output . \
    --push-every "$PUSH_EVERY"

  update_stats
  git push origin main 2>/dev/null || true
  echo ""
  echo "=== Chunk complete at $(date), looping... ==="
  echo ""
done
