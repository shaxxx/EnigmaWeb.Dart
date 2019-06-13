import 'package:dio/dio.dart';
import 'package:enigma_web/src/commands/command_exception.dart';
import 'package:enigma_web/src/commands/i_command.dart';
import 'package:enigma_web/src/i_profile.dart';
import 'package:enigma_web/src/i_web_requester.dart';
import 'package:enigma_web/src/known_exception.dart';
import 'package:enigma_web/src/operation_cancelled_exception.dart';
import 'package:enigma_web/src/parsers/i_response_parser.dart';
import 'package:enigma_web/src/responses/i_response.dart';

abstract class EnigmaCommand<TCommand extends ICommand, TResponse extends IResponse<TCommand>> {
  final IWebRequester requester;

  EnigmaCommand(this.requester) : assert(requester != null) {}

  Future<TResponse> executeGenericAsync(IProfile profile, String url, IResponseParser<TCommand, TResponse> parser,
      {CancelToken token}) async {
    if (profile == null) throw ArgumentError.notNull("profile");
    if (url == null) throw ArgumentError.notNull("url");
    if (parser == null) throw ArgumentError.notNull("parser");

    try {
      var response = await requester.getResponseAsync(url, profile, cancelToken: token);
      if (response == null) {
        return null;
      }
      return await parser.parseAsync(response, profile.enigma);
    } on Exception catch (ex) {
      if (ex is KnownException || ex is OperationCanceledException) {
        rethrow;
      }
      throw CommandException.withException("Command failed for profile ${profile.name}", ex);
    }
  }
}
