class LeaderBoardModel {
  String? name;
  int? count;

  LeaderBoardModel({this.name, this.count});

  LeaderBoardModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['count'] = this.count;
    return data;
  }
}
