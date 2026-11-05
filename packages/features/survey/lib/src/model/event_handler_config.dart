enum EventHandlerScope { global, screen }

class EventHandlerConfig {
  const EventHandlerConfig({required this.type, required this.scope, this.screenKeys});

  final String type;
  final EventHandlerScope scope;
  final List<String>? screenKeys;

  bool shouldHandle(String currentScreenKey) {
    return switch (scope) {
      EventHandlerScope.global => true,
      EventHandlerScope.screen => _matchesScreen(currentScreenKey),
    };
  }

  bool _matchesScreen(String currentScreenKey) {
    final keys = screenKeys;
    if (keys == null || keys.isEmpty) {
      return true;
    }
    return keys.contains(currentScreenKey);
  }
}
