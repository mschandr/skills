# React

- Don't put derived state in useState plus useEffect; compute it during render (useMemo only if measured).
- Effects are for synchronizing with external systems, not for reacting to your own state changes.
- Fetching in effects needs cancellation (AbortController) and handling of out-of-order responses;
  prefer the framework's data layer or a query library where available.
- Lift state only as far as needed; avoid prop drilling through many layers (composition or context).
- Context is not a high-frequency store; frequently changing values in context cause wide re-renders.
- Stable, unique keys for lists (not array index when items reorder).
- Keep components presentational where possible; put logic in hooks or plain functions.
- Accessibility: semantic elements, labels for inputs, keyboard support, alt text.
- Memoization (memo, useMemo, useCallback) only where profiling shows a benefit.
