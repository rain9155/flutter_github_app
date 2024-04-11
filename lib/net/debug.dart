import 'dart:io';

HttpClient createDioHttpClient() {
  HttpClient client = HttpClient();
  client.findProxy = (uri){
    return 'DIRECT';
  };
  client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  return client;
}