import 'package:fennec/fennec.dart' hide UserRepository;
import 'package:fennec_pg/fennec_pg.dart';

import '../repositories/user_repository.dart';

Router userRouter() {
  Router router = Router(routerPath: '/api/v1/user');
  final UserRepository userRepository = UserRepository();
  router.get(
      path: "/getUsers/@id",
      requestHandler: (req, res) async {
        int id = int.parse(req.pathParams['id']);
        FilterBuilder filterBuilder =
            NotEquals(Field.tableColumn("id"), Field.int(id));
        final result =
            await userRepository.findAll(filterBuilder: filterBuilder);
        return res.ok(body: {"result": result}).json();
      });
  return router;
}
