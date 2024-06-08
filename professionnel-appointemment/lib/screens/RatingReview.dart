import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;

class RatingReviewScreen extends StatefulWidget {
  final int? professionId;
  const RatingReviewScreen({Key? key, this.professionId}) : super(key: key);

  @override
  _RatingReviewScreenState createState() => _RatingReviewScreenState();
}

class _RatingReviewScreenState extends State<RatingReviewScreen> {
  double rating = 0;
  TextEditingController _commentController = TextEditingController();

  Future<void> addReview(
      int? professionId, double? rating, String comment) async {
    await initLocalStorage();
    String? userIdString = localStorage?.getItem('userId');
    int? userId = userIdString != null ? int.parse(userIdString) : null;
    var url = Uri.parse('http://192.168.1.17:4000/review/createReview');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'clientId': userId,
        'professionId': professionId,
        'rating': rating,
        'comment': comment
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    var professionId = widget.professionId;

    return Scaffold(
      appBar: AppBar(
        title: Text('Rating and Review System'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Rate this service',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20.0),
            RatingBar.builder(
              initialRating: rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemSize: 30.0,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (value) {
                setState(() {
                  rating = value;
                });
              },
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Write your comment here...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Envoyer la note à votre backend ou effectuer toute autre action nécessaire
                String comment = _commentController.text;
                addReview(professionId, rating, comment)
                    .then((value) => {Navigator.of(context).pop()});
              },
              child: Text('Submit Review'),
            ),
          ],
        ),
      ),
    );
  }
}
