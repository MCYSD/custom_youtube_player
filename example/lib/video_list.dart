import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Creates list of video players
class VideoList extends StatefulWidget {
  @override
  _VideoListState createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  final List<YoutubePlayerController> _controllers = [
    'gQDByCdjUXw',
    'iLnmTe5Q2Qw',
    '_WoCV4c6XOE',
    'KmzdUe0RSJo',
    '6jZDSSZZxjQ',
    'p2lYr3vM_1w',
    '7QUtEmBT_-w',
    '34_PXCzGw1M',
  ]
      .map<YoutubePlayerController>(
        (videoId) => YoutubePlayerController(
          initialVideoId: videoId,
          flags: YoutubePlayerFlags(
            autoPlay: false,
          ),
        ),
      )
      .toList();

  late ScrollController _controller;

  var _itemHeight = 100.0 ;

  int _centeredItems = 1 ;

  late int _numberOfEdgesItems ; // number of items which aren't centered at any moment

  late int _aboveItems ; // number of items above the centered ones

  late int _belowItems ; // number of items below the centered ones

  @override
  void initState() {
    _controller = ScrollController(); // Initializing ScrollController
    _controller.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video List Demo'),
      ),
      body: ListView.separated(
        controller: _controller,
        itemBuilder: (context, index) {
          _aboveItems = ( ( (_controller.offset) / (_itemHeight) )).toInt() ;

          _belowItems = _aboveItems + _centeredItems ;

          var isCentered = index >= _aboveItems && index < _belowItems;
          print("isCentered:$isCentered _controller.offset:${_controller.offset} index: $index _aboveItems:$_aboveItems _belowItems: $_belowItems");
          _controllers[index].flags.autoPlay = isCentered;
          return YoutubePlayer(
            key: ObjectKey(_controllers[index]),
            controller: _controllers[index],
            actionsPadding: const EdgeInsets.only(left: 16.0),
            bottomActions: [
              CurrentPosition(),
              const SizedBox(width: 10.0),
              ProgressBar(isExpanded: true),
              const SizedBox(width: 10.0),
              RemainingDuration(),
              FullScreenButton(),
            ],
          );
        },
        itemCount: _controllers.length,
        separatorBuilder: (context, _) => const SizedBox(height: 10.0),
      ),
    );
  }
}
