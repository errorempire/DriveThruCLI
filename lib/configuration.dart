import 'dart:convert';
import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:drive_thru/responses.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:json2yaml/json2yaml.dart';
import 'package:yaml/yaml.dart';

final String homeDir = Platform.isWindows
    ? Platform.environment["USERPROFILE"]!
    : Platform.environment["HOME"]!;

final String configDir = "$homeDir/.config/DriveThruCLI";
final String configFile = "$configDir/credentials.yaml";

Map<String, String?> loadEnv() {
  DotEnv env = DotEnv()..load();
  return {"clientId": env["CLIENT_ID"], "clientSecret": env["CLIENT_SECRET"]};
}

void checkConfiguration() {
  Directory(configDir).createSync(recursive: true);

  if (!File(configFile).existsSync()) {
    error("missingConfiguration");
    exit(1);
  }
}

void configure(String clientId, String clientSecret, {String mode = "prd"}) {
  File(configFile).writeAsStringSync(json2yaml(json.decode(json.encode({
    'mode': mode,
    "credentials": {
      'clientId': clientId,
      'clientSecret': clientSecret,
    }
  }))));
}

ClientId credentials() {
  YamlMap configuration = loadYaml(File(configFile).readAsStringSync());

  if (configuration["mode"] == "dev") {
    return ClientId(loadEnv()["clientId"]!, loadEnv()["clientSecret"]);
  }

  return ClientId(configuration["credentials"]["clientId"]!,
      configuration["credentials"]["clientSecret"]);
}
