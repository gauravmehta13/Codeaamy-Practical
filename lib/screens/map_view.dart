import 'package:abda_learning/meta/Utility/constants.dart';
import 'package:abda_learning/meta/models/students.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  final int initialIndex;
  final List<StudentData> students;
  const MapView({Key? key, required this.students, this.initialIndex = 0})
      : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Future<String> getAddressFromLatLng(LatLng latLng) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    return "";
  }

  GoogleMapController? _controller;

  List<Marker> allMarkers = [];

  PageController? _pageController;

  int? prevPage;
  late LatLng initialLatLng;
  @override
  void initState() {
    super.initState();
    initialLatLng = LatLng(widget.students[widget.initialIndex].lat ?? 0,
        widget.students[widget.initialIndex].long ?? 0);
    for (var student in widget.students) {
      allMarkers.add(Marker(
          markerId: MarkerId(student.id?.toString() ??
              DateTime.now().millisecondsSinceEpoch.toString()),
          draggable: false,
          infoWindow: InfoWindow(
              title: "${student.firstName}  ${student.lastName}",
              snippet: student.email),
          position: LatLng(student.lat ?? 0, student.long ?? 0)));
    }
    _pageController =
        PageController(initialPage: widget.initialIndex, viewportFraction: 0.7)
          ..addListener(_onScroll);
  }

  void _onScroll() {
    if (_pageController!.page!.toInt() != prevPage) {
      prevPage = _pageController!.page!.toInt();
      moveCamera();
    }
  }

  Widget buildCardOrderRequest(BuildContext context, StudentData student) {
    // TODo add future builder for address
    return InkWell(
      onTap: () {},
      child: Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
              // boxShadow: [boxShadow],
              borderRadius: BorderRadius.circular(10.0),
              color: Theme.of(context).backgroundColor),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: primaryColor,
                  backgroundImage:
                      AssetImage("assets/images/${student.gender}.png"),
                ),
                Text("${student.firstName}  ${student.lastName}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 17)),
                Text(student.email ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 12)),
              ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: widget.students.isEmpty
          ? const Center(
              child: Text(
                "No Students Available",
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
              ),
            )
          : Stack(
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: GoogleMap(
                    initialCameraPosition:
                        CameraPosition(target: initialLatLng, zoom: 5.0),
                    zoomControlsEnabled: false,
                    markers: Set.from(allMarkers),
                    onMapCreated: mapCreated,
                  ),
                ),
                Positioned(
                  bottom: 20.0,
                  child: SizedBox(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: widget.students.length,
                      itemBuilder: (BuildContext context, int index) {
                        return buildCardOrderRequest(
                            context, widget.students[index]);
                      },
                    ),
                  ),
                )
              ],
            ),
    );
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
    moveCamera();
  }

  moveCamera() {
    _controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(widget.students[_pageController!.page!.toInt()].lat ?? 0,
            widget.students[_pageController!.page!.toInt()].long ?? 0),
        zoom: 5,
        bearing: 45.0,
        tilt: 45.0)));
  }
}
