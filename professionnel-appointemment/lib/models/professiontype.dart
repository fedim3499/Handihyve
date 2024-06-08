class Professiontype {
  final int id;
  final String professionName;

  Professiontype({required this.id, required this.professionName});

  factory Professiontype.fromJson(Map<String, dynamic> json) {
    return Professiontype(
      id: json['id'],
      professionName: json['professionName'],
    );
  }
}
