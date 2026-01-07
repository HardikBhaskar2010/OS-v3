# 📸 Photo Upload Setup Guide for Love OS

## Overview
Love OS uses **Supabase Storage** for storing all photos. This is a cloud storage solution that's part of your Supabase project.

---

## 🎯 What is Supabase Storage?

Supabase Storage is a cloud-based file storage system (similar to AWS S3 or Google Cloud Storage) that's integrated with your Supabase database. Your photos are stored securely in the cloud and can be accessed via URLs.

**Benefits:**
- ☁️ Cloud-based storage (no server disk space used)
- 🔗 Direct URL access to photos
- 📱 Works perfectly with React apps
- 🔒 Built-in security policies
- 💰 Free tier: 1GB storage included

---

## 📁 Storage Buckets Needed

You need to create **2 storage buckets** in your Supabase project:

### 1. **mood-photos** bucket
- **Purpose:** Stores photos uploaded with mood updates
- **Access:** Public read, authenticated write
- **Max file size:** 5MB per photo

### 2. **couple-photos** bucket  
- **Purpose:** Stores photos AND videos for the gallery feature
- **Access:** Public read, authenticated write
- **Max file size:** 100MB per file (to support videos)
- **Supported formats:** Images (JPEG, PNG, WebP, HEIC) + Videos (MP4, MOV, WebM)

---

## 🚀 Step-by-Step Setup Instructions

### Step 1: Access Your Supabase Dashboard

1. Go to: **https://app.supabase.com/project/wurbydnkogvqhvtzttlp**
2. Login to your Supabase account
3. Click on **Storage** in the left sidebar

### Step 2: Create mood-photos Bucket

1. Click the **"New bucket"** button
2. Fill in the details:
   - **Name:** `mood-photos`
   - **Public bucket:** ✅ Toggle ON (so photos are publicly accessible)
   - **File size limit:** 5242880 (5MB)
   - **Allowed MIME types:** `image/jpeg,image/png,image/jpg,image/webp,image/heic`
3. Click **"Create bucket"**

### Step 3: Create couple-photos Bucket (Photos + Videos)

1. Click the **"New bucket"** button again
2. Fill in the details:
   - **Name:** `couple-photos`
   - **Public bucket:** ✅ Toggle ON
   - **File size limit:** `104857600` (100MB - to support videos)
   - **Allowed MIME types:** `image/jpeg,image/png,image/jpg,image/webp,image/heic,video/mp4,video/quicktime,video/webm`
3. Click **"Create bucket"**

**Note:** This bucket supports both photos AND videos so you can upload special moments as videos too!

### Step 4: Set Storage Policies

For each bucket, you need to add policies to allow uploads and reads:

#### For mood-photos bucket:

1. Click on **mood-photos** bucket
2. Go to **Policies** tab
3. Click **"New Policy"**

**Policy 1: Allow Public Reads**
```sql
CREATE POLICY "Public read access"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'mood-photos');
```

**Policy 2: Allow Public Uploads** (since we have no auth)
```sql
CREATE POLICY "Allow public uploads"
ON storage.objects FOR INSERT
TO public
WITH CHECK (bucket_id = 'mood-photos');
```

**Policy 3: Allow Public Deletes**
```sql
CREATE POLICY "Allow public deletes"
ON storage.objects FOR DELETE
TO public
USING (bucket_id = 'mood-photos');
```

#### For couple-photos bucket:

Repeat the same 3 policies, replacing `'mood-photos'` with `'couple-photos'`

---

## ✅ Verification

After setup, verify everything works:

1. **Check Buckets:**
   - Go to Storage → You should see both buckets listed
   - Each should show "Public" badge

2. **Test Upload (Optional):**
   - Click on mood-photos bucket
   - Try uploading a test image manually
   - You should get a URL like: `https://wurbydnkogvqhvtzttlp.supabase.co/storage/v1/object/public/mood-photos/test.jpg`

---

## 🎨 How Photo Upload Works in Love OS

### Mood Photos (mood-photos bucket):
1. User selects a mood and clicks "Add Photo"
2. File picker opens → User selects photo from device
3. Photo uploads to Supabase Storage → mood-photos bucket
4. URL is saved in database → moods.photo_url field
5. Photo displays instantly in mood cards

### Gallery Photos (couple-photos bucket):
1. User clicks "Upload Photo" in Gallery page
2. File picker opens → User selects photo
3. Photo uploads to Supabase Storage → couple-photos bucket
4. Caption and URL saved in database → photos table
5. Photo appears in gallery grid

---

## 📊 Storage Limits

**Free Tier (Included):**
- 1GB storage
- Unlimited bandwidth for first 1GB
- 2GB bandwidth after that

**Estimated Capacity:**
- ~200-300 high-quality photos (5MB each)
- ~100-150 ultra-high-quality photos (10MB each)
- ~10-20 video clips (100MB each) in couple-photos bucket
- Perfect for a couple's app with photos and special video moments!

---

## 🔧 Frontend Code (Already Implemented)

The upload functionality is already coded in your React app:

**Upload Function:**
```typescript
// In frontend/src/lib/supabase.ts or component files
const uploadPhoto = async (file: File, bucket: string) => {
  const fileExt = file.name.split('.').pop();
  const fileName = `${Math.random()}.${fileExt}`;
  const filePath = `${fileName}`;

  const { data, error } = await supabase.storage
    .from(bucket)
    .upload(filePath, file);

  if (error) throw error;

  // Get public URL
  const { data: urlData } = supabase.storage
    .from(bucket)
    .getPublicUrl(filePath);

  return urlData.publicUrl;
};
```

---

## 🎯 Summary

**Storage Platform:** Supabase Storage (Cloud-based)

**Setup Required:**
1. ✅ Create `mood-photos` bucket
2. ✅ Create `couple-photos` bucket  
3. ✅ Add storage policies for public access
4. ✅ Test upload functionality

**Where Photos Live:**
- **NOT** on your server/computer
- **IN THE CLOUD** on Supabase servers
- Accessed via URLs like: `https://wurbydnkogvqhvtzttlp.supabase.co/storage/v1/object/public/...`

---

## 🆘 Troubleshooting

**Issue:** Upload button doesn't work
- **Solution:** Make sure buckets are created and policies are set

**Issue:** "Bucket not found" error
- **Solution:** Double-check bucket names are exactly `mood-photos` and `couple-photos`

**Issue:** "Access denied" error
- **Solution:** Verify storage policies allow public insert/select/delete

**Issue:** Photos not displaying
- **Solution:** Make sure buckets are marked as "Public"

---

## 📞 Need Help?

If you encounter any issues:
1. Check Supabase Dashboard → Storage → Logs
2. Check browser console for error messages
3. Verify bucket names match exactly in code and dashboard

Your Supabase project: https://app.supabase.com/project/wurbydnkogvqhvtzttlp
