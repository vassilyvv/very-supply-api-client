import 'base_model.dart';

class TranslatableModel extends BaseModel {
  Map<String, Map<String, String>> translations =
      <String, Map<String, String>>{};

  TranslatableModel.fromJson(json) : super.fromJson(json) {
    json['translations']
        .entries
        .toList()
        .forEach((languageToTranslationsEntry) {
      if (!translations.containsKey(languageToTranslationsEntry.key)) {
        translations[languageToTranslationsEntry.key] = {};
      }
      languageToTranslationsEntry.value.entries
          .forEach((fieldNameToValueEntry) {
        if (fieldNameToValueEntry.value is String) {
          translations[languageToTranslationsEntry.key]![
              fieldNameToValueEntry.key] = fieldNameToValueEntry.value;
        } else {
          for (MapEntry<String, dynamic> choiceTranslations
              in fieldNameToValueEntry.value['translations'].entries) {
            if (!translations.containsKey(choiceTranslations.key)) {
              translations[choiceTranslations.key] = {};
            }
            translations[choiceTranslations.key]![fieldNameToValueEntry.key] =
                fieldNameToValueEntry.value['translations']
                    [choiceTranslations.key]['name'];
          }
        }
      });
    });
  }
}
