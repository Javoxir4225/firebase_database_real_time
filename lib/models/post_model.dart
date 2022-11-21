class PostModel {
  String? id;
  String? fullname;
  String? listname;
  String? content;
  String? date;

  PostModel({
    this.id,
    this.fullname,
    this.listname,
    this.content,
    this.date,
  });

  PostModel.fromJson(Map<String, dynamic> data) {
    id = data["id"];
    fullname = data["fullname"];
    listname = data["listname"];
    content = data["content"];
    date = data["date"];
  }
  Map<String, dynamic> toJson() {
    return {
      "id":id,
      "fullname": fullname,
      "listname": listname,
      "content": content,
      "date": date,
    };
  }
}
