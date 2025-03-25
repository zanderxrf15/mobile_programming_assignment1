import 'package:flutter/material.dart';
import 'package:quan_ly_benh_nhan_sqlite/data/DatabaseHelper.dart'; // Import your DatabaseHelper class
import 'package:quan_ly_benh_nhan_sqlite/models/Patient.dart';
import 'package:quan_ly_benh_nhan_sqlite/screens/login_screen.dart';
import 'package:quan_ly_benh_nhan_sqlite/screens/manager_patients.dart';
import 'package:quan_ly_benh_nhan_sqlite/screens/manager_record.dart';
import 'package:quan_ly_benh_nhan_sqlite/screens/setting.dart';

import '../main.dart'; // Import your Patient class

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Patient> patients;
  List<String> notes = [];

  @override
  void initState() {
    super.initState();
    loadPatients();
  }

  Future<void> loadPatients() async {
    DatabaseHelper dbHelper = DatabaseHelper.instance;
    patients = await dbHelper.getAllPatients();
    setState(() {}); // Refresh the UI after loading patients
  }

  void showNoteDialog({int? index}) {
    TextEditingController noteController = TextEditingController(
        text: index != null ? notes[index] : "");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(index == null ? 'Note' : 'Edit Note'),
          content: TextField(
            controller: noteController,
            decoration: const InputDecoration(hintText: 'Enter your note'),
            maxLines: 3,
          ),
          actions: <Widget>[
            if (index != null)
              TextButton(
                child: const Text('Delete'),
                onPressed: () {
                  setState(() {
                    notes.removeAt(index);
                  });
                  Navigator.of(context).pop();
                },
              ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                setState(() {
                  if (index == null) {
                    notes.add(noteController.text);
                  } else {
                    notes[index] = noteController.text;
                  }
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Trang chủ'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Quản lý bệnh nhân'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManagerPatients()),
                );
              },
            ),
            ListTile(
              title: const Text('Quản lý bệnh án'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManagerRecord()),
                );
              },
            ),
            ListTile(
              title: const Text('Cài đặt'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingScreen()),
                );
              },
            ),
            ListTile(
              title: const Text('Đăng xuất'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          if (notes.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: notes.asMap().entries.map((entry) {
                  int idx = entry.key;
                  String note = entry.value;
                  return Card(
                    child: ListTile(
                      title: Text(note),
                      onTap: () => showNoteDialog(index: idx),
                    ),
                  );
                }).toList(),
              ),
            ),
          Expanded(
            child: patients.isNotEmpty
                ? ListView.builder(
              itemCount: patients.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(patients[index].name),
                  subtitle: Text(
                      'Age: ${patients[index].age}, Gender: ${patients[index].gender}'),
                );
              },
            )
                : Center(
              child: Text('No patients available'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showNoteDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
