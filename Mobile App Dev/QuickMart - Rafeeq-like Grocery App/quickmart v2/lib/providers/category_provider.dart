import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickmart/models/product.dart';
import 'package:quickmart/repos/system_repository.dart';

class CategoryProvider extends Notifier<List<bool>> {
  Set<ProductCategory> categories = {};
  List<bool> isCheckedList = List.filled(6, false);
  Set<String> categoriesToFilter = {};
  final SystemRepository _systemRepository = SystemRepository();

  @override
  List<bool> build() {
    state = isCheckedList;
    initailizeCategories();
    return state;
  }

  initailizeCategories() async {
    categories = await _systemRepository.loadProductCategories();
  }

  updateCheckedCategories(index, bool value) {
    isCheckedList[index] = value;
    state = isCheckedList;
  }
}

final categoryNotifierProvider =
    NotifierProvider<CategoryProvider, List<bool>>(() => CategoryProvider());
