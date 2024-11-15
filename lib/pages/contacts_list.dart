// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sumbalist/controllers/contacts_controller.dart';
//
// class ContactsList extends StatefulWidget {
//   const ContactsList({super.key});
//
//   @override
//   State<ContactsList> createState() => _ContactsListState();
// }
//
// class _ContactsListState extends State<ContactsList> {
//   ContactsController controller = ContactsController();
//
//   @override
//   void initState() {
//     super.initState();
//     controller.getContacts(context);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text(
//           "Lista de contactos",
//           style: TextStyle(color: Colors.black),
//         ),
//       ),
//       body: SafeArea(
//         child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Obx(() {
//               return Column(
//                 children: controller.contacts.value.map((e) {
//                   return Text(e.displayName);
//                 }).toList(),
//               );
//             })),
//       ),
//     );
//   }
// }
