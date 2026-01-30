import 'package:dynamic_domain/dynamic_domain.dart';
// 假设这是 OpenIM 的 SDK
// import 'package:openim_flutter_sdk/openim_flutter_sdk.dart';

/// 演示如何将 Dynamic Domain SDK 与 OpenIM SDK 集成。
///
/// 核心逻辑：
/// 1. 先启动 Dynamic Domain 隧道。
/// 2. 获取代理配置。
/// 3. 将代理应用到环境变量（针对 Go Core）或显式设置给 OpenIM。
/// 4. 初始化 OpenIM SDK。
class OpenIMIntegrationDemo {
  final _dynamicDomain = DynamicDomain();

  Future<void> setupAndInitOpenIM() async {
    try {
      print("Step 1: 初始化 Dynamic Domain...");
      await _dynamicDomain.init("your_app_id_from_dispatch_server");

      print("Step 2: 获取远程配置并启动隧道...");
      // 获取配置（内部会自动处理 DoH/API/Cache 等逻辑）
      final config = await _dynamicDomain.fetchRemoteConfig();
      
      // 启动隧道，获取本地代理地址
      final proxyUrl = await _dynamicDomain.startTunnel(config);
      print("隧道已启动，代理地址: $proxyUrl");

      // 获取结构化代理配置
      final proxy = _dynamicDomain.getProxyConfig();
      if (proxy != null) {
        print("Step 3: 应用代理到环境变量...");
        // 这一步至关重要！OpenIM 的 Go 核心会自动读取这些环境变量
        await proxy.applyToEnvironment();
        
        print("Step 4: 初始化 OpenIM SDK...");
        // await OpenIM.iMManager.initSDK(
        //   platform: IMPlatform.android, // 或 iOS
        //   apiAddr: "https://your-im-api.com",
        //   wsAddr: "ws://your-im-ws.com",
        //   dataDir: "path/to/data",
        //   objectStorage: "cos",
        // );
        
        // 如果 OpenIM 支持显式设置代理，建议也调用：
        // await OpenIM.iMManager.setProxy(
        //   proxyUrl: proxy.socksUrl,
        //   type: 'socks5',
        // );
        
        print("集成完成！OpenIM 现在将通过隧道进行通信。");
      }
    } catch (e) {
      print("集成过程中出错: $e");
    }
  }

  /// 验证连接是否通过隧道
  Future<void> verifyConnection() async {
    final isHealthy = await _dynamicDomain.isConnectionHealthy();
    print("隧道健康状况: ${isHealthy ? '良好' : '异常'}");
  }
}
