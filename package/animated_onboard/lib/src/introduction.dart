import 'package:flutter/material.dart';

class Introduction extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String subTitle;

  final TextStyle titleTextStyle;
  final TextStyle subTitleTextStyle;
  final Widget Function(String url) imageBuilder;

  const Introduction({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.subTitle,
    this.titleTextStyle = const TextStyle(fontSize: 30),
    this.subTitleTextStyle = const TextStyle(fontSize: 20),
    required this.imageBuilder,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => IntroductionState();
}

class IntroductionState extends State<Introduction> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: widget.imageBuilder(widget.imageUrl),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style: widget.titleTextStyle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Flexible(
            child: Text(
              widget.subTitle,
              style: widget.subTitleTextStyle,
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
