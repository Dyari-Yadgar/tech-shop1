import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tech_shop/Data/ItemData.dart';
import 'package:tech_shop/model/itemmodel.dart';
import 'package:tech_shop/pages/itemview.dart';
import 'package:tech_shop/WidgetStyle.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  int selecti = -1;
  List typefiltter = ['هەمووی', 'نرخ', 'قەبارە'];
  int selectedindextype = 0;
  List<itemModel> data = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              const SizedBox(width: 15),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    color: WidgetStyle.primary,
                    borderRadius: BorderRadius.circular(17)),
                child: IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        context: context,
                        builder: (context) => StatefulBuilder(
                            builder: (context, setState1) => filter(setState1)),
                      );
                    },
                    icon: const Icon(
                      Icons.menu_rounded,
                      size: 30,
                      color: Colors.white,
                    )),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'search',
                      hintTextDirection: TextDirection.rtl,
                      suffixIcon: const Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                      filled: true,
                      fillColor: const Color(0xffF1F1F1),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                              width: 0, color: Color(0xffF1F1F1))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                              width: 0, color: Color(0xffF1F1F1))),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 35,
            child: FutureBuilder(
                future: ref.child('sharika').get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    return ListView(
                      reverse: true,
                      scrollDirection: Axis.horizontal,
                      children: List.generate(
                        ItemData.sharikaNames().length,
                        (index) => Container(
                          padding: const EdgeInsets.only(right: 5),
                          child: ChoiceChip(
                            label: Text(
                              ItemData.sharikaNames()[index],
                              style: TextStyle(color: WidgetStyle.primary),
                            ),
                            selected: selecti == index ? true : false,
                            backgroundColor: WidgetStyle.white,
                            selectedColor: WidgetStyle.white,
                            side: BorderSide(
                                color: selecti == index
                                    ? WidgetStyle.primary
                                    : WidgetStyle.white),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            onSelected: (value) {
                              setState(() {
                                if (index == selecti) {
                                  selecti = -1;
                                } else {
                                  selecti = index;
                                }
                              });
                            },
                          ),
                        ),
                      ),
                    );
                  }
                }),
          ),
          const SizedBox(height: 20),
          FutureBuilder(
              future: getData(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No items found'));
                }

                data = snapshot.data!.docs
                    .map((e) => itemModel.fromJson(e.data()))
                    .toList();

                return Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 30,
                    mainAxisSpacing: 30,
                    childAspectRatio: 0.75,
                    children: data.map((item) => itemCard(item)).toList(),
                  ),
                );
              }),
        ],
      ),
    ));
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getData() async {
    try {
      return await FirebaseFirestore.instance.collection('items').get();
    } catch (e) {
      print("Error fetching data: $e");
      rethrow;
    }
  }

  Widget itemCard(itemModel item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => ItemView(item: item),
            ));
      },
      child: Column(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              child: Container(
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    image: DecorationImage(
                        image: AssetImage(item.image), fit: BoxFit.cover)),
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(25)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 4),
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(25))),
                      height: 40,
                      width: double.infinity,
                      child: Text(
                        item.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Text('${item.price}\$: نرخ '),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(item.storage), const Text(' : قەبارە')],
          )
        ],
      ),
    );
  }

  Widget filter(setState1) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
          color: WidgetStyle.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(40))),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {},
                  child: const Text(
                    'گەرانەوە',
                    style: TextStyle(color: Colors.black),
                  )),
              const Expanded(child: SizedBox()),
              const Text(
                'فلتەر',
                style: TextStyle(fontSize: 25),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text('ڕیزکردن بە پێی '),
          const SizedBox(height: 10),
          SizedBox(
            height: 40,
            child: ListView(
                reverse: true,
                scrollDirection: Axis.horizontal,
                children: List.generate(
                    typefiltter.length,
                    (index) => InkWell(
                          onTap: () {
                            setState(() {
                              setState1(() {
                                selectedindextype = index;
                              });
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(
                                left: index == typefiltter.length - 1 ? 0 : 10),
                            width: 100,
                            decoration: BoxDecoration(
                                color: selectedindextype == index
                                    ? Colors.grey[900]
                                    : WidgetStyle.white,
                                border: Border.all(
                                    width: 1.5,
                                    color:
                                        const Color.fromARGB(255, 23, 22, 22)),
                                borderRadius: BorderRadius.circular(12)),
                            child: Text(
                              '${typefiltter[index]}',
                              style: TextStyle(
                                  color: selectedindextype == index
                                      ? WidgetStyle.white
                                      : Colors.grey[900],
                                  fontSize: 17),
                            ),
                          ),
                        ))),
          ),
          const SizedBox(height: 20),
          const Text('شەریکە'),
          const SizedBox(height: 10),
          SizedBox(
            height: 40,
            child: ListView(
                reverse: true,
                scrollDirection: Axis.horizontal,
                children: List.generate(
                    ItemData.sharikaNames().length,
                    (index) => InkWell(
                          onTap: () {
                            setState(() {
                              setState1(() {
                                if (selecti == index) {
                                  selecti = -1;
                                } else {
                                  selecti = index;
                                }
                              });
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(
                                left: index == typefiltter.length - 1 ? 0 : 10),
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                                color: selecti == index
                                    ? Colors.grey[900]
                                    : WidgetStyle.white,
                                border: Border.all(
                                    width: 1.5,
                                    color:
                                        const Color.fromARGB(255, 23, 22, 22)),
                                borderRadius: BorderRadius.circular(12)),
                            child: Text(
                              ItemData.sharikaNames()[index],
                              style: TextStyle(
                                  color: selecti == index
                                      ? WidgetStyle.white
                                      : Colors.grey[900],
                                  fontSize: 17),
                            ),
                          ),
                        ))),
          )
        ],
      ),
    );
  }
}
