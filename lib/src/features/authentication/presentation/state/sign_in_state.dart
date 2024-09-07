import 'package:flutter_riverpod/flutter_riverpod.dart';

final notVisibleProvider = StateProvider<bool>((ref) => false);

final emailProvider = StateProvider<String>((ref) => "");
final hasValidEmailProvider = StateProvider<bool>((ref) => false);

final passwordProvider = StateProvider<String>((ref) => "");
final hasValidPasswordProvider = StateProvider<bool>((ref) => false);