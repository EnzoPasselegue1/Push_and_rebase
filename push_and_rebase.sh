#!/bin/bash

# Get the current branch name
current_branch=$(git branch --show-current)

# Ensure we are not already on 'main'
if [ "$current_branch" == "main" ]; then
    echo "❌ You are already on 'main'. Switch to another branch before running this script."
    exit 1
fi

# Check for modified files
modified_files=$(git status --porcelain | awk '{print $2}')

if [ -z "$modified_files" ]; then
    echo "✅ No modified files, no commit needed."
else
    echo "📂 Modified files:"
    declare -a selected_files=()

    # Ask the user which files to add
    for file in $modified_files; do
        read -p "➕ Add '$file' to the commit? (y/n) : " add_file
        if [[ "$add_file" == "y" ]]; then
            selected_files+=("$file")
        fi
    done

    # Ensure at least one file is selected
    if [ ${#selected_files[@]} -eq 0 ]; then
        echo "⚠️ No files selected, commit aborted."
        exit 1
    fi

    # Add selected files
    git add "${selected_files[@]}"
    
    # Ask for a commit message
    read -p "📝 Enter your commit message: " commit_message
    git commit -m "$commit_message"
    git push origin "$current_branch"
fi

# Ask if we should update 'main' before rebasing
read -p "🔄 Update 'main' before rebasing? (y/n) : " update_main
if [[ "$update_main" == "y" ]]; then
    echo "📥 Updating 'main'..."
    git checkout main
    git pull origin main
    git checkout "$current_branch"
fi

# Rebase on main
echo "🔀 Rebasing '$current_branch' onto 'main'..."
git rebase main

# Check for conflicts
if [ $? -ne 0 ]; then
    echo "❌ Conflicts detected! Resolve them, then run:"
    echo "   git rebase --continue"
    exit 1
fi

# Confirm before forcing the push
read -p "⚠️ Force push after rebase? (y/n) : " confirm_force_push
if [[ "$confirm_force_push" == "y" ]]; then
    echo "📤 Pushing rebased changes..."
    git push origin "$current_branch" --force-with-lease
else
    echo "🚫 Force push canceled. You can do it manually if needed."
    exit 1
fi

# Merge the branch into 'main' after rebase
read -p "🔄 Merge '$current_branch' into 'main' after rebase? (y/n) : " merge_main
if [[ "$merge_main" == "y" ]]; then
    git checkout main
    git pull origin main  # Ensure 'main' is up to date before merging

    if ! git merge "$current_branch"; then
        echo "❌ Merge conflicts detected! Resolve them, then run:"
        echo "   git merge --continue"
        exit 1
    fi

    read -p "📤 Push 'main' to remote after merge? (y/n) : " push_main
    if [[ "$push_main" == "y" ]]; then
        git push origin main
    else
        echo "🚫 Push canceled. You will need to push manually if needed."
    fi
fi

# Ask if the branch should be deleted after merge
read -p "🗑️ Delete branch '$current_branch' after merge? (y/n) : " delete_branch
if [[ "$delete_branch" == "y" ]]; then
    git branch -d "$current_branch"
    git push origin --delete "$current_branch"
    echo "✅ The branch '$current_branch' has been deleted."
fi

echo "🎉 Everything is up to date with selective file commits!"
