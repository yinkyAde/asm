import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_database/firebase_database.dart';

Future<void> addAsset(String assetName, String uniqueAssetCode, String date, String assetType, String assetLocation, String assetValue) async {
  DatabaseReference database =
      FirebaseDatabase.instance.reference().child("Assets");
  database.push().set({
    'assetName': assetName,
    'assetType': assetType,
    'uniqueAssetName': uniqueAssetCode,
    'assetDate': date,
    'assetLocation': assetLocation,
    'assetValue': assetValue
  });
}
