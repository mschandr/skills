# Laravel

- Avoid N+1 queries: eager load relationships with with() / load(); enable
  Model::preventLazyLoading() outside production to catch them.
- Select only needed columns for large lists; paginate; use chunk() / lazy() / cursor() for big jobs.
- Index foreign keys and columns used in where, order by and joins.
- Validation in Form Requests, not inline in controllers.
- Authorization with Policies and Gates, checked on every protected action.
- Thin controllers: move business logic into actions or services (follow whichever pattern the app uses).
- Mass assignment: $fillable (or deliberate $guarded) on every model; never pass $request->all() blindly.
- Read configuration through config(), never env() outside config files (breaks under config:cache).
- Slow or external work (mail, APIs, image processing) goes to queued jobs; jobs are idempotent and
  have retries and timeouts.
- Wrap multi-step writes in DB::transaction().
- Use route model binding, API Resources for response shaping, and named routes.
- No raw DB::raw / whereRaw with user input unless parameter-bound.
- Events and observers sparingly; hidden side effects make flows hard to follow.
- Feature tests for HTTP flows, using RefreshDatabase and factories.
