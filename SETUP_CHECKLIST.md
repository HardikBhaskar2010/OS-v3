# 🚀 Quick Setup Checklist for Love OS

## ✅ Completed by E1 Agent:
- [x] Created `/app/frontend/.env` with Supabase credentials
- [x] Created `/app/supabase-schema.sql` with complete database schema
- [x] Created `/app/PHOTO_UPLOAD_SETUP.md` with photo storage guide

---

## 📋 Manual Steps Required (Do These Now):

### 1️⃣ Setup Database Tables (5 minutes)

**If you're getting "already exists" errors, follow `/app/DATABASE_RESET_GUIDE.md` for a two-step cleanup and install process.**

**For a fresh install:**
1. Go to: **https://app.supabase.com/project/wurbydnkogvqhvtzttlp**
2. Click **SQL Editor** in left sidebar
3. Click **New Query**

**Option A - Fresh Start (Recommended):**
4. Open `/app/supabase-clean-install.sql` file
5. Copy ALL contents and paste into SQL Editor
6. Click **RUN** button (bottom right)
7. Wait for success message: "Success. No rows returned"

**Option B - If You Get Errors:**
- First run `/app/supabase-nuclear-cleanup.sql` to remove everything
- Then run `/app/supabase-clean-install.sql` to create fresh
- See `/app/DATABASE_RESET_GUIDE.md` for detailed steps

**What this creates:**
- ✅ Letters table (for love letters)
- ✅ Moods table (for mood sharing)
- ✅ Mood reactions table (for emoji reactions)
- ✅ Photos table (for gallery)
- ✅ Questions table (30 romantic questions included!)
- ✅ Answers table (for storing responses)
- ✅ All indexes and realtime enabled

---

### 2️⃣ Setup Photo Storage (10 minutes)

Follow the guide in `/app/PHOTO_UPLOAD_SETUP.md` or quick steps:

1. Go to: **https://app.supabase.com/project/wurbydnkogvqhvtzttlp**
2. Click **Storage** in left sidebar
3. Create bucket: `mood-photos` (Public ✓)
4. Create bucket: `couple-photos` (Public ✓)
5. For EACH bucket, add these 3 policies:

**Policy 1 - Public Reads:**
```sql
CREATE POLICY "Public read access"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'BUCKET_NAME_HERE');
```

**Policy 2 - Public Uploads:**
```sql
CREATE POLICY "Allow public uploads"
ON storage.objects FOR INSERT
TO public
WITH CHECK (bucket_id = 'BUCKET_NAME_HERE');
```

**Policy 3 - Public Deletes:**
```sql
CREATE POLICY "Allow public deletes"
ON storage.objects FOR DELETE
TO public
USING (bucket_id = 'BUCKET_NAME_HERE');
```

(Replace `BUCKET_NAME_HERE` with `mood-photos` or `couple-photos`)

---

## 🎉 Once Complete, You'll Have:

✅ **Functional Features:**
- 💌 Love Letters - Write and read letters to each other
- 💖 Mood Sharing - Share moods with emojis and photos
- 📸 Photo Gallery - Upload and view couple photos
- ❓ Daily Questions - Answer romantic questions together
- 🎨 Theme Customization - 6 color themes + dark/light mode
- ⚡ Real-time Updates - Instant syncing between Cookie & Senorita

✅ **Storage Platform:**
- Photos stored in Supabase Cloud Storage
- Accessible via direct URLs
- 1GB free storage (200-300 photos)

✅ **Access URLs:**
- Landing Page: `http://localhost:3000/`
- Cookie's Space: `http://localhost:3000/cookie`
- Senorita's Space: `http://localhost:3000/senorita`

---

## 🧪 Testing Instructions:

After setup, test these flows:

### Test 1: Love Letters
1. Go to Cookie's space → Letters
2. Write a letter to Senorita
3. Go to Senorita's space → Letters
4. See the letter appear instantly!

### Test 2: Mood Sharing
1. Go to Cookie's space → Moods
2. Select a mood emoji
3. Add a note
4. Click "Add Photo" and upload an image
5. Submit mood
6. Go to Senorita's space → Moods
7. See Cookie's mood with photo!

### Test 3: Photo Gallery
1. Go to Cookie's space → Gallery
2. Click "Upload Photo"
3. Select image and add caption
4. Upload
5. Photo appears in gallery grid

### Test 4: Daily Questions
1. Go to Questions page
2. See today's question
3. Answer it
4. Switch to partner's space
5. See their answer when they respond

---

## 📊 Database Setup Verification:

Run this in Supabase SQL Editor to verify tables exist:

```sql
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('letters', 'moods', 'mood_reactions', 'photos', 'questions', 'answers');
```

Should return 6 rows (all table names).

---

## 🔗 Important Links:

- **Supabase Dashboard:** https://app.supabase.com/project/wurbydnkogvqhvtzttlp
- **SQL Schema File:** `/app/supabase-schema.sql`
- **Photo Upload Guide:** `/app/PHOTO_UPLOAD_SETUP.md`
- **App README:** `/app/README.md`

---

## 💡 Quick Answers:

**Q: Where are photos stored?**
A: In Supabase Cloud Storage (not on your server). They're accessible via URLs like: `https://wurbydnkogvqhvtzttlp.supabase.co/storage/v1/object/public/mood-photos/...`

**Q: Do I need authentication?**
A: No! The app uses a simplified system with just "Cookie" and "Senorita" as user names.

**Q: How much does storage cost?**
A: Supabase free tier includes 1GB storage - enough for 200-300 high-quality photos!

**Q: Can I see real-time updates?**
A: Yes! All tables have Realtime enabled. When one person posts, the other sees it instantly.

---

**Estimated Total Setup Time:** 15-20 minutes

Let me know when you've completed the setup and I'll help test everything! 🚀
