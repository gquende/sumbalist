import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:sumbalist/models/userLocation.dart';

import '../core/error/errorLog.dart';

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
          devLog('Código de status do erro: ${error.response!.statusCode}');
          devLog(
              'Mensagem de erro do servidor: ${error.response!.statusMessage}');
          devLog('Corpo da resposta do servidor: ${error.response!.data}');
          return error.response!.data;
        }
      } else {
        devLog("${error.toString()}");
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
          devLog(element);
        });

        return locations;
      }
    } catch (error) {
      devLog(error);
    }

    return [];
  }
}
