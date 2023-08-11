import '../base_model.dart';
import '../logistics/node.dart';
import 'transaction_template.dart';

class Offer extends BaseModel {
  late Node? incomeNode;
  late Node? outcomeNode;
  late TransactionTemplate incomeTransactionTemplate;
  late TransactionTemplate outcomeTransactionTemplate;
  double rating = 0;
  double? userRating;
  late int reserve;

  Offer.fromJson(json) : super.fromJson(json) {
    incomeNode =
    json["income_node"] == null ? null : Node.fromJson(json["income_node"]);
    outcomeNode =
    json["outcome_node"] == null ? null : Node.fromJson(json["outcome_node"]);
    rating = json['rating'].toDouble();
    reserve = json['reserve'];
    userRating = json['userRaging'];
    incomeTransactionTemplate =
        TransactionTemplate.fromJson(json['income_transaction_template']);
    outcomeTransactionTemplate =
        TransactionTemplate.fromJson(json['outcome_transaction_template']);
  }

  get images => outcomeTransactionTemplate.entries.fold(<String>[], (images, entry) => images + entry.asset.images);

  get assetNames => outcomeTransactionTemplate.entries.fold(<String>[], (assetNames, entry) => assetNames + [entry.asset.translations['en']!['name']!]);

  get prices => incomeTransactionTemplate.entries.map((price) => "${price.amount} ${price.asset.translations['en']!['name']!}").toList().join(', ');

  @override
  String toString() {
    return 'Offer{id: $id, incomeNode: $incomeNode, outcomeNode: $outcomeNode, incomeTransactionTemplate: $incomeTransactionTemplate, outcomeTransactionTemplate: $outcomeTransactionTemplate}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Offer && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}