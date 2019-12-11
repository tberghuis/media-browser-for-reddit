import 'package:flutter/material.dart';
import '../state/subreddit_list.dart';

class AddSubredditForm extends StatefulWidget {
  @override
  AddSubredditFormState createState() {
    return AddSubredditFormState();
  }
}

class AddSubredditFormState extends State<AddSubredditForm> {
  final _formKey = GlobalKey<FormState>();
  var _subreddit = '';
  bool _validating = false;

  void _submit() async {
    setState(() {
      _validating = true;
    });
    bool valid = await subredditListState.validateSubreddit(_subreddit);
    setState(() {
      _validating = false;
    });
    if (valid) {
      Navigator.of(context).pop();
      subredditListState.addSubreddit(_subreddit);
      return;
    }
    _formKey.currentState.validate();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AlertDialog(
        title: Text("Add Subreddit"),
        content: TextFormField(
          autofocus: true,
          validator: (value) {
            return 'Invalid Subreddit';
          },
          onFieldSubmitted: (text) {
            print('onFieldSubmitted $text');
            _submit();
          },
          onChanged: (value) {
            print('onchanged $value');

            // do i need to wrap with setState if i don't need a rerender??? assume no for now
            _subreddit = value;
          },
        ),
        actions: <Widget>[
          if (_validating) CircularProgressIndicator(),
          new FlatButton(
            child: new Text("Add"),
            onPressed: _validating ? null : _submit,
          ),
          new FlatButton(
            child: new Text("Cancel"),
            onPressed: _validating ? null : Navigator.of(context).pop,
          ),
        ],
      ),
    );
  }
}
