import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/http.dart';

class _Singleton {

  // always assign both as a pair
  var _subredditList = <String>[];
  final subredditListSubject = new BehaviorSubject<List<String>>.seeded([]);

  _Singleton() {
    _loadSubredditList();
    _persistSubredditList();
  }

  void _loadSubredditList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var list = prefs.getStringList('subredditList');
    if (list != null) {
      _subredditList = list;
      subredditListSubject.add(_subredditList);
    }
  }

  void _persistSubredditList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    subredditListSubject.stream.skip(1).listen((list) {
      prefs.setStringList('subredditList', _subredditList);
    });
  }

  void addSubreddit(subreddit) {
    _subredditList.add(subreddit);
    _subredditList.sort();
    subredditListSubject.add(_subredditList);
  }

  Future<bool> validateSubreddit(subreddit) async {
    subreddit = subreddit.trim();
    if (subreddit == '') {
      return false;
    }
    final request = new http.Request(
        'GET', Uri.parse('https://www.reddit.com/r/$subreddit.json'))
      ..followRedirects = false;
    final streamedResponse = await httpClient.send(request);
    if (streamedResponse.statusCode != 200) {
      return false;
    }
    return true;
  }

  void deleteSubreddit(subreddit) {
    _subredditList.remove(subreddit);
    subredditListSubject.add(_subredditList);
  }
}

var subredditListState = _Singleton();
