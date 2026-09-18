# EduVerse AI — System Architecture & Trust Boundaries

## 1. System Overview & Component Diagram

+-------------------------------------------------------------+
|                     Presentation Layer                      |
|           Flutter Client (Web, Android APK, Desktop)        |
+------------------------------+------------------------------+
                               |
               +---------------+---------------+
               | HTTPS                         | HTTPS (REST API)
               v                               v
+------------------------------+ +------------------------------+
|     Identity & Auth Provider | |    Backend Microservice      |
|    Supabase Cloud (GoTrue)   | |      Go (Gin Framework)      |
|  - Password Hashing (Argon2) | |      Port: 8080              |
|  - Email OTP Delivery        | |  - Course Synthesizer Engine |
|  - JWT Issuer & Session Mgmt | |  - TTS & Media Audio Pipeline|
+--------------+---------------+ +--------------+---------------+
               |                               |
               +---------------+---------------+
                               |
                               v
+-------------------------------------------------------------+
|                       Persistence Layer                      |
|                  Supabase Managed PostgreSQL                |
|  - Table: `profiles` (id [FK->auth.users], role, metadata)  |
|  - Table: `courses`, `quizzes`, `user_progress`             |
|  - Row-Level Security (RLS) policies                        |
+-------------------------------------------------------------+

## 2. Core Architectural Ownership & Boundaries

### 1. Who owns the database?
- **Owner**: Managed Supabase PostgreSQL instance.
- **Access Boundary**: Client interacts through authenticated PostgREST API with JWT validation. Direct database mutations are protected by Row-Level Security (RLS). Service-level background jobs use least-privilege service keys.

### 2. Who issues tokens?
- **Issuer**: Supabase GoTrue Auth Service.
- **Token Type**: Cryptographically signed RS256 / HS256 JSON Web Tokens (JWT).
- **Claims Schema**:
  - `sub`: Unique User UUID.
  - `email`: User verified email address.
  - `role`: Role identifier (`Student`, `Teacher`, `Parent`, `School`, `Administrator`).
  - `exp`: Expiration timestamp (strictly enforced).
  - `iss`: Supabase project authentication authority.

### 3. Who verifies tokens?
- **Client Side**: Flutter Supabase client SDK validates token presence, handles silent refresh token rotation, and detects session termination.
- **Backend Microservice (Go)**: Validates incoming `Authorization: Bearer <token>` headers on `/api/*` endpoints, cryptographically verifying signature against Supabase JWT secret and checking expiration before granting access.

### 4. Where are refresh tokens stored?
- **Mobile (Android APK)**: Encrypted SharedPreferences / Android Keystore (`flutter_secure_storage`).
- **Web**: HTTP-only secure cookie / secure browser storage.
- **Strategy**: Single-use token rotation. Upon reuse detection, the entire token family is revoked immediately.

### 5. Who owns user identity?
- **Owner**: `auth.users` system catalog in Supabase.
- **Password Safety**: Passwords are never stored in plaintext and never logged. Hashed using modern memory-hard password derivation (Argon2id / Bcrypt).

### 6. Where are roles stored?
- **Primary Source of Truth**: The `profiles` table (`profiles.role`) in PostgreSQL with a strict `NOT NULL` constraint.
- **Fast-Path Cache**: Embedded inside user metadata (`user_metadata['role']`) in the JWT claim to eliminate redundant database roundtrips during routing.

### 7. Who performs authorization?
- **Client Route Guards**: UI-level navigation guards in Flutter (`OtpVerificationPage`, `LoginPage`, `SuccessPage`) guarantee actors only reach permitted entry points:
  - `Student` -> `OnboardingStudentInformation`
  - `Teacher` -> `TeacherPortalHub`
  - `Parent` -> `ParentHomeDashboard`
  - `School` -> `SchoolDashboard`
  - `Administrator` -> `AdminDashboard`
- **Data Authorization**: PostgreSQL Row Level Security (RLS) ensures users can only read and write records where `auth.uid() = user_id`.
