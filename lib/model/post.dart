import 'package:faker/faker.dart';

class Post {
  final String imageUrl;
  String ownerName;
  final String ownerImage;
  bool isSaved;
  bool isSubscribed;

  Post({
    required this.imageUrl,
    required this.ownerImage,
    String? ownerName,
    this.isSaved = false,
    this.isSubscribed = false,
  }) : ownerName = ownerName ?? Faker().internet.userName();
}
