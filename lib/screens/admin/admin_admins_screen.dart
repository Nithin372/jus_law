import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AdminAdminsScreen extends StatefulWidget {
  AdminAdminsScreen({Key? key}) : super(key: key);

  @override
  State<AdminAdminsScreen> createState() => _AdminAdminsScreenState();
}

class _AdminAdminsScreenState extends State<AdminAdminsScreen> {
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Users")),
        body: StreamBuilder<QuerySnapshot>(
            stream:
                db.collection("users").where("role", isEqualTo: 2).snapshots(),
            builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SpinKitDancingSquare(
                  color: Colors.blueGrey,
                  size: 50.0,
                );
              }
              if (!snapshot.hasData) {
                return const Text("No Dat found");
              }
              if (snapshot.hasError) {
                return const Text("There was an Error");
              }

              if (snapshot.data!.docs.length < 1) {
                return const Padding(
                  padding: EdgeInsets.all(28.0),
                  child: Text("No data found"),
                );
              }

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
                child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var item = snapshot.data!.docs[index];
                      return Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: item.get('photo') == ""
                                              ? ClipRRect(
                                                  child: Image.asset(
                                                      "assets/images/avatar.png",
                                                      width: 100,
                                                      height: 100,
                                                      fit: BoxFit.cover),
                                                  borderRadius:
                                                      BorderRadius.circular(10))
                                              : ClipRRect(
                                                  child: Image.network(
                                                      item.get("photo"),
                                                      width: 100,
                                                      height: 100,
                                                      fit: BoxFit.cover),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10))),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(item.get('name'),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5!
                                                  .copyWith(
                                                      color: Colors.blue)),
                                        ],
                                      )),
                                      SizedBox(
                                          width: 40,
                                          child: AppPopupMenu(
                                            menuItems: const [
                                              PopupMenuItem(
                                                value: 3,
                                                child: Text('Delete'),
                                              ),
                                            ],
                                            // initialValue: 2,
                                            onSelected: (int value) {
                                              // print("selected");
                                              // print(item.id);

                                              if (value == 3) {
                                                db
                                                    .collection("users")
                                                    .doc(snapshot
                                                        .data!.docs[index].id)
                                                    .delete();
                                              }
                                            },
                                            icon:
                                                const Icon(Icons.more_vert_outlined),
                                          ))
                                    ]),
                              ),
                            ),
                          ));
                    }),
              );
            })));
  }
}
