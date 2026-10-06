import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

import 'faol_page.dart';
import 'hamyon_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  bool showLocationPage = false;
  String destination = '';
  double distance = 0;
  int eta = 0;

  int selectedCar = 0;
  bool orderInProgress = false;

  late final ValueNotifier<double> walletBalance;
  late final ValueNotifier<int> ordersNotifier;
  late final ValueNotifier<double> bonusNotifier;

  final MapController _mapController = MapController();

  static const LatLng _jizzaxCenter = LatLng(40.1158, 67.8422);

  LatLng _userPosition = _jizzaxCenter;
  bool _locationLoading = true;
  bool _usingRealLocation = false;

  StreamSubscription<Position>? _locationSubscription;

  String lastCarName = '';
  double lastPrice = 0;
  String lastDestination = '';

  final List<String> carNames = [
    'Standart',
    'Komfort',
    'Premium',
  ];

  final List<String> carDescriptions = [
    'Oddiy va qulay',
    'Qulaylik yuqori',
    'Premium xizmat',
  ];

  final List<IconData> carIcons = [
    Icons.directions_car,
    Icons.local_taxi,
    Icons.directions_car_filled,
  ];

  final List<Map<String, dynamic>> locations = [
    {
      'name': 'Jizzax shahar markazi',
      'distance': 5.2,
      'eta': 12,
      'standard': 15000,
      'icon': Icons.location_on,
    },
    {
      'name': 'Avtovokzal',
      'distance': 4.5,
      'eta': 10,
      'standard': 13000,
      'icon': Icons.directions_bus,
    },
    {
      'name': 'Temir yo‘l vokzali',
      'distance': 6.1,
      'eta': 14,
      'standard': 16000,
      'icon': Icons.train,
    },
    {
      'name': 'Jizzax Davlat Universiteti',
      'distance': 3.8,
      'eta': 9,
      'standard': 12000,
      'icon': Icons.school,
    },
    {
      'name': 'Zarafshon ko‘chasi',
      'distance': 2.7,
      'eta': 7,
      'standard': 11000,
      'icon': Icons.location_on,
    },
    {
      'name': 'Mustaqillik maydoni',
      'distance': 3.2,
      'eta': 8,
      'standard': 12000,
      'icon': Icons.account_balance,
    },
    {
      'name': 'Bosh prokuratura',
      'distance': 4.0,
      'eta': 10,
      'standard': 13000,
      'icon': Icons.account_balance,
    },
    {
      'name': 'Toshkent yo‘li',
      'distance': 7.2,
      'eta': 16,
      'standard': 18000,
      'icon': Icons.alt_route,
    },
    {
      'name': 'Shodlik mahallasi',
      'distance': 4.1,
      'eta': 10,
      'standard': 13000,
      'icon': Icons.home,
    },
    {
      'name': 'Yangi hayot mahallasi',
      'distance': 5.6,
      'eta': 13,
      'standard': 15000,
      'icon': Icons.home,
    },
    {
      'name': 'G‘afur G‘ulom ko‘chasi',
      'distance': 3.4,
      'eta': 8,
      'standard': 12000,
      'icon': Icons.location_on,
    },
    {
      'name': 'Sanoat zonasi',
      'distance': 8.2,
      'eta': 18,
      'standard': 20000,
      'icon': Icons.factory,
    },
    {
      'name': 'Jizzax xalqaro aeroporti',
      'distance': 12.5,
      'eta': 22,
      'standard': 25000,
      'icon': Icons.flight,
    },
  ];

  // =========================
  // SHRIFTlar
  // =========================

  TextStyle get titleFont {
    return GoogleFonts.poppins(
      color: Colors.white,
      fontSize: 22,
      fontWeight: FontWeight.w800,
    );
  }

  TextStyle get headingFont {
    return GoogleFonts.poppins(
      color: Colors.white,
      fontSize: 19,
      fontWeight: FontWeight.w800,
    );
  }

  TextStyle get bodyFont {
    return GoogleFonts.inter(
      color: Colors.white,
      fontSize: 15,
      fontWeight: FontWeight.w600,
    );
  }

  TextStyle get smallFont {
    return GoogleFonts.nunito(
      color: Colors.white54,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    );
  }

  TextStyle get addressFont {
    return GoogleFonts.roboto(
      color: Colors.white,
      fontSize: 15,
      fontWeight: FontWeight.w600,
    );
  }

  TextStyle get moneyFont {
    return GoogleFonts.montserrat(
      color: const Color(0xFF20D99A),
      fontSize: 15,
      fontWeight: FontWeight.w800,
    );
  }

  TextStyle get buttonFont {
    return GoogleFonts.spaceGrotesk(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w800,
    );
  }

  @override
  void initState() {
    super.initState();

    walletBalance = ValueNotifier<double>(12500);
    ordersNotifier = ValueNotifier<int>(0);
    bonusNotifier = ValueNotifier<double>(0);

    _loadCurrentLocation();
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();

    walletBalance.dispose();
    ordersNotifier.dispose();
    bonusNotifier.dispose();

    super.dispose();
  }

  String _formatMoney(double money) {
    int value = money.toInt();

    String text = value.toString();
    List<String> parts = [];

    while (text.length > 3) {
      parts.insert(0, text.substring(text.length - 3));
      text = text.substring(0, text.length - 3);
    }

    parts.insert(0, text);

    return '${parts.join(' ')} so‘m';
  }

  double _getCarPrice(int carIndex) {
    if (destination.isEmpty) {
      if (carIndex == 0) return 15000;
      if (carIndex == 1) return 22000;
      return 30000;
    }

    final selectedLocation = locations.firstWhere(
      (location) => location['name'] == destination,
      orElse: () => {'standard': 15000},
    );

    final double standardPrice =
        (selectedLocation['standard'] as num).toDouble();

    if (carIndex == 0) return standardPrice;
    if (carIndex == 1) return standardPrice + 7000;

    return standardPrice + 15000;
  }

  void _openLocationPage() {
    setState(() {
      showLocationPage = true;
    });
  }

  void _selectLocation(Map<String, dynamic> location) {
    setState(() {
      destination = location['name'];
      distance = (location['distance'] as num).toDouble();
      eta = location['eta'];
      selectedCar = 0;
      showLocationPage = false;
    });
  }

  void _backFromLocationPage() {
    setState(() {
      showLocationPage = false;
    });
  }

  Future<void> _loadCurrentLocation() async {
    try {
      final serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (mounted) {
          setState(() {
            _locationLoading = false;
          });
        }
        return;
      }

      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (mounted) {
          setState(() {
            _locationLoading = false;
          });
        }
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (!mounted) return;

      setState(() {
        _userPosition = LatLng(
          position.latitude,
          position.longitude,
        );

        _locationLoading = false;
        _usingRealLocation = true;
      });

      _mapController.move(
        _userPosition,
        15.8,
      );

      _locationSubscription?.cancel();

      _locationSubscription =
          Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5,
        ),
      ).listen((position) {
        if (!mounted) return;

        setState(() {
          _userPosition = LatLng(
            position.latitude,
            position.longitude,
          );
        });
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _locationLoading = false;
        });
      }
    }
  }

  void _goToMyLocation() {
    _mapController.move(
      _userPosition,
      16.0,
    );
  }

  Future<bool> _showOrderSheet(double price) async {
    bool driverFound = false;
    Timer? timer;

    final bool? result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            if (!driverFound && timer == null) {
              timer = Timer(
                const Duration(seconds: 2),
                () {
                  if (Navigator.of(sheetContext).canPop()) {
                    setSheetState(() {
                      driverFound = true;
                    });
                  }
                },
              );
            }

            return Container(
              padding: const EdgeInsets.fromLTRB(
                20,
                12,
                20,
                28,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF0A100D),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 45,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFF20D99A)
                              .withOpacity(0.12),
                          borderRadius:
                              BorderRadius.circular(16),
                        ),
                        child: Icon(
                          driverFound
                              ? Icons.check_circle
                              : Icons.search,
                          color: const Color(0xFF20D99A),
                          size: 28,
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              driverFound
                                  ? 'Haydovchi topildi'
                                  : 'Haydovchi qidirilmoqda...',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              driverFound
                                  ? 'Haydovchi siz tomonga kelmoqda'
                                  : 'Atrofdagi haydovchilar qidirilmoqda',
                              style: GoogleFonts.nunito(
                                color: Colors.white54,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFF101713),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Color(0xFF20D99A),
                          size: 22,
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Manzil',
                                style: GoogleFonts.nunito(
                                  color: Colors.white54,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                destination,
                                maxLines: 1,
                                overflow:
                                    TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  if (driverFound)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF101713),
                        borderRadius:
                            BorderRadius.circular(18),
                        border: Border.all(
                          color: const Color(0xFF20D99A)
                              .withOpacity(0.15),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                              color:
                                  const Color(0xFF20D99A),
                              borderRadius:
                                  BorderRadius.circular(16),
                            ),
                            child: Icon(
                              carIcons[selectedCar],
                              color: Colors.black,
                              size: 28,
                            ),
                          ),

                          const SizedBox(width: 13),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selectedCar == 0
                                      ? 'Azizbek'
                                      : selectedCar == 1
                                          ? 'Javohir'
                                          : 'Sardor',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.w800,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  selectedCar == 0
                                      ? 'Chevrolet Cobalt'
                                      : selectedCar == 1
                                          ? 'Chevrolet Malibu'
                                          : 'Toyota Camry',
                                  style: GoogleFonts.roboto(
                                    color: Colors.white54,
                                    fontSize: 11,
                                    fontWeight:
                                        FontWeight.w500,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color:
                                          Color(0xFF20D99A),
                                      size: 14,
                                    ),

                                    const SizedBox(width: 4),

                                    Text(
                                      '4.9',
                                      style:
                                          GoogleFonts.montserrat(
                                        color: Colors.white70,
                                        fontSize: 11,
                                        fontWeight:
                                            FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.end,
                            children: [
                              Text(
                                '3 daqiqa',
                                style:
                                    GoogleFonts.spaceGrotesk(
                                  color:
                                      const Color(0xFF20D99A),
                                  fontSize: 14,
                                  fontWeight:
                                      FontWeight.w800,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                _formatMoney(price),
                                style:
                                    GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight:
                                      FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                  if (!driverFound)
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 18),
                      child: CircularProgressIndicator(
                        color: Color(0xFF20D99A),
                        strokeWidth: 3,
                      ),
                    ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: driverFound
                          ? () {
                              Navigator.pop(
                                sheetContext,
                                true,
                              );
                            }
                          : () {
                              Navigator.pop(
                                sheetContext,
                                false,
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: driverFound
                            ? const Color(0xFF20D99A)
                            : const Color(0xFF18201B),
                        foregroundColor: driverFound
                            ? Colors.black
                            : Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(17),
                        ),
                      ),
                      child: Text(
                        driverFound
                            ? 'Buyurtmani tasdiqlash'
                            : 'Buyurtmani bekor qilish',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    timer?.cancel();

    return result ?? false;
  }

  Future<void> _orderTaxi() async {
    if (destination.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF181C19),
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Avval manzilni tanlang.',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );

      return;
    }

    if (orderInProgress) {
      return;
    }

    final double taxiPrice =
        _getCarPrice(selectedCar);

    if (walletBalance.value < taxiPrice) {
      final double difference =
          taxiPrice - walletBalance.value;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF181C19),
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Balans yetarli emas.\n'
            'Yana ${_formatMoney(difference)} kerak.',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );

      return;
    }

    setState(() {
      orderInProgress = true;
    });

    final bool accepted =
        await _showOrderSheet(taxiPrice);

    if (!mounted) return;

    setState(() {
      orderInProgress = false;
    });

    if (!accepted) {
      return;
    }

    walletBalance.value -= taxiPrice;

    ordersNotifier.value += 1;

    final double bonus = taxiPrice * 0.005;

    bonusNotifier.value += bonus;

    lastCarName = carNames[selectedCar];
    lastPrice = taxiPrice;
    lastDestination = destination;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF20D99A),
        behavior: SnackBarBehavior.floating,
        content: Text(
          'Taksi buyurtmasi qabul qilindi!',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  // =========================
  // HOME PAGE
  // =========================

  Widget _homePage() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          18,
          18,
          18,
          30,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF20D99A),
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.local_taxi,
                    color: Colors.black,
                    size: 28,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Yulchi Taxi',
                        style: titleFont,
                      ),

                      const SizedBox(height: 2),

                      Text(
                        'Safaringizni qulay qiling',
                        style: GoogleFonts.nunito(
                          color: Colors.white54,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                ValueListenableBuilder<double>(
                  valueListenable: walletBalance,
                  builder:
                      (context, balance, child) {
                    return Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color:
                            const Color(0xFF101713),
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                      child: Text(
                        _formatMoney(balance),
                        style:
                            GoogleFonts.montserrat(
                          color:
                              const Color(0xFF20D99A),
                          fontSize: 12,
                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // MAP
            Container(
              height: 270,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF101713),
                borderRadius:
                    BorderRadius.circular(24),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _userPosition,
                      initialZoom: 15.8,
                      minZoom: 10,
                      maxZoom: 19,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName:
                            'uz.yulchi.taxi',
                      ),

                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _userPosition,
                            width: 42,
                            height: 42,
                            child: Container(
                              decoration:
                                  BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      const Color(
                                          0xFF20D99A),
                                  width: 3,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color:
                                        Colors.black45,
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons
                                    .my_location_rounded,
                                color: Colors.black,
                                size: 21,
                              ),
                            ),
                          ),
                        ],
                      ),

                      RichAttributionWidget(
                        attributions: [
                          TextSourceAttribution(
                            'OpenStreetMap contributors',
                          ),
                        ],
                      ),
                    ],
                  ),

                  Positioned(
                    top: 14,
                    left: 14,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black
                            .withOpacity(0.78),
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            color:
                                Color(0xFF20D99A),
                            size: 18,
                          ),

                          const SizedBox(width: 6),

                          Text(
                            _locationLoading
                                ? 'Joylashuv aniqlanmoqda...'
                                : (_usingRealLocation
                                    ? 'Siz turgan joy'
                                    : 'Jizzax'),
                            style:
                                GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight:
                                  FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Positioned(
                    right: 14,
                    bottom: 14,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _goToMyLocation,
                          child: Container(
                            width: 46,
                            height: 46,
                            decoration:
                                BoxDecoration(
                              color:
                                  const Color(
                                      0xFF20D99A),
                              borderRadius:
                                  BorderRadius.circular(
                                      14),
                              boxShadow: const [
                                BoxShadow(
                                  color:
                                      Colors.black38,
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons
                                  .my_location_rounded,
                              color: Colors.black,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        Container(
                          decoration:
                              BoxDecoration(
                            color: Colors.black
                                .withOpacity(0.78),
                            borderRadius:
                                BorderRadius.circular(
                                    14),
                          ),
                          child: Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  final camera =
                                      _mapController
                                          .camera;

                                  _mapController.move(
                                    camera.center,
                                    (camera.zoom + 1)
                                        .clamp(
                                          10.0,
                                          19.0,
                                        )
                                        .toDouble(),
                                  );
                                },
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),

                              IconButton(
                                onPressed: () {
                                  final camera =
                                      _mapController
                                          .camera;

                                  _mapController.move(
                                    camera.center,
                                    (camera.zoom - 1)
                                        .clamp(
                                          10.0,
                                          19.0,
                                        )
                                        .toDouble(),
                                  );
                                },
                                icon: const Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // DESTINATION
            GestureDetector(
              onTap: _openLocationPage,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF101713),
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color:
                            const Color(0xFF20D99A)
                                .withOpacity(0.12),
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.search,
                        color:
                            Color(0xFF20D99A),
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            destination.isEmpty
                                ? 'Qayerga boramiz?'
                                : destination,
                            style:
                                GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            destination.isEmpty
                                ? 'Manzilni tanlash uchun bosing'
                                : '$distance km • $eta daqiqa',
                            style:
                                GoogleFonts.roboto(
                              color: Colors.white54,
                              fontSize: 12,
                              fontWeight:
                                  FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white38,
                      size: 17,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // WALLET
            ValueListenableBuilder<double>(
              valueListenable: walletBalance,
              builder:
                  (context, balance, child) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 2;
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color:
                          const Color(0xFF20D99A),
                      borderRadius:
                          BorderRadius.circular(22),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration:
                              BoxDecoration(
                            color: Colors.black
                                .withOpacity(0.12),
                            borderRadius:
                                BorderRadius.circular(
                                    15),
                          ),
                          child: const Icon(
                            Icons
                                .account_balance_wallet,
                            color: Colors.black,
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Text(
                                'Hamyon balansi',
                                style:
                                    GoogleFonts.nunito(
                                  color:
                                      Colors.black54,
                                  fontSize: 12,
                                  fontWeight:
                                      FontWeight.w700,
                                ),
                              ),

                              const SizedBox(height: 3),

                              Text(
                                _formatMoney(balance),
                                style:
                                    GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight:
                                      FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 11,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black
                                .withOpacity(0.12),
                            borderRadius:
                                BorderRadius.circular(
                                    12),
                          ),
                          child: Text(
                            'To‘ldirish',
                            style:
                                GoogleFonts.spaceGrotesk(
                              color: Colors.black,
                              fontWeight:
                                  FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 26),

            Text(
              'Avtomobil turini tanlang',
              style: headingFont,
            ),

            const SizedBox(height: 14),

            ...List.generate(
              carNames.length,
              (index) {
                final bool selected =
                    selectedCar == index;

                final double price =
                    _getCarPrice(index);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCar = index;
                    });
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.only(
                      bottom: 12,
                    ),
                    padding:
                        const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(
                                  0xFF20D99A)
                              .withOpacity(0.12)
                          : const Color(
                              0xFF101713),
                      borderRadius:
                          BorderRadius.circular(
                              20),
                      border: Border.all(
                        color: selected
                            ? const Color(
                                0xFF20D99A)
                            : Colors.white
                                .withOpacity(0.07),
                        width:
                            selected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 55,
                          height: 55,
                          decoration:
                              BoxDecoration(
                            color: selected
                                ? const Color(
                                    0xFF20D99A)
                                : const Color(
                                    0xFF181F1B),
                            borderRadius:
                                BorderRadius.circular(
                                    16),
                          ),
                          child: Icon(
                            carIcons[index],
                            color: selected
                                ? Colors.black
                                : Colors.white70,
                            size: 28,
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Text(
                                carNames[index],
                                style:
                                    GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.w800,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                carDescriptions[index],
                                style:
                                    GoogleFonts.nunito(
                                  color: Colors.white54,
                                  fontSize: 12,
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.end,
                          children: [
                            Text(
                              _formatMoney(price),
                              style:
                                  GoogleFonts.montserrat(
                                color: selected
                                    ? const Color(
                                        0xFF20D99A)
                                    : Colors.white,
                                fontSize: 15,
                                fontWeight:
                                    FontWeight.w800,
                              ),
                            ),

                            const SizedBox(height: 5),

                            if (selected)
                              const Icon(
                                Icons.check_circle,
                                color:
                                    Color(0xFF20D99A),
                                size: 20,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 8),

            // ORDER BUTTON
            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                onPressed:
                    orderInProgress
                        ? null
                        : _orderTaxi,
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF20D99A),
                  disabledBackgroundColor:
                      const Color(0xFF173329),
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(18),
                  ),
                ),
                child: Text(
                  orderInProgress
                      ? 'Buyurtma jarayonida...'
                      : 'Taksi buyurtma qilish',
                  style:
                      GoogleFonts.spaceGrotesk(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // INFO
            ValueListenableBuilder<int>(
              valueListenable: ordersNotifier,
              builder:
                  (context, orders, child) {
                return ValueListenableBuilder<
                    double>(
                  valueListenable:
                      bonusNotifier,
                  builder:
                      (context, bonus, child) {
                    return Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedIndex =
                                    1;
                              });
                            },
                            child: _smallInfoCard(
                              Icons.route,
                              '$orders',
                              'Safarlar',
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: _smallInfoCard(
                            Icons.card_giftcard,
                            _formatMoney(bonus),
                            'Bonus',
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // SMALL INFO CARD
  // =========================

  Widget _smallInfoCard(
    IconData icon,
    String value,
    String title,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF101713),
        borderRadius:
            BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF20D99A)
                  .withOpacity(0.1),
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color:
                  const Color(0xFF20D99A),
              size: 21,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style:
                      GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  title,
                  style:
                      GoogleFonts.nunito(
                    color: Colors.white54,
                    fontSize: 11,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // LOCATION PAGE
  // =========================

  Widget _locationPage() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          18,
          18,
          18,
          30,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: _backFromLocationPage,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color:
                          const Color(0xFF101713),
                      borderRadius:
                          BorderRadius.circular(
                              14),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Text(
                  'Manzil tanlang',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color:
                    const Color(0xFF101713),
                borderRadius:
                    BorderRadius.circular(18),
              ),
              child: TextField(
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  icon: const Icon(
                    Icons.search,
                    color:
                        Color(0xFF20D99A),
                  ),
                  hintText:
                      'Manzil yoki joy nomi',
                  hintStyle:
                      GoogleFonts.nunito(
                    color: Colors.white38,
                    fontSize: 14,
                  ),
                  border:
                      InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Jizzaxdagi manzillar',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight:
                    FontWeight.w800,
              ),
            ),

            const SizedBox(height: 12),

            ...locations.map(
              (location) {
                return GestureDetector(
                  onTap: () {
                    _selectLocation(
                      location,
                    );
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.only(
                      bottom: 8,
                    ),
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 13,
                    ),
                    decoration:
                        BoxDecoration(
                      color:
                          const Color(0xFF0D1411),
                      borderRadius:
                          BorderRadius.circular(
                              16),
                      border: Border.all(
                        color: Colors.white
                            .withOpacity(0.05),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration:
                              BoxDecoration(
                            color:
                                const Color(
                                    0xFF20D99A)
                                .withOpacity(
                                    0.12),
                            borderRadius:
                                BorderRadius.circular(
                                    14),
                          ),
                          child: Icon(
                            location['icon'],
                            color:
                                const Color(
                                    0xFF20D99A),
                            size: 22,
                          ),
                        ),

                        const SizedBox(width: 13),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Text(
                                location['name'],
                                style:
                                    GoogleFonts.roboto(
                                  color:
                                      Colors.white,
                                  fontSize: 15,
                                  fontWeight:
                                      FontWeight.w700,
                                ),
                              ),

                              const SizedBox(
                                height: 4,
                              ),

                              Text(
                                '${location['distance']} km • ${location['eta']} daqiqa',
                                style:
                                    GoogleFonts.nunito(
                                  color:
                                      Colors.white54,
                                  fontSize: 11,
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Icon(
                          Icons.arrow_forward_ios,
                          color:
                              Colors.white38,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // BUILD
  // =========================

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      showLocationPage
          ? _locationPage()
          : _homePage(),

      ActivityPage(
        ordersNotifier:
            ordersNotifier,
        destination:
            lastDestination,
        carName:
            lastCarName,
        price:
            lastPrice,
      ),

      WalletPage(
        balanceNotifier:
            walletBalance,
      ),

      ProfilePage(
        ordersNotifier:
            ordersNotifier,
        bonusNotifier:
            bonusNotifier,
      ),
    ];

    return Scaffold(
      backgroundColor:
          const Color(0xFF050806),

      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),

      bottomNavigationBar:
          BottomNavigationBar(
        backgroundColor:
            const Color(0xFF090D0A),

        currentIndex:
            _selectedIndex,

        onTap: (index) {
          setState(() {
            _selectedIndex = index;

            if (index != 0) {
              showLocationPage = false;
            }
          });
        },

        type:
            BottomNavigationBarType.fixed,

        selectedItemColor:
            const Color(0xFF20D99A),

        unselectedItemColor:
            Colors.white38,

        selectedLabelStyle:
            GoogleFonts.poppins(
          fontSize: 11,
          fontWeight:
              FontWeight.w700,
        ),

        unselectedLabelStyle:
            GoogleFonts.nunito(
          fontSize: 11,
          fontWeight:
              FontWeight.w600,
        ),

        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
            ),
            activeIcon: Icon(
              Icons.home,
            ),
            label: 'Bosh sahifa',
          ),

          BottomNavigationBarItem(
            icon: Icon(
              Icons.history,
            ),
            activeIcon: Icon(
              Icons.history,
            ),
            label: 'Faol',
          ),

          BottomNavigationBarItem(
            icon: Icon(
              Icons
                  .account_balance_wallet_outlined,
            ),
            activeIcon: Icon(
              Icons.account_balance_wallet,
            ),
            label: 'Hamyon',
          ),

          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
            ),
            activeIcon: Icon(
              Icons.person,
            ),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}