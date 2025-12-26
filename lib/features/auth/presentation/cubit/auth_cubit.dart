import 'package:flinder_app/features/auth/data/models/current_user.dart';
import 'package:flinder_app/core/services/dio_service.dart'; 
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';
import '../../domain/entities/worker.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  CurrentUser? me;

Future<void> fetchMe() async {
  emit(AuthMeLoading());

  try {
    final response = await DioService.get("/api/me");

    final Map<String, dynamic> map =
        Map<String, dynamic>.from(response.data['data']);

    final user = CurrentUser.fromMap(map);
    me = user;

    emit(AuthMeLoaded(user));
  } catch (e) {
    emit(AuthError(e.toString()));
  }
}


  List<Worker> allWorkers = [];
  List<Worker> filteredWorkers = [];
  //Worker currentUser;

  // Whether current user is an admin (controls visibility of worker management actions)
  bool isAdmin = true;

  void setAdmin(bool value) {
    isAdmin = value;
    // no state emission needed for now; UI reads the flag directly
  }



  void loadWorkers(List<Worker> list) {
    allWorkers = list;
    filteredWorkers = List.from(allWorkers);
    emit(AuthLoaded(filteredWorkers));
  }

  // Telefon ile arama
  void searchWorker(String query) {
    final searchQuery = query.trim().toLowerCase();

    if (searchQuery.isEmpty) {

      filteredWorkers = List.from(allWorkers);
    } else {

      filteredWorkers = allWorkers.where((worker) {

        final phone = worker.phone.replaceAll(' ', '').toLowerCase();
        final name = worker.name.toLowerCase(); 

        return phone.startsWith(searchQuery) || 
               name.startsWith(searchQuery);

      }).toList();
    }
    
    emit(AuthLoaded(filteredWorkers));
  }

  // Yeni işçi ekleme
  void addWorker(Worker worker) {
    allWorkers.add(worker);
    filteredWorkers = List.from(allWorkers);
    emit(AuthLoaded(filteredWorkers));
  }

  // Silme

  String _normalizePhone(String phone) {
  return phone
      //.replaceAll('+', '')
      .replaceAll(' ', '');
      //.replaceFirst('90', '');
}

  /*void deleteWorker(String phone) {
    allWorkers.removeWhere((w) => w.phone == phone);
    filteredWorkers.removeWhere((w) => w.phone == phone);
    emit(AuthLoaded(filteredWorkers));
  }*/

  void deleteWorker(String phone) {
  final normalized = _normalizePhone(phone);

  allWorkers.removeWhere(
    (w) => _normalizePhone(w.phone) == normalized,
  );

  filteredWorkers.removeWhere(
    (w) => _normalizePhone(w.phone) == normalized,
  );

  emit(AuthLoaded(filteredWorkers));
}



  void updateWorker(Worker updatedWorker, String originalPhone) {
  final index = allWorkers.indexWhere(
    (w) => w.phone == originalPhone || w.phone == updatedWorker.phone
  );

  if (index != -1) { 
    allWorkers[index] = updatedWorker;
    filteredWorkers = List.from(allWorkers); 
    
    emit(AuthLoaded(filteredWorkers));
  }
 }


}
