import 'package:drive/configuration.dart';
import 'package:drive/drive.dart';
import 'package:drive/responses.dart';

void main(List<String> arguments) async {
  if (arguments.isEmpty) inform();

  String cmd = arguments[0];

  if (cmd == "configure") {
    if (arguments.length > 1) {
      configure(ask("Client ID: "), ask("Client Secret: "), mode: arguments[1]);
      return;
    }
    configure(ask("Client ID: "), ask("Client Secret: "));
  }

  checkConfiguration();

  (cmd == "ls" || cmd == "list") ? listFiles(credentials(), scopes) : "";

  if (cmd == "u" || cmd == "upload") {
    if (arguments.length > 1) {
      uploadFile(credentials(), scopes, ask("File name: "), arguments[1]);
      return;
    }
    error("error");
  }
}
