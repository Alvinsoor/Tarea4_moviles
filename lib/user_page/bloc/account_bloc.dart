import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc() : super(AccountInitial()) {
    on<AccountEvent>(_updater);
  }
  Future<Response?> getData() async {
    try {
      final Response response = await get(Uri.parse(
          "https://api.sheety.co/ec50f0a82608f6ba2dd8fc24e6f65668/tarea4/bank"));

      print("response get");

      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void _updater(AccountEvent event, Emitter emit) async {
    Response? response = await getData();

    if (response != null) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        data = data["bank"];
        print(data);

        emit(AccountSuccessState(data: data));
      } else {
        emit(AccountErrorState(errorMsg: "Couldnt obtain data"));
      }
    } else {
      emit(AccountErrorState(errorMsg: "Null data"));
    }
  }
}
