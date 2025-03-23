plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")  // Add this line to apply the Google services plugin
}

android {
    namespace = "com.example.tech_shop"

    compileSdk = 35 // Or the appropriate Flutter compileSdkVersion if needed

    defaultConfig {
        applicationId = "com.example.tech_shop"
        minSdk = 23 // Change this to 23
        targetSdk = 33 // Set this to 33 or your desired targetSdkVersion
        versionCode = 1
        versionName = "1.0.0"
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

dependencies {
    // Firebase Firestore and Firebase Analytics dependencies
    implementation("com.google.firebase:firebase-analytics:20.0.0")
    implementation("com.google.firebase:firebase-firestore:24.0.0")

    // Other dependencies
    implementation("com.google.android.material:material:1.4.0")
    implementation("androidx.appcompat:appcompat:1.3.1")
    implementation("androidx.constraintlayout:constraintlayout:2.1.0")
}

flutter {
    source = "../.."
}
