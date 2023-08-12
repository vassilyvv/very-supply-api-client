

import '../translatable_model.dart';

class Company extends TranslatableModel {
  Company.fromJson(json) : super.fromJson(json);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Company && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
