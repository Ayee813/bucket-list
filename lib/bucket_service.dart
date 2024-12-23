import 'package:flutter/cupertino.dart';

import 'main.dart';

class BucketService extends ChangeNotifier {
  List<Bucket> bucketList = [Bucket("programer", true)];

  void createBucket(String job) {
    bucketList.add(Bucket(job, false));
    notifyListeners();
  }

  void updateBucket(Bucket bucket, int index) {
    bucketList[index] = bucket;
    notifyListeners();
  }
}
