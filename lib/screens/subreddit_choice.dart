import 'package:flutter/material.dart';
import 'package:redditp_clone_client/state/global_state.dart';
import '../widgets/subreddit_list.dart';
import '../widgets/add_subreddit_form.dart';

class SubredditChoice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalState.subredditChoiceScaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddSubredditForm();
            },
          );
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Center(child: SubredditList()),
      ),
    );
  }
}
