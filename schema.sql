-- Daulatpur Champions League (DCL) — additive Supabase schema / repair script
-- Designed for the existing DCL tables. It does NOT drop or rename existing tables or data.
-- Run in Supabase SQL Editor only if you need to align the database with this website.

create extension if not exists pgcrypto;

create table if not exists public.dcl_admins (
  user_id uuid primary key references auth.users(id) on delete cascade,
  email text
);

create table if not exists public.dcl_teams (
  id uuid primary key default gen_random_uuid(),
  name_en text not null,
  name_bn text,
  logo_url text,
  captain_name text,
  is_published boolean not null default true,
  sort_order integer not null default 1,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.dcl_players (
  id uuid primary key default gen_random_uuid(),
  team_id uuid references public.dcl_teams(id) on delete set null,
  player_name text not null,
  jersey_number integer,
  position text,
  appearances integer not null default 0,
  assists integer not null default 0,
  man_of_match integer not null default 0,
  bio text,
  is_published boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.dcl_matches (
  id uuid primary key default gen_random_uuid(),
  round_name text,
  match_number integer unique,
  home_team_id uuid references public.dcl_teams(id) on delete set null,
  away_team_id uuid references public.dcl_teams(id) on delete set null,
  home_score integer not null default 0,
  away_score integer not null default 0,
  status text not null default 'upcoming',
  kickoff_at timestamptz,
  match_minute integer,
  winner_team_id uuid references public.dcl_teams(id) on delete set null,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.dcl_match_events (
  id uuid primary key default gen_random_uuid(),
  match_id uuid references public.dcl_matches(id) on delete cascade,
  team_id uuid references public.dcl_teams(id) on delete set null,
  player_id uuid references public.dcl_players(id) on delete set null,
  event_type text not null,
  event_minute integer,
  details text,
  created_at timestamptz not null default now()
);

create table if not exists public.dcl_team_applications (
  id uuid primary key default gen_random_uuid(),
  team_name text not null,
  contact_name text,
  phone text,
  status text not null default 'pending',
  created_at timestamptz not null default now()
);

create table if not exists public.dcl_awards (
  id uuid primary key default gen_random_uuid(),
  award_name text not null,
  recipient_name text,
  team_id uuid references public.dcl_teams(id) on delete set null,
  player_id uuid references public.dcl_players(id) on delete set null,
  description text,
  created_at timestamptz not null default now()
);

create table if not exists public.dcl_news (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  body text,
  image_url text,
  is_published boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.dcl_gallery (
  id uuid primary key default gen_random_uuid(),
  title text,
  media_url text not null,
  media_type text not null default 'image',
  is_published boolean not null default false,
  created_at timestamptz not null default now()
);

-- Add fields used by the website when an older DCL table already exists.
alter table public.dcl_admins add column if not exists email text;
alter table public.dcl_teams add column if not exists name_en text;
alter table public.dcl_teams add column if not exists name_bn text;
alter table public.dcl_teams add column if not exists logo_url text;
alter table public.dcl_teams add column if not exists captain_name text;
alter table public.dcl_teams add column if not exists is_published boolean not null default true;
alter table public.dcl_teams add column if not exists sort_order integer not null default 1;
alter table public.dcl_teams add column if not exists created_at timestamptz not null default now();
alter table public.dcl_teams add column if not exists updated_at timestamptz not null default now();

alter table public.dcl_players add column if not exists team_id uuid references public.dcl_teams(id) on delete set null;
alter table public.dcl_players add column if not exists player_name text;
alter table public.dcl_players add column if not exists jersey_number integer;
alter table public.dcl_players add column if not exists position text;
alter table public.dcl_players add column if not exists appearances integer not null default 0;
alter table public.dcl_players add column if not exists assists integer not null default 0;
alter table public.dcl_players add column if not exists man_of_match integer not null default 0;
alter table public.dcl_players add column if not exists bio text;
alter table public.dcl_players add column if not exists is_published boolean not null default true;
alter table public.dcl_players add column if not exists created_at timestamptz not null default now();

alter table public.dcl_matches add column if not exists round_name text;
alter table public.dcl_matches add column if not exists match_number integer;
alter table public.dcl_matches add column if not exists home_team_id uuid references public.dcl_teams(id) on delete set null;
alter table public.dcl_matches add column if not exists away_team_id uuid references public.dcl_teams(id) on delete set null;
alter table public.dcl_matches add column if not exists home_score integer not null default 0;
alter table public.dcl_matches add column if not exists away_score integer not null default 0;
alter table public.dcl_matches add column if not exists status text not null default 'upcoming';
alter table public.dcl_matches add column if not exists kickoff_at timestamptz;
alter table public.dcl_matches add column if not exists match_minute integer;
alter table public.dcl_matches add column if not exists winner_team_id uuid references public.dcl_teams(id) on delete set null;
alter table public.dcl_matches add column if not exists notes text;
alter table public.dcl_matches add column if not exists created_at timestamptz not null default now();
alter table public.dcl_matches add column if not exists updated_at timestamptz not null default now();

alter table public.dcl_match_events add column if not exists match_id uuid references public.dcl_matches(id) on delete cascade;
alter table public.dcl_match_events add column if not exists team_id uuid references public.dcl_teams(id) on delete set null;
alter table public.dcl_match_events add column if not exists player_id uuid references public.dcl_players(id) on delete set null;
alter table public.dcl_match_events add column if not exists event_type text;
alter table public.dcl_match_events add column if not exists event_minute integer;
alter table public.dcl_match_events add column if not exists details text;
alter table public.dcl_match_events add column if not exists created_at timestamptz not null default now();

alter table public.dcl_team_applications add column if not exists team_name text;
alter table public.dcl_team_applications add column if not exists contact_name text;
alter table public.dcl_team_applications add column if not exists phone text;
alter table public.dcl_team_applications add column if not exists status text not null default 'pending';
alter table public.dcl_team_applications add column if not exists created_at timestamptz not null default now();

alter table public.dcl_awards add column if not exists award_name text;
alter table public.dcl_awards add column if not exists recipient_name text;
alter table public.dcl_awards add column if not exists team_id uuid references public.dcl_teams(id) on delete set null;
alter table public.dcl_awards add column if not exists player_id uuid references public.dcl_players(id) on delete set null;
alter table public.dcl_awards add column if not exists description text;
alter table public.dcl_awards add column if not exists created_at timestamptz not null default now();

alter table public.dcl_news add column if not exists title text;
alter table public.dcl_news add column if not exists body text;
alter table public.dcl_news add column if not exists image_url text;
alter table public.dcl_news add column if not exists is_published boolean not null default false;
alter table public.dcl_news add column if not exists created_at timestamptz not null default now();

alter table public.dcl_gallery add column if not exists title text;
alter table public.dcl_gallery add column if not exists media_url text;
alter table public.dcl_gallery add column if not exists media_type text not null default 'image';
alter table public.dcl_gallery add column if not exists is_published boolean not null default false;
alter table public.dcl_gallery add column if not exists created_at timestamptz not null default now();

-- Admin check helper used by DCL admin RLS policies.
create or replace function public.dcl_is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.dcl_admins
    where user_id = auth.uid()
  );
$$;

alter table public.dcl_admins enable row level security;
alter table public.dcl_teams enable row level security;
alter table public.dcl_players enable row level security;
alter table public.dcl_matches enable row level security;
alter table public.dcl_match_events enable row level security;
alter table public.dcl_team_applications enable row level security;
alter table public.dcl_awards enable row level security;
alter table public.dcl_news enable row level security;
alter table public.dcl_gallery enable row level security;

-- Policies are recreated with these stable DCL names.
drop policy if exists "dcl_admin_read_self" on public.dcl_admins;
create policy "dcl_admin_read_self" on public.dcl_admins
for select to authenticated using (user_id = auth.uid());

drop policy if exists "dcl_public_read_teams" on public.dcl_teams;
create policy "dcl_public_read_teams" on public.dcl_teams
for select to anon, authenticated using (is_published = true or public.dcl_is_admin());
drop policy if exists "dcl_admin_manage_teams" on public.dcl_teams;
create policy "dcl_admin_manage_teams" on public.dcl_teams
for all to authenticated using (public.dcl_is_admin()) with check (public.dcl_is_admin());

drop policy if exists "dcl_public_read_players" on public.dcl_players;
create policy "dcl_public_read_players" on public.dcl_players
for select to anon, authenticated using (is_published = true or public.dcl_is_admin());
drop policy if exists "dcl_admin_manage_players" on public.dcl_players;
create policy "dcl_admin_manage_players" on public.dcl_players
for all to authenticated using (public.dcl_is_admin()) with check (public.dcl_is_admin());

drop policy if exists "dcl_public_read_matches" on public.dcl_matches;
create policy "dcl_public_read_matches" on public.dcl_matches
for select to anon, authenticated using (true);
drop policy if exists "dcl_admin_manage_matches" on public.dcl_matches;
create policy "dcl_admin_manage_matches" on public.dcl_matches
for all to authenticated using (public.dcl_is_admin()) with check (public.dcl_is_admin());

drop policy if exists "dcl_public_read_match_events" on public.dcl_match_events;
create policy "dcl_public_read_match_events" on public.dcl_match_events
for select to anon, authenticated using (true);
drop policy if exists "dcl_admin_manage_match_events" on public.dcl_match_events;
create policy "dcl_admin_manage_match_events" on public.dcl_match_events
for all to authenticated using (public.dcl_is_admin()) with check (public.dcl_is_admin());

drop policy if exists "dcl_public_submit_applications" on public.dcl_team_applications;
create policy "dcl_public_submit_applications" on public.dcl_team_applications
for insert to anon, authenticated with check (status = 'pending');
drop policy if exists "dcl_admin_read_applications" on public.dcl_team_applications;
create policy "dcl_admin_read_applications" on public.dcl_team_applications
for select to authenticated using (public.dcl_is_admin());
drop policy if exists "dcl_admin_update_applications" on public.dcl_team_applications;
create policy "dcl_admin_update_applications" on public.dcl_team_applications
for update to authenticated using (public.dcl_is_admin()) with check (public.dcl_is_admin());

drop policy if exists "dcl_public_read_awards" on public.dcl_awards;
create policy "dcl_public_read_awards" on public.dcl_awards
for select to anon, authenticated using (true);
drop policy if exists "dcl_admin_manage_awards" on public.dcl_awards;
create policy "dcl_admin_manage_awards" on public.dcl_awards
for all to authenticated using (public.dcl_is_admin()) with check (public.dcl_is_admin());

drop policy if exists "dcl_public_read_news" on public.dcl_news;
create policy "dcl_public_read_news" on public.dcl_news
for select to anon, authenticated using (is_published = true or public.dcl_is_admin());
drop policy if exists "dcl_admin_manage_news" on public.dcl_news;
create policy "dcl_admin_manage_news" on public.dcl_news
for all to authenticated using (public.dcl_is_admin()) with check (public.dcl_is_admin());

drop policy if exists "dcl_public_read_gallery" on public.dcl_gallery;
create policy "dcl_public_read_gallery" on public.dcl_gallery
for select to anon, authenticated using (is_published = true or public.dcl_is_admin());
drop policy if exists "dcl_admin_manage_gallery" on public.dcl_gallery;
create policy "dcl_admin_manage_gallery" on public.dcl_gallery
for all to authenticated using (public.dcl_is_admin()) with check (public.dcl_is_admin());

-- Ensure the browser roles can reach the public tables via the Supabase REST API.
grant usage on schema public to anon, authenticated;
grant select on public.dcl_teams, public.dcl_players, public.dcl_matches,
  public.dcl_match_events, public.dcl_awards, public.dcl_news, public.dcl_gallery
  to anon, authenticated;
grant insert on public.dcl_team_applications to anon, authenticated;
grant select, insert, update, delete on public.dcl_teams, public.dcl_players,
  public.dcl_matches, public.dcl_match_events, public.dcl_awards, public.dcl_news,
  public.dcl_gallery, public.dcl_team_applications to authenticated;
