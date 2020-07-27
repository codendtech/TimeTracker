class APIPath {
  static String job(String uid, String jodId) => 'users/$uid/jobs/$jodId';
  static String jobsPath(String uid) => 'users/$uid/jobs';
}
