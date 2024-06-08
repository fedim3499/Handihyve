class Profession {
  final int? id;
  final String image;
  final String userName;
  final String specialist;

  Profession(
      {required this.id,
      required this.image,
      required this.userName,
      required this.specialist, });

  factory Profession.fromJson(Map<String, dynamic> json) {
    return Profession(
      id: json['id'],
      image: json['image'],
      userName: json['name'],
      specialist: json['specialist'],
    );
  }
}
