--
-- PostgreSQL database dump
--

\restrict vSl86qQ5NQo5wdAthENGkWwUtQ5NlHLYgSUPldzoRMoatWb0Pxjv7bMaBihnZxE

-- Dumped from database version 16.16
-- Dumped by pg_dump version 16.16

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: appointment_status; Type: TYPE; Schema: public; Owner: avaroom_user
--

CREATE TYPE public.appointment_status AS ENUM (
    'PENDING',
    'CONFIRMED',
    'REJECTED',
    'CANCELLED',
    'COMPLETED'
);


ALTER TYPE public.appointment_status OWNER TO avaroom_user;

--
-- Name: approval_status; Type: TYPE; Schema: public; Owner: avaroom_user
--

CREATE TYPE public.approval_status AS ENUM (
    'PENDING',
    'APPROVED',
    'REJECTED'
);


ALTER TYPE public.approval_status OWNER TO avaroom_user;

--
-- Name: enum_rooms_approval_status; Type: TYPE; Schema: public; Owner: avaroom_user
--

CREATE TYPE public.enum_rooms_approval_status AS ENUM (
    'PENDING',
    'APPROVED',
    'REJECTED'
);


ALTER TYPE public.enum_rooms_approval_status OWNER TO avaroom_user;

--
-- Name: enum_rooms_room_status; Type: TYPE; Schema: public; Owner: avaroom_user
--

CREATE TYPE public.enum_rooms_room_status AS ENUM (
    'AVAILABLE',
    'RENTED',
    'HIDDEN'
);


ALTER TYPE public.enum_rooms_room_status OWNER TO avaroom_user;

--
-- Name: enum_rooms_room_type; Type: TYPE; Schema: public; Owner: avaroom_user
--

CREATE TYPE public.enum_rooms_room_type AS ENUM (
    'DORMITORY',
    'PRIVATE_ROOM',
    'SHARED_ROOM',
    'MINI_APARTMENT',
    'WHOLE_HOUSE'
);


ALTER TYPE public.enum_rooms_room_type OWNER TO avaroom_user;

--
-- Name: enum_users_role; Type: TYPE; Schema: public; Owner: avaroom_user
--

CREATE TYPE public.enum_users_role AS ENUM (
    'STUDENT',
    'LANDLORD',
    'ADMIN'
);


ALTER TYPE public.enum_users_role OWNER TO avaroom_user;

--
-- Name: enum_users_status; Type: TYPE; Schema: public; Owner: avaroom_user
--

CREATE TYPE public.enum_users_status AS ENUM (
    'ACTIVE',
    'INACTIVE',
    'SUSPENDED',
    'DELETED'
);


ALTER TYPE public.enum_users_status OWNER TO avaroom_user;

--
-- Name: notification_type; Type: TYPE; Schema: public; Owner: avaroom_user
--

CREATE TYPE public.notification_type AS ENUM (
    'APPOINTMENT',
    'ROOM_APPROVAL',
    'REPORT_UPDATE',
    'SYSTEM_ALERT'
);


ALTER TYPE public.notification_type OWNER TO avaroom_user;

--
-- Name: otp_type; Type: TYPE; Schema: public; Owner: avaroom_user
--

CREATE TYPE public.otp_type AS ENUM (
    'REGISTER',
    'RESET_PASSWORD',
    'VERIFY_EDU'
);


ALTER TYPE public.otp_type OWNER TO avaroom_user;

--
-- Name: report_reason; Type: TYPE; Schema: public; Owner: avaroom_user
--

CREATE TYPE public.report_reason AS ENUM (
    'FAKE_POST',
    'SCAM_DEPOSIT',
    'INACCURATE_PHOTOS',
    'INCORRECT_PRICING',
    'HARASSMENT',
    'OTHER'
);


ALTER TYPE public.report_reason OWNER TO avaroom_user;

--
-- Name: report_status; Type: TYPE; Schema: public; Owner: avaroom_user
--

CREATE TYPE public.report_status AS ENUM (
    'PENDING',
    'INVESTIGATING',
    'RESOLVED',
    'DISMISSED'
);


ALTER TYPE public.report_status OWNER TO avaroom_user;

--
-- Name: room_status; Type: TYPE; Schema: public; Owner: avaroom_user
--

CREATE TYPE public.room_status AS ENUM (
    'AVAILABLE',
    'RENTED',
    'HIDDEN'
);


ALTER TYPE public.room_status OWNER TO avaroom_user;

--
-- Name: room_type; Type: TYPE; Schema: public; Owner: avaroom_user
--

CREATE TYPE public.room_type AS ENUM (
    'DORMITORY',
    'PRIVATE_ROOM',
    'SHARED_ROOM',
    'MINI_APARTMENT',
    'WHOLE_HOUSE'
);


ALTER TYPE public.room_type OWNER TO avaroom_user;

--
-- Name: user_role; Type: TYPE; Schema: public; Owner: avaroom_user
--

CREATE TYPE public.user_role AS ENUM (
    'STUDENT',
    'LANDLORD',
    'ADMIN'
);


ALTER TYPE public.user_role OWNER TO avaroom_user;

--
-- Name: user_status; Type: TYPE; Schema: public; Owner: avaroom_user
--

CREATE TYPE public.user_status AS ENUM (
    'ACTIVE',
    'INACTIVE',
    'SUSPENDED',
    'DELETED'
);


ALTER TYPE public.user_status OWNER TO avaroom_user;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: amenities; Type: TABLE; Schema: public; Owner: avaroom_user
--

