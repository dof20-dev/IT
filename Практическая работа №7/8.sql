--
-- PostgreSQL database dump
--

\restrict jCynXoRnehU5vxhahfK6EN65AKjnNqyFbAL52bjhWlTPzWf3Dc7LmUEBgdEU06V

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

-- Started on 2026-10-19 12:10:28

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 234 (class 1255 OID 33203)
-- Name: audit_students_changes(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.audit_students_changes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO audit_log (table_name, operation, record_id, new_data) 
        VALUES ('students', 'INSERT', NEW.student_id, to_jsonb(NEW));
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO audit_log (table_name, operation, record_id, old_data, new_data) 
        VALUES ('students', 'UPDATE', NEW.student_id, to_jsonb(OLD), to_jsonb(NEW));
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO audit_log (table_name, operation, record_id, old_data) 
        VALUES ('students', 'DELETE', OLD.student_id, to_jsonb(OLD));
        RETURN OLD;
    END IF;
END;
$$;


ALTER FUNCTION public.audit_students_changes() OWNER TO postgres;

--
-- TOC entry 235 (class 1255 OID 33205)
-- Name: check_grade_range(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_grade_range() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.grade < 2 OR NEW.grade > 5 THEN
        RAISE EXCEPTION 'Оценка должна быть от 2 до 5, получено: %', NEW.grade;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.check_grade_range() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 232 (class 1259 OID 33192)
-- Name: audit_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audit_log (
    log_id integer NOT NULL,
    table_name character varying(50),
    operation character varying(10),
    record_id integer,
    old_data jsonb,
    new_data jsonb,
    changed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    changed_by character varying(50) DEFAULT CURRENT_USER
);


ALTER TABLE public.audit_log OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 33191)
-- Name: audit_log_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.audit_log_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.audit_log_log_id_seq OWNER TO postgres;

--
-- TOC entry 4971 (class 0 OID 0)
-- Dependencies: 231
-- Name: audit_log_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.audit_log_log_id_seq OWNED BY public.audit_log.log_id;


--
-- TOC entry 226 (class 1259 OID 16614)
-- Name: disciplines; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.disciplines (
    discipline_id integer NOT NULL,
    discipline_name character varying(100) NOT NULL,
    hours integer NOT NULL,
    CONSTRAINT disciplines_hours_check CHECK ((hours > 0))
);


ALTER TABLE public.disciplines OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16613)
-- Name: disciplines_discipline_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.disciplines_discipline_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.disciplines_discipline_id_seq OWNER TO postgres;

--
-- TOC entry 4974 (class 0 OID 0)
-- Dependencies: 225
-- Name: disciplines_discipline_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.disciplines_discipline_id_seq OWNED BY public.disciplines.discipline_id;


--
-- TOC entry 230 (class 1259 OID 33169)
-- Name: grades; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grades (
    grade_id integer NOT NULL,
    student_id integer NOT NULL,
    discipline_id integer NOT NULL,
    grade integer NOT NULL,
    grade_date date NOT NULL,
    CONSTRAINT grades_grade_check CHECK (((grade >= 2) AND (grade <= 5)))
);


ALTER TABLE public.grades OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 33168)
-- Name: grades_grade_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.grades_grade_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.grades_grade_id_seq OWNER TO postgres;

--
-- TOC entry 4977 (class 0 OID 0)
-- Dependencies: 229
-- Name: grades_grade_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.grades_grade_id_seq OWNED BY public.grades.grade_id;


--
-- TOC entry 220 (class 1259 OID 16573)
-- Name: groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.groups (
    group_id integer NOT NULL,
    group_name character varying(20) NOT NULL,
    specialty character varying(100) NOT NULL,
    admission_year integer NOT NULL,
    CONSTRAINT chk_admission_year CHECK (((admission_year >= 2000) AND (admission_year <= 2100)))
);


ALTER TABLE public.groups OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16572)
-- Name: groups_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.groups_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.groups_group_id_seq OWNER TO postgres;

