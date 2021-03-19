// Dart библиотеки
import 'dart:async';

///
/// Глобальная шина сообщений
///
/// * [E] - тип событий, обычно это enum
/// * [T] - тип сообщения, который будет приниматься/отправляться по каналу
/// * Каналы создаются автоматом при первой подписке/отправке сообщений
///
class GlobalBus<E> {
  static final Map<String, Map<String, StreamController<dynamic>>> _cache =
      <String, Map<String, StreamController<dynamic>>>{};

  final List<StreamSubscription<dynamic>> _subscribers =
      <StreamSubscription<dynamic>>[];

  dynamic _topic;

  ///
  /// Проверяет, есть ли нужный топик в кеше
  ///
  /// * Если кеша нет, то создается новый топик
  /// * Если кеш есть, то возвращается кеш
  ///
  GlobalBus() {
    final String eName = E.toString();

    _topic = _cache[eName] != null
        ? _cache[eName]
        : _cache[eName] = Map<String, StreamController<dynamic>>();
  }

  ///
  /// Возвращает [StreamController] (канал) из текущего топика
  ///
  /// [topic] - идентификатор топика, обычно значение enum [E]
  ///
  StreamController<dynamic> _getStreamController<T>(E topic, String id) {
    final String fullTopic = topic.toString() + id;

    return _topic[fullTopic] != null
        ? _topic[fullTopic]
        : _topic[fullTopic] = StreamController<T>.broadcast();
  }

  ///
  /// Публикует сообщение
  ///
  /// [topic] - идентификатор топика, обычно значение enum [E]
  /// [data] - данные типа [T], отправляемые по каналу
  /// [id] - индивидуальный индетификатор подписчика,
  /// для возможности изолирования
  ///
  void publish<T>(E topic, T data, {String id = ''}) {
    _getStreamController<T>(topic, id).add(data);
  }

  ///
  /// Подписывается на топик
  ///
  /// [topic] - идентификатор топика, обычно значение enum [E]
  /// [callback] - функция-подписчик, которая будет вызвана
  /// при получении сообщения
  /// * Тип сообщения устанавливается типом [T]
  /// [id] - индивидуальный индетификатор подписчика,
  /// для возможности изолирования [String]
  ///
  void subscribe<T>(E topic, void callback(T data), {String id = ''}) {
    _subscribers.add(
      _getStreamController(topic, id)
          .stream
          .listen((dynamic data) => callback(data)),
    );
  }

  ///
  /// Отписывает всех подписчиков
  ///
  void unsubscribeAll() {
    _subscribers.forEach((StreamSubscription<dynamic> sbr) {
      sbr.cancel();
    });
  }
}
