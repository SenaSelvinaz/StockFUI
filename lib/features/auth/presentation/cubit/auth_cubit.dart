import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';
import '../../domain/entities/worker.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  List<Worker> allWorkers = [];
  List<Worker> filteredWorkers = [];
  //Worker currentUser;



  void loadWorkers(List<Worker> list) {
    allWorkers = list;
    filteredWorkers = List.from(allWorkers);
    emit(AuthLoaded(filteredWorkers));
  }

  // Telefon ile arama
  void searchWorker(String query) {
    // Arama metnini küçük harfe çevirip boşlukları trim'liyoruz.
    final searchQuery = query.trim().toLowerCase();

    if (searchQuery.isEmpty) {
      // Eğer arama kutusu boşsa, tüm çalışanları göster.
      filteredWorkers = List.from(allWorkers);
    } else {
      // 1. Filtreleme Mantığı: Başlangıcı Eşleştirme (Starts With)
      filteredWorkers = allWorkers.where((worker) {
        // Telefon numarasını temizleyip küçük harfe çevirme
        final phone = worker.phone.replaceAll(' ', '').toLowerCase();
        
        // Varsayım: Worker nesnesinin 'name' veya 'fullName' alanı var.
        final name = worker.name.toLowerCase(); 

        // Koşul: Çalışanın telefon numarası VEYA adı arama metniyle başlıyor mu?
        return phone.startsWith(searchQuery) || 
               name.startsWith(searchQuery);

      }).toList();
    }
    
    // Filtrelenmiş listeyi yayınla
    emit(AuthLoaded(filteredWorkers));
  }

  // Yeni işçi ekleme
  void addWorker(Worker worker) {
    allWorkers.add(worker);
    filteredWorkers = List.from(allWorkers);
    emit(AuthLoaded(filteredWorkers));
  }

  // Silme
  void deleteWorker(String phone) {
    allWorkers.removeWhere((w) => w.phone == phone);
    filteredWorkers.removeWhere((w) => w.phone == phone);
    emit(AuthLoaded(filteredWorkers));
  }


  void updateWorker(Worker updatedWorker, String originalPhone) {
  final index = allWorkers.indexWhere((w) => w.phone == originalPhone);

  if (index != -1) { 
    allWorkers[index] = updatedWorker;
    filteredWorkers = List.from(allWorkers); 
    
    emit(AuthLoaded(filteredWorkers));
  }
}
}
