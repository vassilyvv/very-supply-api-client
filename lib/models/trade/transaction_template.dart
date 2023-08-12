import '../base_model.dart';
import 'transaction_template_entry.dart';

class TransactionTemplate extends BaseModel {
  List<TransactionTemplateEntry> entries = [];

  TransactionTemplate.fromJson(json) : super.fromJson(json) {
    json['entries'].forEach((entryJson) {
      entries.add(TransactionTemplateEntry.fromJson(entryJson));
    });
  }
}