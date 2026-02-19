allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Define global properties for legacy plugins that rely on rootProject.ext
extra.apply {
    set("compileSdkVersion", 35)
    set("targetSdkVersion", 35)
    set("minSdkVersion", 21)
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
