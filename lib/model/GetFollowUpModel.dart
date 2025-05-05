class GetFollowUpModel {
  final bool status;
  final FollowUpPageData? data;

  const GetFollowUpModel({required this.status, this.data});

  factory GetFollowUpModel.fromJson(Map<String, dynamic> json) => GetFollowUpModel(
    status: json['status'] as bool,
    data: json['data'] != null
        ? FollowUpPageData.fromJson(json['data'] as Map<String, dynamic>)
        : null,
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    if (data != null) 'data': data!.toJson(),
  };
}

class FollowUpPageData {
  final int currentPage;
  final List<FollowUp> followUps;
  final String? firstPageUrl;
  final int? from; // Made nullable
  final int lastPage;
  final String? lastPageUrl;
  final List<PageLink> links;
  final String? nextPageUrl;
  final String? path;
  final int perPage;
  final String? prevPageUrl;
  final int? to; // Made nullable
  final int total;

  const FollowUpPageData({
    required this.currentPage,
    required this.followUps,
    this.firstPageUrl,
    this.from,
    required this.lastPage,
    this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    this.path,
    required this.perPage,
    this.prevPageUrl,
    this.to,
    required this.total,
  });

  factory FollowUpPageData.fromJson(Map<String, dynamic> json) => FollowUpPageData(
    currentPage: json['current_page'] as int,
    followUps: (json['data'] as List<dynamic>)
        .map((e) => FollowUp.fromJson(e as Map<String, dynamic>))
        .toList(),
    firstPageUrl: json['first_page_url'] as String?,
    from: json['from'] as int?, // Handle null
    lastPage: json['last_page'] as int,
    lastPageUrl: json['last_page_url'] as String?,
    links: (json['links'] as List<dynamic>)
        .map((e) => PageLink.fromJson(e as Map<String, dynamic>))
        .toList(),
    nextPageUrl: json['next_page_url'] as String?,
    path: json['path'] as String?,
    perPage: json['per_page'] as int,
    prevPageUrl: json['prev_page_url'] as String?,
    to: json['to'] as int?, // Handle null
    total: json['total'] as int,
  );

  Map<String, dynamic> toJson() => {
    'current_page': currentPage,
    'data': followUps.map((e) => e.toJson()).toList(),
    'first_page_url': firstPageUrl,
    'from': from,
    'last_page': lastPage,
    'last_page_url': lastPageUrl,
    'links': links.map((e) => e.toJson()).toList(),
    'next_page_url': nextPageUrl,
    'path': path,
    'per_page': perPage,
    'prev_page_url': prevPageUrl,
    'to': to,
    'total': total,
  };
}

class FollowUp {
  final int id;
  final int staffId;
  final int leadId;
  final String name;
  final String? phone; // Made nullable to handle null values
  final String date;
  final String time;
  final int typeOfFollowUp;
  final String status; // Changed to String to match JSON
  final String? remarks;
  final String createdAt;
  final String updatedAt;

  const FollowUp({
    required this.id,
    required this.staffId,
    required this.leadId,
    required this.name,
    this.phone,
    required this.date,
    required this.time,
    required this.typeOfFollowUp,
    required this.status,
    this.remarks,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FollowUp.fromJson(Map<String, dynamic> json) => FollowUp(
    id: json['id'] as int,
    staffId: json['staff_id'] as int,
    leadId: json['lead_id'] as int,
    name: json['name'] as String,
    phone: json['phone'] as String?, // Handle null directly
    date: json['date'] as String,
    time: json['time'] as String,
    typeOfFollowUp: json['type_of_follow_up'] as int,
    status: json['status'] as String,
    remarks: json['remarks'] as String?,
    createdAt: json['created_at'] as String,
    updatedAt: json['updated_at'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'staff_id': staffId,
    'lead_id': leadId,
    'name': name,
    'phone': phone,
    'date': date,
    'time': time,
    'type_of_follow_up': typeOfFollowUp,
    'status': status,
    'remarks': remarks,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}

class PageLink {
  final String? url;
  final String label;
  final bool active;

  const PageLink({this.url, required this.label, required this.active});

  factory PageLink.fromJson(Map<String, dynamic> json) => PageLink(
    url: json['url'] as String?,
    label: json['label'] as String,
    active: json['active'] as bool,
  );

  Map<String, dynamic> toJson() => {
    'url': url,
    'label': label,
    'active': active,
  };
}