# 🧠 Gfrcr's Enhanced PTCGP Bot

This is a heavily improved extension of [Arturo's PTCGP Bot](https://github.com/Arturo-1212/PTCGPB), originally forked by [Hoytdj](https://github.com/hoytdj/PTCGPB) and now upgraded with additional features by **Gfrcr**.

> 💡 This fork focuses on smarter automation, enhanced logging, a cleaner UI, better friend filtering, and optimized workflow during GP testing — while remaining true to the core functionality developed by Arturo and enhanced by Hoytdj.

---

## 📦 Main Features

### 🎯 Intelligent Friend List Filtering

- Instances **automatically add/remove `friendIDs`** based on the type of booster being opened.
- Uses `id.txt` to identify interested users.
- If the booster is a **Godpack**, all users stay on the Friend List.
- For other types (e.g., **Double Two Stars**, **Trainers**, etc.), uninterested users are removed from the FL before opening begins.

### 🧪 GP Test Automation

- On GP Test start:
  - A **heartbeat** is sent to mark the instance as **Offline**.
  - UI is **cleared** for better visibility.
- On GP Test end:
  - A new **heartbeat** marks the **Main as Online** again.
  - Status messages return to normal.

### 📡 Webhook Improvements

- More accurate webhook messages for Main.
- Sends a notification when **GP Test is ready**.

### 🧼 Minimal UI Enhancements

- Cleaner status labels above each instance.
- No more `failtimes`.
- Pressing the status bar now results in a **blank display**.

### ⌨️ Manual Heartbeat Trigger

- **Shift + F7** sends a heartbeat to mark **Main and all instances as Offline**.

### 📄 Improved Logging System

- Cleaner, more transparent logs.
- Individual logs per instance.
- Separate logs for **errors**, **restarts**, and other key actions.

### 🧩 Shared Function File

- Common functions have been centralized into a **single shared file**, reducing redundancy and simplifying maintenance.

---

## 🔧 Base Enhancements from Hoytdj's Fork (Nizuya Mod)

- "**GP Test**" mode: removes all non-VIP friends to help find Wonder Picks.
- VIP management via `vip_ids.txt`, supporting FCs, IGNs, and star ratings.
- Optional **VIP ID URL** to auto-update VIP list from an external file.
- Support for:
  - **100% UI scale** (via _Rayer_3's Scale100_)
  - **5 Pack No Remove** method (via _DietPepperPhD_)
- New options:
  - **Heartbeat Delay**
  - **Send Account XML** (attach .xml file to Discord alerts)

---

## 📘 Getting Started

Follow the instructions in the [original wiki](https://github.com/Arturo-1212/PTCGPB/wiki/Pokemon-TCG-Pocket-Bot).

> 🔧 **Tesseract OCR is required**  
> Download: [Tesseract OCR](https://github.com/UB-Mannheim/tesseract/wiki)  
> Recommended path: `C:\Program Files\Tesseract-OCR`  
> If installed elsewhere, update `Settings.ini`:  
> `tesseractPath=C:\path\to\your\tesseract.exe`

---

## 🧾 License

This project is licensed under the **Creative Commons Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)** license.  
**Commercial use is strictly prohibited**, even with donations.

---

## ☕ Credits

- 💻 Original bot: [Arturo-1212](https://github.com/Arturo-1212/PTCGPB)
- 🔄 Base fork and mod: [Hoytdj](https://github.com/hoytdj/PTCGPB)
- 🚀 Additional improvements: **Gfrcr**

---

> _“The bot will always be free and I will update it as long as this method is viable. If it’s helped you complete your collection, consider buying me a coffee!”_  
> — [Arturo](https://buymeacoffee.com/aarturoo)

---

---

_A note from Arturo (which I echo):_

_The bot will always be free and I will update it as long as this method is viable. I've spent many hours creating the PTCGPB, and if it’s helped you complete your collection, consider buying me a coffee to keep me going and adding new features!_
https://buymeacoffee.com/aarturoo

_Thanks for your support, and let’s keep those god packs coming!_ 😄
