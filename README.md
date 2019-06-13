# EnigmaWeb

This library is conversion of [EnigmaWeb](https://github.com/shaxxx/EnigmaWeb) to [Dart language](https://dart.dev).
Works with both *Enigma1* and *Enigma2* web interfaces.

First thing to do is to setup profile information 

    var profile = Profile();
    profile.address = "192.168.0.2";
    profile.httpPort = 80;
    profile.enigma = EnigmaType.enigma2;
    profile.username = "root";
    profile.password = "password";

## Execute command
All available web commands are implemented, just execute command and read response from object model, ie.

    IFactory f= new Factory(); //default object initializer factory
    var currentCommand = new GetCurrentServiceCommand(f);
    var result = await currentCommand.executeAsync(profile);
    print(result.currentService.name);  
    