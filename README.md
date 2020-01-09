# EnigmaWeb

This library is conversion of [EnigmaWeb](https://github.com/shaxxx/EnigmaWeb) to [Dart language](https://dart.dev).
Works with both *Enigma1* and *Enigma2* web interfaces.

First thing to do is to setup profile information 

    ```dart
    var profile = Profile();
    profile.address = "192.168.0.2";
    profile.httpPort = 80;
    profile.enigma = EnigmaType.enigma2;
    profile.username = "root";
    profile.password = "password";
    ```

## Execute command
All available web commands are implemented, just execute command and read response from object model, ie.

    ```dart
    //initialize parser to parse response to read current service from receiver
    var currentServiceResponseParser = GetCurrentServiceParser();
    //initialize http client implementation to send HTTP requests to receiver
    var webRequester = WebRequester(Logger.root);
    //initialize get current service command object
    var command = GetCurrentServiceCommand(currentServiceResponseParser, webRequester);
    //execute command and get typed result
    GetCurrentServiceResponse response = await command.executeAsync(profile);
    //use result
    print(response.currentService);
    print(response.responseDuration);

    //some commands dont need parsing (IE. we're not interested in result, just if command was successfull)
    //for that we use UnparsedParser<TCommand>, for example WakeUp command to wake up Enigma
    var noParsing = UnparsedParser<WakeUpCommand>();
    // perform WakeUp command, and just wait for it to finish
    await WakeUpCommand(noParsing, requester).executeAsync(profile);
    ```
    
