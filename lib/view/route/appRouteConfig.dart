// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todoapp/view/addToDo.dart';
import 'package:todoapp/view/home.dart';

class AppRouteConfig {
  GoRouter router = GoRouter(routes: [
    GoRoute(
        name: 'home',
        path: '/',
        pageBuilder: (context, state) {
          return const MaterialPage(child: HomeScreen());
        }),
    GoRoute(
        name: 'addToDo',
        path: '/addToDo',
        pageBuilder: (context, state) {
          return const MaterialPage(child: AddToDoScreen());
        }),
  ]);
}
