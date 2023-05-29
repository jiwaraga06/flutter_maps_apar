// import 'dart:async';
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class MyMaps extends StatefulWidget {
//   const MyMaps({Key? key}) : super(key: key);

//   @override
//   State<MyMaps> createState() => MyMapsState();
// }

// class MyMapsState extends State<MyMaps> {
//   Position? currentPosition;
//   Completer<GoogleMapController> _controller = Completer();
//   Future getPermission() async {
//     LocationPermission permission = await Geolocator.requestPermission();
//     getCurrentPosition();
//   }

//   void getCurrentPosition() async {
//     await Geolocator.getCurrentPosition().then((value) {
//       setState(() {
//         print('My Position: $value');
//         currentPosition = value;
//       });
//     }).catchError((e) {
//       print('Error Get Current Position: $e');
//     });
//     // print(position);
//     // StreamSubscription<ServiceStatus> serviceStatusStream = Geolocator.getServiceStatusStream().listen(
//     //   (ServiceStatus status) {
//     //       print(status);
//     //   });
//   }

//   Future<Uint8List> getBytesFromAsset(String path, int width) async {
//     ByteData data = await rootBundle.load(path);
//     ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
//     ui.FrameInfo fi = await codec.getNextFrame();
//     return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
//   }

//   BitmapDescriptor? markerbitmap;
//   Uint8List? aparMerah;
//   Uint8List? aparHijau;
//   Uint8List? aparAbu;
//   BitmapDescriptor? aparAbus;
//   void iconApar() async {
//     aparMerah = await getBytesFromAsset('assets/aparMerah.png', 70);
//     aparHijau = await getBytesFromAsset('assets/aparHijau.png', 70);
//     aparAbu = await getBytesFromAsset('assets/aparAbu.png', 70);
//     aparAbus = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5,size: Size.fromWidth(80)), 'assets/aparAbu.png');
//   }

//   @override
//   void initState() {
//     getPermission();
//     iconApar();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("My Maps"),
//       ),
//       // floatingActionButton: FloatingActionButton(
//       //   onPressed: () {
//       //     getPermission();
//       //   },
//       //   child: Icon(Icons.location_on),
//       // ),
//       body: aparMerah == null ?
//       Center(child: CircularProgressIndicator())
//       :GoogleMap(
//         mapType: MapType.hybrid,
//         initialCameraPosition: CameraPosition(
//           target: LatLng(currentPosition!.latitude, currentPosition!.longitude),
//           zoom: 17,
//         ),
//         buildingsEnabled: true,
//         indoorViewEnabled: true,
//         mapToolbarEnabled: true,
//         myLocationEnabled: true,
//         myLocationButtonEnabled: true,
//         markers: {
//           Marker(
//             markerId: MarkerId("merah"),
//             position: LatLng(-7.047479, 107.745963),
//             icon: aparMerah == null ? BitmapDescriptor.defaultMarker : BitmapDescriptor.fromBytes(aparMerah!),
//             infoWindow: InfoWindow(title: "Expired"),
//           ),
//           Marker(
//             markerId: MarkerId("hijau"),
//             position: LatLng(-7.047620, 107.745900),
//             icon: aparHijau == null ? BitmapDescriptor.defaultMarker : BitmapDescriptor.fromBytes(aparHijau!),
//             infoWindow: InfoWindow(title: "Kondisi Baik"),
//           ),
//           Marker(
//             markerId: MarkerId("abu"),
//             position: LatLng(-7.047978, 107.745744),
//             icon: aparAbu == null ? BitmapDescriptor.defaultMarker : BitmapDescriptor.fromBytes(aparAbu!),
//             // icon: aparAbus!,
//             infoWindow: InfoWindow(
//                 title: "Di Service",
//                 onTap: () {
//                   print("object");
//                   showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           title: Text("Status Apar"),
//                           content: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: const [
//                               Text('Status'),
//                               Text('Di service'),
//                             ],
//                           ),
//                           actions: [
//                             TextButton(
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                 },
//                                 child: Text("Ok"))
//                           ],
//                         );
//                       });
//                 }),
//           ),
//         },
//       ),
//     );
//   }
// }
