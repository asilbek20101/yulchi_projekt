import 'package:flutter/material.dart';
import 'package:meta_ai_projekt/page/app_settings.dart';

class ActivityPage extends StatelessWidget {
  final ValueNotifier<int>? ordersNotifier;
  final ValueNotifier<String>? orderStatusNotifier;
  final ValueNotifier<int>? driverEtaNotifier;
  final String destination;
  final String carName;
  final double price;
  final void Function(String status)? onStatusChanged;

  const ActivityPage({
    super.key,
    this.ordersNotifier,
    this.orderStatusNotifier,
    this.driverEtaNotifier,
    this.destination = '',
    this.carName = '',
    this.price = 0,
    this.onStatusChanged,
  });

  String _formatMoney(double money) {
    int value = money.toInt();
    String text = value.toString();
    final parts = <String>[];
    while (text.length > 3) {
      parts.insert(0, text.substring(text.length - 3));
      text = text.substring(0, text.length - 3);
    }
    parts.insert(0, text);
    return '${parts.join(' ')} ${tr('so‘m')}';
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: appLanguage,
      builder: (context, language, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tr('Faoliyat'), style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 5),
                  Text(tr('Buyurtmalaringiz tarixi'), style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(.54), fontSize: 13)),
                  const SizedBox(height: 22),
                  ValueListenableBuilder<int>(
                    valueListenable: ordersNotifier ?? ValueNotifier<int>(0),
                    builder: (context, orders, child) => _stats(context, orders),
                  ),
                  const SizedBox(height: 28),
                  Text(tr('Oxirgi buyurtma'), style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  if (destination.isEmpty || carName.isEmpty || price <= 0)
                    _empty(context)
                  else
                    _orderCard(context),
                  const SizedBox(height: 22),
                  _historyTip(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _stats(BuildContext context, int orders) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF20D99A).withOpacity(.12)),
      ),
      child: Row(children: [
        Container(width: 52, height: 52, decoration: BoxDecoration(color: const Color(0xFF20D99A).withOpacity(.12), borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.route, color: Color(0xFF20D99A), size: 26)),
        const SizedBox(width: 14),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(tr('Jami safarlar'), style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(.54), fontSize: 12)),
          const SizedBox(height: 4),
          Text('$orders ${tr('ta')}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
        ]),
        const Spacer(),
        Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: const Color(0xFF20D99A).withOpacity(.1), borderRadius: BorderRadius.circular(12)), child: const Text('Faol', style: TextStyle(color: Color(0xFF20D99A), fontWeight: FontWeight.w800))),
      ]),
    );
  }

  Widget _empty(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(20)),
      child: Column(children: [
        Icon(Icons.local_taxi_outlined, color: Theme.of(context).colorScheme.onSurface.withOpacity(.38), size: 45),
        const SizedBox(height: 12),
        Text(tr('Hali buyurtma yo‘q'), style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(.70), fontSize: 16, fontWeight: FontWeight.w700)),
      ]),
    );
  }

  Widget _orderCard(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: orderStatusNotifier ?? ValueNotifier<String>('Buyurtma qabul qilindi'),
      builder: (context, status, child) {
        return ValueListenableBuilder<int>(
          valueListenable: driverEtaNotifier ?? ValueNotifier<int>(3),
          builder: (context, eta, child) {
            final finished = status == 'Safar tugadi';
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(22), border: Border.all(color: const Color(0xFF20D99A).withOpacity(.12))),
              child: Column(children: [
                Row(children: [
                  Container(width: 52, height: 52, decoration: BoxDecoration(color: const Color(0xFF20D99A), borderRadius: BorderRadius.circular(15)), child: const Icon(Icons.local_taxi, color: Colors.black, size: 27)),
                  const SizedBox(width: 13),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(carName, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 5),
                    Text(status, style: const TextStyle(color: Color(0xFF20D99A), fontSize: 12, fontWeight: FontWeight.w700)),
                  ])),
                  Text(_formatMoney(price), style: const TextStyle(color: Color(0xFF20D99A), fontSize: 15, fontWeight: FontWeight.w900)),
                ]),
                const SizedBox(height: 18),
                Container(width: double.infinity, padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: const Color(0xFF0B100D), borderRadius: BorderRadius.circular(16)), child: Row(children: [const Icon(Icons.location_on, color: Color(0xFF20D99A), size: 21), const SizedBox(width: 10), Expanded(child: Text(destination, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)))])),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: _info(context, Icons.schedule, 'Holat', status)),
                  const SizedBox(width: 10),
                  Expanded(child: _info(context, Icons.timer_outlined, 'Yetib kelish', eta > 0 ? '$eta daqiqa' : 'Yetib keldi')),
                ]),
                if (status == 'Haydovchi yo‘lda' || status == 'Haydovchi yetib keldi' || status == 'Safar boshlandi') ...[
                  const SizedBox(height: 14),
                  _driverCard(context),
                ],
                const SizedBox(height: 14),
                if (!finished)
                  SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: () => _nextStatus(context, status), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF20D99A), foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), child: Text(_nextLabel(status), style: const TextStyle(fontWeight: FontWeight.w900)))),
                if (finished) _ratingButton(context),
              ]),
            );
          },
        );
      },
    );
  }

  Widget _driverCard(BuildContext context) {
    return Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(17)), child: Row(children: [Container(width: 48, height: 48, decoration: BoxDecoration(color: const Color(0xFF20D99A), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.person, color: Colors.black)), const SizedBox(width: 12), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Azizbek', style: TextStyle(fontWeight: FontWeight.w800)), SizedBox(height: 3), Text('Chevrolet Cobalt • 01 A 777 AA', style: TextStyle(fontSize: 11))])), const Icon(Icons.star, color: Color(0xFF20D99A), size: 18), const SizedBox(width: 4), const Text('4.9', style: TextStyle(fontWeight: FontWeight.w800))]));
  }

  String _nextLabel(String status) {
    if (status == 'Haydovchi yo‘lda') return 'Haydovchi yetib keldi';
    if (status == 'Haydovchi yetib keldi') return 'Safarni boshlash';
    if (status == 'Safar boshlandi') return 'Safarni tugatish';
    return 'Davom etish';
  }

  void _nextStatus(BuildContext context, String status) {
    if (status == 'Haydovchi yo‘lda') {
      onStatusChanged?.call('Haydovchi yetib keldi');
    } else if (status == 'Haydovchi yetib keldi') {
      onStatusChanged?.call('Safar boshlandi');
    } else if (status == 'Safar boshlandi') {
      onStatusChanged?.call('Safar tugadi');
      Future.microtask(() => _showRating(context));
    }
  }

  Future<void> _showRating(BuildContext context) async {
    int rating = 5;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(builder: (context, setState) => AlertDialog(
        title: const Text('Safarni baholang'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Haydovchi xizmatini baholang'),
          const SizedBox(height: 18),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(5, (i) => IconButton(onPressed: () => setState(() => rating = i + 1), icon: Icon(Icons.star, color: i < rating ? const Color(0xFF20D99A) : Colors.grey, size: 34)))),
          Text('$rating / 5', style: const TextStyle(fontWeight: FontWeight.w800)),
        ]),
        actions: [TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Yopish')), ElevatedButton(onPressed: () { Navigator.pop(dialogContext); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$rating yulduz uchun rahmat!'))); }, child: const Text('Saqlash'))],
      )),
    );
  }

  Widget _ratingButton(BuildContext context) => SizedBox(width: double.infinity, height: 50, child: OutlinedButton.icon(onPressed: () => _showRating(context), icon: const Icon(Icons.star_outline), label: const Text('Safarni baholash')));

  Widget _historyTip(BuildContext context) {
    return Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFF20D99A).withOpacity(.08), borderRadius: BorderRadius.circular(18)), child: const Row(children: [Icon(Icons.info_outline, color: Color(0xFF20D99A)), SizedBox(width: 10), Expanded(child: Text('Safar tugagach baholash oynasi ochiladi. Buyurtma holati shu sahifada yangilanadi.', style: TextStyle(fontSize: 12, height: 1.4)))]));
  }

  Widget _info(BuildContext context, IconData icon, String title, String value) {
    return Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(15)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: const Color(0xFF20D99A), size: 19), const SizedBox(height: 7), Text(title, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(.54), fontSize: 10)), const SizedBox(height: 3), Text(value, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800))]));
  }
}
