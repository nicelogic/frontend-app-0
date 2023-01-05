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
