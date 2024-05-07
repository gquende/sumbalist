import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:sumbalist/models/userLocation.dart';

class LocationService {
  String ipApi = "http://ip-api.com/json";
  String countriesApi = "https://restcountries.com/v3.1";
  Dio dio = Dio();

  LocationService() {}

  Future<UserLocation?> getUserLocation() async {
    try {
      //Country information by Api
      var response = await dio.post(ipApi,
          options: Options(contentType: 'application/json', headers: {}));

      if (response.statusCode == 200) {
        UserLocation location = UserLocation(
            country: response.data["country"],
            countryCode: response.data["countryCode"],
            regionName: response.data["city"]);

        //Get All country information
        response = await dio.get("${countriesApi}/name/${location.country}",
            options: Options(contentType: 'application/json', headers: {}));

        if (response.statusCode == 200) {
          var information = (response.data as List)[0];

          location.flag = information["flag"];
          location.idd =
              "${information["idd"]["root"]}${(information["idd"]["suffixes"][0])}";
        }

        return location;
      }
    } catch (error) {
      if (error is DioException) {
        if (error.response != null) {
          print('Código de status do erro: ${error.response!.statusCode}');
          print(
              'Mensagem de erro do servidor: ${error.response!.statusMessage}');
          print('Corpo da resposta do servidor: ${error.response!.data}');
          return error.response!.data;
        }
      } else {
        print("${error.toString()}");
      }
    }
  }

  Future<List<UserLocation>?> getLocations() async {
    try {
      Future<List<dynamic>> carregarDados() async {
        // Carrega o conteúdo do arquivo JSON
        String jsonString =
            await rootBundle.loadString('assets/data/countries.json');

        // Decodifica o JSON em uma lista de objetos Dart
        List<dynamic> lista = json.decode(jsonString);
        List<UserLocation> locations = [];

        lista.forEach((element) {
          var location = UserLocation(
            country: element["name"]["common"],
            countryCode: element["cca2"],
          );

          locations.add(location);
          print(element);
        });

        return locations;
      }
    } catch (error) {
      print(error);
    }

    return [];
  }
}
