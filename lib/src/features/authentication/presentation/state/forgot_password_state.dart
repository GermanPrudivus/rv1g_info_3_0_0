import 'package:flutter_riverpod/flutter_riverpod.dart';

final hasValidEmailProvider = StateProvider<bool>((ref) => true);
final emailProvider = StateProvider<String>((ref) => "");