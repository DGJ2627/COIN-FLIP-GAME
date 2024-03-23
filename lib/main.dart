import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(CoinFlipApp());
}

class CoinFlipApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coin Flip',
      home: CoinFlipScreen(),
    );
  }
}

class CoinFlipScreen extends StatefulWidget {
  @override
  _CoinFlipScreenState createState() => _CoinFlipScreenState();
}

class _CoinFlipScreenState extends State<CoinFlipScreen>
    with SingleTickerProviderStateMixin {
  bool isFlipping = false;
  bool isHeads = true;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween(begin: 0.0, end: 2 * pi).animate(_animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            isHeads = Random().nextBool();
            isFlipping = false;
          });
          _animationController.reset();
        }
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _flipCoin() {
    setState(() {
      isFlipping = true;
    });
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    const String goldImage = "lib/Assets/gold_img.png";
    const String silverImage = "lib/Assets/silver_img.png";
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text('Coin Flip',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              isFlipping ? 'Flipping...' : (isHeads ? 'Gold' : 'Silver'),
              style: const TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold,color: Colors.white),
            ),
            const SizedBox(height: 20.0),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 2000),
              child: isFlipping
                  ? Transform.rotate(
                angle: _animation.value,
                child: const CircularProgressIndicator(color: Colors.yellow),
              )
                  : GestureDetector(
                onTap: _flipCoin,
                child: Image.asset(
                  fit: BoxFit.contain,
                  isHeads ? goldImage : silverImage,
                  width: 150.0,
                  height: 150.0,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _flipCoin,
        tooltip: 'Flip Coin',
        child: const Icon(Icons.autorenew),
      ),
    );
  }
}
