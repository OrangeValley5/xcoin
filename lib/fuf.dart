import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  StreamSubscription? _subscription;
  bool isShaking = false;

  int counter1 = 5000;
  double counter2 = 0.00005;
  int progressCounter = 200;
  double progressValue = 1.0;
  bool canIncrement = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 0.0), weight: 1),
    ]).animate(_controller);

    _subscription = accelerometerEvents.listen((AccelerometerEvent event) {
      if (event.x.abs() > 2 || event.y.abs() > 2 || event.z.abs() > 2) {
        if (!isShaking && progressCounter > 0) {
          isShaking = true;
          incrementCounter();
        }
      } else {
        isShaking = false;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _subscription?.cancel();
    super.dispose();
  }

  void _shakeImage() {
    if (progressCounter > 0) {
      _controller.forward(from: 0.0);
      incrementCounter();
    }
  }

  void incrementCounter() {
    setState(() {
      if (progressCounter > 0) {
        counter1 += 1;
        counter2 += 0.00004;
        progressCounter -= 1;
        progressValue = progressCounter / 200;
      } else {
        progressCounter += 1;
        progressValue = progressCounter / 200;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.only(left: 25, top: 20, right: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Color(0xFFFAFAFA),
                              borderRadius: BorderRadius.circular(50)),
                          child: Row(
                            children: const [
                              Icon(Icons.person,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  size: 14),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        const Text(
                          'Tosin',
                          style: TextStyle(
                              color: Color.fromARGB(255, 37, 37, 37),
                              fontSize: 12),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Color(0xFFFAFAFA),
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: const [
                            Icon(Icons.people,
                                color: Color.fromARGB(255, 0, 0, 0), size: 14),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              'Invites',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),

                //PROFIT PER CLICK CONTAINER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Color(0xFFFAFAFA),
                            borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Profit per click',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 12),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset('lib/images/xkoyn.png',
                                    width: 10, height: 10),
                                const SizedBox(
                                  width: 4,
                                ),
                                const Text(
                                  '+1',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 105, 105, 105),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset('lib/images/usdt2.png',
                                    width: 10, height: 10),
                                const SizedBox(
                                  width: 4,
                                ),
                                const Text(
                                  '+0.00005',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 105, 105, 105),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Color(0xFFFAFAFA),
                            borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Profit per hour',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 12),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset('lib/images/xkoyn.png',
                                    width: 10, height: 10),
                                const SizedBox(
                                  width: 4,
                                ),
                                const Text(
                                  '+0',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 105, 105, 105),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset('lib/images/usdt2.png',
                                    width: 10, height: 10),
                                const SizedBox(
                                  width: 4,
                                ),
                                const Text(
                                  '+0',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 105, 105, 105),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('lib/images/xkoyn.png', width: 20, height: 20),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      '$counter1',
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 34,
                          fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('lib/images/usdt2.png', width: 10, height: 10),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      counter2.toStringAsFixed(5),
                      style: TextStyle(
                          color: Color.fromARGB(255, 127, 127, 127),
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  onTap: _shakeImage,
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_animation.value, 0),
                        child: child,
                      );
                    },
                    child: Image.asset('lib/images/xkoyn.png',
                        width: 210, height: 210),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: Container(
                            width: 100,
                            height: 6,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                backgroundColor:
                                    Color.fromARGB(255, 207, 207, 207),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color.fromARGB(255, 0, 0, 0)),
                                minHeight: 10,
                                value: progressValue,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      Text(
                        '$progressCounter / 200',
                        style: TextStyle(
                            color: Color.fromARGB(255, 14, 13, 13),
                            fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
