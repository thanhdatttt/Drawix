# 🎨 Drawix App

## 📌 Overview
**Drawix** is a cross-platform basic drawing application that allows users to create and edit basic geometric shapes.
The application supports drawing, coloring, customizing outlines, saving/loading drawings in a user-defined binary format and export to png.

---

## 👥 Members

|  | Fullname | Student ID | Responsibilities |
|-----|-----------|------|---------|
| 1 | Tran Khon Chi | 23127 | Leader / UI Development |
| 2 | Pham Thanh Dat | 23127170 | Drawing Engine |
| 3 | Mai Xuan Hung | 23127 | File Handling |
| 4 | Nguyen Van Minh | 23127422 | Encrypting and decrypting |
| 5 | Giao Thai Bao | 23127526 | Testing & Documentation |

---

## ✨ Features

### 🖊️ 1. Basic shapes drawing
-  **Point**
-  **Line**
-  **Rectangle**
-  **Square**
-  **Ellipse**
-  **Circle**

### 🎨 2. Coloring
- Choose a fill color for the shape.
- Apply a background color to app.

### 🧱 3. Customize stroke
- Change the stroke color
- Adjust the stroke thickness (Stroke Width)

### 💾 4. Save and load drawings
- Save the file using a **customizable binary format .drwx**
- Reopen the file to continue editing.

### 🖼️ 5. Export picture
- Supports exporting drawings to **PNG** format.

### 🖱️ 6. User interaction
- Select drawing tools
- Edit shape properties (stroke color, fill color, stroke width)
- Display the drawing in real time

---

## 🎬 Demo Video

👉 Demonstration of the application on different platform:

- 📹 Windows Demo:  
  https://your-demo-video-link

- 📹 Mobile Demo:  
  https://your-demo-video-link

- 📹 Web Demo:  
  https://your-demo-video-link

---

## 🛠️ Tech stack

- Flutter
- Dart
- Custom Binary File Format
- Cross-platform UI

---

## 📂 App structure

```
drawix/
│
├── android/
├── ios/
├── lib/
│   ├── models/
│   ├── painters/
│   ├── providers/
│   ├── screens/
│   ├── utils/
│   └── main.dart
├── web/
├── windows/
├── .gitignore
├── README.md
└── pubspec.yaml
```

---

## 🚀 Run the application

```bash
# Clone repository
git clone https://github.com/thanhdatttt/drawix.git

# Navigate to the app folder.
cd drawix

# Install dependencies
flutter pub get

# Run application
flutter run
```

---

## 📄 License

Project serves educational and research purposes.
