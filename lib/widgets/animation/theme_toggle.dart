import 'package:e_com/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class ThemeToggle extends StatefulWidget {
  const ThemeToggle({
    super.key,
    required this.onTap,
    required this.size,
  });

  final Function() onTap;
  final double size;

  @override
  State<ThemeToggle> createState() => _ThemeToggleState();
}

class _ThemeToggleState extends State<ThemeToggle> {
  StateMachineController? stateController;
  Artboard? artboard2;
  SMITrigger? trigger;

  @override
  void initState() {
    super.initState();
    rootBundle.load('assets/rive/theme.riv').then(
      (data) {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;

        stateController =
            StateMachineController.fromArtboard(artboard, "theme");
        artboard.addController(stateController!);
        trigger = stateController!.findSMI('toggleTheme');

        trigger = stateController!.inputs.toList()[1] as SMITrigger;
        if (context.isDark) {
          trigger!.fire();
        }
        setState(() {
          artboard2 = artboard;
        });
      },
    );
  }

  void toggle() => setState(() => trigger!.fire());

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: widget.size,
      child: GestureDetector(
        onTap: () {
          widget.onTap();
          toggle();
        },
        child: artboard2 == null
            ? const Icon(Icons.light_mode_rounded)
            : Rive(artboard: artboard2!),
      ),
    );
  }
}
