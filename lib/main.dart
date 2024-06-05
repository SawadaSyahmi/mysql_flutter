import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter MySQL CRUD',
      home: UserScreen(),
    );
  }
}

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final String apiUrl = "http://127.0.0.1:3000";  // Change this to your server's IP/hostname
  List users = [];
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  fetchUsers() async {
    var response = await http.get(Uri.parse('$apiUrl/read'));
    if (response.statusCode == 200) {
      setState(() {
        users = json.decode(response.body);
      });
    }
  }

  addUser() async {
    var response = await http.post(
      Uri.parse('$apiUrl/create'),
      body: {
        "name": nameController.text,
        "email": emailController.text,
      },
    );
    if (response.statusCode == 200) {
      fetchUsers();
    }
  }

  updateUser(int id) async {
    var response = await http.post(
      Uri.parse('$apiUrl/update'),
      body: {
        "id": id.toString(),
        "name": nameController.text,
        "email": emailController.text,
      },
    );
    if (response.statusCode == 200) {
      fetchUsers();
    }
  }

  deleteUser(int id) async {
    var response = await http.post(
      Uri.parse('$apiUrl/delete'),
      body: {
        "id": id.toString(),
      },
    );
    if (response.statusCode == 200) {
      fetchUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter MySQL CRUD'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                ElevatedButton(
                  onPressed: addUser,
                  child: Text('Add User'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                var user = users[index];
                return ListTile(
                  title: Text(user['name']),
                  subtitle: Text(user['email']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          nameController.text = user['name'];
                          emailController.text = user['email'];
                          updateUser(user['id']);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => deleteUser(user['id']),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
