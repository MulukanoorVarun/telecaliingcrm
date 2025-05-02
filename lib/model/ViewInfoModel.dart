class ViewInfoModel {
  final bool? status;
  final List<ViewInfo>? data;

  const ViewInfoModel({this.status, this.data});

  factory ViewInfoModel.fromJson(Map<String, dynamic> json) => ViewInfoModel(
    status: json['status'] as bool?,
    data: (json['data'] as List<dynamic>?)
        ?.map((e) => ViewInfo.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    if (data != null) 'data': data!.map((e) => e.toJson()).toList(),
  };
}

class ViewInfo {
  final int? id;
  final int? number;
  final int? staffId;
  final String? dateAdded;
  final String? callStatus;
  final String? calledStatus;
  final String? name;
  final String? followUpDate;
  final int? serviceType;
  final int? stageType;
  final int? industryType;
  final String? remarks;
  final String? dealStatus;
  final num? dealAmount;
  final int? totalCalls;
  final String? lastCalledDate;
  final int? leadStageId;
  final String? dealClosureDate;
  final int? callDuration;
  final int? activeStatus;
  final String? companyId;
  final String? leadStage;
  final String? leadType;
  final String? leadSource;
  final String? leadIndustry;
  final String? email;
  final String? createdAt;
  final String? updatedAt;
  final String? description;
  final StageName? stageName;
  final LatestFollowupDetail? latestFollowupDetail;
  final int? fId;

  const ViewInfo({
    this.id,
    this.number,
    this.staffId,
    this.dateAdded,
    this.callStatus,
    this.calledStatus,
    this.name,
    this.followUpDate,
    this.serviceType,
    this.stageType,
    this.industryType,
    this.remarks,
    this.dealStatus,
    this.dealAmount,
    this.totalCalls,
    this.lastCalledDate,
    this.leadStageId,
    this.dealClosureDate,
    this.callDuration,
    this.activeStatus,
    this.companyId,
    this.leadStage,
    this.leadType,
    this.leadSource,
    this.leadIndustry,
    this.email,
    this.createdAt,
    this.updatedAt,
    this.description,
    this.stageName,
    this.latestFollowupDetail,
    this.fId,
  });

  factory ViewInfo.fromJson(Map<String, dynamic> json) => ViewInfo(
    id: json['id'] as int?,
    number: json['number'] as int?,
    staffId: json['staff_id'] as int?,
    dateAdded: json['date_added'] as String?,
    callStatus: json['call_status'] as String?,
    calledStatus: json['called_status'] as String?,
    name: json['name'] as String?,
    followUpDate: json['follow_up_date'] as String?,
    serviceType: json['service_type'] as int?,
    stageType: json['stage_type'] as int?,
    industryType: json['industry_type'] as int?,
    remarks: json['remarks'] as String?,
    dealStatus: json['deal_status'] as String?,
    dealAmount: json['deal_amount'] as num?,
    totalCalls: json['total_calls'] as int?,
    lastCalledDate: json['last_called_date'] as String?,
    leadStageId: json['lead_stage_id'] as int?,
    dealClosureDate: json['deal_closure_date'] as String?,
    callDuration: json['call_duration'] as int?,
    activeStatus: json['active_status'] as int?,
    companyId: json['company_id'] as String?,
    leadStage: json['lead_stage'] as String?,
    leadType: json['lead_type'] as String?,
    leadSource: json['lead_source'] as String?,
    leadIndustry: json['lead_industry'] as String?,
    email: json['email'] as String?,
    createdAt: json['created_at'] as String?,
    updatedAt: json['updated_at'] as String?,
    description: json['description'] as String?,
    stageName: json['stage_name'] != null
        ? StageName.fromJson(json['stage_name'] as Map<String, dynamic>)
        : null,
    latestFollowupDetail: json['latest_followup_detail'] != null
        ? LatestFollowupDetail.fromJson(
        json['latest_followup_detail'] as Map<String, dynamic>)
        : null,
    fId: json['f_id'] as int?,
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
    'service_type': serviceType,
    'stage_type': stageType,
    'industry_type': industryType,
    'remarks': remarks,
    'deal_status': dealStatus,
    'deal_amount': dealAmount,
    'total_calls': totalCalls,
    'last_called_date': lastCalledDate,
    'lead_stage_id': leadStageId,
    'deal_closure_date': dealClosureDate,
    'call_duration': callDuration,
    'active_status': activeStatus,
    'company_id': companyId,
    'lead_stage': leadStage,
    'lead_type': leadType,
    'lead_source': leadSource,
    'lead_industry': leadIndustry,
    'email': email,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'description': description,
    if (stageName != null) 'stage_name': stageName!.toJson(),
    if (latestFollowupDetail != null)
      'latest_followup_detail': latestFollowupDetail!.toJson(),
    'f_id': fId,
  };
}

class StageName {
  final int? id;
  final String? stageName;
  final String? createdAt;
  final int? createdBy;

  const StageName({
    this.id,
    this.stageName,
    this.createdAt,
    this.createdBy,
  });

  factory StageName.fromJson(Map<String, dynamic> json) => StageName(
    id: json['id'] as int?,
    stageName: json['stage_name'] as String?,
    createdAt: json['created_at'] as String?,
    createdBy: json['created_by'] as int?,
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
        id: json['id'] as int?,
        leadId: json['lead_id'] as int?,
        followupDate: json['followup_date'] as String?,
        name: json['name'] as String?,
        remarks: json['remarks'] as String?,
        status: json['status'] as int?,
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
