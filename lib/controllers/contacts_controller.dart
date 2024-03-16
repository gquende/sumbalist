import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/contact_model.dart';

class ContactsController extends GetxController {
  var contacts = <ContactModel>[].obs;

  var isLoading = false.obs;

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(
      PermissionStatus permissionStatus, BuildContext context) {
    if (permissionStatus == PermissionStatus.denied) {
      final snackBar = SnackBar(content: Text('Accesso ao contacto negado!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      final snackBar =
          SnackBar(content: Text('Dados de contactos não disponível'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> getContacts(BuildContext context) async {
    PermissionStatus permissionStatus = await _getContactPermission();
    _handleInvalidPermissions(permissionStatus, context);

    try {
      isLoading.value = true;

      var contactsOnPhone =
          await ContactsService.getContacts(withThumbnails: false);

      contactsOnPhone.forEach((element) {
        if (kDebugMode) {
          print(element.givenName);
          print(element.androidAccountName);
          print(element.toMap().toString());
        }

        contacts.value.add(ContactModel(
            displayName: element?.displayName ?? '',
            phoneNumber: element?.phones?[0].value ?? '',
            username: "Test",
            registered: true));
      });

      isLoading.value = false;
    } catch (error) {
      isLoading.value = false;
    }
  }
}
