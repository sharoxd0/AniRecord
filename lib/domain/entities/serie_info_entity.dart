class SerieInfo {
  final String description;
  final PrevAndNext? prev;
  final PrevAndNext? next;

  SerieInfo({
    required this.description,
    this.prev,
    this.next,
  });

  factory SerieInfo.fromJson(Map<String, dynamic> json) {
    return SerieInfo(
      description: json['description'],
      prev: json['prev'] != null ? PrevAndNext.fromJson(json['prev']) : null,
      next: json['next'] != null ? PrevAndNext.fromJson(json['next']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'prev': prev?.toJson(),
      'next': next?.toJson(),
    };
  }
}

class PrevAndNext {
  final String id;
  final String name;

  PrevAndNext({
    required this.id,
    required this.name,
  });

  factory PrevAndNext.fromJson(Map<String, dynamic> json) {
    return PrevAndNext(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
