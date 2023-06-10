import 'dart:io';

import 'package:yaml/yaml.dart';

final String locale = "en";
final dynamic localeFile =
    loadYaml(File("i18n/$locale.yaml").readAsStringSync());

final Map<String, String> colors = {
  "red": "\x1B[31m",
  "green": "\x1B[32m",
  "yellow": "\x1B[33m",
  "blue": "\x1B[34m",
  "reset": "\x1B[0m"
};

void warn(String localeKey) {
  print("");
  print(
      "${colors["yellow"]}[ WARNING ] ${colors["reset"]}${localeFile[localeKey]}");
}

void error(String localeKey) {
  print("");
  print("${colors["red"]}[ ERROR ] ${colors["reset"]}${localeFile[localeKey]}");
}

void info(String localeKey) {
  print("");
  print("${colors["blue"]}[ INFO ] ${colors["reset"]}${localeFile[localeKey]}");
}
