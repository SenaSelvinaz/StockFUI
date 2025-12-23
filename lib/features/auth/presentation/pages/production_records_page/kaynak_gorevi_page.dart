import 'package:flutter/material.dart';

class KaynakGoreviPage extends StatefulWidget {
  const KaynakGoreviPage({super.key});

  @override
  State<KaynakGoreviPage> createState() => _KaynakGoreviPageState();
}

class _KaynakGoreviPageState extends State<KaynakGoreviPage> {
  static const Color primaryBlue = Color.fromARGB(255, 11, 26, 94);

  final TextEditingController kaynakController = TextEditingController();
  final TextEditingController fireController = TextEditingController();

  String? selectedFireReason;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: primaryBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Kaynak Görevi",
          style: TextStyle(
            color: primaryBlue,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 ÜRÜN BİLGİSİ
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: primaryBlue, width: 1.2),
              ),
              padding: const EdgeInsets.all(16),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sipariş: PROD-00451",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text("Ürün: Alüminyum Profil 75cm"),
                  SizedBox(height: 4),
                  Text("Toplam Adet: 250"),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _label("Kaynak Yapılan Adet"),
            _numberField(kaynakController),

            const SizedBox(height: 16),

            _label("Fire Adet"),
            _numberField(fireController),

            const SizedBox(height: 16),

            _label("Fire Sebebi (Zorunlu)"),
            _dropdownField(),

            const SizedBox(height: 32),

            /// 🔹 KAYDI OLUŞTUR
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _handleSubmit,
                child: const Text(
                  "Kaydı Oluştur",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // ---------------- UI HELPERS ----------------

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _numberField(TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: "0",
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryBlue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryBlue, width: 1.6),
        ),
      ),
    );
  }

  Widget _dropdownField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryBlue, width: 1.2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedFireReason,
          hint: const Text("Fire Sebebi Seçin"),
          isExpanded: true,
          items: const [
            DropdownMenuItem(
              value: "Kaynak Hatası",
              child: Text("Kaynak Hatası"),
            ),
            DropdownMenuItem(
              value: "Ölçü Hatası",
              child: Text("Ölçü Hatası"),
            ),
          ],
          onChanged: (value) {
            setState(() {
              selectedFireReason = value;
            });
          },
        ),
      ),
    );
  }

  // ---------------- LOGIC ----------------

  void _handleSubmit() {
    if (kaynakController.text.isEmpty ||
        fireController.text.isEmpty ||
        selectedFireReason == null) {
      _showErrorDialog();
    } else {
      _showConfirmDialog();
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Eksik Bilgi"),
        content: const Text(
          "Kaydı oluşturmak için tüm alanları doldurmanız gerekmektedir.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tamam"),
          ),
        ],
      ),
    );
  }

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Kaydı Onayla"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Sipariş: PROD-00451"),
            const Text("Ürün: Alüminyum Profil 75cm"),
            const SizedBox(height: 8),
            Text("Kaynaklanan Adet: ${kaynakController.text}"),
            Text("Fire Adet: ${fireController.text}"),
            Text("Fire Sebebi: $selectedFireReason"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Vazgeç"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryBlue),
            onPressed: () {
              Navigator.pop(context);
              _saveRecord();
            },
            child: const Text("Onayla"),
          ),
        ],
      ),
    );
  }

  void _saveRecord() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Paketleme kaydı başarıyla oluşturuldu."),
        backgroundColor: Colors.green,
      ),
    );

    kaynakController.clear();
    fireController.clear();
    setState(() {
      selectedFireReason = null;
    });
  }
}
