import '../base_model.dart';

class MenuSectionEntriesListEntry extends BaseModel {
  MenuSectionEntriesListEntry.fromJson(json) : super.fromJson(json);

  @override
  String toString() {
    return 'MenuSectionEntriesListEntry{id: $id}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuSectionEntriesListEntry &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
