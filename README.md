# Smart File Organizer

پروژه پایانی درس Linux Essentials — یک اسکریپت Bash برای سازماندهی خودکار فایل‌ها بر اساس نوع و پسوند.

## معرفی

این اسکریپت فایل‌های داخل یک پوشه رو بررسی می‌کنه، بر اساس پسوندشون دسته‌بندی می‌کنه (عکس، سند، ویدیو، آرشیو و بقیه)، و هرکدوم رو به پوشه‌ی مربوطه منتقل می‌کنه. اگه پوشه‌های مقصد وجود نداشته باشن به صورت خودکار ساخته می‌شن، و کل عملیات توی یک فایل لاگ ثبت می‌شه.

فقط از دستورات استاندارد لینوکس استفاده شده (`mv`, `mkdir`, `read`, `case`, `date`, ...) و هیچ ابزار جانبی‌ای لازم نیست.

## دسته‌بندی فایل‌ها

| دسته | پسوندها |
|---|---|
| Images | jpg, jpeg, png, gif, bmp, webp, svg, tiff, ico |
| Documents | pdf, doc, docx, txt, xls, xlsx, ppt, pptx, odt, csv, md |
| Videos | mp4, mkv, avi, mov, wmv, flv, webm, m4v |
| Archives | zip, rar, tar, gz, 7z, bz2, xz |
| Others | هر پسوند دیگه، یا فایل‌های بدون پسوند |

## ویژگی‌ها

- دریافت مسیر پوشه به صورت تعاملی (`read -p`) یا مستقیم به عنوان آرگومان
- بررسی وجود پوشه و دسترسی خواندن/نوشتن قبل از شروع
- ساخت خودکار پوشه‌های مقصد در صورت نیاز
- مدیریت نام‌های تکراری: اگه فایلی با همون اسم توی مقصد وجود داشته باشه، به جای رونویسی، اسم جدید با شماره ساخته می‌شه (`file_1.ext`, `file_2.ext`, ...)
- ثبت کامل عملیات (ساخت پوشه، جابجایی، تغییر نام) با تاریخ و ساعت در `log.txt`
- گزارش نهایی در ترمینال با تعداد فایل‌های جابجا شده به تفکیک هر دسته
- فایل‌های `.sh` و لاگ‌ها از فرآیند جابجایی مستثنا هستن، و پوشه‌ها (شامل پوشه‌های دسته‌بندی که خودش ساخته) دست‌نخورده می‌مونن — یعنی اجرای دوباره‌ی اسکریپت روی یک پوشه‌ی مرتب‌شده خطایی ایجاد نمی‌کنه

## محدودیت‌ها

اسکریپت فقط فایل‌های سطح اول پوشه رو پردازش می‌کنه و وارد زیرپوشه‌ها نمی‌شه. این عمدیه، تا اگه پوشه‌ی هدف از قبل زیرپوشه‌های دیگه‌ای داشته باشه، ساختارشون به‌هم نریزه.

## نصب و اجرا

```bash
chmod +x organizer.sh generate_test_files.sh
```

اجرای تعاملی:
```bash
./organizer.sh
```

یا با دادن مسیر مستقیم:
```bash
./organizer.sh /path/to/folder
```

برای تست سریع، `generate_test_files.sh` یک پوشه‌ی نمونه با انواع فایل می‌سازه:
```bash
./generate_test_files.sh test_folder
./organizer.sh test_folder
```

## نمونه خروجی

```
==============================================
       Smart File Organizer (Bash)
==============================================
[OK] Target directory found: test_folder
Scanning and categorizing files...
  ✔ [MOVED] assignment.pdf ➔ Documents/assignment.pdf
  ✔ [MOVED] archive1.zip ➔ Archives/archive1.zip
  ✔ [MOVED] sample1.jpg ➔ Images/sample1.jpg
  ✔ [MOVED] tutorial.mp4 ➔ Videos/tutorial.mp4
  ...

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

## نمونه فایل لاگ

```
[2026-09-05 11:45:00] ================== SESSION START ==================
[2026-09-05 11:45:00] Target Directory: test_folder
[2026-09-05 11:45:00] [DIR CREATED] Created directory 'Documents'
[2026-09-05 11:45:00] [MOVED] 'assignment.pdf' -> 'Documents/assignment.pdf'
[2026-09-05 11:45:00] [DIR CREATED] Created directory 'Archives'
[2026-09-05 11:45:00] [MOVED] 'archive1.zip' -> 'Archives/archive1.zip'
[2026-09-05 11:45:00] [DUPLICATE RESOLVED] 'sample1.jpg' renamed to 'sample1_1.jpg' in 'Images/'
[2026-09-05 11:45:00] [MOVED] 'sample1.jpg' -> 'Images/sample1_1.jpg'
...
[2026-09-05 11:45:00] Total files moved: 16 (Images: 4, PDF: 2, ZIP: 1, Videos: 2, Other Docs: 3, Other Archives: 2, Unknown: 2)
[2026-09-05 11:45:00] ================== SESSION END ====================
```

## ساختار پروژه

```
.
├── organizer.sh             # اسکریپت اصلی
├── generate_test_files.sh   # ساخت فایل‌های نمونه برای تست
├── README.md
└── .gitignore
```
