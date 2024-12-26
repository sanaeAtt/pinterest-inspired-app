import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pintrest_grid/my_app.dart';
import 'package:pintrest_grid/provider/post_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PostProvider(),
      child: const MyApp(),
    ),
  );
}
