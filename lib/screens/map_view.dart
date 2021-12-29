import 'package:abda_learning/meta/Utility/constants.dart';
import 'package:abda_learning/meta/models/students.dart';
import 'package:abda_learning/screens/student_profile.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
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
  Future<String> getAddressFromLatLng(double? lat, double? long) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(lat ?? 0, long ?? 0);
    Placemark placemark = placemarks[0];
    String address = (placemark.subThoroughfare ?? '') +
        ' ' +
        (placemark.thoroughfare ?? '') +
        ' ' +
        (placemark.subLocality ?? '') +
        ' ' +
        (placemark.locality ?? '') +
        ' ' +
        (placemark.subAdministrativeArea ?? '') +
        ' ' +
        (placemark.administrativeArea ?? '') +
        ' ' +
        (placemark.postalCode ?? '') +
        ' ' +
        (placemark.country ?? '');
    return address;
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
          onTap: () {
            // _pageController!.animateToPage(
            //   widget.students.indexOf(student),
            //   duration: const Duration(milliseconds: 200),
            //   curve: Curves.easeInOut,
            // );
            _pageController!.jumpToPage(widget.students.indexOf(student));
          },
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
    String address = "";
    return InkWell(
      onTap: () {
        Get.to(() => StudentProfile(
              student: student,
              address: address,
            ));
      },
      child: Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              // boxShadow: [boxShadow],
              borderRadius: BorderRadius.circular(10.0),
              color: bgColor.withOpacity(0.9)),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: primaryColor,
                  backgroundImage:
                      AssetImage("assets/images/${student.gender}.png"),
                ),
                Column(
                  children: [
                    Text("${student.firstName}  ${student.lastName}",
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 17)),
                    Text(student.email ?? "",
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontWeight: FontWeight.w600, fontSize: 12)),
                  ],
                ),
                FutureBuilder<String>(
                  future: getAddressFromLatLng(student.lat, student.long),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      address = snapshot.data ?? "";
                    }
                    return Text(
                      snapshot.data ?? "",
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 10),
                    );
                  },
                )
              ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: bgColor,
      //   centerTitle: true,
      //   title: Text("Map View"),
      // ),
      body: widget.students.isEmpty
          ? const Center(
              child: Text(
                "No Students Available",
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
              ),
            )
          : SafeArea(
              child: Stack(
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
                      height: MediaQuery.of(context).size.height * 0.25,
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
                  ),
                  Positioned(
                    top: 20.0,
                    left: 20,
                    child: CircleAvatar(
                      backgroundColor: primaryColor,
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
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
