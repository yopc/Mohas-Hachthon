import 'coach_model.dart';
import 'security_model.dart';

class CoachWithSecurity {
  final CoachModel coach;
  final SecurityModel? security;

  CoachWithSecurity({
    required this.coach,
    this.security,
  });

  factory CoachWithSecurity.fromSeparate({
    required CoachModel coach,
    SecurityModel? security,
  }) {
    return CoachWithSecurity(
      coach: coach,
      security: security,
    );
  }
}