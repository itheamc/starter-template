
/// This model class is created just for using on the onFeatureTapped
/// callback of the map libre map
class QueriedFeature {
  QueriedFeature({
    this.type,
    this.id,
    this.geometry,
    this.properties,
  });

  final String? type;
  final String? id;
  final dynamic geometry;
  final Map<String, dynamic>? properties;

  QueriedFeature copyWith({
    String? type,
    String? id,
    dynamic geometry,
    Map<String, dynamic>? properties,
  }) {
    return QueriedFeature(
      type: type ?? this.type,
      id: id ?? this.id,
      geometry: geometry ?? this.geometry,
      properties: properties ?? this.properties,
    );
  }

  factory QueriedFeature.fromJson(Map<String, dynamic> json) {
    return QueriedFeature(
      type: json["type"],
      id: json["id"],
      geometry: json["geometry"],
      properties: json["properties"],
    );
  }

  Map<String, dynamic> toJson() => {
        "type": type,
        "id": id,
        "geometry": geometry,
        "properties": properties,
      };

  @override
  String toString() {
    return "$type, $id, $geometry, $properties, ";
  }
}
