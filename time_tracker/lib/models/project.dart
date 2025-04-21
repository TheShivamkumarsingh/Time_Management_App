class Project {
  String id;
  String name;

  Project({required this.id, required this.name});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  factory Project.fromJson(Map<String, dynamic> json) =>
      Project(id: json['id'], name: json['name']);
}
