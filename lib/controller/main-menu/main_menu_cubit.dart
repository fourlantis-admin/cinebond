import 'package:cinebond/utils/storage/store_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainMenuCubit extends Cubit<int> {
  StoreManager storeManager = StoreManager();
  MainMenuCubit() : super(0);

  void changeTab(int index) {
    if (state == index) return;
    emit(index);
  }
  void checkInfo() async {
    final value = await storeManager.getUser();
    final valueToken = await storeManager.getToken();
  }
}
