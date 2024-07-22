import 'package:flutter/material.dart';
import 'upload_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<String> plants = ['Plant 1', 'Plant 2', 'Plant 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plant Care'),
        backgroundColor: Colors.green.shade700,
      ),
      body: ListView.builder(
        itemCount: plants.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(plants[index]),
              trailing: IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UploadScreen()),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
