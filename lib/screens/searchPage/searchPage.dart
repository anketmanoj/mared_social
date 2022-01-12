import 'package:flutter/material.dart';
import 'package:mared_social/constants/Constantcolors.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ConstantColors constantColors = ConstantColors();
  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constantColors.blueGreyColor,
      appBar: AppBar(
        backgroundColor: constantColors.darkColor,
        title: Text(
          "Search Page",
          style: TextStyle(
            color: constantColors.whiteColor,
          ),
        ),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: textController,
                keyboardType: TextInputType.text,
                autocorrect: false,
                style: TextStyle(
                  color: constantColors.whiteColor,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: constantColors.darkColor,
                  hintText: "I.e. Air Jordan 1's",
                  hintStyle: TextStyle(
                    color: constantColors.lightColor.withOpacity(0.6),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  prefixIcon: Icon(
                    Icons.search_outlined,
                    color: constantColors.whiteColor,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      textController.clear();
                    },
                    icon: Icon(
                      Icons.clear,
                      color: constantColors.whiteColor,
                    ),
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
