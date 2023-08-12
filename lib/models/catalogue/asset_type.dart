import '../base_model.dart';
import '../company/company.dart';

class AssetType extends BaseModel {
  late Company? company;

  AssetType.fromJson(json) : super.fromJson(json) {
    company =
        json['company'] == null ? null : Company.fromJson(json['company']);
  }

  @override
  String toString() {
    return 'AssetType{id: $id, company: $company}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssetType && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
