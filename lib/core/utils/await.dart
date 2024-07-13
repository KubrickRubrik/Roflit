abstract final class Await {
  static Future<void> millisecond(int number, {Function? call}) async {
    await Future.delayed(Duration(milliseconds: number), () {});
  }

  static Future<void> second(int number, {Function? call}) async {
    await Future.delayed(Duration(seconds: number), () {});
  }
}
