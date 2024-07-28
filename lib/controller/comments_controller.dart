import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:healther/models/comments_model.dart';
import 'package:http/http.dart' as http;

class CommentsController with ChangeNotifier {
  List<Comment> _comments = [];
  bool _isLoading = false;

  List<Comment> get comments => _comments;
  bool get isLoading => _isLoading;

  Future<void> fetchComments() async {
    _isLoading = true;
    notifyListeners();

    const url = 'https://jsonplaceholder.typicode.com/comments';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        _comments = responseData.map((data) => Comment.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load comments');
      }
    } catch (error) {
      throw error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
