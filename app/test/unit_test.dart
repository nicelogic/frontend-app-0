// This is an example unit test.
//
// A unit test tests a single function, method, or class. To learn more about
// writing unit tests, visit
// https://flutter.dev/docs/cookbook/testing/unit/introduction

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/src/features/add_contacts_applys/add_contacts_applys.dart';

void main() {
  test('dart basic test', () async {
    Stream<int> countStream(int to) async* {
      for (int i = 1; i <= to; i++) {
        yield i;
      }
    }

    Future<int> changeValue(int value) async {
      if (kDebugMode) {
        print('change value($value)');
      }
      await Future.delayed(const Duration(seconds: 2));
      final changedValue = value + 1;
      if (kDebugMode) {
        print('change value($value) to $changedValue');
      }
      return changedValue;
    }

    Future<int> sumStream(Stream<int> stream) async {
      var sum = 0;
      await for (final value in stream) {
        final changedValue = await changeValue(value);
        sum += changedValue;
      }
      return sum;
    }

    var stream = countStream(10);
    var sum = await sumStream(stream);
    if (kDebugMode) {
      print(sum);
    } // 55
  });

  group('Plus Operator', () {
    test('should add two numbers together', () {
      expect(1 + 1, 2);
    });
  });

  test('basic list equatable', () {
    final nowTime = DateTime.now();
    final state1 = AddContactsApplysState(userId: '1', addContactsApplys: {
      '1': AddContactsApply(
          userId: '1',
          userName: '',
          userAvatarUrl: '',
          message: '3',
          updateTime: nowTime,
          replyAddContactsStatus: ReplyAddContactsStatus.none),
    });
    final state2 = AddContactsApplysState(userId: '1', addContactsApplys: {
      '2': AddContactsApply(
          userId: '2',
          userName: '',
          userAvatarUrl: '',
          message: '3',
          updateTime: nowTime,
          replyAddContactsStatus: ReplyAddContactsStatus.none)
    });
    final isEuqatable = state1 == state2;
    if (kDebugMode) {
      log('is equatable($isEuqatable)');
    }
    expect(isEuqatable, false);
  });
}
