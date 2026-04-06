using Microsoft.EntityFrameworkCore;
using SchoolService.Domain.Entities;
using SchoolService.Infrastructure.Data;

namespace SchoolService.Infrastructure.Seed;

// ─────────────────────────────────────────────────────────────────────────────
// School structure
// ─────────────────────────────────────────────────────────────────────────────
//  5 teachers (Cambodian names), each owns exactly 1 subject:
//    teacher1  Sopheak Meas    Mathematics
//    teacher2  Dara Chan       Science
//    teacher3  Bopha Sok       English
//    teacher4  Rithy Phal      History
//    teacher5  Sreyla Noun     Physical Education
//
//  3 classrooms, each with its own homeroom teacher and 5-subject weekly schedule:
//    Class 10-A  homeroom = Sopheak   15 students  (student1–15)
//    Class 11-A  homeroom = Dara      10 students  (student16–25)
//    Class 12-A  homeroom = Bopha      7 students  (student26–32)
// ─────────────────────────────────────────────────────────────────────────────

public class DataSeeder
{
    private readonly SchoolDbContext _context;

    public DataSeeder(SchoolDbContext context)
    {
        _context = context;
    }

    public async Task SeedDataAsync()
    {
        await SeedTeachersAsync();
        await SeedStudentsAsync();
        await SeedSubjectsAsync();        // must come before classrooms (needs subject IDs)
        await SeedClassroomsAsync();
        await SeedSchedulesAsync();
        await SeedGradesAsync();
        await SeedAttendanceAsync();
    }

    private async Task SeedTeachersAsync()
    {
        if (await _context.Teachers.AnyAsync()) return;

        // One teacher per subject — Cambodian names
        var teacherData = new[]
        {
            (First: "Sopheak", Last: "Meas",  Gender: "Male",   Phone: "012-201-0001", Email: "teacher1@school.com", Subject: "Mathematics"),
            (First: "Dara",    Last: "Chan",  Gender: "Male",   Phone: "012-201-0002", Email: "teacher2@school.com", Subject: "Science"),
            (First: "Bopha",   Last: "Sok",   Gender: "Female", Phone: "012-201-0003", Email: "teacher3@school.com", Subject: "English"),
            (First: "Rithy",   Last: "Phal",  Gender: "Male",   Phone: "012-201-0004", Email: "teacher4@school.com", Subject: "History"),
            (First: "Sreyla",  Last: "Noun",  Gender: "Female", Phone: "012-201-0005", Email: "teacher5@school.com", Subject: "Physical Education"),
        };

        var teachers = teacherData.Select(d =>
        {
            var t = new Teacher(d.First, d.Last);
            t.UpdateBasicInfo(d.First, d.Last, d.Gender, null, d.Phone, d.Email, d.Subject, null, null);
            return t;
        }).ToList();

        await _context.Teachers.AddRangeAsync(teachers);
        await _context.SaveChangesAsync();
    }

