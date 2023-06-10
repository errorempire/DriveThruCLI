import 'package:drive_thru/configuration.dart';
import 'package:drive_thru/drive_thru.dart';
import 'package:drive_thru/responses.dart';

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

  (cmd == "ls" || cmd == "list") ? listFiles(credentials()) : "";

  if (cmd == "u" || cmd == "upload") {
    if (arguments.length > 1) {
      uploadFile(credentials(), ask("File name: "), arguments[1]);
      return;
    }
  }
  error("error");
  inform();
}
