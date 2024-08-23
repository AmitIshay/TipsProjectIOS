### TipMaster iOS App - README

[Watch the trailer on YouTube](https://youtu.be/u4bTiQeWU1E)


## Overview
TipMaster is an iOS application designed to help restaurant managers and employees easily calculate and distribute tips based on the hours worked by each employee.


The app integrates with Firebase for user authentication and data storage, allowing users to securely save and retrieve their worker data.

## Features
User Authentication: Sign up and log in with email and password using Firebase Authentication.


Add New Workers: Add workers with their name, role, and starting time. Available roles include Bartender and Waiter.


Tip Calculation: Automatically calculate tips based on the total hours worked and the total tip amount entered.


Persistent Storage: Save and load worker data to/from Firebase Realtime Database for each authenticated user.


Edit and Delete Workers: Modify or remove workers from the list and update the total hours and tip distribution accordingly.


Responsive UI: Intuitive and responsive user interface optimized for various iOS devices.


## Project Structure


AppDelegate.swift: Handles app lifecycle events and ensures data is saved to Firebase when the app enters the background or is terminated.


AddWorkerViewController.swift: Allows users to add a new worker, select their role, and set their starting time.


ListViewController.swift: Displays the list of workers, calculates and displays total hours worked, and distributes tips based on hours worked.


CreateAccountViewController.swift: Handles user sign-up functionality.


LoginViewController.swift: Handles user login functionality.

## Usage


Sign Up / Login: Start by signing up or logging in with your email and password.


Add Workers: Navigate to the worker list and tap the "Add" button to add a new worker. Enter the worker's name, select their role, and set their starting time.


Calculate Tips: Enter the total tip amount and tap "Calculate" to distribute the tips among workers based on the hours they worked.


View and Manage Workers: View the list of workers, edit their details, or delete them as needed. The total hours and tip distribution will update automatically.
