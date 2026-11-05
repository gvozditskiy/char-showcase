# Char

Char is a portfolio showcase: a cut-down, offline version of a production Flutter app.
The code is carried over from the real product and trimmed to four features: a character feed,
a character builder, a feedback survey and a settings tab. It runs with no network, keys or backend.

## Packages

| Package | Contents |
|---|---|
| `core` | `ServiceLocator` with scopes, analytics pipeline, `Logger` and storage contracts |
| `navigation` | `AppNavigator` contract, `PathInfo` |
| `common_ui` | palette (light/dark), theme, shared widgets, routes, `Scoped` |
| `character_data` | `CharacterModel`, `CharacterRepository` contract, character assets |
| `features/cards` | paginated feed, likes, character details |
| `features/cyoc` | step-by-step character builder with a fake generation service |
| `features/survey` | config-driven survey framework |
| `features/profile` | settings: theme switch, "Rate the app" |

Features never import each other; the app (`lib/`) wires them together.

## Architecture

- **Layers:** `Widget → Cubit → (UseCase) → Repository`. A use case exists only where there is a business rule.
- **DI:** a custom `ServiceLocator` with scopes bound to routes (`Scoped`) and reference-counted, so a feature's
  dependencies live exactly as long as its screens. Dependencies go through constructors; implementations of
  shared contracts live in the app, the composition root.
- **Navigation:** `AppNavigator` over `go_router`. Each feature exposes its route graph; the app composes them into
  a `StatefulShellRoute` with the feed and Settings tabs.
- **Cross-feature calls:** a feature declares an adapter interface, the app implements it.
- **Survey:** a flow built from a JSON config. Handlers run per screen and return `proceed` or `finish`; only the
  bloc navigates, and it drops stale steps after every `await`, so a double tap or a close during a slow handler
  is safe.
- **Analytics:** events go through interceptors to the trackers they target (here, a log tracker).
- **Localization:** English only; each package has its own ARB set, bundled configs are keyed by locale.

## Run

```sh
flutter pub get
flutter run
```

## Test

```sh
flutter analyze
flutter test   # app tests; run it inside a package under packages/ for that package's tests
```
