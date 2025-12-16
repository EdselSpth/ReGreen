allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory
    .dir("../../build")
    .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// --- BAGIAN INI DIPINDAH KE ATAS ---
// Kita taruh penanganan error flutter_inappwebview di sini
// supaya dibaca SEBELUM project selesai dievaluasi.
subprojects {
    if (project.name == "flutter_inappwebview") {
        project.afterEvaluate {
            project.extensions.configure<com.android.build.gradle.LibraryExtension> {
                namespace = "com.pichillilorenzo.flutter_inappwebview"
            }
        }
    }
}

// --- evaluationDependsOn DITARUH DI BAWAH ---
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}