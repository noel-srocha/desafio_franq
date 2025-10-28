import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState());

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(ThemeState.prefKey) ?? false;
    emit(state.copyWith(isDark: isDark));
  }

  Future<void> toggle() async {
    final newValue = !state.isDark;
    emit(state.copyWith(isDark: newValue));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(ThemeState.prefKey, newValue);
  }
}