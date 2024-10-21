import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:post_repository/post_repository.dart';
import 'package:post_repository/src/models/post.dart';
import 'package:post_repository/src/post_repo.dart';
import 'package:uuid/uuid.dart';


class FirebasePostRepository implements PostRepository {
  final postCollection = FirebaseFirestore.instance.collection("posts");
  @override
  Future<Post> createPost(Post post)  async{
    
    try {
     
      post.postId= const Uuid().v1();
      post.creadetAt=DateTime.now();
      await postCollection
      .doc(post.postId)
      .set(post.toEntity().toDocument());
      return post;
      
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
  
  @override
  Stream<List<Post>> getPost() {
  try {
    return postCollection
      .snapshots() // Veritabanı değişikliklerini dinlemek için snapshots kullanıyoruz
      .map((snapshot) => snapshot.docs.map((doc) => 
        Post.fromEntitiy(PostEntities.fromDocument(doc.data()))).toList());
  } catch (e) {
    log(e.toString());
    rethrow;
  }
}



}
