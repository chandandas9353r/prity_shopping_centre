import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage{
  SharedPreferences? _sharedPreferences;

  LocalStorage(){
    _initialise;
  }

  Future<void> get _initialise async {
    if(_sharedPreferences != null) return;
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<List<String>?> get getItems async {
    List<String>? items = _sharedPreferences?.getStringList('item');
    return items;
  }
}