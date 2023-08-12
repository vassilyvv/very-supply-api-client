import '../base_model.dart';
import '../trade/order_entry.dart';
import 'node.dart';
import 'transaction_entry.dart';

class Transaction extends BaseModel {
  late Node source;
  late Node target;
  List<TransactionEntry> entries = [];
  late OrderEntry orderEntry;
  late OrderEntry orderEntryToPayFor;
  late OrderEntry orderEntryToCompensateFor;

  Transaction.fromJson(json) : super.fromJson(json) {
    source = Node.fromJson(json['source']);
    target = Node.fromJson(json['target']);
    for (int i = 0; i < json['entries'].length; ++i) {
      entries.add(TransactionEntry.fromJson(json['children'][i]));
    }
    orderEntry = OrderEntry.fromJson(json['order_entry']);
    orderEntryToPayFor = OrderEntry.fromJson(json['order_entry_to_pay_for']);
    orderEntryToCompensateFor = OrderEntry.fromJson(json['order_entry_to_compensate_for']);
  }

  @override
  String toString() {
    return 'Transaction{id: $id, source: $source, target: $target, entries: $entries, orderEntry: $orderEntry, orderEntryToPayFor: $orderEntryToPayFor, orderEntryToCompensateFor: $orderEntryToCompensateFor}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Transaction && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}