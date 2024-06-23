import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class WishlistButton extends StatefulWidget {
  const WishlistButton({
    super.key,
    required this.onButtonTap,
    required this.buttonDimension,
    required this.onWishlist,
  });

  final Function() onButtonTap;
  final double buttonDimension;
  final bool onWishlist;

  @override
  State<WishlistButton> createState() => _WishlistButtonState();
}

class _WishlistButtonState extends State<WishlistButton> {
  Artboard? riveArtboard;
  SMIInput<bool>? pressInput;

  @override
  void initState() {
    super.initState();
    rootBundle.load('assets/rive/favorite.riv').then(
      (data) async {
        final file = RiveFile.import(data);

        final artboard = file.artboardByName('favorite V2');
        if (artboard == null) return '';

        final controller =
            StateMachineController.fromArtboard(artboard, 'State Machine 1');

        if (controller == null) return '';

        artboard.addController(controller);

        setState(() {
          pressInput = controller.findInput('status');
          riveArtboard = artboard;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: widget.buttonDimension,
      child: GestureDetector(
        onTap: () {
          widget.onButtonTap();
          setState(() => pressInput!.change(!pressInput!.value));
        },
        child: riveArtboard == null
            ? const Icon(Icons.favorite_rounded)
            : Rive(artboard: riveArtboard!),
      ),
    );
  }
}