    private async Task SeedStudentsAsync()
    {
        if (await _context.Students.AnyAsync()) return;

        // 47 Cambodian students
        // Class 10-A: student1–15  (15 students)
        // Class 11-A: student16–25 (10 students)
        // Class 12-A: student26–32 ( 7 students)
        // Class 10-B: student33–41 ( 9 students)
        // Class 12-B: student42–47 ( 6 students)
        var students = new (string First, string Last, string Email, string Gender, string Phone)[]
        {
            // ── Class 10-A ─────────────────────────────────────────────────────
            ("Sokha",      "Chea",   "student1@school.com",  "Male",   "012-301-0001"),
            ("Sreymom",    "Keo",    "student2@school.com",  "Female", "012-301-0002"),
            ("Visal",      "Heng",   "student3@school.com",  "Male",   "012-301-0003"),
            ("Channary",   "Pov",    "student4@school.com",  "Female", "012-301-0004"),
            ("Dara",       "Lim",    "student5@school.com",  "Male",   "012-301-0005"),
            ("Pisey",      "Nget",   "student6@school.com",  "Female", "012-301-0006"),
            ("Raksmey",    "Sar",    "student7@school.com",  "Male",   "012-301-0007"),
            ("Sokunthea",  "Im",     "student8@school.com",  "Female", "012-301-0008"),
            ("Makara",     "Tep",    "student9@school.com",  "Male",   "012-301-0009"),
            ("Chanlina",   "Ros",    "student10@school.com", "Female", "012-301-0010"),
            ("Bunthan",    "Mok",    "student11@school.com", "Male",   "012-301-0011"),
            ("Socheata",   "Yem",    "student12@school.com", "Female", "012-301-0012"),
            ("Vutha",      "Kang",   "student13@school.com", "Male",   "012-301-0013"),
            ("Leakena",    "Suon",   "student14@school.com", "Female", "012-301-0014"),
            ("Piseth",     "Ouk",    "student15@school.com", "Male",   "012-301-0015"),
            // ── Class 11-A ─────────────────────────────────────────────────────
            ("Kosal",      "Prum",   "student16@school.com", "Male",   "012-301-0016"),
            ("Sreyroth",   "Pen",    "student17@school.com", "Female", "012-301-0017"),
            ("Bunna",      "Chhim",  "student18@school.com", "Male",   "012-301-0018"),
            ("Chanpov",    "Khiev",  "student19@school.com", "Female", "012-301-0019"),
            ("Sovann",     "Nhem",   "student20@school.com", "Male",   "012-301-0020"),
            ("Reaksmey",   "Tith",   "student21@school.com", "Female", "012-301-0021"),
            ("Kimlong",    "Srey",   "student22@school.com", "Male",   "012-301-0022"),
            ("Daravy",     "Hout",   "student23@school.com", "Female", "012-301-0023"),
            ("Mengly",     "Chan",   "student24@school.com", "Male",   "012-301-0024"),
            ("Sonika",     "Ung",    "student25@school.com", "Female", "012-301-0025"),
            // ── Class 12-A ─────────────────────────────────────────────────────
            ("Ratana",     "Khem",   "student26@school.com", "Male",   "012-301-0026"),
            ("Sophany",    "Loch",   "student27@school.com", "Female", "012-301-0027"),
            ("Bunthoeun",  "Meas",   "student28@school.com", "Male",   "012-301-0028"),
            ("Chanthy",    "Kem",    "student29@school.com", "Female", "012-301-0029"),
            ("Sovannara",  "Nou",    "student30@school.com", "Male",   "012-301-0030"),
            ("Kunthea",    "Sim",    "student31@school.com", "Female", "012-301-0031"),
            ("Phearak",    "Yun",    "student32@school.com", "Male",   "012-301-0032"),
            // ── Class 10-B ─────────────────────────────────────────────────────
            ("Thida",      "Kong",   "student33@school.com", "Female", "012-301-0033"),
            ("Sambo",      "Pich",   "student34@school.com", "Male",   "012-301-0034"),
            ("Sovannak",   "Eav",    "student35@school.com", "Male",   "012-301-0035"),
            ("Chhorvy",    "Mam",    "student36@school.com", "Female", "012-301-0036"),
            ("Davan",      "Som",    "student37@school.com", "Male",   "012-301-0037"),
            ("Sreyleak",   "Hak",    "student38@school.com", "Female", "012-301-0038"),
            ("Naro",       "Tan",    "student39@school.com", "Male",   "012-301-0039"),
            ("Phally",     "Din",    "student40@school.com", "Female", "012-301-0040"),
            ("Sothea",     "Vong",   "student41@school.com", "Male",   "012-301-0041"),
            // ── Class 12-B ─────────────────────────────────────────────────────
            ("Botum",      "Ly",     "student42@school.com", "Female", "012-301-0042"),
            ("Vicheka",    "Nop",    "student43@school.com", "Male",   "012-301-0043"),
            ("Sreynich",   "San",    "student44@school.com", "Female", "012-301-0044"),
            ("Kimsan",     "Koy",    "student45@school.com", "Male",   "012-301-0045"),
            ("Chanmoly",   "Tong",   "student46@school.com", "Female", "012-301-0046"),
            ("Rithy",      "Sorn",   "student47@school.com", "Male",   "012-301-0047"),
        };

        var entities = students.Select(n =>
        {
            var s = new Student(n.First, n.Last);
            s.UpdateBasicInfo(n.First, n.Last, n.Gender, null, n.Phone, null, n.Email);
            return s;
        }).ToList();

        await _context.Students.AddRangeAsync(entities);
        await _context.SaveChangesAsync();
    }

