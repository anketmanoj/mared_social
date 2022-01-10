import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mared_social/constants/Constantcolors.dart';

class CounterView extends StatefulWidget {
  final int initNumber;
  final Function(int) counterCallback;
  final Function increaseCallback;
  final Function decreaseCallback;
  final int minNumber;
  final int auctionCurrentAmount;
  const CounterView(
      {Key? key,
      required this.initNumber,
      required this.counterCallback,
      required this.increaseCallback,
      required this.decreaseCallback,
      required this.minNumber,
      required this.auctionCurrentAmount})
      : super(key: key);
  @override
  _CounterViewState createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  late int _currentCount;
  late Function _counterCallback;
  late Function _increaseCallback;
  late Function _decreaseCallback;
  late int _minNumber;
  late int _auctionCurrentAmount;

  @override
  void initState() {
    _currentCount = widget.initNumber;
    _counterCallback = widget.counterCallback;
    _increaseCallback = widget.increaseCallback;
    _decreaseCallback = widget.decreaseCallback;
    _minNumber = widget.minNumber;
    _auctionCurrentAmount = widget.auctionCurrentAmount;
    super.initState();
  }

  ConstantColors constantColors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.4,
      width: size.width,
      decoration: BoxDecoration(
        color: constantColors.blueGreyColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              "Select Bid Amount",
              style: TextStyle(
                color: constantColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  backgroundColor: constantColors.darkColor,
                  onPressed: () => _dicrement(),
                  child: Icon(
                    FontAwesomeIcons.minus,
                    color: constantColors.redColor,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.1,
                  width: size.width * 0.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "AED $_currentCount",
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                FloatingActionButton(
                  backgroundColor: constantColors.darkColor,
                  onPressed: () => _increment(),
                  child: Icon(
                    FontAwesomeIcons.plus,
                    color: constantColors.greenColor,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              height: size.height * 0.1,
              width: size.width,
              decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: constantColors.blueColor,
                    width: 1,
                    style: BorderStyle.solid),
              ),
              child: SizedBox(
                height: size.height * 0.1,
                width: size.width * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Auction Item Price",
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "AED $_auctionCurrentAmount",
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: Colors.pink,
                  fixedSize: const Size(300, 70),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: () {},
                icon: Icon(
                  FontAwesomeIcons.gavel,
                  color: constantColors.whiteColor,
                  size: 20,
                ),
                label: Text(
                  "Place Bid",
                  style: TextStyle(
                    color: constantColors.whiteColor,
                    fontSize: 20,
                  ),
                )),
          ),
        ],
      ),
    );
  }

  void _increment() {
    setState(() {
      _currentCount++;
      _auctionCurrentAmount++;
      _counterCallback(_currentCount);
      _increaseCallback();
    });
  }

  void _dicrement() {
    setState(() {
      if (_currentCount > widget.minNumber) {
        _currentCount--;
        _auctionCurrentAmount--;
        _counterCallback(_currentCount);
        _decreaseCallback();
      }
    });
  }
}
