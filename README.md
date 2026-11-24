# Daulatpur Cup 2026–27 — HTML + JavaScript + Supabase

## Included
- `index.html` — bilingual tournament frontend (English default).
- `supabase-config.js` — configured with the supplied Supabase Project URL and publishable key.
- `schema.sql` — database tables, starter fixtures, RLS policies and Realtime publication.
- `vercel.json` — static Vercel deployment settings.

## 1) Set up the database
1. Open the Supabase project: https://supabase.com/dashboard/project/kwisnrksmeiyeajvgujs
2. Go to SQL Editor → New query.
3. Open `schema.sql`, copy its complete contents, paste into SQL Editor and click Run.
4. Confirm the tables are created in Table Editor.

## 2) Create the first admin
1. Supabase → Authentication → Users → Add user.
2. Create the admin email and password.
3. Copy that user's UUID.
4. Run this in SQL Editor, replacing the UUID:
   `insert into public.admin_users(user_id, role) values ('ADMIN-USER-UUID', 'owner');`
5. Admin panel is at the bottom of the website. Sign in there.

## 3) Add teams
Use Supabase Table Editor → `teams` → Insert row. Add up to 32 teams. Assign team IDs to `matches.team_a_id` and `matches.team_b_id` after the public draw.

## 4) Deploy to Vercel
1. Upload these files to a GitHub repository: `index.html`, `supabase-config.js`, `vercel.json`.
2. In https://vercel.com/new import the repository.
3. Framework preset: Other. Build command: leave empty. Output directory: `.`.
4. Deploy. Vercel will provide a `*.vercel.app` address.

## Security
The browser file contains only the Supabase Project URL and publishable key. Never add a `sb_secret_...` or `service_role` key. RLS must remain enabled and tested before public launch.

## Current implementation boundary
- Public match/team data loads from Supabase.
- Realtime subscriptions listen for changes to matches, teams and match events.
- Admin email/password login is checked against `admin_users`.
- Admin can update match status, score, minute and add goal/card events.
- Share Match Card uses featured match data.
- Dedicated team registration, team management, bracket advancement approval, draw audit workflow, notice editor and rich event timeline UI are not yet complete.
