class ImageHelper {
    static String fixImageUrl(String originalUrl) {
      return originalUrl.replaceFirst('localhost', '10.0.2.2'); // for Android emulator
  }
}


