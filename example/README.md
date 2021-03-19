# Diz Core Example

## How to use

1. Import package

```dart
import 'package:diz_flutter_core/diz_core.dart';
```

2. Use some classes you want

See small example below

```dart
import 'package:diz_flutter_core/diz_core.dart';

/// Some history service
class HistoryService {
    /// Some method
    void add(String key, String value) async {
        final LocalStroage ls = new LocalStorage('hisotry');
        await ls.addItem<String>(key, value);
    }
}
```