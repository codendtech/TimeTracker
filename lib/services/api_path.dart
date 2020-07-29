class APIPath {
  static String createJobPath(String uid, String jobId) =>
      'users/$uid/jobs/$jobId';
  static String deleteJobPath(String uid, String jobId) =>
      'users/$uid/jobs/$jobId';
  static String readJobsPath(String uid) => 'users/$uid/jobs';
  static String entry(String uid, String entryId) =>
      'users/$uid/entries/$entryId';
  static String entries(String uid) => 'users/$uid/entries';
}
