import '../../domain/entities/video_entity.dart';
import '../../domain/repositories/video_repository.dart';

class VideoRepositoryImpl implements VideoRepository {
  @override
  Future<List<VideoEntity>> getVideos() async {
    // Mock data - replace with actual data source
    return [
      const VideoEntity(
        url: 'https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8',
        title: 'Sample Video',
        duration: Duration(seconds: 30),
      ),
    ];
  }

  @override
  Future<VideoEntity?> getVideoById(String id) async {
    final videos = await getVideos();
    return videos.isNotEmpty ? videos.first : null;
  }
}
