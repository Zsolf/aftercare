# Spring Boot Portfolio Project Documentation: AfterCare

## Project overview
AfterCare is a full-stack Spring Boot portfolio project for health informatics focused on poor medication adherence and weak post-discharge self-management during care transitions for patients with chronic disease. Systematic reviews of patient portals show that portal interventions are generally associated with better medication adherence, improved preventive behaviors, and stronger patient knowledge, but clinical outcomes remain mixed and portal use is often uneven across population groups.The project therefore centers on a portal-plus-coordination platform that does more than display records: it actively supports discharge follow-up, medication understanding, refill adherence, symptom monitoring, and secure communication.

## Problem statement
A persistent modern healthcare issue is the drop in support that many patients experience immediately after discharge or between outpatient visits. Patients often leave care settings with medication changes, follow-up tasks, self-management instructions, and unresolved questions, yet portal use is inconsistent and the evidence suggests that benefit depends heavily on engagement, communication, and tailored support.

This problem is especially important in chronic disease management because medication adherence, comprehension of discharge instructions, and timely follow-up strongly shape outcomes and avoidable utilization. The literature indicates that portals can improve adherence and preventive behavior, but that they do not automatically improve clinical outcomes on their own; this creates an informatics opportunity to design a richer intervention that combines tailored education, reminders, communication, and monitoring.

## Proposed solution
AfterCare is a patient-centered care transition and medication adherence platform with three core user groups: patients, clinicians, and administrators. The platform provides discharge plans, medication reconciliation summaries, refill reminders, symptom check-ins, secure messaging, escalation workflows, and patient-facing education written in plain language. It also includes dashboards for clinicians to identify high-risk patients who may be disengaging after discharge.

The distinctive feature is a GenAI education and coaching component that rewrites clinical instructions into understandable, personalized summaries and answers bounded patient questions using clinician-approved knowledge and safety guardrails. Recent reviews suggest generative AI may improve health literacy, readability, cultural accessibility, and personalized learning, but they also emphasize risks such as hallucination, bias, inequitable communication, and the need for human oversight and structured governance.

## Why this topic is relevant
This project addresses a clear informatics gap between data access and meaningful patient action. Reviews of patient portal interventions report improvements in medication adherence, health knowledge, self-efficacy, and preventive service use, while also noting mixed clinical results and limited inclusion of diverse populations in many studies.

That makes the topic highly relevant for modern healthcare and for a Spring Boot portfolio project: it is clinically grounded, technically rich, and evaluable. It also allows the project to demonstrate applied health informatics principles such as workflow support, patient engagement, socio-technical design, access equity, data governance, and outcome measurement rather than just CRUD functionality.

## Project goals
### Primary goal
Build a secure, full-stack care transition platform that improves patient understanding of medications and follow-up tasks after discharge while helping clinicians monitor adherence risk.

### Secondary goals
- Improve patient comprehension of discharge instructions through plain-language explanations and multilingual support.
- Support medication adherence through reminders, refill tracking, acknowledgment workflows, and symptom-triggered follow-up.
- Reduce communication friction between patients and care teams through secure messaging and structured escalation.
- Enable clinicians to prioritize outreach using engagement and adherence risk indicators informed by patient activity and reported symptoms.
- Demonstrate responsible GenAI integration with auditability, human review, and safety constraints.

## Scope
### In scope
- Web-based patient and clinician portal.
- RESTful backend with Spring Boot.
- Relational data model for users, medications, discharge plans, reminders, messages, symptom check-ins, and AI interactions.
- Role-based access for patient, clinician, and admin roles.
- Evidence-based medication adherence and care transition features.
- GenAI-generated plain-language education summaries and question answering.
- Analytics dashboard for adherence risk and engagement.
- Notification services by email and optional SMS abstraction.
- Audit trails, consent records, and access logging.

### Out of scope
- Direct integration with a live hospital EHR in the first portfolio version.
- Real prescribing, diagnosis, or autonomous clinical decision-making.
- Full national interoperability certification.
- Real-time medical device streaming.
- Billing, insurance claims, and revenue-cycle management.

## Users and personas
### Patient
A recently discharged adult with one or more chronic conditions who needs a clear medication list, daily reminders, symptom check-ins, and an easy way to ask follow-up questions.

### Clinician
A nurse, physician, pharmacist, or care coordinator who needs to monitor discharge compliance, detect risks early, respond to patient questions, and document outreach.

