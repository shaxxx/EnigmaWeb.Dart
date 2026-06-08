# Migrate `enigma_web` to Dart 3 + modern dependencies

**Date:** 2026-06-08
**Status:** Approved design (header-case assumption verified)
**Target version:** 2.0.0 (breaking — null safety changes the public API)

## Goal

Bring the `enigma_web` Dart package from its current Dart 2.7 / pre–null-safety state up to
the latest Dart 3 SDK, with modern, maintained dependencies. The package must continue to
talk to real Enigma1 and Enigma2 satellite receivers, which means **case-sensitive HTTP
headers (`Authorization`) must be preserved on the wire**.

This is a "Modernize" effort: null safety + latest deps + modern lints + correct fixes for
breaking dependency APIs + dead-code cleanup. It is **not** an architectural rewrite.

## Background

`enigma_web` is a pure-Dart library (no Flutter dependency). It exposes a command/parser/
response model over two interchangeable `IWebRequester` implementations:

- `WebRequester` — built on **dio 3** + **alt_http** (an HTTP adapter) + cookie management.
- `DartWebRequester` — built on pure `dart:io` `HttpClient`, zero external HTTP deps.

The package is pinned to `sdk: ">=2.7.0 <3.0.0"`, so it cannot be consumed by any modern
(Dart 3) project at all.

### Why `alt_http` existed, and why it can now be dropped

`alt_http` is a fork of Dart's `HttpClient` authored specifically to **preserve
case-sensitive header names**. Standard `dart:io` lowercased all header names per HTTP spec;
satellite receivers reject a lowercased `authorization` header and require literal
`Authorization`. `alt_http` was injected as dio's HTTP adapter to work around this.

Dart later added native support for this:

