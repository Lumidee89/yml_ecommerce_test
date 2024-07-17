class ShippingMethodModel {
  int? id;
  int? creatorId;
  String? creatorType;
  String? title;
  double? cost;
  String? duration;
  String? createdAt;
  String? updatedAt;

  ShippingMethodModel(
      {this.id,
        this.creatorId,
        this.creatorType,
        this.title,
        this.cost,
        this.duration,
        this.createdAt,
        this.updatedAt});



  ShippingMethodModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    creatorId = json['creator_id'];
    creatorType = json['creator_type'];
    title = json['title'];
    if(json['cost'] != null){
      try{
        cost = json['cost'].toDouble();
      }catch(e){
        cost = double.parse(json['cost'].toString());
      }
    }

    duration = json['duration'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

}
