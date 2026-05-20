# 🏟️ Israa Smart Play — تطبيق حجز ملاعب جامعة إسراء

<p align="center">
  <img src="assets/images/IsraaLogo.jpg" alt="Israa University Logo" width="120"/>
</p>

<p align="center">
  تطبيق موبايل لحجز الملاعب الرياضية في جامعة إسراء، مبني بـ Flutter مع مساعد ذكي مدعوم بـ Gemini AI
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter" />
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart" />
  <img src="https://img.shields.io/badge/Gemini_AI-Free-4285F4?logo=google" />
  <img src="https://img.shields.io/badge/Architecture-Clean-green" />
</p>

---

## 📱 مميزات التطبيق

| الميزة | الوصف |
|--------|-------|
| 🔐 تسجيل الدخول | بالرقم الجامعي |
| 🏅 الملاعب | تصفح وحجز ملاعب متعددة الرياضات |
| 📅 حجوزاتي | عرض وإدارة حجوزاتك |
| 🤖 المساعد الذكي | chatbot مدعوم بـ Gemini AI |
| 👤 الملف الشخصي | بيانات الطالب |

---

## 🛠️ المتطلبات

قبل ما تبدأ، تأكد عندك:

| الأداة | الإصدار المطلوب | رابط التنزيل |
|--------|----------------|-------------|
| Flutter SDK | `>= 3.3.0` | [flutter.dev](https://flutter.dev/docs/get-started/install) |
| Dart SDK | `>= 3.3.0` | يجي مع Flutter |
| Android Studio أو VS Code | أي إصدار | [developer.android.com](https://developer.android.com/studio) |
| Git | أي إصدار | [git-scm.com](https://git-scm.com) |

---

## 🚀 تشغيل المشروع من الصفر

### الخطوة 1 — استنسخ المشروع

```bash
git clone https://github.com/<your-username>/israa-booking-app.git
cd israa-booking-app
```

### الخطوة 2 — ثبّت الحزم

```bash
flutter pub get
```

### الخطوة 3 — احصل على Gemini API Key مجاني 🔑

1. اذهب إلى [aistudio.google.com/app/apikey](https://aistudio.google.com/app/apikey)
2. سجّل دخول بحساب Google
3. اضغط **Create API Key**
4. انسخ المفتاح

### الخطوة 4 — ضع الـ API Key في الكود

افتح هذا الملف:
```
lib/presentation/screens/chatbot/chatbot_screen.dart
```

غيّر السطر 19:
```dart
// قبل
static const _apiKey = 'YOUR_GEMINI_API_KEY';

// بعد
static const _apiKey = 'AIzaSy...مفتاحك هنا...';
```

### الخطوة 5 — شغّل التطبيق

```bash
# تحقق من الأجهزة المتصلة
flutter devices

# شغّل على جهاز أو محاكي
flutter run

# أو شغّل على أندرويد تحديداً
flutter run -d android

# أو بناء APK للتثبيت
flutter build apk --release
```

---

## 🗂️ هيكل المشروع

```
lib/
├── core/
│   ├── constants/          # ثوابت التطبيق والمسارات
│   ├── errors/             # معالجة الأخطاء
│   ├── theme/              # الألوان والخطوط والثيم
│   ├── utils/              # أدوات مساعدة
│   └── widgets/            # widgets مشتركة
│
├── data/
│   ├── datasources/        # مصادر البيانات (API calls)
│   ├── models/             # نماذج البيانات
│   └── repositories/       # تنفيذ الـ repositories
│
├── domain/
│   ├── entities/           # كيانات الأعمال
│   ├── repositories/       # واجهات الـ repositories
│   └── usecases/           # حالات الاستخدام
│
├── presentation/
│   ├── providers/          # إدارة الحالة (Riverpod)
│   ├── screens/
│   │   ├── chatbot/        # 🤖 شاشة المساعد الذكي
│   │   ├── booking/        # شاشات الحجز
│   │   ├── home/           # الصفحة الرئيسية
│   │   ├── login/          # تسجيل الدخول
│   │   ├── my_bookings/    # حجوزاتي
│   │   ├── profile/        # الملف الشخصي
│   │   └── sports/         # الملاعب والرياضات
│   └── widgets/            # widgets خاصة بالعرض
│
├── routing/                # إدارة التنقل (GoRouter)
└── main.dart               # نقطة البداية
```

---

## 📦 الحزم المستخدمة

| الحزمة | الإصدار | الغرض |
|--------|---------|-------|
| `flutter_riverpod` | ^2.5.1 | إدارة الحالة |
| `go_router` | ^13.2.4 | التنقل بين الشاشات |
| `equatable` | ^2.0.5 | مقارنة الكائنات |
| `intl` | 0.20.2 | التواريخ والتوطين |
| `http` | ^1.2.1 | طلبات الـ API |

---

## 🤖 إعداد المساعد الذكي

التطبيق يستخدم **Gemini 2.0 Flash** المجاني من Google.

### الحدود المجانية (مجاني تماماً):
- **15 طلب / دقيقة**
- **1 مليون token / يوم**
- **بدون بطاقة ائتمان**

### تخصيص شخصية المساعد:

في ملف `chatbot_screen.dart`، عدّل الـ `_systemPrompt`:

```dart
static const _systemPrompt = '''
أنت مساعد ذكي لتطبيق حجز ملاعب جامعة إسراء.
// أضف تعليماتك هنا...
''';
```

---

## ⚙️ إعداد الـ Backend

التطبيق يتصل بـ backend خارجي. عدّل الـ endpoints في:
```
lib/core/constants/app_constants.dart
```

---

## 🔒 ملاحظة أمنية مهمة

> ⚠️ لا ترفع الـ API Key على GitHub مباشرة!

بدلاً من ذلك استخدم:

```bash
# تأكد إن .env موجود في .gitignore
echo ".env" >> .gitignore
```

أو استخدم [flutter_dotenv](https://pub.dev/packages/flutter_dotenv) لقراءة المتغيرات من ملف `.env`.

---

## 📤 رفع المشروع على GitHub (من الصفر)

```bash
# 1. ابدأ git في المجلد
git init

# 2. أضف كل الملفات
git add .

# 3. أول commit
git commit -m "Initial commit — Israa Smart Play"

# 4. اربط بالريبو (غيّر الـ URL لريبوك)
git remote add origin https://github.com/<your-username>/israa-booking-app.git

# 5. ارفع
git push -u origin main
```

---

## 👥 فريق التطوير

| الاسم | الدور |
|-------|-------|
| محمد كمال البطش | Full Stack Developer |
| حسين راسم جازية | Flutter Developer |
| نواف خالد البجا | Backend Developer |
| عبدالله سلطان الرويلي | UI/UX Developer |
| غانم عدنان الطراونة | QA & Testing |

**المشرف:** د. عمرو الشواورة

---

## 📄 الرخصة

هذا المشروع مشروع تخرج أكاديمي — **جامعة إسراء © 2026**
