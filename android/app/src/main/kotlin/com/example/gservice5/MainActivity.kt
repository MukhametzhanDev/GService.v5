package com.example.gservice5

import io.flutter.embedding.android.FlutterActivity

import com.yandex.mapkit.MapKitFactory

class MainActivity: FlutterActivity(){
     override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MapKitFactory.setLocale("ru_RU")
        MapKitFactory.setApiKey("7b27f1d3-41c1-4ecb-9965-29145a9b1264")
    }
}