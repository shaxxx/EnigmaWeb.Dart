import 'package:dio/dio.dart';

import '../i_factory.dart';
import '../i_profile.dart';
import '../i_web_requester.dart';
import '../known_exception.dart';
import '../operation_cancelled_exception.dart';
import '../parsers/i_response_parser.dart';
import '../responses/i_response.dart';
import 'command_exception.dart';
import 'i_command.dart';

abstract class EnigmaCommand<TCommand extends ICommand, TResponse extends IResponse<TCommand>> {
  IWebRequester requester;
  //IFactory _factory;

  EnigmaCommand(IFactory factory) {
    if (factory == null) {
      throw ArgumentError.notNull("factory");
    }
    //this._factory = factory;
    requester = factory.webRequester();
  }

  Future<TResponse> executeGenericAsync(
      IProfile profile, String url, IResponseParser<TCommand, TResponse> parser,
      {CancelToken token}) async {
    if (profile == null) throw ArgumentError.notNull("profile");
    if (url == null) throw ArgumentError.notNull("url");
    if (parser == null) throw ArgumentError.notNull("parser");

    try {
      String response = await requester.getResponseAsync(url, profile, cancelToken: token);
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
