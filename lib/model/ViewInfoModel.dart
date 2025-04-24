/// ─────────────────────────────────────────────────────────────────────────────
/// view_info_model.dart
/// ─────────────────────────────────────────────────────────────────────────────

class ViewInfoModel {
  final bool? status;
  final List<ViewInfo>? data;

  const ViewInfoModel({this.status, this.data});

  factory ViewInfoModel.fromJson(Map<String, dynamic> json) => ViewInfoModel(
    status: json['status'],
    data: (json['data'] as List<dynamic>?)
        ?.map((e) => ViewInfo.fromJson(e))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    if (data != null) 'data': data!.map((e) => e.toJson()).toList(),
  };
}

/// ─────────────────────────────────────────────────────────────────────────────
/// SINGLE RECORD
/// ─────────────────────────────────────────────────────────────────────────────
class ViewInfo {
  final int? id;
  final String? number;
  final int? staffId;
  final String? dateAdded;
  final String? callStatus;
  final String? calledStatus;
  final String? name;
  final String? followUpDate;
  final String? remarks;
  final String? dealStatus;
  final dynamic dealAmount;
  final int? totalCalls;
  final String? lastCalledDate;
  final int? leadStageId;
  final String? dealClosureDate;
  final int? callDuration;
  final int? fId;
  final StageName? stageName;
  final LatestFollowupDetail? latestFollowupDetail;

  const ViewInfo({
    this.id,
    this.number,
    this.staffId,
    this.dateAdded,
    this.callStatus,
    this.calledStatus,
    this.name,
    this.followUpDate,
    this.remarks,
    this.dealStatus,
    this.dealAmount,
    this.totalCalls,
    this.lastCalledDate,
    this.leadStageId,
    this.dealClosureDate,
    this.callDuration,
    this.fId,
    this.stageName,
    this.latestFollowupDetail,
  });

  factory ViewInfo.fromJson(Map<String, dynamic> json) => ViewInfo(
    id: json['id'],
    number: json['number'],
    staffId: json['staff_id'],
    dateAdded: json['date_added'],
    callStatus: json['call_status'],
    calledStatus: json['called_status'],
    name: json['name'],
    followUpDate: json['follow_up_date'],
    remarks: json['remarks'],
    dealStatus: json['deal_status'],
    dealAmount: json['deal_amount'],
    totalCalls: json['total_calls'],
    lastCalledDate: json['last_called_date'],
    leadStageId: json['lead_stage_id'],
    dealClosureDate: json['deal_closure_date'],
    callDuration: json['call_duration'],
    fId: json['f_id'],
    stageName:
    json['stage_name'] != null ? StageName.fromJson(json['stage_name']) : null,
    latestFollowupDetail: json['latest_followup_detail'] != null
        ? LatestFollowupDetail.fromJson(json['latest_followup_detail'])
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'number': number,
    'staff_id': staffId,
    'date_added': dateAdded,
    'call_status': callStatus,
    'called_status': calledStatus,
    'name': name,
    'follow_up_date': followUpDate,
    'remarks': remarks,
    'deal_status': dealStatus,
    'deal_amount': dealAmount,
    'total_calls': totalCalls,
    'last_called_date': lastCalledDate,
    'lead_stage_id': leadStageId,
    'deal_closure_date': dealClosureDate,
    'call_duration': callDuration,
    'f_id': fId,
    if (stageName != null) 'stage_name': stageName!.toJson(),
    if (latestFollowupDetail != null)
      'latest_followup_detail': latestFollowupDetail!.toJson(),
  };
}

/// ─────────────────────────────────────────────────────────────────────────────
/// NESTED OBJECTS
/// ─────────────────────────────────────────────────────────────────────────────
class StageName {
  final int? id;
  final String? stageName;
  final String? createdAt;
  final int? createdBy;

  const StageName({this.id, this.stageName, this.createdAt, this.createdBy});

  factory StageName.fromJson(Map<String, dynamic> json) => StageName(
    id: json['id'],
    stageName: json['stage_name'],
    createdAt: json['created_at'],
    createdBy: json['created_by'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'stage_name': stageName,
    'created_at': createdAt,
    'created_by': createdBy,
  };
}

class LatestFollowupDetail {
  final int? id;
  final int? leadId;
  final String? followupDate;
  final String? name;
  final String? remarks;
  final int? status;

  const LatestFollowupDetail({
    this.id,
    this.leadId,
    this.followupDate,
    this.name,
    this.remarks,
    this.status,
  });

  factory LatestFollowupDetail.fromJson(Map<String, dynamic> json) =>
      LatestFollowupDetail(
        id: json['id'],
        leadId: json['lead_id'],
        followupDate: json['followup_date'],
        name: json['name'],
        remarks: json['remarks'],
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'lead_id': leadId,
    'followup_date': followupDate,
    'name': name,
    'remarks': remarks,
    'status': status,
  };
}
