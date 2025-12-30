import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'providers/auth_provider.dart';
import 'providers/trip_provider.dart';
import 'providers/place_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'utils/theme.dart';
import 'utils/constants.dart';

Future<void> _debugLog({
  required String hypothesisId,
  required String location,
  required String message,
  required Map<String, dynamic> data,
  String runId = 'run1',
}) async {
  final payload = {
    'sessionId': 'debug-session',
    'runId': runId,
    'hypothesisId': hypothesisId,
    'location': location,
    'message': message,
    'data': data,
    'timestamp': DateTime.now().millisecondsSinceEpoch,
  };
  print('DEBUG: ${jsonEncode(payload)}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
    ApiConstants.initializeKeys();
    await _debugLog(
      hypothesisId: 'H1',
      location: 'main.dart:48',
      message: '.env loaded and keys initialized',
      data: {
        'otmKey': ApiConstants.openTripMapApiKey.substring(0, 10) + '...',
        'otmKeyLength': ApiConstants.openTripMapApiKey.length,
        'isPlaceholder': ApiConstants.openTripMapApiKey.contains('YOUR_'),
      },
    );
  } catch (e) {
    await _debugLog(
      hypothesisId: 'H1',
      location: 'main.dart:59',
      message: '.env load failed',
      data: {'error': e.toString(), 'errorType': e.runtimeType.toString()},
    );
    ApiConstants.initializeKeys();
    print("Warning: .env file not found: $e");
  }
  
  runApp(
    DevicePreview(
      builder: (context) => const MyApp(),
    ),
  );
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TripProvider()),
        ChangeNotifierProvider(create: (_) => PlaceProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
        },
        builder: DevicePreview.appBuilder,
      ),
    );
  }
}
