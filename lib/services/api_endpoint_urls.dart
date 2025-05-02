class APIEndpointUrls {
  static const String baseUrl = 'https://api.telecallingcrm.com/';
  // static const String baseUrl = 'http://192.168.80.77:8000/';
  static const String apiUrl = 'api/';
  static const String authUrl = 'auth/';

  ///Auth URLS
  static const String userLogin = '${authUrl}login';
  static const String refreshtoken = '${authUrl}refresh-token';


  ///Api URLs
  static const String dashboard = '${apiUrl}dashboard';
  static const String profile = '${apiUrl}profile';
  static const String update_call_status_api = '${apiUrl}update_call_status_api';
  static const String get_lead_calls = '${apiUrl}get_lead_calls';
  static const String today_called_history = '${apiUrl}today-called-history';
  static const String get_leader_board = '${apiUrl}get_leader_board';
  static const String add_lead = '${apiUrl}add-lead';
  static const String add_follow_up = '${apiUrl}add-follow-up';
  static const String delete_follow_ups = '${apiUrl}delete-follow-ups';
  static const String update_info = '${apiUrl}update-info';
  static const String view_info = '${apiUrl}view-info';
  static const String follow_up_list = '${apiUrl}follow_up_list';
  static const String get_follow_up_types = '${apiUrl}get-follow-up-types';
  static const String update_profile = '${apiUrl}update-profile';
  static const String update_password = '${apiUrl}update_password';
  static const String forget_password = '${apiUrl}forget-password';
  static const String verify_otp = '${apiUrl}verify-otp';
}
