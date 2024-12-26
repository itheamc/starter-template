# Starter Template

This Flutter starter template is designed to streamline flutter project setup, enabling us to
kickstart development quickly and efficiently. It includes best practices, essential configurations,
and a structured layout to streamline the development process and ensure consistency across
projects.

## How to Use This Starter Template

To get started with this template, follow these steps to create your own GitHub repository:

1. **Go to the Template Repository:**
    - Navigate to the GitHub page where the starter template is hosted.

2. **Use the Template:**
    - Click on the green **"Use this template"** button located at the top right corner of the
      repository page.

3. **Create a New Repository:**
    - You will be redirected to a new page where you can create your own repository using this
      template.
    - Enter a name for your new repository in the **Repository name** field.
    - Optionally, add a description to describe your project.
    - Choose the visibility of your repository (public or private).

4. **Click "Create Repository from Template":**
    - Once you've filled in the necessary details, click the **Create repository from template**
      button.
    - This action will create a new repository under your GitHub account with all the contents from
      the starter template.

5. **Clone the Repository Locally:**
    - After the repository is created, clone it to your local machine using the command:
   ```
   git clone https://github.com/your-username/your-repository-name.git
   ```

## How to change package name?

Use the below command to change the package name. Replace `com.example.newname` with your desired
package name:

```
      flutter pub run change_app_package_name:main com.example.newname
```

## Setup for .env files

Create a file named .env at the root directory of the project and paste the following content:

```
      # Application configuration
      # PRODUCTION
      BASE_URL=https://baseurl.com.np/
      PRIVACY_POLICY_URL=https://baseurl.com.np/privacy-policy
      HIVE_BOX_NAME=NaxaTemplateApp
      
      # STAGING
      BASE_URL_STAGING=https://baseurl-staging.com.np/
      PRIVACY_POLICY_URL_STAGING=https://baseurl-staging.com.np/privacy-policy
      HIVE_BOX_NAME_STAGING=NaxaTempleteAppStaging
      
      # DEV
      BASE_URL_DEV=https://baseurl-dev.com.np/
      PRIVACY_POLICY_URL_DEV=https://baseurl-dev.com.np/privacy-policy
      HIVE_BOX_NAME_DEV=NaxaTempleteAppDev
```

## How to run app with different flavors?

To run your Flutter app with different flavors, you can use the following methods:

#### Using `flutter run` with the `--flavor` flag:

```
      flutter run --flavor dev
               or
      flutter run --flavor staging
               or
      flutter run --flavor prod
```

#### Using Android Studio or IntelliJ

- Open your Flutter project in `Android Studio` or `IntelliJ`.
- Enter the desired `flavor` in the `Build Flavor` section in the "Run" configuration.
- Click the "Run" button to launch your app with the selected flavor.

## How to build release app with different flavors?

To build your Flutter release app with different flavors, you can use the following method:

#### Using `flutter build` with the `--flavor` flag:

```
      flutter build apk --release --flavor dev
      flutter build appbundle --release --flavor dev
               or
      flutter build apk --release --flavor staging
      flutter build appbundle --release --flavor staging
               or
      flutter build apk --release --flavor prod
      flutter build appbundle --release --flavor prod
```
