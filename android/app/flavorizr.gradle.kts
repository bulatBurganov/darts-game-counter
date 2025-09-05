import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("flavor-type")

    productFlavors {
        create("prod") {
            dimension = "flavor-type"
            applicationId = "com.bzstudio.dartscounter"
            resValue(type = "string", name = "app_name", value = "Счетчик дартс")
        }
        create("dev") {
            dimension = "flavor-type"
            applicationId = "com.bzstudio.dartscounter.dev"
            resValue(type = "string", name = "app_name", value = "Счетчик дартс Dev")
        }
        create("stage") {
            dimension = "flavor-type"
            applicationId = "com.bzstudio.dartscounter.stage"
            resValue(type = "string", name = "app_name", value = "Счетчик дартс Stage")
        }
    }
}