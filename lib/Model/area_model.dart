class AreaModel {
  final String kecamatan;
  final String kelurahan;
  final String kota;
  final String provinsi;

  AreaModel({
    required this.kecamatan,
    required this.kelurahan,
    required this.kota,
    required this.provinsi,
  });

  Map<String, dynamic> toJson() {
    return {
      'kecamatan': kecamatan,
      'kelurahan': kelurahan,
      'kota': kota,
      'provinsi': provinsi,
    };
  }

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return AreaModel(
      kecamatan: json['kecamatan'],
      kelurahan: json['kelurahan'],
      kota: json['kota'],
      provinsi: json['provinsi'],
    );
  }
}
