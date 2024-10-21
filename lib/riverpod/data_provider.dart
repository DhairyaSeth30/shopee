import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../modal/product_modal.dart';
import 'base_state.dart';
import 'data_notifier.dart';

// Create a StateNotifierProvider for ProductNotifier
final productNotifierProvider =
StateNotifierProvider<ProductNotifier, DataState<List<Product>>>(
      (ref) => ProductNotifier(),
);
