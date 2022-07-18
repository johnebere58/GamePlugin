# Game Plugin

[![CI](https://github.com/johnebere58/gameplugin/actions/workflows/main.yml/badge.svg)](https://github.com/johnebere58/gameplugin/actions/workflows/main.yml)

A simple library to add simple fun games to your app
 
<p>
    <img src="https://github.com/johnebere58/gameplugin/blob/master/screenshots/demo1.gif" width="200px" height="400px" hspace="20"/>
    <img src="https://github.com/johnebere58/gameplugin/blob/master/screenshots/sample1.png" width="200px" height="400px" hspace="20"/>
    <img src="https://github.com/johnebere58/gameplugin/blob/master/screenshots/sample2.png" width="200px" height="400px" hspace="20"/>
    <img src="https://github.com/johnebere58/gameplugin/blob/master/screenshots/sample3.png" width="200px" height="400px" hspace="20"/>
   </p>

- [x] 2 Ball Game
- [x] 3 Ball Game
- [x] 4 Ball Game
- [x] 8 Ball Game

## Installation
To use this plugin, add `gameplugin` as a dependency in your pubspec.yaml file.

```
dependencies:
  flutter:
    sdk: flutter

gameplugin:
  git:
    url: git://github.com/johnebere58/gameplugin.git
    ref: master # branch name

```

## Get Started

Add this following to the `initState` method of your widget
Instantiate the game instance by call `GameManager.initialize()`
```
  @override
  void initState() {
    GameManager.initialize();
    super.initState();
  }
```

Then commence the game by calling
```
  GameManager().launchGame(context,);
```

## Optional

You can choose to launch game with custom settings by adding `gameSettings`
```
  GameManager()
        .launchGame(context,
                gameSettings: GameSettings(
                  ballCount: BallCount.four,
                  ballShape: BallShape.circle,
                  ballSize: 50.0,
                  gameSpeed: GameSpeed.normal
                ));
```

[![Buy Me A Coffee](https://bmc-cdn.nyc3.digitaloceanspaces.com/BMC-button-images/custom_images/orange_img.png "Buy Me A Coffee")](https://www.buymeacoffee.com/johnebere58 "Buy Me A Coffee")

## Getting Started
 
This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter development, view the
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

