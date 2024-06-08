import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:professionnel/models/review.dart';
import 'package:professionnel/screens/RatingReview.dart';
import 'package:http/http.dart' as http;

class ReviewsPage extends StatefulWidget {
  final int? professionId;
  const ReviewsPage({Key? key, this.professionId}) : super(key: key);

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  late Future<dynamic> _reviewsFuture;

  @override
  void initState() {
    super.initState();
    _reviewsFuture = _getReviews(widget.professionId);
  }

  Future<dynamic> _getReviews(int? professionId) async {
    final url = Uri.parse(
        'http://192.168.1.12:4000/Review/GetReviewByprofessionId/' +
            professionId.toString());
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'professionId': professionId});

    final response = await http.get(url, headers: headers);
    var data = jsonDecode(response.body);

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews and Ratings'),
      ),
      body: FutureBuilder(
        future: _reviewsFuture,
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Review> reviewList = [];
            for (Map<String, dynamic> i in snapshot.data) {
              reviewList.add(Review.fromJson(i));
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListView.builder(
                      itemCount: reviewList.length,
                      itemBuilder: (context, index) {
                        final Review review = reviewList[index];
                        return ListTile(
                          title: Text(review.clientName),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(review.comment),
                              StarRating(review.rating as int),
                              // Afficher les étoiles ici
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              // Mettez ici le code pour supprimer l'avis
                              // par exemple, une fonction `_deleteReview(review.id)` que vous devrez implémenter
                            },
                          ),
                        );
                      },
                      shrinkWrap: true,
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RatingReviewScreen(
                                professionId: this.widget.professionId),
                          ),
                        );
                      },
                      child: Text('Create a Review'),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class StarRating extends StatelessWidget {
  final int rating;

  StarRating(this.rating);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        if (index < rating) {
          return Icon(Icons.star, color: Colors.yellow);
        } else {
          return Icon(Icons.star_border, color: Colors.yellow);
        }
      }),
    );
  }
}
