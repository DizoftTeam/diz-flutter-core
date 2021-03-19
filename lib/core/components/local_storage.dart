// Dart библиотеки
import 'dart:async';
import 'dart:io';
import 'dart:convert';

// Сторонние зависимости
import 'package:path_provider/path_provider.dart';

///
/// Компонент для работы с постоянным хранилищем
///
class LocalStorage {
  ///
  /// Имя базы данных
  ///
  /// По своей сути - имя файла, в котором будет хранится JSON объект
  ///
  final String dbName;

  ///
  /// Промежуточный слой
  ///
  /// Данные хранятся здесь, после чего записываются в файл
  ///
  Map<String, dynamic> _cache = new Map<String, dynamic>();

  ///
  /// Индикатор что компонент готов к работе
  ///
  Completer<bool> _cReady = new Completer<bool>();

  ///
  /// Конструктор
  ///
  LocalStorage(this.dbName) : assert(dbName.isNotEmpty) {
    _cReady.complete(new Future<bool>(() async {
      await _init();

      return true;
    }));
  }

  ///
  /// Получение элемента по ключу
  ///
  /// Указывать тип данных [T] - обязательно
  /// Если данных нет - то вернется [Null]
  ///
  Future<T> getItem<T>(String key) async {
    await _cReady.future;

    return _cache[key] ?? null;
  }

  ///
  /// Установка данных в кеш
  ///
  Future<void> setItem<T>(String key, T value) {
    _cache[key] = value;

    return _update();
  }

  ///
  /// Удаление данных по ключу [key]
  ///
  Future<File> removeItem(String key) async {
    await _cReady.future;

    if (_cache.containsKey(key)) {
      _cache.remove(key);
    }

    return await _update();
  }

  ///
  /// Удаление всех ключей
  ///
  Future<File> removeAll() async {
    await _cReady.future;

    _cache.clear();

    return await _update();
  }

  ///
  /// Получение всех данных
  ///
  Future<Map<String, dynamic>> all() async {
    await _cReady.future;

    return _cache;
  }

  ///
  /// Инициализация компонента
  ///
  Future<void> _init() async {
    final File file = await _localFile;

    _cache = json.decode(
      await file.readAsString(),
    );
  }

  ///
  /// Обновление данных в файле базы данных
  ///
  Future<File> _update() async {
    return (await _localFile).writeAsString(
      json.encode(_cache),
    );
  }

  ///
  /// Получение указателя на файл
  ///
  Future<File> get _localFile async {
    final Directory dir = await _localPath;
    final String path = dir.path;

    final File result = File('$path/$dbName.json');

    final bool exists = await result.exists();

    if (!exists) {
      await result.create();
      await result.writeAsString('{}');
    }

    return result;
  }

  ///
  /// Получение папки, где будут храниться данные
  ///
  Future<Directory> get _localPath async {
    return await getApplicationDocumentsDirectory();
  }
}