--
-- TOC entry 4980 (class 0 OID 0)
-- Dependencies: 219
-- Name: groups_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.groups_group_id_seq OWNED BY public.groups.group_id;


--
-- TOC entry 228 (class 1259 OID 16627)
-- Name: lessons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lessons (
    lesson_id integer NOT NULL,
    group_id integer NOT NULL,
    discipline_id integer NOT NULL,
    teacher_id integer NOT NULL,
    lesson_date date NOT NULL,
    lesson_type character varying(30) NOT NULL
);


ALTER TABLE public.lessons OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16626)
-- Name: lessons_lesson_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lessons_lesson_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lessons_lesson_id_seq OWNER TO postgres;

--
-- TOC entry 4983 (class 0 OID 0)
-- Dependencies: 227
-- Name: lessons_lesson_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lessons_lesson_id_seq OWNED BY public.lessons.lesson_id;


--
-- TOC entry 222 (class 1259 OID 16586)
-- Name: students; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.students (
    student_id integer NOT NULL,
    last_name character varying(50) NOT NULL,
    first_name character varying(50) NOT NULL,
    middle_name character varying(50),
    birth_date date NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.students OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16585)
-- Name: students_student_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.students_student_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.students_student_id_seq OWNER TO postgres;

--
-- TOC entry 4986 (class 0 OID 0)
-- Dependencies: 221
-- Name: students_student_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.students_student_id_seq OWNED BY public.students.student_id;


--
-- TOC entry 224 (class 1259 OID 16603)
-- Name: teachers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teachers (
    teacher_id integer NOT NULL,
    last_name character varying(50) NOT NULL,
    first_name character varying(50) NOT NULL,
    department character varying(100) NOT NULL
);


ALTER TABLE public.teachers OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16602)
-- Name: teachers_teacher_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.teachers_teacher_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.teachers_teacher_id_seq OWNER TO postgres;

--
-- TOC entry 4989 (class 0 OID 0)
-- Dependencies: 223
-- Name: teachers_teacher_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.teachers_teacher_id_seq OWNED BY public.teachers.teacher_id;


--
-- TOC entry 233 (class 1259 OID 33223)
-- Name: v_my_grades; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_my_grades AS
 SELECT gr.grade_id,
    s.student_id,
    d.discipline_name,
    gr.grade,
    gr.grade_date
   FROM ((public.grades gr
     JOIN public.students s ON ((gr.student_id = s.student_id)))
     JOIN public.disciplines d ON ((gr.discipline_id = d.discipline_id)));


ALTER VIEW public.v_my_grades OWNER TO postgres;

--
-- TOC entry 4769 (class 2604 OID 33195)
-- Name: audit_log log_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_log ALTER COLUMN log_id SET DEFAULT nextval('public.audit_log_log_id_seq'::regclass);


--
-- TOC entry 4766 (class 2604 OID 16617)
-- Name: disciplines discipline_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disciplines ALTER COLUMN discipline_id SET DEFAULT nextval('public.disciplines_discipline_id_seq'::regclass);


--
-- TOC entry 4768 (class 2604 OID 33172)
-- Name: grades grade_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grades ALTER COLUMN grade_id SET DEFAULT nextval('public.grades_grade_id_seq'::regclass);


--
-- TOC entry 4763 (class 2604 OID 16576)
-- Name: groups group_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groups ALTER COLUMN group_id SET DEFAULT nextval('public.groups_group_id_seq'::regclass);


--
-- TOC entry 4767 (class 2604 OID 16630)
-- Name: lessons lesson_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lessons ALTER COLUMN lesson_id SET DEFAULT nextval('public.lessons_lesson_id_seq'::regclass);


--
-- TOC entry 4764 (class 2604 OID 16589)
-- Name: students student_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students ALTER COLUMN student_id SET DEFAULT nextval('public.students_student_id_seq'::regclass);


