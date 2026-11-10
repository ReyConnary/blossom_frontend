// No authentication exists yet — this is a temporary stand-in so pages
// have a PersonnelID to work with. Replace with real session/auth state
// once login is built.
//
// Matches the seed data: 3 = Budi (Pekerja), 2 = Siti (Manager).
class CurrentUser {
  static int? personnelId;
  static String fullName = '';
}
