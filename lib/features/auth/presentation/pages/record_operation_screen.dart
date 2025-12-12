
import 'package:flutter/material.dart';
import 'add_worker.dart';
import 'delete_worker.dart';
import 'worker_list_page.dart';



class RecordOperationsScreen extends StatelessWidget {
  const RecordOperationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, 
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Kayıt İşlemleri"),
          leading: IconButton(
            onPressed: ()=> Navigator.pop(context), 
            icon: const Icon(Icons.arrow_back)
          ),
          bottom: const TabBar(
            tabs: [
            Tab(text: "Çalışan Listesi"),
            Tab(text: "Yeni Kayıt"),
            Tab(text:"Kayıt Sil"),
            ],
          ),
        ),
        
        body:Expanded(
          child: TabBarView(
          physics: BouncingScrollPhysics(),
          children: [
            WorkerListPage(), 
            AddWorkerPage(),
            DeleteWorkerPage(),
          ],
        )
        ) 
      ),
    );
  }
}
