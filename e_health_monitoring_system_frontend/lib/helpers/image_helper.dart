class ImageHelper {
  static String fixImageUrl(String originalUrl) {
    // TODO: change this to your server's IP address or domain
    return originalUrl.replaceFirst(
      'localhost',
      '10.0.2.2', // emulator
      // '192.168.100.130', // ip lore
    );
  }
}
