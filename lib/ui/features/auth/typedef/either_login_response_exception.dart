import 'package:fpdart/fpdart.dart';

import '../../../../core/services/network/http_exception.dart';
import '../models/login_response.dart';

typedef EitherLoginResponseOrException = Either<HttpException, LoginResponse>;
