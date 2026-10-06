
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:meta_ai_projekt/page/app_settings.dart';

class WalletPage extends StatefulWidget {
  final ValueNotifier<double> balanceNotifier;

  WalletPage({
    super.key,
    required this.balanceNotifier,
  });

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  bool showTopUpPage = false;
  String? selectedCard;

  final TextEditingController cardController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  final List<Map<String, dynamic>> cards = [
    {
      'name': 'Uzcard',
      'icon': Icons.credit_card_rounded,
      'color': Color(0xFF20D99A),
    },
    {
      'name': 'Humo',
      'icon': Icons.credit_card_rounded,
      'color': Color(0xFF00A8FF),
    },
    {
      'name': 'Visa',
      'icon': Icons.credit_card_rounded,
      'color': Color(0xFF4969FF),
    },
    {
      'name': 'Mastercard',
      'icon': Icons.credit_card_rounded,
      'color': Color(0xFFFF6B35),
    },
  ];

  final List<Map<String, dynamic>> history = [];

  @override
  void dispose() {
    cardController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: appLanguage,
      builder: (context, language, child) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: appThemeMode,
          builder: (context, themeMode, child) {
            return showTopUpPage ? _topUpPage() : _walletPage();
          },
        );
      },
    );
  }

  // =========================================================
  // WALLET PAGE
  // =========================================================

  Widget _walletPage() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  tr('Fund Pay'),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 30),
                child: Column(
                  children: [
                    _balanceCard(),

                    SizedBox(height: 16),

                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showTopUpPage = true;
                          selectedCard = null;
                          cardController.clear();
                          amountController.clear();
                        });
                      },
                      child: _walletAction(
                        Icons.add_card_rounded,
                        tr('Balansni to‘ldirish'),
                        tr('Kartadan balansga pul qo‘shish'),
                      ),
                    ),

                    SizedBox(height: 10),

                    GestureDetector(
                      onTap: _showHistory,
                      child: _walletAction(
                        Icons.receipt_long_rounded,
                        tr('To‘lovlar tarixi'),
                        tr('Amalga oshirilgan to‘lovlar'),
                      ),
                    ),

                    SizedBox(height: 20),

                    if (history.isNotEmpty) _historyPreview(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // FUND PAY PLASTIC CARD
  // =========================================================

  Widget _balanceCard() {
    return ValueListenableBuilder<double>(
      valueListenable: widget.balanceNotifier,
      builder: (context, balance, child) {
        final bool isDark = Theme.of(context).brightness == Brightness.dark;

        return Container(
          width: double.infinity,
          height: 215,
          padding: EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),

            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      Color(0xFF193B2A),
                      Color(0xFF0B1B13),
                      Color(0xFF030705),
                    ]
                  : [
                      Color(0xFFFFFFFF),
                      Color(0xFFF0F8F3),
                      Color(0xFFE1F1E8),
                    ],
            ),

            border: Border.all(
              color: Color(0xFF20D66B).withOpacity(0.35),
              width: 1,
            ),

            boxShadow: [
              BoxShadow(
                color: Color(0xFF20D66B).withOpacity(0.12),
                blurRadius: 25,
                spreadRadius: 1,
              ),
            ],
          ),

          child: Stack(
            children: [
              Positioned(
                right: -45,
                top: -55,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF20D66B).withOpacity(0.08),
                  ),
                ),
              ),

              Positioned(
                right: 25,
                bottom: -65,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF20D66B).withOpacity(0.04),
                  ),
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'FUND PAY',
                        style: TextStyle(
                          color: isDark ? Colors.white : const Color(0xFF10251D),
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.6,
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF20D66B).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Color(0xFF20D66B).withOpacity(0.2),
                          ),
                        ),
                        child: Text(
                          'DEBIT',
                          style: TextStyle(
                            color: Color(0xFF20D66B),
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 17),

                  Container(
                    width: 45,
                    height: 34,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFD0E8D7),
                          Color(0xFF65A97D),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 1,
                          width: 30,
                          color: Colors.black.withOpacity(0.35),
                        ),
                        SizedBox(height: 5),
                        Container(
                          height: 1,
                          width: 30,
                          color: Colors.black.withOpacity(0.35),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 13),

                  Text(
                    '••••  ••••  ••••  4827',
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF10251D),
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2.3,
                    ),
                  ),

                  Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'BALANCE',
                            style: TextStyle(
                              color: isDark ? Colors.white.withOpacity(0.5) : const Color(0xFF567065),
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.3,
                            ),
                          ),

                          SizedBox(height: 3),

                          Text(
                            _formatMoney(balance),
                            style: TextStyle(
                              color: isDark ? Colors.white : const Color(0xFF10251D),
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),

                      Text(
                        'FUND',
                        style: TextStyle(
                          color: Color(0xFF20D66B),
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                          letterSpacing: -1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // =========================================================
  // TOP UP PAGE
  // =========================================================

  Widget _topUpPage() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showTopUpPage = false;
                        selectedCard = null;
                      });
                    },
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),

                  SizedBox(width: 14),

                  Text(
                    tr('Balansni to‘ldirish'),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20, 15, 20, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr('To‘lov usulini tanlang'),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    SizedBox(height: 6),

                    Text(
                      tr('Kartangizni tanlang'),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.58),
                        fontSize: 13,
                      ),
                    ),

                    SizedBox(height: 18),

                    ...cards.map(
                      (card) => _paymentCard(
                        name: card['name'] as String,
                        icon: card['icon'] as IconData,
                        color: card['color'] as Color,
                      ),
                    ),

                    if (selectedCard != null) ...[
                      SizedBox(height: 24),
                      _cardForm(),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // PAYMENT CARD
  // =========================================================

  Widget _paymentCard({
    required String name,
    required IconData icon,
    required Color color,
  }) {
    final bool selected = selectedCard == name;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCard = name;
          cardController.clear();
          amountController.clear();
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: selected
              ? Color(0xFF10251D)
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? Color(0xFF20D99A)
                : Theme.of(context).dividerColor,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),

            SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  SizedBox(height: 4),

                  Text(
                    tr('Bank karta'),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.58),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              selected
                  ? Icons.check_circle_rounded
                  : Icons.chevron_right_rounded,
              color: selected
                  ? Color(0xFF20D99A)
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.58),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // CARD FORM
  // =========================================================

  Widget _cardForm() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${selectedCard} ${tr('Karta maʼlumotlari')}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),

          SizedBox(height: 18),

          _cardNumberField(),

          SizedBox(height: 14),

          _inputField(
            controller: amountController,
            label: tr('Summa'),
            hint: '50 000',
            icon: Icons.payments_rounded,
          ),

          SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _addMoney,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF20D99A),
                foregroundColor: Color(0xFF04110B),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
              ),
              child: Text(
                tr('Balansni to‘ldirish'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // CARD NUMBER INPUT
  // =========================================================

  Widget _cardNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr('Karta raqami'),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.68),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),

        SizedBox(height: 7),

        TextField(
          controller: cardController,
          keyboardType: TextInputType.number,
          maxLength: 19,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(16),
            _CardNumberFormatter(),
          ],
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
          decoration: InputDecoration(
            counterText: '',
            hintText: '8600 0000 0000 0000',
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.35),
            ),
            prefixIcon: Icon(
              Icons.credit_card_rounded,
              color: Color(0xFF20D99A),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Theme.of(context).dividerColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Theme.of(context).dividerColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Color(0xFF20D99A),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // INPUT
  // =========================================================

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.68),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),

        SizedBox(height: 7),

        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.35),
            ),
            prefixIcon: Icon(
              icon,
              color: Color(0xFF20D99A),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Theme.of(context).dividerColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Theme.of(context).dividerColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Color(0xFF20D99A),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // ADD MONEY
  // =========================================================

  void _addMoney() {
    if (selectedCard == null) {
      _showMessage(tr('Avval karta turini tanlang'));
      return;
    }

    final String card = cardController.text.replaceAll(' ', '');
    final String amountText = amountController.text.replaceAll(' ', '');

    if (card.length != 16) {
      _showMessage(tr('Karta raqami 16 ta raqamdan iborat bo‘lishi kerak'));
      return;
    }

    final double? amount = double.tryParse(amountText);

    if (amount == null || amount <= 0) {
      _showMessage(tr('To‘g‘ri summa kiriting'));
      return;
    }

    widget.balanceNotifier.value += amount;

    history.insert(0, {
      'card': selectedCard,
      'amount': amount,
      'date': DateTime.now(),
    });

    setState(() {
      showTopUpPage = false;
      selectedCard = null;
      cardController.clear();
      amountController.clear();
    });

    _showMessage(
      '${_formatMoney(amount)} ${tr('balansga qo‘shildi')}',
    );
  }

  // =========================================================
  // HISTORY PREVIEW
  // =========================================================

  Widget _historyPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            tr('So‘nggi to‘lovlar'),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        SizedBox(height: 12),

        ...history.take(3).map(
          (item) {
            return Container(
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(17),
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Color(0xFF10251D),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      Icons.add_rounded,
                      color: Color(0xFF20D99A),
                    ),
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['card'] as String,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        SizedBox(height: 3),

                        Text(
                          tr('Balans to‘ldirildi'),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.58),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Text(
                    '+${_formatMoney(item['amount'] as double)}',
                    style: TextStyle(
                      color: Color(0xFF20D99A),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // =========================================================
  // FULL HISTORY
  // =========================================================

  void _showHistory() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr('To‘lovlar tarixi'),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                SizedBox(height: 18),

                if (history.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 35,
                    ),
                    child: Center(
                      child: Text(
                        tr('Hozircha to‘lovlar yo‘q'),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.58),
                        ),
                      ),
                    ),
                  )
                else
                  ...history.map(
                    (item) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: 12,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              color: Color(0xFF20D99A),
                            ),

                            SizedBox(width: 12),

                            Expanded(
                              child: Text(
                                item['card'] as String,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),

                            Text(
                              '+${_formatMoney(item['amount'] as double)}',
                              style: TextStyle(
                                color: Color(0xFF20D99A),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // =========================================================
  // WALLET ACTION
  // =========================================================

  Widget _walletAction(
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Container(
      padding: EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Color(0xFF10251D),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: Color(0xFF20D99A),
            ),
          ),

          SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),

                SizedBox(height: 3),

                Text(
                  subtitle,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.58),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          Icon(
            Icons.chevron_right_rounded,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.58),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // MONEY FORMAT
  // =========================================================

  String _formatMoney(double value) {
    final int number = value.toInt();
    final String text = number.toString();
    final List<String> parts = [];

    for (int i = text.length; i > 0; i -= 3) {
      final int start = i - 3 < 0 ? 0 : i - 3;

      parts.insert(
        0,
        text.substring(start, i),
      );
    }

    return "${parts.join(' ')} ${tr('so‘m')}";
  }

  // =========================================================
  // MESSAGE
  // =========================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}

// =============================================================
// CARD NUMBER FORMATTER
// =============================================================

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (digits.length > 16) {
      digits = digits.substring(0, 16);
    }

    final StringBuffer formatted = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted.write(' ');
      }

      formatted.write(digits[i]);
    }

    final String result = formatted.toString();

    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(
        offset: result.length,
      ),
    );
  }
}

