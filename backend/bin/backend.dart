import 'dart:io';

import 'package:backend/routers/auth_router.dart';
import 'package:backend/routers/chat_router.dart';
import 'package:backend/routers/messages_router.dart';
import 'package:backend/socket_io_singelton.dart';
import 'package:fennec/fennec.dart';
import 'package:fennec_pg/pg_connection_adapter.dart';
import 'package:fennec_socket_io_server/server_io.dart';

void main(List<String> arguments) async {
  var uri = 'postgres://postgres:StartAppPassword@localhost:5432/test_flutter';
  await PGConnectionAdapter.initPool(uri);
  Application application = Application();
  application.useSocketIOServer(false);
  application
      .addRouter(authRouter())
      .addRouter(chatRouter())
      .addRouter(messagesRouter());
  ServerIO serverIO = ServerIO();
  application.setPort(8000).setHost(InternetAddress.loopbackIPv4);
  Server server = Server(application);
  await server.startServer();
  SocketIOSingelton(serverIO);
  await serverIO.listenToHttpServer(server.httpServerStream);

  serverIO.on('connection', (client) {
    print('connection server');
    serverIO.emit('fromServer', 'ok123');
  });
  serverIO.on('fromServer', (e) {
    print('Server on');
  });
}

class Test extends AField {
  final DBField dbField;

  Test(this.dbField);

  @override
  List<DBField> fields() {
    return [dbField];
  }
}

abstract class AField {
  List<DBField> fields();
}

class DBField {
  final String fieldName;
  final BigSerial type;

  DBField(this.fieldName, this.type);
}

class BigSerial {
  ColumnType columnType;
  final int? defaultValue;
  final bool? isUnique;

  BigSerial(this.defaultValue, this.isUnique,
      {this.columnType = ColumnType.bigSerial});
}

class ColumnType {
  final String name;

  const ColumnType(this.name);

  static const ColumnType arrayInt = ColumnType('int[]');
  static const ColumnType arrayString = ColumnType('varchar[]');
  static const ColumnType boolean = ColumnType('boolean');

  static const ColumnType smallSerial = ColumnType('smallserial');
  static const ColumnType serial = ColumnType('serial');
  static const ColumnType bigSerial = ColumnType('bigserial');

  static const ColumnType bigInt = ColumnType('bigint');
  static const ColumnType int = ColumnType('int');
  static const ColumnType smallInt = ColumnType('smallint');
  static const ColumnType tinyInt = ColumnType('tinyint');
  static const ColumnType bit = ColumnType('bit');
  static const ColumnType decimal = ColumnType('decimal');
  static const ColumnType numeric = ColumnType('numeric');
  static const ColumnType money = ColumnType('money');
  static const ColumnType smallMoney = ColumnType('smallmoney');
  static const ColumnType float = ColumnType('float');
  static const ColumnType real = ColumnType('real');

  static const ColumnType dateTime = ColumnType('datetime');
  static const ColumnType smallDateTime = ColumnType('smalldatetime');
  static const ColumnType date = ColumnType('date');
  static const ColumnType time = ColumnType('time');
  static const ColumnType timeStamp = ColumnType('timestamp');
  static const ColumnType timeStampWithTimeZone =
      ColumnType('timestamp with time zone');

  static const ColumnType char = ColumnType('char');
  static const ColumnType varChar = ColumnType('varchar');
  static const ColumnType varCharMax = ColumnType('varchar(max)');
  static const ColumnType text = ColumnType('text');

  static const ColumnType nChar = ColumnType('nchar');
  static const ColumnType nVarChar = ColumnType('nvarchar');
  static const ColumnType nVarCharMax = ColumnType('nvarchar(max)');
  static const ColumnType nText = ColumnType('ntext');

  static const ColumnType binary = ColumnType('binary');
  static const ColumnType varBinary = ColumnType('varbinary');
  static const ColumnType varBinaryMax = ColumnType('varbinary(max)');
  static const ColumnType image = ColumnType('image');

  static const ColumnType json = ColumnType('json');
  static const ColumnType jsonb = ColumnType('jsonb');

  static const ColumnType sqlVariant = ColumnType('sql_variant');
  static const ColumnType uniqueIdentifier = ColumnType('uniqueidentifier');
  static const ColumnType xml = ColumnType('xml');
  static const ColumnType cursor = ColumnType('cursor');
  static const ColumnType table = ColumnType('table');
}
