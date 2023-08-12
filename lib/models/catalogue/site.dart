import 'package:collection/collection.dart';

import '../base_model.dart';

class Site extends BaseModel {
  String? domain;
  String? name;

  Site.fromJson(json) : super.fromJson(json) {
    domain = json['domain'];
    name = json['name'];
  }

  @override
  String toString() {
    return 'Site{id: $id, domain: $domain, name: $name}';
  }

  String formatString() {
    return [name, domain].whereNotNull().join(": ");
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Site && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}