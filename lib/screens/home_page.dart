import 'package:flutter/material.dart';
import '../models/smartphone.dart';
import '../db/database_helper.dart';
import 'add_page.dart';
import 'edit_page.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Smartphone> smartphones = [];
  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadSmartphones();
  }

  Future<void> _loadSmartphones() async {
    final phones = await dbHelper.getSmartphones();
    setState(() {
      smartphones = phones;
    });
  }

  void _addNewSmartphone(Smartphone phone) async {
    int id = await dbHelper.insertSmartphone(phone);
    setState(() {
      smartphones.add(
        Smartphone(
          id: id,
          brand: phone.brand,
          model: phone.model,
          price: phone.price,
          purchaseDate: phone.purchaseDate,
          status: phone.status,
        ),
      );
    });
  }

  void _updateSmartphone(int index, Smartphone updatedPhone) async {
    final id = smartphones[index].id;
    if (id != null) {
      await dbHelper.updateSmartphone(id, updatedPhone);
      _loadSmartphones();
    }
  }

  void _deleteSmartphone(int index) async {
    final id = smartphones[index].id;
    if (id != null) {
      await dbHelper.deleteSmartphone(id);
      setState(() {
        smartphones.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("รายการการวางจำหน่ายสมาร์ทโฟนแต่ละรุ่น"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body:
          smartphones.isEmpty
              ? Center(
                child: Text(
                  "ไม่มีข้อมูล",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )
              : ListView.builder(
                padding: EdgeInsets.all(12),
                itemCount: smartphones.length,
                itemBuilder: (context, index) {
                  final phone = smartphones[index];
                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(12),
                      title: Text(
                        "${phone.brand} - ${phone.model}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5),
                          Text(
                            "💰 ราคา: ${phone.price.toStringAsFixed(2)} บาท",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (phone.purchaseDate != null)
                            Text(
                              "📅 วันที่ขาย: ${DateFormat('yyyy-MM-dd').format(phone.purchaseDate!)}",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          Text(
                            "📌 สถานะ: ${phone.status}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () async {
                              final updatedPhone = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => EditPage(smartphone: phone),
                                ),
                              );
                              if (updatedPhone != null) {
                                _updateSmartphone(index, updatedPhone);
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteSmartphone(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
        onPressed: () async {
          final newPhone = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPage()),
          );
          if (newPhone != null) {
            _addNewSmartphone(newPhone);
          }
        },
      ),
    );
  }
}
