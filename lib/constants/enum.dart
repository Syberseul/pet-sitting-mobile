enum DogSize {
  xSmall, small, medium, large, xLarge;
}

enum Gender {
  male, female, unknown
}

enum UserRole {
  admin, developer, dogOwner, visitor
}

final Map<int, UserRole> userRoleList = {
  100: UserRole.admin,
  90: UserRole.developer,
  10: UserRole.dogOwner,
  0: UserRole.visitor
};