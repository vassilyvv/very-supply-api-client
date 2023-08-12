import '../company/company.dart';
import '../translatable_model.dart';

class MenuSection extends TranslatableModel {
  late Company? company;
  List<MenuSection> children = [];
  MenuSection? parent;

  MenuSection.fromJson(json, {this.parent}) : super.fromJson(json) {
    company =
        json['company'] == null ? null : Company.fromJson(json['company']);
    for (int i = 0; i < json['children'].length; ++i) {
      children.add(MenuSection.fromJson(json['children'][i], parent: this));
    }
  }

  @override
  String toString() {
    return 'MenuSection{id: $id, company: $company}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuSection &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
