import 'package:core/core.dart';

import 'completion_handler.dart';
import 'completion_handler_type.dart';

class CompletionHandlerProvider {
  CompletionHandlerProvider(this._di, this._logger);

  final ServiceLocator _di;
  final Logger _logger;

  CompletionHandler? getCompletionHandler(String? type) {
    return _getHandler(_resolveType(type));
  }

  CompletionHandler? getCloseHandler(String? type) {
    return _getHandler(_resolveType(type));
  }

  CompletionHandler? _getHandler(CompletionHandlerType handlerType) {
    try {
      return _di.get<CompletionHandler>(instanceName: handlerType.id);
    } catch (e) {
      _logger.w('[CompletionHandlerProvider] Handler not found: ${handlerType.id}');
      return null;
    }
  }

  CompletionHandlerType _resolveType(String? type) {
    return CompletionHandlerType.values.firstWhere(
      (e) => e.id == type,
      orElse: () => CompletionHandlerType.generic,
    );
  }
}
