# Student Role Website Implementation Brief

Captured on 2026-04-11 from the implementation request for the new student portal in `admin-web`.

## Goal

Implement a student-facing role portal in the existing Next.js application by following the same architectural patterns, route structure, and visual language used by the admin web panel.

## Required Routes

- `/student/dashboard`
- `/student/academics`
- `/student/academics/[id]`
- `/student/grades`
- `/student/schedules`
- `/student/attendance`
- `/student/assignments`
- `/student/materials`
- `/student/announcements`
- `/student/profile`
- `/student/profile/edit`
- `/student/profile/security`

## Architecture Notes

- Use Next.js App Router patterns already present in the project.
- Keep student pages under `src/app/(dashboard)/student/*`.
- Add reusable components under `src/components` with `Student*` prefixes.
- Extend the shared API/auth layer rather than creating a separate networking stack.
- Protect all student routes with `useAuth([2])`.
- Redirect authenticated students to `/student/dashboard`.
- Persist auth state with `localStorage` and keep auto-refresh-on-401 behavior.

## UX Expectations

- Reuse the existing school/admin palette and card system.
- Keep the sidebar + main content shell consistent with the current admin and teacher experiences.
- Use white cards with subtle borders/shadows, Tailwind spacing, and Lucide icons.
- Provide breadcrumbs, loading states, empty states, sortable tables, status badges, and meaningful error handling.
- Maintain responsive behavior for mobile and desktop.

## Student Features

- Dashboard: GPA, attendance, assignment summary, recent grades, next classes, recent announcements.
- Academics: enrolled courses, subject detail, materials, grades, class roster.
- Grades: transcript filters, GPA summary, trend chart, exports.
- Schedules: calendar/list view plus iCal export.
- Attendance: totals, rate, trend, alerts, filterable history.
- Assignments: browsing, status tracking, detail view, submission flow.
- Materials: search and filter course materials by subject/type/date.
- Announcements: list/detail views with read state.
- Profile: view/edit personal details and security settings.

## API Coverage Expected By The Request

- Student profile retrieval and updates.
- Student grades, attendance, schedules, materials, submissions, and announcements.
- Password change flow.
- Student-specific classroom/subject discovery.

## MVP Order

1. Dashboard
2. Academics
3. Grades
4. Attendance
5. Profile
6. Schedules
7. Materials
8. Assignments
9. Announcements
10. Export and analytics polish
