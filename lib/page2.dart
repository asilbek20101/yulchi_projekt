import 'package:flutter/material.dart';
import 'login_page.dart';

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // FON
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF031C16),
                  Color(0xFF052A21),
                  Color(0xFF07110F),
                ],
              ),
            ),
          ),

          // ORQADAGI YORUG'LIK
          Positioned(
            top: -120,
            right: -80,
            child: Container(
              width: 330,
              height: 330,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF00A879).withOpacity(0.18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00A879).withOpacity(0.22),
                    blurRadius: 120,
                    spreadRadius: 40,
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: -160,
            left: -100,
            child: Container(
              width: 360,
              height: 360,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF00815F).withOpacity(0.15),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00815F).withOpacity(0.20),
                    blurRadius: 120,
                    spreadRadius: 30,
                  ),
                ],
              ),
            ),
          ),

          // ABSTRAKT YO'L CHIZIQLARI
          Positioned.fill(
            child: CustomPaint(
              painter: _RoadPainter(),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Spacer(),

                  // LOGO HALQASI
                  Container(
                    width: 125,
                    height: 125,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF0B3329),
                      border: Border.all(
                        color: const Color(0xFF20C997),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00A879).withOpacity(0.30),
                          blurRadius: 35,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: 82,
                        height: 82,
                        decoration: const BoxDecoration(
                          color: Color(0xFF00815F),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.navigation_rounded,
                          color: Colors.white,
                          size: 43,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  const Text(
                    "Yol'chi",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                  ),

                  const SizedBox(height: 7),

                  const Text(
                    "RIDES • JIZZAX",
                    style: TextStyle(
                      color: Color(0xFF36D9AA),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 4,
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    "Manzilingizga tez, qulay\n"
                    "va xavfsiz yetib boring.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFB4C8C2),
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),

                  const Spacer(),

                  // KIRISH
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A879),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Boshlash",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 21,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    "Yol'chi • Jizzax",
                    style: TextStyle(
                      color: Color(0xFF6D8780),
                      fontSize: 10,
                    ),
                  ),

                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF20C997).withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path1 = Path();

    path1.moveTo(-50, size.height * 0.25);
    path1.quadraticBezierTo(
      size.width * 0.45,
      size.height * 0.05,
      size.width + 70,
      size.height * 0.30,
    );

    canvas.drawPath(path1, paint);

    final path2 = Path();

    path2.moveTo(-80, size.height * 0.75);
    path2.quadraticBezierTo(
      size.width * 0.45,
      size.height * 0.55,
      size.width + 80,
      size.height * 0.72,
    );

    canvas.drawPath(path2, paint);

    final path3 = Path();

    path3.moveTo(size.width * 0.80, -50);
    path3.quadraticBezierTo(
      size.width * 0.55,
      size.height * 0.45,
      size.width * 0.25,
      size.height + 50,
    );

    canvas.drawPath(path3, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}