-- Core identity and access

CREATE TABLE roles (
    id   BIGSERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO roles (name) VALUES ('PATIENT'), ('CLINICIAN'), ('ADMIN');

CREATE TABLE users (
    id            BIGSERIAL PRIMARY KEY,
    email         VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    mfa_enabled   BOOLEAN NOT NULL DEFAULT FALSE,
    enabled       BOOLEAN NOT NULL DEFAULT TRUE,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE user_roles (
    user_id BIGINT NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    role_id BIGINT NOT NULL REFERENCES roles (id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, role_id)
);

-- Profiles and care team

CREATE TABLE patient_profiles (
    id                 BIGSERIAL PRIMARY KEY,
    user_id            BIGINT NOT NULL UNIQUE REFERENCES users (id) ON DELETE CASCADE,
    first_name         VARCHAR(100) NOT NULL,
    last_name          VARCHAR(100) NOT NULL,
    date_of_birth      DATE,
    phone              VARCHAR(30),
    preferred_language VARCHAR(10) NOT NULL DEFAULT 'en',
    caregiver_name     VARCHAR(200),
    caregiver_phone    VARCHAR(30),
    discharge_date     DATE,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at         TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE clinician_profiles (
    id             BIGSERIAL PRIMARY KEY,
    user_id        BIGINT NOT NULL UNIQUE REFERENCES users (id) ON DELETE CASCADE,
    first_name     VARCHAR(100) NOT NULL,
    last_name      VARCHAR(100) NOT NULL,
    specialty      VARCHAR(100),
    license_number VARCHAR(100),
    created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE care_team_assignments (
    id           BIGSERIAL PRIMARY KEY,
    patient_id   BIGINT NOT NULL REFERENCES patient_profiles (id) ON DELETE CASCADE,
    clinician_id BIGINT NOT NULL REFERENCES clinician_profiles (id) ON DELETE CASCADE,
    assigned_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    active       BOOLEAN NOT NULL DEFAULT TRUE,
    UNIQUE (patient_id, clinician_id)
);

-- Clinical context

CREATE TABLE conditions (
    id          BIGSERIAL PRIMARY KEY,
    code        VARCHAR(50),
    name        VARCHAR(200) NOT NULL,
    description TEXT
);

CREATE TABLE patient_conditions (
    patient_id   BIGINT NOT NULL REFERENCES patient_profiles (id) ON DELETE CASCADE,
    condition_id BIGINT NOT NULL REFERENCES conditions (id) ON DELETE CASCADE,
    diagnosed_at DATE,
    PRIMARY KEY (patient_id, condition_id)
);

CREATE TABLE allergies (
    id          BIGSERIAL PRIMARY KEY,
    patient_id  BIGINT NOT NULL REFERENCES patient_profiles (id) ON DELETE CASCADE,
    allergen    VARCHAR(200) NOT NULL,
    reaction    VARCHAR(500),
    severity    VARCHAR(50)
);

-- Medications

CREATE TABLE medications (
    id              BIGSERIAL PRIMARY KEY,
    patient_id      BIGINT NOT NULL REFERENCES patient_profiles (id) ON DELETE CASCADE,
    name            VARCHAR(200) NOT NULL,
    dosage          VARCHAR(100),
    route           VARCHAR(50),
    indication      VARCHAR(500),
    instructions    TEXT,
    status          VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    change_type     VARCHAR(20),
    refill_due_date DATE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE medication_schedules (
    id             BIGSERIAL PRIMARY KEY,
    medication_id  BIGINT NOT NULL REFERENCES medications (id) ON DELETE CASCADE,
    time_of_day    TIME NOT NULL,
    days_of_week   VARCHAR(20) NOT NULL DEFAULT 'DAILY',
    active         BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE medication_logs (
    id             BIGSERIAL PRIMARY KEY,
    medication_id  BIGINT NOT NULL REFERENCES medications (id) ON DELETE CASCADE,
    patient_id     BIGINT NOT NULL REFERENCES patient_profiles (id) ON DELETE CASCADE,
    scheduled_at   TIMESTAMPTZ NOT NULL,
    taken_at       TIMESTAMPTZ,
    status         VARCHAR(20) NOT NULL,
    barrier_reason VARCHAR(50),
    barrier_note   TEXT,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_medication_logs_patient_scheduled ON medication_logs (patient_id, scheduled_at);

-- Discharge plans and tasks

CREATE TABLE discharge_plans (
    id          BIGSERIAL PRIMARY KEY,
    patient_id  BIGINT NOT NULL REFERENCES patient_profiles (id) ON DELETE CASCADE,
    clinician_id BIGINT REFERENCES clinician_profiles (id),
    summary     TEXT,
    red_flags   TEXT,
    status      VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE care_tasks (
    id                BIGSERIAL PRIMARY KEY,
    discharge_plan_id BIGINT REFERENCES discharge_plans (id) ON DELETE CASCADE,
    patient_id        BIGINT NOT NULL REFERENCES patient_profiles (id) ON DELETE CASCADE,
    title             VARCHAR(300) NOT NULL,
    description       TEXT,
    due_date          DATE,
    priority          VARCHAR(20) NOT NULL DEFAULT 'ROUTINE',
    status            VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    acknowledged_at   TIMESTAMPTZ,
    completed_at      TIMESTAMPTZ,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE appointments (
    id           BIGSERIAL PRIMARY KEY,
    patient_id   BIGINT NOT NULL REFERENCES patient_profiles (id) ON DELETE CASCADE,
    clinician_id BIGINT REFERENCES clinician_profiles (id),
    scheduled_at TIMESTAMPTZ NOT NULL,
    location     VARCHAR(300),
    purpose      VARCHAR(500),
    status       VARCHAR(20) NOT NULL DEFAULT 'SCHEDULED',
    created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Symptom monitoring

CREATE TABLE symptom_templates (
    id          BIGSERIAL PRIMARY KEY,
    name        VARCHAR(200) NOT NULL,
    condition_id BIGINT REFERENCES conditions (id),
    questions   JSONB NOT NULL,
    active      BOOLEAN NOT NULL DEFAULT TRUE,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE symptom_check_ins (
    id          BIGSERIAL PRIMARY KEY,
    patient_id  BIGINT NOT NULL REFERENCES patient_profiles (id) ON DELETE CASCADE,
    template_id BIGINT NOT NULL REFERENCES symptom_templates (id),
    responses   JSONB NOT NULL,
    risk_level  VARCHAR(20) NOT NULL,
    submitted_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE alerts (
    id           BIGSERIAL PRIMARY KEY,
    patient_id   BIGINT NOT NULL REFERENCES patient_profiles (id) ON DELETE CASCADE,
    source_type  VARCHAR(50) NOT NULL,
    source_id    BIGINT,
    severity     VARCHAR(20) NOT NULL,
    message      TEXT NOT NULL,
    status       VARCHAR(20) NOT NULL DEFAULT 'OPEN',
    assigned_to  BIGINT REFERENCES clinician_profiles (id),
    resolved_at  TIMESTAMPTZ,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_alerts_patient_status ON alerts (patient_id, status);

-- Messaging

CREATE TABLE message_threads (
    id          BIGSERIAL PRIMARY KEY,
    patient_id  BIGINT NOT NULL REFERENCES patient_profiles (id) ON DELETE CASCADE,
    category    VARCHAR(50) NOT NULL,
    subject     VARCHAR(300),
    status      VARCHAR(20) NOT NULL DEFAULT 'OPEN',
    assigned_to BIGINT REFERENCES clinician_profiles (id),
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE messages (
    id           BIGSERIAL PRIMARY KEY,
    thread_id    BIGINT NOT NULL REFERENCES message_threads (id) ON DELETE CASCADE,
    sender_id    BIGINT NOT NULL REFERENCES users (id),
    body         TEXT NOT NULL,
    sent_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    read_at      TIMESTAMPTZ
);

-- Education and AI

CREATE TABLE education_content (
    id             BIGSERIAL PRIMARY KEY,
    title          VARCHAR(300) NOT NULL,
    body           TEXT NOT NULL,
    language       VARCHAR(10) NOT NULL DEFAULT 'en',
    reading_level  VARCHAR(20),
    condition_id   BIGINT REFERENCES conditions (id),
    approval_status VARCHAR(20) NOT NULL DEFAULT 'DRAFT',
    approved_by    BIGINT REFERENCES users (id),
    approved_at    TIMESTAMPTZ,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE ai_interactions (
    id              BIGSERIAL PRIMARY KEY,
    patient_id      BIGINT NOT NULL REFERENCES patient_profiles (id) ON DELETE CASCADE,
    prompt          TEXT NOT NULL,
    response        TEXT,
    source_refs     JSONB,
    confidence_flag VARCHAR(20),
    model_version   VARCHAR(100),
    reviewer_id     BIGINT REFERENCES clinician_profiles (id),
    reviewed_at     TIMESTAMPTZ,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Governance

CREATE TABLE consent_records (
    id           BIGSERIAL PRIMARY KEY,
    patient_id   BIGINT NOT NULL REFERENCES patient_profiles (id) ON DELETE CASCADE,
    consent_type VARCHAR(50) NOT NULL,
    granted      BOOLEAN NOT NULL,
    recorded_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE notifications (
    id           BIGSERIAL PRIMARY KEY,
    user_id      BIGINT NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    channel      VARCHAR(20) NOT NULL,
    subject      VARCHAR(300),
    body         TEXT NOT NULL,
    status       VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    scheduled_at TIMESTAMPTZ,
    sent_at      TIMESTAMPTZ,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE audit_logs (
    id          BIGSERIAL PRIMARY KEY,
    user_id     BIGINT REFERENCES users (id),
    action      VARCHAR(100) NOT NULL,
    entity_type VARCHAR(100),
    entity_id   BIGINT,
    details     JSONB,
    ip_address  VARCHAR(45),
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_audit_logs_user_created ON audit_logs (user_id, created_at);
