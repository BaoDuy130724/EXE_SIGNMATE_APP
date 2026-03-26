# SignMate Backend API Endpoints

This document contains all the REST API endpoints extracted from the `SignMate_BE` C# backend. It serves as a reference for integrating APIs into the `sign_language_app` Flutter project.

## 1. Authentication (`/api/auth`)
* **POST** `/api/auth/register` - Register a new user
* **POST** `/api/auth/login` - Login to get tokens
* **POST** `/api/auth/refresh` - Refresh access token
* **POST** `/api/auth/logout` - Logout and invalidate token (Requires Auth)
* **POST** `/api/auth/forgot-password` - Request a password reset email
* **POST** `/api/auth/reset-password` - Reset password using the code
* **POST** `/api/auth/change-password` - Change password for logged-in user (Requires Auth)

## 2. Users (`/api/users`)
* **GET** `/api/users/me` - Get current user profile (Requires Auth)
* **PUT** `/api/users/me` - Update current user profile (Requires Auth)
* **GET** `/api/users/me/streak` - Get current user's learning streak (Requires Auth)
* **GET** `/api/users/me/achievements` - Get current user's achievements (Requires Auth)

## 3. Courses (`/api/courses`)
* **GET** `/api/courses` - List courses (supports `?search=` and `?level=`)
* **GET** `/api/courses/{id}` - Get standard course details by ID
* **POST** `/api/courses` - Create a new course (Teacher, Admin)
* **PUT** `/api/courses/{id}` - Update a course (Teacher, Admin)
* **GET** `/api/courses/{id}/lessons` - Get all lessons for a specific course

## 4. Lessons (`/api/lessons`)
* **GET** `/api/lessons/{id}` - Get lesson details by ID

## 5. Enrollments (`/api/enrollments`)
* **POST** `/api/enrollments` - Enroll in a course (Requires Auth)
* **GET** `/api/enrollments/me` - Get current user's enrolled courses and progress (Requires Auth)

## 6. Progress & Tracking (`/api/progress`)
* **PUT** `/api/progress/lesson` - Update lesson progress (Status, Duration) (Requires Auth)
* **PUT** `/api/progress/sign` - Update individual sign mastery progress (Requires Auth)

## 7. Practice Sessions (`/api/practice`)
* **POST** `/api/practice/session/start` - Start a practice session (Requires Auth)
* **POST** `/api/practice/attempt` - Submit a practice attempt video (`multipart/form-data`) (Requires Auth)
* **POST** `/api/practice/session/end` - End a practice session (Requires Auth)
* **GET** `/api/practice/history/{signId}` - Get practice history for a specific sign (Requires Auth)

## 8. Dashboard (`/api/dashboard`)
* **GET** `/api/dashboard` - Get general user dashboard summary (Requires Auth)
* **GET** `/api/dashboard/progress` - Get specific progress statistics (Requires Auth)

## 9. Games (`/api/games`)
* **POST** `/api/games/start` - Start a mini-game session (Requires Auth)
* **POST** `/api/games/complete` - Complete a game session to earn points/rewards (Requires Auth)

## 10. Subscriptions (`/api`)
* **GET** `/api/plans` - Get all available subscription plans
* **POST** `/api/subscription/subscribe` - Subscribe to a plan (Requires Auth)
* **GET** `/api/subscription/me` - Get current user's subscription details (Requires Auth)

## 11. Notifications (`/api/notifications`)
* **GET** `/api/notifications` - Get paginated notifications (Requires Auth)
* **PUT** `/api/notifications/{id}/read` - Mark a specific notification as read (Requires Auth)

## 12. Onboarding (`/api/onboarding`)
* **POST** `/api/onboarding` - Submit initial user onboarding preferences (Requires Auth)

## 13. Center & B2B Management
* **POST** `/api/b2b/contact` - Submit a B2B contact lead form
* **GET** `/api/centers` - Get all educational centers (SuperAdmin)
* **POST** `/api/centers` - Create a center (SuperAdmin)
* **GET** `/api/centers/{id}/dashboard` - Get center dashboard stats (SuperAdmin, CenterAdmin)

## 14. Classes (Centers)
* **GET** `/api/centers/{centerId}/classes` - Get classes in a center (CenterAdmin, Teacher)
* **POST** `/api/centers/{centerId}/classes` - Create a class (CenterAdmin)
* **POST** `/api/centers/{centerId}/classes/{classId}/students` - Add students to class (CenterAdmin)
* **GET** `/api/centers/{centerId}/classes/{classId}/students` - Get students in class (CenterAdmin, Teacher)
* **POST** `/api/centers/{centerId}/classes/{classId}/lessons` - Assign a lesson to class (CenterAdmin, Teacher)

## 15. Teachers & Tracking
* **POST** `/api/teacher/comments` - Add teacher comment to student (CenterAdmin, Teacher)
* **GET** `/api/teacher/students/{studentId}/comments` - Get comments for a student (CenterAdmin, Teacher)
* **GET** `/api/tracking/classes/{classId}/students` - Track class analytics (CenterAdmin, Teacher)
* **GET** `/api/tracking/centers/{centerId}/reports` - Generate center reports (CenterAdmin)
