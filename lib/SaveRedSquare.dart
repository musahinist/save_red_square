import 'dart:async';
import 'dart:ui';

import 'package:flame/game/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:saveredsquare/data/DataHolder.dart';
import 'package:saveredsquare/screens/BaseScreen.dart';
import 'package:saveredsquare/screens/LoadingScreen.dart';
import 'package:saveredsquare/screens/MenuScreen.dart';
import 'package:saveredsquare/screens/PlayGroundScreen.dart';
import 'package:saveredsquare/screens/ScoreScreen.dart';
import 'package:saveredsquare/screens/ScreenState.dart';

SaveRedSquare saveRedSquare = SaveRedSquare();

class SaveRedSquare extends Game with TapDetector {
  ScreenState _screenState;
  BaseScreen _menuScreen;
  BaseScreen _playGroundScreen;
  BaseScreen _scoreScreen;
  BaseScreen _loadingScreen;

  Function _fnUpdate;

  Size _size = Size(0, 0);

  SaveRedSquare() {
    _screenState = ScreenState.kLoadingScreen;

    _menuScreen = MenuScreen();
    _playGroundScreen = PlayGroundScreen();
    _scoreScreen = ScoreScreen();
    _loadingScreen = LoadingScreen();

    _fnUpdate = _init;
  }
  @override
  void render(Canvas canvas) {
    _getActiveScreen()?.render(canvas);
  }

  @override
  void update(double t) {
    _fnUpdate();
  }

  @override
  void resize(Size size) {
    _menuScreen?.resize(size);
    _playGroundScreen?.resize(size);
    _scoreScreen?.resize(size);
    _loadingScreen?.resize(size);

    _size = size;
  }

  void onTapDown(TapDownDetails details) {
    _getActiveScreen()?.onTapDown(details);
  }

  BaseScreen _getActiveScreen() {
    switch (_screenState) {
      case ScreenState.kLoadingScreen:
        return _loadingScreen;
      case ScreenState.kMenuScreen:
        return _menuScreen;
      case ScreenState.kPlayGroundScreen:
        return _playGroundScreen;
      case ScreenState.kScoreScreen:
        return _scoreScreen;
      default:
        return _menuScreen;
    }
  }

  void switchScreen(ScreenState newScreen) {
    switch (newScreen) {
      case ScreenState.kLoadingScreen:
        _setState(newScreen);
        break;
      case ScreenState.kScoreScreen:
        _scoreScreen = ScoreScreen();
        Timer(new Duration(seconds: 3), () {
          _scoreScreen.resize(_size);
          _setState(newScreen);
        });
        break;
      case ScreenState.kPlayGroundScreen:
        _playGroundScreen = PlayGroundScreen();
        _playGroundScreen.resize(_size);
        Timer(new Duration(milliseconds: 10), () {
          _setState(newScreen);
        });
        break;
      case ScreenState.kMenuScreen:
        _setState(newScreen);
        break;
      default:
        _setState(newScreen);
    }
  }

  void _setState(ScreenState newState) {
    this._screenState = newState;
  }

  Future<void> _init() async {
    _fnUpdate = _update;

    Util flameUtil = Util();
    await flameUtil.fullScreen();
    await flameUtil.setOrientation(DeviceOrientation.portraitDown);
    dataHolder.loadData();
  }

  void _update() {
    _getActiveScreen()?.update();
  }
}
