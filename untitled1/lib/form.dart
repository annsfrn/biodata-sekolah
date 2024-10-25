import 'dart:convert';

// import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:biodata/models/api.dart';
import 'package:http/http.dart' as http;

class BiodataForm extends StatefulWidget {
  const BiodataForm({super.key, required GlobalKey<FormState> formKey, required TextEditingController namaController, required TextEditingController tplahirController, required TextEditingController tglahirController, required TextEditingController agamaController, required TextEditingController kelaminController, required TextEditingController alamatController, required TextEditingController emailController});

  @override
  State<StatefulWidget> createState() => _BiodataFormState();
}

class _BiodataFormState extends State<BiodataForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // TextEditingController
  final TextEditingController namaController = TextEditingController();
  final TextEditingController tplahirController = TextEditingController();
  final TextEditingController tglahirController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String? _kelamin;
  String? _agama;

  Future createSw() async {
    return await http.post(
      Uri.parse(BaseUrl.tambah),
      body: {
        "nama": namaController.text,
        "tempat_lahir": tplahirController.text,
        "tanggal_lahir": _dateController.text,
        "agama": _agama ?? '',
        "kelamin": _kelamin ?? '',
        "alamat": alamatController.text,
        "email": emailController.text,
      },
    );
  }

  void _onConfirm(context) async {
    http.Response response = await createSw();
    final data = json.decode(response.body);
    if (data['success']) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    } else {
      // Tampilkan pesan error jika diperlukan
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan data')),
      );
    }
  }

  final List<String> _status = ['', 'Laki-laki', 'Perempuan'];
  final List<String> items = [
    "",
    "Islam",
    "Katholik",
    "Protestan",
    "Hindu",
    "Budha",
    "Konghucu",
    "Kepercayaan"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Data'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.green,
            textStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              _onConfirm(context);
            }
          },
          child: const Text('Simpan'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey, // Pasang key di Form
          child: SingleChildScrollView(
            child: Column(
              children: [
                tbNama(),
                const SizedBox(height: 16),
                tbTempat(),
                const SizedBox(height: 16),
                tbTanggal(),
                const SizedBox(height: 16),
                tbAgama(),
                const SizedBox(height: 16),
                tbKelamin(),
                const SizedBox(height: 16),
                tbAlamat(),
                const SizedBox(height: 16),
                tbEmail(),
                const SizedBox(height: 20.0),
                // Hapus tombol simpan dari sini jika menggunakan tombol di bottomNavigationBar
                // tbSimpan(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget tbNama() {
    return TextFormField(
      controller: namaController, // Hubungkan controller
      decoration: InputDecoration(
        labelText: 'Nama',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Masukkkan Nama Anda...';
        }
        return null;
      },
    );
  }

  Widget tbTempat() {
    return TextFormField(
      controller: tplahirController, // Hubungkan controller
      decoration: InputDecoration(
        labelText: 'Tempat Lahir',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Masukkkan Kota Kelahiran Anda...';
        }
        return null;
      },
    );
  }

  Widget tbTanggal() {
    return TextFormField(
      readOnly: true,
      controller: _dateController,
      decoration: InputDecoration(
        labelText: 'Tanggal Lahir',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(DateTime.now().year - 150),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Silahkan Pilih Tanggal Lahir Anda...';
        }
        return null;
      },
    );
  }

  Widget tbAlamat() {
    return TextFormField(
      controller: alamatController, // Hubungkan controller
      decoration: InputDecoration(
        labelText: 'Alamat',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      maxLines: 3,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Masukkkan Alamat Anda...';
        }
        return null;
      },
    );
  }

  Widget tbEmail() {
    return TextFormField(
      controller: emailController, // Hubungkan controller
      decoration: InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || !value.contains('@')) {
          return 'Masukkkan Email yang Valid...';
        }
        return null;
      },
    );
  }

  Widget tbKelamin() {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      value: _kelamin,
      hint: const Text(
        'Jenis Kelamin',
        style: TextStyle(fontSize: 14),
      ),
      onChanged: (String? newValue) {
        setState(() {
          _kelamin = newValue;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Silahkan Pilih Jenis Kelamin Anda...';
        }
        return null;
      },
      items: _status.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget tbAgama() {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      decoration: InputDecoration(
        labelText: 'Agama',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      value: _agama,
      hint: const Text(
        'Pilih Agama',
        style: TextStyle(fontSize: 14),
      ),
      onChanged: (String? newValue) {
        setState(() {
          _agama = newValue;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Silahkan Pilih Agama';
        }
        return null;
      },
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: const TextStyle(fontSize: 14, color: Colors.blue),
          ),
        );
      }).toList(),
    );
  }
}