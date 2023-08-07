import 'package:flutter_test/flutter_test.dart';
import 'package:reactive_async/reactive_async.dart';

void main() {
  test('Wrap async function', () {
    final wrap = AsyncWrapper.wrap(
      func: (context) => Future.delayed(
        const Duration(seconds: 2),
      ),
    );
    expect(wrap.isLoading, false);
    expect(wrap.error, null);
  });

  test('that the passed async function is called', () async {
    bool called = false;

    await AsyncWrapper.wrap(
      func: () => Future.delayed(const Duration(seconds: 2), () {
        called = true;
      }),
    ).call();
    expect(called, true);
  });

  test('that the passed async function is called', () async {
    bool called = false;

    await AsyncWrapper.wrap(
      func: () => Future.delayed(const Duration(seconds: 2), () {
        called = true;
      }),
    ).call();
    expect(called, true);
  });

  test('catches errors and exceptions', () async {
    final func = AsyncWrapper.wrap(
      func: () => Future.delayed(const Duration(seconds: 2), () {
        throw Exception('hello');
      }),
    );
    // await func.call();
    expect(func.error != null, true);
  });
}
