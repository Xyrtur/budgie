import 'package:flutter_bloc/flutter_bloc.dart';

/**
 * List of cubits:
 * 
 * CurrentSelectedPageCubit
 * SpendingViewSwapCubit
 */

enum PageSelected { Overview, TripPlanning, BudgetPlanning, UserSettings }

class NavbarCubit extends Cubit<PageSelected> {
  final PageSelected page;
  NavbarCubit(this.page) : super(page);

  void changePage({required PageSelected page}) {
    emit(page);
  }
}
