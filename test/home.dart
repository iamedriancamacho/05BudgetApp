/*
import 'category.dart';
import 'add_category.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _buildCategory(Category category, double totalAmountSpent) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => NewTransaction(
                  category: category,
                )),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        padding: EdgeInsets.all(10.0),
        height: 50.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  category.name,
                  style: TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Josefin Sans'),
                ),
                Text(
                  '\$${(category.maxAmount - totalAmountSpent).toStringAsFixed(2)}/\$${category.maxAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontFamily: 'Josefin Sans',
                      fontSize: 10.0,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double maxBarWidth = constraints.maxWidth;
                final double percent = (category.maxAmount - totalAmountSpent) /
                    category.maxAmount;
                double barWidth = percent * maxBarWidth;

                if (barWidth < 0) {
                  barWidth = 0;
                }
                return Stack(
                  children: <Widget>[
                    Container(
                      height: 20.0,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    Container(
                      height: 20.0,
                      width: barWidth,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            forceElevated: true,
            expandedHeight: 70.0,
            leading: IconButton(
              icon: Icon(Icons.settings),
              iconSize: 25.0,
              onPressed: () {},
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Simple Budget',
                style: TextStyle(fontFamily: 'Josefin Sans'),
              ),
              centerTitle: true,
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                iconSize: 25.0,
                onPressed: () {
                  showBottomSheet(
                      context: context, builder: (context) => Container());
                },
              )
            ],
          ),
          // 
        ],
      ),
    );
  }
  }
*/