package io.flutter.plugins;

import androidx.annotation.Keep;
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.shim.ShimPluginRegistry;

/**
 * Generated file. Do not edit.
 * This file is generated by the Flutter tool based on the
 * plugins that support the Android platform.
 */
@Keep
public final class GeneratedPluginRegistrant {
  public static void registerWith(@NonNull FlutterEngine flutterEngine) {
    ShimPluginRegistry shimPluginRegistry = new ShimPluginRegistry(flutterEngine);
      io.flutter.plugins.firebase.cloudfirestore.CloudFirestorePlugin.registerWith(shimPluginRegistry.registrarFor("io.flutter.plugins.firebase.cloudfirestore.CloudFirestorePlugin"));
    flutterEngine.getPlugins().add(new com.mr.flutter.plugin.filepicker.FilePickerPlugin());
      io.flutter.plugins.firebaseauth.FirebaseAuthPlugin.registerWith(shimPluginRegistry.registrarFor("io.flutter.plugins.firebaseauth.FirebaseAuthPlugin"));
    flutterEngine.getPlugins().add(new io.flutter.plugins.firebase.core.FirebaseCorePlugin());
    flutterEngine.getPlugins().add(new io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin());
    flutterEngine.getPlugins().add(new io.flutter.plugins.firebase.storage.FirebaseStoragePlugin());
      infozenplus.com.flutter_open_whatsapp.FlutterOpenWhatsappPlugin.registerWith(shimPluginRegistry.registrarFor("infozenplus.com.flutter_open_whatsapp.FlutterOpenWhatsappPlugin"));
      io.flutter.plugins.flutter_plugin_android_lifecycle.FlutterAndroidLifecyclePlugin.registerWith(shimPluginRegistry.registrarFor("io.flutter.plugins.flutter_plugin_android_lifecycle.FlutterAndroidLifecyclePlugin"));
      com.aloisdeniel.geocoder.GeocoderPlugin.registerWith(shimPluginRegistry.registrarFor("com.aloisdeniel.geocoder.GeocoderPlugin"));
      com.baseflow.geolocator.GeolocatorPlugin.registerWith(shimPluginRegistry.registrarFor("com.baseflow.geolocator.GeolocatorPlugin"));
    flutterEngine.getPlugins().add(new com.baseflow.googleapiavailability.GoogleApiAvailabilityPlugin());
    flutterEngine.getPlugins().add(new vn.hunghd.flutter.plugins.imagecropper.ImageCropperPlugin());
    flutterEngine.getPlugins().add(new io.flutter.plugins.imagepicker.ImagePickerPlugin());
      com.baseflow.location_permissions.LocationPermissionsPlugin.registerWith(shimPluginRegistry.registrarFor("com.baseflow.location_permissions.LocationPermissionsPlugin"));
      com.vitanov.multiimagepicker.MultiImagePickerPlugin.registerWith(shimPluginRegistry.registrarFor("com.vitanov.multiimagepicker.MultiImagePickerPlugin"));
    flutterEngine.getPlugins().add(new io.flutter.plugins.share.SharePlugin());
    flutterEngine.getPlugins().add(new io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin());
    flutterEngine.getPlugins().add(new io.flutter.plugins.urllauncher.UrlLauncherPlugin());
  }
}
