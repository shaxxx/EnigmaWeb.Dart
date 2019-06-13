import 'package:enigma_web/src/responses/i_binary_response.dart';

class BinaryResponse implements IBinaryResponse {
  final List<int> _content;
  final Duration _responseDuration;

  BinaryResponse(this._content, this._responseDuration)
      : assert(_content != null),
        assert(_responseDuration != null);
  @override
  List<int> get content => _content;

  @override
  Duration get responseDuration => _responseDuration;
}
