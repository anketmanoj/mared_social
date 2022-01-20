import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:video_player/video_player.dart';

class SeeVideo extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;

  const SeeVideo({Key? key, required this.documentSnapshot}) : super(key: key);
  @override
  _SeeVideoState createState() => _SeeVideoState();
}

class _SeeVideoState extends State<SeeVideo> {
  ConstantColors constantColors = ConstantColors();
  VideoPlayerController? _controller;

  @override
  void initState() {
    _controller =
        VideoPlayerController.network(widget.documentSnapshot['video'])
          ..initialize().then((_) {
            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
            setState(() {});
            _controller!.play();
          });

    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.darkColor,
      body: SafeArea(
        child: GestureDetector(
          onLongPressEnd: (details) {
            _controller!.play();
          },
          onPanUpdate: (update) {
            if (update.delta.dx > 0) {
              Navigator.pop(context);
            }
          },
          onLongPress: () {
            _controller!.pause();
          },
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: _controller!.value.isInitialized
                                ? VideoPlayer(
                                    _controller!,
                                  )
                                : LoadingWidget(constantColors: constantColors),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
