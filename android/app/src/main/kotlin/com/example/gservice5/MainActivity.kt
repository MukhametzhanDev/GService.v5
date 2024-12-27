package com.example.gservice5

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity

import com.yandex.mapkit.MapKitFactory
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity(){
     override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MapKitFactory.setLocale("ru_RU")
        MapKitFactory.setApiKey("7b27f1d3-41c1-4ecb-9965-29145a9b1264")
    }
}