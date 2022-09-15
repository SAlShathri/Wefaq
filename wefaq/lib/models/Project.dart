class Project {
  String? name;
  String? description;
  String? location;
  String? lookingFor;
  List<String>? category;
  String? Duration;

  Project();
  Map<String, dynamic> toJson() => {
        'category': category,
        'description': description,
        'location': location,
        'lookingFor': lookingFor,
        'name': name,
        'Duration': Duration,
      };
  Project.fromsanpshot(sanpshot)
      : category = sanpshot.data()['category'],
        name = sanpshot.data()['name'],
        location = sanpshot.data()['location'],
        lookingFor = sanpshot.data()['lookingFor'],
        description = sanpshot.data()['description'],
        Duration = sanpshot.data()['Duration'];
}
