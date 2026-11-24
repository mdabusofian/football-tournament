DAULATPUR CUP 2026-27 — ADMIN DASHBOARD UPDATE

Files in this package:
- index.html: existing public tournament website
- admin.html: new standalone admin dashboard
- supabase-config.js: configured with the Supabase Project URL and publishable browser key
- schema.sql: existing Supabase database schema (already run by you)
- vercel.json: routes /admin to admin.html

DEPLOY UPDATE:
1. Download and extract this ZIP.
2. Upload/replace these files in the SAME GitHub repository currently connected to Vercel.
3. Keep the filenames exactly as shown.
4. Commit changes to the deployment branch (usually main).
5. Vercel will redeploy automatically.
6. Open https://football-tournament-two.vercel.app/admin
7. Sign in with the admin email you registered and its password.

Dashboard features:
- Match status, team assignment, score and minute updates
- Goal / yellow-card / red-card event entry
- Add and edit teams and draw positions
- Approve or reject team registration applications
- Create and publish tournament notices

Security:
- Uses Supabase Auth and checks that the signed-in user exists in public.admin_users.
- Uses only the browser-safe publishable key. Never add a Supabase secret/service_role key.
- Existing Supabase RLS policies remain responsible for database authorization.

Note: The ZIP prepares the dashboard files. It does not modify GitHub or deploy the site automatically. Verify each action in Supabase after deployment.
