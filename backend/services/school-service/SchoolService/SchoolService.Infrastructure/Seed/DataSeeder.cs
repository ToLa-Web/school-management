using Microsoft.EntityFrameworkCore;
using SchoolService.Domain.Entities;
using SchoolService.Infrastructure.Data;

namespace SchoolService.Infrastructure.Seed;

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
        await SeedClassroomsAsync();
        await SeedSubjectsAsync();
        await SeedSchedulesAsync();
        await SeedGradesAsync();
        await SeedAttendanceAsync();
    }

    private async Task SeedTeachersAsync()
    {
        if (await _context.Teachers.AnyAsync()) return;

        var t1 = new Teacher("John", "Smith");
        t1.UpdateBasicInfo("John", "Smith", "Male", null, "012-111-001", "teacher1@school.com", "Mathematics");

        var t2 = new Teacher("Sarah", "Lee");
        t2.UpdateBasicInfo("Sarah", "Lee", "Female", null, "012-111-002", "teacher2@school.com", "Science");

        var t3 = new Teacher("Mike", "Chen");
        t3.UpdateBasicInfo("Mike", "Chen", "Male", null, "012-111-003", "teacher3@school.com", "English");

        await _context.Teachers.AddRangeAsync(t1, t2, t3);
        await _context.SaveChangesAsync();
    }

    private async Task SeedStudentsAsync()
    {
        if (await _context.Students.AnyAsync()) return;

        // 45 students — 3 groups of 15 (one group per grade: 10, 11, 12)
        // Emails match auth service: student1@school.com … student45@school.com
        var names = new (string First, string Last, string Email)[]
        {
            // Grade 10 group (students 1-15)
            ("Alice",   "Johnson",  "student1@school.com"),  ("Bob",     "Smith",     "student2@school.com"),
            ("Chenda",  "Tola",     "student3@school.com"),  ("Diana",   "Green",     "student4@school.com"),
            ("Edward",  "Park",     "student5@school.com"),  ("Fiona",   "Brown",     "student6@school.com"),
            ("George",  "Wilson",   "student7@school.com"),  ("Hannah",  "Moore",     "student8@school.com"),
            ("Ivan",    "Taylor",   "student9@school.com"),  ("Jasmine", "Anderson",  "student10@school.com"),
            ("Kevin",   "Thomas",   "student11@school.com"), ("Linda",   "Jackson",   "student12@school.com"),
            ("Marcus",  "White",    "student13@school.com"), ("Nina",    "Harris",    "student14@school.com"),
            ("Oscar",   "Martin",   "student15@school.com"),
            // Grade 11 group (students 16-30)
            ("Paula",   "Garcia",   "student16@school.com"), ("Quinn",   "Martinez",  "student17@school.com"),
            ("Rachel",  "Robinson", "student18@school.com"), ("Samuel",  "Clark",     "student19@school.com"),
            ("Tina",    "Rodriguez","student20@school.com"), ("Uma",     "Lewis",     "student21@school.com"),
            ("Victor",  "Lee",      "student22@school.com"), ("Wendy",   "Walker",    "student23@school.com"),
            ("Xander",  "Hall",     "student24@school.com"), ("Yara",    "Allen",     "student25@school.com"),
            ("Zach",    "Young",    "student26@school.com"), ("Ava",     "Hernandez", "student27@school.com"),
            ("Brian",   "King",     "student28@school.com"), ("Cara",    "Wright",    "student29@school.com"),
            ("Derek",   "Lopez",    "student30@school.com"),
            // Grade 12 group (students 31-45)
            ("Ella",    "Hill",     "student31@school.com"), ("Felix",   "Scott",     "student32@school.com"),
            ("Grace",   "Green",    "student33@school.com"), ("Henry",   "Adams",     "student34@school.com"),
            ("Isabelle","Baker",    "student35@school.com"), ("Jake",    "Gonzalez",  "student36@school.com"),
            ("Karen",   "Nelson",   "student37@school.com"), ("Liam",    "Carter",    "student38@school.com"),
            ("Mia",     "Mitchell", "student39@school.com"), ("Nathan",  "Perez",     "student40@school.com"),
            ("Olivia",  "Roberts",  "student41@school.com"), ("Peter",   "Turner",    "student42@school.com"),
            ("Queenie", "Phillips", "student43@school.com"), ("Ryan",    "Campbell",  "student44@school.com"),
            ("Sofia",   "Parker",   "student45@school.com"),
        };

        var students = names.Select(n =>
        {
            var s = new Student(n.First, n.Last);
            s.UpdateBasicInfo(n.First, n.Last, null, null, null, null, n.Email);
            return s;
        }).ToList();
        await _context.Students.AddRangeAsync(students);
        await _context.SaveChangesAsync();
    }

    private async Task SeedClassroomsAsync()
    {
        if (await _context.Classrooms.AnyAsync()) return;

        var teachers = await _context.Teachers.OrderBy(t => t.Email).ToListAsync();
        var students = await _context.Students.ToListAsync();

        if (teachers.Count < 3) return;

        // teacher1 → Grade 10 (A, B, C)
        // teacher2 → Grade 11 (A, B, C)
        // teacher3 → Grade 12 (A, B, C)
        var classData = new[]
        {
            (Name: "Class 10-A", Grade: "10",  TeacherIdx: 0),
            (Name: "Class 10-B", Grade: "10",  TeacherIdx: 0),
            (Name: "Class 10-C", Grade: "10",  TeacherIdx: 0),
            (Name: "Class 11-A", Grade: "11",  TeacherIdx: 1),
            (Name: "Class 11-B", Grade: "11",  TeacherIdx: 1),
            (Name: "Class 11-C", Grade: "11",  TeacherIdx: 1),
            (Name: "Class 12-A", Grade: "12",  TeacherIdx: 2),
            (Name: "Class 12-B", Grade: "12",  TeacherIdx: 2),
            (Name: "Class 12-C", Grade: "12",  TeacherIdx: 2),
        };

        // 45 students split into 3 groups of 15 (one group per grade)
        const int studentsPerClass = 15;
        const int classesPerGrade  = 3;
        var enrollments = new List<StudentClassroom>();

        for (int ci = 0; ci < classData.Length; ci++)
        {
            var cd  = classData[ci];
            var cls = new Classroom(cd.Name);
            cls.UpdateInfo(cd.Name, cd.Grade, "2025-2026");
            cls.AssignTeacher(teachers[cd.TeacherIdx].Id);
            await _context.Classrooms.AddAsync(cls);
            await _context.SaveChangesAsync();

            // Each grade group of 15 students is shared across its 3 classes
            // Grade group index: 0 = students 0-14, 1 = students 15-29, 2 = students 30-44
            int gradeGroupStart = cd.TeacherIdx * studentsPerClass;
            for (int si = 0; si < studentsPerClass; si++)
            {
                int studentIdx = gradeGroupStart + si;
                if (studentIdx < students.Count)
                    enrollments.Add(new StudentClassroom(students[studentIdx].Id, cls.Id));
            }
        }

        await _context.StudentClassrooms.AddRangeAsync(enrollments);
        await _context.SaveChangesAsync();
    }

    private async Task SeedSubjectsAsync()
    {
        if (await _context.Subjects.AnyAsync()) return;

        var subjectNames = new[] { "Mathematics", "Science", "English", "History", "Physical Education" };
        var subjects = subjectNames.Select(n => new Subject(n)).ToList();

        await _context.Subjects.AddRangeAsync(subjects);
        await _context.SaveChangesAsync();

        // Assign teachers to subjects
        var teachers = await _context.Teachers.OrderBy(t => t.Email).ToListAsync();
        if (teachers.Count >= 3)
        {
            // teacher1 (John)  → Mathematics, Physics
            // teacher2 (Sarah) → Science, Biology
            // teacher3 (Mike)  → English, History
            var pairs = new List<(Guid TeacherId, Guid SubjectId)>
            {
                (teachers[0].Id, subjects[0].Id), // John  → Mathematics
                (teachers[0].Id, subjects[1].Id), // John  → Science
                (teachers[1].Id, subjects[2].Id), // Sarah → English
                (teachers[1].Id, subjects[3].Id), // Sarah → History
                (teachers[2].Id, subjects[4].Id), // Mike  → Physical Education
            };

            foreach (var (tid, sid) in pairs)
                await _context.TeacherSubjects.AddAsync(new TeacherSubject(tid, sid));

            await _context.SaveChangesAsync();
        }
    }

    private async Task SeedSchedulesAsync()
    {
        if (await _context.Schedules.AnyAsync()) return;

        var classroom = await _context.Classrooms.FirstOrDefaultAsync();
        var subjects = await _context.Subjects.ToListAsync();
        var teacher = await _context.Teachers.FirstOrDefaultAsync();

        if (classroom == null || subjects.Count < 3) return;

        var slots = new List<(string Day, string Time, int SubjectIdx)>
        {
            ("Monday",    "08:00-09:30", 0),
            ("Monday",    "10:00-11:30", 1),
            ("Tuesday",   "08:00-09:30", 2),
            ("Wednesday", "08:00-09:30", 0),
            ("Thursday",  "08:00-09:30", 3),
            ("Friday",    "08:00-09:30", 4),
        };

        foreach (var (day, time, idx) in slots)
        {
            if (idx >= subjects.Count) continue;
            var schedule = new Schedule(classroom.Id, subjects[idx].Id, teacher?.Id, day, time);
            await _context.Schedules.AddAsync(schedule);
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
            foreach (var subject in subjects.Take(3))
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

        var students = await _context.Students.ToListAsync();
        var classroom = await _context.Classrooms.FirstOrDefaultAsync();

        if (students.Count == 0 || classroom == null) return;

        var today = DateOnly.FromDateTime(DateTime.UtcNow);
        var statuses = new[] { AttendanceStatus.Present, AttendanceStatus.Present, AttendanceStatus.Late, AttendanceStatus.Absent };

        for (var i = 0; i < 5; i++)
        {
            var date = today.AddDays(-i);
            foreach (var student in students)
            {
                var status = statuses[(i + students.IndexOf(student)) % statuses.Length];
                await _context.Attendances.AddAsync(new Attendance(student.Id, classroom.Id, date, status));
            }
        }

        await _context.SaveChangesAsync();
    }
}
