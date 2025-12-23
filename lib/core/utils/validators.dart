class Validators {
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Telefon numarası gereklidir';
    }
    
    // Sadece rakam kontrolü
    final cleanPhone = value.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (cleanPhone.length != 10) {
      return 'Geçerli bir telefon numarası giriniz';
    }
    
    if (!cleanPhone.startsWith('5')) {
      return 'Telefon numarası 5 ile başlamalıdır';
    }
    
    return null;
  }
  
  static String? validateOTP(String? value) {
    if (value == null || value.isEmpty) {
      return 'Doğrulama kodu gereklidir';
    }
    
    if (value.length != 6) {
      return '6 haneli kod giriniz';
    }
    
    return null;
  }
}
