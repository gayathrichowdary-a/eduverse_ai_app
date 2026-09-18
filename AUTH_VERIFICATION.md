\# EduVerse AI — Authentication \& Authorization Verification Audit

Standard: OWASP ASVS 5.0 (Verification Level 2)



\## 1. Auth Service — Definition of Done Checklist



| Verification Item | Requirement | Status | Evidence / Implementation |

| :--- | :--- | :---: | :--- |

| \*\*User Registration\*\* | Signup creates unverified state until OTP entry | \[x] PASSED | Verified via `\_supabase.auth.signInWithOtp()` |

| \*\*Duplicate Prevention\*\* | Duplicate email rejected by database | \[x] PASSED | PostgreSQL `auth.users.email` has UNIQUE constraint |

| \*\*Password Hashing\*\* | Password never stored in plaintext | \[x] PASSED | Hashed via Argon2id/Bcrypt before database commit |

| \*\*Password Verification\*\*| Incorrect password produces 401 | \[x] PASSED | Verified via `signInWithPassword()` |

| \*\*Unknown User Check\*\* | Unknown email/user rejected | \[x] PASSED | Handled via AuthException response |

| \*\*JWT Generation\*\* | Signed JWT issued upon successful authentication| \[x] PASSED | Validated RS256/HS256 tokens issued by Supabase |

| \*\*JWT Expiration\*\* | Expiration timestamp enforced | \[x] PASSED | Exp claim verified by client SDK and Go server |

| \*\*Token Tampering\*\* | Modified JWT payload rejected | \[x] PASSED | Signature validation failure triggers 401 |

| \*\*Role Route Isolation\*\* | Strict role-based navigation guards | \[x] PASSED | Student -> Onboarding; Teacher/School/Parent/Admin -> dedicated hubs |

| \*\*Cross-Tenant Access\*\* | User cannot read/write another user's profile | \[x] PASSED | Enforced via PostgreSQL Row-Level Security (RLS) |

| \*\*Session Invalidation\*\*| Logout revokes session and clears local tokens | \[x] PASSED | `\_supabase.auth.signOut()` clears keystore session |

| \*\*Sanitized Errors\*\* | Error messages do not leak server secrets | \[x] PASSED | Standardized UI snackbars and client error DTOs |

| \*\*Zero Git Secrets\*\* | Production keys excluded from Git repository | \[x] PASSED | Managed via environment variables and `.gitignore` |



\## 2. Database Constraints Verification (PostgreSQL)



```sql

\-- Schema verification of public.profiles

CREATE TABLE IF NOT EXISTS public.profiles (

&#x20;   id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,

&#x20;   email TEXT NOT NULL UNIQUE,

&#x20;   full\_name TEXT NOT NULL,

&#x20;   role TEXT NOT NULL CHECK (role IN ('Student', 'Teacher', 'Parent', 'School', 'Administrator')),

&#x20;   school\_name TEXT,

&#x20;   branch TEXT,

&#x20;   date\_of\_birth TIMESTAMP WITH TIME ZONE,

&#x20;   unique\_code TEXT,

&#x20;   child\_code TEXT,

&#x20;   created\_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,

&#x20;   updated\_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL

);



\-- Row Level Security (RLS)

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;



CREATE POLICY "Allow users to read own profile"

&#x20;   ON public.profiles FOR SELECT

&#x20;   USING (auth.uid() = id);



CREATE POLICY "Allow users to update own profile"

&#x20;   ON public.profiles FOR UPDATE

&#x20;   USING (auth.uid() = id);

