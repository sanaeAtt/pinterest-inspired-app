import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:pintrest_grid/provider/post_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      margin: const EdgeInsets.only(left: 50),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        boxShadow: [
          BoxShadow(
            color: Colors.red[900]!.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(-4, 0),
          ),
        ],
      ),
      child: Stack(
        // Utilisation de Stack pour positionner l'icône
        children: [
          Column(
            children: [
              const SizedBox(height: 50),
              const Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      NetworkImage('https://picsum.photos/100', scale: .6),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                Faker().internet.userName(),
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Consumer<PostProvider>(
                      builder: (context, provider, _) => _buildStatItem(
                          "Posts", provider.posteSaved().toString()),
                    ),
                    Consumer<PostProvider>(
                      builder: (context, provider, _) => _buildStatItem(
                          "Following",
                          provider.subscriptions.length.toString()),
                    ),
                    _buildStatItem("Followers", "45"),
                  ],
                ),
              ),
              const Divider(height: 30, thickness: 1),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      "Followers",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const Gap(20),
                    Expanded(
                      child: Consumer<PostProvider>(
                        builder: (context, provider, _) {
                          final subscriptions = provider.subscriptions;
                          if (subscriptions.isEmpty) {
                            return const Center(
                              child: Text("No Followers"),
                            );
                          }
                          return ListView.builder(
                            itemCount: subscriptions.length,
                            itemBuilder: (context, index) {
                              final post = subscriptions[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(post.ownerImage),
                                ),
                                title: Text(
                                  post.ownerName,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: TextButton(
                                  style: ButtonStyle(
                                    elevation: WidgetStateProperty.all(9),
                                    side: WidgetStateProperty.all(BorderSide(
                                      color: Colors.red[900]!,
                                      width: 1,
                                    )),
                                  ),
                                  onPressed: () {
                                    provider.toggleSubscribe(post);
                                  },
                                  child: const Text(
                                    "Unfollow",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Ajout de l'icône de fermeture dans le Stack pour le placer dans le coin
          Positioned(
            top: 10,
            left: 10,
            child: IconButton(
              onPressed: () {
                context.read<PostProvider>().toggleProfileVisibility();
              },
              icon: const Icon(Icons.close, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
