class BaseModel {
  late String id;

  BaseModel.fromJson(json) {
    id = json['id'];
  }
}