- `dart:io`: `HttpHeaders.add()` / `.set()` accept `preserveHeaderCase: true`
  ([dart-lang/sdk#39657](https://github.com/dart-lang/sdk/issues/39657), available since Dart 2.8).
- dio 5: `dio.options.preserveHeaderCase = true`
  ([cfug/dio#641](https://github.com/cfug/dio/issues/641)).

**Verified on Dart SDK 3.11.1 (windows_x64) + dio 5.9.2** via a raw `ServerSocket` capturing
literal request bytes (a `dart:io` `HttpServer` could not be used to verify this, because the
server side also lowercases incoming header names):

- Stock `dart:io` `HttpClient` with `preserveHeaderCase: true` emits `Authorization: Basic …`
  with a literal capital `A`; without the flag it emits `authorization:` (control confirmed).
- dio 5 with `preserveHeaderCase = true` emits `Authorization:` for both GET and POST, and
  for both the global `dio.options.headers` and per-request `Options(headers:)` styles.
- Auto-added headers (`host`, `content-length`, `content-type`, `accept-encoding`,
  `user-agent`) remain lowercase on both paths. This is expected and harmless — receivers
  only require `Authorization` (and `X-Requested-With`, which we set ourselves and which is
  preserved via the flag).

**Conclusion:** `alt_http` can be dropped on both HTTP paths with no behavioral loss.

## Strategy & sequencing

The automated `dart migrate` tool was **removed in Dart 3** and in any case required all
dependencies to already be null-safe (these are not). Therefore this is a **single combined
migration** — bumping the SDK and dependencies forces null safety, and the breaking
dependency APIs must be fixed in the same pass. Order of work:

1. Rewrite `pubspec.yaml` (SDK constraint + dependency versions; remove `alt_http`,
   `pedantic`; add `lints`).
2. `dart pub get`, resolve versions.
3. Fix compile errors area-by-area: dio → xml → cookies → logging.
4. Add sound null-safety annotations (`?`, `late`, `required`, drop redundant
   `assert(x != null)` that the type system now enforces).
5. Replace `pedantic` analysis options with `package:lints`; fix lint fallout.
6. Run `dart analyze` + `dart test` to green; bump to **2.0.0**; update `CHANGELOG.md`.

## Dependency changes (`pubspec.yaml`)

| Package | From | To | Note |
|---|---|---|---|
| SDK | `>=2.7.0 <3.0.0` | `^3.0.0` | enables null safety |
| `logging` | `^0.11.3+2` | `^1.3.0` | minor API tweaks |
| `dio` | `>=3.0.0 <3.0.8` | `^5.7.0` | major breaking API |
| `xml` | `^3.5.0` | `^6.5.0` | major breaking API |
| `cookie_jar` | `^1.0.1` | `^4.0.8` | now async |
| `dio_cookie_manager` | `^1.0.0` | `^6.0.0` | tracks dio 5 |
| `alt_http` | `^0.3.0` | **removed** | replaced by `preserveHeaderCase` |
| `meta` | `^1.1.8` | `^1.15.0` | |
| `pedantic` (dev) | `^1.9.0` | **removed** | discontinued |
| `lints` (dev) | — | `^5.0.0` | new, replaces pedantic |
| `test` (dev) | `^1.10.0` | `^1.25.0` | |

(Exact upper patch versions to be confirmed against `dart pub get` resolution at
implementation time; the table reflects intended major lines.)

## Code-change hotspots

### `lib/src/web_requester.dart` (dio 5 — heaviest file)

- `DioError` → `DioException`.
- Error-type enum: `DioErrorType.CANCEL` → `DioExceptionType.cancel`;
  `CONNECT_TIMEOUT` → `connectionTimeout`; `RECEIVE_TIMEOUT` → `receiveTimeout`;
  `SEND_TIMEOUT` → `sendTimeout`; `RESPONSE` → `badResponse`.
- `e.request` → `e.requestOptions`.
- Timeout options become `Duration` (not `int` ms). **Decision:** keep the public
  constructor params `connectTimeOut` / `receiveTimeOut` as `int` milliseconds (minimize
  consumer churn) and convert to `Duration` internally where dio now requires it.
- Adapter: `DefaultHttpClientAdapter` → `IOHttpClientAdapter` (import `package:dio/io.dart`);
  `.onHttpClientCreate` → `.createHttpClient`. Inside it, construct a plain `HttpClient()`
  and apply `badCertificateCallback` (accept) + `findProxy` (when `proxy` set).
- Set `dio.options.preserveHeaderCase = true` so `Authorization` / `X-Requested-With` keep
  their case.
- Cookie management: `dio_cookie_manager` 6 + `cookie_jar` 4 — `DefaultCookieJar`;
  `deleteAll()` is now async (`await`).

### `lib/src/dart_web_requester.dart`

- Add `preserveHeaderCase: true` to the `Authorization` (and `X-Requested-With`,
  `Content-Type`) `headers.add(...)` calls.
- `cookie_jar` 4: `loadForRequest(uri)` and `saveFromResponse(uri, cookies)` are now async —
  `await` them.

### Parsers (`lib/src/parsers/*.dart`) — xml 6

- `xml.parse(s)` → `XmlDocument.parse(s)`.
- `.text` → `.innerText`.
- `findAllElements(...)` returns a non-null `Iterable<XmlElement>` — drop the `!= null`
  guards (keep the `isNotEmpty` checks).

### Null safety (package-wide)

- `Profile` and the `IProfile` interface: make genuinely-optional fields nullable
  (`password`, `proxy`, etc.); keep required fields non-nullable.
- Command / response / model fields: nullable where the data can legitimately be absent
  (e.g. parsed `serviceName`), `required`/non-nullable otherwise.
- Constructor params: convert positional-optional-with-null to `required` or nullable as
  appropriate; remove `assert(x != null)` made redundant by non-nullable types.
- `logging` 1.x: `Logger.root` and record APIs are largely source-compatible; adjust any
  removed members.

### Lints

- Delete the `include: package:pedantic/analysis_options.yaml` line.
- `include: package:lints/recommended.yaml` (or `package:lints/core.yaml`).
- Fix resulting analyzer warnings.

## HTTP layer decision

Both `WebRequester` (dio 5) and `DartWebRequester` (pure `dart:io`) are **kept**. `alt_http`
is removed; header-case behavior is preserved natively on both, as verified above. Public
`IWebRequester` interface is unchanged.

*Out of scope / possible future follow-up:* consolidating to the dependency-light
`DartWebRequester` only (would drop `dio`, `dio_cookie_manager`, `cookie_jar`), at the cost
of dio's interceptor-based session/retry logic.

## Testing & verification

- `test/enigma_web_test.dart` + the `test/getservices.xml` fixture must stay green
  (`dart test`).
- `dart analyze` must be clean under the new lints.
- Existing test coverage is thin and exercises parsing, not live HTTP. The dio request path
  cannot be fully exercised without a real receiver; any change there that can't be unit-
  tested will be flagged for manual verification against actual hardware.
- The header-case assumption that justifies dropping `alt_http` is already verified (above)
  and should be guarded by a small regression test using a raw `ServerSocket` if practical.

## Risks

- **dio 5 surface area** — `web_requester.dart` is the largest behavioral change; the
  interceptor-based session-id acquisition and GET/POST fallback logic must be re-validated
  against the new error-type enums and `requestOptions` shape.
- **Public API break** — null safety changes signatures across the exported surface; this is
  an intentional 2.0.0 major release, not a drop-in upgrade for consumers.
- **Auto-added lowercase headers** — confirmed harmless for Enigma, but noted so it is not
  mistaken for a regression.

## Out of scope

- Flutter integration (the package has no Flutter dependency and stays pure Dart).
- Architectural refactor of the command/parser/response model or the `i_*` interface set.
- Consolidating the two requester implementations.
- Expanding the (currently thin) automated test suite beyond what the migration requires.
