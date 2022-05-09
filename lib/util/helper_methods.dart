import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelperMethods {
  static void createSnackBarMessage(
      BuildContext context, String stringContent) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          stringContent,
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        elevation: 2.0,
      ),
    );
  }

  static void createGenericErrorMessage(BuildContext context,
      {String? stringContent = "Something Went Wrong. Please Try Again"}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          stringContent!,
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily),
        ),
        duration: const Duration(seconds: 3),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        elevation: 2.0,
      ),
    );
  }
}
