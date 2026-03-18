abstract class RemoteSyncService {
  Future<void> syncAll();
}

class StubRemoteSyncService implements RemoteSyncService {
  @override
  Future<void> syncAll() async {}
}

