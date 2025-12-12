import 'package:flutter/material.dart';


class StockControlPage extends StatefulWidget {
  const StockControlPage({super.key});

  @override
  State<StockControlPage> createState() => _StockControlPageState();
}
class _StockControlPageState extends State<StockControlPage> {
  @override
  Widget build (BuildContext context){
    return Scaffold(
      backgroundColor: const Color(0xfff4f4f4),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Stok Tablosu Gelecek",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}