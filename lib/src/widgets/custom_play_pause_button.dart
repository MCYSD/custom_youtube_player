// Copyright 2020 Sarbagya Dhaubanjar. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../enums/player_state.dart';
import '../utils/youtube_player_controller.dart';

/// A widget to display play/pause button.
class CustomPlayPauseButton extends StatefulWidget {
  /// Overrides the default [YoutubePlayerController].
  final YoutubePlayerController? controller;

  /// Defines placeholder widget to show when player is in buffering state.
  final Widget? bufferIndicator;

  Widget btnPlayWidget;

  ValueChanged<bool> forceHideController;

  /// Creates [CustomPlayPauseButton] widget.
  CustomPlayPauseButton({
    required this.forceHideController,
    required this.btnPlayWidget,
    this.controller,
    this.bufferIndicator,
  });

  @override
  _PlayPauseButtonState createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<CustomPlayPauseButton>
    with TickerProviderStateMixin {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = YoutubePlayerController.of(context);
    if (controller == null) {
      assert(
      widget.controller != null,
      '\n\nNo controller could be found in the provided context.\n\n'
          'Try passing the controller explicitly.',
      );
      _controller = widget.controller!;
    } else {
      _controller = controller;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _playerState = _controller.value.playerState;
    if ((!_controller.flags.autoPlay && _controller.value.isReady) ||
        _playerState == PlayerState.playing ||
        _playerState == PlayerState.paused ||
        _playerState == PlayerState.ended) {
      return Visibility(
        visible: _playerState == PlayerState.cued ||
            !_controller.value.isPlaying ||
            _controller.value.isControlsVisible,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              print("controller: play");
              _controller.play();
              widget.forceHideController(true);
            },
            child: widget.btnPlayWidget,
          ),
        ),
      );
    }
    if (_controller.value.hasError) return const SizedBox();

    return widget.bufferIndicator ??
        Container(
          width: 70.0,
          height: 70.0,
          child: const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.white),
          ),
        );
  }
}
