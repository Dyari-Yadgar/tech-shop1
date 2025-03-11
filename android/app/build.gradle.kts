plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.tech_shop"

    compileSdk = 35 // Or the appropriate Flutter compileSdkVersion if needed
    defaultConfig {
        applicationId = "com.example.tech_shop"
        minSdk = 23 // Change this to 23
        targetSdk = 33 // Set this to 33 or your desired targetSdkVersion
        versionCode = 1 // You can set this dynamically or manually
        versionName = "1.0.0" // Set this to your app version
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }
}

flutter {
    source = "../.."
}

