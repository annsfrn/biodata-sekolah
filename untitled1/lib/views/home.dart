import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:biodata/models/api.dart';
import 'package:biodata/models/msiswa.dart';
// import 'package:biodata/details.dart';

class Home extends StatefulWidget {
  const Home({super.key, required String title});
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  late Future<List<SiswaModel>> sw;
  final formkey = GlobalKey<HomeState>();

  TextEditingController nisController = new TextEditingController();
  TextEditingController namController = new TextEditingController();
  TextEditingController tpController = new TextEditingController();
  TextEditingController tgController = new TextEditingController();
  TextEditingController kelaminController = new TextEditingController();
  TextEditingController agamaController = new TextEditingController();
  TextEditingController alamatController = new TextEditingController();


  Future createSw() async {
    return await http.post(
      Uri.parse(BaseUrl.tambah),
      body: {
        "nis": nisController.text,
        "nama": namController.text,
        "tplahir": tpController.text,
        "tglahir": tgController.text,
        "kelamin": kelaminController.text,
        "agama": agamaController.text,
        "alamat": alamatController.text,
      }
    );
  }

  void _onConfirm(context) async {
    http.Response response = await createSw();
    final data = json.decode(response.body);
    if (data['success']) {
      Navigator.of(context)
          .pushAndRemoveUntil('/' as Route, (Route<dynamic> route) => false);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: const Text("tambah siswa"),
        centerTitle: true,
        backgroundColor: Colors.blue,
    ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.green,
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          onPressed: () {
              if (kDebugMode) {
                print("OK SUKSES");
              }
              _onConfirm(context);
            },
          child: const Text("Simpan")
        ),
      ),
      body: Container(
      ),
    );
  }
}