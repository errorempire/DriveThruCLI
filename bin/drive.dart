import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/drive/v3.dart' as drive_v3;
import 'package:prompts/prompts.dart' as prompts;

var env = DotEnv()..load();

final ClientId clientId = ClientId(env["KEY"]!, env["SECRET"]);
final List<String> scopes = [drive_v3.DriveApi.driveScope];

void main(List<String> arguments) async {
  for (var argument in arguments) {
    if (argument == "ls") {
      listFiles(clientId, scopes);
    } else if (argument == "mkdir") {
      create(clientId, scopes, prompts.get('File name'));
    }
  }
}

void prompt(String url) {
  print("Please go to the following URL and grant access:");
  print("  => $url");
}

dynamic create(ClientId clientId, List<String> scopes, String name) {
  clientViaUserConsent(clientId, scopes, prompt)
      .then((AuthClient client) async {
    var driveApi = drive_v3.DriveApi(client);

    var file = drive_v3.File();
    file.name = name;

    var fileToUpload = File('./pubspec.yaml');
    var media =
        drive_v3.Media(fileToUpload.openRead(), fileToUpload.lengthSync());

    var request = await driveApi.files.create(
      file,
      uploadMedia: media,
      // uploadOptions: drive_v3
    );

    print('Uploaded file ID: ${request.id}');

    client.close();
  });
}

dynamic listFiles(ClientId clientId, List<String> scopes) {
  clientViaUserConsent(clientId, scopes, prompt)
      .then((AuthClient client) async {
    var driveApi = drive_v3.DriveApi(client);

    try {
      var fileList = await driveApi.files.list();
      for (var file in fileList.files!) {
        print('File name: ${file.name}, File id: ${file.id}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }

    client.close();
  });
}
