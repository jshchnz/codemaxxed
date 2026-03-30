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

echo "=== CODEMAXXING FOREVER MODE ==="
echo "Sanity: $SANITY | Batch: $BATCH_SIZE | Push every: $PUSH_EVERY commits"
echo "Started: $(date)"
echo ""

codemaxxing \
  --turbo \
  --forever \
  --sanity "$SANITY" \
  --batch-size "$BATCH_SIZE" \
  --branch main \
  --output . \
  --push-every "$PUSH_EVERY"
