class Summary {
  final int total;
  final int recoveries;
  final int deaths;
  final int activeCases;

  const Summary(
      {required this.total,
      required this.recoveries,
      required this.deaths,
      required this.activeCases});

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      total: json['data']['total'],
      recoveries: json['data']['recoveries'],
      deaths: json['data']['deaths'],
      activeCases: json['data']['active_cases'],
    );
  }
}