### Administrator
A system administrator or quality manager who manages user provisioning, configuration, audit logs, content approval, and analytics.

## Evidence basis for design choices
| Design choice | Literature basis | Implication for product |
|---|---|---|
| Patient portal foundation | Portals are associated with improved health awareness, communication, and therapy adherence, but utilization effects are mixed.| Use a portal as the base, but add active workflow support rather than passive record viewing. |
| Tailored education and alerts | Portal interventions commonly use tailored alerts and educational resources, with positive effects on knowledge, self-efficacy, medication adherence, and preventive behaviors. | Prioritize reminders, tailored education, and behavior-support features. |
| Equity-aware onboarding | Portal studies often involve more advantaged users, and adoption gaps exist by race, income, age, and literacy. | Include plain language, accessibility, multilingual content, low-friction onboarding, and digital inclusion measures. |
| GenAI for education | Reviews suggest GenAI can improve readability, personalization, and health literacy support, but evidence remains moderate and safety concerns are substantial. | Restrict GenAI to education and navigation support with clinician review and guardrails. |

## System vision
The platform should function as a “digital safety net” for the first 30 days after discharge and for ongoing chronic disease follow-up. Instead of assuming the patient can interpret medication changes independently, the system translates plans into clear daily actions, confirms understanding, monitors barriers, and routes concerning signals to care teams.

## Functional requirements
### FR-1 Authentication and account management
- The system shall support registration for invited patients using secure token-based onboarding.
- The system shall support login with email and password.
- The system shall support multi-factor authentication for clinician and admin accounts.
- The system shall support password reset and account recovery.
- The system shall enforce role-based access control.
- The system shall log all authentication events for audit purposes.

### FR-2 Patient profile and care context
- The system shall store demographic and contact details, preferred language, consent preferences, and caregiver contact.
- The system shall store clinical context required for the application workflow, including diagnoses, allergies, medication list, discharge date, and follow-up appointments.
- The system shall allow clinicians to update care context fields relevant to patient education and monitoring.
- The system shall display patient-friendly summaries that avoid unnecessary jargon.

### FR-3 Medication management
- The system shall present a current medication list with dosage, route, timing, indication, and special instructions.
- The system shall display medication changes since discharge, including started, stopped, or changed medications.
- The system shall allow patients to mark each medication as taken, skipped, or delayed.
- The system shall allow patients to record reasons for non-adherence such as side effects, cost, confusion, or refill barriers.
- The system shall allow clinicians to review adherence history.
- The system shall generate refill reminders for time-sensitive medications.
- The system shall highlight possible adherence risk when doses are repeatedly missed.

### FR-4 Discharge plan and task tracking
- The system shall display a structured discharge plan containing medications, appointments, monitoring tasks, red-flag symptoms, and self-care actions.
- The system shall allow clinicians to create and edit post-discharge tasks.
- The system shall allow patients to acknowledge each task and mark it completed.
- The system shall send reminders for overdue tasks.
- The system shall escalate overdue critical tasks to clinicians.

### FR-5 Symptom check-ins and escalation
- The system shall present periodic symptom questionnaires customized to the patient’s condition.
- The system shall score responses against configurable escalation rules.
- The system shall generate alerts for moderate-risk and high-risk responses.
- The system shall route alerts to the assigned clinician queue.
- The system shall display red-flag advice that directs patients to emergency care when configured thresholds are reached.
- The system shall record all check-ins and escalations for later review.

### FR-6 Secure messaging
- The system shall provide asynchronous secure messaging between patients and care teams.
- The system shall support message categories such as medication question, symptom concern, appointment issue, and technical help.
- The system shall support attachments for non-sensitive supplemental files in a controlled format.
- The system shall show message status, response time, and assigned responder.
- The system shall allow clinicians to convert messages into tasks or outreach actions.

### FR-7 Education library
- The system shall provide curated educational content linked to diagnosis, medication, and discharge instructions.
- The system shall support plain-language versions and multilingual variants.
- The system shall tag resources by reading level, language, condition, and approval status.
- The system shall allow clinicians or admins to approve and retire content.

