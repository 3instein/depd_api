part of 'widgets.dart';

class UiLoading {
  static Container loading() {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: double.infinity,
      color: Colors.white54,
      child: const SpinKitFadingCircle(
        color: Colors.blue,
        size: 50,
      ),
    );
  }

  static Container loadingDD() {
    return Container(
      alignment: Alignment.center,
      width: 30,
      height: 30,
      color: Colors.white54,
      child: const SpinKitFadingCircle(
        color: Color.fromARGB(255, 245, 0, 0),
        size: 30,
      ),
    );
  }
}
