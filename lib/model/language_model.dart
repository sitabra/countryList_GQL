class Languages {
  String code;
  String name;
  Languages.fromJson(Map<String, dynamic> json)
      : code = json["code"],
        name = json["name"];
}