# Dart 3 Migration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Migrate the `enigma_web` pure-Dart package from Dart 2.7 / pre–null-safety to the latest Dart 3 SDK with modern, maintained dependencies, preserving case-sensitive `Authorization` headers required by Enigma receivers.

**Architecture:** A single combined migration — bumping the SDK + dependencies forces sound null safety, so dependency-API fixes (dio 5, xml 6, cookie_jar 4) and null-safety annotations are applied together, file group by file group. `alt_http` is dropped; case-sensitive headers are preserved natively via `preserveHeaderCase`. Both `IWebRequester` implementations are kept.

**Tech Stack:** Dart 3.x, dio ^5.7, xml ^6.5, cookie_jar ^4.0, dio_cookie_manager ^6.0, logging ^1.3, lints ^5.0, test ^1.25.

---

## Important context for the implementer

- **Reference spec:** `docs/superpowers/specs/2026-06-08-dart3-migration-design.md`. Read it first.
- **The package will NOT fully compile until the final task.** Dart 3 has no "partial null safety" — once the SDK constraint is bumped (Task 1), every file reports errors until all are migrated. Therefore each task's verification is *"the targeted errors in this file group are resolved and `dart analyze` shows no NEW categories of error elsewhere"*, and full green (`dart analyze` clean + `dart test` pass) is the gate in the final task. Track progress with the analyzer error count: `dart analyze 2>&1 | Select-String -Pattern "error •" | Measure-Object` (PowerShell) — it should trend down, never up, between tasks.
- **Work on a branch, not `master`.** Before Task 1: `git switch -c feature/dart3-migration`.
- **Shell is PowerShell** (Windows). Commands below use PowerShell-safe syntax.
- **dio 5 verification:** Task 8 (`web_requester.dart`) ports interceptor/error code whose exact API is version-sensitive. Before finalizing it, confirm the dio 5 `onError` handler, `dio.fetch`, and `ErrorInterceptorHandler` API via context7 (`resolve-library-id` → `dio`, then `query-docs`). The code given is the intended target.

---

## File group map

| Group | Files | Change type |
|---|---|---|
| Config | `pubspec.yaml`, `analysis_options.yaml` | deps + lints |
| Parsers (xml) | `lib/src/parsers/*.dart` (7 use xml + 2 helpers) | xml 6 API + nullable locals |
| Exceptions | `known_exception.dart`, `web_request_exception.dart`, `operation_cancelled_exception.dart`, `failed_status_exception.dart`, `time_out_exception.dart`, `commands/command_exception.dart`, `parsers/parsing_exception.dart` | nullable `innerException`, assert removal |
| Models | `e1_signal.dart`, `e2_signal.dart`, `bouquet_item_bouquet.dart`, `bouquet_item_marker.dart`, `bouquet_item_service.dart`, `bouquet_item_service_e1.dart`, `volume_status.dart` | assert removal / `required` |
| Responses | `lib/src/responses/*_response.dart` (14 concrete) | assert removal |
| Commands | `lib/src/commands/*_command.dart` (18 concrete) + `enigma_command.dart` | assert removal + dead-code removal |
| Profile | `profile.dart`, `i_profile.dart` | nullable ports, drop `@required`/meta |
| Helpers | `string_helper.dart`, `parsers/helpers.dart` | nullable params |
| Requester (dart:io) | `dart_web_requester.dart` | preserveHeaderCase, cookie_jar 4 async, NNBD |
| Requester (dio) | `web_requester.dart` | dio 5 port (highest risk) |
| Release | `pubspec.yaml` version, `CHANGELOG.md`, `README.md` | 2.0.0 + docs |

---

## Task 1: Update `pubspec.yaml` and `analysis_options.yaml`

**Files:**
- Modify: `pubspec.yaml`
- Modify: `analysis_options.yaml`

- [ ] **Step 1: Create the migration branch**

Run:
```powershell
git switch -c feature/dart3-migration
```

- [ ] **Step 2: Rewrite `pubspec.yaml`**

Replace the whole file with:
```yaml
name: enigma_web
description: Attempt to create unified API to control Enigma1 & Enigma2 web interfaces
version: 1.0.5
homepage: https://github.com/shaxxx/EnigmaWeb.Dart.git

environment:
  sdk: ">=3.0.0 <4.0.0"

dependencies:
  logging: ^1.3.0
  dio: ^5.7.0
  xml: ^6.5.0
  cookie_jar: ^4.0.8
  dio_cookie_manager: ^6.0.0
  meta: ^1.15.0

dev_dependencies:
  lints: ^5.0.0
  test: ^1.25.0
```
(`alt_http` and `pedantic` are intentionally removed. The version bump to `2.0.0` happens in the final task, after green.)

- [ ] **Step 3: Rewrite `analysis_options.yaml`**

Replace the whole file with:
```yaml
include: package:lints/recommended.yaml
```

- [ ] **Step 4: Resolve dependencies**

Run:
```powershell
dart pub get
```
Expected: resolves successfully and downloads the new dependency versions. If a resolution conflict appears, relax the offending upper bound and re-run; note the resolved versions. (A warning about the SDK lower bound from a transitive dev dependency is harmless.)

- [ ] **Step 5: Commit**

