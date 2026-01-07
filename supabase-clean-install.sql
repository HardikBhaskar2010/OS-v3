-- Clean Install - Drops existing tables and recreates everything
-- WARNING: This will DELETE ALL existing data in these tables!
-- Only run this if you want a fresh start

-- Drop existing tables (cascades will remove dependent objects including policies)
DROP TABLE IF EXISTS public.answers CASCADE;
DROP TABLE IF EXISTS public.mood_reactions CASCADE;
DROP TABLE IF EXISTS public.moods CASCADE;
DROP TABLE IF EXISTS public.photos CASCADE;
DROP TABLE IF EXISTS public.letters CASCADE;
DROP TABLE IF EXISTS public.questions CASCADE;

-- Now run the main schema from supabase-schema.sql
-- The file has been updated to handle realtime gracefully

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ======================
-- LETTERS TABLE
-- ======================
CREATE TABLE public.letters (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    from_user TEXT NOT NULL CHECK (from_user IN ('Cookie', 'Senorita')),
    to_user TEXT NOT NULL CHECK (to_user IN ('Cookie', 'Senorita')),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_letters_from_user ON public.letters(from_user);
CREATE INDEX idx_letters_to_user ON public.letters(to_user);
CREATE INDEX idx_letters_created_at ON public.letters(created_at DESC);

ALTER TABLE public.letters ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow all operations on letters" ON public.letters
    FOR ALL USING (true) WITH CHECK (true);

DO $$ 
BEGIN
  ALTER PUBLICATION supabase_realtime ADD TABLE public.letters;
EXCEPTION 
  WHEN duplicate_object THEN NULL;
END $$;

-- ======================
-- MOODS TABLE
-- ======================
CREATE TABLE public.moods (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_name TEXT NOT NULL CHECK (user_name IN ('Cookie', 'Senorita')),
    mood_emoji TEXT NOT NULL,
    mood_label TEXT NOT NULL,
    mood_color TEXT NOT NULL,
    note TEXT,
    photo_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_moods_user_name ON public.moods(user_name);
CREATE INDEX idx_moods_created_at ON public.moods(created_at DESC);

ALTER TABLE public.moods ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow all operations on moods" ON public.moods
    FOR ALL USING (true) WITH CHECK (true);

DO $$ 
BEGIN
  ALTER PUBLICATION supabase_realtime ADD TABLE public.moods;
EXCEPTION 
  WHEN duplicate_object THEN NULL;
END $$;

-- ======================
-- MOOD REACTIONS TABLE
-- ======================
CREATE TABLE public.mood_reactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    mood_id UUID NOT NULL REFERENCES public.moods(id) ON DELETE CASCADE,
    user_name TEXT NOT NULL CHECK (user_name IN ('Cookie', 'Senorita')),
    reaction_emoji TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_mood_reactions_mood_id ON public.mood_reactions(mood_id);
CREATE INDEX idx_mood_reactions_user_name ON public.mood_reactions(user_name);

ALTER TABLE public.mood_reactions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow all operations on mood_reactions" ON public.mood_reactions
    FOR ALL USING (true) WITH CHECK (true);

DO $$ 
BEGIN
  ALTER PUBLICATION supabase_realtime ADD TABLE public.mood_reactions;
EXCEPTION 
  WHEN duplicate_object THEN NULL;
END $$;

-- ======================
-- PHOTOS TABLE
-- ======================
CREATE TABLE public.photos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    image_url TEXT NOT NULL,
    caption TEXT,
    uploaded_by TEXT NOT NULL CHECK (uploaded_by IN ('Cookie', 'Senorita')),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_photos_uploaded_by ON public.photos(uploaded_by);
CREATE INDEX idx_photos_created_at ON public.photos(created_at DESC);

ALTER TABLE public.photos ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow all operations on photos" ON public.photos
    FOR ALL USING (true) WITH CHECK (true);

DO $$ 
BEGIN
  ALTER PUBLICATION supabase_realtime ADD TABLE public.photos;
EXCEPTION 
  WHEN duplicate_object THEN NULL;
END $$;

-- ======================
-- QUESTIONS TABLE
-- ======================
CREATE TABLE public.questions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    question_text TEXT NOT NULL,
    category TEXT NOT NULL,
    date DATE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_questions_date ON public.questions(date DESC);
CREATE INDEX idx_questions_category ON public.questions(category);

ALTER TABLE public.questions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow all operations on questions" ON public.questions
    FOR ALL USING (true) WITH CHECK (true);

-- ======================
-- ANSWERS TABLE
-- ======================
CREATE TABLE public.answers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    question_id UUID NOT NULL REFERENCES public.questions(id) ON DELETE CASCADE,
    user_name TEXT NOT NULL CHECK (user_name IN ('Cookie', 'Senorita')),
    answer_text TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_answers_question_id ON public.answers(question_id);
CREATE INDEX idx_answers_user_name ON public.answers(user_name);

ALTER TABLE public.answers ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow all operations on answers" ON public.answers
    FOR ALL USING (true) WITH CHECK (true);

DO $$ 
BEGIN
  ALTER PUBLICATION supabase_realtime ADD TABLE public.answers;
EXCEPTION 
  WHEN duplicate_object THEN NULL;
END $$;

-- ======================
-- SEED DATA - ROMANTIC QUESTIONS
-- ======================
INSERT INTO public.questions (question_text, category, date) VALUES
    ('What made you fall in love with me?', 'deep', '2025-01-08'),
    ('What is your favorite memory of us together?', 'memories', '2025-01-09'),
    ('Where do you see us in 5 years?', 'future', '2025-01-10'),
    ('What is one thing about me that always makes you smile?', 'appreciation', '2025-01-11'),
    ('If you could relive one day with me, which would it be?', 'memories', '2025-01-12'),
    ('What song reminds you of us?', 'fun', '2025-01-13'),
    ('What is your favorite thing we do together?', 'fun', '2025-01-14'),
    ('What do you love most about our relationship?', 'deep', '2025-01-15'),
    ('What is the most romantic thing I''ve ever done for you?', 'appreciation', '2025-01-16'),
    ('What dream destination should we visit together?', 'future', '2025-01-17'),
    ('What was your first impression of me?', 'memories', '2025-01-18'),
    ('What is something new you want to try with me?', 'fun', '2025-01-19'),
    ('How do I make you feel special?', 'appreciation', '2025-01-20'),
    ('What is your favorite quality about me?', 'deep', '2025-01-21'),
    ('What is a perfect day with me like for you?', 'fun', '2025-01-22'),
    ('What do you think our greatest adventure has been so far?', 'memories', '2025-01-23'),
    ('What makes you feel most loved by me?', 'appreciation', '2025-01-24'),
    ('What goals do we share for our future?', 'future', '2025-01-25'),
    ('What silly thing do I do that you secretly love?', 'fun', '2025-01-26'),
    ('What is the best gift I''ve ever given you?', 'appreciation', '2025-01-27'),
    ('What challenge have we overcome together that made us stronger?', 'deep', '2025-01-28'),
    ('What tradition would you like us to start?', 'future', '2025-01-29'),
    ('What nickname do you have for me and why?', 'fun', '2025-01-30'),
    ('What moment made you realize you loved me?', 'memories', '2025-01-31'),
    ('How do you want to celebrate our next anniversary?', 'future', '2025-02-01'),
    ('What is something I do that no one else knows about?', 'appreciation', '2025-02-02'),
    ('What do you appreciate most about how I support you?', 'deep', '2025-02-03'),
    ('What inside joke do we have that always makes us laugh?', 'fun', '2025-02-04'),
    ('What is your favorite photo of us and why?', 'memories', '2025-02-05'),
    ('What adventure should be on our bucket list?', 'future', '2025-02-06')
ON CONFLICT DO NOTHING;
