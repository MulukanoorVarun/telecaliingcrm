import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
part 'internet_status_event.dart';
part 'internet_status_state.dart';

class InternetStatusBloc extends Bloc<InternetStatusEvent, InternetStatusState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  InternetStatusBloc() : super(InternetStatusInitial()) {
    // ✅ Subscribe to connectivity changes (handling List<ConnectivityResult>)
    _subscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      _handleConnectivityChange(results);
    });

    on<InternetStatusBackEvent>(
            (event, emit) => emit(InternetStatusBackState('Internet is back!')));

    on<InternetStatusLostEvent>(
            (event, emit) => emit(InternetStatusLostState('No internet connection')));

    on<CheckInternetEvent>((event, emit) async {
      // ✅ Manually check internet connection
      List<ConnectivityResult> results = await _connectivity.checkConnectivity();
      _handleConnectivityChange(results);
    });
  }

  // ✅ Handle multiple connectivity results
  void _handleConnectivityChange(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.mobile) || results.contains(ConnectivityResult.wifi)) {
      add(InternetStatusBackEvent());
    } else {
      add(InternetStatusLostEvent());
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel(); // ✅ Prevent memory leaks
    return super.close();
  }
}


