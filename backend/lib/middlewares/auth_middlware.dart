import 'package:fennec/fennec.dart';
import 'package:fennec_jwt/fennec_jwt.dart';

import '../routers/auth_router.dart';

AMiddleWareResponse verifyToken(Request req, Response res) {
  try {
    String token = req.httpHeaders.value('token') as String;
    final claimSet = verifyJwtHS256Signature(token, sharedSecret);
    claimSet.validate(issuer: 'fennec_jwt');
    req.additionalData = claimSet.toJson();
    return Next();
  } catch (e) {
    return Stop(res.forbidden(body: e.toString()));
  }
}
