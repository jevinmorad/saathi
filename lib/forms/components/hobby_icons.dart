import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum Hobby {
  writing,
  cooking,
  singing,
  photography,
  playingInstruments,
  painting,
  diyCrafts,
  acting,
  poetry,
  gardening,
  blogging,
  contentCreation,
  designing,
  movies,
  music,
  travelling,
  reading,
  sports,
  socialMedia,
  gaming,
  bingeWatching,
  biking,
  clubbing,
  shopping,
  standUps,
  running,
  cycling,
  yogaMeditation,
  walking,
  workingOut,
  trekking,
  swimming,
  pets,
  foodie,
  newsPolitics,
  socialServices,
  homeDecor,
  investments,
}

// Extension to get the IconData and display name
extension HobbyExtension on Hobby {
  IconData get icon {
    switch (this) {
      case Hobby.movies:
        return Icons.theaters;
      case Hobby.music:
        return Icons.library_music;
      case Hobby.travelling:
        return Icons.flight;
      case Hobby.reading:
        return Icons.book;
      case Hobby.sports:
        return Icons.sports_football;
      case Hobby.socialMedia:
        return Icons.social_distance;
      case Hobby.gaming:
        return Icons.videogame_asset;
      case Hobby.bingeWatching:
        return Icons.laptop;
      case Hobby.biking:
        return Icons.bike_scooter;
      case Hobby.clubbing:
        return Icons.emoji_people;
      case Hobby.shopping:
        return CupertinoIcons.cart_fill;
      case Hobby.standUps:
        return CupertinoIcons.mic_fill;
      case Hobby.running:
        return Icons.directions_run;
      case Hobby.cycling:
        return Icons.directions_bike_sharp;
      case Hobby.yogaMeditation:
        return Icons.self_improvement;
      case Hobby.walking:
        return Icons.directions_walk;
      case Hobby.workingOut:
        return FontAwesomeIcons.dumbbell;
      case Hobby.trekking:
        return Icons.hiking;
      case Hobby.swimming:
        return FontAwesomeIcons.personSwimming;
      case Hobby.pets:
        return FontAwesomeIcons.dog;
      case Hobby.foodie:
        return Icons.fastfood;
      case Hobby.newsPolitics:
        return CupertinoIcons.person_crop_rectangle_fill;
      case Hobby.socialServices:
        return Icons.message_rounded;
      case Hobby.homeDecor:
        return Icons.wallet_giftcard;
      case Hobby.investments:
        return CupertinoIcons.money_dollar_circle_fill;
      case Hobby.writing:
        return Icons.edit;
      case Hobby.blogging:
        return CupertinoIcons.pencil_ellipsis_rectangle;
      case Hobby.contentCreation:
        return CupertinoIcons.square_pencil;
      case Hobby.photography:
        return Icons.camera_alt;
      case Hobby.designing:
        return Icons.design_services;
      case Hobby.diyCrafts:
        return CupertinoIcons.scissors;
      case Hobby.painting:
        return Icons.brush;
      case Hobby.poetry:
        return CupertinoIcons.pencil;
      case Hobby.acting:
        return Icons.theater_comedy;
      case Hobby.cooking:
        return Icons.restaurant;
      case Hobby.singing:
        return CupertinoIcons.music_note;
      case Hobby.playingInstruments:
        return Icons.music_video;
      case Hobby.gardening:
        return CupertinoIcons.leaf_arrow_circlepath;
    }
  }

  String get displayName {
    return name
        .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(0)}')
        .trim()
        .capitalize();
  }
}

// Helper function to convert a string to a Hobby enum
Hobby? getHobbyEnumFromString(String hobbyName) {
  // Convert the hobby name to lowercase and replace spaces with camel case
  String formattedName = hobbyName
      .toLowerCase()
      .replaceAllMapped(RegExp(r' (.)'), (match) => match.group(1)!.toUpperCase())
      .replaceAll(' ', ''); // Remove any remaining spaces

  try {
    // Match the formatted name with the enum values
    return Hobby.values.firstWhere(
          (hobby) => hobby.name == formattedName,
    );
  } catch (e) {
    // If no match is found, return null
    return null;
  }
}

// Extension to capitalize the first letter of a string
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this; // Handle empty strings
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
