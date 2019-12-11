import 'dart:convert';
import 'package:http/http.dart' as http;

class Post {
  String url;

  // xxx replace with enum
  // IMAGE | GFYCAT | REDDITV ...
  String type;

  Future<String> gfycatUrlFuture;

  String imgurVideoUrl;

  // xxx redditv
  // Map media;

  String redditVideoUrl;

  Post(this.url) {
    print('xxx Post url $url');

    if (_matchImage()) {
      return;
    }
    if (_matchImgurVideo()) {
      return;
    }
    if (_matchRedditVideo()) {
      return;
    }

    if (url.contains('gfycat.com')) {
      type = 'GFYCAT';
      fetchGfycatUrl();
    }
  }

  bool _matchImage() {
    RegExp imageRegEx = new RegExp(r'\.(jpg|jpeg|bmp|png|gif)$');
    var match = imageRegEx.firstMatch(url);
    if (match == null) {
      return false;
    }
    type = 'IMAGE';
    return true;
  }

  bool _matchRedditVideo() {
    RegExp redditVideoRegEx = new RegExp(r'^https://v\.redd\.it/(\w+)$');
    var match = redditVideoRegEx.firstMatch(url);
    if (match == null) {
      return false;
    }
    var redditVideoId = match.group(1);
    redditVideoUrl = 'https://v.redd.it/$redditVideoId/DASHPlaylist.mpd';
    type = 'REDDITVIDEO';
    return true;
  }

  bool _matchImgurVideo() {
    RegExp imgurVideoRegEx = new RegExp(r'^https://i\.imgur\.com/(\w+)\.gifv$');
    var match = imgurVideoRegEx.firstMatch(url);
    if (match == null) {
      return false;
    }
    var imgurVideoId = match.group(1);
    imgurVideoUrl = 'https://i.imgur.com/$imgurVideoId.mp4';
    type = 'IMGURVIDEO';
    return true;
  }

  void fetchGfycatUrl() {
    gfycatUrlFuture = () async {
      print('xxx fetchGfycatUrl $url');
      List<String> split = url.split('/');
      String gfycatIdLowercase = split[split.length - 1];
      var response = await http
          .get('https://api.gfycat.com/v1/gfycats/$gfycatIdLowercase');
      final body = jsonDecode(response.body);
      String webmUrl = body['gfyItem']['webmUrl'];
      return webmUrl;
    }();
  }
}
