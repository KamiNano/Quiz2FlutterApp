import 'package:flutter/material.dart';
import '../models/smartphone.dart';
import 'package:intl/intl.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TextEditingController brandController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  
  DateTime? selectedDate;
  String selectedStatus = "ยังไม่ขาย"; // ค่าเริ่มต้นของ Dropdown

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _saveData() {
    String brand = brandController.text.trim();
    String model = modelController.text.trim();
    double? price = double.tryParse(priceController.text.trim());

    if (brand.isEmpty || model.isEmpty || price == null || selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("กรุณากรอกข้อมูลให้ครบ")),
      );
      return;
    }

    final newSmartphone = Smartphone(
      brand: brand,
      model: model,
      price: price,
      status: selectedStatus,
      purchaseDate: selectedDate,
    );

    Navigator.pop(context, newSmartphone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("เพิ่มโทรศัพท์ใหม่")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: brandController,
              decoration: InputDecoration(labelText: "ยี่ห้อโทรศัพท์"),
            ),
            TextField(
              controller: modelController,
              decoration: InputDecoration(labelText: "รุ่นโทรศัพท์"),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "ราคา"),
            ),
            SizedBox(height: 10),
            Text("เลือกวันที่ขาย:"),
            Row(
              children: [
                Text(selectedDate == null
                    ? "ยังไม่ได้เลือกวันที่"
                    : DateFormat('yyyy-MM-dd').format(selectedDate!)),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text("สถานะ:"),
            DropdownButton<String>(
              value: selectedStatus,
              items: ["ขายแล้ว", "ยังไม่ขาย"].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedStatus = newValue!;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveData,
              child: Text("บันทึก"),
            ),
          ],
        ),
      ),
    );
  }
}
