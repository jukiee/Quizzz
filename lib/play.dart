import 'gamescreen.dart';
import 'package:flutter/material.dart';

class PlayGame extends StatelessWidget {
  const PlayGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const PlayGameWrapper();
  }
}

class PlayGameWrapper extends StatefulWidget {
  const PlayGameWrapper({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PlayGameWrapperState();
  }

}

class _PlayGameWrapperState extends State<PlayGameWrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background2.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: const Center(
                child: GameScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}