import '../base_model.dart';
import '../trade/offer.dart';
import 'asset.dart';
import 'package:collection/collection.dart';

class MenuSectionEntry extends BaseModel {
  List<Offer> offers = [];
  late String? favoriteEntry;

  MenuSectionEntry.fromJson(json) : super.fromJson(json) {
    favoriteEntry = json['favorite_entry'];
    for (int i = 0; i < json['offers'].length; ++i) {
      offers.add(Offer.fromJson(json['offers'][i]));
    }
  }

  get images => offers.fold([], (value, element) => value + element.images);

  Set<Offer> getFilteredOffers(Map<String, String> selectedOptions) {
    Set<Offer> result = Set.from(offers);
    selectedOptions.forEach((key, value) {
      result = result.where((offer) {
        Asset asset = offer.outcomeTransactionTemplate.entries[0].asset;
        return asset.translations['en']![key] == value ||
            asset.translations['']![key] == value;
      }).toSet();
    });
    return result;
  }

  get assetNames =>
      offers.fold([], (value, element) => value + element.assetNames);

  Set<Map<String, String>> availableFieldCombinations() {
    Set<Map<String, String>> result = {};
    for (Offer offer in offers) {
      if (offer.outcomeTransactionTemplate.entries.length == 1) {
        Map<String, String> combinedValues = {};
        for (var transactionTemplateEntry
            in offer.outcomeTransactionTemplate.entries) {
          Asset asset = transactionTemplateEntry.asset;
          if (asset.translations.containsKey('en')) {
            combinedValues.addAll(asset.translations['en']!);
          }
          if (asset.translations.containsKey('')) {
            combinedValues.addAll(asset.translations['']!);
          }
          result.add(combinedValues);
          if (result.length > 1) {
            combinedValues
                .removeWhere((key, value) => !result.first.keys.contains(key));
          }
        }
      }
    }
    Set<String> keysWithSameValue = {};
    //remove translations that are not exist for some assets
    for (Map<String, String> translationsMapToCompare in result) {
      List<Map<String, String>> translationMapsToCompareWith = result
          .where((translationsMap) =>
              !DeepCollectionEquality().equals(translationsMap, translationsMapToCompare))
          .toList();
      for (MapEntry<String, String> entry in translationsMapToCompare.entries) {
        if (translationMapsToCompareWith
            .where((translationMapToCompareWith) =>
                translationMapToCompareWith[entry.key] != entry.value)
            .isEmpty) {
          keysWithSameValue.add(entry.key);
        }
      }
    }
    for (Map<String, String> translationsMap in result) {
      translationsMap
          .removeWhere((key, value) => keysWithSameValue.contains(key));
    }
    return result;
  }

  @override
  String toString() {
    return 'MenuSectionEntry{id: $id}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuSectionEntry &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
