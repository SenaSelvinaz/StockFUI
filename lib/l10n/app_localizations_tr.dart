// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get addNewWorker => 'Add New Account';

  @override
  String get workers => 'Workers';

  @override
  String get searchByPhone => 'Search by phone number';

  @override
  String get managerPanel => 'Yönetici Paneli';

  @override
  String get foremanPanel => 'Foreman Panel';

  @override
  String get profileTitle => 'Profilim';

  @override
  String get appSettings => 'Uygulama Ayarları';

  @override
  String get languageSelection => 'Dil Seçimi';

  @override
  String get logout => 'Çıkış Yap';

  @override
  String get home => 'Ana Sayfa';

  @override
  String get profile => 'Profil';

  @override
  String get phoneNumber => 'Telefon Numarası';

  @override
  String get role => 'Yetki Düzeyi';

  @override
  String get namePlaceholder => 'Ad Soyad (Örnek Kullanıcı)';

  @override
  String languageChanged(Object language) {
    return 'Dil değiştirildi: $language';
  }

  @override
  String get workerPanel => 'Worker Panel';

  @override
  String get recordOperations => 'Çalışan Kayıt İşlemleri';

  @override
  String get stockControl => 'Stok Takip';

  @override
  String get jobTracking => 'İş Takip';

  @override
  String get operationReports => 'İşlem Raporları';

  @override
  String comingSoon(Object title) {
    return '$title yakında eklenecektir.';
  }

  @override
  String get workerList => 'Çalışan Listesi';

  @override
  String get newRecord => 'Yeni Kayıt';

  @override
  String get deleteRecord => 'Kayıt Sil';

  @override
  String get enterWorkerName => 'Çalışanın adını ve soyadını girin';

  @override
  String get status => 'Statü';

  @override
  String get enterPhone => 'Çalışanın telefon numarasını giriniz';

  @override
  String get phoneHint => '5xx xxx xx xx';

  @override
  String get save => 'Kaydet';

  @override
  String get fillAllFields => 'Lütfen tüm alanları doldurun';

  @override
  String get invalidPhone => 'Geçersiz telefon numarası. Örn: 5xx xxx xx xx';

  @override
  String get savingWorker => 'Çalışan kaydediliyor...';

  @override
  String get confirmSaveTitle => 'Kayıt Onayı';

  @override
  String get cancel => 'İptal';

  @override
  String get ok => 'Tamam';

  @override
  String get searchHint => 'Telefon numarası/ad soyad ile ara 5xx xxxxxxx';

  @override
  String get noRecords => 'Kayıt bulunamadı';

  @override
  String get deleting => 'Kayıt siliniyor...';

  @override
  String get deleteConfirmTitle => 'Silme Onayı';

  @override
  String get deleteConfirmMessage =>
      'Bu kişiyi silmek istediğinize emin misiniz?';

  @override
  String get yesDelete => 'Evet, Sil';

  @override
  String get recordDeleted => 'Çalışan başarıyla silindi.';

  @override
  String get errorOccurred => 'Bir hata oluştu';

  @override
  String get onlyAdmins => 'Bu işlemleri sadece yönetici yapabilir.';

  @override
  String get statusManagement => 'Yönetim';

  @override
  String get statusPurchasing => 'Satın Alma Birimi';

  @override
  String get statusProductPlanning => 'Ürün Planlama Sorumlusu';

  @override
  String get statusCraftsman => 'Usta';

  @override
  String get statusForeman => 'Ustabaşı';

  @override
  String get cutting => 'Kesim';

  @override
  String get drilling => 'Delikleme';

  @override
  String get packaging => 'Paketleme';

  @override
  String get welding => 'Kaynak';

  @override
  String get workerNameLabel => 'İsim';
}
