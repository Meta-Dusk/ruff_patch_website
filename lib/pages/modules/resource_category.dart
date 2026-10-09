import 'package:flutter/material.dart';

enum ResourceCategory {
  phStrayIssue(title: 'PH Stray Issue', icon: Icons.pets),
  populationControl(title: 'Population Control', icon: Icons.bar_chart),
  localNeutering(title: 'Local Neutering', icon: Icons.medical_services),
  adoptionCenters(title: 'Adoption Centers', icon: Icons.home),
  diseaseVaccination(title: 'Disease Vaccination', icon: Icons.vaccines),
  behavioralTraining(title: 'Behavioral Training', icon: Icons.psychology);

  final String title;
  final IconData icon;

  const ResourceCategory({required this.title, required this.icon});
}
