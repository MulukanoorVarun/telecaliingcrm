/// ─────────────────────────────────────────────────────────────────────────────
/// leaderboard_model.dart
/// ─────────────────────────────────────────────────────────────────────────────

class LeaderBoardModel {
  final int? currentPage;
  final List<LeaderBoard>? leaderboardData;
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

  const LeaderBoardModel({
    this.currentPage,
    this.leaderboardData,
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

  factory LeaderBoardModel.fromJson(Map<String, dynamic> json) =>
      LeaderBoardModel(
        currentPage: json['current_page'],
        leaderboardData: (json['data'] as List<dynamic>?)
            ?.map((e) => LeaderBoard.fromJson(e))
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
    if (leaderboardData != null)
      'data': leaderboardData!.map((e) => e.toJson()).toList(),
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
/// SINGLE ENTRY
/// ─────────────────────────────────────────────────────────────────────────────
class LeaderBoard {
  final String? name;
  final String? photo;
  final int? count;

  const LeaderBoard({this.name, this.photo, this.count});

  factory LeaderBoard.fromJson(Map<String, dynamic> json) => LeaderBoard(
    name: json['name'],
    photo: json['photo'],
    count: json['count'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'photo': photo,
    'count': count,
  };
}

/// ─────────────────────────────────────────────────────────────────────────────
/// PAGE LINK
/// ─────────────────────────────────────────────────────────────────────────────
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
