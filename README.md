VARDIGO — Kısa Case

Flutter + PHP + SQLite implementation of the VARDIGO short case.
The application reproduces the two requested mobile screens and connects them to a real REST API with persistent SQLite storage.

1. Tech Stack

----Frontend-----

- Flutter
- Dart
- flutter_bloc
- HTTP REST API
- Urbanist font
- SVG assets

-----Backend----

- PHP 8.5
- SQLite
- REST API
- JSON seed data

2. Project Structure

vardigo/
│
├── frontend/
│   ├── lib/
│   │   ├── blocs/
│   │   ├── models/
│   │   ├── services/
│   │   ├── views/
│   │   └── utils/
│   ├── assets/
│   └── pubspec.yaml
│
├── backend/
│   ├── data/
│   │   ├── seed.json
│   │   └── vardigo.sqlite
│   ├── public/
│   │   └── index.php
│   ├── src/
│   │   ├── config/
│   │   ├── controllers/
│   │   └── middleware/
│   └── seed.php
│
├── README.md
└── SUREC.txt

3. Requirements

Make sure the following are installed:

- Flutter SDK
- Dart SDK
- PHP 8.5+
- SQLite / PHP SQLite extension

Check the installations:

flutter --version
php --version

The PHP installation must have the following extensions enabled:

pdo_sqlite
sqlite3

4. Backend Setup

Open a terminal in the backend directory:

cd backend

If the database needs to be initialized from the seed data:

php seed.php

Start the PHP development server:

php -S localhost:8000 -t public

The API will then be available at:

http://localhost:8000

5. Frontend Setup

Open another terminal in the Flutter project:

cd frontend

Install dependencies:

flutter pub get

Run the application:

flutter run

API Base URL

The frontend API URL is configured in:

lib/utils/global_params.dart

For example:

static const String baseUrl = 'http://localhost:8000/';

When using an Android emulator, use the host machine address supported by the emulator, for example:

http://10.0.2.2:8000/

6. Demo Accounts

SMS authentication is not implemented because it is not required for the case.

Two fixed demo roles are used:

Employer

{
  "role": "employer"
}

Worker

{
  "role": "worker"
}

Login endpoint:

POST /auth/login
Content-Type: application/json

Example:

{
  "role": "employer"
}

The API returns a development token that is then used with:

Authorization: Bearer <token>

7. API Endpoints

Get candidates

GET /candidates
Authorization: Bearer <employer-token>

Optional parameters:

GET /candidates?tab=perfect&sort=recommended
GET /candidates?tab=similar&sort=near
GET /candidates?tab=perfect&sort=rating

The API returns the candidate list together with the matching counters.

Send interview requests

POST /offers
Authorization: Bearer <employer-token>
Content-Type: application/json

Example:

{
  "workerIds": ["worker-001", "worker-002"]
}

The selected workers receive interview requests.

Get interview requests

GET /offers?status=pending
Authorization: Bearer <worker-token>

Available statuses:

pending
answered
expired

Accept an interview request

POST /offers/{id}/accept
Authorization: Bearer <worker-token>

Reject an interview request

POST /offers/{id}/reject
Authorization: Bearer <worker-token>

8. Application Flow

Employer flow

1. Login as employer.
2. Open Eşleşen Personeller.
3. View candidates returned by the API.
4. Switch between:
   - "%100 Eşleşme"
   - "Benzer Personeller"
5. Select one or more candidates.
6. Press the interview request CTA.
7. The selected workers are saved through "POST /offers".

Worker flow

1. Login as worker.
2. Open Görüşme Talepleri.
3. View requests under:
   - "Bekleyen"
   - "Cevaplanan"
   - "Süresi Dolan"
4. Open the request details if needed.
5. Choose:
   - "İlgileniyorum"
   - "İlgilenmiyorum"
6. The decision is persisted in SQLite.
7. Refreshing the application keeps the updated status.

9. Matching Logic

Candidates are classified according to their score:

score >= 80 → %100 Eşleşme
score < 80  → Benzer Personeller

Candidate selection is handled on the client side until the user sends the interview requests.

The actual request is then persisted by the backend.

10. Expiration Logic

An interview request is considered expired when:

expiresAt < current time

Expired requests are returned through:

GET /offers?status=expired

11. Persistence

SQLite is used as the local backend database.

The following actions are persistent:

- Interview requests
- Accept actions
- Reject actions
- Request status changes

Therefore, refreshing the application does not reset the worker's decision.

12. Error Handling

The API returns appropriate HTTP 4xx responses for invalid requests.

Examples include:

Empty selection

POST /offers

with no workers selected returns a client error.

Invalid worker ID

Sending a request for a worker that does not exist returns a client error with an explanatory message.

Invalid offer ID

Accepting or rejecting a non-existing offer returns a client error.

13. Design Implementation

The UI was implemented based on the provided reference PNGs and specifications.

Priority used during implementation:

1. Reference PNG
2. Design tokens
3. Screen specifications
4. Provided assets

The target viewport is:

390 × 844

The application uses:

- Urbanist typography
- Provided colors and spacing tokens
- Provided icons and assets
- Matching card radius and shadows
- Selected candidate state with the blue left indicator
- Tab pills
- Bottom CTA layout

14. Testing the Complete Flow

To test the complete case:

Step 1

Start the backend:

cd backend
php -S localhost:8000 -t public

Step 2

Start Flutter:

cd frontend
flutter pub get
flutter run

Step 3

Login as employer.

Step 4

Select one or more candidates from Eşleşen Personeller.

Step 5

Send an interview request.

Step 6

Open Görüşme Talepleri as the worker.

Step 7

Verify that the request appears under Bekleyen.

Step 8

Accept or reject the request.

Step 9

Refresh/reopen the screen and verify that the decision remains under Cevaplanan.

15. Notes

This implementation focuses on the requirements of the short case.

SMS authentication, production authentication infrastructure, push notifications, and a production database such as PostgreSQL are intentionally not implemented because they are outside the scope of the requested case.