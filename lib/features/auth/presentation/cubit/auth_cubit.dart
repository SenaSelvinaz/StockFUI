import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/worker.dart';
import '../../data/workers_data.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  void loadWorkers() {
    emit(AuthLoading());
    try {
      emit(AuthLoaded(workersList)); // workersList, data klasöründeki liste
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void addWorker(Worker worker) {
    workersList.add(worker);
    emit(AuthLoaded(List.from(workersList))); // Listeyi kopyala ve emit et
  }

  void deleteWorker(int index) {
    workersList.removeAt(index);
    emit(AuthLoaded(List.from(workersList)));
  }
}
