# Push_and_rebase
This script automates the **Git workflow** for pushing selected files, rebasing on `main`, and merging after rebase. It provides **interactive choices** at every step to ensure a **safe and controlled** Git process.
# 🚀 Push and Rebase Selective Script

This script automates the **Git workflow** for pushing selected files, rebasing on `main`, and merging after rebase. It provides **interactive choices** at every step to ensure a **safe and controlled** Git process.

## 📂 Features
✅ **Select which files to commit** (avoiding unwanted changes)  
✅ **Ensure `main` is up to date** before rebasing  
✅ **Handle rebase conflicts** and prevent force-pushing accidentally  
✅ **Offer a controlled merge into `main`**  
✅ **Allow deleting the branch after merge** for cleanup  

---

## 🛠️ **Installation**
1. **Download the script manually**:
   ```bash
   curl -O https://raw.githubusercontent.com/EnzoPasselegue1/Push_and_rebase/blob/push_and_rebase.sh
   ```
2. **Make it executable**:
   ```bash
   chmod +x Push_and_rebase.sh
   ```

---

## 🚀 **How to Use**
Run the script from the terminal:
```bash
./Push_and_rebase.sh
```
The script will **prompt you step by step** for the actions you want to take.

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

---

### 2️⃣ **Entering a commit message**
Once files are selected, you will be prompted for a commit message:
```
📝 Enter your commit message:
```
- This message will be used for `git commit -m "<your-message>"`.

---

### 3️⃣ **Updating `main` before rebase**
To avoid outdated versions, the script asks if you want to update `main`:
```
🔄 Update 'main' before rebasing? (y/n) :
```
If **yes**, it runs:
```bash
git checkout main
git pull origin main
git checkout <your-branch>
```

---

### 4️⃣ **Rebasing the branch onto `main`**
After switching back to the branch, the script **rebases it on `main`**:
```bash
git rebase main
```
- If there are conflicts, the script **pauses** and asks you to resolve them before continuing:
  ```
  ❌ Conflicts detected! Resolve them, then run:
     git rebase --continue
  ```

---

### 5️⃣ **Force push after rebase**
Since rebase rewrites history, the script asks **before force-pushing**:
```
⚠️ Force push after rebase? (y/n) :
```
If **yes**, it runs:
```bash
git push origin <your-branch> --force-with-lease
```
- The `--force-with-lease` flag prevents overwriting commits from other users.

---

### 6️⃣ **Merging into `main` after rebase**
If the rebase is successful, the script asks if you want to merge the branch into `main`:
```
🔄 Merge '<your-branch>' into 'main' after rebase? (y/n) :
```
If **yes**, it does:
```bash
git checkout main
git pull origin main  # Ensures 'main' is up-to-date before merging
git merge <your-branch>
```
- If **merge conflicts** occur, you must resolve them before continuing:
  ```
  ❌ Merge conflicts detected! Resolve them, then run:
     git merge --continue
  ```

---

### 7️⃣ **Pushing `main` after merge**
After merging, the script asks if you want to push `main`:
```
📤 Push 'main' to remote after merge? (y/n) :
```
If **yes**, it runs:
```bash
git push origin main
```

---

### 8️⃣ **Deleting the branch after merge**
Once everything is merged and pushed, the script offers to delete the branch:
```
🗑️ Delete branch '<your-branch>' after merge? (y/n) :
```
If **yes**, it runs:
```bash
git branch -d <your-branch>
git push origin --delete <your-branch>
```
- This **cleans up** your local and remote repository.

---

## 🔄 **Full Workflow Example**
```
$ ./push_and_rebase_selective.sh
📂 Modified files:
➕ Add 'index.js' to the commit? (y/n) : y
➕ Add 'styles.css' to the commit? (y/n) : n
📝 Enter your commit message: Fix navbar responsiveness
🔄 Update 'main' before rebasing? (y/n) : y
🔀 Rebasing 'feature-branch' onto 'main'...
⚠️ Force push after rebase? (y/n) : y
📤 Pushing rebased changes...
🔄 Merge 'feature-branch' into 'main' after rebase? (y/n) : y
📤 Push 'main' to remote after merge? (y/n) : y
🗑️ Delete branch 'feature-branch' after merge? (y/n) : y
✅ The branch 'feature-branch' has been deleted.
🎉 Everything is up to date with selective file commits!
```

---

## 🛠️ **Customization & Improvements**
🔹 **Skip manual selection**: Add a `--auto` flag to select all files automatically.  
🔹 **Enable logs**: Modify the script to display commit logs before merging.  
🔹 **Dry run mode**: Add a `--dry-run` option to preview changes before applying them.  

---

## 🤝 **Contributing**
Feel free to contribute by **submitting pull requests** or opening issues! If you have suggestions for new features, **let me know**.

---

## 📄 **License**
This script is open-source and available under the **MIT License**.

---

🎉 **Happy coding!**

