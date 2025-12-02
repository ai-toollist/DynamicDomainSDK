import '../openim_common.dart';

extension FutureApiHelper<T> on Future<T> {
  Future<T> catchApiError({List<int> allowDataErrors = const []}) {
    return catchError((e, _) {
      if (e is (int, String?, dynamic)) {
        final errCode = e.$1;
        final errMsg = e.$2;
        final data = e.$3;

        Logger.print('e:$errCode s:$errMsg data:$data');

        if (allowDataErrors.contains(errCode)) {
          return Future.error(
              {'errCode': errCode, 'errMsg': errMsg, 'data': data});
        }
      }

      return Future.error(e);
    });
  }

  Future<T> catchApiErrorCode() {
    return catchError((e, _) {
      if (e is (int, String?, dynamic)) {
        final errCode = e.$1;
        final errMsg = e.$2;
        final data = e.$2;
        Logger.print('e:$errCode s:$errMsg data:$data');
        return Future.error(errCode);
      }
      return Future.error(e);
    });
  }
}
