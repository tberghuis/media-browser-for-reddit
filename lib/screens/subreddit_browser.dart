import 'package:flutter/material.dart';
import '../widgets/transform_url.dart';
import '../models/post.dart';
import 'package:provider/provider.dart';
import '../services/posts_loader.dart';

class SubredditBrowser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String subreddit = ModalRoute.of(context).settings.arguments;
    print('xxx SubredditBrowser subreddit $subreddit');

    return Provider<PostsLoader>(
      create: (context) => PostsLoader(context, subreddit),
      dispose: (context, value) => value.dispose(),
      child: _SubredditBrowserChild(),
    );
  }
}

Widget _wrapScaffold(Widget bodyChild) {
  return Scaffold(
    body: Center(
      child: bodyChild,
    ),
  );
}

class _SubredditBrowserChild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PostsLoader postsLoader = Provider.of<PostsLoader>(context);

    return StreamBuilder<List<Post>>(
      stream: postsLoader.postsSubject.stream,
      initialData: [],
      builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
        var posts = snapshot.data;
        if (posts.length == 0) {
          return _wrapScaffold(CircularProgressIndicator());
        }
        return PageView.builder(
          onPageChanged: (index) {
            print(
                'xxx onPageChanged $index ${posts.length} ${posts[index].url}');
            if (index + 1 == posts.length) {
              postsLoader.loadMorePosts();
            }
          },
          itemBuilder: (context, position) {
            print('xxx itemBuilder $position ${posts[position].url}');
            return _wrapScaffold(TransformUrl(posts[position]));
          },
          itemCount: posts.length,
        );
      },
    );
  }
}
