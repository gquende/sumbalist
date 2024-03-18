import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../utils/utils.dart';

class FirebaseService {
  static final FirebaseDatabase database = FirebaseDatabase.instance;
  static final FirebaseAuth auth = FirebaseAuth.instance;

  static Future<Map<String, dynamic>?> loginAccount(
      String username, String password) async {
    Map<String, dynamic>? userData;

    try {
      auth
          .signInWithEmailAndPassword(
        email: username,
        password: password,
      )
          .then((value) {
        String node =
            value.user!.email!.substring(0, value.user!.email!.indexOf('@'));
        database.ref('users').child(node).onValue.listen((event) {
          userData = {
            "uuid": value.user?.uid ?? '',
            "username": node,
            "name": event.snapshot.child('name').value.toString(),
            "surname": event.snapshot.child('surname').value.toString(),
            "email": event.snapshot.child('email').value.toString(),
            "phoneNumber": event.snapshot.child('phone').value.toString()
          };
        }).onError((error, stackTrace) {
          //EM caso de erro
          debugPrint(error.toString());
        });
      }).onError((error, stackTrace) {
        //Erro de FirebaseBase
        debugPrint(error.toString());
      });
    } catch (e) {
      //Erro genérico

      debugPrint(e.toString());
    }

    return userData;
  }

  static Future<UserCredential> createAccount(Map<String, dynamic> map) async {
    var credentials = await auth.createUserWithEmailAndPassword(
        email: map["email"], password: map["password"]);
    var email = map["email"] as String;
    var node = email.substring(0, email.indexOf('@'));

    database
        .ref("users")
        .child(node)
        .set({
          "uuid": credentials.user?.uid ?? '',
          "username": node,
          "name": map["name"],
          "surname": map["surname"],
          "email": map["email"],
          "phone": map["phone"]
        })
        .then((value) => null)
        .onError((error, stackTrace) {
          debugPrint(error.toString());
        });

    return credentials;
  }

  /*

      static Future<UserCredential> login(String username, String password) async {
        var data = await auth.signInWithEmailAndPassword(
            email: username, password: password);
      }

  */

  static Future<User?> loginWithGoogle() async {
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
              Utils.showSnackBar(
                  'Login',
                  'Successfully Login',
                  const Icon(
                    FontAwesomeIcons.triangleExclamation,
                    color: Colors.red,
                  ),
                  Colors.green);

              user = value.user;
            }).onError((error, stackTrace) {
              Utils.showSnackBar(
                  'Erro',
                  error.toString(),
                  const Icon(
                    FontAwesomeIcons.triangleExclamation,
                    color: Colors.red,
                  ),
                  Colors.red);
              return;
            });
          }).onError((error, stackTrace) {
            debugPrint(error.toString());
            Utils.showSnackBar(
                'Erro',
                error.toString(),
                const Icon(
                  FontAwesomeIcons.triangleExclamation,
                  color: Colors.red,
                ),
                Colors.red);
          });
        }
      }).onError((error, stackTrace) {
        debugPrint(error.toString());
        Utils.showSnackBar(
            'Erro',
            error.toString(),
            const Icon(
              FontAwesomeIcons.triangleExclamation,
              color: Colors.red,
            ),
            Colors.red);
      });
    } catch (error) {
      debugPrint(error.toString());
      Utils.showSnackBar(
          'Erro',
          error.toString(),
          const Icon(
            FontAwesomeIcons.triangleExclamation,
            color: Colors.red,
          ),
          Colors.red);
    }

    return user;
  }
}
