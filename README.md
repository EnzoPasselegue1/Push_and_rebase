# 🚀 Push and Rebase Selective Script

This script automates the **Git workflow** for pushing selected files, rebasing on a chosen branch, and merging after rebase. It provides **interactive choices** at every step to ensure a **safe and controlled** Git process.

## 📂 Features

✅ **Select which files to commit** (avoiding unwanted changes)\
✅ **Choose the target branch for integration (not limited to ****************************`main`****************************)**\
✅ **Handle rebase conflicts and prevent force-pushing accidentally**\
✅ **Offer a controlled merge into a selected branch**\
✅ **Allow deleting the branch after merge** for cleanup

---

## 🛠️ **Installation**

1. **Download the script manually**:
   ```bash
     curl -O https://raw.githubusercontent.com/EnzoPasselegue1/Push_and_rebase/main/push_and_rebase.sh
   ```
2. **Make it executable**:
   ```bash
   chmod +x push_and_rebase.sh
   ```

---

## 🚀 **How to Use**

Run the script from the terminal:

```bash
./push_and_rebase.sh
```

The script will **prompt you step by step** for the actions you want to take, including choosing the target branch for integration.

---

## 📜 **Step-by-Step Breakdown**

### 1️⃣ **Selecting files to commit**

After detecting modified files, the script will ask which files you want to include in the commit.

Example:

```
📂 Modified files:
➕ Add 'file1.py' to the commit? (y/n) : y
➕ Add 'file2.js' to the commit? (y/n) : n
➕ Add 'file3.html' to the commit? (y/n) : y
```

- Only **selected files** will be added to the commit.
- If **no files** are selected, the commit is **canceled**.

### 1️⃣ **Selecting files to commit**

After detecting modified files, the script will ask which files you want to include in the commit.

### 2️⃣ **Choosing the target branch**

Instead of defaulting to `main`, the script lists all available branches and allows you to select the target branch.

### 3️⃣ **Updating the target branch before rebase or merge**

To avoid outdated versions, the script asks if you want to update the target branch:

```
🔄 Update '<target-branch>' before rebasing? (y/n) :
```

If **yes**, it runs:

```bash
git checkout <target-branch>
git pull origin <target-branch>
git checkout <your-branch>
```

The script ensures that the target branch is up to date before proceeding.

### 4️⃣ **Rebasing or Merging**

You can choose between `merge` (keeping commit history) or `rebase` (for a linear history):

```
🔀 Choose integration method:
1️⃣ Merge (Keep commit history)
2️⃣ Rebase (Linear history)
Enter 1 for Merge, 2 for Rebase:
```

- If **Merge** is selected, the script runs:

```bash
git checkout <target-branch>
git merge <your-branch>
```

- If **Rebase** is selected, the script runs:

```bash
git rebase <target-branch>
```

- If conflicts occur, the script **pauses** and asks you to resolve them before continuing:
  ```
  ❌ Conflicts detected! Resolve them, then run:
     git rebase --continue
  ```

You can choose between `merge` (keeping commit history) or `rebase` (for a linear history).

### 5️⃣ **Handling Conflicts**

If conflicts occur, the script pauses to allow you to resolve them before continuing.

### 6️⃣ **Pushing the integrated branch**

After integration, the script asks if you want to push the updated branch:

```
📤 Push '<target-branch>' to remote after merge/rebase? (y/n) :
```

If **yes**, it runs:

```bash
git push origin <target-branch>
```

After integration, the script prompts whether to push the updated branch.

### 7️⃣ **Deleting the source branch**

Once integration is complete, you can choose to delete the source branch to keep your repository clean.

---

## 🔄 **Full Workflow Example**

```
$ ./push_and_integrate.sh
📂 Available branches:
  - main
  - dev
  - feature-xyz
🚀 Select the target branch to integrate into (e.g., main, dev, release): dev
📂 Modified files:
➕ Add 'index.js' to the commit? (y/n) : y
📝 Enter your commit message: Fix navbar responsiveness
🔄 Update 'dev' before rebasing? (y/n) : y
🔀 Choose integration method:
1️⃣ Merge (Keep commit history)
2️⃣ Rebase (Linear history)
Enter 1 for Merge, 2 for Rebase: 2
🔀 Rebasing 'feature-branch' onto 'dev'...
📤 Pushing rebased changes...
🗑️ Delete branch 'feature-branch' after integration? (y/n) : y
✅ The branch 'feature-branch' has been deleted.
🎉 Everything is up to date with your selected integration method!
```

---

## 🛠️ **Customization & Improvements**

🔹 **Skip manual selection**: Add a `--auto` flag to select all files automatically.\
🔹 **Enable logs**: Modify the script to display commit logs before merging.\
🔹 **Dry run mode**: Add a `--dry-run` option to preview changes before applying them.

---

## 🤝 **Contributing**

Feel free to contribute by **submitting pull requests** or opening issues! If you have suggestions for new features, **let me know**.

---

## 📄 **License**

This script is open-source and available under the **MIT License**.

---

🎉 **Happy coding!**

