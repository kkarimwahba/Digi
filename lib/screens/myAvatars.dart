import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class MyAvatarsPage extends StatefulWidget {
  @override
  _MyAvatarsPageState createState() => _MyAvatarsPageState();
}

class _MyAvatarsPageState extends State<MyAvatarsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Two Column Card Page'),
      ),
      body: GridView.count(
        crossAxisCount: 2, // 2 cards per row
        children: [
          Card(
            child: Column(
              children: [
                const ListTile(
                  title: Text('Avatar Card'),
                  subtitle: Text('Description for the avatar'),
                ),
                Expanded(
                  child: ModelViewer(
                    backgroundColor: Colors.transparent,
                    src: 'assets/avatars/model.glb', // Path to the .glb file
                    alt: "A 3D model of an avatar",
                    ar: false,
                    autoRotate: true,
                    cameraControls: true,
                    autoPlay: true,
                    animationName: 'Running',
                    cameraOrbit: '0deg 80deg 2m',
                  ),
                ),
              ],
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Card 2'),
              subtitle: const Text('Description for Card 2'),
              onTap: () {
                // Handle onTap for Card 2
              },
            ),
          ),
          // Add more cards as needed
        ],
      ),
    );
  }
}
