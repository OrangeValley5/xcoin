import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';
import 'utils.dart';
import 'utils/dialog_util.dart';

class Sendz extends StatefulWidget {
  const Sendz({Key? key}) : super(key: key);

  @override
  State<Sendz> createState() => _SendzState();
}

class _SendzState extends State<Sendz> with TickerProviderStateMixin {
  TextEditingController _usdtController = TextEditingController();
  String _dollarEquivalent = "10";
  double _usdtToUsdRate = 0.0;
  late AnimationController _slideController;
  late Animation<Offset> _offsetAnimation;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  String? selectedChain;

  final List<Map<String, dynamic>> chains = [
    {
      'image': 'lib/images/eth.png', // Replace with your image path
      'name': 'Ethereum(ERC-20)',
    },
    {
      'image': 'lib/images/ton.png', // Replace with your image path
      'name': 'TON',
    },
    {
      'image': 'lib/images/tron.png', // Replace with your image path
      'name': 'TRON',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initialize();
    _usdtController.addListener(_updateDollarEquivalent);

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.4, end: 0.6).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    selectedChain = chains.first['name'];
  }

  Future<void> _initialize() async {
    _usdtToUsdRate = await CurrencyConversionUtil.fetchUsdtToUsdRate();
    setState(() {});
  }

  void _updateDollarEquivalent() {
    final usdtAmount = double.tryParse(_usdtController.text) ?? 0.0;
    setState(() {
      _dollarEquivalent = CurrencyConversionUtil.calculateDollarEquivalent(
          usdtAmount, _usdtToUsdRate);
    });
  }

  @override
  void dispose() {
    _usdtController.dispose();
    _slideController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0E101F),
      body: Container(
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
        alignment: Alignment.center,
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 25,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xFF191B2A)),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Color.fromARGB(255, 255, 255, 255),
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'lib/images/usdt2.png',
                  width: 30,
                  height: 30,
                ),
                const SizedBox(
                  width: 4,
                ),
                const Text(
                  'Withdraw USDT',
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontFamily: 'Montserrat SemiBold',
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              children: const [
                Text(
                  'Address',
                  style: TextStyle(
                      color: Color.fromARGB(255, 228, 228, 228),
                      fontFamily: 'Montserrat Medium',
                      fontSize: 12),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              width: MediaQuery.of(context).size.width,
              height: 45,
              decoration: BoxDecoration(
                  color: Color(0xFF232532),
                  borderRadius: BorderRadius.circular(10)),
              child: TextFormField(
                style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'Montserrat Regular',
                    color: Color.fromARGB(255, 255, 255, 255)),
                decoration: const InputDecoration(
                  hintText: 'Enter wallet address',
                  enabledBorder:
                      InputBorder.none, // Remove underline when enabled
                  focusedBorder:
                      InputBorder.none, // Remove underline when focused
                  hintStyle: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Montserrat Regular',
                      color: Color(0xFFA0A0A0)),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Amount',
                  style: TextStyle(
                      color: Color.fromARGB(255, 228, 228, 228),
                      fontFamily: 'Montserrat Medium',
                      fontSize: 12),
                ),
                Text(
                  'Available: 10.00 USDT',
                  style: TextStyle(
                      color: Color.fromARGB(255, 175, 175, 175),
                      fontFamily: 'Montserrat Regular',
                      fontSize: 10),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              width: MediaQuery.of(context).size.width,
              height: 45,
              decoration: BoxDecoration(
                  color: Color(0xFF232532),
                  borderRadius: BorderRadius.circular(10)),
              child: TextFormField(
                controller: _usdtController,
                style: const TextStyle(
                    fontSize: 12, color: Color.fromARGB(255, 255, 255, 255)),
                decoration: const InputDecoration(
                  hintText: 'Enter amount',
                  enabledBorder:
                      InputBorder.none, // Remove underline when enabled
                  focusedBorder:
                      InputBorder.none, // Remove underline when focused
                  hintStyle: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Montserrat Regular',
                      color: Color.fromARGB(255, 203, 203, 203)),
                ),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Text(
                  'Dollar Equivalent: \$$_dollarEquivalent',
                  style: const TextStyle(
                      color: Color.fromARGB(255, 185, 185, 185),
                      fontFamily: 'Montserrat Regular',
                      fontSize: 10),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Chain',
                  style: TextStyle(
                    color: Color.fromARGB(255, 228, 228, 228),
                    fontFamily: 'Montserrat Medium',
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Color(0xFF232532),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedChain,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 18,
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedChain = newValue;
                        });
                      },
                      items: chains.map<DropdownMenuItem<String>>(
                          (Map<String, dynamic> chain) {
                        return DropdownMenuItem<String>(
                          value: chain['name'],
                          child: Row(
                            children: [
                              Image.asset(
                                chain['image'],
                                width: 18,
                                height: 18,
                              ),
                              SizedBox(width: 12),
                              Text(
                                chain['name'],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontFamily: 'Montserrat Regular',
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),

                      dropdownColor: Color(0xFF232532),
                      // Background color for the dropdown
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding:
                  const EdgeInsets.only(top: 12, bottom: 12, right: 8, left: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color.fromARGB(255, 255, 25, 25)
                    .withOpacity(0.2), // Adjust opacity here
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'Make sure you deposit your tokens to the right address and network',
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 33, 33),
                        fontSize: 10,
                        fontFamily: 'Montserrat Regular',
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            GestureDetector(
              onTap: () {
                DialogUtil.showLoadingDialog(
                  context,
                  _controller,
                  _scaleAnimation,
                  _slideController,
                  _offsetAnimation,
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(
                    top: 15, bottom: 15, right: 8, left: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color:
                      Color(0xFF7540F0).withOpacity(1), // Adjust opacity here
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      'Withdraw',
                      style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 12,
                          fontFamily: 'Montserrat Medium',
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
