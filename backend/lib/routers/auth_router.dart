import 'dart:io';
import 'dart:math';

import 'package:fennec/fennec.dart' hide UserRepository, Utils;
import 'package:fennec_jwt/fennec_jwt.dart';
import 'package:fennec_pg/fennec_pg.dart';
import 'package:encrypt/encrypt.dart';

import '../models/user.dart';
import '../repositories/user_repository.dart';
import '../utils/utils.dart';

final key = 'hash password111';
final String sharedSecret = 'jwt_secret';

Router authRouter() {
  String generateRandomString(int len) {
    var r = Random();
    return String.fromCharCodes(
        List.generate(len, (index) => r.nextInt(33) + 89));
  }

  Router router = Router(routerPath: '/api/v1/auth');
  final UserRepository userRepository = UserRepository();
  router.post(
      path: '/signin',
      requestHandler: (req, res) async {
        String username = req.body['username'];
        String password = req.body['password'];

        FilterBuilder filterBuilder =
            Equals(Field.tableColumn('username'), Field.string(username));
        filterBuilder
            .or(Equals(Field.tableColumn('email'), Field.string(username)));
        final result =
            await userRepository.findAll(filterBuilder: filterBuilder);
        if (result.isEmpty) {
          return res.badRequest(
              body: {'message': 'User not Found'},
              contentType: ContentType.json);
        } else if (result.length > 1) {
          return res.badRequest(
              body: {'message': 'Many Users found'},
              contentType: ContentType.json);
        } else {
          String hash = Utils.decryptAES(key, result.first.password!);
          if (hash != password) {
            return res.badRequest(
                body: {'message': 'User not Found'},
                contentType: ContentType.json);
          } else {
            final claimSet = JwtClaim(
              issuer: 'fennec_jwt',
              subject: 'jwt',
              jwtId: generateRandomString(32),
              otherClaims: <String, dynamic>{
                'userId': result.first.id,
                'username': result.first.username
              },
              maxAge: const Duration(days: 1),
            );
            final token = generateJwtHS256(claimSet, sharedSecret);
            return res.ok(
                body: {'user': result.first.toJson(), 'token': token},
                contentType: ContentType.json);
          }
        }
      });
  router.post(
      path: '/signup',
      requestHandler: (req, res) async {
        try {
          String username = req.body['username'];
          String password = req.body['password'];
          String email = req.body['email'];
          User user = User();
          user.username = username;
          user.email = email;
          user.isAnonym = false;
          Encrypted encrypted = Utils.encryptAES(key, password);
          user.password = encrypted.base64;
          final result = await userRepository.insert(user);
          if (result == null) {
            return res.badRequest(
                body: {'message': 'error by creating new User'},
                contentType: ContentType.json);
          } else {
            final claimSet = JwtClaim(
              issuer: 'fennec_jwt',
              subject: 'jwt',
              jwtId: generateRandomString(32),
              otherClaims: <String, dynamic>{
                'userId': result.id,
                'username': result.username
              },
              maxAge: const Duration(minutes: 5),
            );
            final token = generateJwtHS256(claimSet, sharedSecret);
            return res.ok(
                body: {'user': result.toJson(), 'token': token},
                contentType: ContentType.json);
          }
        } catch (e) {
          return res.internalServerError(
              body: {'message': e.toString()}, contentType: ContentType.json);
        }
      });

  return router;
}
