import '../../../../ui/features/profile/models/user_profile.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/services/network/http_exception.dart';

typedef EitherUserProfileResponseOrException
    = Either<HttpException, UserProfile>;
