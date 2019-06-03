import 'package:dio/dio.dart';

import '../commands/enigma_command.dart';
import '../commands/i_message_command.dart';
import '../enums.dart';
import '../i_factory.dart';
import '../i_profile.dart';
import '../parsers/i_response_parser.dart';
import '../responses/i_response.dart';

class MessageCommand
    extends EnigmaCommand<IMessageCommand, IResponse<IMessageCommand>>
    implements IMessageCommand {
  IResponseParser<IMessageCommand, IResponse<IMessageCommand>> _parser;

  MessageCommand(IFactory factory) : super(factory) {
    _parser = factory.messageParser();
  }

  @override
  Future<IResponse<IMessageCommand>> executeAsync(
      IProfile profile, MessageType type, String message, int timeout,
      {CancelToken token}) async {
    String url;
    if (profile.enigma == EnigmaType.enigma1) {
      String caption;
      switch (type) {
        case MessageType.Info:
          {
            caption = "Info";
            break;
          }
        case MessageType.Warning:
          {
            caption = "Warning";
            break;
          }
        case MessageType.Question:
          {
            caption = "Question";
            break;
          }
        default:
          {
            caption = "Message";
          }
      }
      url =
          "cgi-bin/xmessage?caption=$caption&timeout=$timeout&body=${Uri.encodeFull(message).replaceAll(" ", "+")}";
    } else {
      url =
          "web/message?text=${Uri.encodeFull(message)}&type=$type&timeout=$timeout";
    }
    return await super.executeGenericAsync(profile, url, _parser, token: token);
  }
}
