import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart' as loc;
import 'package:google_api_headers/google_api_headers.dart' as header;
import 'package:google_maps_webservice/places.dart' as places;
import 'package:google_maps_webservice/places.dart';
import 'package:one_click/home.dart';
import 'package:one_click/values/colors.dart';
import 'package:one_click/values/dimens.dart';
import 'manage/static_method.dart';
import 'values/styles.dart';

class MapLocation extends StatefulWidget {
  final lat, lng, type;
  MapLocation({super.key, this.lat, this.lng, this.type});

  @override
  State<MapLocation> createState() => _MapLocationState();
}

class _MapLocationState extends State<MapLocation> {
  late BuildContext ctx;
  final Set<Marker> _markers = {};
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

  var Lat, Lng, address,selectAddress;
  List<Placemark> list = [];
  GoogleMapController? _controller;
  bool check = true;

  Future<void> _handleSearch() async {
    places.Prediction? p = await loc.PlacesAutocomplete.show(
        context: context,
        apiKey: 'AIzaSyAyKmLpB0xhYM7i1b7yirSZE0WXMGe2GQE',
        onError: onError,
        // call the onError function below
        mode: loc.Mode.overlay,
        language: 'en',
        //you can set any language for search
        strictbounds: false,
        types: [],
        decoration: InputDecoration(hintText: 'search'),
        logo: Container(
          height: 0,
        ),
        components: [] // you can determine search for just one country
        );
    if(p == null){
      setState(() {
        check = true;
      });
    }else{
      setState(() {
        check = true;
      });
    }
    displayPrediction(p!.placeId, scaffoldState.currentState,p.description);
  }

  void onError(places.PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Message',
        message: response.errorMessage!,
        contentType: ContentType.failure,
      ),
    ));
  }

  Future<void> displayPrediction(p, ScaffoldState? currentState,address) async {
    if (p != null) {
      final places = GoogleMapsPlaces(
        apiKey: "AIzaSyAyKmLpB0xhYM7i1b7yirSZE0WXMGe2GQE",
        apiHeaders: await GoogleApiHeaders().getHeaders(),
      );
      final detail = await places.getDetailsByPlaceId(p);
      print('detail: $detail');
      final geometry = detail.result.geometry!;
      list = await placemarkFromCoordinates(
          geometry.location.lat, geometry.location.lng);
// detail will get place details that user chose from Prediction search
      setState(() {
        selectAddress = address;
        double lat = double.parse(geometry.location.lat.toString());
        double lng = double.parse(geometry.location.lng.toString());
        _markers.clear(); //clear old marker and set new one
        _markers.add(Marker(
          markerId: const MarkerId('deliveryMarker'),
          position: LatLng(lat, lng),
          infoWindow: const InfoWindow(
            title: '',
          ),
        ));
        _controller?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(lat, lng), zoom: 15),
          ),
        );
        Lat = geometry.location.lat.toString();
        Lng = geometry.location.lng.toString();
      });
    }
  }

  TextEditingController controller = TextEditingController();

  _handleTap(LatLng point) async {
    _markers.clear();
    list = await placemarkFromCoordinates(point.latitude, point.longitude);
    setState(() {
      address = list[0].subLocality;
      _markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: InfoWindow(title: address.toString()),
        icon: BitmapDescriptor.defaultMarker,
      ));
      Lat = point.latitude;
      Lng = point.longitude;
    });
    print(list);
  }

  getSession() async {
    list = await placemarkFromCoordinates(widget.lat, widget.lng);
    setState(() {
      address = list[0].thoroughfare;
      _markers.add(
        Marker(
          markerId: const MarkerId('Marker'),
          position: LatLng(widget.lat, widget.lng),
          infoWindow: InfoWindow(title: address.toString()),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Clr().white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        height: Dim().d52,
        width: Dim().d300,
        child: ElevatedButton(
            onPressed: () {
              if (widget.type == 'pick') {
                HomeState.pickAddCtrl.sink.add(
                    {
                      'address' : selectAddress ?? '${list[1].thoroughfare} ${list[1].subLocality} ${list[1].postalCode} ${list[1].country}',
                      'pincode': list[0].postalCode == '' ? list[1].postalCode : list[0].postalCode,
                      'state': list[0].administrativeArea == '' ? list[1].administrativeArea : list[0].administrativeArea,
                      'city':  selectAddress ?? '${list[1].thoroughfare} ${list[1].subLocality} ${list[1].postalCode} ${list[1].country}',
                      "latitude": Lat ?? widget.lat,
                      "longitude": Lng ?? widget.lng,
                    }
                );
                STM().back2Previous(ctx);
              } else {
                HomeState.addresscontroller.sink.add({
                  "latitude": Lat ?? widget.lat,
                  "longitude": Lng ?? widget.lng,
                  "state":  list[0].administrativeArea == '' ? list[1].administrativeArea : list[0].administrativeArea,
                  "city": selectAddress ?? '${list[1].thoroughfare} ${list[1].subLocality} ${list[1].postalCode} ${list[1].country}',
                  "pincode": list[0].postalCode == '' ? list[1].postalCode : list[0].postalCode,
                });
                print(Lat);
                print(Lng);
                STM().back2Previous(ctx);
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Clr().clr29,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(Dim().d20)))),
            child: Center(
              child: Text('Confirm Location',
                  style: Sty().mediumText.copyWith(color: Clr().white)),
            )),
      ),
      appBar: check ? AppBar(
        elevation: 0,
        backgroundColor: Clr().transparent,
        leadingWidth: 52,
        leading: InkWell(
            onTap: () {
              STM().back2Previous(ctx);
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                  padding: EdgeInsets.all(10),
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                      color: Clr().primaryColor, shape: BoxShape.circle),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Clr().white,
                    size: 18,
                  )),
            )),
        title: TextFormField(
          readOnly: true,
          onTap: () {
            _handleSearch();
            Future.delayed(Duration(seconds: 1),(){
              setState(() {
                check = false;
              });
            });
          },
          maxLines: selectAddress.toString().length > 50 ?  3 : 1,
          decoration: Sty().TextFormFieldOutlineDarkStyle.copyWith(
              contentPadding: EdgeInsets.symmetric(
                  vertical: Dim().d14, horizontal: Dim().d14),
              hintText: selectAddress ?? 'Search',
              hintStyle: Sty().smallText),
        ),
        centerTitle: true,
      ) : AppBar(
        elevation: 0,
        backgroundColor: Clr().transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(ctx).size.height,
              child: GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  _controller = controller;
                },
                markers: _markers,
                indoorViewEnabled: true,
                scrollGesturesEnabled: true,
                zoomGesturesEnabled: true,
                mapType: MapType.hybrid,
                onTap: _handleTap,
                initialCameraPosition: CameraPosition(
                  target: LatLng(widget.lat ?? 0, widget.lng ?? 0),
                  zoom: widget.lat == null ? 2 : 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
