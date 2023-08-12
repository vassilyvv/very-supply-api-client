
import 'order_entry.dart';

class Order {
  late String? id;
  late List<OrderEntry> entries;

  Order.fromJson(json) {
    id = json['id'];
    entries = json['entries'] == null
        ? []
        : (json['entries'] as List<dynamic>).map((entry) => OrderEntry.fromJson(entry)).toList();
  }

  @override
  String toString() {
    return 'Order{id: $id, entries: $entries}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Order && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}