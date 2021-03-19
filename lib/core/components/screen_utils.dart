import 'package:flutter/material.dart';

///
/// Утилиты для работы с экраном
///
class ScreenUtils {
  // Контекст приложения
  static BuildContext? _context;

  ///
  /// Установка контекста
  ///
  static setContext(BuildContext context) {
    _context = context;
  }

  ///
  /// Получение размера
  ///
  static Size getSize() {
    assert(_context != null);

    return MediaQuery.of(_context!).size;
  }
}

///
/// Расширение для получения соотношения от экрана
///
extension ScreenSizeExtention on num {
  /// Получить процент от ширины экрана
  get sw => ScreenUtils.getSize().width * this;

  /// Получить процент от высоты экрана
  get sh => ScreenUtils.getSize().height * this;

  /// Получить число пикселей в зависимости от разрешения
  /// Scale point
  double get sp => this.sw * 0.001;

  /// Получить виртуальную ширину
  /// (фактическую ширину экрана вне зависимости от ориентации)
  double get vsw => ScreenUtils.getSize().width > ScreenUtils.getSize().height
      ? this.sw
      : this.sh;

  /// Получить виртуальную высоту
  /// (фактическую длину экрана вне зависимости от ориентации)
  double get vsh => ScreenUtils.getSize().width < ScreenUtils.getSize().height
      ? this.sh
      : this.sw;
}
