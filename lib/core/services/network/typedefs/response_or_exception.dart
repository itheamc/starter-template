import 'package:fpdart/fpdart.dart';

import '../http_exception.dart';

typedef EitherResponseOrException<T> = Either<HttpException, T>;
