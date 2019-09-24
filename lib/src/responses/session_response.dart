import 'package:enigma_web/src/responses/i_session_response.dart';

class SessionResponse implements ISessionResponse {
  final String _sessionId;
  final Duration _responseDuration;

  SessionResponse(this._sessionId, this._responseDuration)
      : assert(_sessionId != null),
        assert(_responseDuration != null);

  @override
  String get sessionId => _sessionId;

  @override
  Duration get responseDuration => _responseDuration;
}