--
-- TOC entry 4765 (class 2604 OID 16606)
-- Name: teachers teacher_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers ALTER COLUMN teacher_id SET DEFAULT nextval('public.teachers_teacher_id_seq'::regclass);


--
-- TOC entry 4963 (class 0 OID 33192)
-- Dependencies: 232
-- Data for Name: audit_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audit_log (log_id, table_name, operation, record_id, old_data, new_data, changed_at, changed_by) FROM stdin;
1	students	INSERT	12	\N	{"group_id": 1, "last_name": "Новиков", "birth_date": "2007-05-05", "first_name": "Пётр", "student_id": 12, "middle_name": null}	2026-10-19 11:28:36.664418	postgres
2	students	UPDATE	12	{"group_id": 1, "last_name": "Новиков", "birth_date": "2007-05-05", "first_name": "Пётр", "student_id": 12, "middle_name": null}	{"group_id": 1, "last_name": "Новиков", "birth_date": "2007-05-05", "first_name": "Петр", "student_id": 12, "middle_name": null}	2026-10-19 11:28:36.664418	postgres
3	students	DELETE	12	{"group_id": 1, "last_name": "Новиков", "birth_date": "2007-05-05", "first_name": "Петр", "student_id": 12, "middle_name": null}	\N	2026-10-19 11:28:36.664418	postgres
\.


--
-- TOC entry 4957 (class 0 OID 16614)
-- Dependencies: 226
-- Data for Name: disciplines; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.disciplines (discipline_id, discipline_name, hours) FROM stdin;
1	Основы проектирования баз данных	72
2	Информационные технологии	72
3	Программирование	144
4	Компьютерные сети	72
\.


--
-- TOC entry 4961 (class 0 OID 33169)
-- Dependencies: 230
-- Data for Name: grades; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.grades (grade_id, student_id, discipline_id, grade, grade_date) FROM stdin;
1	1	1	5	2026-09-15
2	1	3	4	2026-09-16
3	2	1	3	2026-09-15
4	2	3	5	2026-09-16
5	3	1	4	2026-09-17
6	3	2	5	2026-09-18
7	4	2	4	2026-09-18
8	4	1	3	2026-09-19
9	5	2	5	2026-09-20
10	5	1	4	2026-09-21
\.


--
-- TOC entry 4951 (class 0 OID 16573)
-- Dependencies: 220
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.groups (group_id, group_name, specialty, admission_year) FROM stdin;
2	ИС-22	Информационные системы	2026
3	ЭК-21	Экономика	2026
1	П-21	Программирование	2026
\.


--
-- TOC entry 4959 (class 0 OID 16627)
-- Dependencies: 228
-- Data for Name: lessons; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lessons (lesson_id, group_id, discipline_id, teacher_id, lesson_date, lesson_type) FROM stdin;
3	2	1	1	2026-09-10	Практика
4	2	2	2	2026-09-12	Лекция
5	3	2	2	2026-09-13	Практика
1	1	1	1	2026-09-10	Лекция
2	1	3	3	2026-09-11	Практика
\.


--
-- TOC entry 4953 (class 0 OID 16586)
-- Dependencies: 222
-- Data for Name: students; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.students (student_id, last_name, first_name, middle_name, birth_date, group_id) FROM stdin;
3	Сидорова	Анна	Игоревна	2006-11-04	2
4	Кузнецов	Максим	Олегович	2007-01-18	2
5	Смирнова	Елена	Андреевна	2006-09-27	3
2	Петров	Алексей	Сергеевич	2007-07-21	1
1	Иванов	Иван	Иванович	2007-03-15	2
\.


--
-- TOC entry 4955 (class 0 OID 16603)
-- Dependencies: 224
-- Data for Name: teachers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.teachers (teacher_id, last_name, first_name, department) FROM stdin;
1	Волков	Александр	Информационные технологии
2	Орлова	Мария	Общеобразовательные дисциплины
3	Фёдоров	Дмитрий	Программирование
\.


