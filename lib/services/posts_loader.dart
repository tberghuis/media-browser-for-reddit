import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/post.dart';
import 'dart:async';
import '../state/global_state.dart';

class PostsLoader {
  BuildContext context;
  String _currentSubreddit;
  bool _disposed = false;

  // if passing in context for navigator pop is bad practice
  // could use future and completer
  PostsLoader(this.context, this._currentSubreddit) {
    print('xxx PostsLoader constructor');
    loadMorePosts();
  }
  var _posts = <Post>[];
  final postsSubject = new BehaviorSubject<List<Post>>.seeded([]);
  String _nextAfter = '';

  Future<void> _loadMorePosts() async {
    // xTODO stream json decode and convert gfycat urls on the fly
    var response = await http.get(
        'https://www.reddit.com/r/$_currentSubreddit.json?after=$_nextAfter');
    final body = jsonDecode(response.body);
    var posts = body['data']['children'];
    _nextAfter = body['data']['after'];
    List urls = posts.map((post) => post['data']['url']).toList();
    List<Post> allPosts = List<Post>.from(urls.map((url) => Post(url)));
    _posts = [
      ..._posts,
      ...allPosts.where((post) => post.type != null).toList()
    ];
    postsSubject.add(_posts);
  }

  void loadMorePosts() async {
    try {
      await _loadMorePosts();
      while (!_disposed && _nextAfter != null && _posts.length < 2) {
        await _loadMorePosts();
      }
    } catch (e) {
      print('exception');
      _exit();
    }
    if (!_disposed && _nextAfter == null && _posts.length == 0) {
      print('loadMorePosts no results');
      _exit();
    }
  }

  void _exit() {
    if (!_disposed) {
      Navigator.pop(context);
      globalState.subredditChoiceScaffoldKey.currentState.showSnackBar(
          new SnackBar(
              content: new Text(
                  'No posts found for subreddit \'$_currentSubreddit\'')));
    }
  }

  void dispose() {
    // xxx cancel http
    _disposed = true;
  }
}
