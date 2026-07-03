-- Run this whole file once in your Supabase project's SQL editor
-- (Dashboard -> SQL Editor -> New query -> paste -> Run).

create extension if not exists "pgcrypto";

-- ── Projects (the portfolio grid) ──────────────────────────────────────────
create table if not exists public.projects (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  client text not null,
  category text not null check (
    category in ('illustration','logo','packaging','visualIdentity','visualDesign')
  ),
  image_url text,
  sort_order int not null default 0,
  created_at timestamptz not null default now()
);

alter table public.projects enable row level security;

drop policy if exists "Public can read projects" on public.projects;
create policy "Public can read projects"
  on public.projects for select
  to anon, authenticated
  using (true);

drop policy if exists "Authenticated can insert projects" on public.projects;
create policy "Authenticated can insert projects"
  on public.projects for insert
  to authenticated
  with check (true);

drop policy if exists "Authenticated can update projects" on public.projects;
create policy "Authenticated can update projects"
  on public.projects for update
  to authenticated
  using (true);

drop policy if exists "Authenticated can delete projects" on public.projects;
create policy "Authenticated can delete projects"
  on public.projects for delete
  to authenticated
  using (true);

-- ── Messages (contact form submissions) ────────────────────────────────────
create table if not exists public.messages (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  email text not null,
  message text not null,
  is_read boolean not null default false,
  created_at timestamptz not null default now()
);

alter table public.messages enable row level security;

drop policy if exists "Anyone can send a message" on public.messages;
create policy "Anyone can send a message"
  on public.messages for insert
  to anon, authenticated
  with check (true);

drop policy if exists "Authenticated can read messages" on public.messages;
create policy "Authenticated can read messages"
  on public.messages for select
  to authenticated
  using (true);

drop policy if exists "Authenticated can update messages" on public.messages;
create policy "Authenticated can update messages"
  on public.messages for update
  to authenticated
  using (true);

drop policy if exists "Authenticated can delete messages" on public.messages;
create policy "Authenticated can delete messages"
  on public.messages for delete
  to authenticated
  using (true);

-- ── Seed data (optional) ────────────────────────────────────────────────────
-- Loads the same projects that used to be hard-coded in the app, so the
-- portfolio grid isn't empty the first time you connect. Skip this block if
-- you'd rather add projects yourself from the /admin dashboard.
insert into public.projects (title, client, category, image_url, sort_order) values
  ('Stay Glowing in the Dark', 'Illustration art', 'illustration', null, 0),
  ('Media Whale', 'Logo design', 'logo', null, 1),
  ('Bitza Bil Kosour', 'Packaging illustration', 'packaging', null, 2),
  ('Marionette Notebook', 'Visual identity', 'visualIdentity', null, 3),
  ('Qesma W Ta3zeeb', 'Packing', 'packaging', null, 4),
  ('Sultan Al Asal Promo', 'Visual identity', 'visualIdentity', null, 5),
  ('Soweqa', 'Visual', 'visualDesign', null, 6);
-- image_url is left null here because the original artwork files live in
-- assets/images locally, not in Supabase Storage. Upload real images from
-- the /admin dashboard (which uploads to Storage and fills this in for
-- you), or paste a public URL manually via
-- `update public.projects set image_url = '...' where title = '...';`.

-- ── Storage (project artwork uploads) ───────────────────────────────────────
-- Before running this section: go to Storage in the Supabase dashboard and
-- create a bucket named "portfolio", with the "Public bucket" toggle ON.
-- That makes uploaded files viewable by anyone with the link. These
-- policies then control who's allowed to upload/replace/delete files in it
-- (only signed-in admins) versus who can just view them (everyone).
drop policy if exists "Public can view portfolio files" on storage.objects;
create policy "Public can view portfolio files"
  on storage.objects for select
  to anon, authenticated
  using (bucket_id = 'portfolio');

drop policy if exists "Authenticated can upload portfolio files" on storage.objects;
create policy "Authenticated can upload portfolio files"
  on storage.objects for insert
  to authenticated
  with check (bucket_id = 'portfolio');

drop policy if exists "Authenticated can update portfolio files" on storage.objects;
create policy "Authenticated can update portfolio files"
  on storage.objects for update
  to authenticated
  using (bucket_id = 'portfolio');

drop policy if exists "Authenticated can delete portfolio files" on storage.objects;
create policy "Authenticated can delete portfolio files"
  on storage.objects for delete
  to authenticated
  using (bucket_id = 'portfolio');
