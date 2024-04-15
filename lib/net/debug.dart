import 'dart:io';

HttpClient createDioHttpClient() {
  HttpClient client = HttpClient();
  client.findProxy = (uri){
    return 'DIRECT';
    //return 'PROXY 10.70.178.11:8888';
  };
  client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  return client;
}