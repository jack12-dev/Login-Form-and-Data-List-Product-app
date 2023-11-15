import 'package:flutter/material.dart';
import 'Login_Form/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/home': (context) => const MyHomePage(
              title: '',
            ),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> _allUsers = [
    {"id": 1, "name": "Mouse 7200 DPI", "harga": 89},
    {"id": 2, "name": "Mousepad", "harga": 20},
    {"id": 3, "name": "Keyboard", "harga": 299},
    {"id": 4, "name": "Charger Laptop", "harga": 99},
    {"id": 5, "name": "Headset Bluetooth", "harga": 120},
    {"id": 6, "name": "Headphone", "harga": 169},
    {"id": 7, "name": "Facecam", "harga": 200},
    {"id": 8, "name": "Microphone", "harga": 125},
    {"id": 9, "name": "Headset Kabel Gaming", "harga": 99},
    {"id": 10, "name": "Satu Set Pancingan", "harga": 150},
  ];

  List<Map<String, dynamic>> _foundUsers = [];
  @override
  initState() {
    _foundUsers = _allUsers;
    super.initState();
  }

  void _deleteUser(int userId) {
    setState(() {
      _allUsers.removeWhere((user) => user["id"] == userId);
      _foundUsers.removeWhere((user) => user["id"] == userId);
    });
  }

  void _navigateToAddUser() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddUserScreen()),
    );

    if (result != null) {
      setState(() {
        int newId = _allUsers.length + 1;
        Map<String, dynamic> newUser = {
          "id": newId,
          "name": result['name'],
          "harga": result['harga'],
        };

        _allUsers.add(newUser);
        _foundUsers = List.from(_allUsers);
      });
    }
  }

  TextEditingController _nameController = TextEditingController();
  TextEditingController _hargaController = TextEditingController();

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allUsers;
    } else {
      results = _allUsers
          .where((user) =>
              user["name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundUsers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 20),
                TextField(
                  controller: _nameController,
                  onChanged: (value) => _runFilter(value),
                  decoration: InputDecoration(
                    labelText: 'Search',
                    suffixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: _foundUsers.length,
                    itemBuilder: (context, index) => Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        _deleteUser(_foundUsers[index]["id"]);
                      },
                      background: Container(
                        color: Colors.red,
                        child: Icon(Icons.delete),
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 16),
                      ),
                      child: Card(
                        key: ValueKey(_foundUsers[index]["id"]),
                        color: Colors.white,
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          leading: Text(
                            _foundUsers[index]["id"].toString(),
                            style: const TextStyle(
                                fontSize: 24, color: Colors.black),
                          ),
                          title: Text(
                            _foundUsers[index]['name'],
                            style: TextStyle(color: Colors.black),
                          ),
                          subtitle: Text(
                            'Harga: Rp. ${_foundUsers[index]["harga"].toString()}.000',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 16.0,
              right: 16.0,
              child: InkWell(
                onTap: () {
                  _navigateToAddUser(); // Fungsi untuk menambahkan pengguna
                },
                child: Container(
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        Colors.orange, // Sesuaikan warna sesuai kebutuhan Anda
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors
                        .white, // Sesuaikan warna ikon sesuai kebutuhan Anda
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddUserScreen extends StatefulWidget {
  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _hargaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Produk"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _hargaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Harga'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'name': _nameController.text,
                  'harga': _hargaController.text,
                });
              },
              child: Text("Tambah Produk"),
            ),
          ],
        ),
      ),
    );
  }
}
