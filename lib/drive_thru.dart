import 'dart:io';

import 'package:drive_thru/responses.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/drive/v3.dart' as drive_v3;
import 'package:prompts/prompts.dart' as prompts;

final List<String> scopes = [drive_v3.DriveApi.driveScope];

dynamic ask(String question) {
  return prompts.get(question);
}

void prompt(String url) {
  info("grant_access");
  print(url);
}

void inform() {
  print("""
${colors["magenta"]!}
@@@@@@@@@@@@@@@@@@@@
@@@              @@@
@@@ DriveThruCLI @@@
@@@              @@@
@@@@@@@@@@@@@@@@@@@@
${colors["reset"]!}

${colors["yellow"]!}Usage:${colors["reset"]!}
    command [options] [arguments]

${colors["yellow"]!}Options:${colors["reset"]!}
drivethru configure                            :: configure the credentials
drivethru ls            | list                 :: list all the files in Google Drive
drivethru u [arguments] | upload [arguments]   :: upload a file to Google Drive
""");
  exit(0);
}

dynamic listFiles(ClientId clientId, List<String> scopes) {
  clientViaUserConsent(clientId, scopes, prompt)
      .then((AuthClient client) async {
    var driveApi = drive_v3.DriveApi(client);

    try {
      drive_v3.FileList fileList = await driveApi.files.list();
      for (var file in fileList.files!) {
        print("File name: ${file.name}");
      }
    } catch (e) {
      // ignore: prefer_interpolation_to_compose_strings
      error("error" + e.toString());
    }

    client.close();
  });
}

dynamic uploadFile(
    ClientId clientId, List<String> scopes, String name, String path) async {
  clientViaUserConsent(clientId, scopes, prompt)
      .then((AuthClient client) async {
    var driveApi = drive_v3.DriveApi(client);

    var file = drive_v3.File();
    file.name = name;

    var fileToUpload = File(path);
    var media =
        drive_v3.Media(fileToUpload.openRead(), fileToUpload.lengthSync());

    var request = await driveApi.files.create(file, uploadMedia: media);

    print('Uploaded file ID: ${request.id}');

    client.close();
  });
}
