import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playify/playify.dart';

void main() {
  const channel = MethodChannel('com.kaya.playify/playify');
  final log = <MethodCall>[];

  final playify = Playify();

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      log.add(methodCall);
    });
  });

  tearDown(() {
    log.clear();
    channel.setMockMethodCallHandler(null);
  });

  group('setQueue', () {
    test('call setQueue correctly', () async {
      final ids = <String>['s1', 's2'];
      await playify.setQueue(songIDs: ids, startID: 's1');
      expect(log, <Matcher>[
        isMethodCall(
          'setQueue',
          arguments: <String, dynamic>{
            'songIDs': ids,
            'startPlaying': true,
            'startID': null
          },
        ),
      ]);
    });

    test('call setQueue incorrectly', () async {
      final ids = <String>['s1', 's2'];
      final id = 's1';
      await playify.setQueue(songIDs: ids, startID: id);
      expect(log, <Matcher>[
        isNot(
          isMethodCall(
            'setQueue',
            arguments: <String, dynamic>{
              'songIDs': ids,
              'startPlaying': true,
              'startID': null
            },
          ),
        ),
      ]);
      log.clear();
    });

    test('songIDs should contain startID', () async {
      final ids = <String>['s1', 's2'];
      final id = 's2';
      expect(
          () => playify.setQueue(songIDs: ids, startID: id), returnsNormally);
      log.clear();
      debugDefaultTargetPlatformOverride = null; // <-- this is required
    });
  });

  test('songIDs should throw error when it does not contain startID', () async {
    final ids = <String>['s1', 's2'];
    final id = 's3';
    expect(() => playify.setQueue(songIDs: ids, startID: id), throwsException);
    log.clear();
  });
}
