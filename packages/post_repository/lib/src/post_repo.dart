import 'models/post.dart';

abstract class PostRepository {

  Future<Post> createPost(Post post);

  Stream<List<Post>> getPost();

}