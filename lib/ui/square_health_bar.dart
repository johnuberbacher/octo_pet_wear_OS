import 'package:wear/wear.dart';
import 'package:flutter/material.dart';

class SquareHealthBar extends StatelessWidget {
  const SquareHealthBar({Key? key, required this.petHealth, required this.maximumHealth})
      : super(key: key);
  final int petHealth;
  final int maximumHealth;

  @override
  Widget build(BuildContext context) {
    return AmbientMode(
      builder: (BuildContext context, WearMode mode, Widget? child) {
        return WatchShape(
          builder: (BuildContext context, WearShape shape, Widget? child) {
            return shape != WearShape.round
                ? Center(
                    child: Container(
                      margin: EdgeInsets.only(
                        top: (MediaQuery.of(context).size.height * 0.1),
                      ),
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.8,
                      color: mode == WearMode.active ? Color(0xFF4c6141) : Colors.transparent,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: (petHealth / maximumHealth),
                          heightFactor: 1,
                          child: Container(
                            color: mode == WearMode.active ? Color(0xFF222222) : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(
                    width: 0,
                    height: 0,
                  );
          },
        );
      },
    );
  }
}
