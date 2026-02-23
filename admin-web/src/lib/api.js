// All fetch calls go through Next.js rewrites → API Gateway → backend service
// Token is read from localStorage on every call so it's always fresh

function getToken() {
  if (typeof window === 'undefined') return null;
  return localStorage.getItem('token');
}

async function request(path, options = {}) {
  const token = getToken();
  const res = await fetch(path, {
    ...options,
    headers: {
      'Content-Type': 'application/json',
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
      ...options.headers,
    },
  });

  if (res.status === 401) {
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    window.location.href = '/login';
    return;
  }

  return res;
}

// ── Auth ──────────────────────────────────────────────────────────────────────

export async function login(email, password) {
  const res = await fetch('/api/auth/authenticate', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email, password }),
  });
  return res;
}

// ── Teachers ──────────────────────────────────────────────────────────────────

export async function getTeachers(page = 1, pageSize = 20) {
  const res = await request(`/api/school/teachers?page=${page}&pageSize=${pageSize}`);
  return res.ok ? res.json() : null;
}

export async function getTeacher(id) {
  const res = await request(`/api/school/teachers/${id}`);
  return res.ok ? res.json() : null;
}

export async function createTeacher(data) {
  return request('/api/school/teachers', {
    method: 'POST',
    body: JSON.stringify(data),
  });
}

export async function updateTeacher(id, data) {
  return request(`/api/school/teachers/${id}`, {
    method: 'PUT',
    body: JSON.stringify(data),
  });
}

export async function deleteTeacher(id) {
  return request(`/api/school/teachers/${id}`, { method: 'DELETE' });
}

// ── Classrooms ────────────────────────────────────────────────────────────────

export async function getClassrooms(page = 1, pageSize = 20) {
  const res = await request(`/api/school/classrooms?page=${page}&pageSize=${pageSize}`);
  return res.ok ? res.json() : null;
}

export async function getClassroom(id) {
  const res = await request(`/api/school/classrooms/${id}`);
  return res.ok ? res.json() : null;
}

export async function createClassroom(data) {
  return request('/api/school/classrooms', {
    method: 'POST',
    body: JSON.stringify(data),
  });
}

export async function updateClassroom(id, data) {
  return request(`/api/school/classrooms/${id}`, {
    method: 'PUT',
    body: JSON.stringify(data),
  });
}

export async function deleteClassroom(id) {
  return request(`/api/school/classrooms/${id}`, { method: 'DELETE' });
}

export async function enrollStudent(classroomId, studentId) {
  return request(`/api/school/classrooms/${classroomId}/enroll`, {
    method: 'POST',
    body: JSON.stringify({ studentId }),
  });
}

export async function unenrollStudent(classroomId, studentId) {
  return request(`/api/school/classrooms/${classroomId}/unenroll/${studentId}`, {
    method: 'DELETE',
  });
}

// ── Students ──────────────────────────────────────────────────────────────────

export async function getStudents(page = 1, pageSize = 20) {
  const res = await request(`/api/school/students?page=${page}&pageSize=${pageSize}`);
  return res.ok ? res.json() : null;
}

export async function getStudent(id) {
  const res = await request(`/api/school/students/${id}`);
  return res.ok ? res.json() : null;
}

export async function createStudent(data) {
  return request('/api/school/students', {
    method: 'POST',
    body: JSON.stringify(data),
  });
}

export async function updateStudent(id, data) {
  return request(`/api/school/students/${id}`, {
    method: 'PUT',
    body: JSON.stringify(data),
  });
}

export async function deleteStudent(id) {
  return request(`/api/school/students/${id}`, { method: 'DELETE' });
}

// ── Health ────────────────────────────────────────────────────────────────────

export async function getHealthDashboard() {
  const res = await request('/api/school/servicehealth/dashboard');
  return res.ok ? res.json() : null;
}
