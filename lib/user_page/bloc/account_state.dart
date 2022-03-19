part of 'account_bloc.dart';

abstract class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object> get props => [];
}

class AccountInitial extends AccountState {}

class AccountSuccessState extends AccountState {
  var data;

  AccountSuccessState({required this.data});
  @override
  List<Object> get props => [data];
}

class AccountErrorState extends AccountState {
  final String errorMsg;

  AccountErrorState({required this.errorMsg});
  @override
  List<String> get props => [errorMsg];
}