### FR-8 GenAI patient education assistant
- The system shall generate patient-specific, plain-language summaries of discharge instructions and medication explanations from structured clinical inputs.
- The system shall allow patients to ask questions in natural language about medications, appointments, and self-care topics.
- The system shall ground responses in approved internal content and structured patient data rather than unrestricted open-ended generation.
- The system shall present responses with a safety disclaimer stating that the tool does not replace urgent clinical evaluation.
- The system shall block or redirect prompts seeking diagnosis, emergency triage beyond defined rules, prescription changes, or unsafe medical advice.
- The system shall log prompts, responses, source references, confidence flags, and handoff events.
- The system shall allow clinicians to review AI-generated summaries before release in strict mode, or allow post-hoc review in supervised mode.
- The system shall support a readability target and a configurable output style, for example CEFR or grade-level settings, to improve health literacy.

### FR-9 Clinician dashboard
- The system shall provide a dashboard of assigned patients with adherence, engagement, and symptom status.
- The system shall display indicators such as missed doses, overdue tasks, unread education, unanswered messages, and recent symptom alerts.
- The system shall support filtering by risk level, diagnosis, discharge date, and assigned team member.
- The system shall allow clinicians to document outreach and resolution status.
- The system shall provide a longitudinal timeline of key patient interactions.

### FR-10 Analytics and reporting
- The system shall calculate adherence metrics such as medication possession proxies, dose acknowledgment rate, task completion rate, and response latency.
- The system shall provide cohort-level dashboards for administrators.
- The system shall allow export of de-identified aggregate reports.
- The system shall support evaluation measures for the portfolio case study, including engagement, adherence trends, and patient question categories.

### FR-11 Notification services
- The system shall send reminders by email and support an extensible SMS provider interface.
- The system shall allow users to configure reminder frequency and quiet hours.
- The system shall send critical alert notifications to clinicians based on escalation rules.
- The system shall record delivery status and failures.

### FR-12 Administration and governance
- The system shall manage users, roles, clinician assignments, content approval, AI prompt templates, and escalation thresholds.
- The system shall expose audit logs for user activity, data access, and AI interactions.
- The system shall support consent capture for messaging, reminders, and AI-assisted education.
- The system shall support policy configuration for data retention and feature enablement.

## Non-functional requirements
### NFR-1 Privacy and security
- The system shall encrypt data in transit using HTTPS/TLS.
- The system shall encrypt sensitive data at rest.
- The system shall implement RBAC with least-privilege access.
- The system shall store audit logs for all sensitive actions.
- The system shall support configurable retention and deletion policies.
- The system shall avoid using GenAI providers in a way that trains public models on patient data.
- The system shall mask or minimize sensitive data sent to the AI service whenever full context is unnecessary.

### NFR-2 Performance
- The system should return standard API requests within 2 seconds under normal load.
- The system should support at least 500 concurrent sessions for a portfolio demo target.
- The system should process reminder jobs within 5 minutes of scheduled time.

### NFR-3 Reliability
- The system shall recover gracefully from AI provider downtime by reverting to standard educational content.
- The system shall use retries and dead-letter handling for background notifications.
- The system shall preserve data consistency for medication logs and alerts.

### NFR-4 Usability and accessibility
- The system shall follow WCAG 2.1 AA principles.
- The patient interface shall use plain language and avoid unnecessary abbreviations.
- The system shall support responsive design for mobile-first use.
- The system shall allow larger text and high-contrast mode.

### NFR-5 Maintainability
- The backend shall follow layered or hexagonal architecture with clear separation of concerns.
- The codebase shall include unit, integration, and API tests.
- The system shall support environment-based configuration.
- The system shall expose structured logs and health checks.

### NFR-6 Explainability and AI safety
- The GenAI module shall provide traceable source grounding for generated educational responses where possible.
- The system shall surface confidence or verification flags for clinician review.
- The system shall maintain a complete audit trail of prompt, context class, model version, and user-visible output.

## Detailed feature specification
### 1. Patient home dashboard
**Purpose:** Give the patient one clear place to see what to do today.

**Inputs:** Medication schedule, tasks, upcoming appointments, latest messages, symptom check-in schedule.

**Outputs:** Personalized daily action list, reminders, warning banners, progress widgets.

**Acceptance criteria:**
- Displays today’s medications with status chips.
- Shows overdue tasks at the top.
- Shows next appointment and route to contact support.
- Uses plain-language labels instead of clinical shorthand.

### 2. Medication adherence tracker
**Purpose:** Capture patient-reported medication-taking behavior and barriers.

**Inputs:** Medication regimen, patient responses, refill dates.

**Outputs:** Dose log, missed-dose trend, adherence risk score.

