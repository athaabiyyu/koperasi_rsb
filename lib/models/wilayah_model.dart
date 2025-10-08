class Province {
  final String code;
  final String name;

  Province({
    required this.code,
    required this.name,
  });

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
    };
  }
}

class Regency {
  final String code;
  final String provinceCode;
  final String name;

  Regency({
    required this.code,
    required this.provinceCode,
    required this.name,
  });

  factory Regency.fromJson(Map<String, dynamic> json) {
    return Regency(
      code: json['code'] ?? '',
      provinceCode: json['province_code'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'province_code': provinceCode,
      'name': name,
    };
  }
}

class District {
  final String code;
  final String regencyCode;
  final String name;

  District({
    required this.code,
    required this.regencyCode,
    required this.name,
  });

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      code: json['code'] ?? '',
      regencyCode: json['regency_code'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'regency_code': regencyCode,
      'name': name,
    };
  }
}

class Village {
  final String code;
  final String districtCode;
  final String name;

  Village({
    required this.code,
    required this.districtCode,
    required this.name,
  });

  factory Village.fromJson(Map<String, dynamic> json) {
    return Village(
      code: json['code'] ?? '',
      districtCode: json['district_code'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'district_code': districtCode,
      'name': name,
    };
  }
}