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

update_stats() {
  LINES=$(find . -type f \( -name '*.py' -o -name '*.java' -o -name '*.js' -o -name '*.ts' -o -name '*.go' \) -not -path './.codemaxxing-tool/*' | xargs wc -l 2>/dev/null | tail -1 | awk '{print $1}')
  FILES=$(find . -type f \( -name '*.py' -o -name '*.java' -o -name '*.js' -o -name '*.ts' -o -name '*.go' \) -not -path './.codemaxxing-tool/*' | wc -l | tr -d ' ')
  COMMITS=$(git rev-list --count HEAD)
  LINES_FMT=$(printf "%'d" "$LINES")
  FILES_FMT=$(printf "%'d" "$FILES")
  COMMITS_FMT=$(printf "%'d" "$COMMITS")
  echo "{\"lines\": $LINES, \"files\": $FILES, \"commits\": $COMMITS, \"lines_fmt\": \"$LINES_FMT\", \"files_fmt\": \"$FILES_FMT\", \"commits_fmt\": \"$COMMITS_FMT\"}" > stats.json
  git add stats.json
  git commit -m "update stats: ${LINES} lines, ${FILES} files, ${COMMITS} commits" 2>/dev/null || true
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
