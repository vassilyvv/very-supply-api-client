import '../base_model.dart';
import '../catalogue/asset.dart';

class TransactionTemplateEntry extends BaseModel {
  late int amount;
  late Asset asset;

  TransactionTemplateEntry.fromJson(json) : super.fromJson(json) {
    amount = json['amount'];
    asset = Asset.fromJson(json['asset']);
  }
}