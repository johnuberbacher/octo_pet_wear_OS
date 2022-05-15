import 'dart:async';
import 'dart:math';
import 'package:wear/wear.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:octo_pet_wear_os/ui/ui.dart';

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> with WidgetsBindingObserver {
  int gameTicker = 0;
  int gameTickerDuration = 1000; // 1000 milliseconds = 1 second

  String petType = 'egg';
  String petIndex = '0';
  String petMood = '';
  int petHealth = 1800; // 7200 seconds = 2 hours
  bool isEmote = false;
  bool isMenu = false;

  int negativeModifier = 1;
  int positiveModifier = 60;
  int maximumHealth = 1800;

  String hatchMsg = 'Hatch me';
  int hatchCount = 0;

  Audio audioUI = Audio.load('assets/sfx/ui.wav');
  Audio audioHatch = Audio.load('assets/sfx/hatch.wav');
  Audio audioSpawn = Audio.load('assets/sfx/spawn.wav');
  Audio audioFull = Audio.load('assets/sfx/full.wav');
  Audio audioPoof = Audio.load('assets/sfx/poof.wav');
  Audio audioEgg = Audio.load('assets/sfx/egg.wav');

  actionHatchEgg() {
    if (hatchCount < 3) {
      setState(() {
        hatchCount++;
        audioHatch.play();
        if (hatchCount == 0) {
          hatchMsg = 'Hatch me!';
        } else if (hatchCount == 1) {
          hatchMsg = 'Keep going!';
        } else if (hatchCount == 2) {
          hatchMsg = 'Almost there!';
        } else if (hatchCount == 3) {
          hatchMsg = 'Here I come!';
        }
      });
    } else if (hatchCount == 3) {
      int randomPetType = (Random().nextInt(100) + 1);

      if (randomPetType >= 90 && randomPetType <= 100) {
        setState(() {
          petType = 'bot';
        });
      } else if (randomPetType >= 0 && randomPetType <= 24) {
        setState(() {
          petType = 'dog';
        });
      } else if (randomPetType >= 25 && randomPetType <= 44) {
        setState(() {
          petType = 'bat';
        });
      } else if (randomPetType >= 45 && randomPetType <= 64) {
        setState(() {
          petType = 'fox';
        });
      } else if (randomPetType >= 65 && randomPetType <= 90) {
        setState(() {
          petType = 'ox';
        });
      }

      hatchCount = 0;
      hatchMsg = 'Hatch me!';
      audioSpawn.play();
    }
  }

  actionEmote() {
    if (isEmote == false && petType != 'egg') {
      audioUI.play();
      setState(() {
        isEmote = true;
      });
      Future.delayed(const Duration(milliseconds: 3000)).then((_) {
        isEmote = false;
        if ((petHealth + positiveModifier) >= maximumHealth) {
          setState(() {
            petHealth = maximumHealth;
          });
        } else {
          setState(() {
            petHealth = petHealth + positiveModifier;
          });
        }
        audioFull.play();
      });
    }
  }

  actionOpenMenu() {
    audioUI.play();
    if (mounted) {
      setState(() {
        isMenu = true;
      });
    }
  }

  actionCloseMenu() {
    audioUI.play();
    if (mounted) {
      setState(() {
        isMenu = true;
      });
    }
  }

  showEgg() {
    return GestureDetector(
      onTap: () => actionHatchEgg(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.1,
            ),
            child: Center(
              child: AmbientMode(
                builder: (BuildContext context, WearMode mode, Widget? child) {
                  return mode == WearMode.active
                      ? AnimatedSwitcher(
                          duration: const Duration(milliseconds: 1000),
                          child: petSprite(),
                        )
                      : petAmbientSprite();
                },
              ),
            ),
          ),
          WatchShape(
            builder: (BuildContext context, WearShape shape, Widget? child) {
              return Container(
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.0,
                ),
                width: shape != WearShape.round
                    ? MediaQuery.of(context).size.width * 0.9
                    : MediaQuery.of(context).size.width * 0.65,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: AmbientMode(
                    builder: (BuildContext context, WearMode mode, Widget? child) {
                      return mode == WearMode.active
                          ? Text(
                              hatchMsg,
                              textAlign: TextAlign.center,
                            )
                          : Text(
                              hatchMsg,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  showPet() {
    return AmbientMode(
      builder: (BuildContext context, WearMode mode, Widget? child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            RoundHealthBar(petHealth: petHealth, maximumHealth: maximumHealth),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /////////////////////////////////////////
                // Handle Emote, Pet & Ambient Sprites //
                /////////////////////////////////////////
                Stack(
                  children: [
                    Pet(
                      actionEmote: actionEmote,
                      petSprite: petSprite,
                      petAmbientSprite: petAmbientSprite,
                    ),
                  ],
                ),
                SquareHealthBar(petHealth: petHealth, maximumHealth: maximumHealth)
              ],
            ),
            showEmote(),
          ],
        );
      },
    );
  }

  petSprite() {
    List<String> petSprites = [];
    petSprites.add('assets/images/pet/${petType}1.png');
    petSprites.add('assets/images/pet/${petType}2.png');
    return Image.asset(
      petSprites[gameTicker % petSprites.length],
      fit: BoxFit.fitWidth,
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.height * 0.65,
      height: MediaQuery.of(context).size.height * 0.65,
    );
  }

  petAmbientSprite() {
    List<String> ambientPetSprites = [];
    ambientPetSprites.add('assets/images/pet/ambient/ambient${petType}1.png');
    ambientPetSprites.add('assets/images/pet/ambient/ambient${petType}2.png');
    return Image.asset(
      ambientPetSprites[gameTicker % ambientPetSprites.length],
      fit: BoxFit.fitWidth,
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.height * 0.65,
      height: MediaQuery.of(context).size.height * 0.65,
    );
  }

  showEmote() {
    return AmbientMode(builder: (BuildContext context, WearMode mode, Widget? child) {
      return mode == WearMode.active
          ? Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: isEmote == true
                  ? SizedBox(
                      child: Image.asset(
                        'assets/images/emotes/emote_happy.png',
                        fit: BoxFit.scaleDown,
                        height: MediaQuery.of(context).size.height / 1.75,
                        width: MediaQuery.of(context).size.width / 1.75,
                      ),
                    )
                  : const SizedBox(
                      width: 0,
                      height: 0,
                    ),
            )
          : Container();
    });
  }

  gameLoop() {
    Timer.periodic(Duration(milliseconds: gameTickerDuration), (timer) {
      setState(() => gameTicker++);
      print(petHealth);
      if (petType != "egg") {
        if (petHealth - negativeModifier >= 1) {
          setState(() {
            petHealth = petHealth - negativeModifier;
          });
        } else {
          setState(() {
            petType = "egg";
          });
        }
      } else {
        setState(() {
          petHealth = maximumHealth;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    gameLoop();
  }

  @override
  Widget build(BuildContext context) {
    return AmbientMode(
      builder: (BuildContext context, WearMode mode, Widget? child) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  scale: 2.5,
                  repeat: ImageRepeat.repeat,
                  alignment: Alignment(0, 0),
                  image: AssetImage(
                    mode == WearMode.active
                        ? 'assets/images/bg.png'
                        : 'assets/images/bg_ambient.png',
                  ),
                ),
              ),
              child: petType != 'egg' ? showPet() : showEgg()),
        );
      },
    );
  }
}
