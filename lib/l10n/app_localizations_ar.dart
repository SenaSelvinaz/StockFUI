// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get addNewWorker => 'Add New Account';

  @override
  String get workers => 'Workers';

  @override
  String get searchByPhone => 'Search by phone number';

  @override
  String get managerPanel => 'لوحة المدير';

  @override
  String get foremanPanel => 'Foreman Panel';

  @override
  String get profileTitle => 'صفحتي';

  @override
  String get appSettings => 'إعدادات التطبيق';

  @override
  String get languageSelection => 'اختيار اللغة';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get home => 'الصفحة الرئيسية';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get role => 'الدور';

  @override
  String get namePlaceholder => 'الاسم الكامل (مستخدم مثال)';

  @override
  String languageChanged(Object language) {
    return 'تم تغيير اللغة: $language';
  }

  @override
  String get workerPanel => 'Worker Panel';

  @override
  String get recordOperations => 'تسجيل الموظف';

  @override
  String get stockControl => 'مراقبة المخزون';

  @override
  String get jobTracking => 'متابعة العمل';

  @override
  String get operationReports => 'تقارير العمليات';

  @override
  String comingSoon(Object title) {
    return 'سيتم إضافة $title قريبًا.';
  }

  @override
  String get workerList => 'قائمة الموظفين';

  @override
  String get newRecord => 'سجل جديد';

  @override
  String get deleteRecord => 'حذف السجل';

  @override
  String get enterWorkerName => 'أدخل الاسم الكامل للموظف';

  @override
  String get status => 'الحالة';

  @override
  String get enterPhone => 'أدخل رقم هاتف الموظف';

  @override
  String get phoneHint => '5xx xxx xx xx';

  @override
  String get save => 'حفظ';

  @override
  String get fillAllFields => 'يرجى ملء جميع الحقول';

  @override
  String get invalidPhone => 'رقم هاتف غير صالح. مثال: 5xx xxx xx xx';

  @override
  String get savingWorker => 'جاري حفظ الموظف...';

  @override
  String get confirmSaveTitle => 'تأكيد الحفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get ok => 'موافق';

  @override
  String get searchHint => 'ابحث بالهاتف/الاسم 5xx xxxxxxx';

  @override
  String get noRecords => 'لم يتم العثور على سجلات';

  @override
  String get deleting => 'جاري حذف السجل...';

  @override
  String get deleteConfirmTitle => 'تأكيد الحذف';

  @override
  String get deleteConfirmMessage => 'هل أنت متأكد أنك تريد حذف هذا الشخص؟';

  @override
  String get yesDelete => 'نعم، احذف';

  @override
  String get recordDeleted => 'تم حذف الموظف بنجاح.';

  @override
  String get errorOccurred => 'حدث خطأ';

  @override
  String get onlyAdmins => 'Only admins can perform this action.';

  @override
  String get statusManagement => 'الإدارة';

  @override
  String get statusPurchasing => 'قسم الشراء';

  @override
  String get statusProductPlanning => 'مسؤول تخطيط المنتج';

  @override
  String get statusCraftsman => 'حرفي';

  @override
  String get statusForeman => 'رئيس العمال';

  @override
  String get cutting => 'تقطيع';

  @override
  String get drilling => 'حفر';

  @override
  String get packaging => 'تغليف';

  @override
  String get welding => 'لحام';

  @override
  String get workerNameLabel => 'الاسم';
}
