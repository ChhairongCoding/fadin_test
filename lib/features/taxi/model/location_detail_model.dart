class LocationDetailModel {
  final LocationGeometryData locationGeometryData;
  final LocationDetailData locationDetailData;

  LocationDetailModel({required this.locationGeometryData, required this.locationDetailData});

  factory LocationDetailModel.fromJson(Map<String, dynamic> json) {
    return LocationDetailModel(
        locationGeometryData: LocationGeometryData.fromJson(json['geometry']),
        locationDetailData: LocationDetailData.fromJson(json['properties']));
  }
}

class LocationGeometryData {
  final String? type;
  final List<String> latLng;

  LocationGeometryData({
    required this.type,
    required this.latLng,
  });

  factory LocationGeometryData.fromJson(Map<String, dynamic> json) {
    var listLatLng = json['coordinates'] as List;
    List<String> latLngData = listLatLng.map((e) => e.toString()).toList();

    return LocationGeometryData(
        type: json['type'].toString(), latLng: latLngData);
  }
}

class LocationDetailData {
  final String id;
  final String locationName;
  final String label;
  final String street;
  final String country;
  final String region;
  final String county;

  LocationDetailData({
    required this.id,
    required this.locationName,
    required this.label,
    required this.street,
    required this.country,
    required this.region,
    required this.county,
  });

  factory LocationDetailData.fromJson(Map<String, dynamic> json) {
    return LocationDetailData(
        id: json['id'].toString(),
        locationName: json['name'].toString(),
        label: json['label'].toString(),
        street: json['street'].toString(),
        country: json['country'].toString(),
        region: json['region'].toString(),
        county: json['county'].toString());
  }
}