```powershell
git add pubspec.yaml pubspec.lock analysis_options.yaml
git commit -m "build: bump to Dart 3 SDK + modern deps, drop alt_http/pedantic"
```

---

## Task 2: Migrate parsers to xml 6

**Files:**
- Modify: `lib/src/parsers/get_bouquets_parser.dart`
- Modify: `lib/src/parsers/get_bouquets_items_parser.dart`
- Modify: `lib/src/parsers/get_current_service_parser.dart`
- Modify: `lib/src/parsers/power_state_parser.dart`
- Modify: `lib/src/parsers/session_parser.dart`
- Modify: `lib/src/parsers/signal_parser.dart`
- Modify: `lib/src/parsers/volume_status_parser.dart`

**Mechanical xml-6 recipe (apply in every file above):**
1. `xml.parse(s)` → `xml.XmlDocument.parse(s)` (the `import 'package:xml/xml.dart' as xml;` prefix stays).
2. `.text` → `.innerText` on any node (e.g. `node.first.text` → `node.first.innerText`).
3. `findAllElements(...)` now returns a non-null `Iterable<XmlElement>` — delete `xxx != null &&` guards, keep the `.isNotEmpty` checks.

- [ ] **Step 1: Apply the recipe + nullable locals in `get_current_service_parser.dart`**

