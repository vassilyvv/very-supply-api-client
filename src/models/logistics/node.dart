
import '../auth/user.dart';
import '../base_model.dart';
import '../company/company.dart';

class Node extends BaseModel {
  User? user;
  Company? company;
  late String internalId;

  Node.fromJson(json) : super.fromJson(json) {
    company =
        json['company'] == null ? null : Company.fromJson(json['company']);
    user = json['user'] == null ? null : User.fromJson(json['user']);
    internalId = json['internal_id'];
  }

  @override
  String toString() {
    return 'Node{id: $id, company: $company, user: $user, internalId: $internalId, }';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Node &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          internalId == other.internalId;

  @override
  int get hashCode => id.hashCode ^ internalId.hashCode;
}
