import 'package:fpdart/fpdart.dart';

import '../../../../core/services/network/http_exception.dart';
import '../models/register_response.dart';

typedef EitherRegisterResponseOrException
    = Either<HttpException, RegisterResponse>;
