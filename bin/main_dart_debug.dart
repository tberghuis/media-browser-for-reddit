// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../lib/models/post.dart';

// void main() {
//   getPosts();
// }

// void getPosts() async {
//   var _currentSubreddit = 'Whatcouldgowrong';
//   var _nextAfter = '';

//   var response = await http.get(
//       'https://www.reddit.com/r/$_currentSubreddit.json?after=$_nextAfter');
//   final body = jsonDecode(response.body);
//   var posts = body['data']['children'];
//   _nextAfter = body['data']['after'];

//   print('fdsfsdf');
// }
