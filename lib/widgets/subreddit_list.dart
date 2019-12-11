import 'package:flutter/material.dart';
import '../state/subreddit_list.dart';

class SubredditList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
      stream: subredditListState.subredditListSubject.stream,
      initialData: [],
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.data.length == 0) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Add some subreddits using button below',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _subredditButtonList(context, snapshot.data),
          ),
        );
      },
    );
  }

  List<Widget> _subredditButtonList(context, subredditList) {
    return subredditList
        .map<Widget>((subreddit) => _subredditButton(context, subreddit))
        .toList();
  }

  Widget _subredditButton(context, String subreddit) {
    return GestureDetector(
      onLongPress: () {
        print('long press $subreddit');
        _showDeleteDialog(context, subreddit);
      },
      child: SizedBox(
        width: 200.0,
        child: RaisedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/pageviewdemo', arguments: subreddit);
          },
          child: Text(
            subreddit,
            style: TextStyle(fontSize: 20),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

Future<void> _showDeleteDialog(context, subreddit) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete subreddit \'$subreddit\''),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              subredditListState.deleteSubreddit(subreddit);
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
