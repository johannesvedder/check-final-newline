#!/bin/sh -l

MODIFIED=0
FAIL_ON_ERROR=$1
SHOULD_COMMIT=$2 # Accept the commit_changes argument
BRANCH_NAME=$3 # Accept the commit_branch argument
USER_NAME=$4 # Accept the commit_name argument
USER_EMAIL=$5 # Accept the commit_email argument
COMMIT_MSG=$6 # Accept the commit_message argument

git config --global --add safe.directory /github/workspace

# Optionally set user.email and user.name if provided
if [ -n "$USER_EMAIL" ]; then
  git config --global user.email "$USER_EMAIL"
fi

if [ -n "$USER_NAME" ]; then
  git config --global user.name "$USER_NAME"
fi

# Check each file and append a newline if missing
for f in $(git grep -Il ''); do
  if [ "$(tail -c 1 "$f")" ]; then
    echo "$f"
    echo "" >> "$f" # Append newline
    MODIFIED=1
  fi
done

# Check if any file was modified
if [ $MODIFIED -eq 1 ]; then
  # If SHOULD_COMMIT is true, commit the changes
  if [ "$SHOULD_COMMIT" = "true" ]; then
    git add .
    git commit -m "$COMMIT_MSG"
    git push origin "$BRANCH_NAME"
  elif [ "$FAIL_ON_ERROR" = "true" ]; then
    exit 1
  fi
fi
