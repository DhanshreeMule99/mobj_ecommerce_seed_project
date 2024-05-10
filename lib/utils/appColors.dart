import 'cmsConfigue.dart';

class AppColors {
  static const whiteColor = Color(0xFFF5F5F5);
  static const blackColor = Color(0xFF0A0404);
  static const Color tileColor = Color(0xFFCFEBFF);
  static const Color textColor = Color(0xFFD9D9D9);
  static const Color likeColor = Color(0xFFD22F27);
  static const buttonColor = Color(0xFF6F47EB);
  static const greyShade = Color(0xFFEEEDED);
  static const startColor = Color(0xFFFFD233);
  static const Color red = Colors.red;
  static const Color pink = Colors.pink;
  static const Color purple = Colors.purple;
  static const Color deepPurple = Colors.deepPurple;
  static const Color indigo = Colors.indigo;
  static const Color blue = Colors.blue;
  static const Color lightBlue = Colors.lightBlue;
  static const Color cyan = Colors.cyan;
  static const Color teal = Colors.teal;
  static const Color green = Colors.green;
  static const Color lightGreen = Colors.lightGreen;
  static const Color lime = Colors.lime;
  static const Color yellow = Colors.yellow;
  static const Color amber = Colors.amber;
  static const Color orange = Colors.orange;
  static const Color deepOrange = Colors.deepOrange;
  static const Color brown = Colors.brown;
  static const Color grey = Colors.grey;
  static Color greyShade200 = Colors.grey.shade200;
  static Color greyShade800 = Colors.grey.shade800;
  static const Color blueGrey = Colors.blueGrey;
  static const Color transparent = Colors.transparent;
}

class ConstColors {
  //primary color
  static const Color purple = Color(0xFF6F47EB);
  static const Color lightpurple = Color(0xFFEEE9FD);
  static const Color grey = Color(0xFFEDEDED);
  static const Color lightGrey = Color(0xFFF9F9F9);
  static const Color darkGrey = Color(0xFF595D61);
  static const Color textColor = Color(0xFFC5C5C5);
  static const Color lightred = Color(0xFFFBE4E1);

  static const Color black1 = Colors.black;

  static const Color red = Color.fromARGB(255, 255, 0, 0);

  static const shadowColor = Color.fromARGB(255, 196, 196, 196);

  static const Color countColor = Color(0xFF800080);

//Text color
  static const Color black = Colors.black;
//background color
  static const Color backgroundColor = Colors.white;
}

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF6F47EB), //purple
  onPrimary: Color(0xFFEEE9FD), //light  purple
  primaryContainer: Color.fromARGB(255, 224, 224, 224),
  onPrimaryContainer: Color.fromARGB(255, 245, 245, 245),
  secondary: Colors.white, // Dark gray // grey
  onSecondary: Color(0xFFF9F9F9), //lightgrey
  secondaryContainer: Color(0xFF595D61), //darkgrey
  onSecondaryContainer: Color(0xFFC5C5C5), //textColor
  tertiary: Colors.black, // black

  error: Color.fromARGB(255, 255, 0, 0), // red
  onError: Color(0xFFEEE9FD), //light  purple
  tertiaryContainer: Color(0xFFEEE9FD), //light  purple
  background: Colors.white, // backgroundColor
  onBackground: Color(0xFF1C1B1F),
  surface: Color(0xFFF9F9F9), //lightgrey
  onSurface: Color(0xFF1C1B1F),

  shadow: Color.fromARGB(255, 196, 196, 196), // shadow color
  surfaceTint: Colors.white, // white
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF6F47EB), //purple
  onPrimary: Color(0xFFEEE9FD), // Light purple 333639
  primaryContainer: Color(0xFF222223),
  onPrimaryContainer: Color.fromARGB(255, 245, 245, 245),
  secondary: Colors.white, // Dark gray
  onSecondary: Colors.white, // Light gray
  secondaryContainer: Colors.white, // Darker background for containers
  onSecondaryContainer: Colors.white, // Text color on dark container background
  tertiary: Color(0xFFF9F9F9),
  tertiaryContainer: Color.fromARGB(255, 64, 0, 255), //light  purple

  error: Color.fromARGB(255, 255, 0, 0), // Red
  onError: Colors.black54, //White text on red background

  background: Color(0xFF1e1e1e), // Dark background
  onBackground: Color(0xFFEEEEEE), // Light color for text on dark background
  surface: Color(0xFF333639), // Dark surface color
  onSurface:
      Color.fromARGB(255, 201, 8, 8), // Light color for text on dark surface

  shadow: Color.fromARGB(255, 100, 100, 100), // Adjusted shadow color
  surfaceTint: Colors.black, // Black surface tint
);
