import 'package:flutter/material.dart';
import './video_container.dart';
import '../models/post.dart';

class TransformUrl extends StatefulWidget {
  final Post post;
  // xTODO page index passed in, initState if future in bloc not started, start, then await result
  TransformUrl(this.post);
  @override
  _TransformUrlState createState() => _TransformUrlState();
}

class _TransformUrlState extends State<TransformUrl> {
  String _videoUrl;
  String _imageUrl;

  @override
  void initState() {
    _transformUrl();
    super.initState();
  }

  void _setStateIfMounted() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _transformUrl() async {
    if (widget.post.type == 'GFYCAT') {
      _videoUrl = await widget.post.gfycatUrlFuture;
      _setStateIfMounted();
      return;
    }

    if (widget.post.type == 'IMGURVIDEO') {
      _videoUrl = widget.post.imgurVideoUrl;
      _setStateIfMounted();
      return;
    }

    if (widget.post.type == 'REDDITVIDEO') {
      _videoUrl = widget.post.redditVideoUrl;
      _setStateIfMounted();
      return;
    }

    if (widget.post.type == 'IMAGE') {
      _imageUrl = widget.post.url;
      _setStateIfMounted();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_videoUrl == null && _imageUrl == null) {
      return CircularProgressIndicator();
    }
    if (_videoUrl != null) {
      return VideoContainer(_videoUrl);
    }
    return Image.network(
      _imageUrl,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