    private async Task SeedClassroomsAsync()
    {
        if (await _context.Classrooms.AnyAsync()) return;

        var teachers = await _context.Teachers.OrderBy(t => t.Email).ToListAsync();
        var students = await _context.Students.OrderBy(s => s.Email).ToListAsync();

        if (teachers.Count < 5 || students.Count < 47) return;

        // Homeroom teacher assignment:
        //   Class 10-A → Sopheak Meas  (teacher[0])
        //   Class 11-A → Dara Chan     (teacher[1])
        //   Class 12-A → Bopha Sok     (teacher[2])
        //   Class 10-B → Rithy Phal    (teacher[3])
        //   Class 12-B → Sreyla Noun   (teacher[4])
        var classData = new[]
        {
            (Name: "Class 10-A", Grade: "10", TeacherIdx: 0, StudentStart:  0, StudentCount: 15),
            (Name: "Class 11-A", Grade: "11", TeacherIdx: 1, StudentStart: 15, StudentCount: 10),
            (Name: "Class 12-A", Grade: "12", TeacherIdx: 2, StudentStart: 25, StudentCount:  7),
            (Name: "Class 10-B", Grade: "10", TeacherIdx: 3, StudentStart: 32, StudentCount:  9),
            (Name: "Class 12-B", Grade: "12", TeacherIdx: 4, StudentStart: 41, StudentCount:  6),
        };

        var enrollments = new List<StudentClassroom>();

        foreach (var cd in classData)
        {
            var cls = new Classroom(cd.Name);
            cls.UpdateInfo(cd.Name, cd.Grade, "2025-2026", null, null);
            cls.AssignTeacher(teachers[cd.TeacherIdx].Id);
            await _context.Classrooms.AddAsync(cls);
            await _context.SaveChangesAsync();

            for (int si = 0; si < cd.StudentCount; si++)
            {
                int idx = cd.StudentStart + si;
                if (idx < students.Count)
                    enrollments.Add(new StudentClassroom(students[idx].Id, cls.Id));
            }
        }

        await _context.StudentClassrooms.AddRangeAsync(enrollments);
        await _context.SaveChangesAsync();
    }

    private async Task SeedSubjectsAsync()
    {
        if (await _context.Subjects.AnyAsync()) return;

        // 5 subjects — one per teacher (order matches teacher email order)
        // Index 0 = Mathematics → teacher1 (Sopheak)
        // Index 1 = Science     → teacher2 (Dara)
        // Index 2 = English     → teacher3 (Bopha)
        // Index 3 = History     → teacher4 (Rithy)
        // Index 4 = Phys. Ed.   → teacher5 (Sreyla)
        var subjectNames = new[] { "Mathematics", "Science", "English", "History", "Physical Education" };
        var subjects = subjectNames.Select(n => new Subject(n)).ToList();

        await _context.Subjects.AddRangeAsync(subjects);
        await _context.SaveChangesAsync();

        var teachers = await _context.Teachers.OrderBy(t => t.Email).ToListAsync();
        if (teachers.Count >= 5)
        {
            // Each teacher owns exactly one subject
            for (int i = 0; i < 5; i++)
                await _context.TeacherSubjects.AddAsync(new TeacherSubject(teachers[i].Id, subjects[i].Id));

            await _context.SaveChangesAsync();
        }
    }

