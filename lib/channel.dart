import 'package:intl/intl.dart';

import 'cookie_server.dart';

/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://aqueduct.io/docs/http/channel/.
class CookieServerChannel extends ApplicationChannel {
  /// Initialize services in this method.
  ///
  /// Implement this method to initialize services, read values from [options]
  /// and any other initialization required before constructing [entryPoint].
  ///
  /// This method is invoked prior to [entryPoint] being accessed.
  @override
  Future prepare() async {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
  }

  /// Construct the request channel.
  ///
  /// Return an instance of some [Controller] that will be the initial receiver
  /// of all [Request]s.
  ///
  /// This method is invoked after [prepare].
  @override
  Controller get entryPoint {
    final router = Router();
    final dateFormat = DateFormat(DateFormat.HOUR24_MINUTE_SECOND);

    // Prefer to use `link` instead of `linkFunction`.
    // See: https://aqueduct.io/docs/http/request_controller/
    router.route("/getCookie").linkFunction((request) async {
      return Response.ok('getCookie', headers: {
        'Set-Cookie':
            'date=${dateFormat.format(DateTime.now())}; Secure; HttpOnly',
      });
    });

    router.route("/showCookie").linkFunction((request) async {
      final httpHeaders = request.raw.headers;
      final cookie = httpHeaders.value('cookie');
      if (cookie != null) {
        return Response.ok(cookie);
      }
      return Response.ok('No cookie');
    });

    return router;
  }
}
