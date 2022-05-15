import 'package:wear/wear.dart';
import 'package:flutter/material.dart';

class Pet extends StatelessWidget {
  const Pet(
      {Key? key,
      required this.actionEmote,
      required this.petSprite,
      required this.petAmbientSprite})
      : super(key: key);
  final Function() actionEmote;
  final Function() petSprite;
  final Function() petAmbientSprite;

  @override
  Widget build(BuildContext context) {
    return AmbientMode(
      builder: (BuildContext context, WearMode mode, Widget? child) {
        return mode == WearMode.active
            ? GestureDetector(
                onTap: () => actionEmote(),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 1000),
                  child: petSprite(),
                ),
              )
            : petAmbientSprite();
      },
    );
  }
}
