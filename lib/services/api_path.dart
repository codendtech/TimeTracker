class APIPath {
  static String createJobPath(String uid, String jodId) =>
      'users/$uid/jobs/$jodId';
  static String readJobsPath(String uid) => 'users/$uid/jobs';
}
