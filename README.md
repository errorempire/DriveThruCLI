# DriveThruCLI

- [DriveThruCLI](#drivethrucli)
  - [Local Usage](#local-usage)
  - [Global Usage](#global-usage)
  - [Uninstall](#uninstall)

## Local Usage

```sh
dart pub get
```

```sh
dart run bin/drive_thru.dart
```
## Global Usage

```sh
dart pub global activate -sgit git@github.com:errorempire/DriveThruCLI.git
```

```sh
drivethru
```

Please make sure if you have the following line in your `.bashrc` / `.zshrc` / `config.fish`

```
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

## Uninstall

```sh
dart pub global deactivate drive_thru
```