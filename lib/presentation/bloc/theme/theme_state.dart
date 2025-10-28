part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  static const String prefKey = 'is_dark_theme';
  final bool isDark;

  const ThemeState({this.isDark = false});

  ThemeState copyWith({bool? isDark}) => ThemeState(isDark: isDark ?? this.isDark);

  @override
  List<Object?> get props => [isDark];
}
