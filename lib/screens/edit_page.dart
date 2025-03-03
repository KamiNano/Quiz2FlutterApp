import 'package:flutter/material.dart';
import '../models/smartphone.dart';
import 'package:intl/intl.dart';

class EditPage extends StatefulWidget {
  final Smartphone smartphone;

  EditPage({required this.smartphone});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TextEditingController brandController;
  late TextEditingController modelController;
  late TextEditingController priceController;
  DateTime? selectedDate;
  String status = "ยังไม่ขาย";

  @override
  void initState() {
    super.initState();
    brandController = TextEditingController(text: widget.smartphone.brand);
    modelController = TextEditingController(text: widget.smartphone.model);
    priceController = TextEditingController(text: widget.smartphone.price.toString());
    selectedDate = widget.smartphone.purchaseDate;
    status = widget.smartphone.status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("แก้ไขข้อมูล")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: brandController,
              decoration: InputDecoration(labelText: "ยี่ห้อ"),
            ),
            TextField(
              controller: modelController,
              decoration: InputDecoration(labelText: "รุ่น"),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "ราคา"),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text("วันที่ขาย: "),
                Text(
                  selectedDate == null
                      ? "ยังไม่ได้เลือก"
                      : DateFormat('yyyy-MM-dd').format(selectedDate!),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                ),
              ],
            ),
            DropdownButton<String>(
              value: status,
              onChanged: (newValue) {
                setState(() {
                  status = newValue!;
                });
              },
              items: ["ขายแล้ว", "ยังไม่ขาย"].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
        ElevatedButton(
  onPressed: () {
    Navigator.pop(
      context,
      Smartphone(
        id: widget.smartphone.id,
        brand: brandController.text,
        model: modelController.text,
        price: double.tryParse(priceController.text) ?? 0,
        purchaseDate: selectedDate,
        status: status,
      ),
    );
  },
  child: Text("บันทึกการแก้ไข"),
)
          ],
        ),
      ),
    );
  }
}
