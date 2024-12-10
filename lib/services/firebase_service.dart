import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../core/error/errorLog.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//import '../utils/utils.dart';

class FirebaseService {
  static final FirebaseDatabase database = FirebaseDatabase.instance;
  static final FirebaseAuth auth = FirebaseAuth.instance;

  static Future<Map<String, dynamic>?> loginAccount(
      String username, String password) async {
    Map<String, dynamic>? userData;

    try {
      var credentials = await auth.signInWithEmailAndPassword(
        email: username,
        password: password,
      );

      String node = credentials.user!.email!
          .substring(0, credentials.user!.email!.indexOf('@'));
      var snap = await database
          .ref('users')
          .child(credentials.user?.uid ?? node)
          .get();

      userData = {
        "uuid": credentials.user?.uid ?? '',
        "username": node,
        "name": (snap.value as Map)["name"],
        "surname": (snap.value as Map)["surname"],
        "email": (snap.value as Map)["email"],
        "phoneNumber": (snap.value as Map)["phone"],
      };
    } catch (e) {}

    return userData;
  }

  static Future<UserCredential> createAccount(Map<String, dynamic> map) async {
    var credentials = await auth.createUserWithEmailAndPassword(
        email: map["email"], password: map["password"]);
    var email = map["email"] as String;

    database.ref("users").child(credentials.user?.uid ?? email).set({
      "username": email,
      "name": map["name"],
      "surname": map["surname"],
      "email": map["email"],
      "phone": map["phone"]
    }).then((value) {
      database
          .ref("phones")
          .child(map["phone"])
          .set({"uuid": credentials.user?.uid ?? "undefined"})
          .then((value) {})
          .onError((error, stackTrace) {});
      ;
    }).onError((error, stackTrace) {});

    return credentials;
  }

  static Future<Map?> saveTempUser(Map<String, dynamic> map) async {
    database
        .ref("users")
        .child(map["username"])
        .set(map)
        .then((value) {})
        .onError((error, stackTrace) {});
  }

  /* static Future<User?> loginWithGoogle() async {
    User? user;
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      googleSignIn.signIn().then((value) async {
        if (value != null) {
          final GoogleSignInAuthentication googleSignInAuthentication =
              await value.authentication;

          final AuthCredential credential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken,
          );

          await auth.signInWithCredential(credential).then((value) {
            final String str = value.user!.email.toString();
            final String node = str.substring(0, str.indexOf('@'));
            database.ref('Accounts').child(node).set({
              'name': value.user!.displayName,
              'email': value.user!.email,
            }).then((val) {
              /* Utils.showSnackBar(
                  'Login',
                  'Successfully Login',
                  const Icon(
                    FontAwesomeIcons.triangleExclamation,
                    color: Colors.red,
                  ),
                  Colors.green);*/

              user = value.user;
            }).onError((error, stackTrace) {
              /*Utils.showSnackBar(
                  'Erro',
                  error.toString(),
                  const Icon(
                    FontAwesomeIcons.triangleExclamation,
                    color: Colors.red,
                  ),
                  Colors.red);*/
              return;
            });
          }).onError((error, stackTrace) {
            /* debugPrint(error.toString());
            Utils.showSnackBar(
                'Erro',
                error.toString(),
                const Icon(
                  FontAwesomeIcons.triangleExclamation,
                  color: Colors.red,
                ),
                Colors.red);*/
          });
        }
      }).onError((error, stackTrace) {
        /*debugPrint(error.toString());
        Utils.showSnackBar(
            'Erro',
            error.toString(),
            const Icon(
              FontAwesomeIcons.triangleExclamation,
              color: Colors.red,
            ),
            Colors.red);*/
      });
    } catch (error) {
      /*  debugPrint(error.toString());
      Utils.showSnackBar(
          'Erro',
          error.toString(),
          const Icon(
            FontAwesomeIcons.triangleExclamation,
            color: Colors.red,
          ),
          Colors.red);*/
    }
    return user;
  }
  */

  static Future<bool> saveShoppingList(Map<String, dynamic> list) async {
    try {
      database.ref("shoppinglists").child(list["uuid"]).set(list).then((value) {
        database
            .ref("user-lists")
            .child(list["userUUID"])
            .child(list["uuid"])
            .set(list["uuid"]);
      }).onError((error, stackTrace) {
        /* debugPrint(error.toString());*/
      });

      return true;
    } catch (error) {
      return false;
    }
  }

  static Future<List<Map>> getShoppingList(String userUUID) async {
    List<Map> list = [];
    try {
      var data = await database.ref("user-lists").child(userUUID).get();
      var keys = (data.value as Map).keys.toList();

      devLog(keys);
      for (int i = 0; i < keys.length; i++) {
        var shoppinglist =
            await database.ref("shoppinglists").child(keys[i]).get();

        list.add(shoppinglist.value as Map);
      }
      devLog("Lista");
      devLog(list);

      return list;
    } catch (error) {
      devLog(error);

      return list;
    }
  }

  static Future<bool> updateShoppingList(Map<String, dynamic> list) async {
    try {
      database
          .ref("shoppinglists")
          .child(list["uuid"])
          .update(list)
          .then((value) {});

      return true;
    } catch (error) {
      return false;
    }
  }

  static Future<bool> deleteShoppingList(Map<String, dynamic> list) async {
    try {
      database.ref("shoppinglists").child(list["uuid"]).remove().then((value) {
        database
            .ref("user-lists")
            .child(list["userUUID"])
            .child(list["uuid"])
            .remove();
      });

      return true;
    } catch (error) {
      return false;
    }
  }

  static Future<bool> addItemShoppingList(Map<String, dynamic> item) async {
    try {
      database
          .ref("shoppinglists")
          .child(item["listUUID"])
          .child("items")
          .child(item["uuid"])
          .set(item)
          .then((value) {})
          .onError((error, stackTrace) {
        /*debugPrint(error.toString());*/
      });

      return true;
    } catch (error) {
      return false;
    }
  }

  static Future<bool> updateItemShoppingList(Map<String, dynamic> item) async {
    try {
      database
          .ref("shoppinglists")
          .child(item["listUUID"])
          .child("items")
          .child(item["uuid"])
          .update(item)
          .then((value) {})
          .onError((error, stackTrace) {
        /*debugPrint(error.toString());*/
      });

      return true;
    } catch (error) {
      return false;
    }
  }

  static Future<bool> deleteItemShoppingList(Map<String, dynamic> item) async {
    try {
      database
          .ref("shoppinglists")
          .child(item["listUUID"])
          .child("items")
          .child(item["uuid"])
          .remove()
          .then((value) {})
          .onError((error, stackTrace) {
        /*debugPrint(error.toString());*/
      });

      return true;
    } catch (error) {
      return false;
    }
  }
}
