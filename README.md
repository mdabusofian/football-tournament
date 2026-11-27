# Daulatpur Champions League (DCL) — Website

This repository contains the public website, admin dashboard, team application page, and Supabase setup for Daulatpur Champions League 2026–27.

## Files
- `index.html` — public bilingual website (English default).
- `admin.html` — administrator dashboard.
- `registration.html` — public team application form.
- `supabase-config.js` — Supabase project URL and browser-safe publishable/anon key.
- `schema.sql` — additive DCL schema alignment and RLS policies.
- `vercel.json` — Vercel rewrite for `/admin`.

## Supabase configuration
`supabase-config.js` must define:
```js
window.DCL_SUPABASE_URL = "https://YOUR_PROJECT.supabase.co";
window.DCL_SUPABASE_ANON_KEY = "YOUR_PUBLISHABLE_OR_ANON_KEY";
```
Only use the browser-safe publishable/anon key. Never put a `service_role` or secret key in this file.

## Existing DCL database
The website uses the `dcl_` tables:
`dcl_admins`, `dcl_teams`, `dcl_players`, `dcl_matches`, `dcl_match_events`, `dcl_team_applications`, `dcl_awards`, `dcl_news`, and `dcl_gallery`.

The `schema.sql` file is an additive alignment script. It does not drop or rename tables. Before running it on a live database, review it against the current table definitions and take a database backup. Do not run the old generic `teams` / `matches` schema from an earlier project version.

## Admin access
1. Create the admin user in Supabase Authentication.
2. Add that user's UUID to `public.dcl_admins` with the correct email:
```sql
insert into public.dcl_admins (user_id, email)
select id, email
from auth.users
where email = 'mdabusofian842@gmail.com'
on conflict (user_id) do update set email = excluded.email;
```
3. Open `/admin.html` and sign in with that Supabase Auth account.

## Public site
- Teams, players, matches, awards, news, gallery, and match events load from their corresponding DCL tables.
- A database status line in the Teams section reports connection and table errors instead of silently leaving sections empty.
- The overview metrics update from the live database.
- Player cards use the built-in football avatar; no player photo upload is required.
- Team applications are submitted to `dcl_team_applications` and remain pending until approved by an administrator.

## Deploy to Vercel
1. Upload all files from this folder to the GitHub repository root.
2. Confirm `supabase-config.js` contains the correct project URL and publishable/anon key.
3. Import or redeploy the repository in Vercel (Framework Preset: Other; Build Command empty; Output Directory `.`).
4. After deployment, hard-refresh the site with Ctrl+F5.

## Important
This package can be statically checked, but it cannot verify live Supabase permissions or the current data in your project. If the status line reports an error after deployment, share that exact message before changing database policies or table structures.
