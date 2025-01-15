#!/usr/bin/env python3
import sys
import re


def verify_commit_message(commit_msg_file):
    with open(commit_msg_file, "r") as f:
        commit_msg = f.read().strip()

    pattern = r"^(feat|fix|docs|style|refactor|test|chore)(\([a-z-]+\))?: .+$"

    if not re.match(pattern, commit_msg):
        print("ERROR: Invalid commit message format.")
        print("Format should be: <type>(<scope>): <description>")
        print("Types: feat, fix, docs, style, refactor, test, chore")
        print("Example: feat(auth): add JWT authentication")
        sys.exit(1)


if __name__ == "__main__":
    verify_commit_message(sys.argv[1])
