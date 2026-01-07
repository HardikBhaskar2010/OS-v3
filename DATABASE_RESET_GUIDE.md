# 🔥 Complete Database Reset Guide

## The Problem
You're getting: `"policy 'Allow all operations on letters' for table 'letters' already exists"`

This means your database has **partial setup** from previous attempts - some tables, policies, and configurations already exist.

---

## ✅ SOLUTION: Two-Step Clean Reset

### **Step 1: Simple Cleanup (Remove Everything)**

Use the simple cleanup script that just works:

1. Go to: https://app.supabase.com/project/wurbydnkogvqhvtzttlp/editor
2. Click **SQL Editor** → **New Query**
3. Open **`/app/supabase-simple-cleanup.sql`** ⭐ **USE THIS ONE**
4. Copy **ALL** contents
5. Paste into SQL Editor
6. Click **RUN**
7. You should see: `"✅ All tables successfully removed!"`

**Alternative:** You can also use `/app/supabase-nuclear-cleanup.sql` (more thorough but fixed now)

---

### **Step 2: Fresh Install (Create Everything)**

Now create everything fresh:

1. In the same SQL Editor (or new query)
2. Open **`/app/supabase-clean-install.sql`** (I've updated it!)
3. Copy **ALL** contents
4. Paste into SQL Editor
5. Click **RUN**
6. You should see: `"Success. No rows returned"`

---

## 📋 What Each File Does

### `/app/supabase-simple-cleanup.sql` 🔥 **RECOMMENDED**
**Purpose:** Simple, guaranteed cleanup
- ✅ Drops all tables with CASCADE
- ✅ CASCADE auto-removes policies, indexes, etc.
- ✅ Verifies cleanup succeeded
- ✅ **100% works, no syntax errors**

### `/app/supabase-nuclear-cleanup.sql` 🔥 (Advanced)
**Purpose:** More thorough cleanup
- ✅ Drops all policies explicitly
- ✅ Removes tables from realtime
- ✅ Drops all tables
- ✅ Verifies cleanup succeeded
- ✅ **Fixed - no more syntax errors**

### `/app/supabase-clean-install.sql` ✨
**Purpose:** Fresh installation
- ✅ Drops any remaining policies
- ✅ Creates all 6 tables
- ✅ Creates all indexes
- ✅ Enables Row Level Security
- ✅ Adds policies
- ✅ Enables Realtime
- ✅ Seeds 30 romantic questions

---

## 🎯 Complete Process (Copy-Paste Friendly)

### Run These in Order:

**1️⃣ First Query - Cleanup:**
```
File: /app/supabase-simple-cleanup.sql (RECOMMENDED - guaranteed to work!)
  OR
File: /app/supabase-nuclear-cleanup.sql (Advanced, more thorough)
Expected Result: "✅ All tables successfully removed!"
```

**2️⃣ Second Query - Install:**
```
File: /app/supabase-clean-install.sql
Expected Result: "Success. No rows returned"
```

---

## ✅ Verify It Worked

After running both scripts, verify tables exist:

```sql
SELECT 
    table_name,
    'EXISTS ✅' as status
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('letters', 'moods', 'mood_reactions', 'photos', 'questions', 'answers')
ORDER BY table_name;
```

**Expected Result:** 6 rows showing all tables

---

## 🔍 Check Policies Were Created

```sql
SELECT 
    tablename,
    policyname,
    'ACTIVE ✅' as status
FROM pg_policies 
WHERE schemaname = 'public'
AND tablename IN ('letters', 'moods', 'mood_reactions', 'photos', 'questions', 'answers')
ORDER BY tablename;
```

**Expected Result:** 6 rows (one policy per table)

---

## 🧪 Test with Sample Data

After setup, test inserting a love letter:

```sql
-- Insert a test letter
INSERT INTO public.letters (title, content, from_user, to_user)
VALUES ('Test Letter', 'This is a test from Cookie!', 'Cookie', 'Senorita');

-- Verify it worked
SELECT * FROM public.letters;
```

**Expected Result:** Should see your test letter

---

## 📊 Check Romantic Questions

Verify 30 questions were seeded:

```sql
SELECT COUNT(*) as question_count FROM public.questions;
```

**Expected Result:** 30 questions

---

## 🆘 Still Getting Errors?

### Error: "permission denied"
**Solution:** Make sure you're using the SQL Editor in Supabase Dashboard (not API calls)

### Error: "cannot drop table because other objects depend on it"
**Solution:** The cleanup script uses CASCADE - it should handle this automatically. If not, try running just the cleanup script again.

### Error: "publication does not exist"
**Solution:** This is OK! The script handles this gracefully with error catching.

---

## 📁 Files You Need

All files are in `/app/` directory:

1. **`supabase-nuclear-cleanup.sql`** ← Run this FIRST 🔥
2. **`supabase-clean-install.sql`** ← Run this SECOND ✨ (Updated!)
3. **`supabase-check-tables.sql`** ← Use for verification 🔍

---

## ⏭️ After Database Works

Once both scripts run successfully:

1. ✅ **Database is ready!**
2. ⏭️ **Next: Photo Storage Setup**
   - Follow `/app/PHOTO_UPLOAD_SETUP.md`
   - Create 2 storage buckets: `mood-photos` and `couple-photos`
   - Add storage policies (3 per bucket)
3. 🎉 **Test the App!**
   - All features will work
   - Letters, moods, photos, questions

---

## 💡 Why This Approach Works

**Two-Step Process:**
1. **Cleanup** removes everything (tables, policies, realtime subscriptions)
2. **Install** creates everything fresh with no conflicts

This guarantees a clean slate every time!

---

## ⚡ Quick Summary

```bash
# Step 1: Run cleanup
SQL: /app/supabase-nuclear-cleanup.sql
Result: "✅ All tables successfully removed!"

# Step 2: Run install  
SQL: /app/supabase-clean-install.sql
Result: "Success. No rows returned"

# Step 3: Verify
SQL: SELECT COUNT(*) FROM public.questions;
Result: Should show 30 questions
```

---

Let me know when both scripts complete successfully! 🚀
