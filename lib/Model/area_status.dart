enum AreaStatus {
  notRegistered,
  pending,
  approved,
}

AreaStatus areaStatusFromString(String? status) {
  switch (status) {
    case 'pending':
      return AreaStatus.pending;
    case 'approved':
      return AreaStatus.approved;
    default:
      return AreaStatus.notRegistered;
  }
}

String areaStatusToString(AreaStatus status) {
  switch (status) {
    case AreaStatus.pending:
      return 'pending';
    case AreaStatus.approved:
      return 'approved';
    default:
      return 'not_registered';
  }
}