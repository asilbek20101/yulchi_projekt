import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'page/home_page.dart';

// LoginPage'dan ProfilePage'ga ma'lumot uzatish
final ValueNotifier<String> userNameNotifier =
    ValueNotifier<String>('Foydalanuvchi');

final ValueNotifier<String> userPhoneNotifier =
    ValueNotifier<String>('+998 90 000 00 00');

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    phoneController.dispose();
    nameController.dispose();
    super.dispose();
  }

  void _login() {
    final name = nameController.text.trim();
    final phone = phoneController.text.replaceAll(' ', '');

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF151C18),
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Ism va familyangizni kiriting',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      return;
    }

    if (phone.length != 9) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF151C18),
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Telefon raqamingizni to‘liq kiriting',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      return;
    }

    // Login ma'lumotlarini ProfilePage'ga yuborish
    userNameNotifier.value = name;
    userPhoneNotifier.value =
        '+998 ${phone.substring(0, 2)} ${phone.substring(2, 5)} '
        '${phone.substring(5, 7)} ${phone.substring(7, 9)}';

    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    });
  }

  String _formatPhone(String value) {
    // Faqat raqamlarni olamiz
    String numbers = value.replaceAll(RegExp(r'[^0-9]'), '');

    // Maksimum 9 ta raqam
    if (numbers.length > 9) {
      numbers = numbers.substring(0, 9);
    }

    String result = '';

    for (int i = 0; i < numbers.length; i++) {
      if (i == 2 || i == 5 || i == 7) {
        result += ' ';
      }

      result += numbers[i];
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050806),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 35, 22, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),

              // LOGO
              Center(
                child: Container(
                  width: 92,
                  height: 92,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10251D),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF20D99A),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.local_taxi_rounded,
                    color: Color(0xFF20D99A),
                    size: 45,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              const Center(
                child: Text(
                  'Yulchi Taxi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              const Center(
                child: Text(
                  'JIZZAX',
                  style: TextStyle(
                    color: Color(0xFF20D99A),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 4,
                  ),
                ),
              ),

              const SizedBox(height: 60),

              const Text(
                'Xush kelibsiz ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Taksi buyurtma qilish uchun telefon raqamingizni kiriting.',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 28),

              TextField(
                  controller: nameController,
                  textCapitalization: TextCapitalization.words,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.person_outline_rounded,
                      color: Color(0xFF20D99A),
                    ),
                    hintText: 'Ism va familya',
                    hintStyle: TextStyle(
                      color: Colors.white24,
                      fontSize: 15,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              const Text(
                'Telefon raqami',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 9),

              // TELEFON INPUT
              Container(
                height: 62,
                decoration: BoxDecoration(
                  color: const Color(0xFF0D1411),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFF203129),
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 17),

                    const Text(
                      '+998',
                      style: TextStyle(
                        color: Color(0xFF20D99A),
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(width: 14),

                    Container(
                      width: 1,
                      height: 30,
                      color: const Color(0xFF26362E),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.number,
                        maxLength: 12,
                        inputFormatters: [
                          TextInputFormatter.withFunction(
                            (oldValue, newValue) {
                              final formatted =
                                  _formatPhone(newValue.text);

                              return TextEditingValue(
                                text: formatted,
                                selection: TextSelection.collapsed(
                                  offset: formatted.length,
                                ),
                              );
                            },
                          ),
                        ],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                        decoration: const InputDecoration(
                          counterText: '',
                          hintText: '90 123 45 67',
                          hintStyle: TextStyle(
                            color: Colors.white24,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // DAVOM ETISH
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF20D99A),
                    disabledBackgroundColor:
                        const Color(0xFF16352A),
                    foregroundColor: const Color(0xFF04110B),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 23,
                          height: 23,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.black,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Text(
                              'Davom etish',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.arrow_forward_rounded,
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 18),

              const Center(
                child: Text(
                  'Telefon raqamingiz faqat kirish uchun ishlatiladi',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white30,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}