--
-- TOC entry 4992 (class 0 OID 0)
-- Dependencies: 231
-- Name: audit_log_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.audit_log_log_id_seq', 3, true);


--
-- TOC entry 4993 (class 0 OID 0)
-- Dependencies: 225
-- Name: disciplines_discipline_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.disciplines_discipline_id_seq', 4, true);


--
-- TOC entry 4994 (class 0 OID 0)
-- Dependencies: 229
-- Name: grades_grade_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.grades_grade_id_seq', 10, true);


--
-- TOC entry 4995 (class 0 OID 0)
-- Dependencies: 219
-- Name: groups_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.groups_group_id_seq', 9, true);


--
-- TOC entry 4996 (class 0 OID 0)
-- Dependencies: 227
-- Name: lessons_lesson_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lessons_lesson_id_seq', 5, true);


--
-- TOC entry 4997 (class 0 OID 0)
-- Dependencies: 221
-- Name: students_student_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.students_student_id_seq', 12, true);


--
-- TOC entry 4998 (class 0 OID 0)
-- Dependencies: 223
-- Name: teachers_teacher_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.teachers_teacher_id_seq', 3, true);


--
-- TOC entry 4793 (class 2606 OID 33202)
-- Name: audit_log audit_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_pkey PRIMARY KEY (log_id);


--
-- TOC entry 4784 (class 2606 OID 16625)
-- Name: disciplines disciplines_discipline_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disciplines
    ADD CONSTRAINT disciplines_discipline_name_key UNIQUE (discipline_name);


--
-- TOC entry 4786 (class 2606 OID 16623)
-- Name: disciplines disciplines_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disciplines
    ADD CONSTRAINT disciplines_pkey PRIMARY KEY (discipline_id);


--
-- TOC entry 4791 (class 2606 OID 33180)
-- Name: grades grades_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grades
    ADD CONSTRAINT grades_pkey PRIMARY KEY (grade_id);


--
-- TOC entry 4776 (class 2606 OID 16584)
-- Name: groups groups_group_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_group_name_key UNIQUE (group_name);


--
-- TOC entry 4778 (class 2606 OID 16582)
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (group_id);


--
-- TOC entry 4789 (class 2606 OID 16638)
-- Name: lessons lessons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lessons
    ADD CONSTRAINT lessons_pkey PRIMARY KEY (lesson_id);


--
-- TOC entry 4780 (class 2606 OID 16596)
-- Name: students students_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (student_id);


--
-- TOC entry 4782 (class 2606 OID 16612)
-- Name: teachers teachers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_pkey PRIMARY KEY (teacher_id);


--
-- TOC entry 4787 (class 1259 OID 33166)
-- Name: idx_lessons_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_lessons_date ON public.lessons USING btree (lesson_date);


--
-- TOC entry 4801 (class 2620 OID 33206)
-- Name: grades trg_check_grade; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_check_grade BEFORE INSERT OR UPDATE ON public.grades FOR EACH ROW EXECUTE FUNCTION public.check_grade_range();


--
-- TOC entry 4800 (class 2620 OID 33204)
-- Name: students trg_students_audit; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_students_audit AFTER INSERT OR DELETE OR UPDATE ON public.students FOR EACH ROW EXECUTE FUNCTION public.audit_students_changes();


