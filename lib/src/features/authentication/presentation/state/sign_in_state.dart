import 'package:flutter_riverpod/flutter_riverpod.dart';

final emailProvider = StateProvider<String>((ref) => "");
final hasValidEmailProvider = StateProvider<bool>((ref) => false);

final notVisibleProvider = StateProvider<bool>((ref) => true);

final passwordProvider = StateProvider<String>((ref) => "");
final hasValidPasswordProvider = StateProvider<bool>((ref) => false);