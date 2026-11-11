# Next.js (App Router)

- Server components by default; add 'use client' only where hooks, state or browser APIs are needed,
  and push the client boundary as far down the tree as possible.
- Fetch data in server components where possible rather than client effects; avoid request waterfalls
  (start independent fetches in parallel).
- Never import server-only modules (DB clients, secrets, large data files) into client components;
  consider the `server-only` package to enforce it.
- Only NEXT_PUBLIC_ env vars reach the browser; everything else must stay server-side.
- Route handlers and server actions validate input and check authorization themselves; never trust
  client-side checks.
- Be explicit about caching and revalidation (static vs dynamic, revalidate, cache tags); know which
  routes are static and why. Defaults changed between major versions: check the version's docs.
- Next 15+: params and searchParams are Promises; cookies() and headers() are async.
- Use loading.js and error.js for route-level states; not-found for missing resources.
- Images through next/image, fonts through next/font, links through next/link.
