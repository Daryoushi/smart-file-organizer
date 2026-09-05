# Linux Essentials: Smart File Organizer 🗂️

> یک ابزار خودکار و خط فرمانی بر پایه Bash برای مرتب‌سازی، دسته‌بندی و مدیریت هوشمند فایل‌ها بر اساس نوع و پسوند، همراه با سیستم لاگ‌گیری دقیق و مدیریت فایل‌های تکراری.

---

## 📌 معرفی پروژه

پروژه **Smart File Organizer** یک اسکریپت پیشرفته، خودکار و سبک بر پایه **Bash** است که فایل‌های موجود در یک پوشه ورودی را بر اساس پسوند و نوع محتوا دسته‌بندی کرده و به پوشه‌های مرتب‌شده منتقل می‌کند.  
این اسکریپت با رعایت کامل اصول استانداردهای یونیکس/لینوکس و بدون نیاز به ابزارهای جانبی پیاده‌سازی شده است.

---

## ✨ ویژگی‌های کلیدی

1. **دریافت هوشمند مسیر (Input Validation):**
   - دریافت مسیر با دستور `read -p` یا پارامتر ورودی خط فرمان.
   - اعتبارسنجی دقیق وجود پوشه و دسترسی‌های خواندن/نوشتن.

2. **ساخت خودکار ساختار پوشه‌ها (Auto Directory Creation):**
   - در صورت عدم وجود هر یک از پوشه‌های مقصد، اسکریپت با دستور `mkdir -p` آن‌ها را به شکل خودکار ایجاد می‌کند.

3. **دسته‌بندی هوشمند و جامع بر اساس پسوند:**
   - **تصاویر (Images):** `jpg, jpeg, png, gif, bmp, webp, svg, tiff, ico`
   - **اسناد (Documents):** `pdf, doc, docx, txt, xls, xlsx, ppt, pptx, odt, csv, md`
   - **ویدیوها (Videos):** `mp4, mkv, avi, mov, wmv, flv, webm, m4v`
   - **فایل‌های فشرده (Archives):** `zip, rar, tar, gz, 7z, bz2, xz`
   - **سایر فایل‌ها و ناشناخته (Others):** فایل‌های بدون پسوند یا با پسوندهای نامتعارف.

4. **مدیریت پیشرفته فایل‌های همنام (Duplicate Collision Handling):**
   - در صورت وجود فایلی با نام یکسان در پوشه مقصد، اسکریپت بدون بازنویسی (Overwrite) فایل قبلی، نام جدید را به صورت خودکار شماره‌گذاری می‌کند (`file_1.ext`, `file_2.ext`, ...).

5. **ثبت لاگ کامل با تاریخ و ساعت (Timestamped Logging):**
   - تمام رخدادها (ایجاد پوشه، انتقال فایل‌ها، تغییر نام فایل‌های تکراری) با تاریخ و زمان دقیق در فایل `log.txt` ذخیره می‌شوند.

6. **گزارش پایانی در ترمینال (Terminal Summary Report):**
   - نمایش خروجی تفکیک‌شده با رنگ‌بندی ترمینال شامل تعداد فایل‌های جابجا شده به تفکیک:
     - **عکس‌ها (Images)**
     - **فایل‌های PDF**
     - **فایل‌های فشرده (ZIP)**
     - **سایر فایل‌های فشرده (Other Archives)**
     - **ویدیوها (Videos)**
     - **سایر اسناد متنی (Other Documents)**
     - **فایل‌های ناشناخته (Others / Unknown)**
     - **مجموع کل فایل‌های جابجا شده**

7. **حفاظت از فایل‌های اسکریپت و لاگ (Safe Exclusions):**
   - اسکریپت‌های اجرایی (`*.sh`) و فایل‌های لاگ (`*.log`, `log.txt`) و همچنین زیرپوشه‌های موجود در دایرکتوری نادیده گرفته می‌شوند تا فرآیند کاملاً تکرارپذیر (Idempotent) باشد.

8. **طراحی سطح اول و ایمن (Non-Recursive by Design):**
   - اسکریپت تنها فایل‌های سطح اول (Root Level) پوشه هدف را ساماندهی می‌کند و وارد زیرپوشه‌ها یا پوشه‌های تودرتو (Nested Directories) نمی‌شود تا ساختار پروژه‌ها یا پوشه‌های از پیش ساخته‌شده تغییر نکند.

---


## 📂 ساختار فایل‌های پروژه

```plaintext
.
├── organizer.sh             # اسکریپت اصلی سازماندهی فایل‌ها
├── generate_test_files.sh   # اسکریپت کمکی جهت تولید نمونه فایل‌های تستی
├── README.md                # مستندات کامل و راهنمای پروژه
└── .gitignore               # نادیده گرفتن فایل‌ها و پوشه‌های تستی موقت
```

---

## 🚀 نحوه نصب و اجرا

### ۱. دریافت پروژه و آماده‌سازی مجوز اجرا
در محیط لینوکس، مک یا Git Bash در ویندوز:

