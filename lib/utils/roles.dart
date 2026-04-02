enum UserRole {
  superAdmin,
  programManager,
  regionalCoordinator,
  mEOfficer,
  qcVerifier,
  trainer,
  enumerator,
  communicationOfficer,
  enterpriseUser,
}

String roleToString(UserRole role) {
  switch (role) {
    case UserRole.superAdmin:
      return 'super_admin';
    case UserRole.programManager:
      return 'program_manager';
    case UserRole.regionalCoordinator:
      return 'regional_coordinator';
    case UserRole.mEOfficer:
      return 'm_e_officer';
    case UserRole.qcVerifier:
      return 'qc_verifier';
    case UserRole.trainer:
      return 'trainer';
    case UserRole.enumerator:
      return 'enumerator';
    case UserRole.communicationOfficer:
      return 'communication_officer';
    case UserRole.enterpriseUser:
      return 'enterprise_user';
  }
}

UserRole stringToRole(String role) {
  switch (role) {
    case 'super_admin':
      return UserRole.superAdmin;
    case 'program_manager':
      return UserRole.programManager;
    case 'regional_coordinator':
      return UserRole.regionalCoordinator;
    case 'm_e_officer':
      return UserRole.mEOfficer;
    case 'qc_verifier':
      return UserRole.qcVerifier;
    case 'trainer':
      return UserRole.trainer;
    case 'enumerator':
      return UserRole.enumerator;
    case 'communication_officer':
      return UserRole.communicationOfficer;
    case 'enterprise_user':
      return UserRole.enterpriseUser;
    default:
      return UserRole.enumerator;
  }
}
