import 'package:firebase_database/firebase_database.dart';
import 'package:modil6_task7/models/post_model.dart';

class DBService {
  static final FirebaseDatabase _db = FirebaseDatabase.instance;

  static Future<List<PostModel>> getPosts() async {
    final ref = _db.ref("posts");

    final data = await ref.get();
    print("DBService: getPosts: data => ${data.value}");
    final result = <PostModel>[];
    for (var post in data.children) {
      final postModel = PostModel.fromJson(
        Map<String, dynamic>.from(
          post.value as Map,
        ),
      );
      result.add(postModel);
    }
    // return data.value.toString();
    return result;
  }

  static Future<bool> createPost(PostModel post) async {
    final ref = _db.ref("posts/${post.id}");
    try {
      await ref.set(post.toJson());
    } catch (e) {
      print("DBGService:createPost: error => $e");
      return false;
    }
    return true;
  }
  static Future<bool> deletPost(int index) async {
    final ref = _db.ref("posts/${index}");
    try {
      await ref.remove();
    } catch (e) {
      print("DBGService:createPost: error => $e");
      return false;
    }
    return true;
  }
}
