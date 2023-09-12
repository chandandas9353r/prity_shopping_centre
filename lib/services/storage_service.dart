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

  List<String>? get getItems {
    List<String>? items = _sharedPreferences?.getStringList('item');
    return items;
  }
}