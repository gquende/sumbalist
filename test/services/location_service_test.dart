import 'package:flutter_test/flutter_test.dart';
import 'package:sumbalist/services/location_service.dart';

main() {
  LocationService service = LocationService();

  setUp(() async {});

  test("Get UserLocation", () async {
    var location = await service.getUserLocation();
    expect(location, isNotNull);
  });

  test("Get Locations", () async {
    var locations = await service.getLocations();
    expect(locations, isNotNull);
  });
}