In `parseE2`, replace lines 72–101 with:
```dart
  GetCurrentServiceResponse parseE2(IStringResponse response) {
    var responseString = Helpers.sanitizeXmlString(response.responseString);
    var document = xml.XmlDocument.parse(responseString);

    String? serviceReference;
    String? serviceName;

    var refNodes = document.findAllElements('e2servicereference');
    if (refNodes.isNotEmpty) {
      serviceReference = StringHelper.trimAll(refNodes.first.innerText);
    }

    var nameNodes = document.findAllElements('e2servicename');
    if (nameNodes.isNotEmpty) {
      serviceName = StringHelper.trimAll(nameNodes.first.innerText);
    }

    if (serviceReference != null) {
      try {
        serviceReference = Uri.decodeFull(serviceReference);
      } catch (e) {
        Logger.root.fine(e.toString());
      }
    }

    return GetCurrentServiceResponse(
        BouquetItemService(
          name: serviceName,
          reference: serviceReference,
        ),
        response.responseDuration);
  }
```
(Note: `serviceReference`/`serviceName` become `String?`; `Uri.decodeFull` is guarded against null. `BouquetItemService` name/reference will be made nullable in Task 4's model group — coordinate.)

- [ ] **Step 2: Apply the recipe in `get_bouquets_parser.dart`**

In `parseE2` (lines 57–91): `xml.parse` → `xml.XmlDocument.parse`; `serviceReferenceNode.first.text` → `.innerText`; `serviceNameNode.first.text` → `.innerText`; change the local declarations `String serviceReference;`/`String serviceName;` to `String?`; delete the `xxx != null &&` guards (keep `.isNotEmpty`).

- [ ] **Step 3: Apply the recipe in `session_parser.dart`**

`xml.parse` → `xml.XmlDocument.parse`; delete `node != null &&` (keep `.isNotEmpty`); `node.first.text` → `node.first.innerText`.

- [ ] **Step 4: Apply the recipe + nullable locals in `signal_parser.dart`**

In `parseE2` (lines 94–134): `xml.parse` → `xml.XmlDocument.parse`; `.text` → `.innerText`; delete the four `xxxNodes != null &&` guards; change `String snr; String db; String acg; String ber;` → `String? snr; String? db; String? acg; String? ber;`.

In `_initializeSignalEnigma2` (lines 136–223), the parameters and locals need nullable types and explicit non-null assertions where flow analysis cannot prove non-null:
  - Change the signature params to nullable: `String? snr, String? db, String? acg, String? ber`.
  - At the top, guard the inputs:
```dart
    if (snr == null || db == null || acg == null || ber == null) {
      return E2Signal(db: -1, snr: -1, acg: -1, ber: -1);
    }
```
    Place this immediately after `var ds = '.';` and BEFORE the existing `snr = StringHelper.trimAll(...)` lines, so the rest of the body sees non-null `snr/db/acg/ber`.
  - Change `String realSnr;` / `String realDb;` to `String? realSnr;` / `String? realDb;`.
  - In the final computation block (lines 205–214), the `else` branch uses `int.parse(realSnr)` where flow analysis cannot prove `realSnr` non-null — replace with `int.parse(realSnr!)`:
```dart
    if (realSnr != null && realDb != null) {
      snr2 = int.parse(realSnr);
      db2 = double.parse(realDb);
    } else if (realDb != null) {
      db2 = double.parse(realDb);
      snr2 = (db2 * 6.5).round();
    } else {
      snr2 = int.parse(realSnr!);
      db2 = double.parse((snr2 / 6.5).toStringAsFixed(2));
    }
```
  - The locals `int snr2; double db2; int acg2; int ber2;` are definitely assigned before use across all branches — leave as-is; if the analyzer flags them, change to `late int snr2; late double db2;` etc.

- [ ] **Step 5: Apply the recipe in `power_state_parser.dart` and `volume_status_parser.dart`**

In each: `xml.parse` → `xml.XmlDocument.parse`; `.text` → `.innerText`; delete `xxx != null &&` element-collection guards (keep `.isNotEmpty`); make any conditionally-assigned local `String` into `String?`.

- [ ] **Step 6: Apply the recipe in `get_bouquets_items_parser.dart`**

Same recipe: `xml.parse` → `xml.XmlDocument.parse`; `.text` → `.innerText`; remove element `!= null` guards; conditionally-assigned `String` locals → `String?`.

- [ ] **Step 7: Verify the parser group analyzes without xml/text errors**

Run:
```powershell
dart analyze lib/src/parsers
```
Expected: no errors referencing `parse`, `text`, `XmlDocument`, or `findAllElements`. Errors pointing at not-yet-migrated types in other files (e.g. `BouquetItemService`, response constructors) are expected and handled by later tasks.

- [ ] **Step 8: Commit**

```powershell
git add lib/src/parsers
git commit -m "refactor: migrate parsers to xml 6 API + null safety"
```

---

## Task 3: Null-safety sweep — exceptions, models, responses, commands

This is a mechanical sweep across the leaf files. The transformation is deterministic.

**The recipe (apply per file):**
- Delete every `assert(<name> != null)` line (and the now-dangling `: ` / trailing `,` punctuation it leaves). KEEP value asserts that are not null checks (e.g. `assert(address.isNotEmpty)`).
- For each field whose assert you deleted, look at its constructor parameter:
  - **Positional parameter** (e.g. `this._responseString`) → no further change; type is already non-nullable.
  - **Named parameter WITH a default** (e.g. `this.acg = 0`) → no further change.
  - **Named parameter WITHOUT a default** (e.g. `{this.name}`) → prefix with `required`: `{required this.name}`.
- For any optional named parameter typed `Exception innerException` → change to `Exception? innerException`.

**Worked examples (the three variants):**

Positional (no change beyond deleting asserts) — `lib/src/responses/string_response.dart`:
```dart
class StringResponse implements IStringResponse {
  final Duration _responseDuration;
  final String _responseString;

  StringResponse(this._responseString, this._responseDuration);

  @override
  Duration get responseDuration => _responseDuration;

  @override
  String get responseString => _responseString;
}
```

Named-with-default (just delete asserts) — `lib/src/e1_signal.dart` constructor:
```dart
  E1Signal({
    this.acg = 0,
    this.ber = 0,
    this.lock = false,
    this.snr = 0,
    this.sync = false,
  });
```

Named-without-default (add `required`) — `lib/src/bouquet_item_bouquet.dart` constructor becomes:
```dart
  BouquetItemBouquet({
    required this.name,
    required this.reference,
  });
```
**Exception:** `BouquetItemService` and `BouquetItemServiceE1` receive possibly-null `name`/`reference` from the parsers (Task 2). For THESE two model files, make the fields nullable (`String? name; String? reference;`) and the params `{this.name, this.reference}` (nullable, NOT `required`). Verify against their interfaces `i_bouquet_item_service.dart` / `i_bouquet_item_service_e1.dart` and make the interface getters nullable to match (`String? get name;`).

- [ ] **Step 1: Migrate the exception files**

Apply to: `known_exception.dart`, `web_request_exception.dart`, `operation_cancelled_exception.dart`, `failed_status_exception.dart`, `time_out_exception.dart`, `commands/command_exception.dart`, `parsers/parsing_exception.dart`.

`known_exception.dart` becomes:
```dart
abstract class KnownException implements Exception {
  final String message;
  final Exception? innerException;
  KnownException(this.message, {this.innerException});
}
```
`web_request_exception.dart` becomes:
```dart
import 'package:enigma_web/src/known_exception.dart';

class WebRequestException extends KnownException {
  WebRequestException(String message, {Exception? innerException})
      : super(message, innerException: innerException);
}
```
Apply the same `Exception? innerException` change to `operation_cancelled_exception.dart`, `time_out_exception.dart`, `command_exception.dart`, `parsing_exception.dart`.

For `failed_status_exception.dart`, ALSO make `statusCode` nullable (dio's `response?.statusCode` is `int?`):
```dart
import 'package:enigma_web/src/known_exception.dart';

class FailedStatusCodeException extends KnownException {
  final int? statusCode;
  FailedStatusCodeException(String message, this.statusCode,
      {Exception? innerException})
      : super(message, innerException: innerException);
}
```

- [ ] **Step 2: Migrate the model files**

Apply the recipe to: `e1_signal.dart`, `e2_signal.dart`, `bouquet_item_bouquet.dart`, `bouquet_item_marker.dart`, `bouquet_item_service.dart` (nullable variant), `bouquet_item_service_e1.dart` (nullable variant), `volume_status.dart`. Update the matching `i_*` interface getters to nullable only where you made a field nullable.

- [ ] **Step 3: Migrate the response files**

Apply the recipe (all positional — just delete asserts) to every `lib/src/responses/*_response.dart`: `binary_response.dart`, `get_bouquets_response.dart`, `get_bouquet_items_response.dart`, `get_current_service_response.dart`, `get_stream_parameters_response.dart`, `power_state_response.dart`, `screenshot_response.dart`, `session_response.dart`, `signal_response.dart`, `string_response.dart`, `unparsed_response.dart`, `volume_status_response.dart`.

- [ ] **Step 4: Migrate the command files**

Apply the recipe to every `lib/src/commands/*_command.dart` constructor (delete `assert(x != null)`; positional params need no further change; any named-without-default param needs `required`). Files: `get_bouquets_command.dart`, `get_bouquet_items_command.dart`, `get_current_service_command.dart`, `get_stream_parameters_command.dart`, `message_command.dart`, `power_state_command.dart`, `reload_settings_command.dart`, `remote_control_command.dart`, `restart_command.dart`, `screenshot_command.dart`, `session_command.dart`, `set_volume_command.dart`, `signal_command.dart`, `sleep_command.dart`, `volume_status_command.dart`, `wake_up_command.dart`, `zap_command.dart`.

- [ ] **Step 5: Fix `enigma_command.dart` dead code**

The base command has null checks that are now dead (params are non-nullable) and a `return null` that violates the non-nullable return type. Replace lines 14–44 with:
```dart
  EnigmaCommand(this.requester);

  Future<TResponse> executeGenericAsync(
    IProfile profile,
    String url,
    IResponseParser<TCommand, TResponse> parser,
  ) async {
    try {
      var response = await requester.getResponseAsync(
        url,
        profile,
      );
      return await parser.parseAsync(
        response,
        profile.enigma,
      );
    } on Exception catch (ex) {
      if (ex is KnownException || ex is OperationCanceledException) {
        rethrow;
      }
      throw CommandException.withException(
          'Command failed for profile ${profile.name}', ex);
    }
  }
```
(Removed the three `if (x == null) throw ArgumentError.notNull(...)` guards, the `if (response == null) return null;` block, and its dead `return null`.)

- [ ] **Step 6: Verify the count dropped and commit**

Run:
```powershell
dart analyze 2>&1 | Select-String -Pattern "error •" | Measure-Object
```
Expected: error count substantially lower than after Task 2; remaining errors concentrate in `profile.dart`, `dart_web_requester.dart`, `web_requester.dart`.

```powershell
git add lib/src
git commit -m "refactor: null-safety sweep of exceptions, models, responses, commands"
```

---

## Task 4: Migrate `Profile` and `IProfile`

**Files:**
- Modify: `lib/src/profile.dart`
- Modify: `lib/src/i_profile.dart`

- [ ] **Step 1: Rewrite `i_profile.dart`**

`streamingPort` and `transcodingPort` are genuinely optional (no default, never asserted non-null) → nullable:
```dart
import 'package:enigma_web/src/enums.dart' show EnigmaType;

abstract class IProfile {
  String get name;
  String get username;
  String get password;
  EnigmaType get enigma;
  String get address;
  int get httpPort;
  bool get useSsl;
  int? get streamingPort;
  bool get transcoding;
  int? get transcodingPort;
  bool get streaming;
  String get id;
  Map<String, dynamic> toJson();
  IProfile.fromJson(Map<String, dynamic> json);
}
```

- [ ] **Step 2: Rewrite the `Profile` fields and constructor**

Make `streamingPort`/`transcodingPort` nullable, drop the duplicate `@required` meta annotations (and the meta import) in favor of the `required` keyword, and delete all `assert(x != null)` lines (keep `assert(address.isNotEmpty)`). Replace lines 1–55 with:
```dart
import 'package:enigma_web/src/i_profile.dart';

import 'enums.dart' show EnigmaType;

class Profile implements IProfile {
  @override
  final String address;
  @override
  final EnigmaType enigma;
  @override
  final int httpPort;
  @override
  final String name;
  @override
  final String password;
  @override
  final bool useSsl;
  @override
  final String username;
  @override
  final int? streamingPort;
  @override
  final bool transcoding;
  @override
  final int? transcodingPort;
  @override
  final bool streaming;
  @override
  final String id;

  Profile({
    required this.address,
    this.enigma = EnigmaType.enigma2,
    this.httpPort = 80,
    required this.name,
    this.password = 'dreambox',
    this.useSsl = false,
    this.username = 'root',
    this.streamingPort,
    this.transcoding = false,
    this.transcodingPort,
    required this.streaming,
    required this.id,
  }) : assert(address.isNotEmpty);
```
Leave `copyWith`, `hashCode`, `operator ==`, `toString`, `fromJson`, and `toJson` unchanged — their `copyWith` params are already effectively nullable (positional-optional). If the analyzer flags `copyWith` param types, prefix each with the nullable type (e.g. `String? address`).

- [ ] **Step 3: Verify and commit**

Run:
```powershell
dart analyze lib/src/profile.dart lib/src/i_profile.dart
```
Expected: no errors in these two files.
```powershell
git add lib/src/profile.dart lib/src/i_profile.dart
git commit -m "refactor: null-safety migrate Profile/IProfile, nullable ports"
```

---

## Task 5: Migrate helpers

**Files:**
- Modify: `lib/src/string_helper.dart`
- Modify: `lib/src/parsers/helpers.dart`

- [ ] **Step 1: `string_helper.dart`**

`stringIsNullOrEmpty` and `trimAll` are called with non-null strings after the parser migration, but keep them tolerant. Make parameters nullable and return types match:
```dart
class StringHelper {
  static bool stringIsNullOrEmpty(String? text) {
    if (text?.isEmpty ?? true) return true;
    return false;
  }

  static String trimAll(String text) {
    if (text.isEmpty) {
      return text;
    }
    var result = text.trim();
    if (result.isEmpty) {
      return result;
    }
    if (result.startsWith('\n')) {
      return trimAll(result.substring(1));
    }
    if (result.startsWith('\t')) {
      return trimAll(result.substring(1));
    }
    if (result.endsWith('\n')) {
      return trimAll(result.substring(0, result.length - 1));
    }
    if (result.endsWith('\t')) {
      return trimAll(result.substring(0, result.length - 1));
    }
    return result;
  }
}
```
(Removed the now-impossible `if (text == null)` branch in `trimAll`; `text` is non-null.)

- [ ] **Step 2: `parsers/helpers.dart`**

`sanitizeXmlString` receives non-null input; remove the dead null guard:
```dart
class Helpers {
  /// Remove illegal XML characters from a string.
  static String sanitizeXmlString(String xml) {
    var buffer = StringBuffer();
    for (var c in xml.split('')) {
      if (isLegalXmlChar(c.codeUnitAt(0))) {
        buffer.writeCharCode(c.codeUnitAt(0));
      }
    }
    return buffer.toString();
  }

  /// Whether a given character is allowed by XML 1.0.
  static bool isLegalXmlChar(int asciiCode) {
    return (asciiCode == 9 ||
        asciiCode == 10 ||
        asciiCode == 13 ||
        (asciiCode >= 32 && asciiCode <= 55295) ||
        (asciiCode >= 57344 && asciiCode <= 65533) ||
        (asciiCode >= 65536 && asciiCode <= 1114111));
  }
}
```

- [ ] **Step 3: Commit**

```powershell
git add lib/src/string_helper.dart lib/src/parsers/helpers.dart
git commit -m "refactor: null-safety migrate helpers"
```

---

## Task 6: Migrate `DartWebRequester` (pure dart:io)

**Files:**
- Modify: `lib/src/dart_web_requester.dart`

- [ ] **Step 1: Make `HttpClientError` fields nullable**

Change the field declarations (lines 42–57) to nullable:
```dart
  /// Error descriptions.
  String? message;
  _HttpClientErrorType type;
  int? statusCode;

  /// The original error/exception object.
  dynamic error;

  @override
  String toString() =>
      'HttpClientError [$type]: ' +
      (message ?? '') +
      (stackTrace ?? '').toString();

  /// Error stacktrace info
  StackTrace? stackTrace;
```
(The `type` field has a default in the constructor, so it stays non-nullable.)

- [ ] **Step 2: Nullable `proxy`, `DefaultCookieJar`, drop assert**

- Change field `final String proxy;` → `final String? proxy;`.
- Change `_cookies = CookieJar()` initializer → `_cookies = DefaultCookieJar()`. Keep the field type `final CookieJar _cookies;`.
- Delete `assert(log != null)` from the constructor initializer list.
- Change `static void _setHttpProxy(HttpClient client, String proxy)` → `String? proxy`.

- [ ] **Step 3: Await the now-async cookie_jar 4 calls**

In `_getResponse`:
- Line 159: `clientRequest.cookies.addAll(_cookies.loadForRequest(uri));` → `clientRequest.cookies.addAll(await _cookies.loadForRequest(uri));`
- Line 185: `_cookies.saveFromResponse(uri, clientResponse.cookies);` → `await _cookies.saveFromResponse(uri, clientResponse.cookies);`

- [ ] **Step 4: Preserve header case on the headers we set**

In `_setBasicAuthHeader`, `_setXRequestedWithHeader`, and `_setContentTypeHeader`, add `preserveHeaderCase: true` to the `Authorization` and `X-Requested-With` adds (Content-Type case is irrelevant to receivers but harmless to include):
```dart
  static void _setBasicAuthHeader(HttpClientRequest request, IProfile profile) {
    if (_profileHasValidCredentials(profile)) {
      request.headers.add(
        'Authorization',
        _getBasicAuthHeader(profile.username, profile.password),
        preserveHeaderCase: true,
      );
    }
  }
```
```dart
  static void _setXRequestedWithHeader(
      HttpClientRequest request, String xRequestedWithHeader) {
    if (StringHelper.stringIsNullOrEmpty(xRequestedWithHeader)) return;
    request.headers.add('X-Requested-With', xRequestedWithHeader,
        preserveHeaderCase: true);
  }
```

- [ ] **Step 5: Fix the `_getResponse` return path for null safety**

`response` is declared `dynamic response;` and assigned inside `try`. The trailing `on Exception catch (e)` block must always throw so the function never returns an unassigned value. Replace the final catch (lines 202–208) with:
```dart
    } on Exception catch (e) {
      if (e is KnownException) rethrow;
      throw WebRequestException('Request for $completeUrl failed.',
          innerException: e);
    }
```
(Removed the redundant inner `if (e is Exception)`.) If the analyzer reports `response` may be unassigned at the final `return`, change its declaration to `late dynamic response;`.

- [ ] **Step 6: Verify and commit**

Run:
```powershell
dart analyze lib/src/dart_web_requester.dart
```
Expected: no errors in this file.
```powershell
git add lib/src/dart_web_requester.dart
git commit -m "refactor: migrate DartWebRequester to cookie_jar 4 + preserveHeaderCase + null safety"
```

---

## Task 7: Migrate `WebRequester` (dio 5) — HIGHEST RISK

**Files:**
- Modify: `lib/src/web_requester.dart`

> Before editing, confirm the dio 5 API via context7 (`resolve-library-id` → `dio`, then `query-docs` for "InterceptorsWrapper onError ErrorInterceptorHandler", "IOHttpClientAdapter createHttpClient", "DioException type", "preserveHeaderCase"). The code below is the intended target for dio ^5.7.

- [ ] **Step 1: Fix imports**

Replace lines 4–8 (the `alt_http`, `dio/adapter`, `dio`, `dio_cookie_manager`, `cookie_jar` imports) with:
```dart
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
```
(The `package:alt_http/alt_http.dart` import is deleted entirely.)

- [ ] **Step 2: Null-safe fields + nullable proxy + late cookie manager**

Replace the field declarations and constructor (lines 25–52) with:
```dart
  late final CookieManager _cookies;
  final int connectTimeOut;
  final int receiveTimeOut;
  final String userAgentHeader;
  final String xRequestedWithHeader;
  final String? proxy;
  final Logger log;
  final int timeoutRetries;

  int _retried = 0;
  int? _currentProfileHashCode;
  bool _usePostRequest = false;
  bool _triedAlternativeRequestMethod = false;
  String? _sessionId;
  bool _isGetSessionError = false;

  WebRequester(
    this.log, {
    this.connectTimeOut = 15000,
    this.receiveTimeOut = 60000,
    this.userAgentHeader =
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36',
    this.xRequestedWithHeader = 'XMLHttpRequest',
    this.proxy,
    this.timeoutRetries = 0,
  }) {
    _cookies = CookieManager(DefaultCookieJar());
  }
```
Also change the separate `_client` field declaration further down the file (currently `Dio _client;`, around line 157) to nullable: `Dio? _client;`.

- [ ] **Step 3: dio 5 client creation — drop alt_http, native adapter, Duration timeouts, preserveHeaderCase**

Replace `_createHttpClient` (lines 83–112) with:
```dart
  Dio _createHttpClient(IProfile profile) {
    var dio = Dio();
    _usePostRequest = (profile.enigma == EnigmaType.enigma2);
    _triedAlternativeRequestMethod = false;
    _isGetSessionError = false;
    _sessionId = null;
    dio.interceptors.add(_createDefaultInterceptor(dio, profile));

    dio.options.connectTimeout = Duration(milliseconds: connectTimeOut);
    dio.options.receiveTimeout = Duration(milliseconds: receiveTimeOut);
    dio.options.preserveHeaderCase = true;
    _setBasicAuthHeader(dio, profile);
    _setXRequesteWithHeader(dio);
    _setUserAgentHeader(dio);
    dio.options.contentType = _contentTypeByEnigmaVersion(profile.enigma);
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      final p = proxy;
      if (p != null) {
        client.findProxy = (uri) => 'PROXY $p';
      }
      return client;
    };
    dio.interceptors.add(_cookies);
    return dio;
  }
```
(The previous `onHttpClientCreate`/`AltHttpClient` block and the inline `deleteAll()` are gone; cookie clearing moves to Step 4.)

- [ ] **Step 4: Duration timeouts + await cookie clear + DioException in `_getResponse`**

In `_getResponse` (lines 158–224):
- Change `Response response;` (line 164) to `late Response response;`.
- In the client-(re)creation `if` block, clear cookies asynchronously before creating the client:
```dart
      if (_client == null ||
          _currentProfileHashCode != profile.hashCode ||
          profile.enigma == EnigmaType.enigma1) {
        _currentProfileHashCode = profile.hashCode;
        await (_cookies.cookieJar as DefaultCookieJar).deleteAll();
        _client = _createHttpClient(profile);
      }
      _client!.options.receiveTimeout = Duration(milliseconds: receiveTimeOut);
      _setResponseType(_client!, responseType);
```
  (`_client` is `Dio?`; use `_client!` at the use sites, and `response = await _client!.post(completeUrl)` / `_client!.get(completeUrl)`.)
- Replace the entire `on DioError catch (e) { ... }` block (lines 184–215) with:
```dart
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        throw OperationCanceledException(e.message ?? 'Cancelled',
            innerException: e);
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw TimeOutException(
          e.message ?? 'Request timed out',
          url,
          e.requestOptions.connectTimeout ??
              Duration(milliseconds: connectTimeOut),
          innerException: e,
        );
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw TimeOutException(
          e.message ?? 'Receive timed out',
          url,
          e.requestOptions.receiveTimeout ??
              Duration(milliseconds: receiveTimeOut),
          innerException: e,
        );
      } else if (e.type == DioExceptionType.sendTimeout) {
        throw TimeOutException(
          e.message ?? 'Send timed out',
          url,
          e.requestOptions.sendTimeout ?? Duration.zero,
          innerException: e,
        );
      } else if (e.type == DioExceptionType.badResponse) {
        throw FailedStatusCodeException(
          e.message ?? 'Bad response',
          e.response?.statusCode,
          innerException: e,
        );
      }
      throw WebRequestException(e.message ?? 'Request failed', innerException: e);
    } on Exception catch (e) {
      if (e is KnownException) rethrow;
      throw WebRequestException('Request for $completeUrl failed.',
          innerException: e);
    }
```

- [ ] **Step 5: `_setBasicAuthHeader` null-safe param**

The current `void _setBasicAuthHeader(dio, IProfile profile)` uses an untyped `dio`. Keep it but ensure the body compiles under null safety; `profile.password` is non-null now, so:
```dart
  void _setBasicAuthHeader(Dio dio, IProfile profile) {
    if (_profileHasValidCredentials(profile)) {
      dio.options.headers['Authorization'] =
          _getBasicAuthHeader(profile.username, profile.password);
    }
  }
```
(In dio 5 `dio.options.headers` is a non-null `Map`, so drop the `??= {}` lines in `_setBasicAuthHeader`, `_setUserAgentHeader`, and `_setXRequesteWithHeader`, and remove the stray empty `;` statement.)

- [ ] **Step 6: Rewrite the error interceptor for dio 5's handler-based contract**

dio 5's `onError` signature is `(DioException e, ErrorInterceptorHandler handler)`; you resolve a retry with `handler.resolve(response)` and pass through with `handler.next(e)` (no more returning the error/response directly). Replace `_createDefaultInterceptor` (lines 280–344) with:
```dart
  InterceptorsWrapper _createDefaultInterceptor(Dio dio, IProfile profile) {
    return InterceptorsWrapper(
      onError: (DioException e, ErrorInterceptorHandler handler) async {
        if (timeoutRetries > 0) {
          if (e.response == null) {
            if (e.type == DioExceptionType.receiveTimeout ||
                e.type == DioExceptionType.connectionTimeout) {
              if (_retried < timeoutRetries) {
                _retried += 1;
                if (e.type == DioExceptionType.receiveTimeout) {
                  dio.options.receiveTimeout =
                      Duration(milliseconds: receiveTimeOut * (_retried + 1));
                  log.fine(
                      '********************** RECEIVE_TIMEOUT Retry $_retried ${DateTime.now().toIso8601String()}');
                } else {
                  dio.options.connectTimeout =
                      Duration(milliseconds: connectTimeOut * (_retried + 1));
                  log.fine(
                      '********************** CONNECT_TIMEOUT Retry $_retried ${DateTime.now().toIso8601String()}');
                }
                try {
                  return handler.resolve(await dio.fetch(e.requestOptions));
                } on DioException catch (err) {
                  return handler.next(err);
                }
              }
            }
          }
          if (_retried == timeoutRetries) {
            log.fine(
                '********************** FAILED AFTER ${_retried + 1} attempts ${DateTime.now().toIso8601String()}');
          }
        }
        if (e.type == DioExceptionType.badResponse) {
          if (e.response?.statusCode == HttpStatus.preconditionFailed &&
              _isGetSessionError == false) {
            try {
              log.fine('********************** Requesting session id');
              var st = Stopwatch();
              st.start();
              var sessionResponseString =
                  (await dio.post(_createSessionUrl(profile))).data.toString();
              st.stop();
              var stringResponse = StringResponse(sessionResponseString,
                  Duration(milliseconds: st.elapsedMilliseconds));
              var sessionResponse = SessionParser().parseE2(stringResponse);
              _sessionId = sessionResponse.sessionId;
              log.fine('********************** Got session id');
              _client?.options.method = _usePostRequest ? 'POST' : 'GET';
              final retryOptions = e.requestOptions
                ..path = _updateUrlWithSessionId(e.requestOptions.path, _sessionId!);
              return handler.resolve(await dio.fetch(retryOptions));
            } catch (err) {
              log.fine(err);
              _isGetSessionError = true;
              _sessionId = null;
            }
            try {
              return handler.resolve(await dio.fetch(e.requestOptions));
            } on DioException catch (err) {
              return handler.next(err);
            }
          } else if (e.response?.statusCode == HttpStatus.methodNotAllowed &&
              _triedAlternativeRequestMethod == false) {
            _usePostRequest = !_usePostRequest;
            _triedAlternativeRequestMethod = true;
            log.fine(
                '********************** Switching to ${_usePostRequest ? 'POST' : 'GET'} method');
            _client?.options.method = _usePostRequest ? 'POST' : 'GET';
            try {
              return handler.resolve(await dio.fetch(e.requestOptions));
            } on DioException catch (err) {
              return handler.next(err);
            }
          }
        }
        return handler.next(e);
      },
    );
  }
```

- [ ] **Step 7: `logResponse` nullable Response**

Change `void logResponse(Response response, ...)` → `void logResponse(Response? response, ...)` (the `if (response == null)` branch stays valid).

- [ ] **Step 8: Verify and commit**

Run:
```powershell
dart analyze lib/src/web_requester.dart
```
Expected: no errors in this file. If `dio.fetch`/`handler.resolve` signatures differ from the above per the context7 docs, adjust to match and re-run.
```powershell
git add lib/src/web_requester.dart
git commit -m "refactor: migrate WebRequester to dio 5, drop alt_http, preserveHeaderCase"
```

---

## Task 8: Green the build — analyze, test, fix stragglers

**Files:**
- Modify: any file the analyzer/tests still flag (logging API, lint nits).

- [ ] **Step 1: Full analyze**

Run:
```powershell
dart analyze
```
Expected: ideally zero issues. For any remaining errors:
- **logging 1.x:** `Logger.root`, `Level.ALL`, `record.message`, `log.fine/finest/warning` are all still valid in 1.x — no change expected. If `Level.ALL` is flagged, it remains available; leave as-is.
- **Unused imports** (e.g. `package:meta/meta.dart` in `profile.dart`, `dart:async` where no longer needed): delete them.
- **lints warnings** (e.g. `prefer_final_fields`, `unnecessary_this`): fix mechanically as the analyzer directs. Do not suppress.

- [ ] **Step 2: Run the test suite**

Run:
```powershell
dart test
```
Expected: both tests in `test/enigma_web_test.dart` pass (`e1 snr to db conversion`, `default log is working`). The `E1Signal(snr: 91)` test exercises the migrated model; the logging test exercises `logging` 1.x. Fix any failure at its root (do not edit the test to mask a real regression).

- [ ] **Step 3: Add a header-case regression test**

Guard the assumption that justified dropping `alt_http`. Create `test/header_case_test.dart`:
```dart
import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

void main() {
  test('dart:io HttpClient preserves Authorization header case', () async {
    final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    String? rawHead;
    server.listen((socket) {
      final chunks = <int>[];
      socket.listen((data) {
        chunks.addAll(data);
        final text = latin1.decode(chunks);
        if (text.contains('\r\n\r\n') && rawHead == null) {
          rawHead = text.substring(0, text.indexOf('\r\n\r\n'));
          socket.write('HTTP/1.1 200 OK\r\nContent-Length: 2\r\n\r\nOK');
          socket.close();
        }
      });
    });

    final client = HttpClient();
    final req = await client.getUrl(Uri.parse('http://127.0.0.1:${server.port}/'));
    req.headers.add('Authorization', 'Basic abc123', preserveHeaderCase: true);
    final resp = await req.close();
    await resp.drain();
    client.close();
    await server.close();

    expect(rawHead, isNotNull);
    expect(rawHead, contains('Authorization:'));
    expect(rawHead, isNot(contains('authorization:')));
  });
}
```

- [ ] **Step 4: Run the new test**

Run:
```powershell
dart test test/header_case_test.dart
```
Expected: PASS.

- [ ] **Step 5: Commit**

```powershell
git add -A
git commit -m "test: green build on Dart 3 + header-case regression test"
```

---

## Task 9: Release metadata

**Files:**
- Modify: `pubspec.yaml`
- Modify: `CHANGELOG.md`
- Modify: `README.md`

- [ ] **Step 1: Bump version**

In `pubspec.yaml`, change `version: 1.0.5` → `version: 2.0.0`.

- [ ] **Step 2: Add a CHANGELOG entry**

Prepend to `CHANGELOG.md`:
```markdown
## 2.0.0

- Migrated to Dart 3 with sound null safety (breaking: public API signatures now null-aware).
- Upgraded dependencies: dio 5, xml 6, cookie_jar 4, dio_cookie_manager 6, logging 1.
- Removed `alt_http`; case-sensitive `Authorization` headers are now preserved natively via
  `preserveHeaderCase` on both the dio and dart:io requesters.
- Replaced `pedantic` with `package:lints/recommended`.
- `Profile.streamingPort` and `Profile.transcodingPort` are now nullable (`int?`).
```

- [ ] **Step 3: Sanity-check the README example**

Read `README.md` lines 8–38. The example uses `Profile()` with field assignment (`profile.address = ...`), but `Profile` has only `final` fields set via the constructor. This was already inconsistent pre-migration; update the snippet to constructor form:
```dart
var profile = Profile(
  address: "192.168.0.2",
  httpPort: 80,
  enigma: EnigmaType.enigma2,
  username: "root",
  password: "password",
  name: "My receiver",
  streaming: false,
  id: "1",
);
```

- [ ] **Step 4: Final verify and commit**

Run:
```powershell
dart analyze
dart test
```
Expected: clean analyze, all tests pass.
```powershell
git add pubspec.yaml CHANGELOG.md README.md
git commit -m "release: 2.0.0 — Dart 3 + null safety"
```

---

## Self-review notes (for the implementer)

- **Header-case assumption is verified** (see spec §"Why alt_http existed"); the regression test in Task 8 locks it in.
- **Highest-risk task is Task 7** (dio 5). Its interceptor retry/session logic cannot be exercised by the current unit tests — it needs manual verification against a real Enigma1/Enigma2 receiver after the build is green. Flag this to the user before considering the migration "done."
- **`BouquetItemService`/`BouquetItemServiceE1` nullability** (Task 3 Step 2) must agree with the parser changes (Task 2 Step 1) and the interface getters — if you make a field nullable, make its interface getter nullable too, or the `implements` check fails.
- If `dart pub get` (Task 1) forces different majors than the table, update the spec's dependency table to match what actually resolved.
