import 'package:fitcoach/meal_create/mealUi/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'dart:developer';
import 'package:fitcoach/routes/app_routes.dart';
import 'package:fitcoach/theme/app_colors.dart';

class FoodSearchController extends GetxController {
  var allFoods = <Product>[].obs;
  var fitnessFoods = <Product>[].obs;
  var packageItems = <Product>[].obs;
  var filteredFoods = <Product>[].obs;
  var selectedTab = 0.obs;
  var isLoading = false.obs; // ✅ Loading state
  var currentPage = 1.obs;
  final int itemsPerPage = 10;
  ScrollController scrollController = ScrollController();
  var isLoadingMore = false.obs;

  @override
  void onInit() {
    fetchAllFoods(query: "Almonds", isFullData: true);
    scrollController.addListener(_scrollListener);
    super.onInit();
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 100 &&
        !isLoadingMore.value) {
      fetchMoreFoods();
    }
  }

  Future<void> fetchAllFoods({String? query, required bool isFullData}) async {
    try {
      isLoading.value = true;
      currentPage.value = 1; // Reset page number when doing a fresh search

      User offUser =
          User(userId: "sayakmishra8@gmail.com", password: "Sayak123@");

      final SearchResult result = await OpenFoodAPIClient.searchProducts(
        offUser,
        ProductSearchQueryConfiguration(
          parametersList: [
            if (query != null) SearchTerms(terms: [query]),
            PageNumber(page: currentPage.value),
            PageSize(size: itemsPerPage),
          ],
          fields: [ProductField.ALL],
          language: OpenFoodFactsLanguage.ENGLISH,
          country: OpenFoodFactsCountry.INDIA,
          version: ProductQueryVersion.v3,
        ),
      );

      log("API Response: ${result.products?.length ?? 0} products found.");

      if (result.products != null && result.products!.isNotEmpty) {
        allFoods.assignAll(result.products!);
      } else {
        log("No products found.");
      }

      updateTabData(selectedTab.value);
    } catch (e) {
      log("Error fetching food data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMoreFoods() async {
    try {
      if (isLoadingMore.value) return;
      isLoadingMore.value = true;
      currentPage.value += 1;

      User offUser =
          User(userId: "sayakmishra8@gmail.com", password: "Sayak123@");

      final SearchResult result = await OpenFoodAPIClient.searchProducts(
        offUser,
        ProductSearchQueryConfiguration(
          parametersList: [
            PageNumber(page: currentPage.value),
            PageSize(size: itemsPerPage),
          ],
          fields: [ProductField.ALL],
          language: OpenFoodFactsLanguage.ENGLISH,
          country: OpenFoodFactsCountry.INDIA,
          version: ProductQueryVersion.v3,
        ),
      );

      if (result.products != null && result.products!.isNotEmpty) {
        allFoods.addAll(result.products!);
      }

      updateTabData(selectedTab.value);
    } catch (e) {
      log("Error fetching more food data: $e");
    } finally {
      isLoadingMore.value = false;
    }
  }

  void updateTabData(int index) {
    selectedTab.value = index;
    if (index == 0 || index == 3) {
      filteredFoods.assignAll(allFoods);
    } else {
      filteredFoods.clear();
    }
  }
}

class FoodSearchScreen extends StatelessWidget {
  const FoodSearchScreen({super.key});

  void fetchDataFoodInfo(Product? _product) {
    if (_product == null) {
      Get.snackbar("Error", "Product data is unavailable");
      return;
    }

    double proteins = _getNutrientValue(Nutrient.proteins, _product);
    double fat = _getNutrientValue(Nutrient.fat, _product);
    double carbohydrates = _getNutrientValue(Nutrient.carbohydrates, _product);
    double kcal = _getNutrientValue(Nutrient.energyKCal, _product);
    double proteinPercentage = (proteins * 4 / kcal) * 100;
    double fatPercentage = (fat * 9 / kcal) * 100;
    double carbohydratePercentage = (carbohydrates * 4 / kcal) * 100;
    String servingSize = _product.servingSize?.isNotEmpty == true
        ? _product.servingSize!
        : "100g";
    String dataSource =
        _product.creator?.isNotEmpty == true ? _product.creator! : "Unknown";
    String productName = _product.productName?.isNotEmpty == true
        ? _product.productName!
        : "No Name";

    Get.toNamed(AppRoutes.nutritionSummaryScreen, arguments: {
      'protein': proteins.toStringAsFixed(2),
      'fat': fat.toStringAsFixed(2),
      'carbohydrates': carbohydrates.toStringAsFixed(2),
      'kcal': kcal.toStringAsFixed(2),
      'servingSize': servingSize,
      'dataSource': dataSource,
      'name': productName,
      'proteinPercentage': proteinPercentage.isNaN
          ? '0.00'
          : proteinPercentage.toStringAsFixed(2),
      'fatPercentage':
          fatPercentage.isNaN ? '0.00' : fatPercentage.toStringAsFixed(2),
      'carbohydratePercentage': carbohydratePercentage.isNaN
          ? '0.00'
          : carbohydratePercentage.toStringAsFixed(2),
    });
  }

  double _getNutrientValue(Nutrient nutrient, _product) {
    double? per100g =
        _product?.nutriments?.getValue(nutrient, PerSize.oneHundredGrams);
    return per100g ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FoodSearchController());

    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          backgroundColor: Colors.black,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back, color: AppColors.textLight),
          ),
          title: Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              style: TextStyle(color: AppColors.textLight),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  controller.fetchAllFoods(query: value, isFullData: true);
                }
              },
              // onChanged: ,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                suffixIcon:
                    Icon(LucideIcons.settings2, color: AppColors.primaryorange),
                hintText: 'Search all foods...',
                hintStyle: TextStyle(color: Colors.grey[300], fontSize: 14),
                border: InputBorder.none,
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Get.to(() => BarcodeScannerScreen());
              },
              icon: Image.asset(
                'assets/utility/barcode.png',
                width: 30,
                color: AppColors.textLight,
              ),
            )
          ],
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
                  image:
                      AssetImage("assets/homeScreen/homescreen_appbar_img.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: TabBar(
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 5,
                indicatorColor: Colors.blue,
                tabAlignment: TabAlignment.start,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                onTap: controller.updateTabData,
                tabs: [
                  Tab(text: 'All'),
                  // Tab(text: 'Fevorite'),
                  // Tab(text: 'Custom'),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            SizedBox(height: 10),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.gray10,
                ),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(
                        child:
                            CircularProgressIndicator()); // ✅ Loading indicator
                  }

                  if (controller.filteredFoods.isEmpty) {
                    return Center(
                      child: Text(
                        "No Data Found",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ); // ✅ No data message
                  }

                  return ListView.builder(
                    controller: controller
                        .scrollController, // ✅ Attach scroll controller
                    itemCount: controller.filteredFoods.length +
                        1, // Extra item for loader
                    itemBuilder: (context, index) {
                      if (index == controller.filteredFoods.length) {
                        return Obx(() => controller.isLoadingMore.value
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              )
                            : SizedBox.shrink());
                      }

                      var food = controller.filteredFoods[index];

                      return Column(
                        children: [
                          ListTile(
                            onTap: () {
                              fetchDataFoodInfo(food);
                            },
                            title: Text(food.productName ?? "Unknown",
                                style: TextStyle(
                                    color: AppColors.textDark,
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(food.brands ?? "No Brand",
                                style: TextStyle(color: AppColors.textDark)),
                          ),
                          Divider(thickness: 0.5),
                        ],
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
