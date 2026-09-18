# EduVerse AI — Security Threat Model & Verification Matrix
Standards Baseline: OWASP ASVS 5.0 and OWASP API Security Top 10

## 1. Threat Modeling Overview

| Threat Category (STRIDE) | Attack Vector | Potential Impact | EduVerse AI Mitigation Control |
| :--- | :--- | :--- | :--- |
| Spoofing | Brute Force on login | Account takeover | Rate-limiting, progressive delays, 6-digit email OTP verification. |
| Tampering | Modifying JWT payload | Privilege escalation | Cryptographic signature verification on backend invalidates tampered tokens. |
| Information Disclosure | Passwords leaking in server logs | Credential exposure | Passwords stripped from application logging; sanitized error messages. |
| Elevation of Privilege | BOLA/IDOR | Student reading other students' data or admin endpoints | Strict PostgreSQL Row-Level Security (RLS) policies enforcing auth.uid() = user_id. |
| Denial of Service | Flooding OTP generation | Resource exhaustion | Cooldown timers on resend OTP and Supabase per-IP request throttling. |

## 2. OWASP API Security Top 10 Verification Matrix

### API 1: Broken Object Level Authorization (BOLA)
- Attack Scenario: Student A queries grades of Student B.
- Control: PostgreSQL Row Level Security enforces user ownership:
  CREATE POLICY "Users can only view own profile" ON public.profiles FOR SELECT USING (auth.uid() = id);
- Expected Response: 403 Forbidden or empty dataset.

### API 2: Broken Authentication
- Attack Scenario: Attacker presents expired or forged JWT.
- Control: Go backend middleware parses JWT header, verifies signature using shared secret, checks expiration timestamp.
- Expected Response: 401 Unauthorized.

### API 3: Broken Function Level Authorization (BFLA)
- Attack Scenario: Student user attempts to invoke administrative endpoints.
- Control: Role verification middleware checks that claims["role"] == "Administrator".
- Expected Response: 403 Forbidden.

## 3. Password & Secret Storage Compliance (OWASP ASVS V2 & V6)
- Zero Plaintext Rule: No plaintext passwords stored in PostgreSQL or logged.
- Hashing Standard: Argon2id / Bcrypt with salt managed by Supabase GoTrue.
- Secret Separation: All sensitive keys kept in environment variables and excluded from Git commits.
