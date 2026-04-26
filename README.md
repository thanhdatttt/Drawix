# 🎨 Drawix App

## 📌 Overview
**Drawix** is a cross-platform basic drawing application that allows users to create and edit basic geometric shapes.
The application supports drawing, coloring, customizing outlines, saving/loading drawings in a user-defined binary format and export to png.

---

## 👥 Members

|  | Fullname | Student ID | Responsibilities |
|-----|-----------|------|---------|
| 1 | Tran Khon Chi | 23127032 | Leader / UI Development |
| 2 | Pham Thanh Dat | 23127170 | Drawing Engine |
| 3 | Mai Xuan Hung | 23127372 | File Handling |
| 4 | Nguyen Van Minh | 23127422 | Encrypting and decrypting |
| 5 | Giao Thai Bao | 23127526 | Testing & Documentation |

---

## 🛠️ Tech stack

- Flutter
- Dart
- Custom Binary File Format

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

Web demo:

https://drive.google.com/file/d/1W-MjGuH8n-bvS7wXF1zAHPRtPXuIreQ4/view?usp=drive_link

Window app demo:

https://drive.google.com/file/d/1FAx5v5ODZ3ny-Vz8rKr1X_LLZtDwtnZm/view?usp=drive_link

Mobile demo:

https://drive.google.com/file/d/1JPxzGPvDBcs5XlzT0lZeuaTeP8fDemwQ/view?usp=drive_link

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
