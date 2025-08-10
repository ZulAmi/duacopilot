// Background task service (WorkManager disabled for compatibility)

class BackgroundTaskService {
  static Future<void> initialize() async {
    // WorkManager initialization disabled for compatibility
    print('Background task service initialized (WorkManager disabled)');
  }

  static Future<void> registerCacheSyncTask() async {
    // WorkManager task registration disabled for compatibility
    print('Cache sync task registration skipped (WorkManager disabled)');
  }

  static Future<void> registerAudioDownloadTask({
    required String url,
    required String localPath,
    Map<String, dynamic>? metadata,
  }) async {
    // WorkManager task registration disabled for compatibility
    print('Audio download task registration skipped (WorkManager disabled)');
  }

  static Future<void> cancelAllTasks() async {
    // WorkManager task cancellation disabled for compatibility
    print('Task cancellation skipped (WorkManager disabled)');
  }

  static Future<void> cancelTask(String uniqueName) async {
    // WorkManager task cancellation disabled for compatibility
    print('Task cancellation skipped (WorkManager disabled)');
  }
}
