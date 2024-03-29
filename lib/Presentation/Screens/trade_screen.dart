//readonly for price

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mock_tradex/Data/Data_Provider/binance_current.dart';
import 'package:mock_tradex/Data/Data_Provider/binance_socket.dart';
import 'package:mock_tradex/Data/Models/orders.dart';
import 'package:mock_tradex/Data/Models/socketResponse.dart';
import 'package:mock_tradex/constants.dart';
import 'package:action_slider/action_slider.dart';

List<bool> orderSelected = [false, true, false, false];
List<bool> percentSelected = [false, false, false, false];
BinanceSocket? binanceSocket;
BinanceOrderBook? orderBook;
StreamController<BinanceOrderBook> _streamController =
    StreamController<BinanceOrderBook>();
Stream<BinanceOrderBook> stream = _streamController.stream;

class OrderPage extends StatefulWidget {
  final String? cryptoName;
  final String? orderSide;
  final String? tradePair;
  final String? symbol;

  const OrderPage(
      {Key? key, this.orderSide, this.tradePair, this.cryptoName, this.symbol})
      : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  Color? pageThemeColor;
  Timer? timer;
  double currPrice = 0;
  double price = 0;
  double amount = 0;
  double total = 0;
  final myPriceController = TextEditingController();
  final myAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    binanceSocket = BinanceSocket(symbol: widget.tradePair);
    stream = binanceSocket!.getOrders(widget.tradePair!);

    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) async {
      currPrice = await priceUpdate();
      myPriceController.text = currPrice.toStringAsPrecision(5);

      setState(() {
        total = amount * double.tryParse(myPriceController.text)!;
      });
    });
    pageThemeColor = widget.orderSide == 'BUY'
        ? const Color(0xff286bdb)
        : const Color(0xffef4006);
  }

  Future<double> priceUpdate() async {
    return getLatestPrice(widget.tradePair!);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myPriceController.dispose();
    myAmountController.dispose();
    binanceSocket!.channel!.sink.close();
    _streamController.close();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        titleSpacing: 2,
        centerTitle: true,
        title: Text('Spot ${widget.orderSide}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 15),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 12),
                      decoration: const BoxDecoration(
                        color: kTradeScreenGreyBoxColor,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 18),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Price',
                                    style: TextStyle(
                                      color: Color(0xfffeffff),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: TextFormField(
                                      readOnly: true,
                                      onChanged: ((val) {
                                        if (double.tryParse(val) != null) {
                                          setState(() {
                                            price = double.parse(val);
                                          });
                                        }
                                      }),
                                      controller: myPriceController,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: kTickerWhite,
                                      ),
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(12),
                                        //max length of 12 characters
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'(^-?\d*\.?\d*)'))
                                      ],
                                      cursorColor: pageThemeColor,
                                      cursorWidth: 2,
                                      enabled: true,
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.all(10),
                                        isCollapsed: true,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  kTradeScreenGreyBoxColorTextFieldBorder,
                                              width: 1),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  kTradeScreenGreyBoxColorTextFieldBorder,
                                              width: 1),
                                        ),
                                        hintText: '0',
                                        hintStyle: TextStyle(
                                          fontSize: 20,
                                          color: kHintTextColor,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 18),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Amount',
                                    style: TextStyle(
                                      color: Color(0xfffeffff),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: TextFormField(
                                      controller: myAmountController,
                                      onChanged: ((val) {
                                        if (double.tryParse(val) != null) {
                                          setState(
                                            () {
                                              amount = double.parse(val);
                                              total = amount * price;
                                            },
                                          );
                                        }
                                      }),
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: kTickerWhite,
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        LengthLimitingTextInputFormatter(12),
                                        //max length of 12 characters
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'(^-?\d*\.?\d*)'))
                                      ],
                                      cursorColor: pageThemeColor,
                                      cursorWidth: 2,
                                      enabled: true,
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.all(10),
                                        isCollapsed: true,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  kTradeScreenGreyBoxColorTextFieldBorder,
                                              width: 1),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  kTradeScreenGreyBoxColorTextFieldBorder,
                                              width: 1),
                                        ),
                                        hintText: '0',
                                        hintStyle: TextStyle(
                                          fontSize: 20,
                                          color: kHintTextColor,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Text(
                              'Order Book',
                              style: TextStyle(
                                color: Color(0xffeaecf0),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text(
                                        'Bid',
                                        style: TextStyle(
                                          color: Color(0xb773787f),
                                        ),
                                      ),
                                      Text(
                                        'Qty',
                                        style: TextStyle(
                                          color: Color(0xb773787f),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text(
                                        'Ask',
                                        style: TextStyle(
                                          color: Color(0xb773787f),
                                        ),
                                      ),
                                      Text(
                                        'Qty',
                                        style: TextStyle(
                                          color: Color(0xb773787f),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            OrderRows(
                              symbol: widget.tradePair,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Type',
                          style: TextStyle(
                            color: Color(0xfffeffff),
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween, //setstate problem
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: ToggleContainer(
                                  text: 'Limit',
                                  index: 0,
                                  fontSize: kToggleBoxOrderTypeFontSize,
                                  colorTheme: pageThemeColor,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: ToggleContainer(
                                  text: 'Market',
                                  index: 1,
                                  fontSize: kToggleBoxOrderTypeFontSize,
                                  colorTheme: pageThemeColor,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // setState(() {
                                  //   buttonSelect(2, orderSelected);
                                  // });
                                },
                                child: ToggleContainer(
                                  text: 'SL',
                                  index: 2,
                                  fontSize: kToggleBoxOrderTypeFontSize,
                                  colorTheme: pageThemeColor,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: ToggleContainer(
                                  text: 'SL-M',
                                  index: 3,
                                  fontSize: kToggleBoxOrderTypeFontSize,
                                  colorTheme: pageThemeColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            color: Color(0xfffeffff),
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 12),
                            child: Text(
                              '${total.truncateToDouble()}',
                              style: const TextStyle(
                                fontSize: 20,
                                color: kTickerWhite,
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              border: Border.all(
                                  color:
                                      kTradeScreenGreyBoxColorTextFieldBorder),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.black,
            child: Column(
              children: [
                Container(
                  color: const Color(0xcd13161b),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Text(
                              'Available USD ',
                              style: TextStyle(color: Color(0xb773787f)),
                            ),
                            Icon(
                              Icons.account_balance_wallet_rounded,
                              color: Color(0xb773787f),
                              size: 15,
                            ),
                          ],
                        ),
                        const Text(
                          '\$99999999',
                          style: TextStyle(color: Color(0xffeaecf0)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ActionSlider.standard(
                    backgroundColor: pageThemeColor,
                    toggleColor: const Color(0xffffffff),
                    width: 240.0,
                    height: 70.0,
                    slideAnimationCurve: Curves.easeOutExpo,
                    slideAnimationDuration: const Duration(milliseconds: 200),
                    reverseSlideAnimationCurve: Curves.easeOutExpo,
                    reverseSlideAnimationDuration:
                        const Duration(milliseconds: 200),
                    actionThresholdType: ThresholdType.release,
                    child: const Text('SWIPE TO BUY'),
                    onSlide: (controller) async {
                      controller.loading(); //starts loading animation
                      await Future.delayed(const Duration(seconds: 1));
                      double walletBalance = await FirebaseFirestore.instance
                          .collection('Users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .get()
                          .then((value) =>
                              double.parse(value.data()!['wallet_balance']));
                      if (walletBalance > total && total >= 10) {
                        walletBalance = walletBalance - total;
                        orderConfirmed(walletBalance);
                        controller.success(); //starts success animation
                      } else if (total < 10) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Total Value must be more than 10."),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Not Enough Balance Available"),
                          ),
                        );
                        controller.failure();
                      }
                      await Future.delayed(const Duration(seconds: 1));
                      controller.reset(); //resets the slider
                    },
                  ),
                  // child: SlideAction(
                  //   key: _key,
                  //   sliderButtonYOffset: 0,
                  //   text: 'SWIPE TO BUY',
                  //   textStyle:
                  //   const TextStyle(fontSize: 14, color: Colors.white),
                  //   outerColor: pageThemeColor,
                  //   innerColor: const Color(0xffffffff),
                  //   sliderButtonIconPadding: 11,
                  //   sliderRotate: false,
                  //   height: 65,
                  //   sliderButtonIcon: Icon(
                  //     Icons.chevron_right_rounded,
                  //     size: 36,
                  //     color: pageThemeColor,
                  //   ),
                  //   onSubmit: () async {
                  //     await Future.delayed(
                  //       const Duration(seconds: 1),
                  //           () => _key.currentState!.reset(),
                  //     );
                  //     Order order = Order(
                  //       cryptoName: widget.cryptoName,
                  //       price: myPriceController.text,
                  //       amount: myAmountController.text,
                  //       type: "Market",
                  //       total: total,
                  //       orderSide: widget.orderSide,
                  //       orderTime: DateTime.now().toIso8601String(),
                  //     );
                  //     order.addOrder(order);
                  //   },
                  // ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void orderConfirmed(double balance) {
    Order order = Order(
      cryptoName: widget.cryptoName,
      price: myPriceController.text,
      amount: myAmountController.text,
      type: "Market",
      total: total,
      orderSide: widget.orderSide,
      orderTime: DateTime.now().toIso8601String(),
      symbol: widget.symbol,
    );
    order.addOrder(order, balance);
  }

  void buttonSelect(int index, List<bool> isSelected) {
    for (int buttonIndex = 0;
        buttonIndex < orderSelected.length;
        buttonIndex++) {
      if (buttonIndex == index) {
        orderSelected[buttonIndex] = true;
      } else {
        orderSelected[buttonIndex] = false;
      }
    }
  }
}

class OrderRows extends StatefulWidget {
  final String? symbol;
  const OrderRows({Key? key, this.symbol}) : super(key: key);

  @override
  State<OrderRows> createState() => _OrderRowsState();
}

class _OrderRowsState extends State<OrderRows> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BinanceOrderBook>(
        stream: stream,
        builder: (context, snapshot) {
          return ListView.builder(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 20,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${snapshot.connectionState == ConnectionState.active ? '${double.tryParse(snapshot.data!.bid![index])!.toStringAsPrecision(7)}' : '0.0'}',
                              style: const TextStyle(
                                color: Color(0xff286bdb),
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '${snapshot.connectionState == ConnectionState.active ? '${double.tryParse(snapshot.data!.bidQuantity![index])!.toStringAsPrecision(5)}' : '0.0'}',
                              style: const TextStyle(
                                color: Color(0xff286bdb),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${snapshot.connectionState == ConnectionState.active ? '${double.tryParse(snapshot.data!.ask![index])!.toStringAsPrecision(7)}' : '0.0'}',
                              style: const TextStyle(
                                color: Color(0xffef4006),
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '${snapshot.connectionState == ConnectionState.active ? '${double.tryParse(snapshot.data!.askQuantity![index])!.toStringAsPrecision(5)}' : '0.0'}',
                              style: const TextStyle(
                                color: Color(0xffef4006),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
  }
}

class ToggleContainer extends StatefulWidget {
  final String? text;
  final int? index;
  final double? fontSize;
  final Color? colorTheme;
  const ToggleContainer(
      {Key? key, this.text, this.index, this.fontSize, this.colorTheme})
      : super(key: key);

  @override
  State<ToggleContainer> createState() => _ToggleContainerState();
}

class _ToggleContainerState extends State<ToggleContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Text(
        '${widget.text}',
        style: TextStyle(
          color: orderSelected[widget.index!]
              ? widget.colorTheme!
              : const Color(0xffd9d9d7),
          fontSize: widget.fontSize,
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: const BorderRadius.all(Radius.circular(3)),
        border: Border.all(
          color: orderSelected[widget.index!]
              ? widget.colorTheme!
              : const Color(0xff1f1f1f),
        ),
      ),
    );
  }
}
