part of reactive_async;

typedef AsyncFuncListener = void Function();
typedef AsyncFuncErrorListener = void Function(AsyncException);

class AsyncException implements Exception {
  late String message;

  AsyncException({required this.message});
}

enum AsyncState {
  stale,
  loading,
  error,
  successful,
}

class AsyncWrapper<T> {
  bool isLoading = false;
  late Future<void> Function()? call;
  late Future<void> Function() _func;

  AsyncException? error;
  late T? data;
  late void Function() _onSuccess;
  late void Function() _onError;

  AsyncWrapper.wrap(
      {required Function func,
      void Function()? setter,
      AsyncFuncListener? onSuccess,
      AsyncFuncErrorListener? onError,
      bool preventDuplicate = true}) {
    isLoading = false;
    error = null;
    data = null;
    setter?.call();
    _onSuccess = () {
      onSuccess?.call();
    };
    _onError = () {
      if (error == null) return;
      onError?.call(error!);
    };
    _func = () async {
      try {
        isLoading = true;
        error = null;
        setter?.call();
        if (preventDuplicate) {
          this.call = null;
        }

        this.data = await func();
        isLoading = false;
        if (preventDuplicate) {
          this.call = _func;
        }
        setter?.call();

        if (func.runtimeType == Future<void>) {
          _onSuccess.call();
        } else {
          if (this.data != null) {
            _onSuccess.call();
          }
        }
      } catch (err) {
        isLoading = false;
        error = AsyncException(message: err.toString());
        if (preventDuplicate) {
          this.call = _func;
        }
        setter?.call();
        _onError.call();
      }
    };
    call = _func;
  }
}
