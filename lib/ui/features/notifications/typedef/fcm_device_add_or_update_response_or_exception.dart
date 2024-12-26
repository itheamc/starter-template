import 'package:fpdart/fpdart.dart';

import '../../../../core/services/network/http_exception.dart';
import '../models/fcm_device_added_or_updated_response.dart';

typedef EitherFcmDeviceAddedOrUpdatedResponseOrException
    = Either<HttpException, FcmDeviceAddedOrUpdatedResponse>;
