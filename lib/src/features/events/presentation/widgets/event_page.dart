import 'package:flutter/material.dart';

import '../../doamain/models/event.dart';

class EventPage extends StatelessWidget {
  final bool isAdmin;
  final Event event;
  
  const EventPage({
    required this.isAdmin,
    required this.event,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}