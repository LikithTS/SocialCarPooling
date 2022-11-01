class ApiConstant {
  static const int STATUS_CODE_SUCCESS = 200;
  static const int STATUS_CODE_SUCCESS_ONE = 201;
  static const int HTTP_UNAUTHORIZED_ERROR = 401;
  static const int HTTP_INTERNAL_SERVER_ERROR = 500;

  static const String LOGIN_API_PATH = "user/login";
  static const String LOGOUT_API_PATH = "user/logout";
  static const String HOME_API_PATH = "home";
  static const String SIGN_IN_API_PATH = "user/signup";
  static const String SEND_OTP_API_PATH = "user/send-otp";
  static const String VERIFY_OTP_API_PATH = "user/validate-otp";
  static const String QUESTIONARIE_API_PATH = "questionnarie";
  static const String CAR_API_PATH = "car/all";
  static const String CAR_DRVING_STATUS = "car/change-status";
  static const String ADD_NEW_CAR = "car/add";
  static const String DELETE_CAR = "car/del";
  static const String ALL_RIDE = "ride/all";
}