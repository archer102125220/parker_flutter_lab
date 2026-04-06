# make run-android / make run-ios

run-ios:
	fvm flutter run -d iPhone --flavor production --target lib/main_production.dart

run-android:
	fvm flutter run -d emulator --flavor production --target lib/main_production.dart

run-chrome:
	fvm flutter run -d chrome --flavor production --target lib/main_production.dart

run-macos:
	fvm flutter run -d macos --flavor production --target lib/main_production.dart

run-ios-dev:
	fvm flutter run -d ios --flavor development --target lib/main_development.dart

run-android-dev:
	fvm flutter run -d android --flavor development --target lib/main_development.dart

run-ios-stg:
	fvm flutter run -d ios --flavor staging --target lib/main_staging.dart

run-android-stg:
	fvm flutter run -d android --flavor staging --target lib/main_staging.dart