```bash
# اعطای مجوز اجرا به اسکریپت‌ها
chmod +x organizer.sh generate_test_files.sh
```

### ۲. تولید داده‌های تستی (اختیاری برای آزمایش سریع)
با اجرای اسکریپت کمکی، یک پوشه حاوی انواع فایل‌ها جهت تست ساخته می‌شود:

```bash
./generate_test_files.sh test_folder
```

### ۳. اجرای اسکریپت اصلی
اسکریپت را می‌توانید به صورت تعاملی یا با پاس دادن مستقیم مسیر اجرا کنید:

```bash
# حالت تعاملی (اسکریپت از شما مسیر را می‌پرسد)
./organizer.sh

# یا با ارسال مسیر به عنوان ورودی
./organizer.sh test_folder
```

---

## 🖥️ نمونه خروجی ترمینال

```text
==============================================
       Smart File Organizer (Bash)            
==============================================
[OK] Target directory found: test_folder
Scanning and categorizing files...
  ✔ [MOVED] README_NO_EXT ➔ Others/README_NO_EXT
  ✔ [MOVED] archive1.zip ➔ Archives/archive1.zip
  ✔ [MOVED] assignment.pdf ➔ Documents/assignment.pdf
  ✔ [MOVED] backup.tar.gz ➔ Archives/backup.tar.gz
  ✔ [MOVED] dataset.csv ➔ Documents/dataset.csv
  ✔ [MOVED] diagram.svg ➔ Images/diagram.svg
  ✔ [MOVED] linux_book.pdf ➔ Documents/linux_book.pdf
  ✔ [MOVED] notes.txt ➔ Documents/notes.txt
  ✔ [MOVED] package.rar ➔ Archives/package.rar
  ✔ [MOVED] photo with spaces.jpeg ➔ Images/photo with spaces.jpeg
  ✔ [MOVED] presentation.mkv ➔ Videos/presentation.mkv
  ✔ [MOVED] project_spec.docx ➔ Documents/project_spec.docx
  ✔ [MOVED] raw_data.bin ➔ Others/raw_data.bin
  ✔ [MOVED] sample1.jpg ➔ Images/sample1.jpg
  ✔ [MOVED] tutorial.mp4 ➔ Videos/tutorial.mp4
  ✔ [MOVED] wallpaper.png ➔ Images/wallpaper.png

===================================================
             Final Organization Report             
===================================================
  • Images (عکس)                 : 4
  • PDF Documents (پی‌دی‌اف)      : 2
  • ZIP Archives (فایل زیپ)      : 1
  • Other Archives (سایر فشرده)  : 2
  • Videos (ویدیوها)             : 2
  • Other Documents (سایر اسناد) : 3
  • Others & Unknown (ناشناخته)  : 2
---------------------------------------------------
  • Total Files Moved (مجموع)    : 16
===================================================
[INFO] Full activity log saved to: test_folder/log.txt
```


---

## 📝 نمونه محتوای فایل لاگ (`log.txt`)

```text
[2026-09-05 11:45:00] ================== SESSION START ==================
[2026-09-05 11:45:00] Target Directory: test_folder
[2026-09-05 11:45:00] [DIR CREATED] Created directory 'Documents'
[2026-09-05 11:45:00] [MOVED] 'assignment.pdf' -> 'Documents/assignment.pdf'
[2026-09-05 11:45:00] [DIR CREATED] Created directory 'Archives'
[2026-09-05 11:45:00] [MOVED] 'archive1.zip' -> 'Archives/archive1.zip'
[2026-09-05 11:45:00] [DUPLICATE RESOLVED] 'sample1.jpg' renamed to 'sample1_1.jpg' in 'Images/'
[2026-09-05 11:45:00] [MOVED] 'sample1.jpg' -> 'Images/sample1_1.jpg'
[2026-09-05 11:45:00] Total files moved: 15 (Images: 4, PDF: 2, ZIP: 1, Videos: 2, Other Docs: 3, Other Archives: 2, Unknown: 1)
[2026-09-05 11:45:00] ================== SESSION END ====================
```

---

## 🌿 تاریخچه منظم کامیت‌ها (Git Commits)

پروژه به صورت گام‌به‌گام با پیام‌های استاندارد و معنادار در Git کامیت شده است:

1. `Initial structure and directory validation`: ساخت اسکریپت پایه و اعتبارسنجی پوشه ورودی.
2. `Add smart category detection and directory creation`: تشخیص خودکار پسوندها و ایجاد خودکار پوشه‌ها.
3. `Implement duplicate file handling and safe renaming`: مدیریت تداخل فایل‌های همنام بدون رونویسی.
4. `Add operation logging and colored final summary report`: ثبت لاگ رویدادها در `log.txt` و چاپ گزارش نهایی رنگی.
5. `Add test files generator and comprehensive README documentation`: اسکریپت تست و مستندسازی کامل پروژه.