CREATE TABLE public.amenities (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    icon_url character varying(500),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.amenities OWNER TO avaroom_user;

--
-- Name: amenities_id_seq; Type: SEQUENCE; Schema: public; Owner: avaroom_user
--

CREATE SEQUENCE public.amenities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.amenities_id_seq OWNER TO avaroom_user;

--
-- Name: amenities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: avaroom_user
--

ALTER SEQUENCE public.amenities_id_seq OWNED BY public.amenities.id;


--
-- Name: appointments; Type: TABLE; Schema: public; Owner: avaroom_user
--

CREATE TABLE public.appointments (
    id bigint NOT NULL,
    student_id bigint NOT NULL,
    landlord_id bigint NOT NULL,
    room_id bigint NOT NULL,
    appointment_date date NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone,
    student_note text,
    rejection_reason text,
    cancellation_reason text,
    status public.appointment_status DEFAULT 'PENDING'::public.appointment_status NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.appointments OWNER TO avaroom_user;

--
-- Name: appointments_id_seq; Type: SEQUENCE; Schema: public; Owner: avaroom_user
--

CREATE SEQUENCE public.appointments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.appointments_id_seq OWNER TO avaroom_user;

--
-- Name: appointments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: avaroom_user
--

ALTER SEQUENCE public.appointments_id_seq OWNED BY public.appointments.id;


--
-- Name: device_tokens; Type: TABLE; Schema: public; Owner: avaroom_user
--

CREATE TABLE public.device_tokens (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    fcm_token character varying(500) NOT NULL,
    device_type character varying(50),
    is_active boolean DEFAULT true NOT NULL,
    last_used_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.device_tokens OWNER TO avaroom_user;

--
-- Name: device_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: avaroom_user
--

CREATE SEQUENCE public.device_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.device_tokens_id_seq OWNER TO avaroom_user;

--
-- Name: device_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: avaroom_user
--

ALTER SEQUENCE public.device_tokens_id_seq OWNED BY public.device_tokens.id;


--
-- Name: landlord_profiles; Type: TABLE; Schema: public; Owner: avaroom_user
--

CREATE TABLE public.landlord_profiles (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    phone_number character varying(20),
    identity_card_number character varying(20),
    identity_card_front character varying(500),
    identity_card_back character varying(500),
    contact_address text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.landlord_profiles OWNER TO avaroom_user;

--
-- Name: landlord_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: avaroom_user
--

CREATE SEQUENCE public.landlord_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.landlord_profiles_id_seq OWNER TO avaroom_user;

--
-- Name: landlord_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: avaroom_user
--

ALTER SEQUENCE public.landlord_profiles_id_seq OWNED BY public.landlord_profiles.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: avaroom_user
--

CREATE TABLE public.notifications (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    title character varying(200) NOT NULL,
    content text NOT NULL,
    type public.notification_type NOT NULL,
    reference_id bigint,
    reference_type character varying(50),
    is_read boolean DEFAULT false NOT NULL,
    read_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.notifications OWNER TO avaroom_user;

--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: avaroom_user
--

CREATE SEQUENCE public.notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.notifications_id_seq OWNER TO avaroom_user;

--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: avaroom_user
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: otps; Type: TABLE; Schema: public; Owner: avaroom_user
--

CREATE TABLE public.otps (
    id bigint NOT NULL,
    target character varying(255) NOT NULL,
    otp_code character varying(10) NOT NULL,
    type public.otp_type NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    is_used boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.otps OWNER TO avaroom_user;

--
-- Name: otps_id_seq; Type: SEQUENCE; Schema: public; Owner: avaroom_user
--

CREATE SEQUENCE public.otps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.otps_id_seq OWNER TO avaroom_user;

--
-- Name: otps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: avaroom_user
--

ALTER SEQUENCE public.otps_id_seq OWNED BY public.otps.id;


--
-- Name: password_reset_otps; Type: TABLE; Schema: public; Owner: avaroom_user
--

CREATE TABLE public.password_reset_otps (
    id bigint NOT NULL,
    email character varying(255) NOT NULL,
    otp_code character varying(6) NOT NULL,
    reset_token character varying(255),
    expires_at timestamp with time zone NOT NULL,
    is_used boolean DEFAULT false,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.password_reset_otps OWNER TO avaroom_user;

--
-- Name: password_reset_otps_id_seq; Type: SEQUENCE; Schema: public; Owner: avaroom_user
--

CREATE SEQUENCE public.password_reset_otps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.password_reset_otps_id_seq OWNER TO avaroom_user;

--
-- Name: password_reset_otps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: avaroom_user
--

ALTER SEQUENCE public.password_reset_otps_id_seq OWNED BY public.password_reset_otps.id;


--
-- Name: refresh_tokens; Type: TABLE; Schema: public; Owner: avaroom_user
--

CREATE TABLE public.refresh_tokens (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    token character varying(500) NOT NULL,
    device_info character varying(255),
    expires_at timestamp with time zone NOT NULL,
    is_revoked boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.refresh_tokens OWNER TO avaroom_user;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: avaroom_user
--

CREATE SEQUENCE public.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.refresh_tokens_id_seq OWNER TO avaroom_user;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: avaroom_user
--

ALTER SEQUENCE public.refresh_tokens_id_seq OWNED BY public.refresh_tokens.id;


--
-- Name: reports; Type: TABLE; Schema: public; Owner: avaroom_user
--

CREATE TABLE public.reports (
    id bigint NOT NULL,
    reporter_id bigint NOT NULL,
    reported_room_id bigint,
    reported_user_id bigint,
    reason public.report_reason NOT NULL,
    description text NOT NULL,
    evidence_images text[],
    status public.report_status DEFAULT 'PENDING'::public.report_status NOT NULL,
    admin_note text,
    resolved_by bigint,
    resolved_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.reports OWNER TO avaroom_user;

--
-- Name: reports_id_seq; Type: SEQUENCE; Schema: public; Owner: avaroom_user
--

CREATE SEQUENCE public.reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reports_id_seq OWNER TO avaroom_user;

--
-- Name: reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: avaroom_user
--

ALTER SEQUENCE public.reports_id_seq OWNED BY public.reports.id;


--
-- Name: reviews; Type: TABLE; Schema: public; Owner: avaroom_user
--

CREATE TABLE public.reviews (
    id bigint NOT NULL,
    room_id bigint NOT NULL,
    student_id bigint NOT NULL,
    rating integer NOT NULL,
    comment text,
    landlord_reply text,
    replied_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT reviews_rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);


ALTER TABLE public.reviews OWNER TO avaroom_user;

--
-- Name: reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: avaroom_user
--

CREATE SEQUENCE public.reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reviews_id_seq OWNER TO avaroom_user;

--
-- Name: reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: avaroom_user
--

ALTER SEQUENCE public.reviews_id_seq OWNED BY public.reviews.id;


--
-- Name: room_amenities; Type: TABLE; Schema: public; Owner: avaroom_user
--

CREATE TABLE public.room_amenities (
    room_id bigint NOT NULL,
    amenity_id bigint NOT NULL
);


ALTER TABLE public.room_amenities OWNER TO avaroom_user;

--
-- Name: room_images; Type: TABLE; Schema: public; Owner: avaroom_user
--

CREATE TABLE public.room_images (
    id bigint NOT NULL,
    room_id bigint NOT NULL,
    image_url character varying(500) NOT NULL,
    is_cover boolean DEFAULT false NOT NULL,
    display_order integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.room_images OWNER TO avaroom_user;

--
-- Name: room_images_id_seq; Type: SEQUENCE; Schema: public; Owner: avaroom_user
--

CREATE SEQUENCE public.room_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.room_images_id_seq OWNER TO avaroom_user;

--
-- Name: room_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: avaroom_user
--

ALTER SEQUENCE public.room_images_id_seq OWNED BY public.room_images.id;


--
-- Name: room_views; Type: TABLE; Schema: public; Owner: avaroom_user
--

CREATE TABLE public.room_views (
    id bigint NOT NULL,
    room_id bigint NOT NULL,
    user_id bigint,
    ip_address character varying(50),
    viewed_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.room_views OWNER TO avaroom_user;

--
-- Name: room_views_id_seq; Type: SEQUENCE; Schema: public; Owner: avaroom_user
--

CREATE SEQUENCE public.room_views_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.room_views_id_seq OWNER TO avaroom_user;

--
-- Name: room_views_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: avaroom_user
--

ALTER SEQUENCE public.room_views_id_seq OWNED BY public.room_views.id;


--
-- Name: rooms; Type: TABLE; Schema: public; Owner: avaroom_user
--

CREATE TABLE public.rooms (
    id bigint NOT NULL,
    landlord_id bigint NOT NULL,
    title character varying(255) NOT NULL,
    description text NOT NULL,
    room_type public.room_type DEFAULT 'PRIVATE_ROOM'::public.room_type NOT NULL,
    price numeric(12,2) NOT NULL,
    deposit numeric(12,2) DEFAULT 0 NOT NULL,
    electricity_cost numeric(10,2),
    water_cost numeric(10,2),
    internet_cost numeric(10,2),
    parking_fee numeric(10,2),
    area_sqm double precision NOT NULL,
    max_occupants integer DEFAULT 2 NOT NULL,
    province character varying(100) NOT NULL,
    district character varying(100) NOT NULL,
    ward character varying(100) NOT NULL,
    street_address character varying(255) NOT NULL,
    latitude double precision NOT NULL,
    longitude double precision NOT NULL,
    room_status public.room_status DEFAULT 'AVAILABLE'::public.room_status NOT NULL,
    approval_status public.approval_status DEFAULT 'PENDING'::public.approval_status NOT NULL,
    rejection_reason text,
    moderated_by bigint,
    moderated_at timestamp with time zone,
    view_count integer DEFAULT 0 NOT NULL,
    is_featured boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.rooms OWNER TO avaroom_user;

--
-- Name: rooms_id_seq; Type: SEQUENCE; Schema: public; Owner: avaroom_user
--

CREATE SEQUENCE public.rooms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.rooms_id_seq OWNER TO avaroom_user;

--
-- Name: rooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: avaroom_user
--

ALTER SEQUENCE public.rooms_id_seq OWNED BY public.rooms.id;


--
-- Name: saved_rooms; Type: TABLE; Schema: public; Owner: avaroom_user
--

CREATE TABLE public.saved_rooms (
    id bigint NOT NULL,
    student_id bigint NOT NULL,
    room_id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.saved_rooms OWNER TO avaroom_user;

--
-- Name: saved_rooms_id_seq; Type: SEQUENCE; Schema: public; Owner: avaroom_user
--

CREATE SEQUENCE public.saved_rooms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.saved_rooms_id_seq OWNER TO avaroom_user;

--
-- Name: saved_rooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: avaroom_user
--

ALTER SEQUENCE public.saved_rooms_id_seq OWNED BY public.saved_rooms.id;


--
-- Name: student_profiles; Type: TABLE; Schema: public; Owner: avaroom_user
--

CREATE TABLE public.student_profiles (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    university_id bigint,
    student_code character varying(50),
    academic_year character varying(20),
    student_card_image character varying(500),
    is_edu_verified boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.student_profiles OWNER TO avaroom_user;

--
-- Name: student_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: avaroom_user
--

CREATE SEQUENCE public.student_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.student_profiles_id_seq OWNER TO avaroom_user;

--
-- Name: student_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: avaroom_user
--

ALTER SEQUENCE public.student_profiles_id_seq OWNED BY public.student_profiles.id;


--
-- Name: universities; Type: TABLE; Schema: public; Owner: avaroom_user
--

CREATE TABLE public.universities (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    short_name character varying(50) NOT NULL,
    campus_name character varying(150),
    address character varying(300) NOT NULL,
    latitude double precision NOT NULL,
    longitude double precision NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.universities OWNER TO avaroom_user;

--
-- Name: universities_id_seq; Type: SEQUENCE; Schema: public; Owner: avaroom_user
--

CREATE SEQUENCE public.universities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.universities_id_seq OWNER TO avaroom_user;

--
-- Name: universities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: avaroom_user
--

ALTER SEQUENCE public.universities_id_seq OWNED BY public.universities.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: avaroom_user
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying(255) NOT NULL,
    phone_number character varying(20),
    password_hash character varying(255) NOT NULL,
    full_name character varying(100) NOT NULL,
    avatar_url character varying(500),
    role public.enum_users_role DEFAULT 'STUDENT'::public.enum_users_role NOT NULL,
    status public.enum_users_status DEFAULT 'ACTIVE'::public.enum_users_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.users OWNER TO avaroom_user;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: avaroom_user
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO avaroom_user;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: avaroom_user
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: amenities id; Type: DEFAULT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.amenities ALTER COLUMN id SET DEFAULT nextval('public.amenities_id_seq'::regclass);


--
-- Name: appointments id; Type: DEFAULT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.appointments ALTER COLUMN id SET DEFAULT nextval('public.appointments_id_seq'::regclass);


--
-- Name: device_tokens id; Type: DEFAULT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.device_tokens ALTER COLUMN id SET DEFAULT nextval('public.device_tokens_id_seq'::regclass);


--
-- Name: landlord_profiles id; Type: DEFAULT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.landlord_profiles ALTER COLUMN id SET DEFAULT nextval('public.landlord_profiles_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: otps id; Type: DEFAULT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.otps ALTER COLUMN id SET DEFAULT nextval('public.otps_id_seq'::regclass);


--
-- Name: password_reset_otps id; Type: DEFAULT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.password_reset_otps ALTER COLUMN id SET DEFAULT nextval('public.password_reset_otps_id_seq'::regclass);


--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('public.refresh_tokens_id_seq'::regclass);


--
-- Name: reports id; Type: DEFAULT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.reports ALTER COLUMN id SET DEFAULT nextval('public.reports_id_seq'::regclass);


--
-- Name: reviews id; Type: DEFAULT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.reviews ALTER COLUMN id SET DEFAULT nextval('public.reviews_id_seq'::regclass);


--
-- Name: room_images id; Type: DEFAULT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.room_images ALTER COLUMN id SET DEFAULT nextval('public.room_images_id_seq'::regclass);


--
-- Name: room_views id; Type: DEFAULT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.room_views ALTER COLUMN id SET DEFAULT nextval('public.room_views_id_seq'::regclass);


--
-- Name: rooms id; Type: DEFAULT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.rooms ALTER COLUMN id SET DEFAULT nextval('public.rooms_id_seq'::regclass);


--
-- Name: saved_rooms id; Type: DEFAULT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.saved_rooms ALTER COLUMN id SET DEFAULT nextval('public.saved_rooms_id_seq'::regclass);


--
-- Name: student_profiles id; Type: DEFAULT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.student_profiles ALTER COLUMN id SET DEFAULT nextval('public.student_profiles_id_seq'::regclass);


--
-- Name: universities id; Type: DEFAULT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.universities ALTER COLUMN id SET DEFAULT nextval('public.universities_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: amenities; Type: TABLE DATA; Schema: public; Owner: avaroom_user
--

COPY public.amenities (id, name, icon_url, created_at) FROM stdin;
\.


--
-- Data for Name: appointments; Type: TABLE DATA; Schema: public; Owner: avaroom_user
--

COPY public.appointments (id, student_id, landlord_id, room_id, appointment_date, start_time, end_time, student_note, rejection_reason, cancellation_reason, status, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: device_tokens; Type: TABLE DATA; Schema: public; Owner: avaroom_user
--

COPY public.device_tokens (id, user_id, fcm_token, device_type, is_active, last_used_at, created_at) FROM stdin;
\.


--
-- Data for Name: landlord_profiles; Type: TABLE DATA; Schema: public; Owner: avaroom_user
--

COPY public.landlord_profiles (id, user_id, phone_number, identity_card_number, identity_card_front, identity_card_back, contact_address, created_at, updated_at) FROM stdin;
1	12	0987654321	\N	\N	\N	\N	2026-11-02 17:48:00.321+00	2026-11-02 17:48:00.321+00
2	14	0346705101	\N	\N	\N	225 phạm văn đồng	2026-11-09 15:46:23.641+00	2026-11-09 15:46:23.641+00
3	15	0342705106	\N	\N	\N	225 phạm văn đồng	2026-11-09 15:47:17.704+00	2026-11-09 15:47:17.704+00
4	16	0123456888	\N	\N	\N	333	2026-11-09 16:15:52.793+00	2026-11-09 16:15:52.793+00
5	17	01112223333	\N	\N	\N	22 a	2026-11-09 16:35:30.414+00	2026-11-09 16:35:30.414+00
6	18	0356798658	\N	\N	\N	abch	2026-11-09 17:04:00.726+00	2026-11-09 17:13:13.607+00
7	19	0345123698	\N	\N	\N	1262	2026-11-10 01:32:36.189+00	2026-11-10 01:32:36.189+00
8	20	0345123215	079000000020	\N	\N	hsuh	2026-11-10 01:44:49.931+00	2026-11-10 01:46:43.498+00
9	21	03335554789	079000000021	\N	\N	225 pvd	2026-11-10 05:15:56.248+00	2026-11-10 05:18:05.445+00
10	22	0354123456	079000000022	\N	\N	222 bai	2026-11-10 05:24:28.665+00	2026-11-10 05:28:06.215+00
11	23	0645123456	079000000023	\N	\N	abxibs	2026-11-10 05:34:23.585+00	2026-11-10 05:38:20.187+00
12	24	0321456789	051205000639	\N	\N	ktx Khu B	2026-11-10 06:55:23.137+00	2026-11-10 06:56:11.002+00
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: avaroom_user
--

COPY public.notifications (id, user_id, title, content, type, reference_id, reference_type, is_read, read_at, created_at) FROM stdin;
\.


--
-- Data for Name: otps; Type: TABLE DATA; Schema: public; Owner: avaroom_user
--

COPY public.otps (id, target, otp_code, type, expires_at, is_used, created_at) FROM stdin;
\.


--
-- Data for Name: password_reset_otps; Type: TABLE DATA; Schema: public; Owner: avaroom_user
--

COPY public.password_reset_otps (id, email, otp_code, reset_token, expires_at, is_used, created_at, updated_at) FROM stdin;
9	23521512@gm.uit.edu.vn	300568	750fa7f183631f7ceec469ead5f8814e7d223c65d3248bbb4e109d39e51c08e8	2026-10-28 09:46:35.326+00	f	2026-10-28 09:36:35.332+00	2026-10-28 09:37:20.211+00
10	24521810@gm.uit.edu.vn	192858	83dd3df4af05587afd7ac0414aa7e72525c0ccccbb881970bb3146d1405fd160	2026-11-03 17:25:35.517+00	f	2026-11-03 17:15:35.519+00	2026-11-03 17:16:10.69+00
11	wog00527@laoia.com	798367	\N	2026-11-09 15:56:23.645+00	f	2026-11-09 15:46:23.648+00	2026-11-09 15:46:23.648+00
12	bof08181@laoia.com	999507	a08a4181f1c379cd094c94822202a3173bc56387719ee1db9ed737d89a361f7d	2026-11-09 15:57:17.709+00	f	2026-11-09 15:47:17.712+00	2026-11-09 15:49:06.647+00
13	hvj35588@laoia.com	287056	779789843085941d47db0bd8a3e118ed5413c24465f1fc3d33fba5edc95f74e7	2026-11-09 16:25:52.797+00	f	2026-11-09 16:15:52.799+00	2026-11-09 16:16:12.37+00
14	dmy05432@laoia.com	501701	a54f290bd89d9741a6ee8acaf9ec62c175f8d144b92c92ba4586e79c3e687c6c	2026-11-09 16:45:30.418+00	f	2026-11-09 16:35:30.42+00	2026-11-09 16:35:46.977+00
15	crv67602@laoia.com	456256	bd0cace77ad3f40ffe6d964c5510bee092181164ba79501a6c808e222f1d742c	2026-11-09 17:14:00.728+00	t	2026-11-09 17:04:00.73+00	2026-11-09 17:13:13.608+00
16	crv67602@laoia.com	402118	423165d7ef7c1270016bbd7177a0c589aae205a88741ba248ec2300b461e0fa9	2026-11-09 17:23:13.608+00	f	2026-11-09 17:13:13.61+00	2026-11-09 17:13:29.206+00
17	xdv30461@laoia.com	196046	37cf0641d67f5128ee09a1f600159be0d8602099ff14b7f721a4bbd3124a5512	2026-11-10 01:42:36.19+00	f	2026-11-10 01:32:36.193+00	2026-11-10 01:40:45.765+00
18	bss66437@laoia.com	939357	\N	2026-11-10 01:54:49.932+00	t	2026-11-10 01:44:49.935+00	2026-11-10 01:46:02.012+00
19	bss66437@laoia.com	903137	5de8fc74036e22b1cb2c6e1d70167c896bc181b1e5ded94f416e6fa631401449	2026-11-10 01:56:02.012+00	f	2026-11-10 01:46:02.014+00	2026-11-10 01:46:19.626+00
20	tmv30199@laoia.com	984630	08a2a7fb3004a408628248311ddb9ed18b107b2ba807e3abccae0982aa800213	2026-11-10 05:25:56.25+00	f	2026-11-10 05:15:56.252+00	2026-11-10 05:17:28.721+00
21	uyl97953@laoia.com	979185	a059e3aa96767e724f3c99e698f5bd7808a95a3229bf6cbc40dd6f4776b0452f	2026-11-10 05:34:28.667+00	f	2026-11-10 05:24:28.669+00	2026-11-10 05:26:02.996+00
22	rne39635@laoia.com	413888	69f3ba551128930abf6600622a4fc4601a7485981536c9a0e90c181940dda912	2026-11-10 05:44:23.587+00	f	2026-11-10 05:34:23.589+00	2026-11-10 05:37:51.464+00
23	fpx98739@zefvo.com	449326	5a190fd7e394c85bd8521c49429f2aece7199ab6a54c32fb402f50de4cd4d99d	2026-11-10 07:05:23.138+00	f	2026-11-10 06:55:23.141+00	2026-11-10 06:55:34.078+00
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: public; Owner: avaroom_user
--

COPY public.refresh_tokens (id, user_id, token, device_info, expires_at, is_revoked, created_at) FROM stdin;
9	11	a9e0c2b8371c9e56e6727da6836b0740e5675a9420568db3601711c1e4647f123336f6246c648e9f	okhttp/4.12.0	2026-11-04 09:36:35.324+00	f	2026-10-28 09:36:35.325+00
10	11	ae2fe768c17400bc45ef3e720acfd53bae87a31475261f72db1ab2dae9d2c6a5ccb46bc8b3394484	okhttp/4.12.0	2026-11-05 08:31:12.8+00	f	2026-10-29 08:31:12.801+00
11	11	812888439bcfdb8239708e9f06c856889d8a4dcfbc1f9b9dc913fec9542647f82d6348dba0cf7e6a	okhttp/4.12.0	2026-11-09 17:25:21.83+00	f	2026-11-02 17:25:21.831+00
12	12	f0fa6e0b3d13f7a8a2118bf6a0c1b3729db2afd18f3890411cb396399466a2a6766739907736a06e	okhttp/4.12.0	2026-11-09 17:48:24.578+00	f	2026-11-02 17:48:24.578+00
13	11	ffafba9355c7ce661c2800968bb734ab8c6b5e5fd4a63146a3b5fa9f1a021e2b70b142ea9c6e94ea	okhttp/4.12.0	2026-11-10 16:16:47.578+00	f	2026-11-03 16:16:47.579+00
14	12	5dc1eb6c2f32fcbcb8f967129f36675cffaeb74c03c9ac7a4a66d676bb4c258ea00f6b3503bf4372	okhttp/4.12.0	2026-11-10 17:08:58.208+00	f	2026-11-03 17:08:58.209+00
15	11	923fcb7004a568b6474f40a11eedd671f6befb29d95e76c12e65271e1d79e1fb3300b1a5212f0563	okhttp/4.12.0	2026-11-10 17:09:21.194+00	f	2026-11-03 17:09:21.194+00
16	13	508a6d09a34c92c8a6114110529e36af15f3aba97f67d4f5892526942303a27ca403b4f186050398	okhttp/4.12.0	2026-11-10 17:15:35.515+00	f	2026-11-03 17:15:35.515+00
17	13	88ed5a5ed83a7f60f6093233984bf1cc51ebf72352da78a0706c7ca702d79b676c7000ed0f9a7d99	okhttp/4.12.0	2026-11-10 17:16:10.697+00	f	2026-11-03 17:16:10.697+00
18	13	7361f71ba24899621db28a153955ba66a4d1639cc6ac5c49620dbee29ee611005659641dec895987	okhttp/4.12.0	2026-11-10 17:20:18.199+00	f	2026-11-03 17:20:18.199+00
19	13	7332393eca29d484d20607d507c534d93402bc17761be00a44c748926144d5966c4e2f87e7ff7b00	okhttp/4.12.0	2026-11-10 17:21:41.754+00	f	2026-11-03 17:21:41.755+00
20	13	334f152f43f976b75c488c7e01694de78915a47cf3d14547aea89ec98c9bdb71f067651ace2685ee	okhttp/4.12.0	2026-11-10 17:30:10.698+00	f	2026-11-03 17:30:10.698+00
21	13	f2e5492b13134fe8282b50d6b952883687648226de6f839430a371ad5108771032e3f600de2769b0	okhttp/4.12.0	2026-11-10 18:09:09.422+00	f	2026-11-03 18:09:09.422+00
22	13	fdd157b6d1a4b579de2d726ca6426f1115bcc7ea8b554924d5e3f795c609e104ef599c53ce7e1f89	okhttp/4.12.0	2026-11-10 18:17:54.027+00	f	2026-11-03 18:17:54.027+00
23	11	4ad91761f084cfa183795d8055926dc7cda020e26d170f762bfdb1237a2935619ed8a81ccbf86642	okhttp/4.12.0	2026-11-13 05:31:58.75+00	f	2026-11-06 05:31:58.751+00
24	11	9eef7bf7b12cfa0624e4ec3f02a117921db32207fb4bb1881f8d653314e5997ea43b21360c3fa87c	okhttp/4.12.0	2026-11-16 15:44:35.78+00	f	2026-11-09 15:44:35.781+00
25	14	24037c58b89f990de8b72cfc81f0b9e43e38f6329ae9e92d9bcdcfe18255ae7361a7485da5af7b87	okhttp/4.12.0	2026-11-16 15:46:23.644+00	f	2026-11-09 15:46:23.644+00
26	15	b99e22961ea07de6cfda0245d6937eddc81e6355148dac29437805e2b60584693f9012dc0cb3057b	okhttp/4.12.0	2026-11-16 15:47:17.707+00	f	2026-11-09 15:47:17.708+00
27	15	efc1d158e5bcfe1a3b710595d5570ac6e70dd53e5d880b62d0d798cb9eaf2612db7895a22d9ea847	okhttp/4.12.0	2026-11-16 15:49:06.653+00	f	2026-11-09 15:49:06.653+00
28	16	2bc56343ab04d7f03b4e09e2cc5217d9f79ba1d9eeaaa2ef2b7b477679bd424bbc3e98be610c377e	okhttp/4.12.0	2026-11-16 16:15:52.796+00	f	2026-11-09 16:15:52.796+00
29	16	6234ac553fcbfe58bfb28ca0027fc3ed17047f04c3da712dbb93d69f764895621d78b967e94fffa6	okhttp/4.12.0	2026-11-16 16:16:12.377+00	f	2026-11-09 16:16:12.377+00
30	17	1ebb9dbc97c3f08cd7ed2659e77bcfaf8bc0697bc457f7e914192829c5568302adc6e191012d4f79	okhttp/4.12.0	2026-11-16 16:35:30.417+00	f	2026-11-09 16:35:30.417+00
31	17	dfcf3b694d6f92bda6b26f1d06467ae9ba24fe851d1bd3db9a2425ef5a3ab6615f76a860b901120a	okhttp/4.12.0	2026-11-16 16:35:46.985+00	f	2026-11-09 16:35:46.985+00
32	18	df8280ea1c05a1fcbc5d32dc9b3960fc01bb3fafcfe8198551d2c1ef6c5cd6072531ac467c0aa5e9	okhttp/4.12.0	2026-11-16 17:04:13.333+00	f	2026-11-09 17:04:13.333+00
33	18	c7b92926298d33782f58a5b3436640dcb43eeb6d7e2355f754675a07647757b111824cb825972148	okhttp/4.12.0	2026-11-16 17:13:29.218+00	f	2026-11-09 17:13:29.218+00
34	19	fd05090d535b42689084017ab10dd4ad9e16b3c10c1be2909b3e037aa73969be2e7a6dcbba77f6a2	okhttp/4.12.0	2026-11-17 01:32:54.103+00	f	2026-11-10 01:32:54.103+00
35	19	d2b4020b1a1bb15509d122a10c3d44df23a9a91a4f8108f2c1a5e1678ea4505318cfca0bcc6e8251	okhttp/4.12.0	2026-11-17 01:40:45.777+00	f	2026-11-10 01:40:45.777+00
36	20	81350957c8a228a63bda8ab04ca8614d8b46290695f0175fc614b46648119107adb664c5c16b3485	okhttp/4.12.0	2026-11-17 01:46:19.638+00	f	2026-11-10 01:46:19.638+00
37	13	5273d406c9b1f9a89d469212438b30a596017ec0d903e4f716aa6392a2eba200c9308e2608e7c974	okhttp/4.12.0	2026-11-17 03:56:19.26+00	f	2026-11-10 03:56:19.26+00
38	11	2e8f69f777b6e04cb2335dfc749fe1597b37152afaa641b93af615eed14ab818ca7c10140046e1ba	okhttp/4.12.0	2026-11-17 04:10:45.012+00	f	2026-11-10 04:10:45.013+00
39	11	c55748b89c71808e87bff118e3053e6faf7e5e54f7a07286f967038d9a56ef10379d3b07115eade8	okhttp/4.12.0	2026-11-17 04:12:27.899+00	f	2026-11-10 04:12:27.899+00
40	11	d7bf2f49766feae0bef1117827f402df13d52be3bb51d47d69d9d0346449ef1bb9f5b9b4260071f3	okhttp/4.12.0	2026-11-17 04:41:32.313+00	f	2026-11-10 04:41:32.314+00
41	11	052cb79c228c584c466147154e1c92967efed9260279ba0225b5d2f9ac4c54980d013fad1cf75a25	okhttp/4.12.0	2026-11-17 04:53:09.244+00	f	2026-11-10 04:53:09.245+00
42	21	91b6ede059b824d5b04544d8b8ffcee0d35437840cb9d224e76d2c8bbb7aa8d89f779008c813e5e0	okhttp/4.12.0	2026-11-17 05:17:28.73+00	f	2026-11-10 05:17:28.73+00
43	22	4efede083a223badb78570968b6f135c1c41e694e8f135d1077680224c78e2ca8399604d0ce55a46	okhttp/4.12.0	2026-11-17 05:26:03.008+00	f	2026-11-10 05:26:03.008+00
44	23	eeba4a884839d3ae5c9ace3f8809fb9d4a5ec242c3c310cef183259c986e63a2daa13cd01a354578	okhttp/4.12.0	2026-11-17 05:34:36.321+00	f	2026-11-10 05:34:36.321+00
45	23	a13d0eb764af5e8d49e9d81ba0b5958a6aba1221dd51fd80db1a2e6407dc94393f54ac49935fc151	okhttp/4.12.0	2026-11-17 05:37:51.476+00	f	2026-11-10 05:37:51.477+00
46	11	6c636c0945071503dff9da959fdf0c1b51764bdc51cd952a88afdec922e9b1c318c3a3c29c9384bb	PostmanRuntime/2.15.0	2026-11-17 06:04:28.677+00	f	2026-11-10 06:04:28.677+00
47	11	8e5ef9e7d3acfc6e46a3330ce5558be3704df20d1d740f7a83d01f8b1fb77fdc8536983b92a94288	okhttp/4.12.0	2026-11-17 06:25:46.05+00	f	2026-11-10 06:25:46.051+00
48	12	8c591a38e97d0c32f92e39656971bfa6069f1f63197f104b8d81628478df742dbb5d80bab018ac98	okhttp/4.12.0	2026-11-17 06:36:25.724+00	f	2026-11-10 06:36:25.724+00
49	12	72de1c81e40af90c82190dc36d9a10475636764560ddf7cc761e35847725eb40391b02dcb0029f66	okhttp/4.12.0	2026-11-17 06:40:32.271+00	f	2026-11-10 06:40:32.271+00
50	11	04f0691b1b3848cc3905b08e1272a22d3584bc6cc7123841ce8ea9f0b392732bd8c7683d9df26276	okhttp/4.12.0	2026-11-17 06:48:47.355+00	f	2026-11-10 06:48:47.356+00
51	24	2e903ff05f49edfcab192bdeddca6449d1d0b96fe51ec5698f63040d16d51f164c93a22f7f88f647	okhttp/4.12.0	2026-11-17 06:55:34.086+00	f	2026-11-10 06:55:34.086+00
52	11	a753110ed3fb0a54118e848391c02c7be159dd4d23faf2c790a3328e26f913726a03f66548415593	okhttp/4.12.0	2026-11-24 10:25:56.644+00	f	2026-11-17 10:25:56.645+00
53	11	5fa6812be74febd0fca13f183c197c390b9bb74a39943b7da76e0410e1a341eb2c3c6e321278053c	okhttp/4.12.0	2026-11-24 11:29:11.883+00	f	2026-11-17 11:29:11.884+00
\.


--
-- Data for Name: reports; Type: TABLE DATA; Schema: public; Owner: avaroom_user
--

COPY public.reports (id, reporter_id, reported_room_id, reported_user_id, reason, description, evidence_images, status, admin_note, resolved_by, resolved_at, created_at) FROM stdin;
\.


--
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: avaroom_user
--

COPY public.reviews (id, room_id, student_id, rating, comment, landlord_reply, replied_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: room_amenities; Type: TABLE DATA; Schema: public; Owner: avaroom_user
--

COPY public.room_amenities (room_id, amenity_id) FROM stdin;
\.


--
-- Data for Name: room_images; Type: TABLE DATA; Schema: public; Owner: avaroom_user
--

COPY public.room_images (id, room_id, image_url, is_cover, display_order, created_at) FROM stdin;
1	1	https://images.unsplash.com/photo-1555854877-bab0e564b8d5?w=800	t	0	2026-11-10 04:18:43.469+00
2	1	https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?w=800	f	1	2026-11-10 04:18:43.474+00
3	2	https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800	t	0	2026-11-10 04:18:43.498+00
4	2	https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800	f	1	2026-11-10 04:18:43.502+00
5	3	https://images.unsplash.com/photo-1540518614846-7eded433c457?w=800	t	0	2026-11-10 04:18:43.515+00
6	4	https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800	t	0	2026-11-10 04:18:43.525+00
7	5	https://images.unsplash.com/photo-1484154218962-a197022b5858?w=800	t	0	2026-11-10 04:18:43.533+00
\.


--
-- Data for Name: room_views; Type: TABLE DATA; Schema: public; Owner: avaroom_user
--

COPY public.room_views (id, room_id, user_id, ip_address, viewed_at) FROM stdin;
\.


--
-- Data for Name: rooms; Type: TABLE DATA; Schema: public; Owner: avaroom_user
--

COPY public.rooms (id, landlord_id, title, description, room_type, price, deposit, electricity_cost, water_cost, internet_cost, parking_fee, area_sqm, max_occupants, province, district, ward, street_address, latitude, longitude, room_status, approval_status, rejection_reason, moderated_by, moderated_at, view_count, is_featured, created_at, updated_at) FROM stdin;
1	12	Phòng trọ cao cấp Quận 1 - Full nội thất gần ĐH Kinh Tế	Phòng mới xây cực kỳ sạch sẽ, thoáng mát, view đẹp. Đầy đủ tiện nghi: máy lạnh, tủ lạnh, giường nệm cao cấp, giờ giấc tự do không chung chủ.	PRIVATE_ROOM	3800000.00	3800000.00	3500.00	100000.00	100000.00	120000.00	25.5	2	TP. Hồ Chí Minh	Quận 1	Phường Bến Thành	45 Nguyễn Thị Nghĩa	10.7716	106.6934	AVAILABLE	APPROVED	\N	\N	\N	0	t	2026-11-10 04:18:43.459+00	2026-11-10 04:18:43.459+00
3	12	Phòng trọ sinh viên giá rẻ Gò Vấp - Ưu tiên SV ĐH Công Nghiệp	Phòng sạch sẽ có gác lửng, toilet riêng trong phòng, có chỗ để xe máy an toàn, khu dân cư an ninh, đi bộ 5 phút đến trường IUH.	PRIVATE_ROOM	2200000.00	2200000.00	3500.00	80000.00	70000.00	0.00	18	3	TP. Hồ Chí Minh	Gò Vấp	Phường 4	88 Nguyễn Văn Bảo	10.8231	106.6872	AVAILABLE	APPROVED	\N	\N	\N	0	f	2026-11-10 04:18:43.509+00	2026-11-10 04:18:43.509+00
5	12	Nhà nguyên căn Tân Bình - Phù hợp nhóm bạn ở chung 4-5 người	Nhà 1 trệt 1 lầu, 2 phòng ngủ, 2 WC, phòng khách rộng rãi, bếp nấu ăn thoải mái, sân phơi đồ riêng. Gần ĐH Bách Khoa và chợ Tân Bình.	WHOLE_HOUSE	7800000.00	7800000.00	2500.00	50000.00	120000.00	0.00	65	5	TP. Hồ Chí Minh	Tân Bình	Phường 7	15 Lý Thường Kiệt	10.7892	106.6578	AVAILABLE	APPROVED	\N	\N	\N	0	f	2026-11-10 04:18:43.529+00	2026-11-10 04:18:43.529+00
4	12	Căn hộ 1 phòng ngủ Thủ Đức - Gần Làng Đại học Quốc gia	Căn hộ chung cư cao cấp đầy đủ tiện ích: hồ bơi, siêu thị, phòng gym. Phòng ngủ riêng biệt, phòng khách view thoáng mát.	MINI_APARTMENT	5200000.00	5200000.00	3000.00	100000.00	100000.00	100000.00	40	3	TP. Hồ Chí Minh	Thủ Đức	Phường Linh Trung	25 Lê Văn Chí	10.8584	106.7725	AVAILABLE	APPROVED	\N	\N	\N	12	t	2026-11-10 04:18:43.519+00	2026-11-10 06:52:10.023+00
2	12	Studio Chung cư mini Bình Thạnh - Gần ĐH HUTECH & ĐH GTVT	Căn hộ dịch vụ mini có ban công thoáng mát, bếp nấu ăn riêng biệt, thang máy, bảo vệ 24/7, camera an ninh, khóa vân tay ra vào tự do.	MINI_APARTMENT	4500000.00	4500000.00	3800.00	120000.00	80000.00	100000.00	32	2	TP. Hồ Chí Minh	Bình Thạnh	Phường 25	12/5 Điện Biên Phủ	10.8015	106.7118	AVAILABLE	APPROVED	\N	\N	\N	4	t	2026-11-10 04:18:43.482+00	2026-11-17 11:29:15.184+00
\.


--
-- Data for Name: saved_rooms; Type: TABLE DATA; Schema: public; Owner: avaroom_user
--

COPY public.saved_rooms (id, student_id, room_id, created_at) FROM stdin;
\.


--
-- Data for Name: student_profiles; Type: TABLE DATA; Schema: public; Owner: avaroom_user
--

COPY public.student_profiles (id, user_id, university_id, student_code, academic_year, student_card_image, is_edu_verified, created_at, updated_at) FROM stdin;
9	11	\N	\N	\N	\N	f	2026-10-28 09:36:35.321+00	2026-10-28 09:36:35.321+00
10	13	\N	\N	\N	\N	f	2026-11-03 17:15:35.153657+00	2026-11-03 17:15:35.153657+00
\.


--
-- Data for Name: universities; Type: TABLE DATA; Schema: public; Owner: avaroom_user
--

COPY public.universities (id, name, short_name, campus_name, address, latitude, longitude, created_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: avaroom_user
--

COPY public.users (id, email, phone_number, password_hash, full_name, avatar_url, role, status, created_at, updated_at) FROM stdin;
11	23521512@gm.uit.edu.vn	0346705106	$2a$12$8Gc4W7ypDDzKeKnl96v9rOFUwXzJ9xeofYQsf9m0nDyvLRPy7.Fcm	ABC	\N	STUDENT	ACTIVE	2026-10-28 09:36:34.973+00	2026-10-28 09:36:34.973+00
12	chutro@gmail.com	0987654321	$2a$12$MA4I2owKV.FLfiIyIDJSE.Hz6fhZIXg/9GPpEagSkJnfRYK5TKeu2	Chủ Trọ Demo	\N	LANDLORD	ACTIVE	2026-11-02 17:47:59.967+00	2026-11-02 17:47:59.967+00
13	24521810@gm.uit.edu.vn	0123456789	$2a$12$e8yV4mXXxhZL7jAe/romXuk4IetUNbGK8Ivd9BwirG7R8Lm8V2DVO	Chan Chan	\N	STUDENT	ACTIVE	2026-11-03 17:15:35.163+00	2026-11-03 17:15:35.163+00
14	wog00527@laoia.com	0346705101	$2a$12$dfw.wrajnKM.5y0WTmboiOm3pFhOGj3oSKqjPSN6A4GTu4RqECIK6	Xyz	\N	LANDLORD	ACTIVE	2026-11-09 15:46:23.306+00	2026-11-09 15:46:23.306+00
15	bof08181@laoia.com	0342705106	$2a$12$MTf5nVBJH1KusRKpXeFUiOFADRghDd0b5V2E/3LJ3QIZNgzovY1Wm	Xyz	\N	LANDLORD	ACTIVE	2026-11-09 15:47:17.357+00	2026-11-09 15:47:17.357+00
16	hvj35588@laoia.com	0123456888	$2a$12$WehmKjcAWY33/R2l.Mak7uJaSLtrH96zYEppoDRJxawv0XvtUilVO	ABC	\N	LANDLORD	ACTIVE	2026-11-09 16:15:52.459+00	2026-11-09 16:15:52.459+00
17	dmy05432@laoia.com	01112223333	$2a$12$mKHmYO07CWGkej5sRLUc/e9Ev5GXTdA.1M67rXBClDkCxAlXNLZbi	d	\N	LANDLORD	ACTIVE	2026-11-09 16:35:30.083+00	2026-11-09 16:35:30.083+00
18	crv67602@laoia.com	0356798658	$2a$12$bcNFs7GW6SAjSKZ8u57Mn.WF0abQEqSGShkS.bJKWGORA7c.VGp26	abxj	\N	LANDLORD	INACTIVE	2026-11-09 17:04:00.378+00	2026-11-09 17:13:13.258+00
19	xdv30461@laoia.com	0345123698	$2a$12$5uo1IpACHLVnqt42J.wT9enr3AZwhiA8NXbgoG6Tt23A1t9TysEry	abc	\N	LANDLORD	INACTIVE	2026-11-10 01:32:35.841+00	2026-11-10 01:32:35.841+00
20	bss66437@laoia.com	0345123215	$2a$12$x7UY4glM7Hs3M4g7VwiQ8uentN2.D/LTMdakqs2/0UfnAfgbskLhm	abc	\N	LANDLORD	ACTIVE	2026-11-10 01:44:49.582+00	2026-11-10 01:46:43.503+00
21	tmv30199@laoia.com	03335554789	$2a$12$WEbzWsBakTQNwDbo9mcGreLSVII1mS0j90sm/d4kTObaRfi1LI.Ha	ABCX	\N	LANDLORD	ACTIVE	2026-11-10 05:15:55.914+00	2026-11-10 05:18:05.451+00
22	uyl97953@laoia.com	0354123456	$2a$12$exkFmooWXhORDToxn08pFOOzAiwLHx6/NOo/KUUtqAMQMNdz/gi1C	abcg	\N	LANDLORD	ACTIVE	2026-11-10 05:24:28.317+00	2026-11-10 05:28:06.225+00
23	rne39635@laoia.com	0645123456	$2a$12$c.n7ovTpLzYUpufQwoc98eavO5WE9YDqR5xgQxHlqIFNqc8o4npq6	abc	\N	LANDLORD	ACTIVE	2026-11-10 05:34:23.238+00	2026-11-10 05:38:20.194+00
24	fpx98739@zefvo.com	0321456789	$2a$12$n.ez9vUGuBebCy7ebq/Oieiky3V0XfetNq.7nBqzz3f5UOqzcePE2	Trần Hữu Thịnh	\N	LANDLORD	ACTIVE	2026-11-10 06:55:22.803+00	2026-11-10 06:56:11.006+00
\.


--
-- Name: amenities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: avaroom_user
--

SELECT pg_catalog.setval('public.amenities_id_seq', 1, false);


--
-- Name: appointments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: avaroom_user
--

SELECT pg_catalog.setval('public.appointments_id_seq', 1, false);


--
-- Name: device_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: avaroom_user
--

SELECT pg_catalog.setval('public.device_tokens_id_seq', 1, false);


--
-- Name: landlord_profiles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: avaroom_user
--

SELECT pg_catalog.setval('public.landlord_profiles_id_seq', 12, true);


--
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: avaroom_user
--

SELECT pg_catalog.setval('public.notifications_id_seq', 1, false);


--
-- Name: otps_id_seq; Type: SEQUENCE SET; Schema: public; Owner: avaroom_user
--

SELECT pg_catalog.setval('public.otps_id_seq', 1, false);


--
-- Name: password_reset_otps_id_seq; Type: SEQUENCE SET; Schema: public; Owner: avaroom_user
--

SELECT pg_catalog.setval('public.password_reset_otps_id_seq', 23, true);


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: avaroom_user
--

SELECT pg_catalog.setval('public.refresh_tokens_id_seq', 53, true);


--
-- Name: reports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: avaroom_user
--

SELECT pg_catalog.setval('public.reports_id_seq', 1, false);


--
-- Name: reviews_id_seq; Type: SEQUENCE SET; Schema: public; Owner: avaroom_user
--

SELECT pg_catalog.setval('public.reviews_id_seq', 1, false);


--
-- Name: room_images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: avaroom_user
--

SELECT pg_catalog.setval('public.room_images_id_seq', 7, true);


--
-- Name: room_views_id_seq; Type: SEQUENCE SET; Schema: public; Owner: avaroom_user
--

SELECT pg_catalog.setval('public.room_views_id_seq', 1, false);


--
-- Name: rooms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: avaroom_user
--

SELECT pg_catalog.setval('public.rooms_id_seq', 5, true);


--
-- Name: saved_rooms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: avaroom_user
--

SELECT pg_catalog.setval('public.saved_rooms_id_seq', 1, false);


--
-- Name: student_profiles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: avaroom_user
--

SELECT pg_catalog.setval('public.student_profiles_id_seq', 10, true);


--
-- Name: universities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: avaroom_user
--

SELECT pg_catalog.setval('public.universities_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: avaroom_user
--

SELECT pg_catalog.setval('public.users_id_seq', 24, true);


--
-- Name: amenities amenities_name_key; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.amenities
    ADD CONSTRAINT amenities_name_key UNIQUE (name);


--
-- Name: amenities amenities_pkey; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.amenities
    ADD CONSTRAINT amenities_pkey PRIMARY KEY (id);


--
-- Name: appointments appointments_pkey; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_pkey PRIMARY KEY (id);


--
-- Name: device_tokens device_tokens_fcm_token_key; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.device_tokens
    ADD CONSTRAINT device_tokens_fcm_token_key UNIQUE (fcm_token);


--
-- Name: device_tokens device_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.device_tokens
    ADD CONSTRAINT device_tokens_pkey PRIMARY KEY (id);


--
-- Name: landlord_profiles landlord_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.landlord_profiles
    ADD CONSTRAINT landlord_profiles_pkey PRIMARY KEY (id);


--
-- Name: landlord_profiles landlord_profiles_user_id_key; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.landlord_profiles
    ADD CONSTRAINT landlord_profiles_user_id_key UNIQUE (user_id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: otps otps_pkey; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.otps
    ADD CONSTRAINT otps_pkey PRIMARY KEY (id);


--
-- Name: password_reset_otps password_reset_otps_pkey; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.password_reset_otps
    ADD CONSTRAINT password_reset_otps_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_key; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_key UNIQUE (token);


--
-- Name: reports reports_pkey; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);


--
-- Name: reviews reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (id);


--
-- Name: room_amenities room_amenities_pkey; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.room_amenities
    ADD CONSTRAINT room_amenities_pkey PRIMARY KEY (room_id, amenity_id);


--
-- Name: room_images room_images_pkey; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.room_images
    ADD CONSTRAINT room_images_pkey PRIMARY KEY (id);


--
-- Name: room_views room_views_pkey; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.room_views
    ADD CONSTRAINT room_views_pkey PRIMARY KEY (id);


--
-- Name: rooms rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (id);


--
-- Name: saved_rooms saved_rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.saved_rooms
    ADD CONSTRAINT saved_rooms_pkey PRIMARY KEY (id);


--
-- Name: student_profiles student_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.student_profiles
    ADD CONSTRAINT student_profiles_pkey PRIMARY KEY (id);


--
-- Name: student_profiles student_profiles_user_id_key; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.student_profiles
    ADD CONSTRAINT student_profiles_user_id_key UNIQUE (user_id);


--
-- Name: universities universities_pkey; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.universities
    ADD CONSTRAINT universities_pkey PRIMARY KEY (id);


--
-- Name: saved_rooms uq_saved_rooms; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.saved_rooms
    ADD CONSTRAINT uq_saved_rooms UNIQUE (student_id, room_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_email_key1; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key1 UNIQUE (email);


--
-- Name: users users_email_key10; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key10 UNIQUE (email);


--
-- Name: users users_email_key11; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key11 UNIQUE (email);


--
-- Name: users users_email_key12; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key12 UNIQUE (email);


--
-- Name: users users_email_key13; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key13 UNIQUE (email);


--
-- Name: users users_email_key14; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key14 UNIQUE (email);


--
-- Name: users users_email_key15; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key15 UNIQUE (email);


--
-- Name: users users_email_key16; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key16 UNIQUE (email);


--
-- Name: users users_email_key17; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key17 UNIQUE (email);


--
-- Name: users users_email_key18; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key18 UNIQUE (email);


--
-- Name: users users_email_key19; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key19 UNIQUE (email);


--
-- Name: users users_email_key2; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key2 UNIQUE (email);


--
-- Name: users users_email_key20; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key20 UNIQUE (email);


--
-- Name: users users_email_key21; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key21 UNIQUE (email);


--
-- Name: users users_email_key22; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key22 UNIQUE (email);


--
-- Name: users users_email_key23; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key23 UNIQUE (email);


--
-- Name: users users_email_key24; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key24 UNIQUE (email);


--
-- Name: users users_email_key25; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key25 UNIQUE (email);


--
-- Name: users users_email_key26; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key26 UNIQUE (email);


--
-- Name: users users_email_key27; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key27 UNIQUE (email);


--
-- Name: users users_email_key28; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key28 UNIQUE (email);


--
-- Name: users users_email_key29; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key29 UNIQUE (email);


--
-- Name: users users_email_key3; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key3 UNIQUE (email);


--
-- Name: users users_email_key30; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key30 UNIQUE (email);


--
-- Name: users users_email_key31; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key31 UNIQUE (email);


--
-- Name: users users_email_key32; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key32 UNIQUE (email);


--
-- Name: users users_email_key33; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key33 UNIQUE (email);


--
-- Name: users users_email_key34; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key34 UNIQUE (email);


--
-- Name: users users_email_key35; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key35 UNIQUE (email);


--
-- Name: users users_email_key36; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key36 UNIQUE (email);


--
-- Name: users users_email_key37; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key37 UNIQUE (email);


--
-- Name: users users_email_key38; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key38 UNIQUE (email);


--
-- Name: users users_email_key39; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key39 UNIQUE (email);


--
-- Name: users users_email_key4; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key4 UNIQUE (email);


--
-- Name: users users_email_key40; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key40 UNIQUE (email);


--
-- Name: users users_email_key41; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key41 UNIQUE (email);


--
-- Name: users users_email_key42; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key42 UNIQUE (email);


--
-- Name: users users_email_key43; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key43 UNIQUE (email);


--
-- Name: users users_email_key44; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key44 UNIQUE (email);


--
-- Name: users users_email_key45; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key45 UNIQUE (email);


--
-- Name: users users_email_key46; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key46 UNIQUE (email);


--
-- Name: users users_email_key47; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key47 UNIQUE (email);


--
-- Name: users users_email_key48; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key48 UNIQUE (email);


--
-- Name: users users_email_key49; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key49 UNIQUE (email);


--
-- Name: users users_email_key5; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key5 UNIQUE (email);


--
-- Name: users users_email_key50; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key50 UNIQUE (email);


--
-- Name: users users_email_key51; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key51 UNIQUE (email);


--
-- Name: users users_email_key52; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key52 UNIQUE (email);


--
-- Name: users users_email_key53; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key53 UNIQUE (email);


--
-- Name: users users_email_key54; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key54 UNIQUE (email);


--
-- Name: users users_email_key55; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key55 UNIQUE (email);


--
-- Name: users users_email_key56; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key56 UNIQUE (email);


--
-- Name: users users_email_key57; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key57 UNIQUE (email);


--
-- Name: users users_email_key58; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key58 UNIQUE (email);


--
-- Name: users users_email_key59; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key59 UNIQUE (email);


--
-- Name: users users_email_key6; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key6 UNIQUE (email);


--
-- Name: users users_email_key60; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key60 UNIQUE (email);


--
-- Name: users users_email_key61; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key61 UNIQUE (email);


--
-- Name: users users_email_key62; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key62 UNIQUE (email);


--
-- Name: users users_email_key63; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key63 UNIQUE (email);


--
-- Name: users users_email_key64; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key64 UNIQUE (email);


--
-- Name: users users_email_key65; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key65 UNIQUE (email);


--
-- Name: users users_email_key66; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key66 UNIQUE (email);


--
-- Name: users users_email_key67; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key67 UNIQUE (email);


--
-- Name: users users_email_key68; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key68 UNIQUE (email);


--
-- Name: users users_email_key69; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key69 UNIQUE (email);


--
-- Name: users users_email_key7; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key7 UNIQUE (email);


--
-- Name: users users_email_key70; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key70 UNIQUE (email);


--
-- Name: users users_email_key71; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key71 UNIQUE (email);


--
-- Name: users users_email_key72; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key72 UNIQUE (email);


--
-- Name: users users_email_key73; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key73 UNIQUE (email);


--
-- Name: users users_email_key74; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key74 UNIQUE (email);


--
-- Name: users users_email_key75; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key75 UNIQUE (email);


--
-- Name: users users_email_key76; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key76 UNIQUE (email);


--
-- Name: users users_email_key77; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key77 UNIQUE (email);


--
-- Name: users users_email_key78; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key78 UNIQUE (email);


--
-- Name: users users_email_key79; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key79 UNIQUE (email);


--
-- Name: users users_email_key8; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key8 UNIQUE (email);


--
-- Name: users users_email_key80; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key80 UNIQUE (email);


--
-- Name: users users_email_key81; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key81 UNIQUE (email);


--
-- Name: users users_email_key82; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key82 UNIQUE (email);


--
-- Name: users users_email_key83; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key83 UNIQUE (email);


--
-- Name: users users_email_key84; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key84 UNIQUE (email);


--
-- Name: users users_email_key85; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key85 UNIQUE (email);


--
-- Name: users users_email_key86; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key86 UNIQUE (email);


--
-- Name: users users_email_key87; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key87 UNIQUE (email);


--
-- Name: users users_email_key88; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key88 UNIQUE (email);


--
-- Name: users users_email_key89; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key89 UNIQUE (email);


--
-- Name: users users_email_key9; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key9 UNIQUE (email);


--
-- Name: users users_email_key90; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key90 UNIQUE (email);


--
-- Name: users users_email_key91; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key91 UNIQUE (email);


--
-- Name: users users_phone_number_key; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key UNIQUE (phone_number);


--
-- Name: users users_phone_number_key1; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key1 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key10; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key10 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key11; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key11 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key12; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key12 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key13; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key13 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key14; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key14 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key15; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key15 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key16; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key16 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key17; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key17 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key18; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key18 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key19; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key19 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key2; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key2 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key20; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key20 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key21; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key21 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key22; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key22 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key23; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key23 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key24; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key24 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key25; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key25 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key26; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key26 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key27; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key27 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key28; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key28 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key29; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key29 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key3; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key3 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key30; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key30 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key31; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key31 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key32; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key32 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key33; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key33 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key34; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key34 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key35; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key35 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key36; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key36 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key37; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key37 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key38; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key38 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key39; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key39 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key4; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key4 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key40; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key40 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key41; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key41 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key42; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key42 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key43; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key43 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key44; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key44 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key45; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key45 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key46; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key46 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key47; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key47 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key48; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key48 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key49; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key49 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key5; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key5 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key50; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key50 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key51; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key51 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key52; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key52 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key53; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key53 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key54; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key54 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key55; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key55 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key56; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key56 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key57; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key57 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key58; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key58 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key59; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key59 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key6; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key6 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key60; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key60 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key61; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key61 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key62; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key62 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key63; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key63 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key64; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key64 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key65; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key65 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key66; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key66 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key67; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key67 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key68; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key68 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key69; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key69 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key7; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key7 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key70; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key70 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key71; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key71 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key72; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key72 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key73; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key73 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key74; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key74 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key75; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key75 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key76; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key76 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key77; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key77 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key78; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key78 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key79; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key79 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key8; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key8 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key80; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key80 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key81; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key81 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key82; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key82 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key83; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key83 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key84; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key84 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key85; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key85 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key86; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key86 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key87; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key87 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key88; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key88 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key89; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key89 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key9; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key9 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key90; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key90 UNIQUE (phone_number);


--
-- Name: users users_phone_number_key91; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key91 UNIQUE (phone_number);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_appointments_date; Type: INDEX; Schema: public; Owner: avaroom_user
--

CREATE INDEX idx_appointments_date ON public.appointments USING btree (appointment_date);


--
-- Name: idx_appointments_landlord; Type: INDEX; Schema: public; Owner: avaroom_user
--

CREATE INDEX idx_appointments_landlord ON public.appointments USING btree (landlord_id);


--
-- Name: idx_appointments_room; Type: INDEX; Schema: public; Owner: avaroom_user
--

CREATE INDEX idx_appointments_room ON public.appointments USING btree (room_id);


--
-- Name: idx_appointments_status; Type: INDEX; Schema: public; Owner: avaroom_user
--

CREATE INDEX idx_appointments_status ON public.appointments USING btree (status);


--
-- Name: idx_appointments_student; Type: INDEX; Schema: public; Owner: avaroom_user
--

CREATE INDEX idx_appointments_student ON public.appointments USING btree (student_id);


--
-- Name: idx_device_tokens_user; Type: INDEX; Schema: public; Owner: avaroom_user
--

CREATE INDEX idx_device_tokens_user ON public.device_tokens USING btree (user_id);


--
-- Name: idx_notifications_is_read; Type: INDEX; Schema: public; Owner: avaroom_user
--

CREATE INDEX idx_notifications_is_read ON public.notifications USING btree (is_read);


--
-- Name: idx_notifications_user; Type: INDEX; Schema: public; Owner: avaroom_user
--

CREATE INDEX idx_notifications_user ON public.notifications USING btree (user_id);


--
-- Name: idx_otps_target_code; Type: INDEX; Schema: public; Owner: avaroom_user
--

CREATE INDEX idx_otps_target_code ON public.otps USING btree (target, otp_code);


--
-- Name: idx_refresh_tokens_token; Type: INDEX; Schema: public; Owner: avaroom_user
--

CREATE INDEX idx_refresh_tokens_token ON public.refresh_tokens USING btree (token);


--
-- Name: idx_reports_room; Type: INDEX; Schema: public; Owner: avaroom_user
--

CREATE INDEX idx_reports_room ON public.reports USING btree (reported_room_id);


--
-- Name: idx_reports_status; Type: INDEX; Schema: public; Owner: avaroom_user
--

CREATE INDEX idx_reports_status ON public.reports USING btree (status);


--
-- Name: idx_reports_user; Type: INDEX; Schema: public; Owner: avaroom_user
--

CREATE INDEX idx_reports_user ON public.reports USING btree (reported_user_id);


--
-- Name: idx_reviews_room; Type: INDEX; Schema: public; Owner: avaroom_user
--

CREATE INDEX idx_reviews_room ON public.reviews USING btree (room_id);


--
-- Name: idx_reviews_student; Type: INDEX; Schema: public; Owner: avaroom_user
--

CREATE INDEX idx_reviews_student ON public.reviews USING btree (student_id);


--
-- Name: idx_room_images_room; Type: INDEX; Schema: public; Owner: avaroom_user
--

CREATE INDEX idx_room_images_room ON public.room_images USING btree (room_id);


--
-- Name: idx_room_views_date; Type: INDEX; Schema: public; Owner: avaroom_user
--

CREATE INDEX idx_room_views_date ON public.room_views USING btree (viewed_at);


--
-- Name: idx_room_views_room; Type: INDEX; Schema: public; Owner: avaroom_user
--

CREATE INDEX idx_room_views_room ON public.room_views USING btree (room_id);


--
-- Name: idx_rooms_approval; Type: INDEX; Schema: public; Owner: avaroom_user
--

CREATE INDEX idx_rooms_approval ON public.rooms USING btree (approval_status);


--
-- Name: idx_rooms_district; Type: INDEX; Schema: public; Owner: avaroom_user
--

CREATE INDEX idx_rooms_district ON public.rooms USING btree (district);


--
-- Name: idx_rooms_geo; Type: INDEX; Schema: public; Owner: avaroom_user
--

CREATE INDEX idx_rooms_geo ON public.rooms USING btree (latitude, longitude);


--
-- Name: idx_rooms_landlord; Type: INDEX; Schema: public; Owner: avaroom_user
--

CREATE INDEX idx_rooms_landlord ON public.rooms USING btree (landlord_id);


--
-- Name: idx_rooms_price; Type: INDEX; Schema: public; Owner: avaroom_user
--

CREATE INDEX idx_rooms_price ON public.rooms USING btree (price);


--
-- Name: idx_rooms_status; Type: INDEX; Schema: public; Owner: avaroom_user
--

CREATE INDEX idx_rooms_status ON public.rooms USING btree (room_status);


--
-- Name: idx_universities_coords; Type: INDEX; Schema: public; Owner: avaroom_user
--

CREATE INDEX idx_universities_coords ON public.universities USING btree (latitude, longitude);


--
-- Name: idx_users_email; Type: INDEX; Schema: public; Owner: avaroom_user
--

CREATE INDEX idx_users_email ON public.users USING btree (email);


--
-- Name: idx_users_phone; Type: INDEX; Schema: public; Owner: avaroom_user
--

CREATE INDEX idx_users_phone ON public.users USING btree (phone_number);


--
-- Name: idx_users_role; Type: INDEX; Schema: public; Owner: avaroom_user
--

CREATE INDEX idx_users_role ON public.users USING btree (role);


--
-- Name: appointments appointments_landlord_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_landlord_id_fkey FOREIGN KEY (landlord_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: appointments appointments_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id) ON DELETE CASCADE;


--
-- Name: appointments appointments_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: device_tokens device_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.device_tokens
    ADD CONSTRAINT device_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: landlord_profiles landlord_profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.landlord_profiles
    ADD CONSTRAINT landlord_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: reports reports_reported_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_reported_room_id_fkey FOREIGN KEY (reported_room_id) REFERENCES public.rooms(id) ON DELETE SET NULL;


--
-- Name: reports reports_reported_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_reported_user_id_fkey FOREIGN KEY (reported_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: reports reports_reporter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_reporter_id_fkey FOREIGN KEY (reporter_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: reports reports_resolved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_resolved_by_fkey FOREIGN KEY (resolved_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: reviews reviews_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id) ON DELETE CASCADE;


--
-- Name: reviews reviews_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: room_amenities room_amenities_amenity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.room_amenities
    ADD CONSTRAINT room_amenities_amenity_id_fkey FOREIGN KEY (amenity_id) REFERENCES public.amenities(id) ON DELETE CASCADE;


--
-- Name: room_amenities room_amenities_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.room_amenities
    ADD CONSTRAINT room_amenities_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id) ON DELETE CASCADE;


--
-- Name: room_images room_images_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.room_images
    ADD CONSTRAINT room_images_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id) ON DELETE CASCADE;


--
-- Name: room_views room_views_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.room_views
    ADD CONSTRAINT room_views_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id) ON DELETE CASCADE;


--
-- Name: room_views room_views_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.room_views
    ADD CONSTRAINT room_views_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: rooms rooms_landlord_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_landlord_id_fkey FOREIGN KEY (landlord_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: rooms rooms_moderated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_moderated_by_fkey FOREIGN KEY (moderated_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: saved_rooms saved_rooms_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.saved_rooms
    ADD CONSTRAINT saved_rooms_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.rooms(id) ON DELETE CASCADE;


--
-- Name: saved_rooms saved_rooms_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.saved_rooms
    ADD CONSTRAINT saved_rooms_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: student_profiles student_profiles_university_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.student_profiles
    ADD CONSTRAINT student_profiles_university_id_fkey FOREIGN KEY (university_id) REFERENCES public.universities(id) ON DELETE SET NULL;


--
-- Name: student_profiles student_profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: avaroom_user
--

ALTER TABLE ONLY public.student_profiles
    ADD CONSTRAINT student_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict vSl86qQ5NQo5wdAthENGkWwUtQ5NlHLYgSUPldzoRMoatWb0Pxjv7bMaBihnZxE