**Business rules:**
- Three missed doses in seven days triggers medium risk.
- A patient-reported side effect plus two missed doses triggers clinician review.
- Running out of medication within 72 hours triggers refill reminder.

**Acceptance criteria:**
- Patient can log each scheduled dose in under three taps.
- Clinician can view a 30-day adherence trend.
- Barrier reasons are stored as coded categories plus free text.

### 3. Discharge plan viewer
**Purpose:** Improve understanding of discharge instructions.

**Inputs:** Structured discharge plan authored by clinician.

**Outputs:** Task list, medication changes, red-flag symptoms, downloadable summary.

**Acceptance criteria:**
- Shows “what changed” section for medications.
- Separates urgent symptoms from routine follow-up items.
- Allows the patient to acknowledge understanding.

### 4. Symptom monitoring module
**Purpose:** Detect warning signs early after discharge.

**Inputs:** Questionnaire templates, patient responses.

**Outputs:** Severity classification, clinician alert, self-care advice.

**Acceptance criteria:**
- Condition-specific forms are assignable.
- Escalation logic is configurable.
- Critical answers generate immediate emergency guidance.

### 5. Secure messaging center
**Purpose:** Lower friction for follow-up communication.

**Inputs:** Patient or clinician messages.

**Outputs:** Conversation threads, response queue, resolution tracking.

**Acceptance criteria:**
- Supports category tagging.
- Supports assignment to clinician or care coordinator.
- Shows unresolved threads first.

### 6. GenAI education assistant
**Purpose:** Convert complex instructions into understandable guidance without making autonomous clinical decisions.

**Inputs:** Structured patient context, approved content, user question, prompt template.

**Outputs:** Plain-language summary, answer, suggested next steps, escalation recommendation.

**Business rules:**
- Only approved knowledge domains are answerable.
- Emergency or medication-change prompts trigger safe handoff rather than direct advice.
- Output must cite internal source snippets in the UI where feasible.
- All outputs are stored for audit and quality review.

**Acceptance criteria:**
- Generates a discharge summary in plain language at configured reading level.
- Answers routine medication questions using grounded content.
- Refuses unsafe questions and directs users to clinician contact or emergency services as appropriate.
- Allows clinician review workflow for selected cases.

### 7. Clinician risk dashboard
**Purpose:** Support proactive outreach.

**Inputs:** Adherence logs, symptom reports, messaging activity, task completion data.

**Outputs:** Ranked patient list, alerts, timeline, intervention notes.

**Acceptance criteria:**
- Patients can be sorted by risk score.
- Dashboard highlights which factor drove the score.
- Clinician can document outreach outcome.

### 8. Admin governance console
**Purpose:** Manage policy, content, and oversight.

**Inputs:** User roles, templates, thresholds, content records.

**Outputs:** Configuration changes, audit views, approval actions.

**Acceptance criteria:**
- Admin can enable or disable AI features.
- Admin can review AI logs and flagged responses.
- Admin can manage multilingual content versions.

## Use cases
### UC-1 Patient reviews medications after discharge
1. Patient logs in.
2. Dashboard shows changed medications.
3. Patient opens a medication card.
4. System displays dosage, timing, purpose, and plain-language explanation.
5. Patient confirms understanding or asks a question.
6. If the question is low risk, GenAI provides a grounded answer; if high risk, system escalates to clinician.

### UC-2 Clinician reviews adherence risk
1. Clinician opens risk dashboard.
2. System lists patients with missed doses and overdue tasks.
3. Clinician filters to patients discharged in last 14 days.
4. Clinician opens patient timeline.
5. Clinician sends message or creates outreach task.
6. Action is logged for audit and analytics.

### UC-3 AI rewrites discharge instructions
1. Clinician finalizes discharge plan.
2. System generates plain-language version using approved prompt template.
3. Clinician reviews and approves generated summary.
4. Patient receives simplified instructions in portal and notification.
5. System logs model metadata and approval event.

## Data requirements
### Core entities
- User
- Role
- PatientProfile
- ClinicianProfile
- CareTeamAssignment
- Condition
- Medication
- MedicationSchedule
- MedicationLog
- DischargePlan
- CareTask
- Appointment
- SymptomTemplate
- SymptomCheckIn
- Alert
- MessageThread
- Message
- EducationContent
- AIInteraction
- ConsentRecord
- Notification
- AuditLog

