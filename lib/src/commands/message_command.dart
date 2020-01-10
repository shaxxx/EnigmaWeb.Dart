import 'package:enigma_web/enigma_web.dart';
import 'package:enigma_web/src/commands/enigma_command.dart';
import 'package:enigma_web/src/commands/i_message_command.dart';
import 'package:enigma_web/src/enums.dart';
import 'package:enigma_web/src/i_profile.dart';
import 'package:enigma_web/src/parsers/i_response_parser.dart';
import 'package:enigma_web/src/responses/i_response.dart';

class MessageCommand
    extends EnigmaCommand<IMessageCommand, IResponse<IMessageCommand>>
    implements IMessageCommand {
  final IResponseParser<IMessageCommand, IResponse<IMessageCommand>> parser;
  @override
  final IProfile profile;
  @override
  final MessageType type;
  @override
  final String message;
  @override
  final int timeout;

  MessageCommand(
    this.parser,
    IWebRequester requester,
    this.profile,
    this.message,
    this.timeout,
    this.type,
  )   : assert(parser != null),
        assert(profile != null),
        assert(message != null),
        assert(timeout != null),
        assert(type != null),
        super(requester);

  @override
  Future<IResponse<IMessageCommand>> executeAsync() async {
    String url;
    if (profile.enigma == EnigmaType.enigma1) {
      String caption;
      switch (type) {
        case MessageType.info:
          {
            caption = 'Info';
            break;
          }
        case MessageType.warning:
          {
            caption = 'Warning';
            break;
          }
        case MessageType.question:
          {
            caption = 'Question';
            break;
          }
        default:
          {
            caption = 'Message';
          }
      }
      url =
          "cgi-bin/xmessage?caption=$caption&timeout=$timeout&body=${Uri.encodeFull(message).replaceAll(" ", "+")}";
    } else {
      url =
          'web/message?text=${Uri.encodeFull(message)}&type=$type&timeout=$timeout';
    }
    return await super.executeGenericAsync(
      profile,
      url,
      parser,
    );
  }
}
