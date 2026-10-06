import 'dart:async';
import 'package:flutter/material.dart';
import 'page2.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  double progress = 0;

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(milliseconds: 45), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        progress += 0.025;
      });

      if (progress >= 1) {
        timer.cancel();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Page2(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050806),
      body: Stack(
        children: [
          Positioned(
            top: -120,
            left: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                color: const Color(0xFF20D99A).withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            right: -90,
            child: Container(
              width: 360,
              height: 360,
              decoration: BoxDecoration(
                color: const Color(0xFF20D99A).withOpacity(0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 105,
                    height: 105,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10251D),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF20D99A),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF20D99A).withOpacity(0.18),
                          blurRadius: 35,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.local_taxi_rounded,
                      color: Color(0xFF20D99A),
                      size: 50,
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Yulchi Taxi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'JIZZAX',
                    style: TextStyle(
                      color: Color(0xFF20D99A),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 55),
                  SizedBox(
                    width: 150,
                    child: LinearProgressIndicator(
                      value: progress.clamp(0, 1),
                      minHeight: 4,
                      backgroundColor: const Color(0xFF17221D),
                      valueColor: const AlwaysStoppedAnimation(
                        Color(0xFF20D99A),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
