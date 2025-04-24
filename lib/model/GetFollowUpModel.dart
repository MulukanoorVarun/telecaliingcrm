/// ─────────────────────────────────────────────────────────────────────────────
/// get_follow_up_model.dart
/// ─────────────────────────────────────────────────────────────────────────────

class GetFollowUpModel {
  final bool? status;
  final FollowUpPageData? data;

  const GetFollowUpModel({this.status, this.data});

  factory GetFollowUpModel.fromJson(Map<String, dynamic> json) =>
      GetFollowUpModel(
        status: json['status'] as bool?,
        data: json['data'] != null
            ? FollowUpPageData.fromJson(json['data'])
            : null,
      );

  Map<String, dynamic> toJson() => {
    'status': status,
    if (data != null) 'data': data!.toJson(),
  };
}

/// ─────────────────────────────────────────────────────────────────────────────
/// PAGINATED WRAPPER
/// ─────────────────────────────────────────────────────────────────────────────
class FollowUpPageData {
  final int? currentPage;
  final List<FollowUp>? followUps;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final List<PageLink>? links;
  final String? nextPageUrl;
  final String? path;
  final int? perPage;
  final String? prevPageUrl;
  final int? to;
  final int? total;

  const FollowUpPageData({
    this.currentPage,
    this.followUps,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory FollowUpPageData.fromJson(Map<String, dynamic> json) =>
      FollowUpPageData(
        currentPage: json['current_page'],
        followUps: (json['data'] as List<dynamic>?)
            ?.map((e) => FollowUp.fromJson(e))
            .toList(),
        firstPageUrl: json['first_page_url'],
        from: json['from'],
        lastPage: json['last_page'],
        lastPageUrl: json['last_page_url'],
        links: (json['links'] as List<dynamic>?)
            ?.map((e) => PageLink.fromJson(e))
            .toList(),
        nextPageUrl: json['next_page_url'],
        path: json['path'],
        perPage: json['per_page'],
        prevPageUrl: json['prev_page_url'],
        to: json['to'],
        total: json['total'],
      );

  Map<String, dynamic> toJson() => {
    'current_page': currentPage,
    if (followUps != null) 'data': followUps!.map((e) => e.toJson()).toList(),
    'first_page_url': firstPageUrl,
    'from': from,
    'last_page': lastPage,
    'last_page_url': lastPageUrl,
    if (links != null) 'links': links!.map((e) => e.toJson()).toList(),
    'next_page_url': nextPageUrl,
    'path': path,
    'per_page': perPage,
    'prev_page_url': prevPageUrl,
    'to': to,
    'total': total,
  };
}

/// ─────────────────────────────────────────────────────────────────────────────
/// SINGLE FOLLOW‑UP
/// ─────────────────────────────────────────────────────────────────────────────
class FollowUp {
  final int? id;
  final int? leadId;
  final int? phone;
  final int? staffId;
  final String? followupDate;
  final String? name;
  final String? remarks;
  final int? status;
  final LeadType? leadType;

  const FollowUp({
    this.id,
    this.leadId,
    this.phone,
    this.staffId,
    this.followupDate,
    this.name,
    this.remarks,
    this.status,
    this.leadType,
  });

  factory FollowUp.fromJson(Map<String, dynamic> json) => FollowUp(
    id: json['id'],
    leadId: json['lead_id'],
    phone: json['phone'],
    staffId: json['staff_id'],
    followupDate: json['followup_date'],
    name: json['name'],
    remarks: json['remarks'],
    status: json['status'],
    leadType:
    json['lead_type'] != null ? LeadType.fromJson(json['lead_type']) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'lead_id': leadId,
    'phone': phone,
    'staff_id': staffId,
    'followup_date': followupDate,
    'name': name,
    'remarks': remarks,
    'status': status,
    if (leadType != null) 'lead_type': leadType!.toJson(),
  };
}

/// ─────────────────────────────────────────────────────────────────────────────
/// NESTED OBJECTS
/// ─────────────────────────────────────────────────────────────────────────────
class LeadType {
  final int? id;
  final int? leadStageId;
  final String? number;
  final StageName? stageName;

  const LeadType({this.id, this.leadStageId, this.number, this.stageName});

  factory LeadType.fromJson(Map<String, dynamic> json) => LeadType(
    id: json['id'],
    leadStageId: json['lead_stage_id'],
    number: json['number'],
    stageName:
    json['stage_name'] != null ? StageName.fromJson(json['stage_name']) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'lead_stage_id': leadStageId,
    'number': number,
    if (stageName != null) 'stage_name': stageName!.toJson(),
  };
}

class StageName {
  final int? id;
  final String? stageName;

  const StageName({this.id, this.stageName});

  factory StageName.fromJson(Map<String, dynamic> json) => StageName(
    id: json['id'],
    stageName: json['stage_name'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'stage_name': stageName,
  };
}

class PageLink {
  final String? url;
  final String? label;
  final bool? active;

  const PageLink({this.url, this.label, this.active});

  factory PageLink.fromJson(Map<String, dynamic> json) => PageLink(
    url: json['url'],
    label: json['label'],
    active: json['active'],
  );

  Map<String, dynamic> toJson() => {
    'url': url,
    'label': label,
    'active': active,
  };
}
