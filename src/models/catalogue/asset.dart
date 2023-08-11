import '../translatable_model.dart';
import 'asset_type.dart';


class Asset extends TranslatableModel {
  late String barcode;
  late AssetType assetType;
  List<String> images = [];

  Asset.fromJson(json) : super.fromJson(json) {
    barcode = json['barcode'];
    assetType = AssetType.fromJson(json['asset_type']);
    for (int i = 0; i < json['images'].length; ++i) {
      images.add(json['images'][i]);
    }
  }

  @override
  String toString() {
    return 'Asset{id: $id, barcode: $barcode, assetType: $assetType, translations: $translations}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Asset && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}