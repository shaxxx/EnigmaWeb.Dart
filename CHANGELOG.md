# Changelog

## 2.0.0

- Migrated to Dart 3 with sound null safety (breaking: public API signatures are now null-aware).
- Upgraded dependencies: dio 5, xml 6, cookie_jar 4, dio_cookie_manager 3, logging 1.
- Removed `alt_http`; case-sensitive `Authorization` headers are now preserved natively via
  `preserveHeaderCase` on both the dio and dart:io requesters.
- Replaced `pedantic` with `package:lints/recommended`.
- `Profile.streamingPort` and `Profile.transcodingPort` are now nullable (`int?`).
- Bouquet item `name`/`reference` are now nullable (`String?`).
- `SignalParser` now throws `ParsingException` when an Enigma2 signal response is missing
  expected XML fields (previously this surfaced as an uncaught runtime error).
- `VolumeStatusParser` Enigma1 responses now report the actual request duration instead of
  null. Commands that require a service/bouquet `reference` now throw a clear `ArgumentError`
  when it is null instead of a generic null-check error.

1.0.5 fix message command type (again)

1.0.4 fix message command type

1.0.3 updated AltHttp package

1.0.2 updated dependencies with minor code refactoring

1.0.1 support Dreambox security features

1.0.0 production ready

0.9.7 updated AltHttp package reference

0.9.6 removed canceltoken parameter

0.9.5 webrequest fixes for Enigma1

0.9.4 Optional retry strategy

0.9.3 Refactor as immutable types

0.9.2 Failed HTTP status code as int

0.9.1 Refactor command parameters

0.9.0 Uri encoding/decoding as E2 bug workaround

0.8.0 fixed bouquet items parser

0.7.0 all custom exceptions inherit from KnownException

0.6.0 added proxy as optional WebRequester parameter

0.5.0 code styling

0.4.0 absolute imports, equality operator, removed Factory

0.3.0 use curly braces for all flow control structures

0.2.0 minor code refactoring

0.1.0 first working conversion of [EnigmaWeb](https://github.com/shaxxx/EnigmaWeb) to Dart language.
