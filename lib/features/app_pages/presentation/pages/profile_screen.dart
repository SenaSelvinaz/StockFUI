import 'package:flutter/material.dart';
import 'package:flinder_app/l10n/app_localizations.dart';
import 'package:flinder_app/core/localization/locale_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flinder_app/core/services/dio_service.dart';

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
        if (localeCode == 'en') {
          _selectedLanguage = 'English';
        } else if (localeCode == 'ar') {
          _selectedLanguage = 'العربية';
        } else {
          _selectedLanguage = 'Türkçe';
        }
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
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: _buildProfileContent(context),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ================== PROFILE CARD ==================
        Card(
          elevation: 2,
          color: const Color.fromARGB(255, 11, 26, 94),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder(
              future: DioService.getUser(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }

                final user = snapshot.data as Map<String, dynamic>;

                return Center(
                child:Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      child: Icon(Icons.person, size: 45),
                    ),
                    const SizedBox(height: 15),
                    Text(
  user['name'] ?? 'Kullanıcı',
  textAlign: TextAlign.center,
  style: const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  ),
),
const SizedBox(height: 6),
Text(
  _mapRole(user['role']),
  textAlign: TextAlign.center,
  style: const TextStyle(
    fontSize: 14,
    color: Colors.white70,
  ),
),

                  ],
                ),
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 30),

        /// ================== SETTINGS TITLE ==================
        Text(
          AppLocalizations.of(context)?.appSettings ?? 'App Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey.shade700,
          ),
        ),
        const Divider(height: 10),

        /// ================== LANGUAGE CARD ==================
        Card(
          elevation: 2,
          color: const Color.fromARGB(255, 11, 26, 94),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.language,
                        color: Colors.white, size: 24),
                    const SizedBox(width: 15),
                    Text(
                      AppLocalizations.of(context)?.languageSelection ??
                          'Language',
                      style:
                          const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
                DropdownButton<String>(
                  value: _selectedLanguage,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  style: const TextStyle(color: Colors.white),
                  underline: Container(),
                  selectedItemBuilder: (context) {
                    return _languages
                        .map(
                          (value) => Center(
                            child: Text(
                              value,
                              style:
                                  const TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                        .toList();
                  },
                  onChanged: (String? newValue) {
                    if (newValue == null) return;

                    setState(() => _selectedLanguage = newValue);

                    Locale locale = const Locale('tr');
                    if (newValue == 'English') {
                      locale = const Locale('en');
                    } else if (newValue == 'العربية') {
                      locale = const Locale('ar');
                    }

                    context.read<LocaleCubit>().setLocale(locale);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)
                                  ?.languageChanged(newValue) ??
                              'Language changed: $newValue',
                        ),
                      ),
                    );
                  },
                  items: _languages.map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          style:
                              const TextStyle(color: Colors.black)),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 30),

        /// ================== LOGOUT ==================
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.logout),
            label: Text(
              AppLocalizations.of(context)?.logout ?? 'Logout',
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red.shade700,
              side: BorderSide(color: Colors.red.shade400),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              await DioService.logout();
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ),
      ],
    );
  }

  /// ================== ROLE MAPPER ==================
  String _mapRole(String? role) {
    switch (role) {
      case 'yonetici':
        return 'Yönetici';
      case 'satin_alma':
        return 'Satın Alma';
      case 'uretim_planlama':
        return 'Üretim Planlama';
      case 'ustabasi':
        return 'Ustabaşı';
      case 'usta':
        return 'Usta';
      default:
        return 'Kullanıcı';
    }
  }
}
