import 'dart:io';

// TODO: delete this in prod! enabling self signed SSL is not a good idea
// TODO: I need this because the stomp client only allows communication over wss
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
