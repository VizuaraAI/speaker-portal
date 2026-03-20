-- Run this in Supabase SQL Editor (supabase.com/dashboard → SQL Editor → New Query)

-- 1. Create the speakers table
CREATE TABLE speakers (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  created_at TIMESTAMPTZ DEFAULT now(),

  -- Personal info
  full_name TEXT NOT NULL,
  email TEXT NOT NULL,
  linkedin_url TEXT,
  company TEXT NOT NULL,
  role TEXT NOT NULL,

  -- Expertise
  expertise_areas TEXT[] NOT NULL DEFAULT '{}',
  suggested_topic TEXT NOT NULL,
  topic_description TEXT,

  -- Availability
  preferred_dates TEXT,
  session_format TEXT DEFAULT '60-90 min live talk',

  -- Additional
  bio TEXT,
  website_url TEXT,
  how_heard TEXT,
  additional_notes TEXT,

  -- Admin fields
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'reviewing', 'selected', 'declined', 'confirmed')),
  admin_notes TEXT
);

-- 2. Enable Row Level Security
ALTER TABLE speakers ENABLE ROW LEVEL SECURITY;

-- 3. Allow anyone to INSERT (public form submissions)
CREATE POLICY "Allow public inserts" ON speakers
  FOR INSERT TO anon
  WITH CHECK (true);

-- 4. Allow authenticated users to read all (admin dashboard)
-- For simplicity, also allow anon to read (we'll protect admin page with a simple password in the UI)
CREATE POLICY "Allow public reads" ON speakers
  FOR SELECT TO anon
  USING (true);

-- 5. Allow updates (for admin status changes)
CREATE POLICY "Allow public updates" ON speakers
  FOR UPDATE TO anon
  USING (true)
  WITH CHECK (true);

-- 6. Create an index on status for filtering
CREATE INDEX idx_speakers_status ON speakers(status);
CREATE INDEX idx_speakers_created ON speakers(created_at DESC);
