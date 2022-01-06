import 'package:flutter/material.dart';
import 'package:mared_social/constants/Constantcolors.dart';
import 'package:mared_social/screens/HomePage/homepage.dart';
import 'package:mared_social/screens/auctions/auctionspage.dart';
import 'package:mared_social/screens/splitter/splitterhelper.dart';
import 'package:provider/provider.dart';

class SplitPages extends StatefulWidget {
  @override
  _SplitPagesState createState() => _SplitPagesState();
}

class _SplitPagesState extends State<SplitPages> {
  ConstantColors constantColors = ConstantColors();
  final PageController appController = PageController();
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        leadingWidth: 0,
        elevation: 0,
        backgroundColor: constantColors.darkColor,
        title: Provider.of<SplitPagesHelper>(context, listen: false)
            .topNavBar(context, pageIndex, appController),
      ),
      body: PageView(
        controller: appController,
        children: [
          HomePage(),
          AuctionApp(),
        ],
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (page) {
          setState(() {
            pageIndex = page;
          });
        },
      ),
    );
  }
}