### Example key relationships
- A PatientProfile has many Medications, CareTasks, SymptomCheckIns, and MessageThreads.
- A ClinicianProfile is assigned to many patients through CareTeamAssignment.
- A DischargePlan has many CareTasks and medication changes.
- An AIInteraction belongs to one patient and optionally one clinician reviewer.
- An Alert may originate from medication logs, symptom check-ins, or AI safety triggers.

## Suggested architecture
### Backend
- Spring Boot 3
- Spring Web
- Spring Security
- Spring Data JPA
- PostgreSQL
- Bean Validation
- Spring Scheduler / Quartz for reminders
- Spring AI or provider abstraction for LLM integration
- OpenAPI/Swagger for documentation
- MapStruct for DTO mapping
- Flyway for schema migration

### Frontend
- React with TypeScript or Angular
- Responsive UI with Material UI or Tailwind-based component library
- Charting library for adherence and engagement trends
- Form validation and accessibility support

### Integration layer
- REST API first design
- Optional FHIR-inspired adapters for future medication and appointment import
- Email/SMS provider abstraction
- AI provider abstraction with prompt templates and safety filters

### Deployment
- Dockerized backend and frontend
- PostgreSQL container
- Reverse proxy such as Nginx
- CI/CD with GitHub Actions
- Cloud deployment on AWS, Azure, or Render

## Suggested API modules
- `/api/auth`
- `/api/patients`
- `/api/clinicians`
- `/api/medications`
- `/api/discharge-plans`
- `/api/tasks`
- `/api/checkins`
- `/api/messages`
- `/api/education`
- `/api/ai`
- `/api/notifications`
- `/api/admin`
- `/api/audit`
- `/api/reports`

## AI component design
### AI use case boundaries
The GenAI component should be framed as a patient education and navigation assistant, not a diagnostic engine. This is aligned with current literature, which supports GenAI for readability and personalized health literacy support while warning against unverified autonomous clinical use.

### Proposed AI features
- Plain-language discharge summary generation.
- Medication explanation generator: “What is this medicine for?”
- Question answering over approved educational content and the patient’s structured care plan.
- Message drafting assistance for clinicians responding to common patient questions.
- Content readability adaptation for low health literacy or multilingual contexts.

### AI guardrails
- Retrieval-augmented generation over approved content only.
- Prompt templates with safety rules.
- PHI minimization before model calls when feasible.
- Automatic refusal for diagnosis, dosage changes, or emergency substitution.
- Human review workflow for high-risk outputs.
- Logging and periodic audit of unsafe or low-quality responses.

## Privacy, ethics, and governance
This project should explicitly discuss socio-technical risks, not only functionality. Portal and AI interventions can worsen inequities when literacy, language, trust, or access barriers are ignored, and current literature repeatedly notes underrepresentation of more vulnerable populations in portal studies.

Governance requirements should therefore include transparent consent, accessibility, multilingual design, reviewable AI outputs, role-based auditing, and clear escalation boundaries. The AI module must be explainable enough for clinician oversight and conservative enough to avoid presenting speculative medical advice as fact.

## Evaluation plan
### Process metrics
- Account activation rate.
- Daily and weekly active users.
- Message response time.
- Completion rate for symptom check-ins.
- Percentage of AI outputs requiring clinician revision.

### Outcome proxies
- Medication acknowledgment rate over 30 days.
- Rate of overdue follow-up tasks.
- Frequency of adherence barriers by category.
- Patient-reported understanding score before and after AI summaries.
- Clinician-perceived usefulness of dashboard prioritization.

### Safety metrics
- Number of AI refusals by category.
- Number of escalations triggered by AI safety rules.
- Rate of clinician overrides of AI outputs.
- Rate of unresolved high-risk alerts after 24 hours.

## Minimum viable product
- Secure authentication and RBAC.
- Patient dashboard.
- Medication list and dose logging.
- Discharge plan with task checklist.
- Symptom check-in form with alert logic.
- Secure messaging.
- Clinician dashboard with simple risk flags.
- GenAI discharge-summary simplifier with review workflow.
- Audit log and admin content approval.

## Advanced extensions
- SMART-on-FHIR integration mock.
- Multilingual AI summaries.
- Caregiver proxy access.
- Explainable risk scoring.
- Population health quality dashboard.
- Mobile app companion.
- Voice-based patient education assistant for low-literacy users, reflecting literature recommendations to move beyond text-only interaction.[cite:2]
