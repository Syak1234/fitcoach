import 'package:fitcoach/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class FoodSearchScreen extends StatelessWidget {
  const FoodSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
            titleSpacing: 0,
            backgroundColor: Colors.black,
            leading: IconButton(
                // padding: EdgeInsets.symmetric(horizontal: 0),
                onPressed: () {},
                icon: Icon(
                  Icons.arrow_back,
                  color: AppColors.textLight,
                )),
            title: Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                style: TextStyle(color: AppColors.textLight),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: Icon(
                    LucideIcons.settings2,
                    color: AppColors.primaryorange,
                  ),
                  hintText: 'Search all foods...',
                  hintStyle: TextStyle(color: Colors.grey[300], fontSize: 14),
                  border: InputBorder.none,
                ),
              ),
            ),
            actions: [
              // IconButton(
              //   icon: const Icon(LucideIcons.settings2, color: Colors.orange),
              //   onPressed: () {},
              // ),
              IconButton(
                  onPressed: () {},
                  icon: Image.asset(
                    'assets/utility/barcode.png',
                    width: 30,
                    color: AppColors.textLight,
                  ))
            ],
            // flexibleSpace: ,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 6),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  image: DecorationImage(
                    image: AssetImage(
                        "assets/homeScreen/homescreen_appbar_img.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: const TabBar(
                  tabAlignment: TabAlignment.center,
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 5,
                  // automaticIndicatorColorAdjustment: true,

                  // overlayColor: WidgetStatePropertyAll(Colors.red),
                  indicatorColor: Colors.blue,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(text: 'All'),
                    Tab(text: 'Favorites'),
                    Tab(text: 'Custom'),
                    Tab(text: 'Common'),
                  ],
                ),
              ),
            )),
        body: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 6,
                  // vertical: 5,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.gray10,
                ),
                child: ListView(
                  children: [
                    for (int i = 0; i < 5; i++) ...[
                      Container(
                        padding: EdgeInsets.all(0),
                        margin: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                            // border:
                            //     Border(bottom: BorderSide(color: AppColors.gray)),

                            ),
                        child: ListTile(
                          minVerticalPadding: 3,
                          minTileHeight: 20,
                          title: Text('Water',
                              style: TextStyle(
                                  color: AppColors.textDark,
                                  fontWeight: FontWeight.bold)),
                          subtitle: Text('8 fl oz',
                              style: TextStyle(color: AppColors.textDark)),
                          trailing: Text('CRDB',
                              style: TextStyle(
                                  color: AppColors.textDark,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                      Divider(
                        thickness: 0.5,
                      )
                    ]
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
