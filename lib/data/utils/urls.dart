class Urls
{
  static const String _baseUrl = "http://35.73.30.144:2005/api/v1";

  static const String registrationUrl = "$_baseUrl/Registration";
  static const String loginUrl = "$_baseUrl/Login";
  static const String createNewTaskUrl = "$_baseUrl/createTask";
  static const String getTaskStatusCountUrl = "$_baseUrl/taskStatusCount";
  static const String getNewTaskListUrl = "$_baseUrl/listTaskByStatus/New";
  static const String getProgressTaskListUrl = "$_baseUrl/listTaskByStatus/Progress";
  static const String getCancelledTaskListUrl = "$_baseUrl/listTaskByStatus/Cancelled";
  static const String getCompletedTaskListUrl = "$_baseUrl/listTaskByStatus/Completed";
  static const String updateProfileUrl = "$_baseUrl/ProfileUpdate";
  static const String recoveryResetPassword = "$_baseUrl/RecoverResetPassword";
  static String getTaskStatusUrl(String taskId, String status) => "$_baseUrl/updateTaskStatus/$taskId/$status";
  static String getDeleteTaskUrl(String taskId) => "$_baseUrl/deleteTask/$taskId";
  static String getForgotPasswordUrl(String email) => "$_baseUrl/RecoverVerifyEmail/$email";
  static String getRecoverVerifyOtpUrl(String email, String otp) => "$_baseUrl/RecoverVerifyOtp/$email/$otp";
}