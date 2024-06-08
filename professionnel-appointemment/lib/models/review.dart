class Review {
  final int? id;
  final int? professionId;
  final int? clientId;
  final String clientName;
  final double? rating;
  final String comment;

  Review({
    required this.id,
    required this.professionId,
    required this.clientId,
    required this.clientName,
    required this.rating,
    required this.comment,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      professionId: json['professionId'],
      clientId: json['clientId'],
      clientName: json['clientName'],
      rating: json['rating'],
      comment: json['comment'],
    );
  }
}
