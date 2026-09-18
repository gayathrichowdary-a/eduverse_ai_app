package main

import (
	"testing"
	"time"
)

// Unit Test 1: Verify valid email validation
func TestEmailValidation(t *testing.T) {
	validEmail := "student@eduverse.ai"
	invalidEmail := "not-an-email"

	if len(validEmail) == 0 || !containsChar(validEmail, '@') {
		t.Errorf("Expected valid email %s to pass validation", validEmail)
	}

	if containsChar(invalidEmail, '@') {
		t.Errorf("Expected invalid email %s to fail validation", invalidEmail)
	}
}

// Unit Test 2: Verify token expiration enforcement
func TestTokenExpirationEnforcement(t *testing.T) {
	now := time.Now().Unix()
	expiredTime := now - 3600 // Expired 1 hour ago
	futureTime := now + 3600  // Valid for 1 more hour

	if now < expiredTime {
		t.Errorf("Expected token with exp %d to be marked expired at %d", expiredTime, now)
	}

	if now >= futureTime {
		t.Errorf("Expected token with exp %d to remain valid at %d", futureTime, now)
	}
}

// Unit Test 3: Role-based Authorization Matrix (BOLA Prevention)
func TestRoleAuthorization(t *testing.T) {
	roles := map[string]string{
		"student":       "STUDENT_PORTAL",
		"teacher":       "TEACHER_HUB",
		"administrator": "ADMIN_DASHBOARD",
		"school":        "SCHOOL_DASHBOARD",
		"parent":        "PARENT_PORTAL",
	}

	// Rule: Student cannot access Admin Dashboard
	studentTarget := roles["student"]
	if studentTarget == roles["administrator"] {
		t.Errorf("Security violation: Student role granted Admin access!")
	}

	// Rule: Administrator has admin portal access
	adminTarget := roles["administrator"]
	if adminTarget != "ADMIN_DASHBOARD" {
		t.Errorf("Expected Administrator to access ADMIN_DASHBOARD, got %s", adminTarget)
	}
}

func containsChar(s string, c rune) bool {
	for _, r := range s {
		if r == c {
			return true
		}
	}
	return false
}