    private async Task SeedSchedulesAsync()
    {
        if (await _context.Schedules.AnyAsync()) return;

        var classrooms = await _context.Classrooms.OrderBy(c => c.Name).ToListAsync();
        var subjects   = await _context.Subjects.OrderBy(s => s.SubjectName).ToListAsync();
        var teachers   = await _context.Teachers.OrderBy(t => t.Email).ToListAsync();

        if (classrooms.Count < 3 || subjects.Count < 5 || teachers.Count < 5) return;

        // Weekly timetable: 5 subjects × 5 days, each taught by its own subject teacher
        // subjects are sorted alphabetically so map by SubjectName
        var byName = subjects.ToDictionary(s => s.SubjectName);
        var byTeacher = teachers; // ordered by email: [0]=teacher1…[4]=teacher5

        // (DayOfWeek, StartTime, EndTime, SubjectName, TeacherIdx)
        var slots = new[]
        {
            (Day: SchoolDayOfWeek.Monday,    Start: new TimeOnly(7,  0), End: new TimeOnly(8,  30), Subject: "Mathematics",        TIdx: 0),
            (Day: SchoolDayOfWeek.Monday,    Start: new TimeOnly(8, 45), End: new TimeOnly(10, 15), Subject: "Science",            TIdx: 1),
            (Day: SchoolDayOfWeek.Tuesday,   Start: new TimeOnly(7,  0), End: new TimeOnly(8,  30), Subject: "English",            TIdx: 2),
            (Day: SchoolDayOfWeek.Tuesday,   Start: new TimeOnly(8, 45), End: new TimeOnly(10, 15), Subject: "History",            TIdx: 3),
            (Day: SchoolDayOfWeek.Wednesday, Start: new TimeOnly(7,  0), End: new TimeOnly(8,  30), Subject: "Physical Education", TIdx: 4),
            (Day: SchoolDayOfWeek.Wednesday, Start: new TimeOnly(8, 45), End: new TimeOnly(10, 15), Subject: "Mathematics",        TIdx: 0),
            (Day: SchoolDayOfWeek.Thursday,  Start: new TimeOnly(7,  0), End: new TimeOnly(8,  30), Subject: "Science",            TIdx: 1),
            (Day: SchoolDayOfWeek.Thursday,  Start: new TimeOnly(8, 45), End: new TimeOnly(10, 15), Subject: "English",            TIdx: 2),
            (Day: SchoolDayOfWeek.Friday,    Start: new TimeOnly(7,  0), End: new TimeOnly(8,  30), Subject: "History",            TIdx: 3),
            (Day: SchoolDayOfWeek.Friday,    Start: new TimeOnly(8, 45), End: new TimeOnly(10, 15), Subject: "Physical Education", TIdx: 4),
        };

        // Create the same timetable for EVERY classroom
        foreach (var classroom in classrooms)
        {
            foreach (var slot in slots)
            {
                if (!byName.TryGetValue(slot.Subject, out var subject)) continue;
                var schedule = new Schedule(
                    classroom.Id,
                    subject.Id,
                    byTeacher[slot.TIdx].Id,
                    slot.Day,
                    slot.Start,
                    slot.End);
                await _context.Schedules.AddAsync(schedule);
            }
        }

        await _context.SaveChangesAsync();
    }

    private async Task SeedGradesAsync()
    {
        if (await _context.StudentGrades.AnyAsync()) return;

        var students = await _context.Students.ToListAsync();
        var subjects = await _context.Subjects.ToListAsync();

        if (students.Count == 0 || subjects.Count == 0) return;

        var rng = new Random(42);
        foreach (var student in students)
        {
            // Give every student a grade for every subject
            foreach (var subject in subjects)
            {
                var score = Math.Round((decimal)(rng.NextDouble() * 40 + 60), 2); // 60–100
                var grade = new StudentGrade(student.Id, subject.Id, score, "Semester 1");
                await _context.StudentGrades.AddAsync(grade);
            }
        }

        await _context.SaveChangesAsync();
    }

    private async Task SeedAttendanceAsync()
    {
        if (await _context.Attendances.AnyAsync()) return;

        // Load each classroom with its enrolled students
        var classrooms = await _context.Classrooms.ToListAsync();
        var enrollments = await _context.StudentClassrooms.ToListAsync();

        if (classrooms.Count == 0 || enrollments.Count == 0) return;

        var today = DateOnly.FromDateTime(DateTime.UtcNow);
        var statuses = new[] { AttendanceStatus.Present, AttendanceStatus.Present, AttendanceStatus.Late, AttendanceStatus.Absent };
        var rng = new Random(99);

        foreach (var classroom in classrooms)
        {
            var studentIds = enrollments
                .Where(e => e.ClassroomId == classroom.Id)
                .Select(e => e.StudentId)
                .ToList();

            for (int day = 0; day < 5; day++)
            {
                var date = today.AddDays(-day);
                for (int si = 0; si < studentIds.Count; si++)
                {
                    var status = statuses[(day + si) % statuses.Length];
                    await _context.Attendances.AddAsync(
                        new Attendance(studentIds[si], classroom.Id, date, status));
                }
            }
        }

        await _context.SaveChangesAsync();
    }
}
