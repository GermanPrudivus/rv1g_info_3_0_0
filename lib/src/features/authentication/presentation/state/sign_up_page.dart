import 'package:flutter_riverpod/flutter_riverpod.dart';

final imagePathProvider = StateProvider<String>((ref) => "");

final hasValidEmailProvider = StateProvider<bool>((ref) => true);
final emailProvider = StateProvider<String>((ref) => "");

final hasFullNameProvider = StateProvider<bool>((ref) => true);
final fullNameProvider = StateProvider<String>((ref) => "");

final dropDownValueProvider = StateProvider<String>((ref) => "Izvēlies savu klasi");

final notVisibleProvider = StateProvider<bool>((ref) => true);

final hasValidPasswordProvider = StateProvider<bool>((ref) => true);
final passwordProvider = StateProvider<String>((ref) => "");

final hasValidRepeatPasswordProvider = StateProvider<bool>((ref) => true);
final repeatPasswordProvider = StateProvider<String>((ref) => "");