import 'package:fpdart/fpdart.dart';
import '../../../../core/services/network/http_exception.dart';
import '../models/fcm_device_check_response.dart';

typedef EitherFcmDeviceCheckResponseOrException
    = Either<HttpException, FcmDeviceCheckResponse>;
