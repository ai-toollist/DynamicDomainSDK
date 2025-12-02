import 'dart:async';

class Apis {
  static StreamController kickoffController = StreamController<int>.broadcast();

  static void kickoff(int? errCode) {
    if (errCode == 1501 ||
        errCode == 1503 ||
        errCode == 1504 ||
        errCode == 1505) {
      kickoffController.sink.add(errCode);
    }
  }

}
