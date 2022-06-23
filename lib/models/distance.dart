class Distance {
  final String distance;
  final String time;
  final int seconds;
  final double meter;

  const Distance(
      {required this.distance,
      required this.time,
      required this.seconds,
      required this.meter});

  factory Distance.fromJson(Map<String, dynamic> json) {
    return Distance(
      distance: json['rows'].first['elements'].first['distance']['text'],
      time: json['rows'].first['elements'].first['duration']['text'],
      seconds: json['rows'].first['elements'].first['duration']['value'],
      meter: json['rows'].first['elements'].first['distance']['value'] / 1000,
    );
  }
}
