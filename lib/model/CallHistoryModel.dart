class CallHistoryModel {
  bool? status;
  int? count;
  List<CallHistory>? call_history;

  CallHistoryModel({this.status, this.count, this.call_history});

  CallHistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    count = json['count'];
    if (json['data'] != null) {
      call_history = <CallHistory>[];
      json['data'].forEach((v) {
        call_history!.add(new CallHistory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['count'] = this.count;
    if (this.call_history != null) {
      data['data'] = this.call_history!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CallHistory {
  String? number;
  String? dateAdded;
  String? callStatus;
  String? calledStatus;
  String? callDuration;
  String? latestUpdate;

  CallHistory(
      {this.number,
        this.dateAdded,
        this.callStatus,
        this.calledStatus,
        this.callDuration,
        this.latestUpdate});

  CallHistory.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    dateAdded = json['date_added'];
    callStatus = json['call_status'];
    calledStatus = json['called_status'];
    callDuration = json['call_duration'];
    latestUpdate = json['latest_update'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.number;
    data['date_added'] = this.dateAdded;
    data['call_status'] = this.callStatus;
    data['called_status'] = this.calledStatus;
    data['call_duration'] = this.callDuration;
    data['latest_update'] = this.latestUpdate;
    return data;
  }
}
