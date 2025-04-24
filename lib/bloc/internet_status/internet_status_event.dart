part of 'internet_status_bloc.dart';

abstract class InternetStatusEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Internet restored event
class InternetStatusBackEvent extends InternetStatusEvent {}

// Internet lost event
class InternetStatusLostEvent extends InternetStatusEvent {}

// Manually check internet event
class CheckInternetEvent extends InternetStatusEvent {}

