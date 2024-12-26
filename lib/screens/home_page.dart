import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pintrest_grid/provider/post_provider.dart';
import 'package:pintrest_grid/screens/browser_page.dart';
import 'package:pintrest_grid/screens/profil_page.dart';
import 'package:pintrest_grid/screens/saved_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _profileController;
  late Animation<Offset> _profileAnimation;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _profileController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _profileAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _profileController, curve: Curves.easeInOut));

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _profileController.dispose();
    super.dispose();
  }

  void _toggleProfilePage(BuildContext context) {
    final postProvider = context.read<PostProvider>();
    postProvider.toggleProfileVisibility();

    if (postProvider.isProfileVisible) {
      _profileController.forward();
    } else {
      _profileController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isProfileVisible = context.watch<PostProvider>().isProfileVisible;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: TabBar(
                    tabs: [
                      const Tab(text: "Browse"),
                      Consumer<PostProvider>(
                        builder: (context, postProvider, _) {
                          final newSaved = postProvider.savedPosts.isNotEmpty;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Saved"),
                              if (newSaved)
                                Container(
                                  margin: const EdgeInsets.only(left: 5),
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red,
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.black,
                    controller: _tabController,
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      if (!isProfileVisible && details.delta.dx < 0) {
                        _toggleProfilePage(context);
                      }
                    },
                    child: TabBarView(
                      controller: _tabController,
                      children: const [
                        BrowsePage(),
                        SavedPage(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SlideTransition(
              position: _profileAnimation,
              child: Visibility(
                visible: isProfileVisible,
                child: IgnorePointer(
                  ignoring: !isProfileVisible,
                  child: const ProfilePage(),
                ),
              ),
            ),
            Positioned(
              bottom: 2,
              right: 2,
              child: GestureDetector(
                onTap: () => _toggleProfilePage(context),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.red.shade900,
                  child: const CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.white,
                    backgroundImage: CachedNetworkImageProvider(
                        'https://picsum.photos/100',
                        scale: .9),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
