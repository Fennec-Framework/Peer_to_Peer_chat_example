import 'package:fennec/fennec.dart';
import 'package:fennec_jwt/fennec_jwt.dart';

import '../routers/auth_router.dart';

MiddleWareResponse verfiyToken(Request req, Response res) {
  try {
    String token = req.httpHeaders.value('token') as String;
    final claimSet = verifyJwtHS256Signature(token, sharedSecret);
    claimSet.validate(issuer: 'fennec_jwt');
    req.additionalData = claimSet.toJson();
    return MiddleWareResponse(MiddleWareResponseEnum.next);
  } catch (e) {
    res.forbidden().send(e.toString());
    return MiddleWareResponse(MiddleWareResponseEnum.stop);
  }
}
