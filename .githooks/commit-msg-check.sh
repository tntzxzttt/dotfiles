#!/usr/bin/env bash

set -euo pipefail

commit_msg_file="$1"
commit_msg="$(cat "$commit_msg_file")"

./scripts/check-commit-msg.sh "$commit_msg"
