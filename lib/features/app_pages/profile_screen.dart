import 'package:flutter/material.dart';
import 'main_ui.dart';
import 'package:flinder_app/l10n/app_localizations.dart';
import 'package:flinder_app/core/localization/locale_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _selectedLanguage = 'Türkçe';
  final List<String> _languages = ['Türkçe', 'English', 'العربية'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final localeCode = context.read<LocaleCubit>().state.languageCode;
      setState(() {
        if (localeCode == 'en') _selectedLanguage = 'English';
        else if (localeCode == 'ar') _selectedLanguage = 'العربية';
        else _selectedLanguage = 'Türkçe';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.profileTitle ?? 'Profil',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading: false,
      ),


      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: _buildProfileContent(context),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: AppLocalizations.of(context)?.home ?? 'Home',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: AppLocalizations.of(context)?.profile ?? 'Profile',
          ),
        ],
        currentIndex: 1, // PROFIL sayfasında olduğumuzun göstergesi
        selectedItemColor: const Color.fromARGB(255, 37, 38, 68),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MainUI()),
            );
          }
        },
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 2,
          color: const Color.fromARGB(255, 11, 26, 94),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: CircleAvatar(
                    radius: 40,
                    child: Icon(Icons.person, size: 45),
                  ),
                ),
                const SizedBox(height: 15),
                Center(
                  child: Text(
                    AppLocalizations.of(context)?.namePlaceholder ?? 'Ad Soyad (Örnek Kullanıcı)',
                    style: const TextStyle(fontSize: 20, 
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
                  ),
                ),
                const Divider(height: 30),
                _buildDetailRow(Icons.phone, AppLocalizations.of(context)?.phoneNumber ?? 'Phone Number', "******"),
                _buildDetailRow(Icons.badge, AppLocalizations.of(context)?.role ?? 'Role', "Yönetici"),
              ],
            ),
          ),
        ),

        const SizedBox(height: 25),

        Text(
          AppLocalizations.of(context)?.appSettings ?? 'App Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey.shade700,
          ),
        ),
        const Divider(height: 10),

        Card(
          elevation: 2,
          color: const Color.fromARGB(255, 11, 26, 94),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    const Icon(Icons.language, color: Color.fromARGB(255, 255, 255, 255), size: 24),
                    const SizedBox(width: 15),
                    Text(AppLocalizations.of(context)?.languageSelection ?? 'Language', style: 
                    const TextStyle(fontSize: 16, color: Colors.white),),
                  ],
                ),
                DropdownButton<String>(
                  value: _selectedLanguage,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  style: const TextStyle(color: Colors.white),
                  underline: Container(),
                  selectedItemBuilder: (BuildContext context) {
                    return _languages.map((value) => Center(child: Text(value, style: const TextStyle(color: Colors.white)))).toList();
                  },
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedLanguage = newValue!;
                      // map selection to locale codes
                      Locale locale = const Locale('tr');
                      if (newValue == 'English') locale = const Locale('en');
                      if (newValue == 'العربية') locale = const Locale('ar');
                      context.read<LocaleCubit>().setLocale(locale);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(AppLocalizations.of(context)?.languageChanged(newValue) ?? 'Language changed: $newValue')),
                      );
                    });
                  },
                  items: _languages.map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: const TextStyle(color: Colors.black)),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 25),

        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.logout),
            label: Text(AppLocalizations.of(context)?.logout ?? 'Logout'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red.shade700,
              side: BorderSide(color: Colors.red.shade400),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.white),
          const SizedBox(width: 10),
          SizedBox(
            width: 100,
            child: Text("$label:",
                style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(fontWeight: FontWeight.w400, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
