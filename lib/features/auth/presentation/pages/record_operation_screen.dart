
import 'package:flutter/material.dart';
import 'package:flinder_app/l10n/app_localizations.dart';
import 'add_worker.dart';
import 'delete_worker.dart';
import 'worker_list_page.dart';



class RecordOperationsScreen extends StatelessWidget {
  const RecordOperationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return DefaultTabController(
      length: 3, 
      child: Directionality(
        textDirection: isArabic ? TextDirection.ltr : Directionality.of(context),
        child: Scaffold(
          appBar: AppBar(
            title: Directionality(
              textDirection: isArabic ? TextDirection.rtl : Directionality.of(context),
              child: Text(AppLocalizations.of(context)?.recordOperations ?? 'Record Operations'),
            ),
            leading: IconButton(
              onPressed: ()=> Navigator.pop(context), 
              icon: const Icon(Icons.arrow_back)
            ),
            bottom: TabBar(
              tabs: [
                Tab(text: AppLocalizations.of(context)?.workerList ?? 'Worker List'),
                Tab(text: AppLocalizations.of(context)?.newRecord ?? 'New Record'),
                Tab(text: AppLocalizations.of(context)?.deleteRecord ?? 'Delete Record'),
              ],
            ),
          ),
          
          body: TabBarView(
            physics: const BouncingScrollPhysics(),
            children: [
              _wrapForSupportedLocales(context, const WorkerListPage()), 
              _wrapForSupportedLocales(context, const AddWorkerPage()),
              _wrapForSupportedLocales(context, const DeleteWorkerPage()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _wrapForSupportedLocales(BuildContext context, Widget child) {
    final code = Localizations.localeOf(context).languageCode;
    const supported = ['tr', 'en'];
    final locale = supported.contains(code) ? Localizations.localeOf(context) : const Locale('en');
    return Localizations.override(context: context, locale: locale, child: child);
  }
}
