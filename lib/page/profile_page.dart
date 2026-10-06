import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meta_ai_projekt/login_page.dart';
import 'package:meta_ai_projekt/page/app_settings.dart';

class ProfilePage extends StatefulWidget {
  final ValueNotifier<int> ordersNotifier;
  final ValueNotifier<double> bonusNotifier;

  const ProfilePage({
    super.key,
    required this.ordersNotifier,
    required this.bonusNotifier,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = userNameNotifier.value;
  String userPhone = userPhoneNotifier.value;

  Uint8List? profileImageBytes;

  void _syncLoginProfile() {
    if (!mounted) return;
    setState(() {
      userName = userNameNotifier.value;
      userPhone = userPhoneNotifier.value;
    });
  }

  @override
  void initState() {
    super.initState();
    userNameNotifier.addListener(_syncLoginProfile);
    userPhoneNotifier.addListener(_syncLoginProfile);
  }

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void dispose() {
    userNameNotifier.removeListener(_syncLoginProfile);
    userPhoneNotifier.removeListener(_syncLoginProfile);
    super.dispose();
  }

  static const Color green = Color(0xFF20D99A);
  static const Color darkBg = Color(0xFF050806);
  static const Color darkCard = Color(0xFF0D1411);
  static const Color darkBorder = Color(0xFF203129);

  // GALEREYADAN RASM TANLASH
  Future<void> _pickProfileImage() async {
    try {
      final XFile? picked = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );

      if (picked == null) return;

      // WEB uchun path/File ishlatilmaydi.
      // Rasmni to'g'ridan-to'g'ri bytes sifatida o'qiymiz.
      final Uint8List bytes = await picked.readAsBytes();

      if (bytes.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: darkCard,
            content: Text(
              'Rasmni o‘qib bo‘lmadi',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
        return;
      }

      setState(() {
        profileImageBytes = bytes;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: darkCard,
          content: Text(
            'Rasmni joylashda xatolik: $e',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  Widget _profilePhoto({
    required double size,
    required double iconSize,
  }) {
    if (profileImageBytes == null) {
      return Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: green,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.person_rounded,
          color: Color(0xFF04110B),
          size: iconSize,
        ),
      );
    }

    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: Image.memory(
          profileImageBytes!,
          key: ValueKey(profileImageBytes!.length),
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: green,
              alignment: Alignment.center,
              child: Icon(
                Icons.person_rounded,
                color: Color(0xFF04110B),
                size: iconSize,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: appLanguage,
      builder: (context, language, child) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: appThemeMode,
          builder: (context, themeMode, child) {
            return Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),

                      const SizedBox(height: 20),

                      _buildProfileCard(),

                      const SizedBox(height: 22),

                      _buildStats(),

                      const SizedBox(height: 25),

                      _sectionTitle('Ma\'lumotlar'),

                      const SizedBox(height: 12),

                      _infoCard(
                        icon: Icons.person_outline_rounded,
                        title: 'Ism',
                        value: userName,
                      ),

                      const SizedBox(height: 10),

                      _infoCard(
                        icon: Icons.phone_outlined,
                        title: 'Telefon raqam',
                        value: userPhone,
                      ),

                      const SizedBox(height: 25),

                      _sectionTitle('Sozlamalar'),

                      const SizedBox(height: 12),

                      _profileItem(
                        icon: Icons.edit_rounded,
                        title: 'Profilni tahrirlash',
                        onTap: _showEditProfileDialog,
                      ),

                      _profileItem(
                        icon: Icons.notifications_none_rounded,
                        title: 'Bildirishnomalar',
                        onTap: _showNotifications,
                      ),

                      _profileItem(
                        icon: Icons.location_on_outlined,
                        title: 'Saqlangan manzillar',
                        onTap: _showSavedAddresses,
                      ),

                      _profileItem(
                        icon: Icons.help_outline_rounded,
                        title: 'Yordam',
                        onTap: _showHelp,
                      ),

                      const SizedBox(height: 15),

                      _profileItem(
                        icon: Icons.logout_rounded,
                        title: 'Hisobdan chiqish',
                        color: Colors.redAccent,
                        onTap: _showLogoutDialog,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // HEADER
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Profil',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),

        GestureDetector(
          onTap: _showEditProfileDialog,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: darkCard,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: darkBorder,
              ),
            ),
            child: const Icon(
              Icons.edit_rounded,
              color: green,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  // PROFILE CARD
  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: darkCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: darkBorder,
        ),
      ),
      child: Row(
        children: [
          // RASMGA BOSILGANDA GALLERY OCHILADI
          GestureDetector(
            onTap: _pickProfileImage,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: green.withOpacity(0.18),
                        blurRadius: 20,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: _profilePhoto(
                    size: 72,
                    iconSize: 40,
                  ),
                ),

                // CAMERA ICON
                Positioned(
                  right: -3,
                  bottom: -3,
                  child: Container(
                    width: 27,
                    height: 27,
                    decoration: BoxDecoration(
                      color: green,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: darkBg,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.black,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  userPhone,
                  style: GoogleFonts.roboto(
                    color: Colors.white60,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 8),

                GestureDetector(
                  onTap: _pickProfileImage,
                  child: Text(
                    'Rasmni o‘zgartirish',
                    style: GoogleFonts.inter(
                      color: green,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // STATISTICS
  Widget _buildStats() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 18,
      ),
      decoration: BoxDecoration(
        color: darkCard,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: darkBorder,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: ValueListenableBuilder<int>(
              valueListenable: widget.ordersNotifier,
              builder: (context, orders, child) {
                return _statItem(
                  value: '$orders',
                  title: 'Safarlar',
                );
              },
            ),
          ),

          _verticalDivider(),

          Expanded(
            child: _statItem(
              value: '4.9',
              title: 'Baholar',
            ),
          ),

          _verticalDivider(),

          Expanded(
            child: ValueListenableBuilder<double>(
              valueListenable: widget.bonusNotifier,
              builder: (context, bonus, child) {
                return _statItem(
                  value: _formatMoney(bonus),
                  title: 'Bonus',
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _statItem({
    required String value,
    required String title,
  }) {
    return Column(
      children: [
        Text(
          value,
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            color: green,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.nunito(
            color: Colors.white54,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _verticalDivider() {
    return Container(
      width: 1,
      height: 38,
      color: darkBorder,
    );
  }

  // INFO CARD
  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: darkCard,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: darkBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: green.withOpacity(0.10),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: green,
              size: 21,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.nunito(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // SETTINGS ITEM
  Widget _profileItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    final itemColor = color ?? Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 9),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        decoration: BoxDecoration(
          color: darkCard,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: darkBorder,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: color ?? green,
              size: 21,
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  color: itemColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.white30,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: 17,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  // PROFILNI TAHRIRLASH
  void _showEditProfileDialog() {
    final nameController = TextEditingController(
      text: userName,
    );

    final phoneController = TextEditingController(
      text: userPhone
          .replaceAll(RegExp(r'[^0-9]'), '')
          .replaceFirst('998', ''),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: darkCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Text(
            'Profilni tahrirlash',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // DIALOG ICHIDA HAM RASMGA BOSILSA GALLERY OCHILADI
              GestureDetector(
                onTap: _pickProfileImage,
                child: Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: _profilePhoto(
                        size: 80,
                        iconSize: 42,
                      ),
                    ),

                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: const BoxDecoration(
                          color: green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.black,
                          size: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: nameController,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  labelText: 'Ism',
                  labelStyle: const TextStyle(
                    color: Colors.white54,
                  ),
                  prefixIcon: const Icon(
                    Icons.person_outline,
                    color: green,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: darkBorder,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: green,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 9,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  labelText: 'Telefon raqam',
                  labelStyle: const TextStyle(
                    color: Colors.white54,
                  ),
                  prefixText: '+998 ',
                  prefixStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  prefixIcon: const Icon(
                    Icons.phone_outlined,
                    color: green,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: darkBorder,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: green,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Bekor qilish',
                style: TextStyle(
                  color: Colors.white54,
                ),
              ),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: green,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                final name = nameController.text.trim();
                final phone = phoneController.text.trim();

                if (name.isEmpty) {
                  return;
                }

                if (phone.length != 9) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Telefon raqam 9 ta raqamdan iborat bo‘lishi kerak',
                      ),
                    ),
                  );
                  return;
                }

                final formattedPhone =
                    '+998 ${phone.substring(0, 2)} ${phone.substring(2, 5)} '
                    '${phone.substring(5, 7)} ${phone.substring(7, 9)}';

                setState(() {
                  userName = name;
                  userPhone = formattedPhone;
                });

                // Profil tahrirlanganda ham umumiy ma'lumot yangilanadi.
                userNameNotifier.value = name;
                userPhoneNotifier.value = formattedPhone;

                Navigator.pop(context);
              },
              child: Text(
                'Saqlash',
                style: GoogleFonts.spaceGrotesk(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showNotifications() {
    showDialog(
      context: context,
      builder: (context) {
        bool enabled = true;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: darkCard,
              title: const Text(
                'Bildirishnomalar',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              content: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Bildirishnomalarni olish',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                value: enabled,
                activeColor: green,
                onChanged: (value) {
                  setDialogState(() {
                    enabled = value;
                  });
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Yopish',
                    style: TextStyle(
                      color: green,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showSavedAddresses() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: darkCard,
          title: const Text(
            'Saqlangan manzillar',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: const Text(
            'Hozircha saqlangan manzillar mavjud emas.',
            style: TextStyle(
              color: Colors.white60,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Yopish',
                style: TextStyle(
                  color: green,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showHelp() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: darkCard,
          title: const Text(
            'Yordam',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: const Text(
            'Muammo bo‘lsa, qo‘llab-quvvatlash xizmatiga murojaat qiling.',
            style: TextStyle(
              color: Colors.white60,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Yopish',
                style: TextStyle(
                  color: green,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: darkCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Hisobdan chiqish',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Haqiqatan ham hisobdan chiqmoqchimisiz?',
            style: TextStyle(
              color: Colors.white60,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Yo‘q',
                style: TextStyle(
                  color: Colors.white54,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginPage(),
                  ),
                  (route) => false,
                );
              },
              child: const Text(
                'Ha, chiqish',
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatMoney(double value) {
    final number = value.round().toString();

    final chars = number.split('');

    String result = '';

    for (int i = 0; i < chars.length; i++) {
      final positionFromEnd = chars.length - i;

      result += chars[i];

      if (positionFromEnd > 1 &&
          positionFromEnd % 3 == 1) {
        result += ' ';
      }
    }

    return '$result so‘m';
  }
}