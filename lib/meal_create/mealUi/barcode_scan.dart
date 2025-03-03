import 'dart:developer';

import 'package:fitcoach/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class FoodService {
  static Future<Product?> fetchProductByBarcode(String barcode) async {
    try {
      ProductQueryConfiguration config = ProductQueryConfiguration(
        barcode,
        fields: [
          ProductField.ALL, // Fetch all fields for completeness
        ],
        version: ProductQueryVersion.v3,
      );

      ProductResultV3 result = await OpenFoodAPIClient.getProductV3(config);
      return result.product;
    } catch (e) {
      log("Error fetching product: $e");
      return null;
    }
  }
}

class BarcodeScannerScreen extends StatefulWidget {
  @override
  _BarcodeScannerScreenState createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  final MobileScannerController cameraController = MobileScannerController();
  final Set<String> scannedBarcodes = {}; // Track unique barcodes
  Product? _product;
  bool _isLoading = false;

  void _onBarcodeDetected(BarcodeCapture capture) {
    if (capture.barcodes.isNotEmpty) {
      final String barcode = capture.barcodes.first.rawValue ?? "Unknown";

      if (!scannedBarcodes.contains(barcode)) {
        scannedBarcodes.add(barcode);
        _fetchProduct(barcode);
      }
    }
  }

  void _fetchProduct(String barcode) async {
  setState(() => _isLoading = true);

  try {
    _product = await FoodService.fetchProductByBarcode(barcode);
  } catch (e) {
    log("Error fetching product: $e");
    Get.snackbar("Error", "Failed to fetch product data",
        snackPosition: SnackPosition.BOTTOM);
    setState(() => _isLoading = false);
    return;
  }

  setState(() => _isLoading = false);

  if (_product == null) {
    Get.snackbar("Error", "Product not found",
        snackPosition: SnackPosition.BOTTOM);
    return;
  }

  log("Fetched Product: ${_product?.productName ?? 'Unknown'}");

  // Extracting macronutrient values
  double proteins = _getNutrientValue(Nutrient.proteins);
  double fat = _getNutrientValue(Nutrient.fat);
  double carbohydrates = _getNutrientValue(Nutrient.carbohydrates);
  double kcal = _getNutrientValue(Nutrient.energyKCal);

  if (kcal == 0) {
    kcal = (proteins * 4) + (carbohydrates * 4) + (fat * 9);
  }
  

  // Calculate percentage contributions
  double proteinPercentage = (proteins * 4 / kcal) * 100;
  double fatPercentage = (fat * 9 / kcal) * 100;
  double carbohydratePercentage = (carbohydrates * 4 / kcal) * 100;

  // Ensuring valid percentages
  proteinPercentage = proteinPercentage.isNaN ? 0.0 : proteinPercentage;
  fatPercentage = fatPercentage.isNaN ? 0.0 : fatPercentage;
  carbohydratePercentage =
      carbohydratePercentage.isNaN ? 0.0 : carbohydratePercentage;

  String servingSize = _product?.servingSize?.isNotEmpty == true
      ? _product!.servingSize!
      : "100g";
  String dataSource =
      _product?.creator?.isNotEmpty == true ? _product!.creator! : "Unknown";
  String productName = _product?.productName?.isNotEmpty == true
      ? _product!.productName!
      : "No Name";

  // Navigate to Nutrition Summary Screen with fetched details
  Get.toNamed(AppRoutes.nutritionSummaryScreen, arguments: {
    'protein': proteins.toStringAsFixed(2),
    'fat': fat.toStringAsFixed(2),
    "carbohydrates": carbohydrates.toStringAsFixed(2),
    "kcal": kcal.toStringAsFixed(2),
    "servingSize": servingSize,
    "dataSource": dataSource,
    "name": productName,
    "proteinPercentage": proteinPercentage.toStringAsFixed(2),
    "fatPercentage": fatPercentage.toStringAsFixed(2),
    "carbohydratePercentage": carbohydratePercentage.toStringAsFixed(2),
  });
}

  double _getNutrientValue(Nutrient nutrient) {
    double? per100g =
        _product?.nutriments?.getValue(nutrient, PerSize.oneHundredGrams);
    return per100g ?? 0.0;
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan Barcode"),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: _onBarcodeDetected,
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
          if (_isLoading)
            Center(
                child:
                    CircularProgressIndicator()), // Show loader while fetching

          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.flash_on, color: Colors.white),
                  onPressed: () {
                    cameraController.toggleTorch();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    // Handle manual barcode input
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
