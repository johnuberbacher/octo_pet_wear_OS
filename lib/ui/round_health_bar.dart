import 'package:wear/wear.dart';
import 'package:flutter/material.dart';

class RoundHealthBar extends StatelessWidget {
  const RoundHealthBar({Key? key, required this.petHealth, required this.maximumHealth})
      : super(key: key);
  final int petHealth;
  final int maximumHealth;

  @override
  Widget build(BuildContext context) {
    return AmbientMode(
      builder: (BuildContext context, WearMode mode, Widget? child) {
        return WatchShape(builder: (BuildContext context, WearShape shape, Widget? child) {
          return shape == WearShape.round
              ? Positioned(
                  top: 2,
                  left: 2,
                  right: 2,
                  bottom: 2,
                  child: CircularProgressIndicator(
                    color: mode == WearMode.active ? Color(0xFF222222) : Colors.white,
                    backgroundColor: mode == WearMode.active
                        ? Color(0xFF4c6141).withOpacity(0.66)
                        : Colors.transparent,
                    value: (petHealth / maximumHealth),
                    strokeWidth: 12,
                  ),
                )
              : const Positioned(
                  child: SizedBox(
                    width: 0,
                    height: 0,
                  ),
                );
        });
      },
    );
  }
}
