import 'package:fivoza_learning/core/errors/exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class OnBoardingLocalDataSource {
  Future<void> cacheFirstTimer();
  Future<bool> checkIfUserIsFirstTimer();
}

const kFirstTimerKey = "first_timer";

class OnBoardingLocalDataSourceImpl implements OnBoardingLocalDataSource {
  final SharedPreferences _prefs;

  OnBoardingLocalDataSourceImpl(this._prefs);
  @override
  Future<void> cacheFirstTimer() async {
    try {
      await _prefs.setBool(kFirstTimerKey, false);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<bool> checkIfUserIsFirstTimer() async {
    try {
      return _prefs.getBool(kFirstTimerKey) ?? true;
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }
}
