import 'package:fpdart/fpdart.dart';

import '../../../../core/services/network/http_exception.dart';
import '../models/forget_password_response.dart';

typedef EitherForgotPasswordResponseOrException = Either<HttpException, ForgotPasswordResponse>;
