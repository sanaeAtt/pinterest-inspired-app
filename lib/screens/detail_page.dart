import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pintrest_grid/model/post.dart';
import 'package:pintrest_grid/provider/post_provider.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatefulWidget {
  final List<Post> posts;
  final int initialIndex;

  const DetailPage({
    super.key,
    required this.posts,
    required this.initialIndex,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: widget.posts.length,
              onPageChanged: (index) {
                setState(() {});
              },
              itemBuilder: (context, index) {
                final post = widget.posts[index];
                return Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: post.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Row(
                        children: [
                          Text(
                            post.ownerName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Consumer<PostProvider>(
                            builder: (context, provider, child) {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: post.isSubscribed
                                      ? Colors.white
                                      : Colors.red,
                                ),
                                onPressed: () {
                                  provider.toggleSubscribe(post);
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      post.isSubscribed
                                          ? Icons.check
                                          : Icons.add,
                                      color: post.isSubscribed
                                          ? Colors.red
                                          : Colors.white,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      post.isSubscribed ? "Followed" : "Follow",
                                      style: TextStyle(
                                        color: post.isSubscribed
                                            ? Colors.red
                                            : Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  color: Colors.red[900]!.withOpacity(.6),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: IconButton(
                    icon:
                        const Icon(Icons.close, color: Colors.white, size: 20),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
