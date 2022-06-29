class Country {
  String? name;
  String? capital;
  String? code;
  String? native;
  String? currency;
  String? phone;
  String? emoji;
  List<Languages>? languages;

  Country(
      {this.name,
        this.capital,
        this.code,
        this.native,
        this.currency,
        this.phone,
        this.emoji,
        this.languages});

  Country.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    capital = json['capital'];
    code = json['code'];
    native = json['native'];
    currency = json['currency'];
    phone = json['phone'];
    emoji = json['emoji'];
    if (json['languages'] != null) {
      languages = <Languages>[];
      json['languages'].forEach((v) {
        languages!.add(Languages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['capital'] = capital;
    data['code'] = code;
    data['native'] = native;
    data['currency'] = currency;
    data['phone'] = phone;
    data['emoji'] = emoji;
    if (languages != null) {
      data['languages'] = languages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Languages {
  String? name;
  String? native;

  Languages({this.name, this.native});

  Languages.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    native = json['native'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['native'] = native;
    return data;
  }
}
