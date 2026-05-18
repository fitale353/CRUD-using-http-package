import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/models/post_model.dart';

class PostRepository {
  final String baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  // GET: Fetch Posts
  async Future<List<Post>> fetchPosts() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => Post.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load posts (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // POST: Create Post
  async Future<Post> createPost(Post post) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(post.toJson()),
      );
      if (response.statusCode == 201) {
        return Post.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create post');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // PUT: Update Post
  async Future<Post> updatePost(int id, Post post) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(post.toJson()),
      );
      if (response.statusCode == 200) {
        return Post.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update post');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // DELETE: Delete Post
  async Future<void> deletePost(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode != 200) {
        throw Exception('Failed to delete post');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
