import '../base_model.dart';
import '../catalogue/asset.dart';

class TransactionEntry extends BaseModel {
  late Asset asset;
  late int amount;

  TransactionEntry.fromJson(json) : super.fromJson(json) {
    asset = Asset.fromJson(json['asset']);
    amount = json["amount"];
  }

  @override
  String toString() {
    return 'TransactionEntry{id: $id, asset: $asset, amount: $amount}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is TransactionEntry && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}