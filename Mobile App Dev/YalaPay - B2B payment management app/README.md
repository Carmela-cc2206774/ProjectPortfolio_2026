YalaPay is a B2B payment management application designed to streamline invoice tracking, payments, and cheque cashing between companies and their customers.

# Project Phase 1

Phase 1 focused on designing and implementing the UI of the YalaPay application using a file-based approach. The goal of this phase was to validate the overall structure, user flows, and feature completeness of the system without relying on a real database.

This phase included:
- Designing and implementing responsive UI screens for all core use cases
- Setting up application navigation and user flows
- Implementing entities and repositories using Dart
- Handling data using in-memory structures and local JSON files
- Testing the UI and logic through screenshots

A lot of time was spent experimenting with different UI/UX designs in this phase. Some of these designs were later refined or removed in Phase 2 once the data layer was introduced.

Notes:
- No sign-up functionality was required or implemented in Phase 1
- Dashboard values were only populated using dummy data
- Phase 1 served as a foundation to test logic, navigation, and usability before database integration

# Project Phase 2

Our Phase 2 focused on adding data persistence and improving backend robustness. The file-based storage from Phase 1 was replaced with Firestore, Firebase Authentication, Firebase Storage, and a local SQLite database.

This phase included:
- Designing Firestore and SQLite database schemas
- Implementing signup and signin using Firebase Authentication
- Connecting repositories and providers to real data sources
- Supporting cheque image uploads using Firebase Storage
- Re-testing all existing features with persistent data

All features from Phase 1 were retained, but enhanced to work with real databases instead of JSON files. Phase 2 represents the transition from a UI-focused prototype to a fully data-driven application.
