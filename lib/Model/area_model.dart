class AreaModel {
  final int? id;
  final String jalan;
  final String kelurahan;
  final String kecamatan;
  final String kota;
  final String provinsi;

  AreaModel({
    this.id,
    required this.jalan,
    required this.kelurahan,
    required this.kecamatan,
    required this.kota,
    required this.provinsi,
  });

  Map<String, dynamic> toJson() {
    return {
      'jalan': jalan,
      'kelurahan': kelurahan,
      'kecamatan': kecamatan,
      'kota': kota,
      'provinsi': provinsi,
    };
  }

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return AreaModel(
      id: json['id'],
      jalan: json['jalan'],
      kelurahan: json['kelurahan'],
      kecamatan: json['kecamatan'],
      kota: json['kota'],
      provinsi: json['provinsi'],
    );
  }
}
