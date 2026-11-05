import 'tracker.dart';

class AnalyticsEvent {
  const AnalyticsEvent({required this.name, this.params, this.trackers});

  final String name;
  final Map<String, dynamic>? params;
  final List<Tracker>? trackers;

  @override
  String toString() {
    final sb = StringBuffer()
      ..write('{')
      ..write('name : $name,');

    if (trackers?.isNotEmpty ?? false) {
      sb.write(' trackers : [${trackers?.join(",")},]');
    }

    if (params?.isNotEmpty ?? false) {
      sb.write(
        ' params : [${params?.entries.map((entry) => "${entry.key} : ${entry.value}").join(",")}]',
      );
    }
    sb.write('}');
    return sb.toString();
  }
}
