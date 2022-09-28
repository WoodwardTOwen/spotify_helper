import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelperMethods {
  static void createSnackBarMessage(BuildContext context, String stringContent,
      {bool isSecondaryColour = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          stringContent,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: GoogleFonts.poppins().fontFamily,
              color: isSecondaryColour ? Colors.black : Colors.white),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: isSecondaryColour
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.primary,
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

  static void showGenericDialog(BuildContext context, String errorMessage,
      {String title = "Whoops..."}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontSize: 20, color: Colors.black),
          ),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static String concatingArtists(List<dynamic> jsonArtists) {
    if (jsonArtists.length <= 1) return jsonArtists[0]['name'];
    List<String> artists = jsonArtists
        .map((currentArtist) => currentArtist['name'] as String)
        .toList();
    return artists.join(', ');
  }

  static List<String> filterListForArtistId(List<dynamic> jsonArtists) =>
      jsonArtists
          .map((currentArtist) => currentArtist['id'] as String)
          .toList();
}
