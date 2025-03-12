#!/bin/bash

# Get the current branch name
current_branch=$(git branch --show-current)

# Ensure we are not already on the target branch
if [ -z "$current_branch" ]; then
    echo "❌ No branch detected. Make sure you are inside a Git repository."
    exit 1
fi

# Fetch the latest branch list
git fetch --all --quiet

# List available branches and ask for a target branch
echo "📂 Available branches:"
git branch -r | sed 's/origin\///' | sort | uniq
read -p "🚀 Select the target branch to integrate into (e.g., main, dev, release): " target_branch

# Ensure the selected branch is valid
if ! git show-ref --verify --quiet refs/heads/"$target_branch"; then
    echo "❌ Branch '$target_branch' does not exist locally. Checking remote..."
    if git ls-remote --exit-code --heads origin "$target_branch"; then
        echo "📥 Fetching '$target_branch' from remote..."
        git checkout -b "$target_branch" origin/"$target_branch"
    else
        echo "❌ The branch '$target_branch' does not exist in the remote repository either."
        exit 1
    fi
fi

# Ensure we are not integrating into the same branch
if [ "$current_branch" == "$target_branch" ]; then
    echo "❌ You cannot integrate a branch into itself. Choose another branch."
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

# Ask if we should update the target branch before integrating
read -p "🔄 Update '$target_branch' before proceeding? (y/n) : " update_target
if [[ "$update_target" == "y" ]]; then
    echo "📥 Updating '$target_branch'..."
    git checkout "$target_branch"
    git pull origin "$target_branch"
    git checkout "$current_branch"
fi

# Ask the user to choose between merge or rebase
echo "🔀 Choose your integration method:"
echo "1️⃣ Merge (Keep commit history and create a merge commit)"
echo "2️⃣ Rebase (Rewrite commit history for a clean linear history)"
read -p "Enter 1 for Merge, 2 for Rebase: " integration_method

if [[ "$integration_method" == "2" ]]; then
    # Rebase option
    echo "🔀 Rebasing '$current_branch' onto '$target_branch'..."
    git rebase "$target_branch"

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
else
    # Merge option
    echo "🔄 Merging '$current_branch' into '$target_branch'..."
    git checkout "$target_branch"
    git pull origin "$target_branch"  # Ensure the target branch is up to date before merging

    if ! git merge --no-ff "$current_branch"; then
        echo "❌ Merge conflicts detected! Resolve them, then run:"
        echo "   git merge --continue"
        exit 1
    fi

    read -p "📤 Push '$target_branch' to remote after merge? (y/n) : " push_target
    if [[ "$push_target" == "y" ]]; then
        git push origin "$target_branch"
    else
        echo "🚫 Push canceled. You will need to push manually if needed."
    fi
fi

# Ask if the branch should be deleted after integration
read -p "🗑️ Delete branch '$current_branch' after integration? (y/n) : " delete_branch
if [[ "$delete_branch" == "y" ]]; then
    git branch -d "$current_branch"
    git push origin --delete "$current_branch"
    echo "✅ The branch '$current_branch' has been deleted."
fi

echo "🎉 Everything is up to date with your selected integration method into '$target_branch'!"
