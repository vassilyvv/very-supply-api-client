import '../base_model.dart';
import '../logistics/node.dart';
import 'offer.dart';

class OrderEntry extends BaseModel {
  late Node incomeNode;
  late Node outcomeNode;
  late Offer offer;
  late int amount;

  Offer? offerObject;

  OrderEntry.fromJson(json) : super.fromJson(json) {
    incomeNode = Node.fromJson(json["income_node"]);
    outcomeNode = Node.fromJson(json["outcome_node"]);
    offer = json['offer'];
    amount = json["amount"];
  }

  @override
  String toString() {
    return 'OrderEntry{id: $id, incomeNode: $incomeNode, outcomeNode: $outcomeNode, offer: $offer, offerObject: $offerObject, amount: $amount}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is OrderEntry && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}