--
-- TOC entry 4798 (class 2606 OID 33186)
-- Name: grades fk_grades_disciplines; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grades
    ADD CONSTRAINT fk_grades_disciplines FOREIGN KEY (discipline_id) REFERENCES public.disciplines(discipline_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4799 (class 2606 OID 33181)
-- Name: grades fk_grades_students; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grades
    ADD CONSTRAINT fk_grades_students FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4795 (class 2606 OID 16644)
-- Name: lessons fk_lessons_disciplines; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lessons
    ADD CONSTRAINT fk_lessons_disciplines FOREIGN KEY (discipline_id) REFERENCES public.disciplines(discipline_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4796 (class 2606 OID 16639)
-- Name: lessons fk_lessons_groups; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lessons
    ADD CONSTRAINT fk_lessons_groups FOREIGN KEY (group_id) REFERENCES public.groups(group_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4797 (class 2606 OID 16649)
-- Name: lessons fk_lessons_teachers; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lessons
    ADD CONSTRAINT fk_lessons_teachers FOREIGN KEY (teacher_id) REFERENCES public.teachers(teacher_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4794 (class 2606 OID 16597)
-- Name: students fk_students_groups; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT fk_students_groups FOREIGN KEY (group_id) REFERENCES public.groups(group_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4969 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO borisov;


--
-- TOC entry 4970 (class 0 OID 0)
-- Dependencies: 232
-- Name: TABLE audit_log; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.audit_log TO borisov;


--
-- TOC entry 4972 (class 0 OID 0)
-- Dependencies: 231
-- Name: SEQUENCE audit_log_log_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.audit_log_log_id_seq TO borisov;


--
-- TOC entry 4973 (class 0 OID 0)
-- Dependencies: 226
-- Name: TABLE disciplines; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.disciplines TO borisov;
GRANT SELECT ON TABLE public.disciplines TO teacher_role;


--
-- TOC entry 4975 (class 0 OID 0)
-- Dependencies: 225
-- Name: SEQUENCE disciplines_discipline_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.disciplines_discipline_id_seq TO borisov;


--
-- TOC entry 4976 (class 0 OID 0)
-- Dependencies: 230
-- Name: TABLE grades; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.grades TO borisov;


--
-- TOC entry 4978 (class 0 OID 0)
-- Dependencies: 229
-- Name: SEQUENCE grades_grade_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.grades_grade_id_seq TO borisov;


--
-- TOC entry 4979 (class 0 OID 0)
-- Dependencies: 220
-- Name: TABLE groups; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.groups TO borisov;
GRANT SELECT ON TABLE public.groups TO teacher_role;


--
-- TOC entry 4981 (class 0 OID 0)
-- Dependencies: 219
-- Name: SEQUENCE groups_group_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.groups_group_id_seq TO borisov;


--
-- TOC entry 4982 (class 0 OID 0)
-- Dependencies: 228
-- Name: TABLE lessons; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.lessons TO borisov;
GRANT SELECT ON TABLE public.lessons TO teacher_role;


--
-- TOC entry 4984 (class 0 OID 0)
-- Dependencies: 227
-- Name: SEQUENCE lessons_lesson_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.lessons_lesson_id_seq TO borisov;


--
-- TOC entry 4985 (class 0 OID 0)
-- Dependencies: 222
-- Name: TABLE students; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.students TO borisov;
GRANT SELECT ON TABLE public.students TO teacher_role;


--
-- TOC entry 4987 (class 0 OID 0)
-- Dependencies: 221
-- Name: SEQUENCE students_student_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.students_student_id_seq TO borisov;


--
-- TOC entry 4988 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE teachers; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.teachers TO borisov;


--
-- TOC entry 4990 (class 0 OID 0)
-- Dependencies: 223
-- Name: SEQUENCE teachers_teacher_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.teachers_teacher_id_seq TO borisov;


--
-- TOC entry 4991 (class 0 OID 0)
-- Dependencies: 233
-- Name: TABLE v_my_grades; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.v_my_grades TO borisov;
GRANT SELECT ON TABLE public.v_my_grades TO student_role;


--
-- TOC entry 2089 (class 826 OID 33159)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT,USAGE ON SEQUENCES TO borisov;


--
-- TOC entry 2088 (class 826 OID 33158)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT,INSERT,DELETE,UPDATE ON TABLES TO borisov;


-- Completed on 2026-10-19 12:10:28

--
-- PostgreSQL database dump complete
--

\unrestrict jCynXoRnehU5vxhahfK6EN65AKjnNqyFbAL52bjhWlTPzWf3Dc7LmUEBgdEU06V

