import 'package:flutter/cupertino.dart';
import 'package:pintrest_grid/model/post.dart';

class PostProvider with ChangeNotifier {
  final List<Post> _posts = List.generate(
    20,
    (index) => Post(
      imageUrl: 'https://picsum.photos/${800 + index}/${(index % 2 + 1) * 970}',
      ownerImage: 'https://picsum.photos/50?random=$index',
    ),
  );

  bool _isProfileVisible = false;

  bool get isProfileVisible => _isProfileVisible;

  void toggleProfileVisibility() {
    _isProfileVisible = !_isProfileVisible;
    notifyListeners();
  }

  void setProfileVisibility(bool isVisible) {
    _isProfileVisible = isVisible;
    notifyListeners();
  }

  List<Post> get posts => _posts;

  List<Post> get savedPosts => _posts.where((post) => post.isSaved).toList();

  int posteSaved() {
    return _posts.where((post) => post.isSaved).length;
  }

  final List<Post> _subscriptions = [];

  List<Post> get subscriptions => _subscriptions;

  void toggleSave(Post post) {
    post.isSaved = !post.isSaved;
    notifyListeners();
  }

  void toggleSubscribe(Post post) {
    post.isSubscribed = !post.isSubscribed;
    if (post.isSubscribed) {
      _subscriptions.add(post);
    } else {
      _subscriptions.remove(post);
    }
    notifyListeners();
  }
}
