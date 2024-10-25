import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';

class BiodataForm extends StatefulWidget {
  @override
  _BiodataFormState createState() => _BiodataFormState();
}

class _BiodataFormState extends State<BiodataForm> {
  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>(); //A key for managing the form
  String _name = ''; // Variable to store the entered name
  String _email = ''; // Variable to store the entered email
  String _alamat = '';
  String _tplahir = '';
  String? _kelamin;
  String _agama = '';
  String? selectedValue;
  DateTime tglahir = DateTime.now();

  void _submitForm() {
    // Check if the form is valid
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Save the form data
      // You can perform actions with the form data here and extract the
      print('Name: $_name'); // Print the name
      print('Email: $_email'); // Print the email
      print('Kelamin: $_kelamin');
      print('Tempat Lahir: $_tplahir');
      print('Tanggal Lahir: $tglahir');
      print('Agama: $_agama');
      print('Alamat: $_alamat');
      print('Agama: $selectedValue');
    }
  }

  final _dateController = TextEditingController();
  final _status = ["Laki-Laki", "Perempuan"];
  final List<String> items = [
    "Islam",
    "Katholik",
    "Protestan",
    "Hindu",
    "Budha",
    "Khonghucu",
    "Kepercayaan",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Biodata'),
      ),
      body: Form(
        key: _formKey, // Associate the form key with this Form widget
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              tbNama(),
              tbTempat(),
              tbTanggal(),
              tbAgama(),
              tbKelamin(),
              tbAlamat(),
              tbEmail(),
              SizedBox(height: 20.0),
              tblSimpan(),
            ],
          ),
        ),
      ),
    );
  }

  tbNama() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Nama',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ), // Label for the name field
      validator: (value) {
        // Validation function for the name field
        if (value!.isEmpty) {
          return 'Masukkan Nama Anda.'; // Return an error message;
        }
        return null; // Return null if the name is valid
      },
      onSaved: (value) {
        _name = value!; // Save the entered name
      },
    );
  }

  tbTempat() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Tempat Lahir',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ), // Label for the name field
      validator: (value) {
        // Validation function for the name field
        if (value!.isEmpty) {
          return 'Masukkan Kota Kelahiran Anda.'; // Return an error message;
        }
        return null; // Return null if the name is valid
      },
      onSaved: (value) {
        _tplahir = value!; // Save the entered name
      },
    );
  }

  tbTanggal() {
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
        await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(DateTime.now().year - 150),
          lastDate: DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day),
        ).then((tglahir) {
          if (tglahir != null) {
            _dateController.text = DateFormat('yyyy-MM-dd').format(tglahir);
          }
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter date.';
        }
        return null;
      },
    );
  }

  tbAlamat() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Alamat',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ), // Label for the name field
      validator: (value) {
        // Validation function for the name field
        if (value!.isEmpty) {
          return 'Silahkan Masukkan Alamat Anda.'; // Return an error
        }
        return null; // Return null if the name is valid
      },
      onSaved: (value) {
        _alamat = value!;
      },
    );
  }

  tbEmail() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ), // Label for the name field
      validator: (value) {
        if (value!.contains('@')) {
          return 'Silahkan Masukkan Email Anda.'; // Return an error
        }
        return null; // Return null if the name is valid
      },
      onSaved: (value) {
        _email = value!; // Save the entered email
      },
    );
  }

  tbKelamin() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        // labelText: 'Jenis Kelamin',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      value: _kelamin,
      hint: Text('Jenis Kelamin'),
      onChanged: (String? newValue) {
        setState(() {
          _kelamin = newValue!;
        });
      },
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Silahkan Pilih Jenis Kelamin Anda.';
        }
        return null;
      },
      items: _status.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  tbAgama() {
    return DropdownButtonFormField2<String>(
      isExpanded: true,
      decoration: InputDecoration(
        labelText: "Agama",
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      hint: const Text(
        'Pilih Agama',
        style: TextStyle(fontSize: 14),
      ),
      items: items
          .map((item) => DropdownMenuItem<String>(
        value: item,
        child: Text(
          item,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.blue,
          ),
        ),
      ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Silahkan Pilih Agama.';
        }
        return null;
      },
      onChanged: (value) {
        // Do something when selected item is changed.
      },
      onSaved: (value) {
        selectedValue = value.toString();
        _agama = value.toString();
      },
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.only(right: 8),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 24,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  tblSimpan() {
    return ElevatedButton(
        onPressed: _submitForm,
        // Call the _submitForm function when the button is pressed
        child: Text('Submit'), //Text on the button
        );
    }
}
