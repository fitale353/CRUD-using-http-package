import 'package:flutter/material.dart';
import '../data/models/post_model.dart';
import '../repository/post_repository.dart';

class PostProvider with ChangeNotifier {
  final PostRepository _repository = PostRepository();

  List<Post> _posts = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // READ
  async Future<void> loadPosts() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _posts = await _repository.fetchPosts();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // CREATE
  async Future<bool> addPost(String title, String body) async {
    _isLoading = true;
    notifyListeners();
    try {
      final newPost = Post(userId: 1, title: title, body: body);
      final createdPost = await _repository.createPost(newPost);
      // Insert locally at the top of the list for visual confirmation
      _posts.insert(0, createdPost);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // UPDATE
  async Future<bool> editPost(int id, String title, String body) async {
    _isLoading = true;
    notifyListeners();
    try {
      final updatedData = Post(id: id, userId: 1, title: title, body: body);
      final updatedPost = await _repository.updatePost(id, updatedData);
      
      int index = _posts.indexWhere((post) => post.id == id);
      if (index != -1) {
        _posts[index] = updatedPost;
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // DELETE
  async Future<bool> removePost(int id) async {
    // Optimistic UI updates could be applied, but we show loading for clarity
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.deletePost(id);
      _posts.removeWhere((post) => post.id == id);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
