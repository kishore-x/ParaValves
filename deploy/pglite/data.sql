set session_replication_role = replica;
--
-- PostgreSQL database dump
--


-- Dumped from database version 16.15 (Postgres.app)
-- Dumped by pg_dump version 16.15 (Postgres.app)

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
-- Data for Name: organizations; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.organizations VALUES
	('4a0f88e6-467f-406c-a37b-fde4abff9898', 'IN', 'Paravalves India', 'IN', 'INR', '33AABCP0000A1Z5', '33', NULL, true, '2026-10-27 14:05:21.445587+00', '2026-10-27 14:05:21.445587+00', 1),
	('b10f5674-4156-474a-864f-22de1bbc6757', 'ES', 'Paravalves Spain', 'ES', 'EUR', NULL, NULL, NULL, true, '2026-10-27 14:05:21.445587+00', '2026-10-27 14:05:21.445587+00', 1);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.users VALUES
	('cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'admin@paravalves.com', 'System Admin', 'scrypt$16384$642be20b8143a1ea7101cb3ad4cd55b1$b89df920f38ce5ad4f68c85c69d8fddf890d42c70a3d6ddde6ff2ca7bc20914909ce71de7b09a0f9ab99d9064f3e11f4fde4880699b99287f65b7be7920fbffe', true, true, NULL, '2026-10-27 14:05:21.445587+00', '2026-10-27 14:05:21.445587+00', 1),
	('0258e002-4154-48b4-ad1d-2195882841be', 'sales@paravalves.com', 'Ravi Kumar (Sales)', 'scrypt$16384$821fc97a8ecac39efa61f2cd0f1fe814$c17c7af423746de9dc5a85a1bb4d1d3466c1943932cbf1dd959307f5a29028785216f5606fc7bf8654346900d5656cf3e0471fb6d4f1537a44c55804771939c4', true, false, NULL, '2026-10-27 14:05:21.445587+00', '2026-10-27 14:05:21.445587+00', 1),
	('693a2518-49d6-4f23-8d7c-089491e70217', 'quality@paravalves.com', 'Anjali Nair (Quality)', 'scrypt$16384$27f73b7fe94a7164b4242893a3ffa6fb$396e63ad97a37282d8569e6330ec4845df948567a6cc7a951ffaf17685f89df8e5b8e7bfd0add6da8a50810d16c0740854527b47a4615346ce0463f4c94794b1', true, false, NULL, '2026-10-27 14:05:23.369908+00', '2026-10-27 14:05:23.369908+00', 1),
	('1b0292cb-4999-40df-893a-e2e9c3dc6101', 'production@paravalves.com', 'Suresh Pillai (Production)', 'scrypt$16384$8669618a919fd81287eaa5849cc3e7e5$6b986eda9cbe262952bebd3b9fe471b590bd92df2d71e9abf2a2a6e9553a76f1991125f8f984bad2988f683206a155cf02320545e7dfc46d36f28e3f7e186888', true, false, NULL, '2026-10-27 14:05:23.450319+00', '2026-10-27 14:05:23.450319+00', 1),
	('6b544707-dfa2-4b3b-8cf6-5d69641b903c', 'manager@paravalves.com', 'Meera Krishnan (Plant Head)', 'scrypt$16384$d307113ebe4a7f1564347d2ca8425233$d2f76ffd923bbd422a1c3a600e68f0e08e4994b1b54d6eccf089915d53ae104b4e0443fa5fba1d446f716dd17914bd047e3d57988b1eb15b2fe2e71ea1d527f3', true, false, NULL, '2026-10-27 14:05:23.522445+00', '2026-10-27 14:05:23.522445+00', 1);


--
-- Data for Name: activities; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.activities VALUES
	(1, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', 'b0136396-fcf8-4945-8445-6dae8f2b11ef', 'system', 'Drawing DRW-2026-000001 created', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:23.63613+00'),
	(2, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', 'b0136396-fcf8-4945-8445-6dae8f2b11ef', 'status', 'Status DRAFT → REVIEW', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:23.649922+00'),
	(3, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', 'b0136396-fcf8-4945-8445-6dae8f2b11ef', 'status', 'Status REVIEW → INTERNAL_APPROVAL', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:23.663837+00'),
	(4, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', 'b0136396-fcf8-4945-8445-6dae8f2b11ef', 'status', 'Status INTERNAL_APPROVAL → RELEASED', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:23.673067+00'),
	(5, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', 'f63b6b4f-d129-4a20-a4b7-9b2f7c8e0dee', 'system', 'Drawing DRW-2026-000002 created', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:23.6835+00'),
	(6, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', 'f63b6b4f-d129-4a20-a4b7-9b2f7c8e0dee', 'status', 'Status DRAFT → REVIEW', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:23.693551+00'),
	(7, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', 'f63b6b4f-d129-4a20-a4b7-9b2f7c8e0dee', 'status', 'Status REVIEW → INTERNAL_APPROVAL', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:23.70317+00'),
	(8, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', 'f63b6b4f-d129-4a20-a4b7-9b2f7c8e0dee', 'status', 'Status INTERNAL_APPROVAL → RELEASED', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:23.713698+00'),
	(9, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', '10a944da-25c6-44cd-91ef-d47c6b9e6864', 'system', 'Drawing DRW-2026-000003 created', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:23.722295+00'),
	(10, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', '10a944da-25c6-44cd-91ef-d47c6b9e6864', 'status', 'Status DRAFT → REVIEW', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:23.732209+00'),
	(11, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', '10a944da-25c6-44cd-91ef-d47c6b9e6864', 'status', 'Status REVIEW → INTERNAL_APPROVAL', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:23.742366+00'),
	(12, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', '10a944da-25c6-44cd-91ef-d47c6b9e6864', 'status', 'Status INTERNAL_APPROVAL → RELEASED', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:23.751662+00'),
	(13, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', 'fec6b539-a669-4d0f-b164-b2ffdfd25166', 'system', 'Drawing DRW-2026-000004 created', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:23.761707+00'),
	(14, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', 'fec6b539-a669-4d0f-b164-b2ffdfd25166', 'status', 'Status DRAFT → REVIEW', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:23.770992+00'),
	(15, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', 'fec6b539-a669-4d0f-b164-b2ffdfd25166', 'status', 'Status REVIEW → INTERNAL_APPROVAL', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:23.781821+00'),
	(16, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', 'fec6b539-a669-4d0f-b164-b2ffdfd25166', 'status', 'Status INTERNAL_APPROVAL → RELEASED', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:23.791731+00'),
	(17, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', 'e6939dc8-15bb-4a22-a933-cd6405398fd2', 'system', 'Drawing DRW-2026-000005 created', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:23.800733+00'),
	(18, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', 'e6939dc8-15bb-4a22-a933-cd6405398fd2', 'status', 'Status DRAFT → REVIEW', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:23.810135+00'),
	(19, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', 'e6939dc8-15bb-4a22-a933-cd6405398fd2', 'status', 'Status REVIEW → INTERNAL_APPROVAL', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:23.819557+00'),
	(20, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', 'e6939dc8-15bb-4a22-a933-cd6405398fd2', 'status', 'Status INTERNAL_APPROVAL → RELEASED', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:23.830267+00'),
	(21, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', '060e77a1-8d88-4eef-a393-1de10264d450', 'system', 'Drawing DRW-2026-000006 created', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:23.83903+00'),
	(22, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', '060e77a1-8d88-4eef-a393-1de10264d450', 'status', 'Status DRAFT → REVIEW', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:23.84906+00'),
	(23, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', '060e77a1-8d88-4eef-a393-1de10264d450', 'status', 'Status REVIEW → INTERNAL_APPROVAL', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:23.859901+00'),
	(24, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', '060e77a1-8d88-4eef-a393-1de10264d450', 'status', 'Status INTERNAL_APPROVAL → RELEASED', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:23.870205+00'),
	(25, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', '639d20b4-bf47-4805-ad8e-96e6a90e1ccd', 'system', 'Drawing DRW-2026-000007 created', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:23.880091+00'),
	(26, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', '639d20b4-bf47-4805-ad8e-96e6a90e1ccd', 'status', 'Status DRAFT → REVIEW', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:23.889022+00'),
	(27, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', '639d20b4-bf47-4805-ad8e-96e6a90e1ccd', 'status', 'Status REVIEW → INTERNAL_APPROVAL', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:23.900185+00'),
	(28, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', '639d20b4-bf47-4805-ad8e-96e6a90e1ccd', 'status', 'Status INTERNAL_APPROVAL → RELEASED', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:23.911936+00'),
	(29, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', '88e3f2dd-70ac-4ce7-829d-259afacab83f', 'system', 'Drawing DRW-2026-000008 created', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:23.920872+00'),
	(30, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', '88e3f2dd-70ac-4ce7-829d-259afacab83f', 'status', 'Status DRAFT → REVIEW', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:23.931614+00'),
	(31, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', '88e3f2dd-70ac-4ce7-829d-259afacab83f', 'status', 'Status REVIEW → INTERNAL_APPROVAL', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:23.941493+00'),
	(32, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', '88e3f2dd-70ac-4ce7-829d-259afacab83f', 'status', 'Status INTERNAL_APPROVAL → RELEASED', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:23.951786+00'),
	(33, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', 'eb5b314f-9980-45ae-a923-da2778ed2170', 'system', 'Drawing DRW-2026-000009 created', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:23.961024+00'),
	(34, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', 'eb5b314f-9980-45ae-a923-da2778ed2170', 'status', 'Status DRAFT → REVIEW', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:23.970266+00'),
	(35, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '6b2a26bc-9e8b-420d-8c63-abc2f3f1a5a5', 'system', 'Lead LEAD-2026-000001 created', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.361718+00'),
	(36, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '6b2a26bc-9e8b-420d-8c63-abc2f3f1a5a5', 'status', 'Status NEW → CONTACTED', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.377802+00'),
	(37, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '6b2a26bc-9e8b-420d-8c63-abc2f3f1a5a5', 'status', 'Status CONTACTED → QUALIFIED', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.387068+00'),
	(38, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '29cd3cd5-e05d-41cd-a90e-3d10db43f833', 'system', 'Lead LEAD-2026-000002 created', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.395242+00'),
	(39, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '29cd3cd5-e05d-41cd-a90e-3d10db43f833', 'status', 'Status NEW → CONTACTED', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.4063+00'),
	(40, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '97220804-111c-432c-817f-6995ea0508ea', 'system', 'Lead LEAD-2026-000003 created', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.417416+00'),
	(41, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '97220804-111c-432c-817f-6995ea0508ea', 'status', 'Status NEW → CONTACTED', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.431354+00'),
	(42, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '97220804-111c-432c-817f-6995ea0508ea', 'status', 'Status CONTACTED → QUALIFIED', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.441988+00'),
	(43, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '97220804-111c-432c-817f-6995ea0508ea', 'status', 'Status QUALIFIED → MEETING', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.452699+00'),
	(44, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '9c0b5d27-c5df-4eeb-b77b-816a5ba8c684', 'system', 'Lead LEAD-2026-000004 created', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.46274+00'),
	(45, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '9c0b5d27-c5df-4eeb-b77b-816a5ba8c684', 'status', 'Status NEW → CONTACTED', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.478494+00'),
	(46, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '9c0b5d27-c5df-4eeb-b77b-816a5ba8c684', 'status', 'Status CONTACTED → QUALIFIED', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.494482+00'),
	(47, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '9c0b5d27-c5df-4eeb-b77b-816a5ba8c684', 'status', 'Status QUALIFIED → QUOTATION', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.507395+00'),
	(48, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '1d7082ad-817e-47d0-a6dd-f1fb0757c36d', 'system', 'Lead LEAD-2026-000005 created', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.519991+00'),
	(49, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '1d7082ad-817e-47d0-a6dd-f1fb0757c36d', 'status', 'Status NEW → LOST', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.539055+00'),
	(50, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', 'c5ce13c6-6264-4afa-b0de-ee49b5fb3e5f', 'system', 'Lead LEAD-2026-000006 created', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.55127+00');
INSERT INTO public.activities VALUES
	(51, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', 'c5ce13c6-6264-4afa-b0de-ee49b5fb3e5f', 'status', 'Status NEW → CONTACTED', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.572152+00'),
	(52, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', 'c5ce13c6-6264-4afa-b0de-ee49b5fb3e5f', 'status', 'Status CONTACTED → QUALIFIED', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.58663+00'),
	(53, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', 'f4452124-f2ce-4ec5-9e66-148677a631a4', 'system', 'Lead LEAD-2026-000007 created', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.599408+00'),
	(54, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', 'f4452124-f2ce-4ec5-9e66-148677a631a4', 'status', 'Status NEW → CONTACTED', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.613351+00'),
	(55, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', 'f4452124-f2ce-4ec5-9e66-148677a631a4', 'status', 'Status CONTACTED → QUALIFIED', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.623131+00'),
	(56, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', 'f4452124-f2ce-4ec5-9e66-148677a631a4', 'status', 'Status QUALIFIED → QUOTATION', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.63443+00'),
	(57, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '00ebac3b-8252-4275-b9a9-6f94e2184918', 'system', 'Lead LEAD-2026-000008 created', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.643095+00'),
	(58, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '00ebac3b-8252-4275-b9a9-6f94e2184918', 'status', 'Status NEW → CONTACTED', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.654722+00'),
	(59, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '00ebac3b-8252-4275-b9a9-6f94e2184918', 'status', 'Status CONTACTED → QUALIFIED', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.667182+00'),
	(60, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '00ebac3b-8252-4275-b9a9-6f94e2184918', 'status', 'Status QUALIFIED → MEETING', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.679138+00'),
	(61, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '328cf045-2a7e-4a4b-9418-8758969e6a8f', 'system', 'Lead LEAD-2026-000009 created', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.688476+00'),
	(62, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '328cf045-2a7e-4a4b-9418-8758969e6a8f', 'status', 'Status NEW → CONTACTED', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.702283+00'),
	(63, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', 'd00adf8d-ad63-431b-a1a9-5a980ce375ce', 'system', 'Lead LEAD-2026-000010 created', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.712965+00'),
	(64, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', 'd00adf8d-ad63-431b-a1a9-5a980ce375ce', 'status', 'Status NEW → CONTACTED', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.724232+00'),
	(65, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', 'd00adf8d-ad63-431b-a1a9-5a980ce375ce', 'status', 'Status CONTACTED → QUALIFIED', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.73342+00'),
	(66, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', 'bce778f5-fe67-4d47-8c15-a616dfb4060f', 'system', 'Lead LEAD-2026-000011 created', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.741915+00'),
	(67, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '6441fbd3-7866-425b-b69c-9340501592e1', 'system', 'Lead LEAD-2026-000012 created', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.750787+00'),
	(68, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '8870458f-25e2-4ed3-bdef-99e2a1ae7f60', 'system', 'Lead LEAD-2026-000013 created', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.760062+00'),
	(69, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '8870458f-25e2-4ed3-bdef-99e2a1ae7f60', 'status', 'Status NEW → CONTACTED', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.769977+00'),
	(70, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '8870458f-25e2-4ed3-bdef-99e2a1ae7f60', 'status', 'Status CONTACTED → QUALIFIED', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.779106+00'),
	(71, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '8870458f-25e2-4ed3-bdef-99e2a1ae7f60', 'status', 'Status QUALIFIED → QUOTATION', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.78777+00'),
	(72, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '8870458f-25e2-4ed3-bdef-99e2a1ae7f60', 'status', 'Status QUOTATION → NEGOTIATION', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.79714+00'),
	(73, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '355e1dd8-e5da-4ce5-9109-36fa00b8aa92', 'system', 'Lead LEAD-2026-000014 created', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.804949+00'),
	(74, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '355e1dd8-e5da-4ce5-9109-36fa00b8aa92', 'status', 'Status NEW → LOST', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.815354+00'),
	(75, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '6399bb36-6142-456b-a179-6f02916d8dcf', 'system', 'Lead LEAD-2026-000015 created', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.822573+00'),
	(76, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '6399bb36-6142-456b-a179-6f02916d8dcf', 'status', 'Status NEW → CONTACTED', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.833105+00'),
	(77, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', 'acc2a4f1-4770-4991-917e-d6e9f93ccb93', 'system', 'Quotation QUO-2026-000001 created', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.843766+00'),
	(78, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', 'acc2a4f1-4770-4991-917e-d6e9f93ccb93', 'status', 'Status DRAFT → SENT', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.856638+00'),
	(79, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', 'acc2a4f1-4770-4991-917e-d6e9f93ccb93', 'system', 'Converted to order SO-2026-000001', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:24.889812+00'),
	(80, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'order', '84f16360-acd8-4658-a08c-5095e56335a6', 'system', 'Order SO-2026-000001 created from QUO-2026-000001', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:24.889812+00'),
	(81, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', 'fc114276-1b5f-4018-9a2a-fd523fff4926', 'system', 'Quotation QUO-2026-000002 created', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.928887+00'),
	(82, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', 'fc114276-1b5f-4018-9a2a-fd523fff4926', 'status', 'Status DRAFT → SENT', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.937436+00'),
	(83, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', 'fc114276-1b5f-4018-9a2a-fd523fff4926', 'system', 'Converted to order SO-2026-000002', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:24.953594+00'),
	(84, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'order', '0bbed72f-1aff-49df-867f-4201b53b165f', 'system', 'Order SO-2026-000002 created from QUO-2026-000002', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:24.953594+00'),
	(85, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', '44dde98c-02b8-43f3-a22b-f6d914f1df1b', 'system', 'Quotation QUO-2026-000003 created', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:24.989372+00'),
	(86, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', '44dde98c-02b8-43f3-a22b-f6d914f1df1b', 'status', 'Status DRAFT → SENT', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:25.000286+00'),
	(87, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', '44dde98c-02b8-43f3-a22b-f6d914f1df1b', 'system', 'Converted to order SO-2026-000003', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:25.01735+00'),
	(88, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'order', '08c81785-76c6-4ce9-9c02-f0d075c9befc', 'system', 'Order SO-2026-000003 created from QUO-2026-000003', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:25.01735+00'),
	(89, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', '14ebed78-c91d-4508-9a0e-43af0dfad235', 'system', 'Quotation QUO-2026-000004 created', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:25.049625+00'),
	(90, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', '14ebed78-c91d-4508-9a0e-43af0dfad235', 'status', 'Status DRAFT → SENT', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:25.058961+00'),
	(91, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', '14ebed78-c91d-4508-9a0e-43af0dfad235', 'system', 'Converted to order SO-2026-000004', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:25.072563+00'),
	(92, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'order', '5150e791-ad57-45a1-9173-962ee330f78f', 'system', 'Order SO-2026-000004 created from QUO-2026-000004', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:25.072563+00'),
	(93, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', 'd8d170b5-2ae9-4b08-9031-ed036c67fb26', 'system', 'Quotation QUO-2026-000005 created', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:25.102152+00'),
	(94, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', 'd8d170b5-2ae9-4b08-9031-ed036c67fb26', 'status', 'Status DRAFT → SENT', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:25.111519+00'),
	(95, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', 'd8d170b5-2ae9-4b08-9031-ed036c67fb26', 'system', 'Converted to order SO-2026-000005', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:25.125237+00'),
	(96, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'order', 'bc2c7461-b1cd-4c66-8996-611e28098035', 'system', 'Order SO-2026-000005 created from QUO-2026-000005', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:25.125237+00'),
	(97, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', 'eabc6dfb-091b-4a26-8690-736a3a331a0f', 'system', 'Quotation QUO-2026-000006 created', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:25.153544+00'),
	(98, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', 'eabc6dfb-091b-4a26-8690-736a3a331a0f', 'status', 'Status DRAFT → SENT', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:25.163366+00'),
	(99, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', 'eabc6dfb-091b-4a26-8690-736a3a331a0f', 'system', 'Converted to order SO-2026-000006', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:25.178283+00'),
	(100, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'order', 'd7896924-f01a-474e-afe1-ef33836afd2f', 'system', 'Order SO-2026-000006 created from QUO-2026-000006', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:25.178283+00');
INSERT INTO public.activities VALUES
	(101, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', '023b8d39-f4e0-4672-9c1c-79b54478612e', 'system', 'Quotation QUO-2026-000007 created', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:25.208676+00'),
	(102, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', '023b8d39-f4e0-4672-9c1c-79b54478612e', 'status', 'Status DRAFT → SENT', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:25.218005+00'),
	(103, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', '023b8d39-f4e0-4672-9c1c-79b54478612e', 'system', 'Converted to order SO-2026-000007', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:25.232856+00'),
	(104, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'order', '498e3f4d-22ff-4b1e-a1ab-43e37332b591', 'system', 'Order SO-2026-000007 created from QUO-2026-000007', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:25.232856+00'),
	(105, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', 'e63491b4-3f5a-4319-a98b-80b04378bc0f', 'system', 'Quotation QUO-2026-000008 created', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:25.261354+00'),
	(106, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', 'e63491b4-3f5a-4319-a98b-80b04378bc0f', 'status', 'Status DRAFT → SENT', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:25.270804+00'),
	(107, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', 'e63491b4-3f5a-4319-a98b-80b04378bc0f', 'system', 'Converted to order SO-2026-000008', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:25.286585+00'),
	(108, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'order', '4e36052e-0a7c-47ae-94dd-8c74ff17ee6e', 'system', 'Order SO-2026-000008 created from QUO-2026-000008', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:25.286585+00'),
	(109, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', '7668d975-423a-4704-a27d-3fb0c3478491', 'system', 'Quotation QUO-2026-000009 created', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:25.315186+00'),
	(110, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', '7668d975-423a-4704-a27d-3fb0c3478491', 'status', 'Status DRAFT → SENT', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:25.325617+00'),
	(111, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', '7668d975-423a-4704-a27d-3fb0c3478491', 'system', 'Converted to order SO-2026-000009', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:25.340546+00'),
	(112, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'order', 'c8daa3b5-bd9e-41fe-83ca-f53a2138d16d', 'system', 'Order SO-2026-000009 created from QUO-2026-000009', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:25.340546+00'),
	(113, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', 'f983962b-2117-4356-b2f4-841a61b80e50', 'system', 'Quotation QUO-2026-000010 created', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:25.372984+00'),
	(114, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', 'f983962b-2117-4356-b2f4-841a61b80e50', 'status', 'Status DRAFT → SENT', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:25.382619+00'),
	(115, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', 'f983962b-2117-4356-b2f4-841a61b80e50', 'system', 'Converted to order SO-2026-000010', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:25.397066+00'),
	(116, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'order', '17faff62-40d5-4b82-a2bb-e6c64e3162be', 'system', 'Order SO-2026-000010 created from QUO-2026-000010', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:25.397066+00'),
	(117, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', '54b98a5d-b260-477a-9f41-9ac2378f3f54', 'system', 'Quotation QUO-2026-000011 created', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:25.425011+00'),
	(118, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', '54b98a5d-b260-477a-9f41-9ac2378f3f54', 'status', 'Status DRAFT → SENT', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:25.434301+00'),
	(119, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', '54b98a5d-b260-477a-9f41-9ac2378f3f54', 'system', 'Converted to order SO-2026-000011', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:25.448918+00'),
	(120, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'order', '23f877c9-0add-44dc-b617-5e7e48c1e841', 'system', 'Order SO-2026-000011 created from QUO-2026-000011', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:25.448918+00'),
	(121, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', 'fc153539-b57b-41dd-a1ca-c3771f81640a', 'system', 'Quotation QUO-2026-000012 created', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:25.477025+00'),
	(122, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', 'fc153539-b57b-41dd-a1ca-c3771f81640a', 'status', 'Status DRAFT → SENT', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:25.485315+00'),
	(123, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', 'fc153539-b57b-41dd-a1ca-c3771f81640a', 'system', 'Converted to order SO-2026-000012', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:25.499541+00'),
	(124, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'order', 'afc38366-3c26-4a27-a1cc-e811550d9b5c', 'system', 'Order SO-2026-000012 created from QUO-2026-000012', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:25.499541+00'),
	(125, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', 'cb8dc1b9-2f62-4e6c-8067-e22f2579145e', 'system', 'Quotation QUO-2026-000013 created', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:25.52703+00'),
	(126, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', 'cb8dc1b9-2f62-4e6c-8067-e22f2579145e', 'status', 'Status DRAFT → SENT', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:25.535353+00'),
	(127, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', '2a5d0fe2-6b3a-4833-b653-5bb1a354d68d', 'system', 'Quotation QUO-2026-000014 created', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:25.55128+00'),
	(128, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', '2a5d0fe2-6b3a-4833-b653-5bb1a354d68d', 'status', 'Status DRAFT → SENT', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:25.560227+00'),
	(129, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', '92c97736-af56-473b-89ec-1660fb2174b0', 'system', 'Quotation QUO-2026-000015 created', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:25.575529+00'),
	(130, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', '367f8d37-03ee-4da0-b20a-b953fe2306f4', 'system', 'Quotation QUO-2026-000016 created', NULL, '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', '2026-10-27 14:05:25.585371+00'),
	(131, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'po', 'ce93a67c-9fed-4963-afb5-0ba101288930', 'system', 'Purchase order PO-2026-000001 created', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:25.658705+00'),
	(132, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'po', 'ce93a67c-9fed-4963-afb5-0ba101288930', 'status', 'Status DRAFT → SENT', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:25.676845+00'),
	(133, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'po', 'ce93a67c-9fed-4963-afb5-0ba101288930', 'status', 'Status SENT → CONFIRMED', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:25.687543+00'),
	(134, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'po', 'ce93a67c-9fed-4963-afb5-0ba101288930', 'system', 'Goods received: GRN-2026-000001', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:25.705063+00'),
	(135, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'po', '71578b63-a1db-494a-adca-f340552bf4f9', 'system', 'Purchase order PO-2026-000002 created', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:25.766327+00'),
	(136, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'po', '71578b63-a1db-494a-adca-f340552bf4f9', 'status', 'Status DRAFT → SENT', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:25.781371+00'),
	(137, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'po', '71578b63-a1db-494a-adca-f340552bf4f9', 'status', 'Status SENT → CONFIRMED', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:25.793031+00'),
	(138, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'po', '71578b63-a1db-494a-adca-f340552bf4f9', 'system', 'Goods received: GRN-2026-000002', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:25.807881+00'),
	(139, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'po', '4753aa94-8b49-4c00-903e-ac1ef9478495', 'system', 'Purchase order PO-2026-000003 created', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:25.856118+00'),
	(140, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'po', '4753aa94-8b49-4c00-903e-ac1ef9478495', 'status', 'Status DRAFT → SENT', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:25.87055+00'),
	(141, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'po', '4753aa94-8b49-4c00-903e-ac1ef9478495', 'status', 'Status SENT → CONFIRMED', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:25.882985+00'),
	(142, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'po', '4753aa94-8b49-4c00-903e-ac1ef9478495', 'system', 'Goods received: GRN-2026-000003', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:25.900835+00'),
	(143, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'po', '9c2ea34b-bc2f-4e8c-a28a-29f19d040c87', 'system', 'Purchase order PO-2026-000004 created', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:25.951517+00'),
	(144, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'po', '9c2ea34b-bc2f-4e8c-a28a-29f19d040c87', 'status', 'Status DRAFT → SENT', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:25.966618+00'),
	(145, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'po', '9c2ea34b-bc2f-4e8c-a28a-29f19d040c87', 'status', 'Status SENT → CONFIRMED', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:25.978671+00'),
	(146, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'po', '9c2ea34b-bc2f-4e8c-a28a-29f19d040c87', 'system', 'Goods received: GRN-2026-000004', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:25.994935+00'),
	(147, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'po', '4507d976-1c8e-445c-912f-afb72176e7f9', 'system', 'Purchase order PO-2026-000005 created', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:26.043905+00'),
	(148, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'po', '4507d976-1c8e-445c-912f-afb72176e7f9', 'status', 'Status DRAFT → SENT', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:26.053261+00'),
	(149, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'po', '5b1af53a-3402-449f-ac83-b285bb733ab5', 'system', 'Purchase order PO-2026-000006 created', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:26.063948+00'),
	(150, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'po', '5b1af53a-3402-449f-ac83-b285bb733ab5', 'status', 'Status DRAFT → PENDING_APPROVAL', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:26.072984+00');
INSERT INTO public.activities VALUES
	(151, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'work_order', '71cb5f2d-7cf9-4623-a70b-7baeb9c1b66c', 'status', 'Work order released to shop floor', NULL, '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', '2026-10-27 14:05:26.587376+00'),
	(152, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'work_order', '6f1dd7e0-32bb-4c8a-a0d9-25e051a1a9b1', 'status', 'Work order released to shop floor', NULL, '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', '2026-10-27 14:05:26.627362+00'),
	(153, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'work_order', 'a96efb75-c93f-4af2-b48a-4962753900cd', 'status', 'Work order released to shop floor', NULL, '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', '2026-10-27 14:05:26.664373+00'),
	(154, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'work_order', 'd996f72b-9fab-4c89-878a-34c63fe6f3ea', 'status', 'Work order released to shop floor', NULL, '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', '2026-10-27 14:05:26.69727+00'),
	(155, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'work_order', 'aed5986d-07e3-4fc5-9aae-74d6c3de22ff', 'status', 'Work order released to shop floor', NULL, '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', '2026-10-27 14:05:26.729297+00'),
	(156, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'work_order', '56925ee4-f597-4196-b51e-59ca9740cc60', 'status', 'Work order released to shop floor', NULL, '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', '2026-10-27 14:05:26.757906+00'),
	(157, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'work_order', 'b4d2e412-f532-4bd4-8101-e08fd008857d', 'status', 'Work order released to shop floor', NULL, '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', '2026-10-27 14:05:26.791157+00'),
	(158, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'work_order', '17d9f431-383d-4e86-9ba9-5c2e555fd89e', 'status', 'Work order released to shop floor', NULL, '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', '2026-10-27 14:05:26.824223+00'),
	(159, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'work_order', 'e215079d-260a-4bf0-9aa5-bf2a931bc28c', 'status', 'Work order released to shop floor', NULL, '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', '2026-10-27 14:05:26.85314+00'),
	(160, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'work_order', 'ed7ae99b-3958-4efa-922f-7bf0e92beaf7', 'status', 'Work order released to shop floor', NULL, '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', '2026-10-27 14:05:26.883385+00'),
	(161, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'work_order', '7aadadef-4d0a-4ddb-9052-9fa3df733888', 'status', 'Work order released to shop floor', NULL, '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', '2026-10-27 14:05:26.91475+00'),
	(162, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'work_order', 'c87a5b27-1f37-4ba1-98cc-a7c64214737b', 'status', 'Work order released to shop floor', NULL, '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', '2026-10-27 14:05:26.94096+00'),
	(163, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'work_order', '6e4d3be3-969c-4555-9e96-ca9f6b65a201', 'status', 'Work order released to shop floor', NULL, '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', '2026-10-27 14:05:26.966795+00'),
	(164, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'serial', '4ec63d7c-4c91-4963-834e-c9837b80f2d6', 'status', 'Unit PV-2026-00001 released by quality', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', '2026-10-27 14:05:27.83035+00'),
	(165, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'serial', '59f83746-e6fc-49f4-a77b-cb821493e11f', 'status', 'Unit PV-2026-00002 released by quality', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', '2026-10-27 14:05:27.88256+00'),
	(166, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'serial', '4cb646d1-3878-4424-b41c-fdcf1caceca0', 'status', 'Unit PV-2026-00003 released by quality', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', '2026-10-27 14:05:27.935548+00'),
	(167, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'serial', '400708e9-52e1-4214-b07c-c7837dbeeb2c', 'status', 'Unit PV-2026-00004 released by quality', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', '2026-10-27 14:05:27.991128+00'),
	(168, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'serial', 'f287ea25-7179-4e4d-a695-4bb1414938da', 'status', 'Unit PV-2026-00005 released by quality', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', '2026-10-27 14:05:28.040789+00'),
	(169, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'serial', 'e612e4b3-497c-470c-8396-74a36728f675', 'status', 'Unit PV-2026-00008 released by quality', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', '2026-10-27 14:05:28.089233+00'),
	(170, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'serial', '326a1502-8dcd-4de5-acf8-f5b56b4ec57c', 'status', 'Unit PV-2026-00009 released by quality', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', '2026-10-27 14:05:28.137957+00'),
	(171, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'serial', 'c8b7b4fb-6148-494b-990d-b2b14b6350b3', 'status', 'Unit PV-2026-00014 released by quality', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', '2026-10-27 14:05:28.188109+00'),
	(172, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'serial', '451711cb-bdb5-46aa-a135-e7bb6ce9a477', 'status', 'Unit PV-2026-00015 released by quality', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', '2026-10-27 14:05:28.241875+00'),
	(173, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'serial', '1f31d15f-0bf3-45b3-991b-db09ef7af236', 'status', 'Unit PV-2026-00018 released by quality', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', '2026-10-27 14:05:28.303184+00'),
	(174, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'serial', '92d9db2b-a78c-4256-bbf9-24dfafbec521', 'status', 'Unit PV-2026-00019 released by quality', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', '2026-10-27 14:05:28.367684+00'),
	(175, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'serial', 'b23230f2-f025-43ed-82dc-75a1c78a3ea1', 'status', 'Unit PV-2026-00020 released by quality', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', '2026-10-27 14:05:28.428867+00'),
	(176, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'serial', '6140c882-132d-428a-9759-c01123be0297', 'status', 'Unit PV-2026-00021 released by quality', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', '2026-10-27 14:05:28.486223+00'),
	(177, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'serial', '25dd99d8-20bf-48f8-bece-c7e4f0bf1514', 'status', 'Unit PV-2026-00010 released by quality', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', '2026-10-27 14:05:28.568526+00'),
	(178, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'serial', 'afdd35b7-be62-4847-a82c-64b8ddf1b75f', 'status', 'Unit PV-2026-00017 released by quality', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', '2026-10-27 14:05:28.663419+00'),
	(179, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'order', '84f16360-acd8-4658-a08c-5095e56335a6', 'system', 'Shipment SHP-2026-000001 dispatched', NULL, '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', '2026-10-27 14:05:28.697137+00'),
	(180, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'order', '0bbed72f-1aff-49df-867f-4201b53b165f', 'system', 'Shipment SHP-2026-000002 dispatched', NULL, '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', '2026-10-27 14:05:28.733323+00'),
	(181, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'order', 'bc2c7461-b1cd-4c66-8996-611e28098035', 'system', 'Shipment SHP-2026-000003 dispatched', NULL, '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', '2026-10-27 14:05:28.765626+00'),
	(182, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'order', '84f16360-acd8-4658-a08c-5095e56335a6', 'status', 'Status CONFIRMED → ENGINEERING', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:28.920514+00'),
	(183, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'order', '84f16360-acd8-4658-a08c-5095e56335a6', 'status', 'Status ENGINEERING → MATERIAL_CHECK', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:28.931983+00'),
	(184, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'order', '84f16360-acd8-4658-a08c-5095e56335a6', 'status', 'Status MATERIAL_CHECK → PROCUREMENT', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:28.94159+00'),
	(185, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'order', '84f16360-acd8-4658-a08c-5095e56335a6', 'status', 'Status PROCUREMENT → READY', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:28.952358+00'),
	(186, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'order', '84f16360-acd8-4658-a08c-5095e56335a6', 'system', 'Invoice INV-2026-000001 generated', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:28.975+00'),
	(187, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'invoice', 'b5b3c1d7-f38b-4cf8-a6fa-83982def8785', 'system', 'Invoice INV-2026-000001 created (7700)', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:28.975+00'),
	(188, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'invoice', 'b5b3c1d7-f38b-4cf8-a6fa-83982def8785', 'status', 'Status DRAFT → ISSUED', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:28.997868+00'),
	(189, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'invoice', 'b5b3c1d7-f38b-4cf8-a6fa-83982def8785', 'system', 'Payment PAY-2026-000001 recorded: 3850', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:29.019448+00'),
	(190, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'order', 'bc2c7461-b1cd-4c66-8996-611e28098035', 'status', 'Status CONFIRMED → ENGINEERING', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:29.036034+00'),
	(191, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'order', 'bc2c7461-b1cd-4c66-8996-611e28098035', 'status', 'Status ENGINEERING → MATERIAL_CHECK', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:29.048653+00'),
	(192, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'order', 'bc2c7461-b1cd-4c66-8996-611e28098035', 'status', 'Status MATERIAL_CHECK → PROCUREMENT', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:29.05917+00'),
	(193, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'order', 'bc2c7461-b1cd-4c66-8996-611e28098035', 'system', 'Invoice INV-2026-000002 generated', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:29.084999+00'),
	(194, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'invoice', 'af319e29-79f3-42e0-8a7b-0f905462b0f1', 'system', 'Invoice INV-2026-000002 created (5664)', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:29.084999+00'),
	(195, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'invoice', 'af319e29-79f3-42e0-8a7b-0f905462b0f1', 'status', 'Status DRAFT → ISSUED', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:29.104438+00'),
	(196, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'invoice', 'af319e29-79f3-42e0-8a7b-0f905462b0f1', 'system', 'Payment PAY-2026-000002 recorded: 5664', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:29.118455+00'),
	(197, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'order', '0bbed72f-1aff-49df-867f-4201b53b165f', 'system', 'Invoice INV-2026-000003 generated', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:29.129413+00'),
	(198, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'invoice', 'a526920e-7321-4968-b2ca-ffa2b379e6d9', 'system', 'Invoice INV-2026-000003 created (27013)', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:29.129413+00'),
	(199, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'invoice', 'a526920e-7321-4968-b2ca-ffa2b379e6d9', 'status', 'Status DRAFT → ISSUED', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:29.145986+00'),
	(200, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'invoice', 'a526920e-7321-4968-b2ca-ffa2b379e6d9', 'status', 'Status ISSUED → OVERDUE', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', '2026-10-27 14:05:29.161616+00');


--
-- Data for Name: approval_requests; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.approval_requests VALUES
	('8f5cbdf2-6bb4-4fb4-8d5f-cf8697771b1f', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'NCR_DISPOSITION', 'ncr', 'ee7687e3-e02c-465d-a813-ac84ce80c248', 'NCR-2026-000001 → SCRAP', NULL, 'Hardness out of spec — scrap, claim from supplier', 'APPROVED', '693a2518-49d6-4f23-8d7c-089491e70217', '6b544707-dfa2-4b3b-8cf6-5d69641b903c', 'Agreed — scrap and raise supplier debit note', '2026-10-27 14:05:26.354556+00', '2026-10-27 14:05:26.364328+00'),
	('bbb5e5eb-153b-4e22-8bad-c52f6fb05761', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'NCR_DISPOSITION', 'ncr', '5b8a78a2-c076-4e63-8c39-83211b4861f0', 'NCR-2026-000002 → RETURN_TO_SUPPLIER', NULL, 'Return batch to supplier for re-heat-treatment', 'PENDING', '693a2518-49d6-4f23-8d7c-089491e70217', NULL, NULL, '2026-10-27 14:05:26.373758+00', NULL),
	('91f505e8-bc9a-4dfa-97a0-8c65dd7e9e7c', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'NCR_DISPOSITION', 'ncr', 'afe88422-33b9-4c6d-8e5c-0b25caf7bf98', 'NCR-2026-000003 → RETEST', NULL, 'Seat re-lapped; retest after cleaning seat face', 'APPROVED', '693a2518-49d6-4f23-8d7c-089491e70217', '6b544707-dfa2-4b3b-8cf6-5d69641b903c', 'Approved — retest under witness', '2026-10-27 14:05:28.520536+00', '2026-10-27 14:05:28.529462+00'),
	('88909d09-7100-4521-9fe4-f29d014dc57b', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'ECN', 'ecn', '12bb7771-9b7d-4616-8e3c-a828f72ea06b', 'ECN-2026-000002 Increase bonnet bolt torque spec', NULL, 'Rework WIP & stock to new revision — effective from serial 20', 'PENDING', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', NULL, NULL, '2026-10-27 14:05:29.208051+00', NULL),
	('50904c9b-cb3d-4374-acfb-23603d626dcc', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'ECN', 'ecn', '32f47fe3-2898-4403-8d0c-2bcf34ad2aed', 'ECN-2026-000003 Add spring retainer groove', NULL, 'Use existing stock until exhausted, then change — effective from next batch', 'APPROVED', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '6b544707-dfa2-4b3b-8cf6-5d69641b903c', 'Approved', '2026-10-27 14:05:29.233418+00', '2026-10-27 14:05:29.241649+00'),
	('3e27e65e-f4db-45fe-b46d-ca208d27cbbf', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'QUOTE_DISCOUNT', 'manual', NULL, 'Quote for Bharat Oilfield — 12% discount', 85000.00, 'Competitive tender', 'PENDING', '0258e002-4154-48b4-ad1d-2195882841be', NULL, NULL, '2026-10-27 14:05:29.256238+00', NULL),
	('ed318763-1d6f-4590-a2d7-3194132e0482', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PO_VALUE', 'manual', NULL, 'PO — Eastern Alloys SS316 bar stock', 708000.00, 'Above ₹5 lakh — needs senior approval', 'PENDING', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', NULL, NULL, '2026-10-27 14:05:29.262547+00', NULL),
	('36a03111-1809-4b03-973f-7274cb37a4dd', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'CREDIT_OVERRIDE', 'manual', NULL, 'Release order for Sahara Fertilizers on credit hold', 300000.00, 'Customer promised payment on Friday', 'PENDING', '0258e002-4154-48b4-ad1d-2195882841be', NULL, NULL, '2026-10-27 14:05:29.268359+00', NULL);


--
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.audit_logs VALUES
	(1, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'product.create', 'product', '82048a24-aa7e-422f-bee0-1642d75bd996', NULL, '{"code": "PV-BV-025", "name": "Ball Valve 25mm SS316"}', NULL, NULL, '2026-10-27 14:05:23.560744+00'),
	(2, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'product.create', 'product', '6f56aa1e-de31-44a5-b842-756c12aa7646', NULL, '{"code": "PV-BV-100", "name": "Ball Valve 100mm CF8M"}', NULL, NULL, '2026-10-27 14:05:23.569957+00'),
	(3, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'product.create', 'product', 'd61fe768-7f6e-4d65-b1f1-6f5621e2008b', NULL, '{"code": "PV-GV-050", "name": "Gate Valve 50mm WCB"}', NULL, NULL, '2026-10-27 14:05:23.577814+00'),
	(4, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'product.create', 'product', '9152c8e7-6ed4-495d-a58c-ee509367659f', NULL, '{"code": "PV-GV-150", "name": "Gate Valve 150mm CF8M"}', NULL, NULL, '2026-10-27 14:05:23.58415+00'),
	(5, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'product.create', 'product', '92a93794-1287-4b7d-8868-7b9b81b87cb2', NULL, '{"code": "PV-CV-050", "name": "Check Valve 50mm SS316"}', NULL, NULL, '2026-10-27 14:05:23.590884+00'),
	(6, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'product.create', 'product', '77a428fe-4dd9-4a6e-8138-36a5f4efc6b2', NULL, '{"code": "PV-GLV-050", "name": "Globe Valve 50mm SS316"}', NULL, NULL, '2026-10-27 14:05:23.597607+00'),
	(7, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'product.create', 'product', '65e1cab5-04f9-4e45-9081-e07e65803ba9', NULL, '{"code": "PV-BFV-200", "name": "Butterfly Valve 200mm"}', NULL, NULL, '2026-10-27 14:05:23.603605+00'),
	(8, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'product.create', 'product', 'd14a8056-467a-425a-a517-b0f08e05e8ec', NULL, '{"code": "PV-BODY-01", "name": "Valve body casting CF8M"}', NULL, NULL, '2026-10-27 14:05:23.610141+00'),
	(9, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'product.create', 'product', '2488bae2-79d6-4ce2-95c8-385344da703b', NULL, '{"code": "PV-BONNET-01", "name": "Bonnet forging CF8M"}', NULL, NULL, '2026-10-27 14:05:23.616331+00'),
	(10, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'product.create', 'product', '086765c3-bd85-4e70-85fe-183ad180df42', NULL, '{"code": "PV-BAR-316", "name": "SS316 bar stock Ø40"}', NULL, NULL, '2026-10-27 14:05:23.622516+00'),
	(11, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'product.create', 'product', '8922a168-0213-41f6-b58a-7dab5331adda', NULL, '{"code": "PV-GASKET-01", "name": "Graphite gasket set"}', NULL, NULL, '2026-10-27 14:05:23.629695+00'),
	(12, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'drawing.create', 'drawing', 'b0136396-fcf8-4945-8445-6dae8f2b11ef', NULL, '{"drawingNumber": "DRW-2026-000001"}', NULL, NULL, '2026-10-27 14:05:23.63613+00'),
	(13, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'drawing.transition', 'drawing', 'b0136396-fcf8-4945-8445-6dae8f2b11ef', '{"status": "DRAFT"}', '{"status": "REVIEW"}', NULL, NULL, '2026-10-27 14:05:23.649922+00'),
	(14, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'drawing.transition', 'drawing', 'b0136396-fcf8-4945-8445-6dae8f2b11ef', '{"status": "REVIEW"}', '{"status": "INTERNAL_APPROVAL"}', NULL, NULL, '2026-10-27 14:05:23.663837+00'),
	(15, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'drawing.transition', 'drawing', 'b0136396-fcf8-4945-8445-6dae8f2b11ef', '{"status": "INTERNAL_APPROVAL"}', '{"status": "RELEASED"}', NULL, NULL, '2026-10-27 14:05:23.673067+00'),
	(16, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'drawing.create', 'drawing', 'f63b6b4f-d129-4a20-a4b7-9b2f7c8e0dee', NULL, '{"drawingNumber": "DRW-2026-000002"}', NULL, NULL, '2026-10-27 14:05:23.6835+00'),
	(17, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'drawing.transition', 'drawing', 'f63b6b4f-d129-4a20-a4b7-9b2f7c8e0dee', '{"status": "DRAFT"}', '{"status": "REVIEW"}', NULL, NULL, '2026-10-27 14:05:23.693551+00'),
	(18, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'drawing.transition', 'drawing', 'f63b6b4f-d129-4a20-a4b7-9b2f7c8e0dee', '{"status": "REVIEW"}', '{"status": "INTERNAL_APPROVAL"}', NULL, NULL, '2026-10-27 14:05:23.70317+00'),
	(19, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'drawing.transition', 'drawing', 'f63b6b4f-d129-4a20-a4b7-9b2f7c8e0dee', '{"status": "INTERNAL_APPROVAL"}', '{"status": "RELEASED"}', NULL, NULL, '2026-10-27 14:05:23.713698+00'),
	(20, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'drawing.create', 'drawing', '10a944da-25c6-44cd-91ef-d47c6b9e6864', NULL, '{"drawingNumber": "DRW-2026-000003"}', NULL, NULL, '2026-10-27 14:05:23.722295+00'),
	(21, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'drawing.transition', 'drawing', '10a944da-25c6-44cd-91ef-d47c6b9e6864', '{"status": "DRAFT"}', '{"status": "REVIEW"}', NULL, NULL, '2026-10-27 14:05:23.732209+00'),
	(22, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'drawing.transition', 'drawing', '10a944da-25c6-44cd-91ef-d47c6b9e6864', '{"status": "REVIEW"}', '{"status": "INTERNAL_APPROVAL"}', NULL, NULL, '2026-10-27 14:05:23.742366+00'),
	(23, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'drawing.transition', 'drawing', '10a944da-25c6-44cd-91ef-d47c6b9e6864', '{"status": "INTERNAL_APPROVAL"}', '{"status": "RELEASED"}', NULL, NULL, '2026-10-27 14:05:23.751662+00'),
	(24, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'drawing.create', 'drawing', 'fec6b539-a669-4d0f-b164-b2ffdfd25166', NULL, '{"drawingNumber": "DRW-2026-000004"}', NULL, NULL, '2026-10-27 14:05:23.761707+00'),
	(25, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'drawing.transition', 'drawing', 'fec6b539-a669-4d0f-b164-b2ffdfd25166', '{"status": "DRAFT"}', '{"status": "REVIEW"}', NULL, NULL, '2026-10-27 14:05:23.770992+00'),
	(26, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'drawing.transition', 'drawing', 'fec6b539-a669-4d0f-b164-b2ffdfd25166', '{"status": "REVIEW"}', '{"status": "INTERNAL_APPROVAL"}', NULL, NULL, '2026-10-27 14:05:23.781821+00'),
	(27, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'drawing.transition', 'drawing', 'fec6b539-a669-4d0f-b164-b2ffdfd25166', '{"status": "INTERNAL_APPROVAL"}', '{"status": "RELEASED"}', NULL, NULL, '2026-10-27 14:05:23.791731+00'),
	(28, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'drawing.create', 'drawing', 'e6939dc8-15bb-4a22-a933-cd6405398fd2', NULL, '{"drawingNumber": "DRW-2026-000005"}', NULL, NULL, '2026-10-27 14:05:23.800733+00'),
	(29, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'drawing.transition', 'drawing', 'e6939dc8-15bb-4a22-a933-cd6405398fd2', '{"status": "DRAFT"}', '{"status": "REVIEW"}', NULL, NULL, '2026-10-27 14:05:23.810135+00'),
	(30, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'drawing.transition', 'drawing', 'e6939dc8-15bb-4a22-a933-cd6405398fd2', '{"status": "REVIEW"}', '{"status": "INTERNAL_APPROVAL"}', NULL, NULL, '2026-10-27 14:05:23.819557+00'),
	(31, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'drawing.transition', 'drawing', 'e6939dc8-15bb-4a22-a933-cd6405398fd2', '{"status": "INTERNAL_APPROVAL"}', '{"status": "RELEASED"}', NULL, NULL, '2026-10-27 14:05:23.830267+00'),
	(32, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'drawing.create', 'drawing', '060e77a1-8d88-4eef-a393-1de10264d450', NULL, '{"drawingNumber": "DRW-2026-000006"}', NULL, NULL, '2026-10-27 14:05:23.83903+00'),
	(33, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'drawing.transition', 'drawing', '060e77a1-8d88-4eef-a393-1de10264d450', '{"status": "DRAFT"}', '{"status": "REVIEW"}', NULL, NULL, '2026-10-27 14:05:23.84906+00'),
	(34, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'drawing.transition', 'drawing', '060e77a1-8d88-4eef-a393-1de10264d450', '{"status": "REVIEW"}', '{"status": "INTERNAL_APPROVAL"}', NULL, NULL, '2026-10-27 14:05:23.859901+00'),
	(35, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'drawing.transition', 'drawing', '060e77a1-8d88-4eef-a393-1de10264d450', '{"status": "INTERNAL_APPROVAL"}', '{"status": "RELEASED"}', NULL, NULL, '2026-10-27 14:05:23.870205+00'),
	(36, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'drawing.create', 'drawing', '639d20b4-bf47-4805-ad8e-96e6a90e1ccd', NULL, '{"drawingNumber": "DRW-2026-000007"}', NULL, NULL, '2026-10-27 14:05:23.880091+00'),
	(37, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'drawing.transition', 'drawing', '639d20b4-bf47-4805-ad8e-96e6a90e1ccd', '{"status": "DRAFT"}', '{"status": "REVIEW"}', NULL, NULL, '2026-10-27 14:05:23.889022+00'),
	(38, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'drawing.transition', 'drawing', '639d20b4-bf47-4805-ad8e-96e6a90e1ccd', '{"status": "REVIEW"}', '{"status": "INTERNAL_APPROVAL"}', NULL, NULL, '2026-10-27 14:05:23.900185+00'),
	(39, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'drawing.transition', 'drawing', '639d20b4-bf47-4805-ad8e-96e6a90e1ccd', '{"status": "INTERNAL_APPROVAL"}', '{"status": "RELEASED"}', NULL, NULL, '2026-10-27 14:05:23.911936+00'),
	(40, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'drawing.create', 'drawing', '88e3f2dd-70ac-4ce7-829d-259afacab83f', NULL, '{"drawingNumber": "DRW-2026-000008"}', NULL, NULL, '2026-10-27 14:05:23.920872+00'),
	(41, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'drawing.transition', 'drawing', '88e3f2dd-70ac-4ce7-829d-259afacab83f', '{"status": "DRAFT"}', '{"status": "REVIEW"}', NULL, NULL, '2026-10-27 14:05:23.931614+00'),
	(42, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'drawing.transition', 'drawing', '88e3f2dd-70ac-4ce7-829d-259afacab83f', '{"status": "REVIEW"}', '{"status": "INTERNAL_APPROVAL"}', NULL, NULL, '2026-10-27 14:05:23.941493+00'),
	(43, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'drawing.transition', 'drawing', '88e3f2dd-70ac-4ce7-829d-259afacab83f', '{"status": "INTERNAL_APPROVAL"}', '{"status": "RELEASED"}', NULL, NULL, '2026-10-27 14:05:23.951786+00'),
	(44, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'drawing.create', 'drawing', 'eb5b314f-9980-45ae-a923-da2778ed2170', NULL, '{"drawingNumber": "DRW-2026-000009"}', NULL, NULL, '2026-10-27 14:05:23.961024+00'),
	(45, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'drawing.transition', 'drawing', 'eb5b314f-9980-45ae-a923-da2778ed2170', '{"status": "DRAFT"}', '{"status": "REVIEW"}', NULL, NULL, '2026-10-27 14:05:23.970266+00'),
	(46, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.create', 'lead', '6b2a26bc-9e8b-420d-8c63-abc2f3f1a5a5', NULL, '{"email": "anita@deccanpetroc.com", "phone": "+91 910000000", "source": "WEBSITE", "priority": "HIGH", "quantity": 30, "company_name": "Deccan Petrochem Ltd", "contact_name": "Anita Rao", "expected_close": "2026-11-10", "expected_value": 177000, "product_requirement": "Gate valves 80mm"}', NULL, NULL, '2026-10-27 14:05:24.361718+00'),
	(47, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.transition', 'lead', '6b2a26bc-9e8b-420d-8c63-abc2f3f1a5a5', '{"status": "NEW"}', '{"status": "CONTACTED"}', NULL, NULL, '2026-10-27 14:05:24.377802+00'),
	(48, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.transition', 'lead', '6b2a26bc-9e8b-420d-8c63-abc2f3f1a5a5', '{"status": "CONTACTED"}', '{"status": "QUALIFIED"}', NULL, NULL, '2026-10-27 14:05:24.387068+00'),
	(49, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.create', 'lead', '29cd3cd5-e05d-41cd-a90e-3d10db43f833', NULL, '{"email": "vikram@coastalpower.com", "phone": "+91 911111111", "source": "REFERRAL", "priority": "NORMAL", "quantity": 50, "company_name": "Coastal Power Ltd", "contact_name": "Vikram Shah", "expected_close": "2026-11-13", "expected_value": 105000, "product_requirement": "Ball valves assorted"}', NULL, NULL, '2026-10-27 14:05:24.395242+00'),
	(50, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.transition', 'lead', '29cd3cd5-e05d-41cd-a90e-3d10db43f833', '{"status": "NEW"}', '{"status": "CONTACTED"}', NULL, NULL, '2026-10-27 14:05:24.4063+00');
INSERT INTO public.audit_logs VALUES
	(51, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.create', 'lead', '97220804-111c-432c-817f-6995ea0508ea', NULL, '{"email": "farah@nagpursteelw.com", "phone": "+91 912222222", "source": "PHONE", "priority": "NORMAL", "quantity": 12, "company_name": "Nagpur Steel Works", "contact_name": "Farah Khan", "expected_close": "2026-11-16", "expected_value": 68000, "product_requirement": "Knife gate valves"}', NULL, NULL, '2026-10-27 14:05:24.417416+00'),
	(52, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.transition', 'lead', '97220804-111c-432c-817f-6995ea0508ea', '{"status": "NEW"}', '{"status": "CONTACTED"}', NULL, NULL, '2026-10-27 14:05:24.431354+00'),
	(53, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.transition', 'lead', '97220804-111c-432c-817f-6995ea0508ea', '{"status": "CONTACTED"}', '{"status": "QUALIFIED"}', NULL, NULL, '2026-10-27 14:05:24.441988+00'),
	(54, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.transition', 'lead', '97220804-111c-432c-817f-6995ea0508ea', '{"status": "QUALIFIED"}', '{"status": "MEETING"}', NULL, NULL, '2026-10-27 14:05:24.452699+00'),
	(55, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.create', 'lead', '9c0b5d27-c5df-4eeb-b77b-816a5ba8c684', NULL, '{"email": "carlos@iberiawaters.com", "phone": "+91 913333333", "source": "WEBSITE", "priority": "HIGH", "quantity": 8, "company_name": "Iberia Water S.L.", "contact_name": "Carlos Ruiz", "expected_close": "2026-11-19", "expected_value": 240000, "product_requirement": "Butterfly valves for water plant"}', NULL, NULL, '2026-10-27 14:05:24.46274+00'),
	(56, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.transition', 'lead', '9c0b5d27-c5df-4eeb-b77b-816a5ba8c684', '{"status": "NEW"}', '{"status": "CONTACTED"}', NULL, NULL, '2026-10-27 14:05:24.478494+00'),
	(57, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.transition', 'lead', '9c0b5d27-c5df-4eeb-b77b-816a5ba8c684', '{"status": "CONTACTED"}', '{"status": "QUALIFIED"}', NULL, NULL, '2026-10-27 14:05:24.494482+00'),
	(58, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.transition', 'lead', '9c0b5d27-c5df-4eeb-b77b-816a5ba8c684', '{"status": "QUALIFIED"}', '{"status": "QUOTATION"}', NULL, NULL, '2026-10-27 14:05:24.507395+00'),
	(59, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.create', 'lead', '1d7082ad-817e-47d0-a6dd-f1fb0757c36d', NULL, '{"email": "ramesh@metroutiliti.com", "phone": "+91 914444444", "source": "MANUAL", "priority": "LOW", "quantity": 5, "company_name": "Metro Utilities", "contact_name": "Ramesh Iyer", "expected_close": "2026-11-22", "expected_value": 42000, "product_requirement": "Dampers"}', NULL, NULL, '2026-10-27 14:05:24.519991+00'),
	(60, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.transition', 'lead', '1d7082ad-817e-47d0-a6dd-f1fb0757c36d', '{"status": "NEW"}', '{"status": "LOST"}', NULL, NULL, '2026-10-27 14:05:24.539055+00'),
	(61, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.create', 'lead', 'c5ce13c6-6264-4afa-b0de-ee49b5fb3e5f', NULL, '{"email": "lakshmi@kaveriwaterb.com", "phone": "+91 915555555", "source": "WEBSITE", "priority": "NORMAL", "quantity": 40, "company_name": "Kaveri Water Board", "contact_name": "Lakshmi Gowda", "expected_close": "2026-11-25", "expected_value": 96000, "product_requirement": "Check valves 50mm"}', NULL, NULL, '2026-10-27 14:05:24.55127+00'),
	(62, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.transition', 'lead', 'c5ce13c6-6264-4afa-b0de-ee49b5fb3e5f', '{"status": "NEW"}', '{"status": "CONTACTED"}', NULL, NULL, '2026-10-27 14:05:24.572152+00'),
	(63, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.transition', 'lead', 'c5ce13c6-6264-4afa-b0de-ee49b5fb3e5f', '{"status": "CONTACTED"}', '{"status": "QUALIFIED"}', NULL, NULL, '2026-10-27 14:05:24.58663+00'),
	(64, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.create', 'lead', 'f4452124-f2ce-4ec5-9e66-148677a631a4', NULL, '{"email": "jonas@hamburgproce.com", "phone": "+91 916666666", "source": "WEBSITE", "priority": "HIGH", "quantity": 20, "company_name": "Hamburg Process GmbH", "contact_name": "Jonas Weber", "expected_close": "2026-11-28", "expected_value": 136000, "product_requirement": "Ball valves CF8M 100mm"}', NULL, NULL, '2026-10-27 14:05:24.599408+00'),
	(65, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.transition', 'lead', 'f4452124-f2ce-4ec5-9e66-148677a631a4', '{"status": "NEW"}', '{"status": "CONTACTED"}', NULL, NULL, '2026-10-27 14:05:24.613351+00'),
	(66, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.transition', 'lead', 'f4452124-f2ce-4ec5-9e66-148677a631a4', '{"status": "CONTACTED"}', '{"status": "QUALIFIED"}', NULL, NULL, '2026-10-27 14:05:24.623131+00'),
	(67, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.transition', 'lead', 'f4452124-f2ce-4ec5-9e66-148677a631a4', '{"status": "QUALIFIED"}', '{"status": "QUOTATION"}', NULL, NULL, '2026-10-27 14:05:24.63443+00'),
	(68, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.create', 'lead', '00ebac3b-8252-4275-b9a9-6f94e2184918', NULL, '{"email": "neha@tataprocesss.com", "phone": "+91 917777777", "source": "REFERRAL", "priority": "NORMAL", "quantity": 25, "company_name": "Tata Process Systems", "contact_name": "Neha Joshi", "expected_close": "2026-12-01", "expected_value": 85000, "product_requirement": "Globe valves"}', NULL, NULL, '2026-10-27 14:05:24.643095+00'),
	(69, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.transition', 'lead', '00ebac3b-8252-4275-b9a9-6f94e2184918', '{"status": "NEW"}', '{"status": "CONTACTED"}', NULL, NULL, '2026-10-27 14:05:24.654722+00'),
	(70, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.transition', 'lead', '00ebac3b-8252-4275-b9a9-6f94e2184918', '{"status": "CONTACTED"}', '{"status": "QUALIFIED"}', NULL, NULL, '2026-10-27 14:05:24.667182+00'),
	(71, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.transition', 'lead', '00ebac3b-8252-4275-b9a9-6f94e2184918', '{"status": "QUALIFIED"}', '{"status": "MEETING"}', NULL, NULL, '2026-10-27 14:05:24.679138+00'),
	(72, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.create', 'lead', '328cf045-2a7e-4a4b-9418-8758969e6a8f', NULL, '{"email": "capt@reliancemari.com", "phone": "+91 918888888", "source": "TRADE_SHOW", "priority": "HIGH", "quantity": 60, "company_name": "Reliance Marine Services", "contact_name": "Capt. Dsouza", "expected_close": "2026-12-04", "expected_value": 290000, "product_requirement": "Marine ball valves"}', NULL, NULL, '2026-10-27 14:05:24.688476+00'),
	(73, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.transition', 'lead', '328cf045-2a7e-4a4b-9418-8758969e6a8f', '{"status": "NEW"}', '{"status": "CONTACTED"}', NULL, NULL, '2026-10-27 14:05:24.702283+00'),
	(74, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.create', 'lead', 'd00adf8d-ad63-431b-a1a9-5a980ce375ce', NULL, '{"email": "gurpreet@bharatoilfie.com", "phone": "+91 919999999", "source": "PHONE", "priority": "HIGH", "quantity": 16, "company_name": "Bharat Oilfield Services", "contact_name": "Gurpreet Singh", "expected_close": "2026-12-07", "expected_value": 206000, "product_requirement": "High-pressure gate valves"}', NULL, NULL, '2026-10-27 14:05:24.712965+00'),
	(75, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.transition', 'lead', 'd00adf8d-ad63-431b-a1a9-5a980ce375ce', '{"status": "NEW"}', '{"status": "CONTACTED"}', NULL, NULL, '2026-10-27 14:05:24.724232+00'),
	(76, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.transition', 'lead', 'd00adf8d-ad63-431b-a1a9-5a980ce375ce', '{"status": "CONTACTED"}', '{"status": "QUALIFIED"}', NULL, NULL, '2026-10-27 14:05:24.73342+00'),
	(77, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.create', 'lead', 'bce778f5-fe67-4d47-8c15-a616dfb4060f', NULL, '{"email": "dr@sunrisepharm.com", "phone": "+91 921111110", "source": "WEBSITE", "priority": "NORMAL", "quantity": 30, "company_name": "Sunrise Pharma", "contact_name": "Dr. Mehta", "expected_close": "2026-12-10", "expected_value": 120000, "product_requirement": "Sanitary ball valves"}', NULL, NULL, '2026-10-27 14:05:24.741915+00'),
	(78, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.create', 'lead', '6441fbd3-7866-425b-b69c-9340501592e1', NULL, '{"email": "amit@easternferti.com", "phone": "+91 922222221", "source": "REFERRAL", "priority": "NORMAL", "quantity": 10, "company_name": "Eastern Fertilizers", "contact_name": "Amit Das", "expected_close": "2026-12-13", "expected_value": 82000, "product_requirement": "Butterfly valves 200mm"}', NULL, NULL, '2026-10-27 14:05:24.750787+00'),
	(79, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.create', 'lead', '8870458f-25e2-4ed3-bdef-99e2a1ae7f60', NULL, '{"email": "omar@gulfrefining.com", "phone": "+91 923333332", "source": "WEBSITE", "priority": "HIGH", "quantity": 14, "company_name": "Gulf Refining Co.", "contact_name": "Omar Al Farsi", "expected_close": "2026-12-16", "expected_value": 180000, "product_requirement": "Gate valves 150mm"}', NULL, NULL, '2026-10-27 14:05:24.760062+00'),
	(80, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.transition', 'lead', '8870458f-25e2-4ed3-bdef-99e2a1ae7f60', '{"status": "NEW"}', '{"status": "CONTACTED"}', NULL, NULL, '2026-10-27 14:05:24.769977+00'),
	(81, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.transition', 'lead', '8870458f-25e2-4ed3-bdef-99e2a1ae7f60', '{"status": "CONTACTED"}', '{"status": "QUALIFIED"}', NULL, NULL, '2026-10-27 14:05:24.779106+00'),
	(82, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.transition', 'lead', '8870458f-25e2-4ed3-bdef-99e2a1ae7f60', '{"status": "QUALIFIED"}', '{"status": "QUOTATION"}', NULL, NULL, '2026-10-27 14:05:24.78777+00'),
	(83, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.transition', 'lead', '8870458f-25e2-4ed3-bdef-99e2a1ae7f60', '{"status": "QUOTATION"}', '{"status": "NEGOTIATION"}', NULL, NULL, '2026-10-27 14:05:24.79714+00'),
	(84, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.create', 'lead', '355e1dd8-e5da-4ce5-9109-36fa00b8aa92', NULL, '{"email": "sachin@puneautocomp.com", "phone": "+91 924444443", "source": "MANUAL", "priority": "LOW", "quantity": 20, "company_name": "Pune Auto Components", "contact_name": "Sachin Patil", "expected_close": "2026-12-19", "expected_value": 48000, "product_requirement": "Check valves"}', NULL, NULL, '2026-10-27 14:05:24.804949+00'),
	(85, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.transition', 'lead', '355e1dd8-e5da-4ce5-9109-36fa00b8aa92', '{"status": "NEW"}', '{"status": "LOST"}', NULL, NULL, '2026-10-27 14:05:24.815354+00'),
	(86, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.create', 'lead', '6399bb36-6142-456b-a179-6f02916d8dcf', NULL, '{"email": "rekha@hindustanche.com", "phone": "+91 925555554", "source": "WEBSITE", "priority": "NORMAL", "quantity": 80, "company_name": "Hindustan Chemicals", "contact_name": "Rekha Menon", "expected_close": "2026-12-22", "expected_value": 116000, "product_requirement": "Ball valves 25mm"}', NULL, NULL, '2026-10-27 14:05:24.822573+00'),
	(87, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'lead.transition', 'lead', '6399bb36-6142-456b-a179-6f02916d8dcf', '{"status": "NEW"}', '{"status": "CONTACTED"}', NULL, NULL, '2026-10-27 14:05:24.833105+00'),
	(88, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'quote.create', 'quote', 'acc2a4f1-4770-4991-917e-d6e9f93ccb93', NULL, '{"total": 7699.5, "quoteNumber": "QUO-2026-000001"}', NULL, NULL, '2026-10-27 14:05:24.843766+00'),
	(89, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'quote.transition', 'quote', 'acc2a4f1-4770-4991-917e-d6e9f93ccb93', '{"status": "DRAFT"}', '{"status": "SENT"}', NULL, NULL, '2026-10-27 14:05:24.856638+00'),
	(90, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'order.create_from_quote', 'order', '84f16360-acd8-4658-a08c-5095e56335a6', NULL, '{"quoteId": "acc2a4f1-4770-4991-917e-d6e9f93ccb93", "orderNumber": "SO-2026-000001"}', NULL, NULL, '2026-10-27 14:05:24.889812+00'),
	(91, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'quote.create', 'quote', 'fc114276-1b5f-4018-9a2a-fd523fff4926', NULL, '{"total": 27012.56, "quoteNumber": "QUO-2026-000002"}', NULL, NULL, '2026-10-27 14:05:24.928887+00'),
	(92, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'quote.transition', 'quote', 'fc114276-1b5f-4018-9a2a-fd523fff4926', '{"status": "DRAFT"}', '{"status": "SENT"}', NULL, NULL, '2026-10-27 14:05:24.937436+00'),
	(93, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'order.create_from_quote', 'order', '0bbed72f-1aff-49df-867f-4201b53b165f', NULL, '{"quoteId": "fc114276-1b5f-4018-9a2a-fd523fff4926", "orderNumber": "SO-2026-000002"}', NULL, NULL, '2026-10-27 14:05:24.953594+00'),
	(94, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'quote.create', 'quote', '44dde98c-02b8-43f3-a22b-f6d914f1df1b', NULL, '{"total": 5133, "quoteNumber": "QUO-2026-000003"}', NULL, NULL, '2026-10-27 14:05:24.989372+00'),
	(95, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'quote.transition', 'quote', '44dde98c-02b8-43f3-a22b-f6d914f1df1b', '{"status": "DRAFT"}', '{"status": "SENT"}', NULL, NULL, '2026-10-27 14:05:25.000286+00'),
	(96, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'order.create_from_quote', 'order', '08c81785-76c6-4ce9-9c02-f0d075c9befc', NULL, '{"quoteId": "44dde98c-02b8-43f3-a22b-f6d914f1df1b", "orderNumber": "SO-2026-000003"}', NULL, NULL, '2026-10-27 14:05:25.01735+00'),
	(97, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'quote.create', 'quote', '14ebed78-c91d-4508-9a0e-43af0dfad235', NULL, '{"total": 12036, "quoteNumber": "QUO-2026-000004"}', NULL, NULL, '2026-10-27 14:05:25.049625+00'),
	(98, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'quote.transition', 'quote', '14ebed78-c91d-4508-9a0e-43af0dfad235', '{"status": "DRAFT"}', '{"status": "SENT"}', NULL, NULL, '2026-10-27 14:05:25.058961+00'),
	(99, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'order.create_from_quote', 'order', '5150e791-ad57-45a1-9173-962ee330f78f', NULL, '{"quoteId": "14ebed78-c91d-4508-9a0e-43af0dfad235", "orderNumber": "SO-2026-000004"}', NULL, NULL, '2026-10-27 14:05:25.072563+00'),
	(100, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'quote.create', 'quote', 'd8d170b5-2ae9-4b08-9031-ed036c67fb26', NULL, '{"total": 5664, "quoteNumber": "QUO-2026-000005"}', NULL, NULL, '2026-10-27 14:05:25.102152+00');
INSERT INTO public.audit_logs VALUES
	(101, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'quote.transition', 'quote', 'd8d170b5-2ae9-4b08-9031-ed036c67fb26', '{"status": "DRAFT"}', '{"status": "SENT"}', NULL, NULL, '2026-10-27 14:05:25.111519+00'),
	(102, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'order.create_from_quote', 'order', 'bc2c7461-b1cd-4c66-8996-611e28098035', NULL, '{"quoteId": "d8d170b5-2ae9-4b08-9031-ed036c67fb26", "orderNumber": "SO-2026-000005"}', NULL, NULL, '2026-10-27 14:05:25.125237+00'),
	(103, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'quote.create', 'quote', 'eabc6dfb-091b-4a26-8690-736a3a331a0f', NULL, '{"total": 16048, "quoteNumber": "QUO-2026-000006"}', NULL, NULL, '2026-10-27 14:05:25.153544+00'),
	(104, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'quote.transition', 'quote', 'eabc6dfb-091b-4a26-8690-736a3a331a0f', '{"status": "DRAFT"}', '{"status": "SENT"}', NULL, NULL, '2026-10-27 14:05:25.163366+00'),
	(105, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'order.create_from_quote', 'order', 'd7896924-f01a-474e-afe1-ef33836afd2f', NULL, '{"quoteId": "eabc6dfb-091b-4a26-8690-736a3a331a0f", "orderNumber": "SO-2026-000006"}', NULL, NULL, '2026-10-27 14:05:25.178283+00'),
	(106, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'quote.create', 'quote', '023b8d39-f4e0-4672-9c1c-79b54478612e', NULL, '{"total": 58452.48, "quoteNumber": "QUO-2026-000007"}', NULL, NULL, '2026-10-27 14:05:25.208676+00'),
	(107, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'quote.transition', 'quote', '023b8d39-f4e0-4672-9c1c-79b54478612e', '{"status": "DRAFT"}', '{"status": "SENT"}', NULL, NULL, '2026-10-27 14:05:25.218005+00'),
	(108, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'order.create_from_quote', 'order', '498e3f4d-22ff-4b1e-a1ab-43e37332b591', NULL, '{"quoteId": "023b8d39-f4e0-4672-9c1c-79b54478612e", "orderNumber": "SO-2026-000007"}', NULL, NULL, '2026-10-27 14:05:25.232856+00'),
	(109, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'quote.create', 'quote', 'e63491b4-3f5a-4319-a98b-80b04378bc0f', NULL, '{"total": 7316, "quoteNumber": "QUO-2026-000008"}', NULL, NULL, '2026-10-27 14:05:25.261354+00'),
	(110, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'quote.transition', 'quote', 'e63491b4-3f5a-4319-a98b-80b04378bc0f', '{"status": "DRAFT"}', '{"status": "SENT"}', NULL, NULL, '2026-10-27 14:05:25.270804+00'),
	(111, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'order.create_from_quote', 'order', '4e36052e-0a7c-47ae-94dd-8c74ff17ee6e', NULL, '{"quoteId": "e63491b4-3f5a-4319-a98b-80b04378bc0f", "orderNumber": "SO-2026-000008"}', NULL, NULL, '2026-10-27 14:05:25.286585+00'),
	(112, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'quote.create', 'quote', '7668d975-423a-4704-a27d-3fb0c3478491', NULL, '{"total": 19352, "quoteNumber": "QUO-2026-000009"}', NULL, NULL, '2026-10-27 14:05:25.315186+00'),
	(113, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'quote.transition', 'quote', '7668d975-423a-4704-a27d-3fb0c3478491', '{"status": "DRAFT"}', '{"status": "SENT"}', NULL, NULL, '2026-10-27 14:05:25.325617+00'),
	(114, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'order.create_from_quote', 'order', 'c8daa3b5-bd9e-41fe-83ca-f53a2138d16d', NULL, '{"quoteId": "7668d975-423a-4704-a27d-3fb0c3478491", "orderNumber": "SO-2026-000009"}', NULL, NULL, '2026-10-27 14:05:25.340546+00'),
	(115, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'quote.create', 'quote', 'f983962b-2117-4356-b2f4-841a61b80e50', NULL, '{"total": 47181.12, "quoteNumber": "QUO-2026-000010"}', NULL, NULL, '2026-10-27 14:05:25.372984+00'),
	(116, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'quote.transition', 'quote', 'f983962b-2117-4356-b2f4-841a61b80e50', '{"status": "DRAFT"}', '{"status": "SENT"}', NULL, NULL, '2026-10-27 14:05:25.382619+00'),
	(117, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'order.create_from_quote', 'order', '17faff62-40d5-4b82-a2bb-e6c64e3162be', NULL, '{"quoteId": "f983962b-2117-4356-b2f4-841a61b80e50", "orderNumber": "SO-2026-000010"}', NULL, NULL, '2026-10-27 14:05:25.397066+00'),
	(118, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'quote.create', 'quote', '54b98a5d-b260-477a-9f41-9ac2378f3f54', NULL, '{"total": 38704, "quoteNumber": "QUO-2026-000011"}', NULL, NULL, '2026-10-27 14:05:25.425011+00'),
	(119, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'quote.transition', 'quote', '54b98a5d-b260-477a-9f41-9ac2378f3f54', '{"status": "DRAFT"}', '{"status": "SENT"}', NULL, NULL, '2026-10-27 14:05:25.434301+00'),
	(120, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'order.create_from_quote', 'order', '23f877c9-0add-44dc-b617-5e7e48c1e841', NULL, '{"quoteId": "54b98a5d-b260-477a-9f41-9ac2378f3f54", "orderNumber": "SO-2026-000011"}', NULL, NULL, '2026-10-27 14:05:25.448918+00'),
	(121, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'quote.create', 'quote', 'fc153539-b57b-41dd-a1ca-c3771f81640a', NULL, '{"total": 16254.5, "quoteNumber": "QUO-2026-000012"}', NULL, NULL, '2026-10-27 14:05:25.477025+00'),
	(122, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'quote.transition', 'quote', 'fc153539-b57b-41dd-a1ca-c3771f81640a', '{"status": "DRAFT"}', '{"status": "SENT"}', NULL, NULL, '2026-10-27 14:05:25.485315+00'),
	(123, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'order.create_from_quote', 'order', 'afc38366-3c26-4a27-a1cc-e811550d9b5c', NULL, '{"quoteId": "fc153539-b57b-41dd-a1ca-c3771f81640a", "orderNumber": "SO-2026-000012"}', NULL, NULL, '2026-10-27 14:05:25.499541+00'),
	(124, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'quote.create', 'quote', 'cb8dc1b9-2f62-4e6c-8067-e22f2579145e', NULL, '{"total": 24072, "quoteNumber": "QUO-2026-000013"}', NULL, NULL, '2026-10-27 14:05:25.52703+00'),
	(125, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'quote.transition', 'quote', 'cb8dc1b9-2f62-4e6c-8067-e22f2579145e', '{"status": "DRAFT"}', '{"status": "SENT"}', NULL, NULL, '2026-10-27 14:05:25.535353+00'),
	(126, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'quote.create', 'quote', '2a5d0fe2-6b3a-4833-b653-5bb1a354d68d', NULL, '{"total": 52354.24, "quoteNumber": "QUO-2026-000014"}', NULL, NULL, '2026-10-27 14:05:25.55128+00'),
	(127, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'quote.transition', 'quote', '2a5d0fe2-6b3a-4833-b653-5bb1a354d68d', '{"status": "DRAFT"}', '{"status": "SENT"}', NULL, NULL, '2026-10-27 14:05:25.560227+00'),
	(128, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'quote.create', 'quote', '92c97736-af56-473b-89ec-1660fb2174b0', NULL, '{"total": 33984, "quoteNumber": "QUO-2026-000015"}', NULL, NULL, '2026-10-27 14:05:25.575529+00'),
	(129, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'quote.create', 'quote', '367f8d37-03ee-4da0-b20a-b953fe2306f4', NULL, '{"total": 36910.4, "quoteNumber": "QUO-2026-000016"}', NULL, NULL, '2026-10-27 14:05:25.585371+00'),
	(130, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'po.create', 'po', 'ce93a67c-9fed-4963-afb5-0ba101288930', NULL, '{"poNumber": "PO-2026-000001"}', NULL, NULL, '2026-10-27 14:05:25.658705+00'),
	(131, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'po.transition', 'po', 'ce93a67c-9fed-4963-afb5-0ba101288930', '{"status": "DRAFT"}', '{"status": "SENT"}', NULL, NULL, '2026-10-27 14:05:25.676845+00'),
	(132, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'po.transition', 'po', 'ce93a67c-9fed-4963-afb5-0ba101288930', '{"status": "SENT"}', '{"status": "CONFIRMED"}', NULL, NULL, '2026-10-27 14:05:25.687543+00'),
	(133, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'grn.create', 'grn', 'e1d2578b-4bf7-4a4c-8fab-6e13f71549eb', NULL, '{"poId": "ce93a67c-9fed-4963-afb5-0ba101288930", "grnNumber": "GRN-2026-000001"}', NULL, NULL, '2026-10-27 14:05:25.705063+00'),
	(134, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'po.create', 'po', '71578b63-a1db-494a-adca-f340552bf4f9', NULL, '{"poNumber": "PO-2026-000002"}', NULL, NULL, '2026-10-27 14:05:25.766327+00'),
	(135, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'po.transition', 'po', '71578b63-a1db-494a-adca-f340552bf4f9', '{"status": "DRAFT"}', '{"status": "SENT"}', NULL, NULL, '2026-10-27 14:05:25.781371+00'),
	(136, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'po.transition', 'po', '71578b63-a1db-494a-adca-f340552bf4f9', '{"status": "SENT"}', '{"status": "CONFIRMED"}', NULL, NULL, '2026-10-27 14:05:25.793031+00'),
	(137, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'grn.create', 'grn', '39849164-7e5a-4cf4-a7c0-51985752ccf4', NULL, '{"poId": "71578b63-a1db-494a-adca-f340552bf4f9", "grnNumber": "GRN-2026-000002"}', NULL, NULL, '2026-10-27 14:05:25.807881+00'),
	(138, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'po.create', 'po', '4753aa94-8b49-4c00-903e-ac1ef9478495', NULL, '{"poNumber": "PO-2026-000003"}', NULL, NULL, '2026-10-27 14:05:25.856118+00'),
	(139, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'po.transition', 'po', '4753aa94-8b49-4c00-903e-ac1ef9478495', '{"status": "DRAFT"}', '{"status": "SENT"}', NULL, NULL, '2026-10-27 14:05:25.87055+00'),
	(140, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'po.transition', 'po', '4753aa94-8b49-4c00-903e-ac1ef9478495', '{"status": "SENT"}', '{"status": "CONFIRMED"}', NULL, NULL, '2026-10-27 14:05:25.882985+00'),
	(141, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'grn.create', 'grn', '2d427e21-6868-4293-848c-907d2ecb3544', NULL, '{"poId": "4753aa94-8b49-4c00-903e-ac1ef9478495", "grnNumber": "GRN-2026-000003"}', NULL, NULL, '2026-10-27 14:05:25.900835+00'),
	(142, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'po.create', 'po', '9c2ea34b-bc2f-4e8c-a28a-29f19d040c87', NULL, '{"poNumber": "PO-2026-000004"}', NULL, NULL, '2026-10-27 14:05:25.951517+00'),
	(143, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'po.transition', 'po', '9c2ea34b-bc2f-4e8c-a28a-29f19d040c87', '{"status": "DRAFT"}', '{"status": "SENT"}', NULL, NULL, '2026-10-27 14:05:25.966618+00'),
	(144, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'po.transition', 'po', '9c2ea34b-bc2f-4e8c-a28a-29f19d040c87', '{"status": "SENT"}', '{"status": "CONFIRMED"}', NULL, NULL, '2026-10-27 14:05:25.978671+00'),
	(145, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'grn.create', 'grn', '25c5720f-01ba-401d-be7c-1cd37e709753', NULL, '{"poId": "9c2ea34b-bc2f-4e8c-a28a-29f19d040c87", "grnNumber": "GRN-2026-000004"}', NULL, NULL, '2026-10-27 14:05:25.994935+00'),
	(146, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'po.create', 'po', '4507d976-1c8e-445c-912f-afb72176e7f9', NULL, '{"poNumber": "PO-2026-000005"}', NULL, NULL, '2026-10-27 14:05:26.043905+00'),
	(147, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'po.transition', 'po', '4507d976-1c8e-445c-912f-afb72176e7f9', '{"status": "DRAFT"}', '{"status": "SENT"}', NULL, NULL, '2026-10-27 14:05:26.053261+00'),
	(148, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'po.create', 'po', '5b1af53a-3402-449f-ac83-b285bb733ab5', NULL, '{"poNumber": "PO-2026-000006"}', NULL, NULL, '2026-10-27 14:05:26.063948+00'),
	(149, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'po.transition', 'po', '5b1af53a-3402-449f-ac83-b285bb733ab5', '{"status": "DRAFT"}', '{"status": "PENDING_APPROVAL"}', NULL, NULL, '2026-10-27 14:05:26.072984+00'),
	(150, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'inspection.decide', 'inspection', '371e7943-87ad-4a85-a761-87525f644eba', NULL, '{"passed": true}', NULL, NULL, '2026-10-27 14:05:26.088838+00');
INSERT INTO public.audit_logs VALUES
	(151, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'inspection.decide', 'inspection', '13f53eca-f5ad-4db2-9251-9e7e3fa4b06d', NULL, '{"passed": true}', NULL, NULL, '2026-10-27 14:05:26.10432+00'),
	(152, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'inspection.decide', 'inspection', 'de063587-91b8-4bea-8a83-f3f2899d3a90', NULL, '{"passed": true}', NULL, NULL, '2026-10-27 14:05:26.119069+00'),
	(153, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'inspection.decide', 'inspection', 'a812e3b3-8bf5-4c57-a570-0a30aa5675a4', NULL, '{"passed": true}', NULL, NULL, '2026-10-27 14:05:26.133667+00'),
	(154, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'ncr.raise', 'ncr', 'ee7687e3-e02c-465d-a813-ac84ce80c248', NULL, '{"id": "aa3bd83d-a31c-43bb-90c2-c211ab496716", "no": "NCR-2026-000001", "type": "INSPECTION", "label": "Lot BD-H26138", "description": "INCOMING inspection INS-2026-000005 failed: Hardness / PMI (if specified)"}', NULL, NULL, '2026-10-27 14:05:26.147745+00'),
	(155, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'inspection.decide', 'inspection', 'aa3bd83d-a31c-43bb-90c2-c211ab496716', NULL, '{"passed": false}', NULL, NULL, '2026-10-27 14:05:26.147745+00'),
	(156, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'inspection.decide', 'inspection', 'e1ae9670-29cb-4d72-bb21-537a5cb4a08b', NULL, '{"passed": true}', NULL, NULL, '2026-10-27 14:05:26.165725+00'),
	(157, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'inspection.decide', 'inspection', '33f5fbf5-9beb-4c07-904e-83e0270bab61', NULL, '{"passed": true}', NULL, NULL, '2026-10-27 14:05:26.179766+00'),
	(158, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'inspection.decide', 'inspection', 'b172f7dd-029d-4a13-ab5f-05271b7576b7', NULL, '{"passed": true}', NULL, NULL, '2026-10-27 14:05:26.193464+00'),
	(159, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'inspection.decide', 'inspection', '9dba1ff8-78e4-4459-8b32-b5dd2e846708', NULL, '{"passed": true}', NULL, NULL, '2026-10-27 14:05:26.207407+00'),
	(160, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'ncr.raise', 'ncr', '5b8a78a2-c076-4e63-8c39-83211b4861f0', NULL, '{"id": "d939dc57-b405-45d5-9bdc-bf74386b6c8c", "no": "NCR-2026-000002", "type": "INSPECTION", "label": "Lot ST-H26138", "description": "INCOMING inspection INS-2026-000010 failed: Hardness / PMI (if specified)"}', NULL, NULL, '2026-10-27 14:05:26.221683+00'),
	(161, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'inspection.decide', 'inspection', 'd939dc57-b405-45d5-9bdc-bf74386b6c8c', NULL, '{"passed": false}', NULL, NULL, '2026-10-27 14:05:26.221683+00'),
	(162, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'inspection.decide', 'inspection', 'acaa6c68-0c99-452d-9855-f6a2c22fdc7d', NULL, '{"passed": true}', NULL, NULL, '2026-10-27 14:05:26.238764+00'),
	(163, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'inspection.decide', 'inspection', 'cc2abdb7-f73a-498c-a2c1-16c104e88fbd', NULL, '{"passed": true}', NULL, NULL, '2026-10-27 14:05:26.252785+00'),
	(164, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'inspection.decide', 'inspection', 'b5d580a3-4ac1-47ee-a3c9-ca72bb26b1bb', NULL, '{"passed": true}', NULL, NULL, '2026-10-27 14:05:26.26656+00'),
	(165, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'inspection.decide', 'inspection', 'dd268999-dadf-43c1-be8d-44c48a91e21d', NULL, '{"passed": true}', NULL, NULL, '2026-10-27 14:05:26.28125+00'),
	(166, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'inspection.decide', 'inspection', '6479704a-fd29-42b1-a21a-fa96cd91ffae', NULL, '{"passed": true}', NULL, NULL, '2026-10-27 14:05:26.301756+00'),
	(167, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'inspection.decide', 'inspection', '527f04a0-bc24-4c81-97e6-7f269f43ef76', NULL, '{"passed": true}', NULL, NULL, '2026-10-27 14:05:26.315594+00'),
	(168, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'inspection.decide', 'inspection', 'fe23b206-586c-4514-95af-cc157a907c49', NULL, '{"passed": true}', NULL, NULL, '2026-10-27 14:05:26.330327+00'),
	(169, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'inspection.decide', 'inspection', '09bb7629-0b0b-4266-810f-88b2bff1b610', NULL, '{"passed": true}', NULL, NULL, '2026-10-27 14:05:26.344229+00'),
	(170, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'ncr.propose', 'ncr', 'ee7687e3-e02c-465d-a813-ac84ce80c248', NULL, '{"disposition": "SCRAP"}', NULL, NULL, '2026-10-27 14:05:26.354556+00'),
	(171, '4a0f88e6-467f-406c-a37b-fde4abff9898', '6b544707-dfa2-4b3b-8cf6-5d69641b903c', 'Meera Krishnan (Plant Head)', 'approval.approve', 'approval', '8f5cbdf2-6bb4-4fb4-8d5f-cf8697771b1f', NULL, NULL, '{"note": "Agreed — scrap and raise supplier debit note"}', NULL, '2026-10-27 14:05:26.364328+00'),
	(172, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'ncr.propose', 'ncr', '5b8a78a2-c076-4e63-8c39-83211b4861f0', NULL, '{"disposition": "RETURN_TO_SUPPLIER"}', NULL, NULL, '2026-10-27 14:05:26.373758+00'),
	(173, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'order.acknowledge', 'order', '84f16360-acd8-4658-a08c-5095e56335a6', NULL, NULL, NULL, NULL, '2026-10-27 14:05:26.381356+00'),
	(174, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'order.acknowledge', 'order', '0bbed72f-1aff-49df-867f-4201b53b165f', NULL, NULL, NULL, NULL, '2026-10-27 14:05:26.389914+00'),
	(175, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'order.review', 'order', '08c81785-76c6-4ce9-9c02-f0d075c9befc', NULL, NULL, NULL, NULL, '2026-10-27 14:05:26.398162+00'),
	(176, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'order.review', 'order', '5150e791-ad57-45a1-9173-962ee330f78f', NULL, NULL, NULL, NULL, '2026-10-27 14:05:26.404273+00'),
	(177, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'wo.create', 'work_order', '71cb5f2d-7cf9-4623-a70b-7baeb9c1b66c', NULL, '{"no": "WO-2026-000001"}', NULL, NULL, '2026-10-27 14:05:26.411385+00'),
	(178, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'wo.create', 'work_order', '6f1dd7e0-32bb-4c8a-a0d9-25e051a1a9b1', NULL, '{"no": "WO-2026-000002"}', NULL, NULL, '2026-10-27 14:05:26.425776+00'),
	(179, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'wo.create', 'work_order', 'a96efb75-c93f-4af2-b48a-4962753900cd', NULL, '{"no": "WO-2026-000003"}', NULL, NULL, '2026-10-27 14:05:26.436712+00'),
	(180, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'wo.create', 'work_order', 'd996f72b-9fab-4c89-878a-34c63fe6f3ea', NULL, '{"no": "WO-2026-000004"}', NULL, NULL, '2026-10-27 14:05:26.44851+00'),
	(181, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'wo.create', 'work_order', 'aed5986d-07e3-4fc5-9aae-74d6c3de22ff', NULL, '{"no": "WO-2026-000005"}', NULL, NULL, '2026-10-27 14:05:26.459497+00'),
	(182, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'wo.create', 'work_order', '56925ee4-f597-4196-b51e-59ca9740cc60', NULL, '{"no": "WO-2026-000006"}', NULL, NULL, '2026-10-27 14:05:26.470566+00'),
	(183, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'wo.create', 'work_order', '8ebcb809-6629-4f68-add0-926ef84e4337', NULL, '{"no": "WO-2026-000007"}', NULL, NULL, '2026-10-27 14:05:26.482911+00'),
	(184, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'wo.create', 'work_order', 'b4d2e412-f532-4bd4-8101-e08fd008857d', NULL, '{"no": "WO-2026-000008"}', NULL, NULL, '2026-10-27 14:05:26.494267+00'),
	(185, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'wo.create', 'work_order', '076f8a96-8f7a-4b69-a2db-b257e115f802', NULL, '{"no": "WO-2026-000009"}', NULL, NULL, '2026-10-27 14:05:26.505056+00'),
	(186, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'wo.create', 'work_order', '17d9f431-383d-4e86-9ba9-5c2e555fd89e', NULL, '{"no": "WO-2026-000010"}', NULL, NULL, '2026-10-27 14:05:26.517136+00'),
	(187, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'wo.create', 'work_order', 'e215079d-260a-4bf0-9aa5-bf2a931bc28c', NULL, '{"no": "WO-2026-000011"}', NULL, NULL, '2026-10-27 14:05:26.529404+00'),
	(188, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'wo.create', 'work_order', 'ed7ae99b-3958-4efa-922f-7bf0e92beaf7', NULL, '{"no": "WO-2026-000012"}', NULL, NULL, '2026-10-27 14:05:26.5407+00'),
	(189, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'wo.create', 'work_order', '7aadadef-4d0a-4ddb-9052-9fa3df733888', NULL, '{"no": "WO-2026-000013"}', NULL, NULL, '2026-10-27 14:05:26.55233+00'),
	(190, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'wo.create', 'work_order', 'c87a5b27-1f37-4ba1-98cc-a7c64214737b', NULL, '{"no": "WO-2026-000014"}', NULL, NULL, '2026-10-27 14:05:26.564895+00'),
	(191, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'wo.create', 'work_order', '6e4d3be3-969c-4555-9e96-ca9f6b65a201', NULL, '{"no": "WO-2026-000015"}', NULL, NULL, '2026-10-27 14:05:26.576346+00'),
	(192, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'subcontract.update', 'subcontract', '67fe8e31-5628-4f20-a0fc-b1885b2434a1', NULL, '{"status": "RECONCILED", "returned": 3, "scrapped": 0, "processed": 3}', NULL, NULL, '2026-10-27 14:05:27.317863+00'),
	(193, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'subcontract.update', 'subcontract', '928bcc07-9351-4024-8527-17b852b05b83', NULL, '{"status": "RECONCILED", "returned": 4, "scrapped": 0, "processed": 4}', NULL, NULL, '2026-10-27 14:05:27.338065+00'),
	(194, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'subcontract.update', 'subcontract', '5c8276ce-93e7-4872-a094-e1d04a02dc09', NULL, '{"status": "RECONCILED", "returned": 2, "scrapped": 1, "processed": 2}', NULL, NULL, '2026-10-27 14:05:27.354316+00'),
	(195, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'subcontract.update', 'subcontract', 'afb1546c-d580-4537-b6d5-eda3606f40e1', NULL, '{"status": "RECONCILED", "returned": 3, "scrapped": 0, "processed": 3}', NULL, NULL, '2026-10-27 14:05:27.369989+00'),
	(196, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'subcontract.update', 'subcontract', '473a7904-d69f-4a5f-8567-35026e1621cd', NULL, '{"status": "RECONCILED", "returned": 2, "scrapped": 0, "processed": 2}', NULL, NULL, '2026-10-27 14:05:27.386036+00'),
	(197, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'subcontract.update', 'subcontract', 'bd842578-e6d3-42f0-8827-bba74d1a62c2', NULL, '{"status": "RECONCILED", "returned": 2, "scrapped": 0, "processed": 2}', NULL, NULL, '2026-10-27 14:05:27.403324+00'),
	(198, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'subcontract.update', 'subcontract', '23df83cd-8aa9-413e-9976-f733c6c5ff31', NULL, '{"status": "RECONCILED", "returned": 2, "scrapped": 0, "processed": 2}', NULL, NULL, '2026-10-27 14:05:27.419416+00'),
	(199, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'subcontract.update', 'subcontract', '0b892b0e-aea9-4c02-8197-4e4f9132c365', NULL, '{"status": "RECONCILED", "returned": 2, "scrapped": 0, "processed": 2}', NULL, NULL, '2026-10-27 14:05:27.434262+00'),
	(200, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'subcontract.update', 'subcontract', '8ae950a0-81b7-400a-adba-50cb2039bb66', NULL, '{"status": "MISMATCH", "returned": 4, "scrapped": 0, "processed": 5}', NULL, NULL, '2026-10-27 14:05:27.455591+00');
INSERT INTO public.audit_logs VALUES
	(201, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'serial.create', 'serial', '4ec63d7c-4c91-4963-834e-c9837b80f2d6', NULL, '{"serial": "PV-2026-00001"}', NULL, NULL, '2026-10-27 14:05:27.465974+00'),
	(202, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'serial.create', 'serial', '59f83746-e6fc-49f4-a77b-cb821493e11f', NULL, '{"serial": "PV-2026-00002"}', NULL, NULL, '2026-10-27 14:05:27.48586+00'),
	(203, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'serial.create', 'serial', '4cb646d1-3878-4424-b41c-fdcf1caceca0', NULL, '{"serial": "PV-2026-00003"}', NULL, NULL, '2026-10-27 14:05:27.500975+00'),
	(204, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'serial.create', 'serial', '400708e9-52e1-4214-b07c-c7837dbeeb2c', NULL, '{"serial": "PV-2026-00004"}', NULL, NULL, '2026-10-27 14:05:27.515924+00'),
	(205, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'serial.create', 'serial', 'f287ea25-7179-4e4d-a695-4bb1414938da', NULL, '{"serial": "PV-2026-00005"}', NULL, NULL, '2026-10-27 14:05:27.532344+00'),
	(206, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'serial.create', 'serial', 'e026d7e0-1793-48a6-8e1d-55052368ee86', NULL, '{"serial": "PV-2026-00006"}', NULL, NULL, '2026-10-27 14:05:27.546297+00'),
	(207, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'serial.create', 'serial', '1e0f70f6-1106-4b94-bbf5-f54796d3349d', NULL, '{"serial": "PV-2026-00007"}', NULL, NULL, '2026-10-27 14:05:27.559672+00'),
	(208, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'serial.create', 'serial', 'e612e4b3-497c-470c-8396-74a36728f675', NULL, '{"serial": "PV-2026-00008"}', NULL, NULL, '2026-10-27 14:05:27.572718+00'),
	(209, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'serial.create', 'serial', '326a1502-8dcd-4de5-acf8-f5b56b4ec57c', NULL, '{"serial": "PV-2026-00009"}', NULL, NULL, '2026-10-27 14:05:27.58727+00'),
	(210, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'serial.create', 'serial', '25dd99d8-20bf-48f8-bece-c7e4f0bf1514', NULL, '{"serial": "PV-2026-00010"}', NULL, NULL, '2026-10-27 14:05:27.601432+00'),
	(211, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'serial.create', 'serial', '889f17af-4522-46de-a212-c9fc160fe4c5', NULL, '{"serial": "PV-2026-00011"}', NULL, NULL, '2026-10-27 14:05:27.615477+00'),
	(212, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'serial.create', 'serial', 'e7390bf4-8562-4115-ba09-42cec5480e45', NULL, '{"serial": "PV-2026-00012"}', NULL, NULL, '2026-10-27 14:05:27.630934+00'),
	(213, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'serial.create', 'serial', '38b43ff4-03c6-4021-a195-4b8973395fdc', NULL, '{"serial": "PV-2026-00013"}', NULL, NULL, '2026-10-27 14:05:27.645378+00'),
	(214, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'serial.create', 'serial', 'c8b7b4fb-6148-494b-990d-b2b14b6350b3', NULL, '{"serial": "PV-2026-00014"}', NULL, NULL, '2026-10-27 14:05:27.659945+00'),
	(215, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'serial.create', 'serial', '451711cb-bdb5-46aa-a135-e7bb6ce9a477', NULL, '{"serial": "PV-2026-00015"}', NULL, NULL, '2026-10-27 14:05:27.674511+00'),
	(216, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'serial.create', 'serial', 'a54cf213-c4dd-4f12-a524-d401753e81b5', NULL, '{"serial": "PV-2026-00016"}', NULL, NULL, '2026-10-27 14:05:27.688292+00'),
	(217, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'serial.create', 'serial', 'afdd35b7-be62-4847-a82c-64b8ddf1b75f', NULL, '{"serial": "PV-2026-00017"}', NULL, NULL, '2026-10-27 14:05:27.705546+00'),
	(218, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'serial.create', 'serial', '1f31d15f-0bf3-45b3-991b-db09ef7af236', NULL, '{"serial": "PV-2026-00018"}', NULL, NULL, '2026-10-27 14:05:27.722353+00'),
	(219, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'serial.create', 'serial', '92d9db2b-a78c-4256-bbf9-24dfafbec521', NULL, '{"serial": "PV-2026-00019"}', NULL, NULL, '2026-10-27 14:05:27.739742+00'),
	(220, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'serial.create', 'serial', 'b23230f2-f025-43ed-82dc-75a1c78a3ea1', NULL, '{"serial": "PV-2026-00020"}', NULL, NULL, '2026-10-27 14:05:27.754994+00'),
	(221, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'serial.create', 'serial', '6140c882-132d-428a-9759-c01123be0297', NULL, '{"serial": "PV-2026-00021"}', NULL, NULL, '2026-10-27 14:05:27.772201+00'),
	(222, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'inspection.decide', 'inspection', '120268c7-2eca-47a0-b098-c37db0487d6a', NULL, '{"passed": true}', NULL, NULL, '2026-10-27 14:05:27.795461+00'),
	(223, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', '653233f8-cb9e-4e75-8062-ecf672dc3b8e', NULL, '{"no": "TST-2026-000001", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:27.802951+00'),
	(224, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', 'e6ccb44b-bcab-4199-bb44-392f23b16f39', NULL, '{"no": "TST-2026-000002", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:27.813308+00'),
	(225, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', '27ffdfd4-919a-4c49-aadf-da7211ba1413', NULL, '{"no": "TST-2026-000003", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:27.820407+00'),
	(226, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'unit.release', 'serial', '4ec63d7c-4c91-4963-834e-c9837b80f2d6', NULL, NULL, NULL, NULL, '2026-10-27 14:05:27.83035+00'),
	(227, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'inspection.decide', 'inspection', 'e4673cdf-e967-4311-8623-5407b2b7f4e5', NULL, '{"passed": true}', NULL, NULL, '2026-10-27 14:05:27.848695+00'),
	(228, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', '74a764f7-676a-4ad8-b923-e754c94ec26b', NULL, '{"no": "TST-2026-000004", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:27.855337+00'),
	(229, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', '5dea3393-4643-4f1c-a6d0-757f4b2c2b7b', NULL, '{"no": "TST-2026-000005", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:27.866497+00'),
	(230, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', 'c0a7adf8-4930-4a27-84c2-1218d899279d', NULL, '{"no": "TST-2026-000006", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:27.874693+00'),
	(231, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'unit.release', 'serial', '59f83746-e6fc-49f4-a77b-cb821493e11f', NULL, NULL, NULL, NULL, '2026-10-27 14:05:27.88256+00'),
	(232, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'inspection.decide', 'inspection', 'b736570d-901e-4946-8426-3964a7d068ea', NULL, '{"passed": true}', NULL, NULL, '2026-10-27 14:05:27.901101+00'),
	(233, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', '8ae22a03-32b1-4748-8bf1-d87d65e87239', NULL, '{"no": "TST-2026-000007", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:27.908265+00'),
	(234, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', '99ce4b0e-6f9a-4800-afa2-988dfad83639', NULL, '{"no": "TST-2026-000008", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:27.916456+00'),
	(235, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', '77ceca33-0e5d-4e2a-9009-a34519185643', NULL, '{"no": "TST-2026-000009", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:27.926332+00'),
	(236, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'unit.release', 'serial', '4cb646d1-3878-4424-b41c-fdcf1caceca0', NULL, NULL, NULL, NULL, '2026-10-27 14:05:27.935548+00'),
	(237, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'inspection.decide', 'inspection', '8cfe765b-237a-4800-aece-9f296f9bd3c0', NULL, '{"passed": true}', NULL, NULL, '2026-10-27 14:05:27.955752+00'),
	(238, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', 'f2fbeead-8578-4167-a51a-5d910769b3fc', NULL, '{"no": "TST-2026-000010", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:27.966175+00'),
	(239, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', '155233ac-87b5-4dce-ad5a-c8e42fce1c1f', NULL, '{"no": "TST-2026-000011", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:27.975098+00'),
	(240, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', 'cc6ddc70-2b29-4dff-b81f-bca9a8fe0686', NULL, '{"no": "TST-2026-000012", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:27.983029+00'),
	(241, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'unit.release', 'serial', '400708e9-52e1-4214-b07c-c7837dbeeb2c', NULL, NULL, NULL, NULL, '2026-10-27 14:05:27.991128+00'),
	(242, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'inspection.decide', 'inspection', '7d813395-dd05-4c6c-8940-3e1684a1466e', NULL, '{"passed": true}', NULL, NULL, '2026-10-27 14:05:28.008882+00'),
	(243, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', 'c0f5d4be-7476-4da7-a6eb-04ca82805220', NULL, '{"no": "TST-2026-000013", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:28.01589+00'),
	(244, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', 'd8336e36-1ee0-4010-8f65-6a1c04ac94ab', NULL, '{"no": "TST-2026-000014", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:28.023793+00'),
	(245, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', '45c74bd0-0ff9-426b-a1ec-5e19a05910f0', NULL, '{"no": "TST-2026-000015", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:28.032303+00'),
	(246, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'unit.release', 'serial', 'f287ea25-7179-4e4d-a695-4bb1414938da', NULL, NULL, NULL, NULL, '2026-10-27 14:05:28.040789+00'),
	(247, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'inspection.decide', 'inspection', 'f55e5a5f-3f03-49d3-a9d0-db3d5e60164c', NULL, '{"passed": true}', NULL, NULL, '2026-10-27 14:05:28.058682+00'),
	(248, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', 'e432544b-f273-406b-aa9a-b1315a46ba35', NULL, '{"no": "TST-2026-000016", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:28.065337+00'),
	(249, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', 'fad75148-c6a7-4a9d-bbe8-b3438b8ffd0d', NULL, '{"no": "TST-2026-000017", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:28.073399+00'),
	(250, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', '591bd3fd-42ff-4f5a-9f9a-3a7db4e77474', NULL, '{"no": "TST-2026-000018", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:28.081155+00');
INSERT INTO public.audit_logs VALUES
	(251, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'unit.release', 'serial', 'e612e4b3-497c-470c-8396-74a36728f675', NULL, NULL, NULL, NULL, '2026-10-27 14:05:28.089233+00'),
	(252, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'inspection.decide', 'inspection', '998e04ec-a402-4631-b5a2-3cb33c304d8a', NULL, '{"passed": true}', NULL, NULL, '2026-10-27 14:05:28.106887+00'),
	(253, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', '2d75ff47-b033-44a2-95aa-a7dc352e0251', NULL, '{"no": "TST-2026-000019", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:28.114004+00'),
	(254, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', '0d744884-012b-476f-a58a-b3e9829b295e', NULL, '{"no": "TST-2026-000020", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:28.121591+00'),
	(255, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', 'de6fc941-2034-491e-afdf-266a89439dfc', NULL, '{"no": "TST-2026-000021", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:28.130112+00'),
	(256, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'unit.release', 'serial', '326a1502-8dcd-4de5-acf8-f5b56b4ec57c', NULL, NULL, NULL, NULL, '2026-10-27 14:05:28.137957+00'),
	(257, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'inspection.decide', 'inspection', 'f32264de-e8d9-45a3-b13b-8726dbc71466', NULL, '{"passed": true}', NULL, NULL, '2026-10-27 14:05:28.156346+00'),
	(258, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', 'e22b2456-2241-4088-8c3f-47d35b88b9c8', NULL, '{"no": "TST-2026-000022", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:28.163738+00'),
	(259, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', '1d811776-7fe6-4a93-9ed7-5fe92e2d6c94', NULL, '{"no": "TST-2026-000023", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:28.171535+00'),
	(260, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', 'b5254f38-742d-4913-a206-993e02a1f0c6', NULL, '{"no": "TST-2026-000024", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:28.180401+00'),
	(261, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'unit.release', 'serial', 'c8b7b4fb-6148-494b-990d-b2b14b6350b3', NULL, NULL, NULL, NULL, '2026-10-27 14:05:28.188109+00'),
	(262, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'inspection.decide', 'inspection', 'b3ad121e-3f59-408c-aae1-f466df76f001', NULL, '{"passed": true}', NULL, NULL, '2026-10-27 14:05:28.206274+00'),
	(263, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', 'b6a2db42-5912-497a-bf8e-5aae16863a89', NULL, '{"no": "TST-2026-000025", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:28.213474+00'),
	(264, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', '8a4bb1f0-d646-49ea-8317-d6aa628d7f83', NULL, '{"no": "TST-2026-000026", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:28.224355+00'),
	(265, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', '8a0134d1-bc8b-44bc-b930-630994317538', NULL, '{"no": "TST-2026-000027", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:28.232225+00'),
	(266, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'unit.release', 'serial', '451711cb-bdb5-46aa-a135-e7bb6ce9a477', NULL, NULL, NULL, NULL, '2026-10-27 14:05:28.241875+00'),
	(267, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'inspection.decide', 'inspection', 'f31a502e-5baf-460b-9479-534447534a74', NULL, '{"passed": true}', NULL, NULL, '2026-10-27 14:05:28.261784+00'),
	(268, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', '69d7ee45-d84f-42b6-b6f8-2fdeed29b46d', NULL, '{"no": "TST-2026-000028", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:28.268864+00'),
	(269, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', '7dfa7962-03e8-42c1-84b0-9fcefeb22bce', NULL, '{"no": "TST-2026-000029", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:28.279192+00'),
	(270, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', '538a87fa-a8d9-4ee4-b143-378a185f0584', NULL, '{"no": "TST-2026-000030", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:28.289637+00'),
	(271, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'unit.release', 'serial', '1f31d15f-0bf3-45b3-991b-db09ef7af236', NULL, NULL, NULL, NULL, '2026-10-27 14:05:28.303184+00'),
	(272, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'inspection.decide', 'inspection', '63458516-afb6-4e56-aa47-c0f2dded7761', NULL, '{"passed": true}', NULL, NULL, '2026-10-27 14:05:28.329163+00'),
	(273, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', 'c8e4b7b5-ef7c-4adc-8ad1-4c6af3ba1237', NULL, '{"no": "TST-2026-000031", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:28.337482+00'),
	(274, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', '23127ce9-6d7b-4a05-832c-bb60219ccac2', NULL, '{"no": "TST-2026-000032", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:28.347952+00'),
	(275, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', 'de9344f2-161a-411d-9cf7-87da967808a6', NULL, '{"no": "TST-2026-000033", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:28.358038+00'),
	(276, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'unit.release', 'serial', '92d9db2b-a78c-4256-bbf9-24dfafbec521', NULL, NULL, NULL, NULL, '2026-10-27 14:05:28.367684+00'),
	(277, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'inspection.decide', 'inspection', '353e62d6-f468-4b38-be73-3117b26056b5', NULL, '{"passed": true}', NULL, NULL, '2026-10-27 14:05:28.390951+00'),
	(278, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', '63f23238-34b7-4c11-aa13-f06fefa7f946', NULL, '{"no": "TST-2026-000034", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:28.400044+00'),
	(279, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', 'c14deff2-d6e9-4353-9507-08d866c7453f', NULL, '{"no": "TST-2026-000035", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:28.409752+00'),
	(280, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', '7d856c5a-7f59-49cc-bd61-1765bfdd4ea4', NULL, '{"no": "TST-2026-000036", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:28.419269+00'),
	(281, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'unit.release', 'serial', 'b23230f2-f025-43ed-82dc-75a1c78a3ea1', NULL, NULL, NULL, NULL, '2026-10-27 14:05:28.428867+00'),
	(282, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'inspection.decide', 'inspection', 'f8b7831f-d61b-44c9-b3db-93e60d8af5fd', NULL, '{"passed": true}', NULL, NULL, '2026-10-27 14:05:28.447289+00'),
	(283, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', 'e10db956-431a-439c-93fd-1dccdcf33c29', NULL, '{"no": "TST-2026-000037", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:28.455106+00'),
	(284, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', '8efe6337-8f17-428f-b776-ba1bfbf98c18', NULL, '{"no": "TST-2026-000038", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:28.466261+00'),
	(285, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', 'a229b371-2a14-43db-a4a9-433d230ca32b', NULL, '{"no": "TST-2026-000039", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:28.476759+00'),
	(286, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'unit.release', 'serial', '6140c882-132d-428a-9759-c01123be0297', NULL, NULL, NULL, NULL, '2026-10-27 14:05:28.486223+00'),
	(287, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', '13bf0ecf-b618-4e85-ae54-96b8fcc2923a', NULL, '{"no": "TST-2026-000040", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:28.498454+00'),
	(288, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'ncr.raise', 'ncr', 'afe88422-33b9-4c6d-8e5c-0b25caf7bf98', NULL, '{"id": "aadedcfe-763b-415f-974a-9ee47e39b3e2", "no": "NCR-2026-000003", "type": "TEST", "label": "PV-2026-00010", "description": "SEAT_LEAK test TST-2026-000041 failed on PV-2026-00010 (allowable Max 0 bubbles/min (ISO 5208 Rate A), measured 12 bubbles/min)"}', NULL, NULL, '2026-10-27 14:05:28.506525+00'),
	(289, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', 'aadedcfe-763b-415f-974a-9ee47e39b3e2', NULL, '{"no": "TST-2026-000041", "result": "FAIL"}', NULL, NULL, '2026-10-27 14:05:28.506525+00'),
	(290, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'ncr.propose', 'ncr', 'afe88422-33b9-4c6d-8e5c-0b25caf7bf98', NULL, '{"disposition": "RETEST"}', NULL, NULL, '2026-10-27 14:05:28.520536+00'),
	(291, '4a0f88e6-467f-406c-a37b-fde4abff9898', '6b544707-dfa2-4b3b-8cf6-5d69641b903c', 'Meera Krishnan (Plant Head)', 'approval.approve', 'approval', '91f505e8-bc9a-4dfa-97a0-8c65dd7e9e7c', NULL, NULL, '{"note": "Approved — retest under witness"}', NULL, '2026-10-27 14:05:28.529462+00'),
	(292, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', '69229ca5-2660-4d57-aa60-f01675b5aff0', NULL, '{"no": "TST-2026-000042", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:28.538564+00'),
	(293, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', '73aba2e3-ba1b-4562-8a34-98105cc76293', NULL, '{"no": "TST-2026-000043", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:28.547529+00'),
	(294, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'inspection.decide', 'inspection', 'e4ee5236-ce7e-440b-85b5-3a2f323086bb', NULL, '{"passed": true}', NULL, NULL, '2026-10-27 14:05:28.561811+00'),
	(295, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'unit.release', 'serial', '25dd99d8-20bf-48f8-bece-c7e4f0bf1514', NULL, NULL, NULL, NULL, '2026-10-27 14:05:28.568526+00'),
	(296, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'inspection.decide', 'inspection', 'a5f11fbd-2b9d-4203-ba04-662a204a20a4', NULL, '{"passed": true}', NULL, NULL, '2026-10-27 14:05:28.587821+00'),
	(297, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', 'd703876d-59a7-427a-a8bd-4f9ad37519e7', NULL, '{"no": "TST-2026-000044", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:28.596336+00'),
	(298, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'ncr.raise', 'ncr', 'e575d512-297e-47e7-8acb-49055bf63283', NULL, '{"id": "232602e7-5a1f-470f-8feb-ef489f3e3cc5", "no": "NCR-2026-000004", "type": "TEST", "label": "PV-2026-00016", "description": "SEAT_LEAK test TST-2026-000045 failed on PV-2026-00016 (allowable Max 0 bubbles/min (ISO 5208 Rate A), measured 12 bubbles/min)"}', NULL, NULL, '2026-10-27 14:05:28.604262+00'),
	(299, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', '232602e7-5a1f-470f-8feb-ef489f3e3cc5', NULL, '{"no": "TST-2026-000045", "result": "FAIL"}', NULL, NULL, '2026-10-27 14:05:28.604262+00'),
	(300, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', 'fe42fa29-de7c-497c-adcf-d496e04619c1', NULL, '{"no": "TST-2026-000046", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:28.617526+00');
INSERT INTO public.audit_logs VALUES
	(301, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'inspection.decide', 'inspection', '4f79c4f3-fcac-45e9-94c8-b2def51cf8f0', NULL, '{"passed": true}', NULL, NULL, '2026-10-27 14:05:28.632369+00'),
	(302, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', '2b6d2706-0a6d-41d0-bd33-5d1ba4246846', NULL, '{"no": "TST-2026-000047", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:28.639041+00'),
	(303, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', 'e745d095-4c67-4a4f-abe7-a13a4e4f73aa', NULL, '{"no": "TST-2026-000048", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:28.647338+00'),
	(304, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'test.record', 'test', 'dfb8c529-2c60-427b-96eb-6cccf01a0c4a', NULL, '{"no": "TST-2026-000049", "result": "PASS"}', NULL, NULL, '2026-10-27 14:05:28.654748+00'),
	(305, '4a0f88e6-467f-406c-a37b-fde4abff9898', '693a2518-49d6-4f23-8d7c-089491e70217', 'Anjali Nair (Quality)', 'unit.release', 'serial', 'afdd35b7-be62-4847-a82c-64b8ddf1b75f', NULL, NULL, NULL, NULL, '2026-10-27 14:05:28.663419+00'),
	(306, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'shipment.create', 'shipment', '9daa4c8a-5c46-42d9-9043-fd3f27894ce6', NULL, '{"no": "SHP-2026-000001"}', NULL, NULL, '2026-10-27 14:05:28.674673+00'),
	(307, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'shipment.ship', 'shipment', '9daa4c8a-5c46-42d9-9043-fd3f27894ce6', NULL, NULL, NULL, NULL, '2026-10-27 14:05:28.697137+00'),
	(308, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'shipment.create', 'shipment', 'e69f1135-e2e7-4789-b7d8-0338d785cd5d', NULL, '{"no": "SHP-2026-000002"}', NULL, NULL, '2026-10-27 14:05:28.71413+00'),
	(309, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'shipment.ship', 'shipment', 'e69f1135-e2e7-4789-b7d8-0338d785cd5d', NULL, NULL, NULL, NULL, '2026-10-27 14:05:28.733323+00'),
	(310, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'shipment.create', 'shipment', '34487842-ee98-451e-b927-f22db4697158', NULL, '{"no": "SHP-2026-000003"}', NULL, NULL, '2026-10-27 14:05:28.747875+00'),
	(311, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'shipment.ship', 'shipment', '34487842-ee98-451e-b927-f22db4697158', NULL, NULL, NULL, NULL, '2026-10-27 14:05:28.765626+00'),
	(312, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'shipment.create', 'shipment', 'd1930648-ceec-440d-becc-0dfe724e9b41', NULL, '{"no": "SHP-2026-000004"}', NULL, NULL, '2026-10-27 14:05:28.779478+00'),
	(313, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'shipment.create', 'shipment', '771f7e34-04fa-493e-9e97-226ee5bf4110', NULL, '{"no": "SHP-2026-000005"}', NULL, NULL, '2026-10-27 14:05:28.80925+00'),
	(314, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'shipment.create', 'shipment', '9c0b36db-59e8-4b76-b738-1b18d474c762', NULL, '{"no": "SHP-2026-000006"}', NULL, NULL, '2026-10-27 14:05:28.83771+00'),
	(315, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'shipment.create', 'shipment', '728bbe23-7529-49c9-a6f7-aeba8655c86e', NULL, '{"no": "SHP-2026-000007"}', NULL, NULL, '2026-10-27 14:05:28.868824+00'),
	(316, '4a0f88e6-467f-406c-a37b-fde4abff9898', '1b0292cb-4999-40df-893a-e2e9c3dc6101', 'Suresh Pillai (Production)', 'shipment.create', 'shipment', '075652c1-3e13-42cb-9cc8-ceecdf6b1dff', NULL, '{"no": "SHP-2026-000008"}', NULL, NULL, '2026-10-27 14:05:28.901936+00'),
	(317, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'order.transition', 'order', '84f16360-acd8-4658-a08c-5095e56335a6', '{"status": "CONFIRMED"}', '{"status": "ENGINEERING"}', NULL, NULL, '2026-10-27 14:05:28.920514+00'),
	(318, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'order.transition', 'order', '84f16360-acd8-4658-a08c-5095e56335a6', '{"status": "ENGINEERING"}', '{"status": "MATERIAL_CHECK"}', NULL, NULL, '2026-10-27 14:05:28.931983+00'),
	(319, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'order.transition', 'order', '84f16360-acd8-4658-a08c-5095e56335a6', '{"status": "MATERIAL_CHECK"}', '{"status": "PROCUREMENT"}', NULL, NULL, '2026-10-27 14:05:28.94159+00'),
	(320, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'order.transition', 'order', '84f16360-acd8-4658-a08c-5095e56335a6', '{"status": "PROCUREMENT"}', '{"status": "READY"}', NULL, NULL, '2026-10-27 14:05:28.952358+00'),
	(321, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'invoice.create', 'invoice', 'b5b3c1d7-f38b-4cf8-a6fa-83982def8785', NULL, '{"grand": 7700, "invNumber": "INV-2026-000001"}', NULL, NULL, '2026-10-27 14:05:28.975+00'),
	(322, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'invoice.transition', 'invoice', 'b5b3c1d7-f38b-4cf8-a6fa-83982def8785', '{"status": "DRAFT"}', '{"status": "ISSUED"}', NULL, NULL, '2026-10-27 14:05:28.997868+00'),
	(323, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'payment.create', 'payment', '69f9cc5b-7af2-433a-bb98-8b4815923b1e', NULL, '{"amount": 3850, "invoiceId": "b5b3c1d7-f38b-4cf8-a6fa-83982def8785"}', NULL, NULL, '2026-10-27 14:05:29.019448+00'),
	(324, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'order.transition', 'order', 'bc2c7461-b1cd-4c66-8996-611e28098035', '{"status": "CONFIRMED"}', '{"status": "ENGINEERING"}', NULL, NULL, '2026-10-27 14:05:29.036034+00'),
	(325, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'order.transition', 'order', 'bc2c7461-b1cd-4c66-8996-611e28098035', '{"status": "ENGINEERING"}', '{"status": "MATERIAL_CHECK"}', NULL, NULL, '2026-10-27 14:05:29.048653+00'),
	(326, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'order.transition', 'order', 'bc2c7461-b1cd-4c66-8996-611e28098035', '{"status": "MATERIAL_CHECK"}', '{"status": "PROCUREMENT"}', NULL, NULL, '2026-10-27 14:05:29.05917+00'),
	(327, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'invoice.create', 'invoice', 'af319e29-79f3-42e0-8a7b-0f905462b0f1', NULL, '{"grand": 5664, "invNumber": "INV-2026-000002"}', NULL, NULL, '2026-10-27 14:05:29.084999+00'),
	(328, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'invoice.transition', 'invoice', 'af319e29-79f3-42e0-8a7b-0f905462b0f1', '{"status": "DRAFT"}', '{"status": "ISSUED"}', NULL, NULL, '2026-10-27 14:05:29.104438+00'),
	(329, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'payment.create', 'payment', 'ca51b05e-21e9-4085-93bc-4e3bce1331a2', NULL, '{"amount": 5664, "invoiceId": "af319e29-79f3-42e0-8a7b-0f905462b0f1"}', NULL, NULL, '2026-10-27 14:05:29.118455+00'),
	(330, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'invoice.create', 'invoice', 'a526920e-7321-4968-b2ca-ffa2b379e6d9', NULL, '{"grand": 27013, "invNumber": "INV-2026-000003"}', NULL, NULL, '2026-10-27 14:05:29.129413+00'),
	(331, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'invoice.transition', 'invoice', 'a526920e-7321-4968-b2ca-ffa2b379e6d9', '{"status": "DRAFT"}', '{"status": "ISSUED"}', NULL, NULL, '2026-10-27 14:05:29.145986+00'),
	(332, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'invoice.transition', 'invoice', 'a526920e-7321-4968-b2ca-ffa2b379e6d9', '{"status": "ISSUED"}', '{"status": "OVERDUE"}', NULL, NULL, '2026-10-27 14:05:29.161616+00'),
	(333, '4a0f88e6-467f-406c-a37b-fde4abff9898', '6b544707-dfa2-4b3b-8cf6-5d69641b903c', 'Meera Krishnan (Plant Head)', 'approval.approve', 'approval', '50904c9b-cb3d-4374-acfb-23603d626dcc', NULL, NULL, '{"note": "Approved"}', NULL, '2026-10-27 14:05:29.241649+00'),
	(334, '4a0f88e6-467f-406c-a37b-fde4abff9898', '6b544707-dfa2-4b3b-8cf6-5d69641b903c', 'Meera Krishnan (Plant Head)', 'ecn.implement', 'ecn', '32f47fe3-2898-4403-8d0c-2bcf34ad2aed', NULL, NULL, NULL, NULL, '2026-10-27 14:05:29.248813+00'),
	(335, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'approval.request', 'approval', '3e27e65e-f4db-45fe-b46d-ca208d27cbbf', NULL, '{"kind": "QUOTE_DISCOUNT", "amount": 85000, "reason": "Competitive tender", "entity_type": "manual", "entity_label": "Quote for Bharat Oilfield — 12% discount"}', NULL, NULL, '2026-10-27 14:05:29.256238+00'),
	(336, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'approval.request', 'approval', 'ed318763-1d6f-4590-a2d7-3194132e0482', NULL, '{"kind": "PO_VALUE", "amount": 708000, "reason": "Above ₹5 lakh — needs senior approval", "entity_type": "manual", "entity_label": "PO — Eastern Alloys SS316 bar stock"}', NULL, NULL, '2026-10-27 14:05:29.262547+00'),
	(337, '4a0f88e6-467f-406c-a37b-fde4abff9898', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', 'approval.request', 'approval', '36a03111-1809-4b03-973f-7274cb37a4dd', NULL, '{"kind": "CREDIT_OVERRIDE", "amount": 300000, "reason": "Customer promised payment on Friday", "entity_type": "manual", "entity_label": "Release order for Sahara Fertilizers on credit hold"}', NULL, NULL, '2026-10-27 14:05:29.268359+00'),
	(338, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', 'integration.retry', 'integration', '5581d443-f815-41d8-b42f-b63268e35b3f', NULL, NULL, '{"key": "INV-SYNC-0003"}', NULL, '2026-10-27 14:05:29.354347+00');


--
-- Data for Name: automation_events; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: product_categories; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.products VALUES
	('6e212887-960b-4eed-ade6-18715e05c5cb', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PV-BV-050', 'Ball Valve 50mm SS316', NULL, NULL, 'NOS', 'SS316', NULL, NULL, '84818090', 18.00, 1200.0000, 2100.0000, 5.000, 10.000, true, NULL, NULL, '2026-10-27 14:05:21.445587+00', '2026-10-27 14:05:21.445587+00', 1),
	('eb07eab2-eba7-4b97-88f8-9066662e9a5e', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PV-GV-080', 'Gate Valve 80mm CF8M', NULL, NULL, 'NOS', 'CF8M', NULL, NULL, '84818090', 18.00, 3400.0000, 5900.0000, 5.000, 10.000, true, NULL, NULL, '2026-10-27 14:05:21.445587+00', '2026-10-27 14:05:21.445587+00', 1),
	('abe0ed52-e0fd-424a-b2d4-00c1c625767f', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PV-SEAT-01', 'PTFE Seat Ring', NULL, NULL, 'NOS', 'PTFE', NULL, NULL, '84819090', 18.00, 90.0000, 180.0000, 5.000, 10.000, false, NULL, NULL, '2026-10-27 14:05:21.445587+00', '2026-10-27 14:05:21.445587+00', 1),
	('961b2013-58fb-45fb-8a7c-618c84887c18', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PV-STEM-01', 'Valve Stem SS316', NULL, NULL, 'NOS', 'SS316', NULL, NULL, '84819090', 18.00, 220.0000, 420.0000, 5.000, 10.000, false, NULL, NULL, '2026-10-27 14:05:21.445587+00', '2026-10-27 14:05:21.445587+00', 1),
	('82048a24-aa7e-422f-bee0-1642d75bd996', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PV-BV-025', 'Ball Valve 25mm SS316', NULL, NULL, 'NOS', 'SS316', NULL, NULL, '84818090', 18.00, 820.0000, 1450.0000, 5.000, 10.000, true, NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:23.560744+00', '2026-10-27 14:05:23.560744+00', 1),
	('6f56aa1e-de31-44a5-b842-756c12aa7646', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PV-BV-100', 'Ball Valve 100mm CF8M', NULL, NULL, 'NOS', 'CF8M', NULL, NULL, '84818090', 18.00, 3900.0000, 6800.0000, 5.000, 10.000, true, NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:23.569957+00', '2026-10-27 14:05:23.569957+00', 1),
	('d61fe768-7f6e-4d65-b1f1-6f5621e2008b', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PV-GV-050', 'Gate Valve 50mm WCB', NULL, NULL, 'NOS', 'WCB', NULL, NULL, '84818090', 18.00, 1700.0000, 3100.0000, 5.000, 10.000, true, NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:23.577814+00', '2026-10-27 14:05:23.577814+00', 1),
	('9152c8e7-6ed4-495d-a58c-ee509367659f', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PV-GV-150', 'Gate Valve 150mm CF8M', NULL, NULL, 'NOS', 'CF8M', NULL, NULL, '84818090', 18.00, 7600.0000, 12900.0000, 5.000, 10.000, true, NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:23.58415+00', '2026-10-27 14:05:23.58415+00', 1),
	('92a93794-1287-4b7d-8868-7b9b81b87cb2', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PV-CV-050', 'Check Valve 50mm SS316', NULL, NULL, 'NOS', 'SS316', NULL, NULL, '84818090', 18.00, 1350.0000, 2400.0000, 5.000, 10.000, true, NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:23.590884+00', '2026-10-27 14:05:23.590884+00', 1),
	('77a428fe-4dd9-4a6e-8138-36a5f4efc6b2', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PV-GLV-050', 'Globe Valve 50mm SS316', NULL, NULL, 'NOS', 'SS316', NULL, NULL, '84818090', 18.00, 1900.0000, 3400.0000, 5.000, 10.000, true, NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:23.597607+00', '2026-10-27 14:05:23.597607+00', 1),
	('65e1cab5-04f9-4e45-9081-e07e65803ba9', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PV-BFV-200', 'Butterfly Valve 200mm', NULL, NULL, 'NOS', 'CI/SS', NULL, NULL, '84818090', 18.00, 4800.0000, 8200.0000, 5.000, 10.000, true, NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:23.603605+00', '2026-10-27 14:05:23.603605+00', 1),
	('d14a8056-467a-425a-a517-b0f08e05e8ec', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PV-BODY-01', 'Valve body casting CF8M', NULL, NULL, 'NOS', 'CF8M', NULL, NULL, '84818090', 18.00, 620.0000, 0.0000, 5.000, 10.000, false, NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:23.610141+00', '2026-10-27 14:05:23.610141+00', 1),
	('2488bae2-79d6-4ce2-95c8-385344da703b', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PV-BONNET-01', 'Bonnet forging CF8M', NULL, NULL, 'NOS', 'CF8M', NULL, NULL, '84818090', 18.00, 410.0000, 0.0000, 5.000, 10.000, false, NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:23.616331+00', '2026-10-27 14:05:23.616331+00', 1),
	('086765c3-bd85-4e70-85fe-183ad180df42', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PV-BAR-316', 'SS316 bar stock Ø40', NULL, NULL, 'NOS', 'SS316', NULL, NULL, '84818090', 18.00, 150.0000, 0.0000, 5.000, 10.000, false, NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:23.622516+00', '2026-10-27 14:05:23.622516+00', 1),
	('8922a168-0213-41f6-b58a-7dab5331adda', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PV-GASKET-01', 'Graphite gasket set', NULL, NULL, 'NOS', 'Graphite', NULL, NULL, '84818090', 18.00, 45.0000, 0.0000, 5.000, 10.000, false, NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:23.629695+00', '2026-10-27 14:05:23.629695+00', 1);


--
-- Data for Name: boms; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.boms VALUES
	('cac69cb4-3f20-4878-8c8d-a310e4607bd7', '4a0f88e6-467f-406c-a37b-fde4abff9898', '82048a24-aa7e-422f-bee0-1642d75bd996', 1, 'RELEASED', '2026-08-28', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:23.980516+00', '2026-10-27 14:05:23.980516+00', 1),
	('563fed79-8437-4a25-85f6-65325961f433', '4a0f88e6-467f-406c-a37b-fde4abff9898', '6e212887-960b-4eed-ade6-18715e05c5cb', 1, 'RELEASED', '2026-08-28', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:24.0025+00', '2026-10-27 14:05:24.0025+00', 1),
	('21fc1271-3f37-4597-a7aa-fd8c516a4131', '4a0f88e6-467f-406c-a37b-fde4abff9898', '6f56aa1e-de31-44a5-b842-756c12aa7646', 1, 'RELEASED', '2026-08-28', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:24.022613+00', '2026-10-27 14:05:24.022613+00', 1),
	('e3d4d7da-4f03-4476-9332-022984f0cf0c', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'd61fe768-7f6e-4d65-b1f1-6f5621e2008b', 1, 'RELEASED', '2026-08-28', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:24.042454+00', '2026-10-27 14:05:24.042454+00', 1),
	('7ca0874b-5082-4dce-8800-f3ed34743c47', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'eb07eab2-eba7-4b97-88f8-9066662e9a5e', 1, 'RELEASED', '2026-08-28', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:24.061794+00', '2026-10-27 14:05:24.061794+00', 1),
	('85311685-a1d7-4c26-b54e-19fc7c4a6494', '4a0f88e6-467f-406c-a37b-fde4abff9898', '92a93794-1287-4b7d-8868-7b9b81b87cb2', 1, 'RELEASED', '2026-08-28', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:24.08111+00', '2026-10-27 14:05:24.08111+00', 1),
	('d57a4930-25cb-45bd-a7ca-04ca02254919', '4a0f88e6-467f-406c-a37b-fde4abff9898', '77a428fe-4dd9-4a6e-8138-36a5f4efc6b2', 1, 'RELEASED', '2026-08-28', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:24.100321+00', '2026-10-27 14:05:24.100321+00', 1),
	('580dd0b3-4c5d-4702-9cee-823273a7ee81', '4a0f88e6-467f-406c-a37b-fde4abff9898', '65e1cab5-04f9-4e45-9081-e07e65803ba9', 1, 'RELEASED', '2026-08-28', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:24.118809+00', '2026-10-27 14:05:24.118809+00', 1),
	('9110d097-a1d0-4b61-96e3-acceadf19768', '4a0f88e6-467f-406c-a37b-fde4abff9898', '9152c8e7-6ed4-495d-a58c-ee509367659f', 1, 'DRAFT', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:24.137746+00', '2026-10-27 14:05:24.137746+00', 1);


--
-- Data for Name: bom_lines; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.bom_lines VALUES
	('0c941f60-1936-4dd1-be90-31624f480a2d', 'cac69cb4-3f20-4878-8c8d-a310e4607bd7', 'd14a8056-467a-425a-a517-b0f08e05e8ec', 1.0000, 'NOS', 2.00),
	('ad1cdf39-8c4d-4700-bc97-78b4fe0bc952', 'cac69cb4-3f20-4878-8c8d-a310e4607bd7', '961b2013-58fb-45fb-8a7c-618c84887c18', 1.0000, 'NOS', 1.00),
	('75596750-207f-41c6-a415-89aae8ee0214', 'cac69cb4-3f20-4878-8c8d-a310e4607bd7', 'abe0ed52-e0fd-424a-b2d4-00c1c625767f', 2.0000, 'NOS', 0.00),
	('a01b24f1-41ac-4b56-b101-a94310823828', 'cac69cb4-3f20-4878-8c8d-a310e4607bd7', '2488bae2-79d6-4ce2-95c8-385344da703b', 1.0000, 'NOS', 2.00),
	('91ea015b-a6b9-4e3b-8f3e-3602fe47e090', 'cac69cb4-3f20-4878-8c8d-a310e4607bd7', '8922a168-0213-41f6-b58a-7dab5331adda', 1.0000, 'NOS', 0.00),
	('a0d89a3b-d100-44ad-96e4-8e7fc2b12a08', '563fed79-8437-4a25-85f6-65325961f433', 'd14a8056-467a-425a-a517-b0f08e05e8ec', 1.0000, 'NOS', 2.00),
	('c03a4c6e-18e9-4301-882b-02f85dcf024d', '563fed79-8437-4a25-85f6-65325961f433', '961b2013-58fb-45fb-8a7c-618c84887c18', 1.0000, 'NOS', 1.00),
	('61ae7445-2da6-402a-8fae-81ccf248c88b', '563fed79-8437-4a25-85f6-65325961f433', 'abe0ed52-e0fd-424a-b2d4-00c1c625767f', 2.0000, 'NOS', 0.00),
	('8ca9a73c-62cd-41d7-baf6-371cb8963537', '563fed79-8437-4a25-85f6-65325961f433', '2488bae2-79d6-4ce2-95c8-385344da703b', 1.0000, 'NOS', 2.00),
	('dc68c2f9-b5ef-4a67-9d2d-33a9a24a2579', '563fed79-8437-4a25-85f6-65325961f433', '8922a168-0213-41f6-b58a-7dab5331adda', 1.0000, 'NOS', 0.00),
	('fb9ebe8c-f413-491f-a315-3247a8478e6c', '21fc1271-3f37-4597-a7aa-fd8c516a4131', 'd14a8056-467a-425a-a517-b0f08e05e8ec', 1.0000, 'NOS', 2.00),
	('7f0b547a-4bee-4ff2-9033-37cf1c4e34bc', '21fc1271-3f37-4597-a7aa-fd8c516a4131', '961b2013-58fb-45fb-8a7c-618c84887c18', 1.0000, 'NOS', 1.00),
	('0d8e3a65-d96f-4ae6-9a96-a40e5b0971ff', '21fc1271-3f37-4597-a7aa-fd8c516a4131', 'abe0ed52-e0fd-424a-b2d4-00c1c625767f', 2.0000, 'NOS', 0.00),
	('b91d822a-7adc-4356-a00f-3954f277a597', '21fc1271-3f37-4597-a7aa-fd8c516a4131', '2488bae2-79d6-4ce2-95c8-385344da703b', 1.0000, 'NOS', 2.00),
	('42c1ce9e-8262-4434-a8ba-e3dc3d31dc86', '21fc1271-3f37-4597-a7aa-fd8c516a4131', '8922a168-0213-41f6-b58a-7dab5331adda', 1.0000, 'NOS', 0.00),
	('f70bcde5-248e-4fda-a726-8f29798385d6', 'e3d4d7da-4f03-4476-9332-022984f0cf0c', 'd14a8056-467a-425a-a517-b0f08e05e8ec', 1.0000, 'NOS', 2.00),
	('b5a09eb6-de02-4af8-9566-a2d86801eedd', 'e3d4d7da-4f03-4476-9332-022984f0cf0c', '961b2013-58fb-45fb-8a7c-618c84887c18', 1.0000, 'NOS', 1.00),
	('94d4b60d-5e2e-4313-acd8-ec24c3da4fbd', 'e3d4d7da-4f03-4476-9332-022984f0cf0c', 'abe0ed52-e0fd-424a-b2d4-00c1c625767f', 2.0000, 'NOS', 0.00),
	('407df04a-4499-4992-9307-c894795f2ed3', 'e3d4d7da-4f03-4476-9332-022984f0cf0c', '2488bae2-79d6-4ce2-95c8-385344da703b', 1.0000, 'NOS', 2.00),
	('8e07f909-3685-4753-b53f-de52bb87fe9c', 'e3d4d7da-4f03-4476-9332-022984f0cf0c', '8922a168-0213-41f6-b58a-7dab5331adda', 1.0000, 'NOS', 0.00),
	('0949ad3c-f699-45b3-82e2-150b4e7e7cb8', '7ca0874b-5082-4dce-8800-f3ed34743c47', 'd14a8056-467a-425a-a517-b0f08e05e8ec', 1.0000, 'NOS', 2.00),
	('ab6b207d-e528-4035-b1f8-575a4c1063c3', '7ca0874b-5082-4dce-8800-f3ed34743c47', '961b2013-58fb-45fb-8a7c-618c84887c18', 1.0000, 'NOS', 1.00),
	('0c135e82-d66d-4357-9789-733be893fa8b', '7ca0874b-5082-4dce-8800-f3ed34743c47', 'abe0ed52-e0fd-424a-b2d4-00c1c625767f', 2.0000, 'NOS', 0.00),
	('776dd079-a19c-4cc9-bec6-1f1190f50daa', '7ca0874b-5082-4dce-8800-f3ed34743c47', '2488bae2-79d6-4ce2-95c8-385344da703b', 1.0000, 'NOS', 2.00),
	('484bef5a-2a7f-4ce9-a824-e0809aa9d455', '7ca0874b-5082-4dce-8800-f3ed34743c47', '8922a168-0213-41f6-b58a-7dab5331adda', 1.0000, 'NOS', 0.00),
	('8e98c979-02c8-432a-9784-cc87ccab474b', '85311685-a1d7-4c26-b54e-19fc7c4a6494', 'd14a8056-467a-425a-a517-b0f08e05e8ec', 1.0000, 'NOS', 2.00),
	('7cf73399-a3f6-4517-abd5-3079960b15c1', '85311685-a1d7-4c26-b54e-19fc7c4a6494', '961b2013-58fb-45fb-8a7c-618c84887c18', 1.0000, 'NOS', 1.00),
	('351ea1c3-5d38-4704-b53e-ed999eadfd65', '85311685-a1d7-4c26-b54e-19fc7c4a6494', 'abe0ed52-e0fd-424a-b2d4-00c1c625767f', 2.0000, 'NOS', 0.00),
	('8c697e80-dba7-4940-b1df-c3194b052aa4', '85311685-a1d7-4c26-b54e-19fc7c4a6494', '2488bae2-79d6-4ce2-95c8-385344da703b', 1.0000, 'NOS', 2.00),
	('3168acd5-ac7a-4c44-b8f7-d9dcb149d2fd', '85311685-a1d7-4c26-b54e-19fc7c4a6494', '8922a168-0213-41f6-b58a-7dab5331adda', 1.0000, 'NOS', 0.00),
	('ffa1ac24-8807-4cc4-aeb3-e677db718030', 'd57a4930-25cb-45bd-a7ca-04ca02254919', 'd14a8056-467a-425a-a517-b0f08e05e8ec', 1.0000, 'NOS', 2.00),
	('68f246eb-a658-42f6-bb41-e101e2ef86a7', 'd57a4930-25cb-45bd-a7ca-04ca02254919', '961b2013-58fb-45fb-8a7c-618c84887c18', 1.0000, 'NOS', 1.00),
	('50639aea-78eb-45a4-8cf9-7e53d6bd644e', 'd57a4930-25cb-45bd-a7ca-04ca02254919', 'abe0ed52-e0fd-424a-b2d4-00c1c625767f', 2.0000, 'NOS', 0.00),
	('fe1a5d83-ddb5-42b5-863c-9351301a44b7', 'd57a4930-25cb-45bd-a7ca-04ca02254919', '2488bae2-79d6-4ce2-95c8-385344da703b', 1.0000, 'NOS', 2.00),
	('2f38f7d7-674a-4307-b58e-864ab49bf411', 'd57a4930-25cb-45bd-a7ca-04ca02254919', '8922a168-0213-41f6-b58a-7dab5331adda', 1.0000, 'NOS', 0.00),
	('c3d158ca-1fbd-40ec-bae7-188ddf1a37f3', '580dd0b3-4c5d-4702-9cee-823273a7ee81', 'd14a8056-467a-425a-a517-b0f08e05e8ec', 1.0000, 'NOS', 2.00),
	('fed58538-0b2e-48a9-a4a6-30db13187e04', '580dd0b3-4c5d-4702-9cee-823273a7ee81', '961b2013-58fb-45fb-8a7c-618c84887c18', 1.0000, 'NOS', 1.00),
	('3f804d37-63c8-48dc-a706-306f0d80034b', '580dd0b3-4c5d-4702-9cee-823273a7ee81', 'abe0ed52-e0fd-424a-b2d4-00c1c625767f', 2.0000, 'NOS', 0.00),
	('236d2b09-84b1-4ac9-8462-f7b3a44977bc', '580dd0b3-4c5d-4702-9cee-823273a7ee81', '2488bae2-79d6-4ce2-95c8-385344da703b', 1.0000, 'NOS', 2.00),
	('207a4b79-be36-48f8-a191-7c6aa100ff75', '580dd0b3-4c5d-4702-9cee-823273a7ee81', '8922a168-0213-41f6-b58a-7dab5331adda', 1.0000, 'NOS', 0.00),
	('efdefb43-e3cd-4eef-a0c8-6e080249dbba', '9110d097-a1d0-4b61-96e3-acceadf19768', 'd14a8056-467a-425a-a517-b0f08e05e8ec', 1.0000, 'NOS', 2.00),
	('794446ae-62f0-4ee6-9b3f-fa35626103b5', '9110d097-a1d0-4b61-96e3-acceadf19768', '961b2013-58fb-45fb-8a7c-618c84887c18', 1.0000, 'NOS', 1.00),
	('486fa4e0-cf28-4cdb-8ed2-ccce0592b489', '9110d097-a1d0-4b61-96e3-acceadf19768', 'abe0ed52-e0fd-424a-b2d4-00c1c625767f', 2.0000, 'NOS', 0.00),
	('4f8cc045-06d4-41d1-9f21-fe41c31a8d7f', '9110d097-a1d0-4b61-96e3-acceadf19768', '2488bae2-79d6-4ce2-95c8-385344da703b', 1.0000, 'NOS', 2.00),
	('7e537ac2-6b0c-4d4f-9bc5-d5149f124989', '9110d097-a1d0-4b61-96e3-acceadf19768', '8922a168-0213-41f6-b58a-7dab5331adda', 1.0000, 'NOS', 0.00);


--
-- Data for Name: companies; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.companies VALUES
	('493d756e-cdfe-465c-884b-77f468f1f216', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'CUST-2026-000001', 'ABC Industries', true, false, 'IN', '29', 'Bengaluru', NULL, NULL, '29AABCA1111A1Z5', 'DOMESTIC', 'INR', 'NET30', NULL, '0258e002-4154-48b4-ad1d-2195882841be', NULL, NULL, NULL, '2026-10-27 14:05:21.445587+00', '2026-10-27 14:05:21.445587+00', 1, 'APPROVED', 0.00, false, true, NULL),
	('d52968f6-fca2-437d-afc4-74883a4a0540', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SUPP-2026-000001', 'Precision Castings Ltd', false, true, 'IN', '27', 'Coimbatore', NULL, NULL, NULL, 'DOMESTIC', 'INR', 'NET30', NULL, NULL, NULL, NULL, NULL, '2026-10-27 14:05:21.445587+00', '2026-10-27 14:05:24.159582+00', 2, 'APPROVED', 0.00, false, true, 4.6),
	('4beb637f-1b4c-4c99-9821-18432f34c3d8', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SUPP-2026-000002', 'Bharat Forgings Pvt Ltd', false, true, 'IN', '27', 'Pune', NULL, NULL, NULL, 'DOMESTIC', 'INR', 'NET30', NULL, NULL, NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', NULL, '2026-10-27 14:05:24.168447+00', '2026-10-27 14:05:24.168447+00', 1, 'APPROVED', 0.00, false, true, 4.4),
	('15390c7c-a37d-4ee6-ae7d-8ab0c9d23fa9', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SUPP-2026-000003', 'Tamil Heat Treat Works', false, true, 'IN', '27', 'Chennai', NULL, NULL, NULL, 'DOMESTIC', 'INR', 'NET30', NULL, NULL, NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', NULL, '2026-10-27 14:05:24.17767+00', '2026-10-27 14:05:24.17767+00', 1, 'APPROVED', 0.00, false, true, 4.2),
	('362c5ed7-df92-47df-bc90-a7ed326e1ac2', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SUPP-2026-000004', 'Sri Hardfacing & Coatings', false, true, 'IN', '27', 'Hosur', NULL, NULL, NULL, 'DOMESTIC', 'INR', 'NET30', NULL, NULL, NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', NULL, '2026-10-27 14:05:24.18628+00', '2026-10-27 14:05:24.18628+00', 1, 'APPROVED', 0.00, false, true, 4.0),
	('f010fc14-ae10-4f2b-8f3d-0555bc31309c', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SUPP-2026-000005', 'Precision Seals India', false, true, 'IN', '27', 'Bengaluru', NULL, NULL, NULL, 'DOMESTIC', 'INR', 'NET30', NULL, NULL, NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', NULL, '2026-10-27 14:05:24.195722+00', '2026-10-27 14:05:24.195722+00', 1, 'APPROVED', 0.00, false, true, 4.7),
	('381b66ca-9a74-4434-8030-224a9da35b2e', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SUPP-2026-000006', 'Metro Fasteners', false, true, 'IN', '27', 'Mumbai', NULL, NULL, NULL, 'DOMESTIC', 'INR', 'NET30', NULL, NULL, NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', NULL, '2026-10-27 14:05:24.204377+00', '2026-10-27 14:05:24.204377+00', 1, 'APPROVED', 0.00, false, true, 3.9),
	('2b48019d-4f6b-452d-9a3a-20c75671cdf3', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SUPP-2026-000007', 'Eastern Alloys Corp', false, true, 'IN', '27', 'Kolkata', NULL, NULL, NULL, 'DOMESTIC', 'INR', 'NET30', NULL, NULL, NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', NULL, '2026-10-27 14:05:24.214173+00', '2026-10-27 14:05:24.214173+00', 1, 'CONDITIONAL', 0.00, false, true, 3.1),
	('531915c2-39a2-40d7-88b8-f330000f17c2', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SUPP-2026-000008', 'QuickCast Metals', false, true, 'IN', '27', 'Rajkot', NULL, NULL, NULL, 'DOMESTIC', 'INR', 'NET30', NULL, NULL, NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', NULL, '2026-10-27 14:05:24.222782+00', '2026-10-27 14:05:24.222782+00', 1, 'BLOCKED', 0.00, false, true, 1.8),
	('94b43258-4d8e-48ac-a5b3-04e8607fe937', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'CUST-2026-000014', 'Bharat Oilfield Services', true, false, 'IN', '27', 'Mumbai', NULL, NULL, NULL, 'DOMESTIC', 'INR', 'NET30', NULL, NULL, NULL, '0258e002-4154-48b4-ad1d-2195882841be', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.30593+00', '2026-10-27 14:05:24.35665+00', 2, 'APPROVED', 0.00, false, true, NULL),
	('b93cc6d0-2b05-44d6-ab87-2a4b9cf61a3e', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'CUST-2026-000009', 'Gulf Refining Co.', true, false, 'AE', NULL, 'Dubai', NULL, NULL, NULL, 'EXPORT', 'USD', 'NET30', NULL, NULL, NULL, '0258e002-4154-48b4-ad1d-2195882841be', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.273845+00', '2026-10-27 14:05:24.316529+00', 2, 'APPROVED', 0.00, false, false, NULL),
	('15a84750-6559-46aa-b0a2-6f1920761e68', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'CUST-2026-000010', 'Hamburg Process GmbH', true, false, 'DE', NULL, 'Hamburg', NULL, NULL, NULL, 'EXPORT', 'EUR', 'NET30', NULL, NULL, NULL, '0258e002-4154-48b4-ad1d-2195882841be', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.280544+00', '2026-10-27 14:05:24.319682+00', 2, 'APPROVED', 0.00, false, true, NULL),
	('8adb0ee1-eb89-41e7-871d-e685e2e1ff38', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'CUST-2026-000011', 'Iberia Water S.L.', true, false, 'ES', NULL, 'Madrid', NULL, NULL, NULL, 'EXPORT', 'EUR', 'NET30', NULL, NULL, NULL, '0258e002-4154-48b4-ad1d-2195882841be', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.286441+00', '2026-10-27 14:05:24.323092+00', 2, 'APPROVED', 0.00, false, true, NULL),
	('e3cd7bb2-b68b-477b-9f79-65e38911aa9d', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'CUST-2026-000002', 'Deccan Petrochem Ltd', true, false, 'IN', '27', 'Hyderabad', NULL, NULL, NULL, 'DOMESTIC', 'INR', 'NET30', NULL, NULL, NULL, '0258e002-4154-48b4-ad1d-2195882841be', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.228453+00', '2026-10-27 14:05:24.326876+00', 2, 'APPROVED', 0.00, false, true, NULL),
	('bf611ca6-3960-4d76-99ad-7fb0a30f1349', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'CUST-2026-000003', 'Coastal Power Ltd', true, false, 'IN', '27', 'Visakhapatnam', NULL, NULL, NULL, 'DOMESTIC', 'INR', 'NET30', NULL, NULL, NULL, '0258e002-4154-48b4-ad1d-2195882841be', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.234799+00', '2026-10-27 14:05:24.330199+00', 2, 'APPROVED', 0.00, false, true, NULL),
	('1138c7ca-0fa9-4e2a-96df-6216ec00a6ce', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'CUST-2026-000004', 'Nagpur Steel Works', true, false, 'IN', '27', 'Nagpur', NULL, NULL, NULL, 'DOMESTIC', 'INR', 'NET30', NULL, NULL, NULL, '0258e002-4154-48b4-ad1d-2195882841be', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.241154+00', '2026-10-27 14:05:24.333232+00', 2, 'APPROVED', 0.00, false, true, NULL),
	('4fe2d155-87cd-4e06-b9f7-8bd425bddc4d', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'CUST-2026-000005', 'Metro Utilities', true, false, 'IN', '27', 'Mumbai', NULL, NULL, NULL, 'DOMESTIC', 'INR', 'NET30', NULL, NULL, NULL, '0258e002-4154-48b4-ad1d-2195882841be', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.247774+00', '2026-10-27 14:05:24.336281+00', 2, 'APPROVED', 0.00, false, true, NULL),
	('a1e41cbe-ac6e-4f15-b86c-a9cba5f85a31', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'CUST-2026-000006', 'Vizag Chemicals', true, false, 'IN', '27', 'Vizag', NULL, NULL, NULL, 'DOMESTIC', 'INR', 'NET30', NULL, NULL, NULL, '0258e002-4154-48b4-ad1d-2195882841be', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.254313+00', '2026-10-27 14:05:24.339448+00', 2, 'APPROVED', 0.00, false, true, NULL),
	('380afc7f-f7a6-4475-8687-bdab7cedfad0', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'CUST-2026-000007', 'Kaveri Water Board', true, false, 'IN', '27', 'Mysuru', NULL, NULL, NULL, 'DOMESTIC', 'INR', 'NET30', NULL, NULL, NULL, '0258e002-4154-48b4-ad1d-2195882841be', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.261294+00', '2026-10-27 14:05:24.343091+00', 2, 'APPROVED', 0.00, false, true, NULL),
	('3c5682c9-90ef-4c1a-a319-f763f49889d0', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'CUST-2026-000008', 'Sahara Fertilizers Ltd', true, false, 'IN', '27', 'Kanpur', NULL, NULL, NULL, 'DOMESTIC', 'INR', 'NET30', NULL, NULL, NULL, '0258e002-4154-48b4-ad1d-2195882841be', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.267792+00', '2026-10-27 14:05:24.346427+00', 3, 'APPROVED', 500000.00, true, true, NULL),
	('234b9a3f-6df9-4272-8c0f-7487c2af1990', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'CUST-2026-000012', 'Reliance Marine Services', true, false, 'IN', '27', 'Kochi', NULL, NULL, NULL, 'DOMESTIC', 'INR', 'NET30', NULL, NULL, NULL, '0258e002-4154-48b4-ad1d-2195882841be', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.293392+00', '2026-10-27 14:05:24.349784+00', 2, 'APPROVED', 0.00, false, true, NULL),
	('25da1635-b03a-4c1a-be08-0ad7d91e99e4', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'CUST-2026-000013', 'Tata Process Systems', true, false, 'IN', '27', 'Jamshedpur', NULL, NULL, NULL, 'DOMESTIC', 'INR', 'NET30', NULL, NULL, NULL, '0258e002-4154-48b4-ad1d-2195882841be', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.299674+00', '2026-10-27 14:05:24.353102+00', 2, 'APPROVED', 0.00, false, true, NULL);


--
-- Data for Name: contacts; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.contacts VALUES
	('a0aae722-7210-4f1a-bfb3-e8ea8b737653', '4a0f88e6-467f-406c-a37b-fde4abff9898', '493d756e-cdfe-465c-884b-77f468f1f216', 'Suresh Menon', 'Purchase Manager', NULL, 'suresh@abcindustries.com', '+91 98400 12345', NULL, true, NULL, NULL, '2026-10-27 14:05:21.445587+00', '2026-10-27 14:05:21.445587+00', 1);


--
-- Data for Name: leads; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.leads VALUES
	('6b2a26bc-9e8b-420d-8c63-abc2f3f1a5a5', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'LEAD-2026-000001', 'Deccan Petrochem Ltd', 'Anita Rao', 'anita@deccanpetroc.com', '+91 910000000', NULL, 'Gate valves 80mm', 30.000, NULL, 'WEBSITE', 'QUALIFIED', 'HIGH', 177000.00, '2026-11-10', '0258e002-4154-48b4-ad1d-2195882841be', NULL, NULL, '0258e002-4154-48b4-ad1d-2195882841be', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.361718+00', '2026-10-27 14:05:24.387068+00', 3),
	('29cd3cd5-e05d-41cd-a90e-3d10db43f833', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'LEAD-2026-000002', 'Coastal Power Ltd', 'Vikram Shah', 'vikram@coastalpower.com', '+91 911111111', NULL, 'Ball valves assorted', 50.000, NULL, 'REFERRAL', 'CONTACTED', 'NORMAL', 105000.00, '2026-11-13', '0258e002-4154-48b4-ad1d-2195882841be', NULL, NULL, '0258e002-4154-48b4-ad1d-2195882841be', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.395242+00', '2026-10-27 14:05:24.4063+00', 2),
	('97220804-111c-432c-817f-6995ea0508ea', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'LEAD-2026-000003', 'Nagpur Steel Works', 'Farah Khan', 'farah@nagpursteelw.com', '+91 912222222', NULL, 'Knife gate valves', 12.000, NULL, 'PHONE', 'MEETING', 'NORMAL', 68000.00, '2026-11-16', '0258e002-4154-48b4-ad1d-2195882841be', NULL, NULL, '0258e002-4154-48b4-ad1d-2195882841be', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.417416+00', '2026-10-27 14:05:24.452699+00', 4),
	('9c0b5d27-c5df-4eeb-b77b-816a5ba8c684', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'LEAD-2026-000004', 'Iberia Water S.L.', 'Carlos Ruiz', 'carlos@iberiawaters.com', '+91 913333333', NULL, 'Butterfly valves for water plant', 8.000, NULL, 'WEBSITE', 'QUOTATION', 'HIGH', 240000.00, '2026-11-19', '0258e002-4154-48b4-ad1d-2195882841be', NULL, NULL, '0258e002-4154-48b4-ad1d-2195882841be', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.46274+00', '2026-10-27 14:05:24.507395+00', 4),
	('1d7082ad-817e-47d0-a6dd-f1fb0757c36d', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'LEAD-2026-000005', 'Metro Utilities', 'Ramesh Iyer', 'ramesh@metroutiliti.com', '+91 914444444', NULL, 'Dampers', 5.000, NULL, 'MANUAL', 'LOST', 'LOW', 42000.00, '2026-11-22', '0258e002-4154-48b4-ad1d-2195882841be', NULL, NULL, '0258e002-4154-48b4-ad1d-2195882841be', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.519991+00', '2026-10-27 14:05:24.539055+00', 2),
	('c5ce13c6-6264-4afa-b0de-ee49b5fb3e5f', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'LEAD-2026-000006', 'Kaveri Water Board', 'Lakshmi Gowda', 'lakshmi@kaveriwaterb.com', '+91 915555555', NULL, 'Check valves 50mm', 40.000, NULL, 'WEBSITE', 'QUALIFIED', 'NORMAL', 96000.00, '2026-11-25', '0258e002-4154-48b4-ad1d-2195882841be', NULL, NULL, '0258e002-4154-48b4-ad1d-2195882841be', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.55127+00', '2026-10-27 14:05:24.58663+00', 3),
	('f4452124-f2ce-4ec5-9e66-148677a631a4', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'LEAD-2026-000007', 'Hamburg Process GmbH', 'Jonas Weber', 'jonas@hamburgproce.com', '+91 916666666', NULL, 'Ball valves CF8M 100mm', 20.000, NULL, 'WEBSITE', 'QUOTATION', 'HIGH', 136000.00, '2026-11-28', '0258e002-4154-48b4-ad1d-2195882841be', NULL, NULL, '0258e002-4154-48b4-ad1d-2195882841be', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.599408+00', '2026-10-27 14:05:24.63443+00', 4),
	('00ebac3b-8252-4275-b9a9-6f94e2184918', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'LEAD-2026-000008', 'Tata Process Systems', 'Neha Joshi', 'neha@tataprocesss.com', '+91 917777777', NULL, 'Globe valves', 25.000, NULL, 'REFERRAL', 'MEETING', 'NORMAL', 85000.00, '2026-12-01', '0258e002-4154-48b4-ad1d-2195882841be', NULL, NULL, '0258e002-4154-48b4-ad1d-2195882841be', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.643095+00', '2026-10-27 14:05:24.679138+00', 4),
	('328cf045-2a7e-4a4b-9418-8758969e6a8f', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'LEAD-2026-000009', 'Reliance Marine Services', 'Capt. Dsouza', 'capt@reliancemari.com', '+91 918888888', NULL, 'Marine ball valves', 60.000, NULL, 'TRADE_SHOW', 'CONTACTED', 'HIGH', 290000.00, '2026-12-04', '0258e002-4154-48b4-ad1d-2195882841be', NULL, NULL, '0258e002-4154-48b4-ad1d-2195882841be', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.688476+00', '2026-10-27 14:05:24.702283+00', 2),
	('d00adf8d-ad63-431b-a1a9-5a980ce375ce', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'LEAD-2026-000010', 'Bharat Oilfield Services', 'Gurpreet Singh', 'gurpreet@bharatoilfie.com', '+91 919999999', NULL, 'High-pressure gate valves', 16.000, NULL, 'PHONE', 'QUALIFIED', 'HIGH', 206000.00, '2026-12-07', '0258e002-4154-48b4-ad1d-2195882841be', NULL, NULL, '0258e002-4154-48b4-ad1d-2195882841be', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.712965+00', '2026-10-27 14:05:24.73342+00', 3),
	('bce778f5-fe67-4d47-8c15-a616dfb4060f', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'LEAD-2026-000011', 'Sunrise Pharma', 'Dr. Mehta', 'dr@sunrisepharm.com', '+91 921111110', NULL, 'Sanitary ball valves', 30.000, NULL, 'WEBSITE', 'NEW', 'NORMAL', 120000.00, '2026-12-10', '0258e002-4154-48b4-ad1d-2195882841be', NULL, NULL, '0258e002-4154-48b4-ad1d-2195882841be', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.741915+00', '2026-10-27 14:05:24.741915+00', 1),
	('6441fbd3-7866-425b-b69c-9340501592e1', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'LEAD-2026-000012', 'Eastern Fertilizers', 'Amit Das', 'amit@easternferti.com', '+91 922222221', NULL, 'Butterfly valves 200mm', 10.000, NULL, 'REFERRAL', 'NEW', 'NORMAL', 82000.00, '2026-12-13', '0258e002-4154-48b4-ad1d-2195882841be', NULL, NULL, '0258e002-4154-48b4-ad1d-2195882841be', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.750787+00', '2026-10-27 14:05:24.750787+00', 1),
	('8870458f-25e2-4ed3-bdef-99e2a1ae7f60', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'LEAD-2026-000013', 'Gulf Refining Co.', 'Omar Al Farsi', 'omar@gulfrefining.com', '+91 923333332', NULL, 'Gate valves 150mm', 14.000, NULL, 'WEBSITE', 'NEGOTIATION', 'HIGH', 180000.00, '2026-12-16', '0258e002-4154-48b4-ad1d-2195882841be', NULL, NULL, '0258e002-4154-48b4-ad1d-2195882841be', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.760062+00', '2026-10-27 14:05:24.79714+00', 5),
	('355e1dd8-e5da-4ce5-9109-36fa00b8aa92', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'LEAD-2026-000014', 'Pune Auto Components', 'Sachin Patil', 'sachin@puneautocomp.com', '+91 924444443', NULL, 'Check valves', 20.000, NULL, 'MANUAL', 'LOST', 'LOW', 48000.00, '2026-12-19', '0258e002-4154-48b4-ad1d-2195882841be', NULL, NULL, '0258e002-4154-48b4-ad1d-2195882841be', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.804949+00', '2026-10-27 14:05:24.815354+00', 2),
	('6399bb36-6142-456b-a179-6f02916d8dcf', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'LEAD-2026-000015', 'Hindustan Chemicals', 'Rekha Menon', 'rekha@hindustanche.com', '+91 925555554', NULL, 'Ball valves 25mm', 80.000, NULL, 'WEBSITE', 'CONTACTED', 'NORMAL', 116000.00, '2026-12-22', '0258e002-4154-48b4-ad1d-2195882841be', NULL, NULL, '0258e002-4154-48b4-ad1d-2195882841be', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.822573+00', '2026-10-27 14:05:24.833105+00', 2);


--
-- Data for Name: quotations; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.quotations VALUES
	('acc2a4f1-4770-4991-917e-d6e9f93ccb93', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'QUO-2026-000001', '493d756e-cdfe-465c-884b-77f468f1f216', NULL, NULL, NULL, 1, 'ACCEPTED', 'INR', 1.000000, 'NET30', 'Ex-works, 8–10 weeks', '2026-11-26', 'Hydrotest certificates and MTCs included.', 6840.00, 315.00, 1174.50, 7699.50, '0258e002-4154-48b4-ad1d-2195882841be', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:24.843766+00', '2026-10-27 14:05:24.889812+00', 3),
	('fc114276-1b5f-4018-9a2a-fd523fff4926', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'QUO-2026-000002', 'e3cd7bb2-b68b-477b-9f79-65e38911aa9d', NULL, NULL, NULL, 1, 'ACCEPTED', 'INR', 1.000000, 'NET30', 'Ex-works, 8–10 weeks', '2026-11-26', 'Hydrotest certificates and MTCs included.', 23600.00, 708.00, 4120.56, 27012.56, '0258e002-4154-48b4-ad1d-2195882841be', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:24.928887+00', '2026-10-27 14:05:24.953594+00', 3),
	('44dde98c-02b8-43f3-a22b-f6d914f1df1b', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'QUO-2026-000003', 'bf611ca6-3960-4d76-99ad-7fb0a30f1349', NULL, NULL, NULL, 1, 'ACCEPTED', 'INR', 1.000000, 'NET30', 'Ex-works, 8–10 weeks', '2026-11-26', 'Hydrotest certificates and MTCs included.', 4350.00, 0.00, 783.00, 5133.00, '0258e002-4154-48b4-ad1d-2195882841be', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:24.989372+00', '2026-10-27 14:05:25.01735+00', 3),
	('14ebed78-c91d-4508-9a0e-43af0dfad235', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'QUO-2026-000004', '1138c7ca-0fa9-4e2a-96df-6216ec00a6ce', NULL, NULL, NULL, 1, 'ACCEPTED', 'INR', 1.000000, 'NET30', 'Ex-works, 8–10 weeks', '2026-11-26', 'Hydrotest certificates and MTCs included.', 10200.00, 0.00, 1836.00, 12036.00, '0258e002-4154-48b4-ad1d-2195882841be', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.049625+00', '2026-10-27 14:05:25.072563+00', 3),
	('d8d170b5-2ae9-4b08-9031-ed036c67fb26', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'QUO-2026-000005', '4fe2d155-87cd-4e06-b9f7-8bd425bddc4d', NULL, NULL, NULL, 1, 'ACCEPTED', 'INR', 1.000000, 'NET30', 'Ex-works, 8–10 weeks', '2026-11-26', 'Hydrotest certificates and MTCs included.', 4800.00, 0.00, 864.00, 5664.00, '0258e002-4154-48b4-ad1d-2195882841be', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.102152+00', '2026-10-27 14:05:25.125237+00', 3),
	('eabc6dfb-091b-4a26-8690-736a3a331a0f', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'QUO-2026-000006', 'a1e41cbe-ac6e-4f15-b86c-a9cba5f85a31', NULL, NULL, NULL, 1, 'ACCEPTED', 'INR', 1.000000, 'NET30', 'Ex-works, 8–10 weeks', '2026-11-26', 'Hydrotest certificates and MTCs included.', 13600.00, 0.00, 2448.00, 16048.00, '0258e002-4154-48b4-ad1d-2195882841be', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.153544+00', '2026-10-27 14:05:25.178283+00', 3),
	('023b8d39-f4e0-4672-9c1c-79b54478612e', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'QUO-2026-000007', '380afc7f-f7a6-4475-8687-bdab7cedfad0', NULL, NULL, NULL, 1, 'ACCEPTED', 'INR', 1.000000, 'NET30', 'Ex-works, 8–10 weeks', '2026-11-26', 'Hydrotest certificates and MTCs included.', 51600.00, 2064.00, 8916.48, 58452.48, '0258e002-4154-48b4-ad1d-2195882841be', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.208676+00', '2026-10-27 14:05:25.232856+00', 3),
	('e63491b4-3f5a-4319-a98b-80b04378bc0f', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'QUO-2026-000008', '3c5682c9-90ef-4c1a-a319-f763f49889d0', NULL, NULL, NULL, 1, 'ACCEPTED', 'INR', 1.000000, 'NET30', 'Ex-works, 8–10 weeks', '2026-11-26', 'Hydrotest certificates and MTCs included.', 6200.00, 0.00, 1116.00, 7316.00, '0258e002-4154-48b4-ad1d-2195882841be', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.261354+00', '2026-10-27 14:05:25.286585+00', 3),
	('7668d975-423a-4704-a27d-3fb0c3478491', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'QUO-2026-000009', 'b93cc6d0-2b05-44d6-ab87-2a4b9cf61a3e', NULL, NULL, NULL, 1, 'ACCEPTED', 'INR', 1.000000, 'NET30', 'Ex-works, 8–10 weeks', '2026-11-26', 'Hydrotest certificates and MTCs included.', 16400.00, 0.00, 2952.00, 19352.00, '0258e002-4154-48b4-ad1d-2195882841be', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.315186+00', '2026-10-27 14:05:25.340546+00', 3),
	('f983962b-2117-4356-b2f4-841a61b80e50', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'QUO-2026-000010', '15a84750-6559-46aa-b0a2-6f1920761e68', NULL, NULL, NULL, 1, 'ACCEPTED', 'INR', 1.000000, 'NET30', 'Ex-works, 8–10 weeks', '2026-11-26', 'Hydrotest certificates and MTCs included.', 40800.00, 816.00, 7197.12, 47181.12, '0258e002-4154-48b4-ad1d-2195882841be', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.372984+00', '2026-10-27 14:05:25.397066+00', 3),
	('54b98a5d-b260-477a-9f41-9ac2378f3f54', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'QUO-2026-000011', '8adb0ee1-eb89-41e7-871d-e685e2e1ff38', NULL, NULL, NULL, 1, 'ACCEPTED', 'INR', 1.000000, 'NET30', 'Ex-works, 8–10 weeks', '2026-11-26', 'Hydrotest certificates and MTCs included.', 32800.00, 0.00, 5904.00, 38704.00, '0258e002-4154-48b4-ad1d-2195882841be', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.425011+00', '2026-10-27 14:05:25.448918+00', 3),
	('fc153539-b57b-41dd-a1ca-c3771f81640a', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'QUO-2026-000012', '234b9a3f-6df9-4272-8c0f-7487c2af1990', NULL, NULL, NULL, 1, 'ACCEPTED', 'INR', 1.000000, 'NET30', 'Ex-works, 8–10 weeks', '2026-11-26', 'Hydrotest certificates and MTCs included.', 14500.00, 725.00, 2479.50, 16254.50, '0258e002-4154-48b4-ad1d-2195882841be', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.477025+00', '2026-10-27 14:05:25.499541+00', 3),
	('cb8dc1b9-2f62-4e6c-8067-e22f2579145e', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'QUO-2026-000013', '25da1635-b03a-4c1a-be08-0ad7d91e99e4', NULL, NULL, NULL, 1, 'SENT', 'INR', 1.000000, 'NET30', 'Ex-works, 8–10 weeks', '2026-11-26', 'Hydrotest certificates and MTCs included.', 20400.00, 0.00, 3672.00, 24072.00, '0258e002-4154-48b4-ad1d-2195882841be', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:25.52703+00', '2026-10-27 14:05:25.535353+00', 2),
	('2a5d0fe2-6b3a-4833-b653-5bb1a354d68d', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'QUO-2026-000014', '94b43258-4d8e-48ac-a5b3-04e8607fe937', NULL, NULL, NULL, 1, 'SENT', 'INR', 1.000000, 'NET30', 'Ex-works, 8–10 weeks', '2026-11-26', 'Hydrotest certificates and MTCs included.', 47200.00, 2832.00, 7986.24, 52354.24, '0258e002-4154-48b4-ad1d-2195882841be', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:25.55128+00', '2026-10-27 14:05:25.560227+00', 2),
	('92c97736-af56-473b-89ec-1660fb2174b0', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'QUO-2026-000015', 'e3cd7bb2-b68b-477b-9f79-65e38911aa9d', NULL, NULL, NULL, 1, 'DRAFT', 'INR', 1.000000, 'NET30', 'Ex-works, 8–10 weeks', '2026-11-26', 'Hydrotest certificates and MTCs included.', 28800.00, 0.00, 5184.00, 33984.00, '0258e002-4154-48b4-ad1d-2195882841be', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:25.575529+00', '2026-10-27 14:05:25.575529+00', 1),
	('367f8d37-03ee-4da0-b20a-b953fe2306f4', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'QUO-2026-000016', '493d756e-cdfe-465c-884b-77f468f1f216', NULL, NULL, NULL, 1, 'DRAFT', 'INR', 1.000000, 'NET30', 'Ex-works, 8–10 weeks', '2026-11-26', 'Hydrotest certificates and MTCs included.', 34000.00, 2720.00, 5630.40, 36910.40, '0258e002-4154-48b4-ad1d-2195882841be', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:25.585371+00', '2026-10-27 14:05:25.585371+00', 1);


--
-- Data for Name: sales_orders; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.sales_orders VALUES
	('84f16360-acd8-4658-a08c-5095e56335a6', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SO-2026-000001', '493d756e-cdfe-465c-884b-77f468f1f216', NULL, 'acc2a4f1-4770-4991-917e-d6e9f93ccb93', 'PO-2026-4100', 'READY', 'INR', 1.000000, '2026-11-26', true, 6840.00, 315.00, 1174.50, 7699.50, 'Hydrotest certificates and MTCs included.', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:24.889812+00', '2026-10-27 14:05:28.952358+00', 7),
	('08c81785-76c6-4ce9-9c02-f0d075c9befc', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SO-2026-000003', 'bf611ca6-3960-4d76-99ad-7fb0a30f1349', NULL, '44dde98c-02b8-43f3-a22b-f6d914f1df1b', 'PO-2026-4134', 'CONFIRMED', 'INR', 1.000000, '2026-11-08', true, 4350.00, 0.00, 783.00, 5133.00, 'Hydrotest certificates and MTCs included.', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.01735+00', '2026-10-27 14:05:25.602605+00', 2),
	('d7896924-f01a-474e-afe1-ef33836afd2f', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SO-2026-000006', 'a1e41cbe-ac6e-4f15-b86c-a9cba5f85a31', NULL, 'eabc6dfb-091b-4a26-8690-736a3a331a0f', 'PO-2026-4185', 'CONFIRMED', 'INR', 1.000000, '2026-11-21', true, 13600.00, 0.00, 2448.00, 16048.00, 'Hydrotest certificates and MTCs included.', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.178283+00', '2026-10-27 14:05:25.612594+00', 2),
	('498e3f4d-22ff-4b1e-a1ab-43e37332b591', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SO-2026-000007', '380afc7f-f7a6-4475-8687-bdab7cedfad0', NULL, '023b8d39-f4e0-4672-9c1c-79b54478612e', 'PO-2026-4202', 'CONFIRMED', 'INR', 1.000000, '2026-11-24', true, 51600.00, 2064.00, 8916.48, 58452.48, 'Hydrotest certificates and MTCs included.', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.232856+00', '2026-10-27 14:05:25.615731+00', 2),
	('4e36052e-0a7c-47ae-94dd-8c74ff17ee6e', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SO-2026-000008', '3c5682c9-90ef-4c1a-a319-f763f49889d0', NULL, 'e63491b4-3f5a-4319-a98b-80b04378bc0f', 'PO-2026-4219', 'CONFIRMED', 'INR', 1.000000, '2026-11-02', true, 6200.00, 0.00, 1116.00, 7316.00, 'Hydrotest certificates and MTCs included.', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.286585+00', '2026-10-27 14:05:25.618734+00', 2),
	('c8daa3b5-bd9e-41fe-83ca-f53a2138d16d', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SO-2026-000009', 'b93cc6d0-2b05-44d6-ab87-2a4b9cf61a3e', NULL, '7668d975-423a-4704-a27d-3fb0c3478491', 'PO-2026-4236', 'CONFIRMED', 'INR', 1.000000, '2026-11-14', true, 16400.00, 0.00, 2952.00, 19352.00, 'Hydrotest certificates and MTCs included.', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.340546+00', '2026-10-27 14:05:25.621709+00', 2),
	('23f877c9-0add-44dc-b617-5e7e48c1e841', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SO-2026-000011', '8adb0ee1-eb89-41e7-871d-e685e2e1ff38', NULL, '54b98a5d-b260-477a-9f41-9ac2378f3f54', 'PO-2026-4270', 'CONFIRMED', 'INR', 1.000000, '2026-12-06', true, 32800.00, 0.00, 5904.00, 38704.00, 'Hydrotest certificates and MTCs included.', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.448918+00', '2026-10-27 14:05:25.628441+00', 2),
	('afc38366-3c26-4a27-a1cc-e811550d9b5c', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SO-2026-000012', '234b9a3f-6df9-4272-8c0f-7487c2af1990', NULL, 'fc153539-b57b-41dd-a1ca-c3771f81640a', 'PO-2026-4287', 'CONFIRMED', 'INR', 1.000000, '2026-12-11', true, 14500.00, 725.00, 2479.50, 16254.50, 'Hydrotest certificates and MTCs included.', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.499541+00', '2026-10-27 14:05:25.631447+00', 2),
	('0bbed72f-1aff-49df-867f-4201b53b165f', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SO-2026-000002', 'e3cd7bb2-b68b-477b-9f79-65e38911aa9d', NULL, 'fc114276-1b5f-4018-9a2a-fd523fff4926', 'PO-2026-4117', 'CONFIRMED', 'INR', 1.000000, '2026-11-17', true, 23600.00, 708.00, 4120.56, 27012.56, 'Hydrotest certificates and MTCs included.', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:24.953594+00', '2026-10-27 14:05:26.389914+00', 3),
	('bc2c7461-b1cd-4c66-8996-611e28098035', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SO-2026-000005', '4fe2d155-87cd-4e06-b9f7-8bd425bddc4d', NULL, 'd8d170b5-2ae9-4b08-9031-ed036c67fb26', 'PO-2026-4168', 'PROCUREMENT', 'INR', 1.000000, '2026-11-04', true, 4800.00, 0.00, 864.00, 5664.00, 'Hydrotest certificates and MTCs included.', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.125237+00', '2026-10-27 14:05:29.05917+00', 5),
	('5150e791-ad57-45a1-9173-962ee330f78f', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SO-2026-000004', '1138c7ca-0fa9-4e2a-96df-6216ec00a6ce', NULL, '14ebed78-c91d-4508-9a0e-43af0dfad235', 'PO-2026-4151', 'CONFIRMED', 'INR', 1.000000, '2026-11-10', true, 10200.00, 0.00, 1836.00, 12036.00, 'Hydrotest certificates and MTCs included.', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.072563+00', '2026-10-27 14:05:29.293755+00', 3),
	('17faff62-40d5-4b82-a2bb-e6c64e3162be', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SO-2026-000010', '15a84750-6559-46aa-b0a2-6f1920761e68', NULL, 'f983962b-2117-4356-b2f4-841a61b80e50', 'PO-2026-4253', 'CONFIRMED', 'INR', 1.000000, '2026-11-24', true, 40800.00, 816.00, 7197.12, 47181.12, 'Hydrotest certificates and MTCs included.', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.397066+00', '2026-10-27 14:05:29.30502+00', 3);


--
-- Data for Name: work_orders; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.work_orders VALUES
	('8ebcb809-6629-4f68-add0-926ef84e4337', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'WO-2026-000007', '4e36052e-0a7c-47ae-94dd-8c74ff17ee6e', 'd61fe768-7f6e-4d65-b1f1-6f5621e2008b', 2.000, 0.000, 0.000, 'PLANNED', NULL, '2026-10-27', '2026-10-27', 1870.00, 11700.00, 408.00, 272.00, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:26.482911+00', '2026-10-27 14:05:26.482911+00', 1),
	('076f8a96-8f7a-4b69-a2db-b257e115f802', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'WO-2026-000009', '498e3f4d-22ff-4b1e-a1ab-43e37332b591', '9152c8e7-6ed4-495d-a58c-ee509367659f', 4.000, 0.000, 0.000, 'PLANNED', NULL, '2026-10-27', '2026-11-18', 16720.00, 23400.00, 3648.00, 2432.00, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:26.505056+00', '2026-10-27 14:05:26.505056+00', 1),
	('17d9f431-383d-4e86-9ba9-5c2e555fd89e', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'WO-2026-000010', '17faff62-40d5-4b82-a2bb-e6c64e3162be', '6f56aa1e-de31-44a5-b842-756c12aa7646', 6.000, 0.000, 0.000, 'IN_PROGRESS', NULL, '2026-10-27', '2026-11-25', 12870.00, 35100.00, 2808.00, 1872.00, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:26.517136+00', '2026-10-27 14:05:26.83555+00', 3),
	('e215079d-260a-4bf0-9aa5-bf2a931bc28c', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'WO-2026-000011', '23f877c9-0add-44dc-b617-5e7e48c1e841', '65e1cab5-04f9-4e45-9081-e07e65803ba9', 4.000, 0.000, 0.000, 'IN_PROGRESS', NULL, '2026-10-27', '2026-11-30', 10560.00, 23400.00, 2304.00, 1536.00, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:26.529404+00', '2026-10-27 14:05:26.865721+00', 3),
	('ed7ae99b-3958-4efa-922f-7bf0e92beaf7', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'WO-2026-000012', 'afc38366-3c26-4a27-a1cc-e811550d9b5c', '82048a24-aa7e-422f-bee0-1642d75bd996', 10.000, 0.000, 0.000, 'IN_PROGRESS', NULL, '2026-10-27', '2026-12-05', 4510.00, 58500.00, 984.00, 656.00, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:26.5407+00', '2026-10-27 14:05:26.895078+00', 3),
	('7aadadef-4d0a-4ddb-9052-9fa3df733888', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'WO-2026-000013', NULL, '6e212887-960b-4eed-ade6-18715e05c5cb', 8.000, 0.000, 0.000, 'IN_PROGRESS', NULL, '2026-10-27', '2026-12-06', 5280.00, 46800.00, 1152.00, 768.00, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:26.55233+00', '2026-10-27 14:05:26.923211+00', 3),
	('c87a5b27-1f37-4ba1-98cc-a7c64214737b', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'WO-2026-000014', NULL, 'eb07eab2-eba7-4b97-88f8-9066662e9a5e', 5.000, 0.000, 0.000, 'IN_PROGRESS', NULL, '2026-10-27', '2026-12-06', 9350.00, 29250.00, 2040.00, 1360.00, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:26.564895+00', '2026-10-27 14:05:26.95006+00', 3),
	('6e4d3be3-969c-4555-9e96-ca9f6b65a201', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'WO-2026-000015', NULL, '92a93794-1287-4b7d-8868-7b9b81b87cb2', 6.000, 0.000, 0.000, 'IN_PROGRESS', NULL, '2026-10-27', '2026-12-06', 4455.00, 35100.00, 972.00, 648.00, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:26.576346+00', '2026-10-27 14:05:26.975924+00', 3),
	('71cb5f2d-7cf9-4623-a70b-7baeb9c1b66c', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'WO-2026-000001', '84f16360-acd8-4658-a08c-5095e56335a6', '6e212887-960b-4eed-ade6-18715e05c5cb', 3.000, 3.000, 0.000, 'COMPLETED', NULL, '2026-10-27', '2026-11-20', 1980.00, 17550.00, 432.00, 288.00, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:26.411385+00', '2026-10-27 14:05:27.317863+00', 4),
	('6f1dd7e0-32bb-4c8a-a0d9-25e051a1a9b1', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'WO-2026-000002', '0bbed72f-1aff-49df-867f-4201b53b165f', 'eb07eab2-eba7-4b97-88f8-9066662e9a5e', 4.000, 4.000, 0.000, 'COMPLETED', NULL, '2026-10-27', '2026-11-11', 7480.00, 23400.00, 1632.00, 1088.00, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:26.425776+00', '2026-10-27 14:05:27.338065+00', 4),
	('a96efb75-c93f-4af2-b48a-4962753900cd', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'WO-2026-000003', '08c81785-76c6-4ce9-9c02-f0d075c9befc', '82048a24-aa7e-422f-bee0-1642d75bd996', 3.000, 2.000, 1.000, 'COMPLETED', NULL, '2026-10-27', '2026-11-02', 1353.00, 17550.00, 295.20, 196.80, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:26.436712+00', '2026-10-27 14:05:27.354316+00', 5),
	('d996f72b-9fab-4c89-878a-34c63fe6f3ea', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'WO-2026-000004', '5150e791-ad57-45a1-9173-962ee330f78f', '77a428fe-4dd9-4a6e-8138-36a5f4efc6b2', 3.000, 3.000, 0.000, 'COMPLETED', NULL, '2026-10-27', '2026-10-30', 3135.00, 17550.00, 684.00, 456.00, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:26.44851+00', '2026-10-27 14:05:27.369989+00', 4),
	('aed5986d-07e3-4fc5-9aae-74d6c3de22ff', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'WO-2026-000005', 'bc2c7461-b1cd-4c66-8996-611e28098035', '92a93794-1287-4b7d-8868-7b9b81b87cb2', 2.000, 2.000, 0.000, 'COMPLETED', NULL, '2026-10-27', '2026-10-29', 1485.00, 11700.00, 324.00, 216.00, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:26.459497+00', '2026-10-27 14:05:27.386036+00', 4),
	('56925ee4-f597-4196-b51e-59ca9740cc60', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'WO-2026-000006', 'd7896924-f01a-474e-afe1-ef33836afd2f', '6f56aa1e-de31-44a5-b842-756c12aa7646', 2.000, 2.000, 0.000, 'COMPLETED', NULL, '2026-10-27', '2026-11-15', 4290.00, 11700.00, 936.00, 624.00, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:26.470566+00', '2026-10-27 14:05:27.403324+00', 4),
	('b4d2e412-f532-4bd4-8101-e08fd008857d', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'WO-2026-000008', 'c8daa3b5-bd9e-41fe-83ca-f53a2138d16d', '65e1cab5-04f9-4e45-9081-e07e65803ba9', 2.000, 2.000, 0.000, 'COMPLETED', NULL, '2026-10-27', '2026-11-08', 5280.00, 11700.00, 1152.00, 768.00, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:26.494267+00', '2026-10-27 14:05:27.434262+00', 4);


--
-- Data for Name: cost_entries; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.cost_entries VALUES
	('0bbdbb93-c955-42a4-bc47-cc68afaf36cc', '4a0f88e6-467f-406c-a37b-fde4abff9898', '71cb5f2d-7cf9-4623-a70b-7baeb9c1b66c', 'MATERIAL', 1860.00, 'Valve body casting CF8M lot BD-H26110 × 3', '2026-10-27 14:05:26.602547+00'),
	('470f1f3e-45d3-492c-b286-7786862c39e9', '4a0f88e6-467f-406c-a37b-fde4abff9898', '71cb5f2d-7cf9-4623-a70b-7baeb9c1b66c', 'MATERIAL', 660.00, 'Valve Stem SS316 lot ST-H26110 × 3', '2026-10-27 14:05:26.616645+00'),
	('09c24cf9-8ae1-4c4c-9da1-6c641e56c51a', '4a0f88e6-467f-406c-a37b-fde4abff9898', '6f1dd7e0-32bb-4c8a-a0d9-25e051a1a9b1', 'MATERIAL', 2480.00, 'Valve body casting CF8M lot BD-H26117 × 4', '2026-10-27 14:05:26.641006+00'),
	('6b19775d-bf36-4aa5-a070-c48eaf0daf05', '4a0f88e6-467f-406c-a37b-fde4abff9898', '6f1dd7e0-32bb-4c8a-a0d9-25e051a1a9b1', 'MATERIAL', 880.00, 'Valve Stem SS316 lot ST-H26117 × 4', '2026-10-27 14:05:26.653087+00'),
	('b01f3d49-ace2-433e-84f2-8fe4f769be68', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'a96efb75-c93f-4af2-b48a-4962753900cd', 'MATERIAL', 1860.00, 'Valve body casting CF8M lot BD-H26124 × 3', '2026-10-27 14:05:26.677734+00'),
	('2b1033cc-1225-4f86-9716-942c71c35999', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'a96efb75-c93f-4af2-b48a-4962753900cd', 'MATERIAL', 660.00, 'Valve Stem SS316 lot ST-H26124 × 3', '2026-10-27 14:05:26.687537+00'),
	('4ae90156-dde8-4a50-9c1d-95fcd33a20a5', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'd996f72b-9fab-4c89-878a-34c63fe6f3ea', 'MATERIAL', 1860.00, 'Valve body casting CF8M lot BD-H26131 × 3', '2026-10-27 14:05:26.710697+00'),
	('a51d84e7-0639-48a0-afb0-974c32714917', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'd996f72b-9fab-4c89-878a-34c63fe6f3ea', 'MATERIAL', 660.00, 'Valve Stem SS316 lot ST-H26131 × 3', '2026-10-27 14:05:26.720027+00'),
	('aff71561-e399-4d2b-8575-c5f836ee067c', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'aed5986d-07e3-4fc5-9aae-74d6c3de22ff', 'MATERIAL', 1240.00, 'Valve body casting CF8M lot BD-H26110 × 2', '2026-10-27 14:05:26.739791+00'),
	('d2cf4f0b-a76c-465a-a393-4a40336cd05c', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'aed5986d-07e3-4fc5-9aae-74d6c3de22ff', 'MATERIAL', 440.00, 'Valve Stem SS316 lot ST-H26110 × 2', '2026-10-27 14:05:26.749376+00'),
	('8b5d820e-3af9-4e9f-a5fd-ba4eafb7eac0', '4a0f88e6-467f-406c-a37b-fde4abff9898', '56925ee4-f597-4196-b51e-59ca9740cc60', 'MATERIAL', 1240.00, 'Valve body casting CF8M lot BD-H26117 × 2', '2026-10-27 14:05:26.768954+00'),
	('43420949-a6a6-4fc0-97e4-8a111b3f88b4', '4a0f88e6-467f-406c-a37b-fde4abff9898', '56925ee4-f597-4196-b51e-59ca9740cc60', 'MATERIAL', 440.00, 'Valve Stem SS316 lot ST-H26117 × 2', '2026-10-27 14:05:26.778034+00'),
	('89bdfdf7-214d-4ccd-b952-54ca2c5d7a24', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'b4d2e412-f532-4bd4-8101-e08fd008857d', 'MATERIAL', 1240.00, 'Valve body casting CF8M lot BD-H26131 × 2', '2026-10-27 14:05:26.802374+00'),
	('9005a9bb-c5d3-426e-a2dd-541660c7384c', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'b4d2e412-f532-4bd4-8101-e08fd008857d', 'MATERIAL', 440.00, 'Valve Stem SS316 lot ST-H26131 × 2', '2026-10-27 14:05:26.811276+00'),
	('19fccb93-1b26-4713-8665-4ccb5919cf00', '4a0f88e6-467f-406c-a37b-fde4abff9898', '17d9f431-383d-4e86-9ba9-5c2e555fd89e', 'MATERIAL', 3720.00, 'Valve body casting CF8M lot BD-H26117 × 6', '2026-10-27 14:05:26.83555+00'),
	('2cb71251-5884-4ccd-a1d7-425a99c39653', '4a0f88e6-467f-406c-a37b-fde4abff9898', '17d9f431-383d-4e86-9ba9-5c2e555fd89e', 'MATERIAL', 1320.00, 'Valve Stem SS316 lot ST-H26117 × 6', '2026-10-27 14:05:26.845001+00'),
	('181e1fae-55c2-4392-b6cb-a1af3205c608', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'e215079d-260a-4bf0-9aa5-bf2a931bc28c', 'MATERIAL', 2480.00, 'Valve body casting CF8M lot BD-H26124 × 4', '2026-10-27 14:05:26.865721+00'),
	('d31df8f4-d943-4e85-ae65-cb36a2237a26', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'e215079d-260a-4bf0-9aa5-bf2a931bc28c', 'MATERIAL', 880.00, 'Valve Stem SS316 lot ST-H26124 × 4', '2026-10-27 14:05:26.874918+00'),
	('aa3a4b28-0ea9-4999-bcb8-b55e0a59809b', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'ed7ae99b-3958-4efa-922f-7bf0e92beaf7', 'MATERIAL', 6200.00, 'Valve body casting CF8M lot BD-H26131 × 10', '2026-10-27 14:05:26.895078+00'),
	('8ccb2cd9-54fa-4992-b501-f45b225c1cb2', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'ed7ae99b-3958-4efa-922f-7bf0e92beaf7', 'MATERIAL', 2200.00, 'Valve Stem SS316 lot ST-H26131 × 10', '2026-10-27 14:05:26.904587+00'),
	('6209a140-2473-4046-8e1b-dc203901f5a3', '4a0f88e6-467f-406c-a37b-fde4abff9898', '7aadadef-4d0a-4ddb-9052-9fa3df733888', 'MATERIAL', 4960.00, 'Valve body casting CF8M lot BD-H26110 × 8', '2026-10-27 14:05:26.923211+00'),
	('b26472ea-8cc3-48cd-96bb-2d69c5a578bf', '4a0f88e6-467f-406c-a37b-fde4abff9898', '7aadadef-4d0a-4ddb-9052-9fa3df733888', 'MATERIAL', 1760.00, 'Valve Stem SS316 lot ST-H26110 × 8', '2026-10-27 14:05:26.933127+00'),
	('dc3bb8aa-b676-40be-8614-224f72ff3181', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'c87a5b27-1f37-4ba1-98cc-a7c64214737b', 'MATERIAL', 3100.00, 'Valve body casting CF8M lot BD-H26117 × 5', '2026-10-27 14:05:26.95006+00'),
	('1315a25a-c590-4c74-9ad9-ae2ca518bd5b', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'c87a5b27-1f37-4ba1-98cc-a7c64214737b', 'MATERIAL', 1100.00, 'Valve Stem SS316 lot ST-H26117 × 5', '2026-10-27 14:05:26.958748+00'),
	('5f2a6645-2975-4759-8c51-5e1b9d330620', '4a0f88e6-467f-406c-a37b-fde4abff9898', '6e4d3be3-969c-4555-9e96-ca9f6b65a201', 'MATERIAL', 3720.00, 'Valve body casting CF8M lot BD-H26124 × 6', '2026-10-27 14:05:26.975924+00'),
	('4fe19a53-a756-479d-a57e-c8be8756c363', '4a0f88e6-467f-406c-a37b-fde4abff9898', '6e4d3be3-969c-4555-9e96-ca9f6b65a201', 'MATERIAL', 1320.00, 'Valve Stem SS316 lot ST-H26124 × 6', '2026-10-27 14:05:26.984644+00'),
	('04d747ca-82dc-4522-8f17-c4d9f98dad4c', '4a0f88e6-467f-406c-a37b-fde4abff9898', '71cb5f2d-7cf9-4623-a70b-7baeb9c1b66c', 'LABOR', 2700.00, 'Material cut & forge/casting prep — 6h', '2026-10-27 14:05:26.995598+00'),
	('ac5ce689-1401-40d0-95f0-0b7ae609a995', '4a0f88e6-467f-406c-a37b-fde4abff9898', '71cb5f2d-7cf9-4623-a70b-7baeb9c1b66c', 'LABOR', 8100.00, 'CNC machining (body, bonnet, stem) — 18h', '2026-10-27 14:05:27.00442+00'),
	('4d4808e0-52a5-41d7-9b9d-79fb3d304cbd', '4a0f88e6-467f-406c-a37b-fde4abff9898', '71cb5f2d-7cf9-4623-a70b-7baeb9c1b66c', 'LABOR', 2700.00, 'Seat lapping & deburr — 6h', '2026-10-27 14:05:27.013682+00'),
	('f06829db-3175-4585-a500-d0b8c6ec37d8', '4a0f88e6-467f-406c-a37b-fde4abff9898', '71cb5f2d-7cf9-4623-a70b-7baeb9c1b66c', 'LABOR', 4050.00, 'Assembly — 9h', '2026-10-27 14:05:27.021486+00'),
	('7e7d1742-ade3-4cb1-a7f1-93ff1864d1d4', '4a0f88e6-467f-406c-a37b-fde4abff9898', '6f1dd7e0-32bb-4c8a-a0d9-25e051a1a9b1', 'LABOR', 3888.00, 'Material cut & forge/casting prep — 8.64h', '2026-10-27 14:05:27.032042+00'),
	('4360eb24-4b7c-484b-9bb3-4132fa54b77b', '4a0f88e6-467f-406c-a37b-fde4abff9898', '6f1dd7e0-32bb-4c8a-a0d9-25e051a1a9b1', 'LABOR', 11664.00, 'CNC machining (body, bonnet, stem) — 25.92h', '2026-10-27 14:05:27.039556+00'),
	('3ae8d488-d942-475e-9b4c-88d69105c5bf', '4a0f88e6-467f-406c-a37b-fde4abff9898', '6f1dd7e0-32bb-4c8a-a0d9-25e051a1a9b1', 'LABOR', 3888.00, 'Seat lapping & deburr — 8.64h', '2026-10-27 14:05:27.048437+00'),
	('932c4ae9-d6a8-42c7-9b1b-b46561468ec6', '4a0f88e6-467f-406c-a37b-fde4abff9898', '6f1dd7e0-32bb-4c8a-a0d9-25e051a1a9b1', 'LABOR', 5832.00, 'Assembly — 12.96h', '2026-10-27 14:05:27.05602+00'),
	('0c7021a4-bb0c-43c9-9601-2bc42d131691', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'a96efb75-c93f-4af2-b48a-4962753900cd', 'LABOR', 3132.00, 'Material cut & forge/casting prep — 6.959999999999999h', '2026-10-27 14:05:27.067086+00'),
	('c9c33086-acf2-4b1e-8723-638c3f9f3eab', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'a96efb75-c93f-4af2-b48a-4962753900cd', 'LABOR', 9396.00, 'CNC machining (body, bonnet, stem) — 20.88h', '2026-10-27 14:05:27.077006+00'),
	('4526cd24-dee4-494f-aced-042ec47b9bbd', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'a96efb75-c93f-4af2-b48a-4962753900cd', 'SCRAP', 328.00, 'Scrap at CNC machining (body, bonnet, stem) × 1', '2026-10-27 14:05:27.077006+00'),
	('6acc40c1-40cd-4b8f-b0f3-1cb90634075a', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'a96efb75-c93f-4af2-b48a-4962753900cd', 'LABOR', 3132.00, 'Seat lapping & deburr — 6.959999999999999h', '2026-10-27 14:05:27.088509+00'),
	('97f43906-24d9-488f-813e-8d3b63c9ba80', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'a96efb75-c93f-4af2-b48a-4962753900cd', 'LABOR', 4698.00, 'Assembly — 10.44h', '2026-10-27 14:05:27.097576+00'),
	('7f7c1269-52f5-4107-a815-a42b26584e54', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'd996f72b-9fab-4c89-878a-34c63fe6f3ea', 'LABOR', 2700.00, 'Material cut & forge/casting prep — 6h', '2026-10-27 14:05:27.109367+00'),
	('16130a01-48ec-4137-977b-c7aaf919d3fd', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'd996f72b-9fab-4c89-878a-34c63fe6f3ea', 'LABOR', 8100.00, 'CNC machining (body, bonnet, stem) — 18h', '2026-10-27 14:05:27.117824+00'),
	('4c9f6ae0-7a11-4736-9edd-a61cf368e01c', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'd996f72b-9fab-4c89-878a-34c63fe6f3ea', 'LABOR', 2700.00, 'Seat lapping & deburr — 6h', '2026-10-27 14:05:27.126016+00'),
	('83b402f5-5586-40ff-acb0-f6029e7641e1', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'd996f72b-9fab-4c89-878a-34c63fe6f3ea', 'LABOR', 4050.00, 'Assembly — 9h', '2026-10-27 14:05:27.133717+00'),
	('7a47421f-fd32-48be-a8fe-d3f1eb62c111', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'aed5986d-07e3-4fc5-9aae-74d6c3de22ff', 'LABOR', 1944.00, 'Material cut & forge/casting prep — 4.32h', '2026-10-27 14:05:27.143891+00'),
	('7967a92c-aee2-446a-b0ed-ff74866d0a25', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'aed5986d-07e3-4fc5-9aae-74d6c3de22ff', 'LABOR', 5832.00, 'CNC machining (body, bonnet, stem) — 12.96h', '2026-10-27 14:05:27.151668+00'),
	('7125624b-488f-4eb5-8353-ae38a698c2eb', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'aed5986d-07e3-4fc5-9aae-74d6c3de22ff', 'LABOR', 1944.00, 'Seat lapping & deburr — 4.32h', '2026-10-27 14:05:27.15995+00'),
	('bde85d0f-b6da-4fcf-bb16-944fbf19fe74', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'aed5986d-07e3-4fc5-9aae-74d6c3de22ff', 'LABOR', 2916.00, 'Assembly — 6.48h', '2026-10-27 14:05:27.16789+00'),
	('8dcf095e-bcf0-42e2-8ea5-687a5f38c68f', '4a0f88e6-467f-406c-a37b-fde4abff9898', '56925ee4-f597-4196-b51e-59ca9740cc60', 'LABOR', 2088.00, 'Material cut & forge/casting prep — 4.64h', '2026-10-27 14:05:27.177764+00'),
	('8fe33992-e483-44e9-b987-77bf699e2ce6', '4a0f88e6-467f-406c-a37b-fde4abff9898', '56925ee4-f597-4196-b51e-59ca9740cc60', 'LABOR', 6264.00, 'CNC machining (body, bonnet, stem) — 13.919999999999998h', '2026-10-27 14:05:27.185548+00'),
	('aa4c68c6-5f0e-4326-ba76-08d1eb123a24', '4a0f88e6-467f-406c-a37b-fde4abff9898', '56925ee4-f597-4196-b51e-59ca9740cc60', 'LABOR', 2088.00, 'Seat lapping & deburr — 4.64h', '2026-10-27 14:05:27.194968+00');
INSERT INTO public.cost_entries VALUES
	('8f87fc12-0a05-4d87-b0aa-4843f7aae44d', '4a0f88e6-467f-406c-a37b-fde4abff9898', '56925ee4-f597-4196-b51e-59ca9740cc60', 'LABOR', 3132.00, 'Assembly — 6.959999999999999h', '2026-10-27 14:05:27.202868+00'),
	('10a96ad7-c8aa-4421-817b-79145b12efa0', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'b4d2e412-f532-4bd4-8101-e08fd008857d', 'LABOR', 1944.00, 'Material cut & forge/casting prep — 4.32h', '2026-10-27 14:05:27.214925+00'),
	('b5aa0887-fa33-4221-bc54-73066aaff2b7', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'b4d2e412-f532-4bd4-8101-e08fd008857d', 'LABOR', 5832.00, 'CNC machining (body, bonnet, stem) — 12.96h', '2026-10-27 14:05:27.222436+00'),
	('698268fa-c2a5-4fa3-885b-fcdbdab0eba3', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'b4d2e412-f532-4bd4-8101-e08fd008857d', 'LABOR', 1944.00, 'Seat lapping & deburr — 4.32h', '2026-10-27 14:05:27.23134+00'),
	('4402c720-5736-4aaf-958d-ffcc6a9d2660', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'b4d2e412-f532-4bd4-8101-e08fd008857d', 'LABOR', 2916.00, 'Assembly — 6.48h', '2026-10-27 14:05:27.238937+00'),
	('a82b9a74-cb85-4390-9685-77ae5ea6bfdb', '4a0f88e6-467f-406c-a37b-fde4abff9898', '17d9f431-383d-4e86-9ba9-5c2e555fd89e', 'LABOR', 5400.00, 'Material cut & forge/casting prep — 12h', '2026-10-27 14:05:27.251299+00'),
	('2f00d8bf-812a-4730-b3c9-deae703596bb', '4a0f88e6-467f-406c-a37b-fde4abff9898', '17d9f431-383d-4e86-9ba9-5c2e555fd89e', 'LABOR', 16200.00, 'CNC machining (body, bonnet, stem) — 36h', '2026-10-27 14:05:27.259234+00'),
	('ce1edd8b-49f6-44dd-9032-f26092c0ffa2', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'e215079d-260a-4bf0-9aa5-bf2a931bc28c', 'LABOR', 3888.00, 'Material cut & forge/casting prep — 8.64h', '2026-10-27 14:05:27.26888+00'),
	('6766b58a-10eb-4706-b7ed-47628f5d77cb', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'e215079d-260a-4bf0-9aa5-bf2a931bc28c', 'LABOR', 11664.00, 'CNC machining (body, bonnet, stem) — 25.92h', '2026-10-27 14:05:27.27671+00'),
	('6f2560d8-b1bb-42b3-99cf-f0effe5097c9', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'ed7ae99b-3958-4efa-922f-7bf0e92beaf7', 'LABOR', 10440.00, 'Material cut & forge/casting prep — 23.2h', '2026-10-27 14:05:27.286537+00'),
	('a9cf988c-2be2-4dab-a219-983cd56b5b2d', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'ed7ae99b-3958-4efa-922f-7bf0e92beaf7', 'LABOR', 31320.00, 'CNC machining (body, bonnet, stem) — 69.6h', '2026-10-27 14:05:27.295248+00'),
	('ae29aa18-2dfc-4988-b92d-6e3412a6de7a', '4a0f88e6-467f-406c-a37b-fde4abff9898', '71cb5f2d-7cf9-4623-a70b-7baeb9c1b66c', 'SUBCONTRACT', 4500.00, 'SC-2026-000001 Heat treatment', '2026-10-27 14:05:27.317863+00'),
	('75fa07cb-6484-4112-9827-8f840427be0c', '4a0f88e6-467f-406c-a37b-fde4abff9898', '6f1dd7e0-32bb-4c8a-a0d9-25e051a1a9b1', 'SUBCONTRACT', 6000.00, 'SC-2026-000002 Heat treatment', '2026-10-27 14:05:27.338065+00'),
	('c050648a-5f43-4ee2-ada4-9445beafdcb5', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'a96efb75-c93f-4af2-b48a-4962753900cd', 'SUBCONTRACT', 7800.00, 'SC-2026-000003 Stellite hard-facing', '2026-10-27 14:05:27.354316+00'),
	('13f210e3-9b42-4fd4-8183-1e8407875730', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'd996f72b-9fab-4c89-878a-34c63fe6f3ea', 'SUBCONTRACT', 4500.00, 'SC-2026-000004 Heat treatment', '2026-10-27 14:05:27.369989+00'),
	('4f0d8bb6-1bb4-4e45-92b9-f6c9306b3437', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'aed5986d-07e3-4fc5-9aae-74d6c3de22ff', 'SUBCONTRACT', 3200.00, 'SC-2026-000005 Plating', '2026-10-27 14:05:27.386036+00'),
	('d5586257-c381-4de9-8010-91f8c3c90923', '4a0f88e6-467f-406c-a37b-fde4abff9898', '56925ee4-f597-4196-b51e-59ca9740cc60', 'SUBCONTRACT', 3000.00, 'SC-2026-000006 Heat treatment', '2026-10-27 14:05:27.403324+00'),
	('1987bfdf-78a4-4e68-b049-ae21a2f7a8fa', '4a0f88e6-467f-406c-a37b-fde4abff9898', '8ebcb809-6629-4f68-add0-926ef84e4337', 'SUBCONTRACT', 3900.00, 'SC-2026-000007 Hard-facing', '2026-10-27 14:05:27.419416+00'),
	('003993d6-565a-4192-a15e-74a7bf976f1e', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'b4d2e412-f532-4bd4-8101-e08fd008857d', 'SUBCONTRACT', 3000.00, 'SC-2026-000008 Heat treatment', '2026-10-27 14:05:27.434262+00');


--
-- Data for Name: drawings; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.drawings VALUES
	('b0136396-fcf8-4945-8445-6dae8f2b11ef', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'DRW-2026-000001', '82048a24-aa7e-422f-bee0-1642d75bd996', NULL, 'GA drawing — PV-BV-025', 'RELEASED', 1, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:23.63613+00', '2026-10-27 14:05:23.673067+00', 4),
	('f63b6b4f-d129-4a20-a4b7-9b2f7c8e0dee', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'DRW-2026-000002', '6e212887-960b-4eed-ade6-18715e05c5cb', NULL, 'GA drawing — PV-BV-050', 'RELEASED', 1, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:23.6835+00', '2026-10-27 14:05:23.713698+00', 4),
	('10a944da-25c6-44cd-91ef-d47c6b9e6864', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'DRW-2026-000003', '6f56aa1e-de31-44a5-b842-756c12aa7646', NULL, 'GA drawing — PV-BV-100', 'RELEASED', 1, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:23.722295+00', '2026-10-27 14:05:23.751662+00', 4),
	('fec6b539-a669-4d0f-b164-b2ffdfd25166', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'DRW-2026-000004', 'd61fe768-7f6e-4d65-b1f1-6f5621e2008b', NULL, 'GA drawing — PV-GV-050', 'RELEASED', 1, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:23.761707+00', '2026-10-27 14:05:23.791731+00', 4),
	('e6939dc8-15bb-4a22-a933-cd6405398fd2', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'DRW-2026-000005', 'eb07eab2-eba7-4b97-88f8-9066662e9a5e', NULL, 'GA drawing — PV-GV-080', 'RELEASED', 1, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:23.800733+00', '2026-10-27 14:05:23.830267+00', 4),
	('639d20b4-bf47-4805-ad8e-96e6a90e1ccd', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'DRW-2026-000007', '77a428fe-4dd9-4a6e-8138-36a5f4efc6b2', NULL, 'GA drawing — PV-GLV-050', 'RELEASED', 1, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:23.880091+00', '2026-10-27 14:05:23.911936+00', 4),
	('88e3f2dd-70ac-4ce7-829d-259afacab83f', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'DRW-2026-000008', '65e1cab5-04f9-4e45-9081-e07e65803ba9', NULL, 'GA drawing — PV-BFV-200', 'RELEASED', 1, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:23.920872+00', '2026-10-27 14:05:23.951786+00', 4),
	('eb5b314f-9980-45ae-a923-da2778ed2170', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'DRW-2026-000009', '9152c8e7-6ed4-495d-a58c-ee509367659f', NULL, 'GA drawing — PV-GV-150 (under review)', 'REVIEW', 1, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:23.961024+00', '2026-10-27 14:05:23.970266+00', 2),
	('060e77a1-8d88-4eef-a393-1de10264d450', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'DRW-2026-000006', '92a93794-1287-4b7d-8868-7b9b81b87cb2', NULL, 'GA drawing — PV-CV-050', 'REVIEW', 2, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:23.83903+00', '2026-10-27 14:05:29.248813+00', 5);


--
-- Data for Name: files; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: drawing_revisions; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.drawing_revisions VALUES
	('fbd06623-296c-4ec1-aa21-5244ef85fac5', 'b0136396-fcf8-4945-8445-6dae8f2b11ef', 1, NULL, 'RELEASED', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:23.673067+00', NULL, '2026-10-27 14:05:23.63613+00'),
	('0b31e297-e716-42fc-9175-6aca8fd51162', 'f63b6b4f-d129-4a20-a4b7-9b2f7c8e0dee', 1, NULL, 'RELEASED', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:23.713698+00', NULL, '2026-10-27 14:05:23.6835+00'),
	('6dacfb50-6eef-494b-8b99-69ba12898313', '10a944da-25c6-44cd-91ef-d47c6b9e6864', 1, NULL, 'RELEASED', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:23.751662+00', NULL, '2026-10-27 14:05:23.722295+00'),
	('044c2483-3367-4ca4-8f21-40f2fe153ad1', 'fec6b539-a669-4d0f-b164-b2ffdfd25166', 1, NULL, 'RELEASED', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:23.791731+00', NULL, '2026-10-27 14:05:23.761707+00'),
	('92d59fbb-199f-4b70-b358-a16a0eba842e', 'e6939dc8-15bb-4a22-a933-cd6405398fd2', 1, NULL, 'RELEASED', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:23.830267+00', NULL, '2026-10-27 14:05:23.800733+00'),
	('11b9caef-c61c-45dd-834b-94028277c219', '060e77a1-8d88-4eef-a393-1de10264d450', 1, NULL, 'RELEASED', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:23.870205+00', NULL, '2026-10-27 14:05:23.83903+00'),
	('c4ac3ad1-956f-43f5-8cf5-1d788515110e', '639d20b4-bf47-4805-ad8e-96e6a90e1ccd', 1, NULL, 'RELEASED', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:23.911936+00', NULL, '2026-10-27 14:05:23.880091+00'),
	('f3918fb5-ab80-4af2-a70d-3350488bd385', '88e3f2dd-70ac-4ce7-829d-259afacab83f', 1, NULL, 'RELEASED', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:23.951786+00', NULL, '2026-10-27 14:05:23.920872+00'),
	('0b515fb9-bcf4-4828-837e-9c0927b36f6d', 'eb5b314f-9980-45ae-a923-da2778ed2170', 1, NULL, 'REVIEW', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', NULL, NULL, NULL, NULL, '2026-10-27 14:05:23.961024+00');


--
-- Data for Name: email_log; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.email_log VALUES
	(1, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'customer@example.com', 'Quotation QUO-2026-000001 from Paravalves', 'quote.sent', 'sent', NULL, '2026-10-27 14:05:24.856638+00', '2026-10-27 14:05:24.856638+00'),
	(2, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'customer@example.com', 'Quotation QUO-2026-000002 from Paravalves', 'quote.sent', 'sent', NULL, '2026-10-27 14:05:24.937436+00', '2026-10-27 14:05:24.937436+00'),
	(3, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'customer@example.com', 'Quotation QUO-2026-000003 from Paravalves', 'quote.sent', 'sent', NULL, '2026-10-27 14:05:25.000286+00', '2026-10-27 14:05:25.000286+00'),
	(4, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'customer@example.com', 'Quotation QUO-2026-000004 from Paravalves', 'quote.sent', 'sent', NULL, '2026-10-27 14:05:25.058961+00', '2026-10-27 14:05:25.058961+00'),
	(5, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'customer@example.com', 'Quotation QUO-2026-000005 from Paravalves', 'quote.sent', 'sent', NULL, '2026-10-27 14:05:25.111519+00', '2026-10-27 14:05:25.111519+00'),
	(6, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'customer@example.com', 'Quotation QUO-2026-000006 from Paravalves', 'quote.sent', 'sent', NULL, '2026-10-27 14:05:25.163366+00', '2026-10-27 14:05:25.163366+00'),
	(7, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'customer@example.com', 'Quotation QUO-2026-000007 from Paravalves', 'quote.sent', 'sent', NULL, '2026-10-27 14:05:25.218005+00', '2026-10-27 14:05:25.218005+00'),
	(8, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'customer@example.com', 'Quotation QUO-2026-000008 from Paravalves', 'quote.sent', 'sent', NULL, '2026-10-27 14:05:25.270804+00', '2026-10-27 14:05:25.270804+00'),
	(9, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'customer@example.com', 'Quotation QUO-2026-000009 from Paravalves', 'quote.sent', 'sent', NULL, '2026-10-27 14:05:25.325617+00', '2026-10-27 14:05:25.325617+00'),
	(10, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'customer@example.com', 'Quotation QUO-2026-000010 from Paravalves', 'quote.sent', 'sent', NULL, '2026-10-27 14:05:25.382619+00', '2026-10-27 14:05:25.382619+00'),
	(11, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'customer@example.com', 'Quotation QUO-2026-000011 from Paravalves', 'quote.sent', 'sent', NULL, '2026-10-27 14:05:25.434301+00', '2026-10-27 14:05:25.434301+00'),
	(12, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'customer@example.com', 'Quotation QUO-2026-000012 from Paravalves', 'quote.sent', 'sent', NULL, '2026-10-27 14:05:25.485315+00', '2026-10-27 14:05:25.485315+00'),
	(13, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'customer@example.com', 'Quotation QUO-2026-000013 from Paravalves', 'quote.sent', 'sent', NULL, '2026-10-27 14:05:25.535353+00', '2026-10-27 14:05:25.535353+00'),
	(14, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'customer@example.com', 'Quotation QUO-2026-000014 from Paravalves', 'quote.sent', 'sent', NULL, '2026-10-27 14:05:25.560227+00', '2026-10-27 14:05:25.560227+00'),
	(15, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'supplier@example.com', 'Purchase Order PO-2026-000001 from Paravalves', 'po.sent', 'sent', NULL, '2026-10-27 14:05:25.676845+00', '2026-10-27 14:05:25.676845+00'),
	(16, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'supplier@example.com', 'Purchase Order PO-2026-000002 from Paravalves', 'po.sent', 'sent', NULL, '2026-10-27 14:05:25.781371+00', '2026-10-27 14:05:25.781371+00'),
	(17, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'supplier@example.com', 'Purchase Order PO-2026-000003 from Paravalves', 'po.sent', 'sent', NULL, '2026-10-27 14:05:25.87055+00', '2026-10-27 14:05:25.87055+00'),
	(18, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'supplier@example.com', 'Purchase Order PO-2026-000004 from Paravalves', 'po.sent', 'sent', NULL, '2026-10-27 14:05:25.966618+00', '2026-10-27 14:05:25.966618+00'),
	(19, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'supplier@example.com', 'Purchase Order PO-2026-000005 from Paravalves', 'po.sent', 'sent', NULL, '2026-10-27 14:05:26.053261+00', '2026-10-27 14:05:26.053261+00'),
	(20, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'suresh@abcindustries.com', 'Invoice INV-2026-000001 from Paravalves', 'invoice.issued', 'sent', NULL, '2026-10-27 14:05:28.997868+00', '2026-10-27 14:05:28.997868+00'),
	(21, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'customer@example.com', 'Invoice INV-2026-000002 from Paravalves', 'invoice.issued', 'sent', NULL, '2026-10-27 14:05:29.104438+00', '2026-10-27 14:05:29.104438+00'),
	(22, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'customer@example.com', 'Invoice INV-2026-000003 from Paravalves', 'invoice.issued', 'sent', NULL, '2026-10-27 14:05:29.145986+00', '2026-10-27 14:05:29.145986+00');


--
-- Data for Name: engineering_changes; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.engineering_changes VALUES
	('ac3c083a-be60-41d3-88ef-215c4e5abdbb', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'ECN-2026-000001', '6e212887-960b-4eed-ade6-18715e05c5cb', NULL, 'Change stem O-ring material to FKM', 'Field failures with EPDM at 120°C service', 'IMPACT_ASSESSED', '{"pos": [], "wip": [{"status": "IN_PROGRESS", "quantity": "8.000", "wo_number": "WO-2026-000013"}], "stock": {"lots": [], "on_hand": 13, "incoming": 0}, "orders": [{"status": "READY", "customer": "ABC Industries", "order_number": "SO-2026-000001", "delivery_date": "2026-11-25T18:30:00.000Z"}], "units_in_process": 0}', NULL, NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', NULL, NULL, '2026-10-27 14:05:29.169485+00'),
	('12bb7771-9b7d-4616-8e3c-a828f72ea06b', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'ECN-2026-000002', 'eb07eab2-eba7-4b97-88f8-9066662e9a5e', NULL, 'Increase bonnet bolt torque spec', 'Leak at bonnet joint during site hydrotest', 'IMPACT_ASSESSED', '{"pos": [], "wip": [{"status": "IN_PROGRESS", "quantity": "5.000", "wo_number": "WO-2026-000014"}], "stock": {"lots": [], "on_hand": 0, "incoming": 0}, "orders": [{"status": "CONFIRMED", "customer": "Deccan Petrochem Ltd", "order_number": "SO-2026-000002", "delivery_date": "2026-11-16T18:30:00.000Z"}], "units_in_process": 2}', 'Rework WIP & stock to new revision', 'from serial 20', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', NULL, NULL, '2026-10-27 14:05:29.190814+00'),
	('32f47fe3-2898-4403-8d0c-2bcf34ad2aed', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'ECN-2026-000003', '92a93794-1287-4b7d-8868-7b9b81b87cb2', '060e77a1-8d88-4eef-a393-1de10264d450', 'Add spring retainer groove', 'Supplier casting update', 'IMPLEMENTED', '{"pos": [], "wip": [{"status": "IN_PROGRESS", "quantity": "6.000", "wo_number": "WO-2026-000015"}], "stock": {"lots": [], "on_hand": 0, "incoming": 0}, "orders": [{"status": "PROCUREMENT", "customer": "Metro Utilities", "order_number": "SO-2026-000005", "delivery_date": "2026-11-03T18:30:00.000Z"}], "units_in_process": 0}', 'Use existing stock until exhausted, then change', 'from next batch', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '6b544707-dfa2-4b3b-8cf6-5d69641b903c', '2026-10-27 14:05:29.241649+00', '2026-10-27 14:05:29.214606+00');


--
-- Data for Name: engineering_requests; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.engineering_requests VALUES
	('853e14b4-5e47-421f-9010-65c1bbde9d40', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'ER-2026-000001', '84f16360-acd8-4658-a08c-5095e56335a6', NULL, 'Engineering for SO-2026-000001', NULL, 'OPEN', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:24.889812+00', '2026-10-27 14:05:24.889812+00', 1),
	('c4e22e04-898b-4e33-b5cf-29596761b805', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'ER-2026-000002', '0bbed72f-1aff-49df-867f-4201b53b165f', NULL, 'Engineering for SO-2026-000002', NULL, 'OPEN', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:24.953594+00', '2026-10-27 14:05:24.953594+00', 1),
	('b5184667-2408-4b24-86b5-9a3ae92d8d96', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'ER-2026-000003', '08c81785-76c6-4ce9-9c02-f0d075c9befc', NULL, 'Engineering for SO-2026-000003', NULL, 'OPEN', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.01735+00', '2026-10-27 14:05:25.01735+00', 1),
	('c357d573-f8e4-4bdd-a020-e9b285156bad', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'ER-2026-000004', '5150e791-ad57-45a1-9173-962ee330f78f', NULL, 'Engineering for SO-2026-000004', NULL, 'OPEN', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.072563+00', '2026-10-27 14:05:25.072563+00', 1),
	('127a4e95-bacb-4259-9b19-66f0654932da', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'ER-2026-000005', 'bc2c7461-b1cd-4c66-8996-611e28098035', NULL, 'Engineering for SO-2026-000005', NULL, 'OPEN', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.125237+00', '2026-10-27 14:05:25.125237+00', 1),
	('ed476ca9-22af-4a64-b709-47128f2421cc', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'ER-2026-000006', 'd7896924-f01a-474e-afe1-ef33836afd2f', NULL, 'Engineering for SO-2026-000006', NULL, 'OPEN', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.178283+00', '2026-10-27 14:05:25.178283+00', 1),
	('a835e6e1-d8ef-412d-b3d5-7ee71d4b29cd', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'ER-2026-000007', '498e3f4d-22ff-4b1e-a1ab-43e37332b591', NULL, 'Engineering for SO-2026-000007', NULL, 'OPEN', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.232856+00', '2026-10-27 14:05:25.232856+00', 1),
	('80a92a91-03b3-496a-ba81-6b3a611dd78e', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'ER-2026-000008', '4e36052e-0a7c-47ae-94dd-8c74ff17ee6e', NULL, 'Engineering for SO-2026-000008', NULL, 'OPEN', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.286585+00', '2026-10-27 14:05:25.286585+00', 1),
	('566dd68f-b425-4f6a-a2f2-bc8f68f369d0', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'ER-2026-000009', 'c8daa3b5-bd9e-41fe-83ca-f53a2138d16d', NULL, 'Engineering for SO-2026-000009', NULL, 'OPEN', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.340546+00', '2026-10-27 14:05:25.340546+00', 1),
	('72143c34-915a-495d-920d-d258701d3209', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'ER-2026-000010', '17faff62-40d5-4b82-a2bb-e6c64e3162be', NULL, 'Engineering for SO-2026-000010', NULL, 'OPEN', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.397066+00', '2026-10-27 14:05:25.397066+00', 1),
	('1d67ded1-8d74-4f63-a20a-aec3489f29d8', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'ER-2026-000011', '23f877c9-0add-44dc-b617-5e7e48c1e841', NULL, 'Engineering for SO-2026-000011', NULL, 'OPEN', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.448918+00', '2026-10-27 14:05:25.448918+00', 1),
	('eee61626-3e10-491b-9f76-9e0e25be78ee', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'ER-2026-000012', 'afc38366-3c26-4a27-a1cc-e811550d9b5c', NULL, 'Engineering for SO-2026-000012', NULL, 'OPEN', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.499541+00', '2026-10-27 14:05:25.499541+00', 1);


--
-- Data for Name: equipment; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.equipment VALUES
	('39ed37f2-99b8-4f7b-b5ab-a93be10edabb', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'EQ-TB-01', 'Hydrostatic test bench 100 bar', 'TEST_BENCH', '2027-02-24', 'ACTIVE'),
	('cc9a4be8-38c2-4db9-bfed-ec7800379a51', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'EQ-TB-02', 'Pneumatic seat-leak bench', 'TEST_BENCH', '2026-12-11', 'ACTIVE'),
	('e191cdcb-11ab-4a13-b1e7-5e4b53f07e8b', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'EQ-CMM-01', 'Coordinate measuring machine', 'CMM', '2027-05-15', 'ACTIVE'),
	('70be426a-d46c-4936-8746-d13159349e4b', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'EQ-VC-01', 'Vernier caliper set', 'GAUGE', '2026-12-26', 'ACTIVE'),
	('a2a098da-54a8-4ef7-b096-25c580473149', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'EQ-TW-01', 'Torque wrench 20–200 Nm', 'GAUGE', '2026-11-06', 'ACTIVE'),
	('fe751927-f029-4e7a-9774-756d7104b7b5', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'EQ-PG-07', 'Pressure gauge 0–160 bar', 'GAUGE', '2026-10-12', 'ACTIVE'),
	('6c9bb4ca-9e32-4348-b035-d99f5b30dabd', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'EQ-HT-02', 'Hardness tester (Rockwell)', 'GAUGE', '2026-09-17', 'OUT_OF_CALIBRATION');


--
-- Data for Name: expenses; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: purchase_orders; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.purchase_orders VALUES
	('ce93a67c-9fed-4963-afb5-0ba101288930', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PO-2026-000001', 'd52968f6-fca2-437d-afc4-74883a4a0540', 'RECEIVED', 'INR', '2026-10-22', 62000.00, 11160.00, 73160.00, NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.658705+00', '2026-10-27 14:05:25.705063+00', 5),
	('71578b63-a1db-494a-adca-f340552bf4f9', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PO-2026-000002', '4beb637f-1b4c-4c99-9821-18432f34c3d8', 'RECEIVED', 'INR', '2026-10-22', 22000.00, 3960.00, 25960.00, NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.766327+00', '2026-10-27 14:05:25.807881+00', 5),
	('4753aa94-8b49-4c00-903e-ac1ef9478495', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PO-2026-000003', 'f010fc14-ae10-4f2b-8f3d-0555bc31309c', 'RECEIVED', 'INR', '2026-10-22', 9000.00, 1620.00, 10620.00, NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.856118+00', '2026-10-27 14:05:25.900835+00', 5),
	('9c2ea34b-bc2f-4e8c-a28a-29f19d040c87', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PO-2026-000004', '4beb637f-1b4c-4c99-9821-18432f34c3d8', 'RECEIVED', 'INR', '2026-10-22', 41000.00, 7380.00, 48380.00, NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.951517+00', '2026-10-27 14:05:25.994935+00', 5),
	('4507d976-1c8e-445c-912f-afb72176e7f9', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PO-2026-000005', '15390c7c-a37d-4ee6-ae7d-8ab0c9d23fa9', 'SENT', 'INR', '2026-10-21', 18000.00, 3240.00, 21240.00, NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:26.043905+00', '2026-10-27 14:05:26.053261+00', 3),
	('5b1af53a-3402-449f-ac83-b285bb733ab5', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PO-2026-000006', '2b48019d-4f6b-452d-9a3a-20c75671cdf3', 'PENDING_APPROVAL', 'INR', '2026-11-16', 600000.00, 108000.00, 708000.00, NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:26.063948+00', '2026-10-27 14:05:26.072984+00', 3);


--
-- Data for Name: warehouses; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.warehouses VALUES
	('e4804dc7-b2ff-4c92-9b17-767e229aec84', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'MAIN', 'Main Warehouse', true);


--
-- Data for Name: goods_receipts; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.goods_receipts VALUES
	('e1d2578b-4bf7-4a4c-8fab-6e13f71549eb', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'GRN-2026-000001', 'ce93a67c-9fed-4963-afb5-0ba101288930', 'd52968f6-fca2-437d-afc4-74883a4a0540', 'e4804dc7-b2ff-4c92-9b17-767e229aec84', 'DONE', '2026-10-27 14:05:25.705063+00', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.705063+00'),
	('39849164-7e5a-4cf4-a7c0-51985752ccf4', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'GRN-2026-000002', '71578b63-a1db-494a-adca-f340552bf4f9', '4beb637f-1b4c-4c99-9821-18432f34c3d8', 'e4804dc7-b2ff-4c92-9b17-767e229aec84', 'DONE', '2026-10-27 14:05:25.807881+00', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.807881+00'),
	('2d427e21-6868-4293-848c-907d2ecb3544', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'GRN-2026-000003', '4753aa94-8b49-4c00-903e-ac1ef9478495', 'f010fc14-ae10-4f2b-8f3d-0555bc31309c', 'e4804dc7-b2ff-4c92-9b17-767e229aec84', 'DONE', '2026-10-27 14:05:25.900835+00', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.900835+00'),
	('25c5720f-01ba-401d-be7c-1cd37e709753', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'GRN-2026-000004', '9c2ea34b-bc2f-4e8c-a28a-29f19d040c87', '4beb637f-1b4c-4c99-9821-18432f34c3d8', 'e4804dc7-b2ff-4c92-9b17-767e229aec84', 'DONE', '2026-10-27 14:05:25.994935+00', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.994935+00');


--
-- Data for Name: purchase_order_lines; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.purchase_order_lines VALUES
	('2d85b266-584e-4d2e-84d5-a7b32d9d1c04', 'ce93a67c-9fed-4963-afb5-0ba101288930', 1, 'd14a8056-467a-425a-a517-b0f08e05e8ec', 'PV-BODY-01 batch 1', 20.000, 20.000, 620.0000, 18.00, 14632.00),
	('d3e20519-1653-4923-bca5-a263529433cb', 'ce93a67c-9fed-4963-afb5-0ba101288930', 2, 'd14a8056-467a-425a-a517-b0f08e05e8ec', 'PV-BODY-01 batch 2', 20.000, 20.000, 620.0000, 18.00, 14632.00),
	('c7c38f3c-26d7-4fb3-b529-d5c7cc1a28d7', 'ce93a67c-9fed-4963-afb5-0ba101288930', 3, 'd14a8056-467a-425a-a517-b0f08e05e8ec', 'PV-BODY-01 batch 3', 20.000, 20.000, 620.0000, 18.00, 14632.00),
	('e0ffb694-b59b-4e21-883d-57d7e385bfbe', 'ce93a67c-9fed-4963-afb5-0ba101288930', 4, 'd14a8056-467a-425a-a517-b0f08e05e8ec', 'PV-BODY-01 batch 4', 20.000, 20.000, 620.0000, 18.00, 14632.00),
	('6345d05a-4ab6-4574-b742-67cf7f4e793c', 'ce93a67c-9fed-4963-afb5-0ba101288930', 5, 'd14a8056-467a-425a-a517-b0f08e05e8ec', 'PV-BODY-01 batch 5', 20.000, 20.000, 620.0000, 18.00, 14632.00),
	('282e5fbf-3ed6-40f2-be10-6fd5d29df842', '71578b63-a1db-494a-adca-f340552bf4f9', 1, '961b2013-58fb-45fb-8a7c-618c84887c18', 'PV-STEM-01 batch 1', 20.000, 20.000, 220.0000, 18.00, 5192.00),
	('7f55942e-3343-4509-b42c-46b37ed91f32', '71578b63-a1db-494a-adca-f340552bf4f9', 2, '961b2013-58fb-45fb-8a7c-618c84887c18', 'PV-STEM-01 batch 2', 20.000, 20.000, 220.0000, 18.00, 5192.00),
	('258acd4a-17bc-41dd-b51c-ceb362118714', '71578b63-a1db-494a-adca-f340552bf4f9', 3, '961b2013-58fb-45fb-8a7c-618c84887c18', 'PV-STEM-01 batch 3', 20.000, 20.000, 220.0000, 18.00, 5192.00),
	('6529899b-fc00-406a-bd58-d03053a84c18', '71578b63-a1db-494a-adca-f340552bf4f9', 4, '961b2013-58fb-45fb-8a7c-618c84887c18', 'PV-STEM-01 batch 4', 20.000, 20.000, 220.0000, 18.00, 5192.00),
	('e1cb37f6-35e4-47d4-8aae-a0b351f37208', '71578b63-a1db-494a-adca-f340552bf4f9', 5, '961b2013-58fb-45fb-8a7c-618c84887c18', 'PV-STEM-01 batch 5', 20.000, 20.000, 220.0000, 18.00, 5192.00),
	('6eda9614-048c-4202-aa32-86e1c761162a', '4753aa94-8b49-4c00-903e-ac1ef9478495', 1, 'abe0ed52-e0fd-424a-b2d4-00c1c625767f', 'PV-SEAT-01 batch 1', 20.000, 20.000, 90.0000, 18.00, 2124.00),
	('07c6e355-0bd0-439f-866f-e6777dafc4c2', '4753aa94-8b49-4c00-903e-ac1ef9478495', 2, 'abe0ed52-e0fd-424a-b2d4-00c1c625767f', 'PV-SEAT-01 batch 2', 20.000, 20.000, 90.0000, 18.00, 2124.00),
	('f3c35ba8-bb3e-4bb2-9a4e-eede563301d7', '4753aa94-8b49-4c00-903e-ac1ef9478495', 3, 'abe0ed52-e0fd-424a-b2d4-00c1c625767f', 'PV-SEAT-01 batch 3', 20.000, 20.000, 90.0000, 18.00, 2124.00),
	('02a61237-c193-4dbe-b480-146840942de9', '4753aa94-8b49-4c00-903e-ac1ef9478495', 4, 'abe0ed52-e0fd-424a-b2d4-00c1c625767f', 'PV-SEAT-01 batch 4', 20.000, 20.000, 90.0000, 18.00, 2124.00),
	('1efeda9b-82e2-47da-b6ce-14313c439a22', '4753aa94-8b49-4c00-903e-ac1ef9478495', 5, 'abe0ed52-e0fd-424a-b2d4-00c1c625767f', 'PV-SEAT-01 batch 5', 20.000, 20.000, 90.0000, 18.00, 2124.00),
	('014af29a-5866-4e9c-8b3b-b6fd3ceaa39e', '9c2ea34b-bc2f-4e8c-a28a-29f19d040c87', 1, '2488bae2-79d6-4ce2-95c8-385344da703b', 'PV-BONNET-01 batch 1', 20.000, 20.000, 410.0000, 18.00, 9676.00),
	('64e90580-4faf-47c8-9cfe-3e43ae35623a', '9c2ea34b-bc2f-4e8c-a28a-29f19d040c87', 2, '2488bae2-79d6-4ce2-95c8-385344da703b', 'PV-BONNET-01 batch 2', 20.000, 20.000, 410.0000, 18.00, 9676.00),
	('9538ad79-2b4c-4c7a-ab56-9d84c66f2f40', '9c2ea34b-bc2f-4e8c-a28a-29f19d040c87', 3, '2488bae2-79d6-4ce2-95c8-385344da703b', 'PV-BONNET-01 batch 3', 20.000, 20.000, 410.0000, 18.00, 9676.00),
	('976eb82b-5fb2-45b6-849a-b6a9e196a220', '9c2ea34b-bc2f-4e8c-a28a-29f19d040c87', 4, '2488bae2-79d6-4ce2-95c8-385344da703b', 'PV-BONNET-01 batch 4', 20.000, 20.000, 410.0000, 18.00, 9676.00),
	('7d1f293d-4f2d-458d-b49c-b3c16ffe162d', '9c2ea34b-bc2f-4e8c-a28a-29f19d040c87', 5, '2488bae2-79d6-4ce2-95c8-385344da703b', 'PV-BONNET-01 batch 5', 20.000, 20.000, 410.0000, 18.00, 9676.00),
	('ebde64e6-fd9f-4a72-a7e7-29605d35590c', '4507d976-1c8e-445c-912f-afb72176e7f9', 1, NULL, 'Heat-treatment consumables', 10.000, 0.000, 1800.0000, 18.00, 21240.00),
	('4ad575ec-f99b-463c-a6c4-fb69ca59b185', '5b1af53a-3402-449f-ac83-b285bb733ab5', 1, '086765c3-bd85-4e70-85fe-183ad180df42', 'SS316 bar stock Ø40', 4000.000, 0.000, 150.0000, 18.00, 708000.00);


--
-- Data for Name: goods_receipt_lines; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.goods_receipt_lines VALUES
	('75fc0c07-12e9-46a3-b609-5f2b5a8d5ad9', 'e1d2578b-4bf7-4a4c-8fab-6e13f71549eb', '2d85b266-584e-4d2e-84d5-a7b32d9d1c04', 'd14a8056-467a-425a-a517-b0f08e05e8ec', 0.000, 20.000, 20.000, 0.000, 0.000, 'BD-H26110'),
	('1d09d7a0-1ba3-4a18-b5a5-3a57270a9cdc', 'e1d2578b-4bf7-4a4c-8fab-6e13f71549eb', 'd3e20519-1653-4923-bca5-a263529433cb', 'd14a8056-467a-425a-a517-b0f08e05e8ec', 0.000, 20.000, 20.000, 0.000, 0.000, 'BD-H26117'),
	('61bb6e1a-4f50-46e9-80f2-e8b33d5454d9', 'e1d2578b-4bf7-4a4c-8fab-6e13f71549eb', 'c7c38f3c-26d7-4fb3-b529-d5c7cc1a28d7', 'd14a8056-467a-425a-a517-b0f08e05e8ec', 0.000, 20.000, 20.000, 0.000, 0.000, 'BD-H26124'),
	('5b21ad43-26f4-4326-be59-65907a00c52f', 'e1d2578b-4bf7-4a4c-8fab-6e13f71549eb', 'e0ffb694-b59b-4e21-883d-57d7e385bfbe', 'd14a8056-467a-425a-a517-b0f08e05e8ec', 0.000, 20.000, 20.000, 0.000, 0.000, 'BD-H26131'),
	('3de0dae7-8734-4cd4-a7ec-b9bcb5f5b277', 'e1d2578b-4bf7-4a4c-8fab-6e13f71549eb', '6345d05a-4ab6-4574-b742-67cf7f4e793c', 'd14a8056-467a-425a-a517-b0f08e05e8ec', 0.000, 20.000, 20.000, 0.000, 0.000, 'BD-H26138'),
	('9ccc84a7-a21d-423b-bdc6-bb9c50af22a4', '39849164-7e5a-4cf4-a7c0-51985752ccf4', '282e5fbf-3ed6-40f2-be10-6fd5d29df842', '961b2013-58fb-45fb-8a7c-618c84887c18', 0.000, 20.000, 20.000, 0.000, 0.000, 'ST-H26110'),
	('14e63abf-e990-4418-a8d6-a5cd9598fe77', '39849164-7e5a-4cf4-a7c0-51985752ccf4', '7f55942e-3343-4509-b42c-46b37ed91f32', '961b2013-58fb-45fb-8a7c-618c84887c18', 0.000, 20.000, 20.000, 0.000, 0.000, 'ST-H26117'),
	('4d8b03b6-d0df-40b2-a3dd-8252f9de2250', '39849164-7e5a-4cf4-a7c0-51985752ccf4', '258acd4a-17bc-41dd-b51c-ceb362118714', '961b2013-58fb-45fb-8a7c-618c84887c18', 0.000, 20.000, 20.000, 0.000, 0.000, 'ST-H26124'),
	('27b070e7-7ff8-4ca5-beb9-215b8dad4238', '39849164-7e5a-4cf4-a7c0-51985752ccf4', '6529899b-fc00-406a-bd58-d03053a84c18', '961b2013-58fb-45fb-8a7c-618c84887c18', 0.000, 20.000, 20.000, 0.000, 0.000, 'ST-H26131'),
	('1b619140-b340-4bab-8d08-0d2b37f858b4', '39849164-7e5a-4cf4-a7c0-51985752ccf4', 'e1cb37f6-35e4-47d4-8aae-a0b351f37208', '961b2013-58fb-45fb-8a7c-618c84887c18', 0.000, 20.000, 20.000, 0.000, 0.000, 'ST-H26138'),
	('03e5c4e3-13e5-4aae-bc4b-b2a2cf2161f5', '2d427e21-6868-4293-848c-907d2ecb3544', '6eda9614-048c-4202-aa32-86e1c761162a', 'abe0ed52-e0fd-424a-b2d4-00c1c625767f', 0.000, 20.000, 20.000, 0.000, 0.000, 'SE-H26110'),
	('e122ff6b-132b-46e9-9c9c-13fe3ab5f524', '2d427e21-6868-4293-848c-907d2ecb3544', '07c6e355-0bd0-439f-866f-e6777dafc4c2', 'abe0ed52-e0fd-424a-b2d4-00c1c625767f', 0.000, 20.000, 20.000, 0.000, 0.000, 'SE-H26117'),
	('0bcbc9eb-bc7b-4521-95a3-d34ff3a35a52', '2d427e21-6868-4293-848c-907d2ecb3544', 'f3c35ba8-bb3e-4bb2-9a4e-eede563301d7', 'abe0ed52-e0fd-424a-b2d4-00c1c625767f', 0.000, 20.000, 20.000, 0.000, 0.000, 'SE-H26124'),
	('8da948ba-3622-4370-aa23-5fe7a8ec1ef8', '2d427e21-6868-4293-848c-907d2ecb3544', '02a61237-c193-4dbe-b480-146840942de9', 'abe0ed52-e0fd-424a-b2d4-00c1c625767f', 0.000, 20.000, 20.000, 0.000, 0.000, 'SE-H26131'),
	('d10f0468-3df9-4df2-a489-6c972134e859', '2d427e21-6868-4293-848c-907d2ecb3544', '1efeda9b-82e2-47da-b6ce-14313c439a22', 'abe0ed52-e0fd-424a-b2d4-00c1c625767f', 0.000, 20.000, 20.000, 0.000, 0.000, 'SE-H26138'),
	('10ed9f61-b6ec-4633-9c58-d59c9167f281', '25c5720f-01ba-401d-be7c-1cd37e709753', '014af29a-5866-4e9c-8b3b-b6fd3ceaa39e', '2488bae2-79d6-4ce2-95c8-385344da703b', 0.000, 20.000, 20.000, 0.000, 0.000, 'BN-H26112'),
	('10d98773-ea0e-4f73-ae93-50e867e1e7bc', '25c5720f-01ba-401d-be7c-1cd37e709753', '64e90580-4faf-47c8-9cfe-3e43ae35623a', '2488bae2-79d6-4ce2-95c8-385344da703b', 0.000, 20.000, 20.000, 0.000, 0.000, 'BN-H26119'),
	('accd76be-088a-44ee-a29e-840720a098cd', '25c5720f-01ba-401d-be7c-1cd37e709753', '9538ad79-2b4c-4c7a-ab56-9d84c66f2f40', '2488bae2-79d6-4ce2-95c8-385344da703b', 0.000, 20.000, 20.000, 0.000, 0.000, 'BN-H26126'),
	('fb88a2b0-4821-4534-af5a-558cb55115ab', '25c5720f-01ba-401d-be7c-1cd37e709753', '976eb82b-5fb2-45b6-849a-b6a9e196a220', '2488bae2-79d6-4ce2-95c8-385344da703b', 0.000, 20.000, 20.000, 0.000, 0.000, 'BN-H26133'),
	('caaef092-b69a-48dd-bd8e-852dda9802ed', '25c5720f-01ba-401d-be7c-1cd37e709753', '7d1f293d-4f2d-458d-b49c-b3c16ffe162d', '2488bae2-79d6-4ce2-95c8-385344da703b', 0.000, 20.000, 20.000, 0.000, 0.000, 'BN-H26140');


--
-- Data for Name: import_batches; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: inquiry_submissions; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: inspections; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.inspections VALUES
	('371e7943-87ad-4a85-a761-87525f644eba', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'INS-2026-000001', 'INCOMING', 'LOT', '95d5f8ff-3e0e-4e8c-83a3-5a2302d2179c', 'Lot BD-H26110', '[{"ok": true, "name": "Dimensional check vs drawing", "measured": "within tol."}, {"ok": true, "name": "Material / heat certificate matches lot", "measured": "within tol."}, {"ok": true, "name": "Visual & surface condition", "measured": "within tol."}, {"ok": true, "name": "Hardness / PMI (if specified)", "measured": "within tol."}]', 'PASSED', '70be426a-d46c-4936-8746-d13159349e4b', 'Accepted', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:26.088838+00', '2026-10-27 14:05:26.082074+00'),
	('13f53eca-f5ad-4db2-9251-9e7e3fa4b06d', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'INS-2026-000002', 'INCOMING', 'LOT', '58a3b02d-323f-4467-98e1-e7a6fa301605', 'Lot BD-H26117', '[{"ok": true, "name": "Dimensional check vs drawing", "measured": "within tol."}, {"ok": true, "name": "Material / heat certificate matches lot", "measured": "within tol."}, {"ok": true, "name": "Visual & surface condition", "measured": "within tol."}, {"ok": true, "name": "Hardness / PMI (if specified)", "measured": "within tol."}]', 'PASSED', '70be426a-d46c-4936-8746-d13159349e4b', 'Accepted', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:26.10432+00', '2026-10-27 14:05:26.099188+00'),
	('de063587-91b8-4bea-8a83-f3f2899d3a90', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'INS-2026-000003', 'INCOMING', 'LOT', '6b284d86-e253-4eb6-8042-ffff725e5290', 'Lot BD-H26124', '[{"ok": true, "name": "Dimensional check vs drawing", "measured": "within tol."}, {"ok": true, "name": "Material / heat certificate matches lot", "measured": "within tol."}, {"ok": true, "name": "Visual & surface condition", "measured": "within tol."}, {"ok": true, "name": "Hardness / PMI (if specified)", "measured": "within tol."}]', 'PASSED', '70be426a-d46c-4936-8746-d13159349e4b', 'Accepted', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:26.119069+00', '2026-10-27 14:05:26.113901+00'),
	('a812e3b3-8bf5-4c57-a570-0a30aa5675a4', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'INS-2026-000004', 'INCOMING', 'LOT', '048db9a3-8ba6-4d10-bd7b-58a7f4d5f0f2', 'Lot BD-H26131', '[{"ok": true, "name": "Dimensional check vs drawing", "measured": "within tol."}, {"ok": true, "name": "Material / heat certificate matches lot", "measured": "within tol."}, {"ok": true, "name": "Visual & surface condition", "measured": "within tol."}, {"ok": true, "name": "Hardness / PMI (if specified)", "measured": "within tol."}]', 'PASSED', '70be426a-d46c-4936-8746-d13159349e4b', 'Accepted', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:26.133667+00', '2026-10-27 14:05:26.128453+00'),
	('aa3bd83d-a31c-43bb-90c2-c211ab496716', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'INS-2026-000005', 'INCOMING', 'LOT', 'c34442e4-29f2-4d70-9ce7-ed440cde9a9b', 'Lot BD-H26138', '[{"ok": true, "name": "Dimensional check vs drawing", "measured": "within tol."}, {"ok": true, "name": "Material / heat certificate matches lot", "measured": "within tol."}, {"ok": true, "name": "Visual & surface condition", "measured": "within tol."}, {"ok": false, "name": "Hardness / PMI (if specified)", "measured": "168 HB (min 180)"}]', 'FAILED', '70be426a-d46c-4936-8746-d13159349e4b', 'Hardness below specification', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:26.147745+00', '2026-10-27 14:05:26.142538+00'),
	('e1ae9670-29cb-4d72-bb21-537a5cb4a08b', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'INS-2026-000006', 'INCOMING', 'LOT', '4f97209e-2450-473b-9fa2-202f7f292a52', 'Lot ST-H26110', '[{"ok": true, "name": "Dimensional check vs drawing", "measured": "within tol."}, {"ok": true, "name": "Material / heat certificate matches lot", "measured": "within tol."}, {"ok": true, "name": "Visual & surface condition", "measured": "within tol."}, {"ok": true, "name": "Hardness / PMI (if specified)", "measured": "within tol."}]', 'PASSED', '70be426a-d46c-4936-8746-d13159349e4b', 'Accepted', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:26.165725+00', '2026-10-27 14:05:26.160511+00'),
	('33f5fbf5-9beb-4c07-904e-83e0270bab61', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'INS-2026-000007', 'INCOMING', 'LOT', '5f814b84-9601-463b-a2e3-30d480bf2957', 'Lot ST-H26117', '[{"ok": true, "name": "Dimensional check vs drawing", "measured": "within tol."}, {"ok": true, "name": "Material / heat certificate matches lot", "measured": "within tol."}, {"ok": true, "name": "Visual & surface condition", "measured": "within tol."}, {"ok": true, "name": "Hardness / PMI (if specified)", "measured": "within tol."}]', 'PASSED', '70be426a-d46c-4936-8746-d13159349e4b', 'Accepted', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:26.179766+00', '2026-10-27 14:05:26.173945+00'),
	('b172f7dd-029d-4a13-ab5f-05271b7576b7', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'INS-2026-000008', 'INCOMING', 'LOT', 'a72dcfd1-1cf8-4783-9663-76c21c970d92', 'Lot ST-H26124', '[{"ok": true, "name": "Dimensional check vs drawing", "measured": "within tol."}, {"ok": true, "name": "Material / heat certificate matches lot", "measured": "within tol."}, {"ok": true, "name": "Visual & surface condition", "measured": "within tol."}, {"ok": true, "name": "Hardness / PMI (if specified)", "measured": "within tol."}]', 'PASSED', '70be426a-d46c-4936-8746-d13159349e4b', 'Accepted', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:26.193464+00', '2026-10-27 14:05:26.188053+00'),
	('9dba1ff8-78e4-4459-8b32-b5dd2e846708', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'INS-2026-000009', 'INCOMING', 'LOT', '0120e309-58a4-4109-8fc0-3d73ec38cb1e', 'Lot ST-H26131', '[{"ok": true, "name": "Dimensional check vs drawing", "measured": "within tol."}, {"ok": true, "name": "Material / heat certificate matches lot", "measured": "within tol."}, {"ok": true, "name": "Visual & surface condition", "measured": "within tol."}, {"ok": true, "name": "Hardness / PMI (if specified)", "measured": "within tol."}]', 'PASSED', '70be426a-d46c-4936-8746-d13159349e4b', 'Accepted', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:26.207407+00', '2026-10-27 14:05:26.20228+00'),
	('d939dc57-b405-45d5-9bdc-bf74386b6c8c', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'INS-2026-000010', 'INCOMING', 'LOT', '17c99f4c-ed79-4499-b523-8576198201fc', 'Lot ST-H26138', '[{"ok": true, "name": "Dimensional check vs drawing", "measured": "within tol."}, {"ok": true, "name": "Material / heat certificate matches lot", "measured": "within tol."}, {"ok": true, "name": "Visual & surface condition", "measured": "within tol."}, {"ok": false, "name": "Hardness / PMI (if specified)", "measured": "168 HB (min 180)"}]', 'FAILED', '70be426a-d46c-4936-8746-d13159349e4b', 'Hardness below specification', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:26.221683+00', '2026-10-27 14:05:26.216628+00'),
	('acaa6c68-0c99-452d-9855-f6a2c22fdc7d', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'INS-2026-000011', 'INCOMING', 'LOT', 'd7bf700f-7b18-4e2b-b49b-b4a40562d9b0', 'Lot SE-H26110', '[{"ok": true, "name": "Dimensional check vs drawing", "measured": "within tol."}, {"ok": true, "name": "Material / heat certificate matches lot", "measured": "within tol."}, {"ok": true, "name": "Visual & surface condition", "measured": "within tol."}, {"ok": true, "name": "Hardness / PMI (if specified)", "measured": "within tol."}]', 'PASSED', '70be426a-d46c-4936-8746-d13159349e4b', 'Accepted', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:26.238764+00', '2026-10-27 14:05:26.23348+00'),
	('cc2abdb7-f73a-498c-a2c1-16c104e88fbd', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'INS-2026-000012', 'INCOMING', 'LOT', 'ac69d498-8678-482a-a1f8-b88b8aa5ff2d', 'Lot SE-H26117', '[{"ok": true, "name": "Dimensional check vs drawing", "measured": "within tol."}, {"ok": true, "name": "Material / heat certificate matches lot", "measured": "within tol."}, {"ok": true, "name": "Visual & surface condition", "measured": "within tol."}, {"ok": true, "name": "Hardness / PMI (if specified)", "measured": "within tol."}]', 'PASSED', '70be426a-d46c-4936-8746-d13159349e4b', 'Accepted', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:26.252785+00', '2026-10-27 14:05:26.247807+00'),
	('b5d580a3-4ac1-47ee-a3c9-ca72bb26b1bb', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'INS-2026-000013', 'INCOMING', 'LOT', 'd1d4171d-c2fb-4670-9e30-492d79057522', 'Lot SE-H26124', '[{"ok": true, "name": "Dimensional check vs drawing", "measured": "within tol."}, {"ok": true, "name": "Material / heat certificate matches lot", "measured": "within tol."}, {"ok": true, "name": "Visual & surface condition", "measured": "within tol."}, {"ok": true, "name": "Hardness / PMI (if specified)", "measured": "within tol."}]', 'PASSED', '70be426a-d46c-4936-8746-d13159349e4b', 'Accepted', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:26.26656+00', '2026-10-27 14:05:26.261434+00'),
	('dd268999-dadf-43c1-be8d-44c48a91e21d', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'INS-2026-000014', 'INCOMING', 'LOT', 'f68863e2-74c6-4938-a665-6b13c9844f68', 'Lot SE-H26131', '[{"ok": true, "name": "Dimensional check vs drawing", "measured": "within tol."}, {"ok": true, "name": "Material / heat certificate matches lot", "measured": "within tol."}, {"ok": true, "name": "Visual & surface condition", "measured": "within tol."}, {"ok": true, "name": "Hardness / PMI (if specified)", "measured": "within tol."}]', 'PASSED', '70be426a-d46c-4936-8746-d13159349e4b', 'Accepted', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:26.28125+00', '2026-10-27 14:05:26.276007+00'),
	('c3090a00-b56f-4034-adc2-704fc00180ac', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'INS-2026-000015', 'INCOMING', 'LOT', '99680ed9-90e9-4b14-b7fa-eb66f3d6007b', 'Lot SE-H26138', '[]', 'PENDING', '70be426a-d46c-4936-8746-d13159349e4b', NULL, NULL, '693a2518-49d6-4f23-8d7c-089491e70217', NULL, '2026-10-27 14:05:26.289439+00'),
	('6479704a-fd29-42b1-a21a-fa96cd91ffae', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'INS-2026-000016', 'INCOMING', 'LOT', 'a3951547-845b-4e82-97bb-5f68f0b32aaa', 'Lot BN-H26112', '[{"ok": true, "name": "Dimensional check vs drawing", "measured": "within tol."}, {"ok": true, "name": "Material / heat certificate matches lot", "measured": "within tol."}, {"ok": true, "name": "Visual & surface condition", "measured": "within tol."}, {"ok": true, "name": "Hardness / PMI (if specified)", "measured": "within tol."}]', 'PASSED', '70be426a-d46c-4936-8746-d13159349e4b', 'Accepted', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:26.301756+00', '2026-10-27 14:05:26.296654+00'),
	('527f04a0-bc24-4c81-97e6-7f269f43ef76', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'INS-2026-000017', 'INCOMING', 'LOT', 'b0650c06-a99d-4de4-b7f8-088489f58662', 'Lot BN-H26119', '[{"ok": true, "name": "Dimensional check vs drawing", "measured": "within tol."}, {"ok": true, "name": "Material / heat certificate matches lot", "measured": "within tol."}, {"ok": true, "name": "Visual & surface condition", "measured": "within tol."}, {"ok": true, "name": "Hardness / PMI (if specified)", "measured": "within tol."}]', 'PASSED', '70be426a-d46c-4936-8746-d13159349e4b', 'Accepted', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:26.315594+00', '2026-10-27 14:05:26.310429+00'),
	('fe23b206-586c-4514-95af-cc157a907c49', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'INS-2026-000018', 'INCOMING', 'LOT', 'ff2523c8-97a5-490f-a0ec-9a6282f4f47e', 'Lot BN-H26126', '[{"ok": true, "name": "Dimensional check vs drawing", "measured": "within tol."}, {"ok": true, "name": "Material / heat certificate matches lot", "measured": "within tol."}, {"ok": true, "name": "Visual & surface condition", "measured": "within tol."}, {"ok": true, "name": "Hardness / PMI (if specified)", "measured": "within tol."}]', 'PASSED', '70be426a-d46c-4936-8746-d13159349e4b', 'Accepted', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:26.330327+00', '2026-10-27 14:05:26.3248+00'),
	('09bb7629-0b0b-4266-810f-88b2bff1b610', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'INS-2026-000019', 'INCOMING', 'LOT', 'eebe2eea-b930-4d79-829a-bd637b413497', 'Lot BN-H26133', '[{"ok": true, "name": "Dimensional check vs drawing", "measured": "within tol."}, {"ok": true, "name": "Material / heat certificate matches lot", "measured": "within tol."}, {"ok": true, "name": "Visual & surface condition", "measured": "within tol."}, {"ok": true, "name": "Hardness / PMI (if specified)", "measured": "within tol."}]', 'PASSED', '70be426a-d46c-4936-8746-d13159349e4b', 'Accepted', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:26.344229+00', '2026-10-27 14:05:26.338615+00'),
	('120268c7-2eca-47a0-b098-c37db0487d6a', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'INS-2026-000020', 'FINAL', 'SERIAL', '4ec63d7c-4c91-4963-834e-c9837b80f2d6', 'PV-2026-00001', '[{"ok": true, "name": "Visual, marking & nameplate", "measured": "OK"}, {"ok": true, "name": "Face-to-face & end dimensions", "measured": "OK"}, {"ok": true, "name": "Seat & stem operation (torque)", "measured": "OK"}, {"ok": true, "name": "Tag / serial verified", "measured": "OK"}]', 'PASSED', NULL, 'Accepted', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:27.795461+00', '2026-10-27 14:05:27.789338+00'),
	('e4673cdf-e967-4311-8623-5407b2b7f4e5', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'INS-2026-000021', 'FINAL', 'SERIAL', '59f83746-e6fc-49f4-a77b-cb821493e11f', 'PV-2026-00002', '[{"ok": true, "name": "Visual, marking & nameplate", "measured": "OK"}, {"ok": true, "name": "Face-to-face & end dimensions", "measured": "OK"}, {"ok": true, "name": "Seat & stem operation (torque)", "measured": "OK"}, {"ok": true, "name": "Tag / serial verified", "measured": "OK"}]', 'PASSED', NULL, 'Accepted', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:27.848695+00', '2026-10-27 14:05:27.84346+00'),
	('b736570d-901e-4946-8426-3964a7d068ea', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'INS-2026-000022', 'FINAL', 'SERIAL', '4cb646d1-3878-4424-b41c-fdcf1caceca0', 'PV-2026-00003', '[{"ok": true, "name": "Visual, marking & nameplate", "measured": "OK"}, {"ok": true, "name": "Face-to-face & end dimensions", "measured": "OK"}, {"ok": true, "name": "Seat & stem operation (torque)", "measured": "OK"}, {"ok": true, "name": "Tag / serial verified", "measured": "OK"}]', 'PASSED', NULL, 'Accepted', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:27.901101+00', '2026-10-27 14:05:27.895717+00'),
	('8cfe765b-237a-4800-aece-9f296f9bd3c0', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'INS-2026-000023', 'FINAL', 'SERIAL', '400708e9-52e1-4214-b07c-c7837dbeeb2c', 'PV-2026-00004', '[{"ok": true, "name": "Visual, marking & nameplate", "measured": "OK"}, {"ok": true, "name": "Face-to-face & end dimensions", "measured": "OK"}, {"ok": true, "name": "Seat & stem operation (torque)", "measured": "OK"}, {"ok": true, "name": "Tag / serial verified", "measured": "OK"}]', 'PASSED', NULL, 'Accepted', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:27.955752+00', '2026-10-27 14:05:27.949945+00'),
	('7d813395-dd05-4c6c-8940-3e1684a1466e', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'INS-2026-000024', 'FINAL', 'SERIAL', 'f287ea25-7179-4e4d-a695-4bb1414938da', 'PV-2026-00005', '[{"ok": true, "name": "Visual, marking & nameplate", "measured": "OK"}, {"ok": true, "name": "Face-to-face & end dimensions", "measured": "OK"}, {"ok": true, "name": "Seat & stem operation (torque)", "measured": "OK"}, {"ok": true, "name": "Tag / serial verified", "measured": "OK"}]', 'PASSED', NULL, 'Accepted', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.008882+00', '2026-10-27 14:05:28.003123+00'),
	('f55e5a5f-3f03-49d3-a9d0-db3d5e60164c', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'INS-2026-000025', 'FINAL', 'SERIAL', 'e612e4b3-497c-470c-8396-74a36728f675', 'PV-2026-00008', '[{"ok": true, "name": "Visual, marking & nameplate", "measured": "OK"}, {"ok": true, "name": "Face-to-face & end dimensions", "measured": "OK"}, {"ok": true, "name": "Seat & stem operation (torque)", "measured": "OK"}, {"ok": true, "name": "Tag / serial verified", "measured": "OK"}]', 'PASSED', NULL, 'Accepted', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.058682+00', '2026-10-27 14:05:28.052822+00'),
	('998e04ec-a402-4631-b5a2-3cb33c304d8a', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'INS-2026-000026', 'FINAL', 'SERIAL', '326a1502-8dcd-4de5-acf8-f5b56b4ec57c', 'PV-2026-00009', '[{"ok": true, "name": "Visual, marking & nameplate", "measured": "OK"}, {"ok": true, "name": "Face-to-face & end dimensions", "measured": "OK"}, {"ok": true, "name": "Seat & stem operation (torque)", "measured": "OK"}, {"ok": true, "name": "Tag / serial verified", "measured": "OK"}]', 'PASSED', NULL, 'Accepted', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.106887+00', '2026-10-27 14:05:28.101486+00'),
	('f32264de-e8d9-45a3-b13b-8726dbc71466', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'INS-2026-000027', 'FINAL', 'SERIAL', 'c8b7b4fb-6148-494b-990d-b2b14b6350b3', 'PV-2026-00014', '[{"ok": true, "name": "Visual, marking & nameplate", "measured": "OK"}, {"ok": true, "name": "Face-to-face & end dimensions", "measured": "OK"}, {"ok": true, "name": "Seat & stem operation (torque)", "measured": "OK"}, {"ok": true, "name": "Tag / serial verified", "measured": "OK"}]', 'PASSED', NULL, 'Accepted', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.156346+00', '2026-10-27 14:05:28.150758+00'),
	('b3ad121e-3f59-408c-aae1-f466df76f001', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'INS-2026-000028', 'FINAL', 'SERIAL', '451711cb-bdb5-46aa-a135-e7bb6ce9a477', 'PV-2026-00015', '[{"ok": true, "name": "Visual, marking & nameplate", "measured": "OK"}, {"ok": true, "name": "Face-to-face & end dimensions", "measured": "OK"}, {"ok": true, "name": "Seat & stem operation (torque)", "measured": "OK"}, {"ok": true, "name": "Tag / serial verified", "measured": "OK"}]', 'PASSED', NULL, 'Accepted', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.206274+00', '2026-10-27 14:05:28.200994+00'),
	('f31a502e-5baf-460b-9479-534447534a74', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'INS-2026-000029', 'FINAL', 'SERIAL', '1f31d15f-0bf3-45b3-991b-db09ef7af236', 'PV-2026-00018', '[{"ok": true, "name": "Visual, marking & nameplate", "measured": "OK"}, {"ok": true, "name": "Face-to-face & end dimensions", "measured": "OK"}, {"ok": true, "name": "Seat & stem operation (torque)", "measured": "OK"}, {"ok": true, "name": "Tag / serial verified", "measured": "OK"}]', 'PASSED', NULL, 'Accepted', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.261784+00', '2026-10-27 14:05:28.25493+00'),
	('63458516-afb6-4e56-aa47-c0f2dded7761', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'INS-2026-000030', 'FINAL', 'SERIAL', '92d9db2b-a78c-4256-bbf9-24dfafbec521', 'PV-2026-00019', '[{"ok": true, "name": "Visual, marking & nameplate", "measured": "OK"}, {"ok": true, "name": "Face-to-face & end dimensions", "measured": "OK"}, {"ok": true, "name": "Seat & stem operation (torque)", "measured": "OK"}, {"ok": true, "name": "Tag / serial verified", "measured": "OK"}]', 'PASSED', NULL, 'Accepted', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.329163+00', '2026-10-27 14:05:28.321982+00'),
	('353e62d6-f468-4b38-be73-3117b26056b5', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'INS-2026-000031', 'FINAL', 'SERIAL', 'b23230f2-f025-43ed-82dc-75a1c78a3ea1', 'PV-2026-00020', '[{"ok": true, "name": "Visual, marking & nameplate", "measured": "OK"}, {"ok": true, "name": "Face-to-face & end dimensions", "measured": "OK"}, {"ok": true, "name": "Seat & stem operation (torque)", "measured": "OK"}, {"ok": true, "name": "Tag / serial verified", "measured": "OK"}]', 'PASSED', NULL, 'Accepted', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.390951+00', '2026-10-27 14:05:28.384264+00'),
	('f8b7831f-d61b-44c9-b3db-93e60d8af5fd', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'INS-2026-000032', 'FINAL', 'SERIAL', '6140c882-132d-428a-9759-c01123be0297', 'PV-2026-00021', '[{"ok": true, "name": "Visual, marking & nameplate", "measured": "OK"}, {"ok": true, "name": "Face-to-face & end dimensions", "measured": "OK"}, {"ok": true, "name": "Seat & stem operation (torque)", "measured": "OK"}, {"ok": true, "name": "Tag / serial verified", "measured": "OK"}]', 'PASSED', NULL, 'Accepted', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.447289+00', '2026-10-27 14:05:28.441931+00'),
	('e4ee5236-ce7e-440b-85b5-3a2f323086bb', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'INS-2026-000033', 'FINAL', 'SERIAL', '25dd99d8-20bf-48f8-bece-c7e4f0bf1514', 'PV-2026-00010', '[{"ok": true, "name": "Visual, marking & nameplate", "measured": "OK"}, {"ok": true, "name": "Face-to-face & end dimensions", "measured": "OK"}, {"ok": true, "name": "Seat & stem operation (torque)", "measured": "OK"}, {"ok": true, "name": "Tag / serial verified", "measured": "OK"}]', 'PASSED', NULL, 'Accepted', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.561811+00', '2026-10-27 14:05:28.556334+00'),
	('a5f11fbd-2b9d-4203-ba04-662a204a20a4', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'INS-2026-000034', 'FINAL', 'SERIAL', 'a54cf213-c4dd-4f12-a524-d401753e81b5', 'PV-2026-00016', '[{"ok": true, "name": "Visual, marking & nameplate", "measured": "OK"}, {"ok": true, "name": "Face-to-face & end dimensions", "measured": "OK"}, {"ok": true, "name": "Seat & stem operation (torque)", "measured": "OK"}, {"ok": true, "name": "Tag / serial verified", "measured": "OK"}]', 'PASSED', NULL, 'Accepted', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.587821+00', '2026-10-27 14:05:28.582184+00'),
	('4f79c4f3-fcac-45e9-94c8-b2def51cf8f0', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'INS-2026-000035', 'FINAL', 'SERIAL', 'afdd35b7-be62-4847-a82c-64b8ddf1b75f', 'PV-2026-00017', '[{"ok": true, "name": "Visual, marking & nameplate", "measured": "OK"}, {"ok": true, "name": "Face-to-face & end dimensions", "measured": "OK"}, {"ok": true, "name": "Seat & stem operation (torque)", "measured": "OK"}, {"ok": true, "name": "Tag / serial verified", "measured": "OK"}]', 'PASSED', NULL, 'Accepted', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.632369+00', '2026-10-27 14:05:28.627368+00');


--
-- Data for Name: integration_events; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.integration_events VALUES
	('fedbfe28-c10f-4667-8efa-fe029a7ef8ea', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'ACCOUNTING', 'OUTBOUND', 'invoice.post', 'INV-SYNC-0001', 'INV-SYNC-0001', '{}', 'OK', NULL, 1, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:29.311885+00', '2026-10-27 14:05:29.311885+00'),
	('06c91cfc-3836-44c3-a8be-f1aae73f2b88', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'ACCOUNTING', 'OUTBOUND', 'invoice.post', 'INV-SYNC-0002', 'INV-SYNC-0002', '{}', 'OK', NULL, 1, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:29.318397+00', '2026-10-27 14:05:29.318397+00'),
	('b04d1b1d-4747-49e4-b9e7-ce946e7f7659', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'WEBSITE', 'OUTBOUND', 'inquiry.import', 'WEB-INQ-5521', 'WEB-INQ-5521', '{}', 'OK', NULL, 1, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:29.32353+00', '2026-10-27 14:05:29.32353+00'),
	('7c6ce99b-173c-47e7-b6d1-60b192658815', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'EMAIL', 'OUTBOUND', 'quote.sent', 'MAIL-QUO-0014', 'MAIL-QUO-0014', '{}', 'OK', NULL, 1, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:29.328524+00', '2026-10-27 14:05:29.328524+00'),
	('f6a0508d-aedf-41c7-8d56-6a265c93e079', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'CUSTOMER_PORTAL', 'OUTBOUND', 'order.status', 'PORTAL-SO-0007', 'PORTAL-SO-0007', '{}', 'OK', NULL, 1, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:29.333493+00', '2026-10-27 14:05:29.333493+00'),
	('c5f58498-403e-4d41-a290-2649c8346243', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SUPPLIER_EDI', 'OUTBOUND', 'po.confirm', 'EDI-PO-0003', 'EDI-PO-0003', '{}', 'OK', NULL, 1, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:29.338253+00', '2026-10-27 14:05:29.338253+00'),
	('c3529a34-a42d-43ff-b1c2-a18464172a63', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SUPPLIER_EDI', 'OUTBOUND', 'po.confirm', 'EDI-PO-0009', 'EDI-PO-0009', '{}', 'FAILED', 'Supplier endpoint returned 401 — credentials expired', 1, NULL, '2026-10-27 14:05:29.348447+00', '2026-10-27 14:05:29.348447+00'),
	('5581d443-f815-41d8-b42f-b63268e35b3f', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'ACCOUNTING', 'OUTBOUND', 'invoice.post', 'INV-SYNC-0003', 'INV-SYNC-0003', '{}', 'RETRIED', NULL, 2, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:29.343925+00', '2026-10-27 14:05:29.354347+00');


--
-- Data for Name: invoices; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.invoices VALUES
	('b5b3c1d7-f38b-4cf8-a6fa-83982def8785', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'INV-2026-000001', '493d756e-cdfe-465c-884b-77f468f1f216', '84f16360-acd8-4658-a08c-5095e56335a6', 'PARTIALLY_PAID', 'INR', '2026-10-27', '2026-11-26', '29', false, 6525.00, 0.00, 0.00, 1174.50, 0.50, 7700.00, 3850.00, NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:28.975+00', '2026-10-27 14:05:29.019448+00', 4),
	('af319e29-79f3-42e0-8a7b-0f905462b0f1', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'INV-2026-000002', '4fe2d155-87cd-4e06-b9f7-8bd425bddc4d', 'bc2c7461-b1cd-4c66-8996-611e28098035', 'PAID', 'INR', '2026-10-27', '2026-11-26', '27', false, 4800.00, 0.00, 0.00, 864.00, 0.00, 5664.00, 5664.00, NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:29.084999+00', '2026-10-27 14:05:29.118455+00', 4),
	('a526920e-7321-4968-b2ca-ffa2b379e6d9', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'INV-2026-000003', 'e3cd7bb2-b68b-477b-9f79-65e38911aa9d', '0bbed72f-1aff-49df-867f-4201b53b165f', 'OVERDUE', 'INR', '2026-10-27', '2026-10-15', '27', false, 22892.00, 0.00, 0.00, 4120.56, 0.44, 27013.00, 0.00, NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:29.129413+00', '2026-10-27 14:05:29.161616+00', 5);


--
-- Data for Name: invoice_lines; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.invoice_lines VALUES
	('071f6634-5bab-46da-829d-3ed8325e9a90', 'b5b3c1d7-f38b-4cf8-a6fa-83982def8785', 1, '6e212887-960b-4eed-ade6-18715e05c5cb', 'PV-BV-050 — Ball Valve 50mm SS316', NULL, 3.000, 2100.0000, 18.00, 5985.00, 1077.30, 7062.30),
	('847596e1-8426-4ab5-99e5-483bb1249d7f', 'b5b3c1d7-f38b-4cf8-a6fa-83982def8785', 2, 'abe0ed52-e0fd-424a-b2d4-00c1c625767f', 'PV-SEAT-01 — PTFE Seat Ring', NULL, 3.000, 180.0000, 18.00, 540.00, 97.20, 637.20),
	('69995897-a3e1-4f1b-9731-a1e563eac931', 'af319e29-79f3-42e0-8a7b-0f905462b0f1', 1, '92a93794-1287-4b7d-8868-7b9b81b87cb2', 'PV-CV-050 — Check Valve 50mm SS316', NULL, 2.000, 2400.0000, 18.00, 4800.00, 864.00, 5664.00),
	('74cb77f9-b34d-4aa0-87c9-8e6fddf223ab', 'a526920e-7321-4968-b2ca-ffa2b379e6d9', 1, 'eb07eab2-eba7-4b97-88f8-9066662e9a5e', 'PV-GV-080 — Gate Valve 80mm CF8M', NULL, 4.000, 5900.0000, 18.00, 22892.00, 4120.56, 27012.56);


--
-- Data for Name: jobs; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: material_lots; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.material_lots VALUES
	('b0650c06-a99d-4de4-b7f8-088489f58662', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'BN-H26119', '2488bae2-79d6-4ce2-95c8-385344da703b', '4beb637f-1b4c-4c99-9821-18432f34c3d8', '25c5720f-01ba-401d-be7c-1cd37e709753', 'BN-H26119', 'MTC-BN-H26119 (EN 10204 3.1)', 20.000, 20.000, NULL, 'RELEASED', '2026-10-27 14:05:25.994935+00', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a'),
	('ff2523c8-97a5-490f-a0ec-9a6282f4f47e', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'BN-H26126', '2488bae2-79d6-4ce2-95c8-385344da703b', '4beb637f-1b4c-4c99-9821-18432f34c3d8', '25c5720f-01ba-401d-be7c-1cd37e709753', 'BN-H26126', 'MTC-BN-H26126 (EN 10204 3.1)', 20.000, 20.000, NULL, 'RELEASED', '2026-10-27 14:05:25.994935+00', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a'),
	('eebe2eea-b930-4d79-829a-bd637b413497', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'BN-H26133', '2488bae2-79d6-4ce2-95c8-385344da703b', '4beb637f-1b4c-4c99-9821-18432f34c3d8', '25c5720f-01ba-401d-be7c-1cd37e709753', 'BN-H26133', 'MTC-BN-H26133 (EN 10204 3.1)', 20.000, 20.000, NULL, 'RELEASED', '2026-10-27 14:05:25.994935+00', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a'),
	('c34442e4-29f2-4d70-9ce7-ed440cde9a9b', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'BD-H26138', 'd14a8056-467a-425a-a517-b0f08e05e8ec', 'd52968f6-fca2-437d-afc4-74883a4a0540', 'e1d2578b-4bf7-4a4c-8fab-6e13f71549eb', 'BD-H26138', 'MTC-BD-H26138 (EN 10204 3.1)', 20.000, 0.000, NULL, 'REJECTED', '2026-10-27 14:05:25.705063+00', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a'),
	('a72dcfd1-1cf8-4783-9663-76c21c970d92', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'ST-H26124', '961b2013-58fb-45fb-8a7c-618c84887c18', '4beb637f-1b4c-4c99-9821-18432f34c3d8', '39849164-7e5a-4cf4-a7c0-51985752ccf4', 'ST-H26124', 'MTC-ST-H26124 (EN 10204 3.1)', 20.000, 7.000, NULL, 'RELEASED', '2026-10-27 14:05:25.807881+00', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a'),
	('99680ed9-90e9-4b14-b7fa-eb66f3d6007b', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SE-H26138', 'abe0ed52-e0fd-424a-b2d4-00c1c625767f', 'f010fc14-ae10-4f2b-8f3d-0555bc31309c', '2d427e21-6868-4293-848c-907d2ecb3544', 'SE-H26138', 'MTC-SE-H26138 (EN 10204 3.1)', 20.000, 20.000, NULL, 'QUARANTINE', '2026-10-27 14:05:25.900835+00', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a'),
	('b96945db-8342-48f5-ae0b-57d0bcf25eb4', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'BN-H26140', '2488bae2-79d6-4ce2-95c8-385344da703b', '4beb637f-1b4c-4c99-9821-18432f34c3d8', '25c5720f-01ba-401d-be7c-1cd37e709753', 'BN-H26140', 'MTC-BN-H26140 (EN 10204 3.1)', 20.000, 20.000, NULL, 'QUARANTINE', '2026-10-27 14:05:25.994935+00', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a'),
	('17c99f4c-ed79-4499-b523-8576198201fc', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'ST-H26138', '961b2013-58fb-45fb-8a7c-618c84887c18', '4beb637f-1b4c-4c99-9821-18432f34c3d8', '39849164-7e5a-4cf4-a7c0-51985752ccf4', 'ST-H26138', 'MTC-ST-H26138 (EN 10204 3.1)', 20.000, 20.000, NULL, 'QUARANTINE', '2026-10-27 14:05:25.807881+00', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a'),
	('d7bf700f-7b18-4e2b-b49b-b4a40562d9b0', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SE-H26110', 'abe0ed52-e0fd-424a-b2d4-00c1c625767f', 'f010fc14-ae10-4f2b-8f3d-0555bc31309c', '2d427e21-6868-4293-848c-907d2ecb3544', 'SE-H26110', 'MTC-SE-H26110 (EN 10204 3.1)', 20.000, 20.000, NULL, 'RELEASED', '2026-10-27 14:05:25.900835+00', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a'),
	('ac69d498-8678-482a-a1f8-b88b8aa5ff2d', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SE-H26117', 'abe0ed52-e0fd-424a-b2d4-00c1c625767f', 'f010fc14-ae10-4f2b-8f3d-0555bc31309c', '2d427e21-6868-4293-848c-907d2ecb3544', 'SE-H26117', 'MTC-SE-H26117 (EN 10204 3.1)', 20.000, 20.000, NULL, 'RELEASED', '2026-10-27 14:05:25.900835+00', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a'),
	('d1d4171d-c2fb-4670-9e30-492d79057522', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SE-H26124', 'abe0ed52-e0fd-424a-b2d4-00c1c625767f', 'f010fc14-ae10-4f2b-8f3d-0555bc31309c', '2d427e21-6868-4293-848c-907d2ecb3544', 'SE-H26124', 'MTC-SE-H26124 (EN 10204 3.1)', 20.000, 20.000, NULL, 'RELEASED', '2026-10-27 14:05:25.900835+00', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a'),
	('f68863e2-74c6-4938-a665-6b13c9844f68', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SE-H26131', 'abe0ed52-e0fd-424a-b2d4-00c1c625767f', 'f010fc14-ae10-4f2b-8f3d-0555bc31309c', '2d427e21-6868-4293-848c-907d2ecb3544', 'SE-H26131', 'MTC-SE-H26131 (EN 10204 3.1)', 20.000, 20.000, NULL, 'RELEASED', '2026-10-27 14:05:25.900835+00', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a'),
	('a3951547-845b-4e82-97bb-5f68f0b32aaa', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'BN-H26112', '2488bae2-79d6-4ce2-95c8-385344da703b', '4beb637f-1b4c-4c99-9821-18432f34c3d8', '25c5720f-01ba-401d-be7c-1cd37e709753', 'BN-H26112', 'MTC-BN-H26112 (EN 10204 3.1)', 20.000, 20.000, NULL, 'RELEASED', '2026-10-27 14:05:25.994935+00', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a'),
	('048db9a3-8ba6-4d10-bd7b-58a7f4d5f0f2', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'BD-H26131', 'd14a8056-467a-425a-a517-b0f08e05e8ec', 'd52968f6-fca2-437d-afc4-74883a4a0540', 'e1d2578b-4bf7-4a4c-8fab-6e13f71549eb', 'BD-H26131', 'MTC-BD-H26131 (EN 10204 3.1)', 20.000, 5.000, NULL, 'RELEASED', '2026-10-27 14:05:25.705063+00', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a'),
	('0120e309-58a4-4109-8fc0-3d73ec38cb1e', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'ST-H26131', '961b2013-58fb-45fb-8a7c-618c84887c18', '4beb637f-1b4c-4c99-9821-18432f34c3d8', '39849164-7e5a-4cf4-a7c0-51985752ccf4', 'ST-H26131', 'MTC-ST-H26131 (EN 10204 3.1)', 20.000, 5.000, NULL, 'RELEASED', '2026-10-27 14:05:25.807881+00', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a'),
	('95d5f8ff-3e0e-4e8c-83a3-5a2302d2179c', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'BD-H26110', 'd14a8056-467a-425a-a517-b0f08e05e8ec', 'd52968f6-fca2-437d-afc4-74883a4a0540', 'e1d2578b-4bf7-4a4c-8fab-6e13f71549eb', 'BD-H26110', 'MTC-BD-H26110 (EN 10204 3.1)', 20.000, 7.000, NULL, 'RELEASED', '2026-10-27 14:05:25.705063+00', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a'),
	('4f97209e-2450-473b-9fa2-202f7f292a52', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'ST-H26110', '961b2013-58fb-45fb-8a7c-618c84887c18', '4beb637f-1b4c-4c99-9821-18432f34c3d8', '39849164-7e5a-4cf4-a7c0-51985752ccf4', 'ST-H26110', 'MTC-ST-H26110 (EN 10204 3.1)', 20.000, 7.000, NULL, 'RELEASED', '2026-10-27 14:05:25.807881+00', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a'),
	('58a3b02d-323f-4467-98e1-e7a6fa301605', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'BD-H26117', 'd14a8056-467a-425a-a517-b0f08e05e8ec', 'd52968f6-fca2-437d-afc4-74883a4a0540', 'e1d2578b-4bf7-4a4c-8fab-6e13f71549eb', 'BD-H26117', 'MTC-BD-H26117 (EN 10204 3.1)', 20.000, 3.000, NULL, 'RELEASED', '2026-10-27 14:05:25.705063+00', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a'),
	('5f814b84-9601-463b-a2e3-30d480bf2957', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'ST-H26117', '961b2013-58fb-45fb-8a7c-618c84887c18', '4beb637f-1b4c-4c99-9821-18432f34c3d8', '39849164-7e5a-4cf4-a7c0-51985752ccf4', 'ST-H26117', 'MTC-ST-H26117 (EN 10204 3.1)', 20.000, 3.000, NULL, 'RELEASED', '2026-10-27 14:05:25.807881+00', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a'),
	('6b284d86-e253-4eb6-8042-ffff725e5290', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'BD-H26124', 'd14a8056-467a-425a-a517-b0f08e05e8ec', 'd52968f6-fca2-437d-afc4-74883a4a0540', 'e1d2578b-4bf7-4a4c-8fab-6e13f71549eb', 'BD-H26124', 'MTC-BD-H26124 (EN 10204 3.1)', 20.000, 7.000, NULL, 'RELEASED', '2026-10-27 14:05:25.705063+00', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a');


--
-- Data for Name: material_requirements; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.material_requirements VALUES
	('ec0dd327-46e6-4cfb-8fd1-b686da6d3c34', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'MR-2026-000001', '84f16360-acd8-4658-a08c-5095e56335a6', '6e212887-960b-4eed-ade6-18715e05c5cb', 3.000, 13.000, 0.000, 0.000, 0.000, 'COVERED', '2026-10-27 14:05:24.889812+00', '2026-10-27 14:05:24.889812+00', 1),
	('1064d42a-c2bf-46ea-9cce-236b5337141d', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'MR-2026-000002', '84f16360-acd8-4658-a08c-5095e56335a6', 'abe0ed52-e0fd-424a-b2d4-00c1c625767f', 3.000, 40.000, 0.000, 0.000, 0.000, 'COVERED', '2026-10-27 14:05:24.889812+00', '2026-10-27 14:05:24.889812+00', 1),
	('64ac6858-af35-4f5b-950d-beebe22be6da', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'MR-2026-000003', '0bbed72f-1aff-49df-867f-4201b53b165f', 'eb07eab2-eba7-4b97-88f8-9066662e9a5e', 4.000, 0.000, 0.000, 0.000, 4.000, 'OPEN', '2026-10-27 14:05:24.953594+00', '2026-10-27 14:05:24.953594+00', 1),
	('552ecca7-4971-44f9-b2f8-febfd75692c6', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'MR-2026-000004', '08c81785-76c6-4ce9-9c02-f0d075c9befc', '82048a24-aa7e-422f-bee0-1642d75bd996', 3.000, 0.000, 0.000, 0.000, 3.000, 'OPEN', '2026-10-27 14:05:25.01735+00', '2026-10-27 14:05:25.01735+00', 1),
	('aa4af2a2-3dd0-4c8f-a8a1-c930e9f7a4dd', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'MR-2026-000005', '5150e791-ad57-45a1-9173-962ee330f78f', '77a428fe-4dd9-4a6e-8138-36a5f4efc6b2', 3.000, 0.000, 0.000, 0.000, 3.000, 'OPEN', '2026-10-27 14:05:25.072563+00', '2026-10-27 14:05:25.072563+00', 1),
	('ef39999b-7af5-49e2-b351-a68f35cf80d0', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'MR-2026-000006', 'bc2c7461-b1cd-4c66-8996-611e28098035', '92a93794-1287-4b7d-8868-7b9b81b87cb2', 2.000, 0.000, 0.000, 0.000, 2.000, 'OPEN', '2026-10-27 14:05:25.125237+00', '2026-10-27 14:05:25.125237+00', 1),
	('145e7f02-1046-4016-bb5e-60bdc9d85bfc', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'MR-2026-000007', 'd7896924-f01a-474e-afe1-ef33836afd2f', '6f56aa1e-de31-44a5-b842-756c12aa7646', 2.000, 0.000, 0.000, 0.000, 2.000, 'OPEN', '2026-10-27 14:05:25.178283+00', '2026-10-27 14:05:25.178283+00', 1),
	('5e1cf301-10e9-4ade-832e-45346f2de1f9', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'MR-2026-000008', '498e3f4d-22ff-4b1e-a1ab-43e37332b591', '9152c8e7-6ed4-495d-a58c-ee509367659f', 4.000, 0.000, 0.000, 0.000, 4.000, 'OPEN', '2026-10-27 14:05:25.232856+00', '2026-10-27 14:05:25.232856+00', 1),
	('d79db314-daeb-4e74-93a3-8c712eaf671f', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'MR-2026-000009', '4e36052e-0a7c-47ae-94dd-8c74ff17ee6e', 'd61fe768-7f6e-4d65-b1f1-6f5621e2008b', 2.000, 0.000, 0.000, 0.000, 2.000, 'OPEN', '2026-10-27 14:05:25.286585+00', '2026-10-27 14:05:25.286585+00', 1),
	('de547ab1-99ee-46b2-aabb-4f24adc78002', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'MR-2026-000010', 'c8daa3b5-bd9e-41fe-83ca-f53a2138d16d', '65e1cab5-04f9-4e45-9081-e07e65803ba9', 2.000, 0.000, 0.000, 0.000, 2.000, 'OPEN', '2026-10-27 14:05:25.340546+00', '2026-10-27 14:05:25.340546+00', 1),
	('eee30869-48d1-41aa-9b68-010231bfcfc9', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'MR-2026-000011', '17faff62-40d5-4b82-a2bb-e6c64e3162be', '6f56aa1e-de31-44a5-b842-756c12aa7646', 6.000, 0.000, 0.000, 0.000, 6.000, 'OPEN', '2026-10-27 14:05:25.397066+00', '2026-10-27 14:05:25.397066+00', 1),
	('193d8e0c-9441-4432-8a21-c04df2217946', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'MR-2026-000012', '23f877c9-0add-44dc-b617-5e7e48c1e841', '65e1cab5-04f9-4e45-9081-e07e65803ba9', 4.000, 0.000, 0.000, 0.000, 4.000, 'OPEN', '2026-10-27 14:05:25.448918+00', '2026-10-27 14:05:25.448918+00', 1),
	('00d27bd4-175d-4a12-8e64-761ec08e8384', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'MR-2026-000013', 'afc38366-3c26-4a27-a1cc-e811550d9b5c', '82048a24-aa7e-422f-bee0-1642d75bd996', 10.000, 0.000, 0.000, 0.000, 10.000, 'OPEN', '2026-10-27 14:05:25.499541+00', '2026-10-27 14:05:25.499541+00', 1);


--
-- Data for Name: nonconformances; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.nonconformances VALUES
	('ee7687e3-e02c-465d-a813-ac84ce80c248', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'NCR-2026-000001', 'INSPECTION', 'aa3bd83d-a31c-43bb-90c2-c211ab496716', 'Lot BD-H26138', 'INCOMING inspection INS-2026-000005 failed: Hardness / PMI (if specified)', 1.000, 'APPROVED', 'SCRAP', 'Hardness out of spec — scrap, claim from supplier', '693a2518-49d6-4f23-8d7c-089491e70217', '6b544707-dfa2-4b3b-8cf6-5d69641b903c', '2026-10-27 14:05:26.364328+00', '2026-10-27 14:05:26.147745+00', NULL),
	('5b8a78a2-c076-4e63-8c39-83211b4861f0', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'NCR-2026-000002', 'INSPECTION', 'd939dc57-b405-45d5-9bdc-bf74386b6c8c', 'Lot ST-H26138', 'INCOMING inspection INS-2026-000010 failed: Hardness / PMI (if specified)', 1.000, 'PENDING_APPROVAL', 'RETURN_TO_SUPPLIER', 'Return batch to supplier for re-heat-treatment', '693a2518-49d6-4f23-8d7c-089491e70217', NULL, NULL, '2026-10-27 14:05:26.221683+00', NULL),
	('afe88422-33b9-4c6d-8e5c-0b25caf7bf98', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'NCR-2026-000003', 'TEST', 'aadedcfe-763b-415f-974a-9ee47e39b3e2', 'PV-2026-00010', 'SEAT_LEAK test TST-2026-000041 failed on PV-2026-00010 (allowable Max 0 bubbles/min (ISO 5208 Rate A), measured 12 bubbles/min)', 1.000, 'APPROVED', 'RETEST', 'Seat re-lapped; retest after cleaning seat face', '693a2518-49d6-4f23-8d7c-089491e70217', '6b544707-dfa2-4b3b-8cf6-5d69641b903c', '2026-10-27 14:05:28.529462+00', '2026-10-27 14:05:28.506525+00', NULL),
	('e575d512-297e-47e7-8acb-49055bf63283', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'NCR-2026-000004', 'TEST', '232602e7-5a1f-470f-8feb-ef489f3e3cc5', 'PV-2026-00016', 'SEAT_LEAK test TST-2026-000045 failed on PV-2026-00016 (allowable Max 0 bubbles/min (ISO 5208 Rate A), measured 12 bubbles/min)', 1.000, 'OPEN', NULL, NULL, '693a2518-49d6-4f23-8d7c-089491e70217', NULL, NULL, '2026-10-27 14:05:28.604262+00', NULL);


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.notifications VALUES
	(1, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'material_shortage', 'Material shortage: Gate Valve 80mm CF8M', '4 units short for order', '/inventory', false, '2026-10-27 14:05:24.953594+00'),
	(2, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'material_shortage', 'Material shortage: Ball Valve 25mm SS316', '3 units short for order', '/inventory', false, '2026-10-27 14:05:25.01735+00'),
	(3, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'material_shortage', 'Material shortage: Globe Valve 50mm SS316', '3 units short for order', '/inventory', false, '2026-10-27 14:05:25.072563+00'),
	(4, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'material_shortage', 'Material shortage: Check Valve 50mm SS316', '2 units short for order', '/inventory', false, '2026-10-27 14:05:25.125237+00'),
	(5, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'material_shortage', 'Material shortage: Ball Valve 100mm CF8M', '2 units short for order', '/inventory', false, '2026-10-27 14:05:25.178283+00'),
	(6, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'material_shortage', 'Material shortage: Gate Valve 150mm CF8M', '4 units short for order', '/inventory', false, '2026-10-27 14:05:25.232856+00'),
	(7, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'material_shortage', 'Material shortage: Gate Valve 50mm WCB', '2 units short for order', '/inventory', false, '2026-10-27 14:05:25.286585+00'),
	(8, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'material_shortage', 'Material shortage: Butterfly Valve 200mm', '2 units short for order', '/inventory', false, '2026-10-27 14:05:25.340546+00'),
	(9, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'material_shortage', 'Material shortage: Ball Valve 100mm CF8M', '6 units short for order', '/inventory', false, '2026-10-27 14:05:25.397066+00'),
	(10, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'material_shortage', 'Material shortage: Butterfly Valve 200mm', '4 units short for order', '/inventory', false, '2026-10-27 14:05:25.448918+00'),
	(11, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'material_shortage', 'Material shortage: Ball Valve 25mm SS316', '10 units short for order', '/inventory', false, '2026-10-27 14:05:25.499541+00');


--
-- Data for Name: number_sequences; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.number_sequences VALUES
	('4a0f88e6-467f-406c-a37b-fde4abff9898', 'SHP', '2026', 'SHP', 6, 8),
	('4a0f88e6-467f-406c-a37b-fde4abff9898', 'SC', '2026', 'SC', 6, 10),
	('4a0f88e6-467f-406c-a37b-fde4abff9898', 'DRW', '2026', 'DRW', 6, 9),
	('4a0f88e6-467f-406c-a37b-fde4abff9898', 'PAY', '2026', 'PAY', 6, 2),
	('4a0f88e6-467f-406c-a37b-fde4abff9898', 'INV', '2026', 'INV', 6, 3),
	('4a0f88e6-467f-406c-a37b-fde4abff9898', 'ECN', '2026', 'ECN', 6, 3),
	('4a0f88e6-467f-406c-a37b-fde4abff9898', 'SUPP', '2026', 'SUPP', 6, 8),
	('4a0f88e6-467f-406c-a37b-fde4abff9898', 'EXC', '2026', 'EXC', 6, 8),
	('4a0f88e6-467f-406c-a37b-fde4abff9898', 'CUST', '2026', 'CUST', 6, 14),
	('4a0f88e6-467f-406c-a37b-fde4abff9898', 'SO', '2026', 'SO', 6, 12),
	('4a0f88e6-467f-406c-a37b-fde4abff9898', 'PROJ', '2026', 'PROJ', 6, 12),
	('4a0f88e6-467f-406c-a37b-fde4abff9898', 'ER', '2026', 'ER', 6, 12),
	('4a0f88e6-467f-406c-a37b-fde4abff9898', 'MR', '2026', 'MR', 6, 13),
	('4a0f88e6-467f-406c-a37b-fde4abff9898', 'TASK', '2026', 'TASK', 6, 29),
	('4a0f88e6-467f-406c-a37b-fde4abff9898', 'QUO', '2026', 'QUO', 6, 16),
	('4a0f88e6-467f-406c-a37b-fde4abff9898', 'GRN', '2026', 'GRN', 6, 4),
	('4a0f88e6-467f-406c-a37b-fde4abff9898', 'PO', '2026', 'PO', 6, 6),
	('4a0f88e6-467f-406c-a37b-fde4abff9898', 'LEAD', '2026', 'LEAD', 6, 15),
	('4a0f88e6-467f-406c-a37b-fde4abff9898', 'NCR', '2026', 'NCR', 6, 4),
	('4a0f88e6-467f-406c-a37b-fde4abff9898', 'INS', '2026', 'INS', 6, 35),
	('4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST', '2026', 'TST', 6, 49),
	('4a0f88e6-467f-406c-a37b-fde4abff9898', 'WO', '2026', 'WO', 6, 15);


--
-- Data for Name: order_exceptions; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.order_exceptions VALUES
	('a8f06fcf-31c9-45d2-a340-e4907ea6209b', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'EXC-2026-000001', '08c81785-76c6-4ce9-9c02-f0d075c9befc', 'SHIPMENT_BLOCK', 'OPEN', 'Shipment SHP-2026-000004 blocked — Customer documents', NULL, NULL, NULL, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:28.797765+00', NULL),
	('da3cf987-a9da-47b3-a69d-9801b1bb0c5c', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'EXC-2026-000002', '4e36052e-0a7c-47ae-94dd-8c74ff17ee6e', 'SHIPMENT_BLOCK', 'OPEN', 'Shipment SHP-2026-000005 blocked — Credit check', NULL, NULL, NULL, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:28.826736+00', NULL),
	('81b48692-4430-4f2e-afea-13b087d93b9c', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'EXC-2026-000003', 'c8daa3b5-bd9e-41fe-83ca-f53a2138d16d', 'SHIPMENT_BLOCK', 'OPEN', 'Shipment SHP-2026-000006 blocked — Export clearance', NULL, NULL, NULL, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:28.857648+00', NULL),
	('c0911b8c-0902-467f-8155-1c32bdc77844', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'EXC-2026-000004', '5150e791-ad57-45a1-9173-962ee330f78f', 'SHIPMENT_BLOCK', 'OPEN', 'Shipment SHP-2026-000007 blocked — Quality release', NULL, NULL, NULL, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:28.890217+00', NULL),
	('16667dd9-e244-46c5-a29e-ec93612ee884', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'EXC-2026-000005', '08c81785-76c6-4ce9-9c02-f0d075c9befc', 'SPEC_CHANGE', 'OPEN', 'Flange standard on customer PO differs from quotation — clarification requested from customer', NULL, NULL, '0258e002-4154-48b4-ad1d-2195882841be', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:29.274862+00', NULL),
	('67503825-c983-4ad5-b80f-eb97ab216e29', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'EXC-2026-000006', '498e3f4d-22ff-4b1e-a1ab-43e37332b591', 'MATERIAL_SHORTAGE', 'OPEN', 'Gate valve 150mm: bodies not available; CF8M casting lead time 5 weeks', NULL, NULL, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:29.281099+00', NULL),
	('ff659da1-0648-4342-b626-506e233fe923', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'EXC-2026-000007', '5150e791-ad57-45a1-9173-962ee330f78f', 'LATE_SUPPLIER', 'RESOLVED', 'Heat-treatment consumables PO is 6 days late (Tamil Heat Treat Works)', 'EXPEDITE', '2026-11-10', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:29.287287+00', '2026-10-27 14:05:29.293755+00'),
	('73e28fc9-c840-42b8-b050-220c4a872ce4', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'EXC-2026-000008', '17faff62-40d5-4b82-a2bb-e6c64e3162be', 'OTHER', 'RESOLVED', 'Customer requested 1 week earlier delivery', 'DATE_CHANGE', '2026-11-24', '0258e002-4154-48b4-ad1d-2195882841be', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:29.29962+00', '2026-10-27 14:05:29.30502+00');


--
-- Data for Name: order_reviews; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.order_reviews VALUES
	('943b1045-c5c2-4271-a24c-704b179c04d7', '4a0f88e6-467f-406c-a37b-fde4abff9898', '84f16360-acd8-4658-a08c-5095e56335a6', true, true, true, true, true, true, true, NULL, '2026-11-26', '2026-10-27 14:05:26.381+00', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:26.381356+00'),
	('1578d84a-d48b-4930-b748-366e538d08e6', '4a0f88e6-467f-406c-a37b-fde4abff9898', '0bbed72f-1aff-49df-867f-4201b53b165f', true, true, true, true, true, true, true, 'Customer PO adds 1 spare seat kit — price confirmed', '2026-11-17', '2026-10-27 14:05:26.39+00', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:26.389914+00'),
	('8167c348-8e29-4b5c-a92f-1871bcedcfbd', '4a0f88e6-467f-406c-a37b-fde4abff9898', '08c81785-76c6-4ce9-9c02-f0d075c9befc', true, false, true, true, true, true, true, 'Flange standard on PO differs from quote (ANSI 150 vs PN16) — clarification requested', NULL, NULL, '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:26.398162+00'),
	('2f470764-bd5b-4c7f-b279-2b2e47a3fa14', '4a0f88e6-467f-406c-a37b-fde4abff9898', '5150e791-ad57-45a1-9173-962ee330f78f', true, true, true, true, true, false, false, 'Requested date needs expedited heat-treatment slot', NULL, NULL, '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:26.404273+00');


--
-- Data for Name: part_number_rules; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: part_numbers; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.payments VALUES
	('69f9cc5b-7af2-433a-bb98-8b4815923b1e', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PAY-2026-000001', '493d756e-cdfe-465c-884b-77f468f1f216', 3850.00, 'INR', 'BANK_TRANSFER', 'NEFT-DEMO-001', '2026-10-27', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:29.019448+00'),
	('ca51b05e-21e9-4085-93bc-4e3bce1331a2', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PAY-2026-000002', '4fe2d155-87cd-4e06-b9f7-8bd425bddc4d', 5664.00, 'INR', 'BANK_TRANSFER', 'NEFT-DEMO-401', '2026-10-27', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:29.118455+00');


--
-- Data for Name: payment_allocations; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.payment_allocations VALUES
	('267744e0-57b4-484e-b174-cd8d51da583e', '69f9cc5b-7af2-433a-bb98-8b4815923b1e', 'b5b3c1d7-f38b-4cf8-a6fa-83982def8785', 3850.00),
	('f9b06b80-c71b-4a30-b609-c12cd9cd1d04', 'ca51b05e-21e9-4085-93bc-4e3bce1331a2', 'af319e29-79f3-42e0-8a7b-0f905462b0f1', 5664.00);


--
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.permissions VALUES
	('lead.view', 'lead', 'view lead'),
	('lead.create', 'lead', 'create lead'),
	('lead.edit', 'lead', 'edit lead'),
	('lead.delete', 'lead', 'delete lead'),
	('lead.approve', 'lead', 'approve lead'),
	('lead.export', 'lead', 'export lead'),
	('lead.manage', 'lead', 'manage lead'),
	('company.view', 'company', 'view company'),
	('company.create', 'company', 'create company'),
	('company.edit', 'company', 'edit company'),
	('company.delete', 'company', 'delete company'),
	('company.approve', 'company', 'approve company'),
	('company.export', 'company', 'export company'),
	('company.manage', 'company', 'manage company'),
	('contact.view', 'contact', 'view contact'),
	('contact.create', 'contact', 'create contact'),
	('contact.edit', 'contact', 'edit contact'),
	('contact.delete', 'contact', 'delete contact'),
	('contact.approve', 'contact', 'approve contact'),
	('contact.export', 'contact', 'export contact'),
	('contact.manage', 'contact', 'manage contact'),
	('product.view', 'product', 'view product'),
	('product.create', 'product', 'create product'),
	('product.edit', 'product', 'edit product'),
	('product.delete', 'product', 'delete product'),
	('product.approve', 'product', 'approve product'),
	('product.export', 'product', 'export product'),
	('product.manage', 'product', 'manage product'),
	('partnumber.view', 'partnumber', 'view partnumber'),
	('partnumber.create', 'partnumber', 'create partnumber'),
	('partnumber.edit', 'partnumber', 'edit partnumber'),
	('partnumber.delete', 'partnumber', 'delete partnumber'),
	('partnumber.approve', 'partnumber', 'approve partnumber'),
	('partnumber.export', 'partnumber', 'export partnumber'),
	('partnumber.manage', 'partnumber', 'manage partnumber'),
	('quote.view', 'quote', 'view quote'),
	('quote.create', 'quote', 'create quote'),
	('quote.edit', 'quote', 'edit quote'),
	('quote.delete', 'quote', 'delete quote'),
	('quote.approve', 'quote', 'approve quote'),
	('quote.export', 'quote', 'export quote'),
	('quote.manage', 'quote', 'manage quote'),
	('order.view', 'order', 'view order'),
	('order.create', 'order', 'create order'),
	('order.edit', 'order', 'edit order'),
	('order.delete', 'order', 'delete order'),
	('order.approve', 'order', 'approve order'),
	('order.export', 'order', 'export order'),
	('order.manage', 'order', 'manage order'),
	('engineering.view', 'engineering', 'view engineering');
INSERT INTO public.permissions VALUES
	('engineering.create', 'engineering', 'create engineering'),
	('engineering.edit', 'engineering', 'edit engineering'),
	('engineering.delete', 'engineering', 'delete engineering'),
	('engineering.approve', 'engineering', 'approve engineering'),
	('engineering.export', 'engineering', 'export engineering'),
	('engineering.manage', 'engineering', 'manage engineering'),
	('drawing.view', 'drawing', 'view drawing'),
	('drawing.create', 'drawing', 'create drawing'),
	('drawing.edit', 'drawing', 'edit drawing'),
	('drawing.delete', 'drawing', 'delete drawing'),
	('drawing.approve', 'drawing', 'approve drawing'),
	('drawing.export', 'drawing', 'export drawing'),
	('drawing.manage', 'drawing', 'manage drawing'),
	('bom.view', 'bom', 'view bom'),
	('bom.create', 'bom', 'create bom'),
	('bom.edit', 'bom', 'edit bom'),
	('bom.delete', 'bom', 'delete bom'),
	('bom.approve', 'bom', 'approve bom'),
	('bom.export', 'bom', 'export bom'),
	('bom.manage', 'bom', 'manage bom'),
	('inventory.view', 'inventory', 'view inventory'),
	('inventory.create', 'inventory', 'create inventory'),
	('inventory.edit', 'inventory', 'edit inventory'),
	('inventory.delete', 'inventory', 'delete inventory'),
	('inventory.approve', 'inventory', 'approve inventory'),
	('inventory.export', 'inventory', 'export inventory'),
	('inventory.manage', 'inventory', 'manage inventory'),
	('mrp.view', 'mrp', 'view mrp'),
	('mrp.create', 'mrp', 'create mrp'),
	('mrp.edit', 'mrp', 'edit mrp'),
	('mrp.delete', 'mrp', 'delete mrp'),
	('mrp.approve', 'mrp', 'approve mrp'),
	('mrp.export', 'mrp', 'export mrp'),
	('mrp.manage', 'mrp', 'manage mrp'),
	('procurement.view', 'procurement', 'view procurement'),
	('procurement.create', 'procurement', 'create procurement'),
	('procurement.edit', 'procurement', 'edit procurement'),
	('procurement.delete', 'procurement', 'delete procurement'),
	('procurement.approve', 'procurement', 'approve procurement'),
	('procurement.export', 'procurement', 'export procurement'),
	('procurement.manage', 'procurement', 'manage procurement'),
	('grn.view', 'grn', 'view grn'),
	('grn.create', 'grn', 'create grn'),
	('grn.edit', 'grn', 'edit grn'),
	('grn.delete', 'grn', 'delete grn'),
	('grn.approve', 'grn', 'approve grn'),
	('grn.export', 'grn', 'export grn'),
	('grn.manage', 'grn', 'manage grn'),
	('project.view', 'project', 'view project'),
	('project.create', 'project', 'create project');
INSERT INTO public.permissions VALUES
	('project.edit', 'project', 'edit project'),
	('project.delete', 'project', 'delete project'),
	('project.approve', 'project', 'approve project'),
	('project.export', 'project', 'export project'),
	('project.manage', 'project', 'manage project'),
	('task.view', 'task', 'view task'),
	('task.create', 'task', 'create task'),
	('task.edit', 'task', 'edit task'),
	('task.delete', 'task', 'delete task'),
	('task.approve', 'task', 'approve task'),
	('task.export', 'task', 'export task'),
	('task.manage', 'task', 'manage task'),
	('invoice.view', 'invoice', 'view invoice'),
	('invoice.create', 'invoice', 'create invoice'),
	('invoice.edit', 'invoice', 'edit invoice'),
	('invoice.delete', 'invoice', 'delete invoice'),
	('invoice.approve', 'invoice', 'approve invoice'),
	('invoice.export', 'invoice', 'export invoice'),
	('invoice.manage', 'invoice', 'manage invoice'),
	('payment.view', 'payment', 'view payment'),
	('payment.create', 'payment', 'create payment'),
	('payment.edit', 'payment', 'edit payment'),
	('payment.delete', 'payment', 'delete payment'),
	('payment.approve', 'payment', 'approve payment'),
	('payment.export', 'payment', 'export payment'),
	('payment.manage', 'payment', 'manage payment'),
	('expense.view', 'expense', 'view expense'),
	('expense.create', 'expense', 'create expense'),
	('expense.edit', 'expense', 'edit expense'),
	('expense.delete', 'expense', 'delete expense'),
	('expense.approve', 'expense', 'approve expense'),
	('expense.export', 'expense', 'export expense'),
	('expense.manage', 'expense', 'manage expense'),
	('document.view', 'document', 'view document'),
	('document.create', 'document', 'create document'),
	('document.edit', 'document', 'edit document'),
	('document.delete', 'document', 'delete document'),
	('document.approve', 'document', 'approve document'),
	('document.export', 'document', 'export document'),
	('document.manage', 'document', 'manage document'),
	('report.view', 'report', 'view report'),
	('report.create', 'report', 'create report'),
	('report.edit', 'report', 'edit report'),
	('report.delete', 'report', 'delete report'),
	('report.approve', 'report', 'approve report'),
	('report.export', 'report', 'export report'),
	('report.manage', 'report', 'manage report'),
	('dashboard.view', 'dashboard', 'view dashboard'),
	('dashboard.create', 'dashboard', 'create dashboard'),
	('dashboard.edit', 'dashboard', 'edit dashboard');
INSERT INTO public.permissions VALUES
	('dashboard.delete', 'dashboard', 'delete dashboard'),
	('dashboard.approve', 'dashboard', 'approve dashboard'),
	('dashboard.export', 'dashboard', 'export dashboard'),
	('dashboard.manage', 'dashboard', 'manage dashboard'),
	('search.view', 'search', 'view search'),
	('search.create', 'search', 'create search'),
	('search.edit', 'search', 'edit search'),
	('search.delete', 'search', 'delete search'),
	('search.approve', 'search', 'approve search'),
	('search.export', 'search', 'export search'),
	('search.manage', 'search', 'manage search'),
	('admin.view', 'admin', 'view admin'),
	('admin.create', 'admin', 'create admin'),
	('admin.edit', 'admin', 'edit admin'),
	('admin.delete', 'admin', 'delete admin'),
	('admin.approve', 'admin', 'approve admin'),
	('admin.export', 'admin', 'export admin'),
	('admin.manage', 'admin', 'manage admin'),
	('finance.view', 'finance', 'view finance'),
	('finance.create', 'finance', 'create finance'),
	('finance.edit', 'finance', 'edit finance'),
	('finance.delete', 'finance', 'delete finance'),
	('finance.approve', 'finance', 'approve finance'),
	('finance.export', 'finance', 'export finance'),
	('finance.manage', 'finance', 'manage finance'),
	('quality.view', 'quality', 'view quality'),
	('quality.create', 'quality', 'create quality'),
	('quality.edit', 'quality', 'edit quality'),
	('quality.delete', 'quality', 'delete quality'),
	('quality.approve', 'quality', 'approve quality'),
	('quality.export', 'quality', 'export quality'),
	('quality.manage', 'quality', 'manage quality'),
	('production.view', 'production', 'view production'),
	('production.create', 'production', 'create production'),
	('production.edit', 'production', 'edit production'),
	('production.delete', 'production', 'delete production'),
	('production.approve', 'production', 'approve production'),
	('production.export', 'production', 'export production'),
	('production.manage', 'production', 'manage production'),
	('subcontract.view', 'subcontract', 'view subcontract'),
	('subcontract.create', 'subcontract', 'create subcontract'),
	('subcontract.edit', 'subcontract', 'edit subcontract'),
	('subcontract.delete', 'subcontract', 'delete subcontract'),
	('subcontract.approve', 'subcontract', 'approve subcontract'),
	('subcontract.export', 'subcontract', 'export subcontract'),
	('subcontract.manage', 'subcontract', 'manage subcontract'),
	('shipment.view', 'shipment', 'view shipment'),
	('shipment.create', 'shipment', 'create shipment'),
	('shipment.edit', 'shipment', 'edit shipment'),
	('shipment.delete', 'shipment', 'delete shipment');
INSERT INTO public.permissions VALUES
	('shipment.approve', 'shipment', 'approve shipment'),
	('shipment.export', 'shipment', 'export shipment'),
	('shipment.manage', 'shipment', 'manage shipment'),
	('approval.view', 'approval', 'view approval'),
	('approval.create', 'approval', 'create approval'),
	('approval.edit', 'approval', 'edit approval'),
	('approval.delete', 'approval', 'delete approval'),
	('approval.approve', 'approval', 'approve approval'),
	('approval.export', 'approval', 'export approval'),
	('approval.manage', 'approval', 'manage approval'),
	('integration.view', 'integration', 'view integration'),
	('integration.create', 'integration', 'create integration'),
	('integration.edit', 'integration', 'edit integration'),
	('integration.delete', 'integration', 'delete integration'),
	('integration.approve', 'integration', 'approve integration'),
	('integration.export', 'integration', 'export integration'),
	('integration.manage', 'integration', 'manage integration'),
	('*', 'all', 'Full access');


--
-- Data for Name: projects; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.projects VALUES
	('4f34b130-a257-49ec-a198-33166c83b78c', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PROJ-2026-000002', 'SO-2026-000002 — Deccan Petrochem Ltd', 'e3cd7bb2-b68b-477b-9f79-65e38911aa9d', '0bbed72f-1aff-49df-867f-4201b53b165f', 'PLANNING', 0.00, NULL, NULL, NULL, NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:24.953594+00', '2026-10-27 14:05:24.953594+00', 1),
	('b639e43a-27fb-4079-90cf-21d8db9e4cf2', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PROJ-2026-000003', 'SO-2026-000003 — Coastal Power Ltd', 'bf611ca6-3960-4d76-99ad-7fb0a30f1349', '08c81785-76c6-4ce9-9c02-f0d075c9befc', 'PLANNING', 0.00, NULL, NULL, NULL, NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.01735+00', '2026-10-27 14:05:25.01735+00', 1),
	('d539b477-a33c-4c8b-877f-1688b0896ee5', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PROJ-2026-000004', 'SO-2026-000004 — Nagpur Steel Works', '1138c7ca-0fa9-4e2a-96df-6216ec00a6ce', '5150e791-ad57-45a1-9173-962ee330f78f', 'PLANNING', 0.00, NULL, NULL, NULL, NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.072563+00', '2026-10-27 14:05:25.072563+00', 1),
	('ae5710ae-e514-4c0d-96a1-70d15fa6fb10', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PROJ-2026-000006', 'SO-2026-000006 — Vizag Chemicals', 'a1e41cbe-ac6e-4f15-b86c-a9cba5f85a31', 'd7896924-f01a-474e-afe1-ef33836afd2f', 'PLANNING', 0.00, NULL, NULL, NULL, NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.178283+00', '2026-10-27 14:05:25.178283+00', 1),
	('ca3c1420-21a0-4f4b-8c18-4305124668d8', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PROJ-2026-000007', 'SO-2026-000007 — Kaveri Water Board', '380afc7f-f7a6-4475-8687-bdab7cedfad0', '498e3f4d-22ff-4b1e-a1ab-43e37332b591', 'PLANNING', 0.00, NULL, NULL, NULL, NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.232856+00', '2026-10-27 14:05:25.232856+00', 1),
	('5320c208-2aec-4021-9cc9-82644e942504', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PROJ-2026-000008', 'SO-2026-000008 — Sahara Fertilizers Ltd', '3c5682c9-90ef-4c1a-a319-f763f49889d0', '4e36052e-0a7c-47ae-94dd-8c74ff17ee6e', 'PLANNING', 0.00, NULL, NULL, NULL, NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.286585+00', '2026-10-27 14:05:25.286585+00', 1),
	('a1cd80a9-edf2-4514-a347-490a745be459', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PROJ-2026-000009', 'SO-2026-000009 — Gulf Refining Co.', 'b93cc6d0-2b05-44d6-ab87-2a4b9cf61a3e', 'c8daa3b5-bd9e-41fe-83ca-f53a2138d16d', 'PLANNING', 0.00, NULL, NULL, NULL, NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.340546+00', '2026-10-27 14:05:25.340546+00', 1),
	('d9cb1242-0efb-49e7-9700-ed7d0b8b5fef', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PROJ-2026-000010', 'SO-2026-000010 — Hamburg Process GmbH', '15a84750-6559-46aa-b0a2-6f1920761e68', '17faff62-40d5-4b82-a2bb-e6c64e3162be', 'PLANNING', 0.00, NULL, NULL, NULL, NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.397066+00', '2026-10-27 14:05:25.397066+00', 1),
	('84101b04-ed2d-4d90-a0e8-fd3ab0c72963', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PROJ-2026-000011', 'SO-2026-000011 — Iberia Water S.L.', '8adb0ee1-eb89-41e7-871d-e685e2e1ff38', '23f877c9-0add-44dc-b617-5e7e48c1e841', 'PLANNING', 0.00, NULL, NULL, NULL, NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.448918+00', '2026-10-27 14:05:25.448918+00', 1),
	('fe6c8196-bffc-49d7-8dca-db586acf76b1', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PROJ-2026-000012', 'SO-2026-000012 — Reliance Marine Services', '234b9a3f-6df9-4272-8c0f-7487c2af1990', 'afc38366-3c26-4a27-a1cc-e811550d9b5c', 'PLANNING', 0.00, NULL, NULL, NULL, NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.499541+00', '2026-10-27 14:05:25.499541+00', 1),
	('5d2d3f5c-d45e-4bad-9845-37d43bcc4ad5', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PROJ-2026-000001', 'SO-2026-000001 — ABC Industries', '493d756e-cdfe-465c-884b-77f468f1f216', '84f16360-acd8-4658-a08c-5095e56335a6', 'ACTIVE', 0.00, NULL, NULL, NULL, NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:24.889812+00', '2026-10-27 14:05:28.920514+00', 2),
	('b35df05a-eece-4379-ac3e-21d533aeeeb4', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PROJ-2026-000005', 'SO-2026-000005 — Metro Utilities', '4fe2d155-87cd-4e06-b9f7-8bd425bddc4d', 'bc2c7461-b1cd-4c66-8996-611e28098035', 'ACTIVE', 0.00, NULL, NULL, NULL, NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.125237+00', '2026-10-27 14:05:29.036034+00', 2);


--
-- Data for Name: project_tasks; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.project_tasks VALUES
	('b43a9ed3-9524-402e-8608-d58e6a8a91b2', '5d2d3f5c-d45e-4bad-9845-37d43bcc4ad5', 'Engineering', 'Engineering', 'TODO', 0.00, NULL, NULL, NULL, false, 0),
	('c0a56f66-95c0-41fd-be0a-85a107b6fb08', '5d2d3f5c-d45e-4bad-9845-37d43bcc4ad5', 'Drawing Approval', 'Drawing Approval', 'TODO', 0.00, NULL, NULL, NULL, false, 1),
	('0a5793b2-1ea5-4cfe-b337-8b7b37aadd7d', '5d2d3f5c-d45e-4bad-9845-37d43bcc4ad5', 'Procurement', 'Procurement', 'TODO', 0.00, NULL, NULL, NULL, false, 2),
	('ddac5c8b-a02e-4b89-a824-e2859743c0c1', '5d2d3f5c-d45e-4bad-9845-37d43bcc4ad5', 'Production', 'Production', 'TODO', 0.00, NULL, NULL, NULL, false, 3),
	('9c33350e-054c-46cf-954e-fe1e6958ba3a', '5d2d3f5c-d45e-4bad-9845-37d43bcc4ad5', 'QC', 'QC', 'TODO', 0.00, NULL, NULL, NULL, true, 4),
	('7392563c-6301-4d69-8ffa-e967d9c0376f', '5d2d3f5c-d45e-4bad-9845-37d43bcc4ad5', 'Delivery', 'Delivery', 'TODO', 0.00, NULL, NULL, NULL, true, 5),
	('84a4a9f3-3d28-4144-9742-4e4d2db8ee41', '4f34b130-a257-49ec-a198-33166c83b78c', 'Engineering', 'Engineering', 'TODO', 0.00, NULL, NULL, NULL, false, 0),
	('3ce33a26-5ecc-4a8b-a87e-5ecdf47b49ba', '4f34b130-a257-49ec-a198-33166c83b78c', 'Drawing Approval', 'Drawing Approval', 'TODO', 0.00, NULL, NULL, NULL, false, 1),
	('21159d9e-0db6-42d8-a6f7-107c5b8b6b07', '4f34b130-a257-49ec-a198-33166c83b78c', 'Procurement', 'Procurement', 'TODO', 0.00, NULL, NULL, NULL, false, 2),
	('8fbe19c9-40d3-4d36-ad29-285878e3e693', '4f34b130-a257-49ec-a198-33166c83b78c', 'Production', 'Production', 'TODO', 0.00, NULL, NULL, NULL, false, 3),
	('8d5d7d19-1419-45ad-baf4-64fee475004e', '4f34b130-a257-49ec-a198-33166c83b78c', 'QC', 'QC', 'TODO', 0.00, NULL, NULL, NULL, true, 4),
	('316ae847-68c7-4cf2-adf6-6d3913c5a29c', '4f34b130-a257-49ec-a198-33166c83b78c', 'Delivery', 'Delivery', 'TODO', 0.00, NULL, NULL, NULL, true, 5),
	('c0184e06-7148-43da-b474-f61229e4810d', 'b639e43a-27fb-4079-90cf-21d8db9e4cf2', 'Engineering', 'Engineering', 'TODO', 0.00, NULL, NULL, NULL, false, 0),
	('74b7b0fb-764b-4535-88f3-f6e05f6097aa', 'b639e43a-27fb-4079-90cf-21d8db9e4cf2', 'Drawing Approval', 'Drawing Approval', 'TODO', 0.00, NULL, NULL, NULL, false, 1),
	('f5a1a922-5b2c-4e2c-8f03-b4bb6c0259ae', 'b639e43a-27fb-4079-90cf-21d8db9e4cf2', 'Procurement', 'Procurement', 'TODO', 0.00, NULL, NULL, NULL, false, 2),
	('65cccef8-1d5d-40d2-9be0-8b276b3d0163', 'b639e43a-27fb-4079-90cf-21d8db9e4cf2', 'Production', 'Production', 'TODO', 0.00, NULL, NULL, NULL, false, 3),
	('d5f73075-ec10-4222-b7aa-459facb06cee', 'b639e43a-27fb-4079-90cf-21d8db9e4cf2', 'QC', 'QC', 'TODO', 0.00, NULL, NULL, NULL, true, 4),
	('abc6e47d-656c-4513-bb0c-bd7d1a9e0f58', 'b639e43a-27fb-4079-90cf-21d8db9e4cf2', 'Delivery', 'Delivery', 'TODO', 0.00, NULL, NULL, NULL, true, 5),
	('3b1ea748-a412-4d0a-83f4-ec1adbdca0bf', 'd539b477-a33c-4c8b-877f-1688b0896ee5', 'Engineering', 'Engineering', 'TODO', 0.00, NULL, NULL, NULL, false, 0),
	('10bbe57a-9f4c-4c34-8910-5c5be6ad5a7e', 'd539b477-a33c-4c8b-877f-1688b0896ee5', 'Drawing Approval', 'Drawing Approval', 'TODO', 0.00, NULL, NULL, NULL, false, 1),
	('f6fcb49d-adad-4962-8a3e-6e4b9e390a3b', 'd539b477-a33c-4c8b-877f-1688b0896ee5', 'Procurement', 'Procurement', 'TODO', 0.00, NULL, NULL, NULL, false, 2),
	('0b915499-c327-498d-a666-968dc9bb55f0', 'd539b477-a33c-4c8b-877f-1688b0896ee5', 'Production', 'Production', 'TODO', 0.00, NULL, NULL, NULL, false, 3),
	('cd14975d-4964-476f-8c49-c46c5bc0716b', 'd539b477-a33c-4c8b-877f-1688b0896ee5', 'QC', 'QC', 'TODO', 0.00, NULL, NULL, NULL, true, 4),
	('7b204b08-6de9-4e9c-8dc5-bc357f69ca7a', 'd539b477-a33c-4c8b-877f-1688b0896ee5', 'Delivery', 'Delivery', 'TODO', 0.00, NULL, NULL, NULL, true, 5),
	('ef4e27a0-1cfc-4dbc-b3fe-78b5e91a0b4b', 'b35df05a-eece-4379-ac3e-21d533aeeeb4', 'Engineering', 'Engineering', 'TODO', 0.00, NULL, NULL, NULL, false, 0),
	('4f6bee64-fe1b-4c4b-a7be-1be08ada4a69', 'b35df05a-eece-4379-ac3e-21d533aeeeb4', 'Drawing Approval', 'Drawing Approval', 'TODO', 0.00, NULL, NULL, NULL, false, 1),
	('3ffd4c87-8616-4271-9b3c-1a697af6093d', 'b35df05a-eece-4379-ac3e-21d533aeeeb4', 'Procurement', 'Procurement', 'TODO', 0.00, NULL, NULL, NULL, false, 2),
	('5138bc7c-b0c3-4bb0-95a3-f390ef7336b7', 'b35df05a-eece-4379-ac3e-21d533aeeeb4', 'Production', 'Production', 'TODO', 0.00, NULL, NULL, NULL, false, 3),
	('afd29532-2fe3-4468-8e67-11e2b186e01f', 'b35df05a-eece-4379-ac3e-21d533aeeeb4', 'QC', 'QC', 'TODO', 0.00, NULL, NULL, NULL, true, 4),
	('b02c5b23-82b3-4a3d-a255-f06d77588ad0', 'b35df05a-eece-4379-ac3e-21d533aeeeb4', 'Delivery', 'Delivery', 'TODO', 0.00, NULL, NULL, NULL, true, 5),
	('2727f8e3-52cc-4970-9a88-62abb12f0344', 'ae5710ae-e514-4c0d-96a1-70d15fa6fb10', 'Engineering', 'Engineering', 'TODO', 0.00, NULL, NULL, NULL, false, 0),
	('b615b238-de01-453c-8652-d3c663de63cf', 'ae5710ae-e514-4c0d-96a1-70d15fa6fb10', 'Drawing Approval', 'Drawing Approval', 'TODO', 0.00, NULL, NULL, NULL, false, 1),
	('bc153755-61b7-4d61-9777-e32eb55cdcbc', 'ae5710ae-e514-4c0d-96a1-70d15fa6fb10', 'Procurement', 'Procurement', 'TODO', 0.00, NULL, NULL, NULL, false, 2),
	('18ce32ae-c413-4471-a922-9274a77df2f7', 'ae5710ae-e514-4c0d-96a1-70d15fa6fb10', 'Production', 'Production', 'TODO', 0.00, NULL, NULL, NULL, false, 3),
	('b8546bc2-ff42-4373-989d-9f058a307844', 'ae5710ae-e514-4c0d-96a1-70d15fa6fb10', 'QC', 'QC', 'TODO', 0.00, NULL, NULL, NULL, true, 4),
	('b685171e-7012-49eb-8e67-9e75e89d2fa6', 'ae5710ae-e514-4c0d-96a1-70d15fa6fb10', 'Delivery', 'Delivery', 'TODO', 0.00, NULL, NULL, NULL, true, 5),
	('1f44864f-410e-40ba-b709-499ada47792c', 'ca3c1420-21a0-4f4b-8c18-4305124668d8', 'Engineering', 'Engineering', 'TODO', 0.00, NULL, NULL, NULL, false, 0),
	('72ce6116-ef17-4ac8-a1bb-634e0808b98d', 'ca3c1420-21a0-4f4b-8c18-4305124668d8', 'Drawing Approval', 'Drawing Approval', 'TODO', 0.00, NULL, NULL, NULL, false, 1),
	('199cc716-ec3a-418f-8e69-c4ec24e07a9c', 'ca3c1420-21a0-4f4b-8c18-4305124668d8', 'Procurement', 'Procurement', 'TODO', 0.00, NULL, NULL, NULL, false, 2),
	('b99007c2-0ee3-4cf6-877a-b1fccd96351c', 'ca3c1420-21a0-4f4b-8c18-4305124668d8', 'Production', 'Production', 'TODO', 0.00, NULL, NULL, NULL, false, 3),
	('36f504a8-b796-48b9-ae7f-46041589498a', 'ca3c1420-21a0-4f4b-8c18-4305124668d8', 'QC', 'QC', 'TODO', 0.00, NULL, NULL, NULL, true, 4),
	('9c4bda3e-6a4f-48f4-a2b0-36f20046bc92', 'ca3c1420-21a0-4f4b-8c18-4305124668d8', 'Delivery', 'Delivery', 'TODO', 0.00, NULL, NULL, NULL, true, 5),
	('f15e053d-2239-43e0-8e8d-19888719aaf4', '5320c208-2aec-4021-9cc9-82644e942504', 'Engineering', 'Engineering', 'TODO', 0.00, NULL, NULL, NULL, false, 0),
	('eafe7018-15b5-4e3b-bbed-e09bfb604ccd', '5320c208-2aec-4021-9cc9-82644e942504', 'Drawing Approval', 'Drawing Approval', 'TODO', 0.00, NULL, NULL, NULL, false, 1),
	('f14771fc-aba8-4922-b129-ff07f254a128', '5320c208-2aec-4021-9cc9-82644e942504', 'Procurement', 'Procurement', 'TODO', 0.00, NULL, NULL, NULL, false, 2),
	('3a8cd711-181e-40d4-b428-4b18b4ced25b', '5320c208-2aec-4021-9cc9-82644e942504', 'Production', 'Production', 'TODO', 0.00, NULL, NULL, NULL, false, 3),
	('78955854-b991-4def-9c1f-de0adc96eb8d', '5320c208-2aec-4021-9cc9-82644e942504', 'QC', 'QC', 'TODO', 0.00, NULL, NULL, NULL, true, 4),
	('28b09dca-2203-4a2d-8344-f6c0fd551ccf', '5320c208-2aec-4021-9cc9-82644e942504', 'Delivery', 'Delivery', 'TODO', 0.00, NULL, NULL, NULL, true, 5),
	('bd3238e3-5d3a-4a49-b79a-ae03a22219bc', 'a1cd80a9-edf2-4514-a347-490a745be459', 'Engineering', 'Engineering', 'TODO', 0.00, NULL, NULL, NULL, false, 0),
	('9e60dfa2-4f3a-4e45-a860-91c08821279e', 'a1cd80a9-edf2-4514-a347-490a745be459', 'Drawing Approval', 'Drawing Approval', 'TODO', 0.00, NULL, NULL, NULL, false, 1);
INSERT INTO public.project_tasks VALUES
	('608d8f60-d637-4ad1-bf16-2bb332d39095', 'a1cd80a9-edf2-4514-a347-490a745be459', 'Procurement', 'Procurement', 'TODO', 0.00, NULL, NULL, NULL, false, 2),
	('94aaecfc-56bc-43b5-9425-db88d21e2de5', 'a1cd80a9-edf2-4514-a347-490a745be459', 'Production', 'Production', 'TODO', 0.00, NULL, NULL, NULL, false, 3),
	('855ba305-838a-46f1-8aa1-53771bd74977', 'a1cd80a9-edf2-4514-a347-490a745be459', 'QC', 'QC', 'TODO', 0.00, NULL, NULL, NULL, true, 4),
	('ff529cb7-8a54-41b5-bc5c-d940ddeadbc3', 'a1cd80a9-edf2-4514-a347-490a745be459', 'Delivery', 'Delivery', 'TODO', 0.00, NULL, NULL, NULL, true, 5),
	('7252e033-d5ab-4580-95c3-7da07802e9fb', 'd9cb1242-0efb-49e7-9700-ed7d0b8b5fef', 'Engineering', 'Engineering', 'TODO', 0.00, NULL, NULL, NULL, false, 0),
	('b00694cb-73fc-4a3b-be0b-cdec19e5b70b', 'd9cb1242-0efb-49e7-9700-ed7d0b8b5fef', 'Drawing Approval', 'Drawing Approval', 'TODO', 0.00, NULL, NULL, NULL, false, 1),
	('ad9828bd-9fd7-4f57-9b94-62d8cf4ecd20', 'd9cb1242-0efb-49e7-9700-ed7d0b8b5fef', 'Procurement', 'Procurement', 'TODO', 0.00, NULL, NULL, NULL, false, 2),
	('77caeeda-bb36-4559-8d1d-604c9c41dfaa', 'd9cb1242-0efb-49e7-9700-ed7d0b8b5fef', 'Production', 'Production', 'TODO', 0.00, NULL, NULL, NULL, false, 3),
	('dc429c15-edee-4de4-8f3d-c40db6a55186', 'd9cb1242-0efb-49e7-9700-ed7d0b8b5fef', 'QC', 'QC', 'TODO', 0.00, NULL, NULL, NULL, true, 4),
	('02b07746-d3a1-4f89-ad9a-c6215bc39d6f', 'd9cb1242-0efb-49e7-9700-ed7d0b8b5fef', 'Delivery', 'Delivery', 'TODO', 0.00, NULL, NULL, NULL, true, 5),
	('f7ba5f86-06cc-49d1-97a9-8ccfaa8eb2a1', '84101b04-ed2d-4d90-a0e8-fd3ab0c72963', 'Engineering', 'Engineering', 'TODO', 0.00, NULL, NULL, NULL, false, 0),
	('eb8bfcfd-06a7-4ad6-a28b-5b1d1fd2afad', '84101b04-ed2d-4d90-a0e8-fd3ab0c72963', 'Drawing Approval', 'Drawing Approval', 'TODO', 0.00, NULL, NULL, NULL, false, 1),
	('edf8479c-9950-4b9a-ba94-b4e709ad2092', '84101b04-ed2d-4d90-a0e8-fd3ab0c72963', 'Procurement', 'Procurement', 'TODO', 0.00, NULL, NULL, NULL, false, 2),
	('06d9372b-6805-415f-918f-5f69003db6b5', '84101b04-ed2d-4d90-a0e8-fd3ab0c72963', 'Production', 'Production', 'TODO', 0.00, NULL, NULL, NULL, false, 3),
	('58d234fd-ddc0-4289-81eb-807d502f1dbd', '84101b04-ed2d-4d90-a0e8-fd3ab0c72963', 'QC', 'QC', 'TODO', 0.00, NULL, NULL, NULL, true, 4),
	('0a703e05-e79b-4846-b8b0-ad46840cb73e', '84101b04-ed2d-4d90-a0e8-fd3ab0c72963', 'Delivery', 'Delivery', 'TODO', 0.00, NULL, NULL, NULL, true, 5),
	('4807557d-d7ce-4bed-b602-7d11f457cff5', 'fe6c8196-bffc-49d7-8dca-db586acf76b1', 'Engineering', 'Engineering', 'TODO', 0.00, NULL, NULL, NULL, false, 0),
	('781404e0-700e-49ab-8d17-00e67f8e78df', 'fe6c8196-bffc-49d7-8dca-db586acf76b1', 'Drawing Approval', 'Drawing Approval', 'TODO', 0.00, NULL, NULL, NULL, false, 1),
	('ffd9d8f7-897b-4f7c-8847-730b17f1d1e9', 'fe6c8196-bffc-49d7-8dca-db586acf76b1', 'Procurement', 'Procurement', 'TODO', 0.00, NULL, NULL, NULL, false, 2),
	('1b5a84ea-2c3f-4b28-8018-73e696f82447', 'fe6c8196-bffc-49d7-8dca-db586acf76b1', 'Production', 'Production', 'TODO', 0.00, NULL, NULL, NULL, false, 3),
	('ebffa44a-c7f9-48a4-9982-cc8b4a38ce6c', 'fe6c8196-bffc-49d7-8dca-db586acf76b1', 'QC', 'QC', 'TODO', 0.00, NULL, NULL, NULL, true, 4),
	('7e457d93-6182-4bf3-9dda-e3d5918da016', 'fe6c8196-bffc-49d7-8dca-db586acf76b1', 'Delivery', 'Delivery', 'TODO', 0.00, NULL, NULL, NULL, true, 5);


--
-- Data for Name: quotation_lines; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.quotation_lines VALUES
	('0bfb46d3-fa20-4b8a-bf04-15c7ddd93a81', 'acc2a4f1-4770-4991-917e-d6e9f93ccb93', 1, '6e212887-960b-4eed-ade6-18715e05c5cb', 'PV-BV-050 — Ball Valve 50mm SS316', 3.000, 2100.0000, 5.00, 18.00, 7062.30),
	('964ee6fc-c41b-4a06-8e8d-bed33e09501e', 'acc2a4f1-4770-4991-917e-d6e9f93ccb93', 2, 'abe0ed52-e0fd-424a-b2d4-00c1c625767f', 'PV-SEAT-01 — PTFE Seat Ring', 3.000, 180.0000, 0.00, 18.00, 637.20),
	('f9163395-4a3e-44a0-9bc9-a724d9c745bb', 'fc114276-1b5f-4018-9a2a-fd523fff4926', 1, 'eb07eab2-eba7-4b97-88f8-9066662e9a5e', 'PV-GV-080 — Gate Valve 80mm CF8M', 4.000, 5900.0000, 3.00, 18.00, 27012.56),
	('4b0412e1-e96f-407c-8eed-95ed870540a2', '44dde98c-02b8-43f3-a22b-f6d914f1df1b', 1, '82048a24-aa7e-422f-bee0-1642d75bd996', 'PV-BV-025 — Ball Valve 25mm SS316', 3.000, 1450.0000, 0.00, 18.00, 5133.00),
	('72a74128-2e66-4da7-9254-07b0bdbfb348', '14ebed78-c91d-4508-9a0e-43af0dfad235', 1, '77a428fe-4dd9-4a6e-8138-36a5f4efc6b2', 'PV-GLV-050 — Globe Valve 50mm SS316', 3.000, 3400.0000, 0.00, 18.00, 12036.00),
	('f0efd6cd-109d-4c4d-8cf3-70e18e8f1117', 'd8d170b5-2ae9-4b08-9031-ed036c67fb26', 1, '92a93794-1287-4b7d-8868-7b9b81b87cb2', 'PV-CV-050 — Check Valve 50mm SS316', 2.000, 2400.0000, 0.00, 18.00, 5664.00),
	('2e8bf600-e5d9-4ca8-b142-85228d139ae8', 'eabc6dfb-091b-4a26-8690-736a3a331a0f', 1, '6f56aa1e-de31-44a5-b842-756c12aa7646', 'PV-BV-100 — Ball Valve 100mm CF8M', 2.000, 6800.0000, 0.00, 18.00, 16048.00),
	('3545f177-dda1-4f2e-839b-1f9595ec37d9', '023b8d39-f4e0-4672-9c1c-79b54478612e', 1, '9152c8e7-6ed4-495d-a58c-ee509367659f', 'PV-GV-150 — Gate Valve 150mm CF8M', 4.000, 12900.0000, 4.00, 18.00, 58452.48),
	('9bfc6fb7-1064-4dea-9ab7-22f2074f571e', 'e63491b4-3f5a-4319-a98b-80b04378bc0f', 1, 'd61fe768-7f6e-4d65-b1f1-6f5621e2008b', 'PV-GV-050 — Gate Valve 50mm WCB', 2.000, 3100.0000, 0.00, 18.00, 7316.00),
	('5eca5935-9dd3-4cec-a787-489333dab678', '7668d975-423a-4704-a27d-3fb0c3478491', 1, '65e1cab5-04f9-4e45-9081-e07e65803ba9', 'PV-BFV-200 — Butterfly Valve 200mm', 2.000, 8200.0000, 0.00, 18.00, 19352.00),
	('8c6a2531-9412-4428-9856-b3dd3b0d4f33', 'f983962b-2117-4356-b2f4-841a61b80e50', 1, '6f56aa1e-de31-44a5-b842-756c12aa7646', 'PV-BV-100 — Ball Valve 100mm CF8M', 6.000, 6800.0000, 2.00, 18.00, 47181.12),
	('1fec21b6-7aac-4e9d-9d07-46b393078529', '54b98a5d-b260-477a-9f41-9ac2378f3f54', 1, '65e1cab5-04f9-4e45-9081-e07e65803ba9', 'PV-BFV-200 — Butterfly Valve 200mm', 4.000, 8200.0000, 0.00, 18.00, 38704.00),
	('3ee994fa-0191-4327-9162-ca482a65c4d7', 'fc153539-b57b-41dd-a1ca-c3771f81640a', 1, '82048a24-aa7e-422f-bee0-1642d75bd996', 'PV-BV-025 — Ball Valve 25mm SS316', 10.000, 1450.0000, 5.00, 18.00, 16254.50),
	('90625c01-2129-4ee0-a669-67e2e6f9f38e', 'cb8dc1b9-2f62-4e6c-8067-e22f2579145e', 1, '77a428fe-4dd9-4a6e-8138-36a5f4efc6b2', 'PV-GLV-050 — Globe Valve 50mm SS316', 6.000, 3400.0000, 0.00, 18.00, 24072.00),
	('c7302569-ef0e-4897-ad12-5a6dfaeb8a44', '2a5d0fe2-6b3a-4833-b653-5bb1a354d68d', 1, 'eb07eab2-eba7-4b97-88f8-9066662e9a5e', 'PV-GV-080 — Gate Valve 80mm CF8M', 8.000, 5900.0000, 6.00, 18.00, 52354.24),
	('d44808d7-6d31-43aa-9120-cfe77ae5a7e2', '92c97736-af56-473b-89ec-1660fb2174b0', 1, '92a93794-1287-4b7d-8868-7b9b81b87cb2', 'PV-CV-050 — Check Valve 50mm SS316', 12.000, 2400.0000, 0.00, 18.00, 33984.00),
	('db254587-3a4c-4b3e-84fd-4d8ec910d50a', '367f8d37-03ee-4da0-b20a-b953fe2306f4', 1, '6f56aa1e-de31-44a5-b842-756c12aa7646', 'PV-BV-100 — Ball Valve 100mm CF8M', 5.000, 6800.0000, 8.00, 18.00, 36910.40);


--
-- Data for Name: quotation_versions; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.quotation_versions VALUES
	('42a7702a-2fc5-40fb-91f2-bd2e944f7f74', 'acc2a4f1-4770-4991-917e-d6e9f93ccb93', 1, '{"lines": [{"id": "0bfb46d3-fa20-4b8a-bf04-15c7ddd93a81", "line_no": 1, "quantity": 3.000, "tax_rate": 18.00, "line_total": 7062.30, "product_id": "6e212887-960b-4eed-ade6-18715e05c5cb", "unit_price": 2100.0000, "description": "PV-BV-050 — Ball Valve 50mm SS316", "discount_pct": 5.00, "quotation_id": "acc2a4f1-4770-4991-917e-d6e9f93ccb93"}, {"id": "964ee6fc-c41b-4a06-8e8d-bed33e09501e", "line_no": 2, "quantity": 3.000, "tax_rate": 18.00, "line_total": 637.20, "product_id": "abe0ed52-e0fd-424a-b2d4-00c1c625767f", "unit_price": 180.0000, "description": "PV-SEAT-01 — PTFE Seat Ring", "discount_pct": 0.00, "quotation_id": "acc2a4f1-4770-4991-917e-d6e9f93ccb93"}], "quote": {"id": "acc2a4f1-4770-4991-917e-d6e9f93ccb93", "notes": "Hydrotest certificates and MTCs included.", "org_id": "4a0f88e6-467f-406c-a37b-fde4abff9898", "status": "SENT", "lead_id": null, "version": 2, "currency": "INR", "revision": 1, "subtotal": 6840.00, "tax_total": 1174.50, "company_id": "493d756e-cdfe-465c-884b-77f468f1f216", "contact_id": null, "created_at": "2026-10-27T14:05:24.843766+00:00", "created_by": "0258e002-4154-48b4-ad1d-2195882841be", "updated_at": "2026-10-27T14:05:24.856638+00:00", "updated_by": "0258e002-4154-48b4-ad1d-2195882841be", "grand_total": 7699.50, "valid_until": "2026-11-26", "quote_number": "QUO-2026-000001", "exchange_rate": 1.000000, "payment_terms": "NET30", "delivery_terms": "Ex-works, 8–10 weeks", "discount_total": 315.00, "parent_quote_id": null}}', 'Sent to customer', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.856638+00'),
	('53bef12f-9736-44a2-bbdd-4f94cacc8363', 'fc114276-1b5f-4018-9a2a-fd523fff4926', 1, '{"lines": [{"id": "f9163395-4a3e-44a0-9bc9-a724d9c745bb", "line_no": 1, "quantity": 4.000, "tax_rate": 18.00, "line_total": 27012.56, "product_id": "eb07eab2-eba7-4b97-88f8-9066662e9a5e", "unit_price": 5900.0000, "description": "PV-GV-080 — Gate Valve 80mm CF8M", "discount_pct": 3.00, "quotation_id": "fc114276-1b5f-4018-9a2a-fd523fff4926"}], "quote": {"id": "fc114276-1b5f-4018-9a2a-fd523fff4926", "notes": "Hydrotest certificates and MTCs included.", "org_id": "4a0f88e6-467f-406c-a37b-fde4abff9898", "status": "SENT", "lead_id": null, "version": 2, "currency": "INR", "revision": 1, "subtotal": 23600.00, "tax_total": 4120.56, "company_id": "e3cd7bb2-b68b-477b-9f79-65e38911aa9d", "contact_id": null, "created_at": "2026-10-27T14:05:24.928887+00:00", "created_by": "0258e002-4154-48b4-ad1d-2195882841be", "updated_at": "2026-10-27T14:05:24.937436+00:00", "updated_by": "0258e002-4154-48b4-ad1d-2195882841be", "grand_total": 27012.56, "valid_until": "2026-11-26", "quote_number": "QUO-2026-000002", "exchange_rate": 1.000000, "payment_terms": "NET30", "delivery_terms": "Ex-works, 8–10 weeks", "discount_total": 708.00, "parent_quote_id": null}}', 'Sent to customer', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.937436+00'),
	('4c317d5a-b8f8-4d77-9ed7-7b84da4699f4', '44dde98c-02b8-43f3-a22b-f6d914f1df1b', 1, '{"lines": [{"id": "4b0412e1-e96f-407c-8eed-95ed870540a2", "line_no": 1, "quantity": 3.000, "tax_rate": 18.00, "line_total": 5133.00, "product_id": "82048a24-aa7e-422f-bee0-1642d75bd996", "unit_price": 1450.0000, "description": "PV-BV-025 — Ball Valve 25mm SS316", "discount_pct": 0.00, "quotation_id": "44dde98c-02b8-43f3-a22b-f6d914f1df1b"}], "quote": {"id": "44dde98c-02b8-43f3-a22b-f6d914f1df1b", "notes": "Hydrotest certificates and MTCs included.", "org_id": "4a0f88e6-467f-406c-a37b-fde4abff9898", "status": "SENT", "lead_id": null, "version": 2, "currency": "INR", "revision": 1, "subtotal": 4350.00, "tax_total": 783.00, "company_id": "bf611ca6-3960-4d76-99ad-7fb0a30f1349", "contact_id": null, "created_at": "2026-10-27T14:05:24.989372+00:00", "created_by": "0258e002-4154-48b4-ad1d-2195882841be", "updated_at": "2026-10-27T14:05:25.000286+00:00", "updated_by": "0258e002-4154-48b4-ad1d-2195882841be", "grand_total": 5133.00, "valid_until": "2026-11-26", "quote_number": "QUO-2026-000003", "exchange_rate": 1.000000, "payment_terms": "NET30", "delivery_terms": "Ex-works, 8–10 weeks", "discount_total": 0.00, "parent_quote_id": null}}', 'Sent to customer', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:25.000286+00'),
	('6bf069aa-b322-4e77-8c74-7edf461a3d7b', '14ebed78-c91d-4508-9a0e-43af0dfad235', 1, '{"lines": [{"id": "72a74128-2e66-4da7-9254-07b0bdbfb348", "line_no": 1, "quantity": 3.000, "tax_rate": 18.00, "line_total": 12036.00, "product_id": "77a428fe-4dd9-4a6e-8138-36a5f4efc6b2", "unit_price": 3400.0000, "description": "PV-GLV-050 — Globe Valve 50mm SS316", "discount_pct": 0.00, "quotation_id": "14ebed78-c91d-4508-9a0e-43af0dfad235"}], "quote": {"id": "14ebed78-c91d-4508-9a0e-43af0dfad235", "notes": "Hydrotest certificates and MTCs included.", "org_id": "4a0f88e6-467f-406c-a37b-fde4abff9898", "status": "SENT", "lead_id": null, "version": 2, "currency": "INR", "revision": 1, "subtotal": 10200.00, "tax_total": 1836.00, "company_id": "1138c7ca-0fa9-4e2a-96df-6216ec00a6ce", "contact_id": null, "created_at": "2026-10-27T14:05:25.049625+00:00", "created_by": "0258e002-4154-48b4-ad1d-2195882841be", "updated_at": "2026-10-27T14:05:25.058961+00:00", "updated_by": "0258e002-4154-48b4-ad1d-2195882841be", "grand_total": 12036.00, "valid_until": "2026-11-26", "quote_number": "QUO-2026-000004", "exchange_rate": 1.000000, "payment_terms": "NET30", "delivery_terms": "Ex-works, 8–10 weeks", "discount_total": 0.00, "parent_quote_id": null}}', 'Sent to customer', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:25.058961+00'),
	('47b8372f-ef48-4962-bc72-e44f918edb1a', 'd8d170b5-2ae9-4b08-9031-ed036c67fb26', 1, '{"lines": [{"id": "f0efd6cd-109d-4c4d-8cf3-70e18e8f1117", "line_no": 1, "quantity": 2.000, "tax_rate": 18.00, "line_total": 5664.00, "product_id": "92a93794-1287-4b7d-8868-7b9b81b87cb2", "unit_price": 2400.0000, "description": "PV-CV-050 — Check Valve 50mm SS316", "discount_pct": 0.00, "quotation_id": "d8d170b5-2ae9-4b08-9031-ed036c67fb26"}], "quote": {"id": "d8d170b5-2ae9-4b08-9031-ed036c67fb26", "notes": "Hydrotest certificates and MTCs included.", "org_id": "4a0f88e6-467f-406c-a37b-fde4abff9898", "status": "SENT", "lead_id": null, "version": 2, "currency": "INR", "revision": 1, "subtotal": 4800.00, "tax_total": 864.00, "company_id": "4fe2d155-87cd-4e06-b9f7-8bd425bddc4d", "contact_id": null, "created_at": "2026-10-27T14:05:25.102152+00:00", "created_by": "0258e002-4154-48b4-ad1d-2195882841be", "updated_at": "2026-10-27T14:05:25.111519+00:00", "updated_by": "0258e002-4154-48b4-ad1d-2195882841be", "grand_total": 5664.00, "valid_until": "2026-11-26", "quote_number": "QUO-2026-000005", "exchange_rate": 1.000000, "payment_terms": "NET30", "delivery_terms": "Ex-works, 8–10 weeks", "discount_total": 0.00, "parent_quote_id": null}}', 'Sent to customer', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:25.111519+00'),
	('34a72ad5-5e3d-4279-93b9-b7cbdc4a49fa', 'eabc6dfb-091b-4a26-8690-736a3a331a0f', 1, '{"lines": [{"id": "2e8bf600-e5d9-4ca8-b142-85228d139ae8", "line_no": 1, "quantity": 2.000, "tax_rate": 18.00, "line_total": 16048.00, "product_id": "6f56aa1e-de31-44a5-b842-756c12aa7646", "unit_price": 6800.0000, "description": "PV-BV-100 — Ball Valve 100mm CF8M", "discount_pct": 0.00, "quotation_id": "eabc6dfb-091b-4a26-8690-736a3a331a0f"}], "quote": {"id": "eabc6dfb-091b-4a26-8690-736a3a331a0f", "notes": "Hydrotest certificates and MTCs included.", "org_id": "4a0f88e6-467f-406c-a37b-fde4abff9898", "status": "SENT", "lead_id": null, "version": 2, "currency": "INR", "revision": 1, "subtotal": 13600.00, "tax_total": 2448.00, "company_id": "a1e41cbe-ac6e-4f15-b86c-a9cba5f85a31", "contact_id": null, "created_at": "2026-10-27T14:05:25.153544+00:00", "created_by": "0258e002-4154-48b4-ad1d-2195882841be", "updated_at": "2026-10-27T14:05:25.163366+00:00", "updated_by": "0258e002-4154-48b4-ad1d-2195882841be", "grand_total": 16048.00, "valid_until": "2026-11-26", "quote_number": "QUO-2026-000006", "exchange_rate": 1.000000, "payment_terms": "NET30", "delivery_terms": "Ex-works, 8–10 weeks", "discount_total": 0.00, "parent_quote_id": null}}', 'Sent to customer', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:25.163366+00'),
	('8b909343-ae0b-49d9-8b0a-9660b6c0e809', '023b8d39-f4e0-4672-9c1c-79b54478612e', 1, '{"lines": [{"id": "3545f177-dda1-4f2e-839b-1f9595ec37d9", "line_no": 1, "quantity": 4.000, "tax_rate": 18.00, "line_total": 58452.48, "product_id": "9152c8e7-6ed4-495d-a58c-ee509367659f", "unit_price": 12900.0000, "description": "PV-GV-150 — Gate Valve 150mm CF8M", "discount_pct": 4.00, "quotation_id": "023b8d39-f4e0-4672-9c1c-79b54478612e"}], "quote": {"id": "023b8d39-f4e0-4672-9c1c-79b54478612e", "notes": "Hydrotest certificates and MTCs included.", "org_id": "4a0f88e6-467f-406c-a37b-fde4abff9898", "status": "SENT", "lead_id": null, "version": 2, "currency": "INR", "revision": 1, "subtotal": 51600.00, "tax_total": 8916.48, "company_id": "380afc7f-f7a6-4475-8687-bdab7cedfad0", "contact_id": null, "created_at": "2026-10-27T14:05:25.208676+00:00", "created_by": "0258e002-4154-48b4-ad1d-2195882841be", "updated_at": "2026-10-27T14:05:25.218005+00:00", "updated_by": "0258e002-4154-48b4-ad1d-2195882841be", "grand_total": 58452.48, "valid_until": "2026-11-26", "quote_number": "QUO-2026-000007", "exchange_rate": 1.000000, "payment_terms": "NET30", "delivery_terms": "Ex-works, 8–10 weeks", "discount_total": 2064.00, "parent_quote_id": null}}', 'Sent to customer', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:25.218005+00'),
	('78cb1011-6193-4368-877a-794f653a2216', 'e63491b4-3f5a-4319-a98b-80b04378bc0f', 1, '{"lines": [{"id": "9bfc6fb7-1064-4dea-9ab7-22f2074f571e", "line_no": 1, "quantity": 2.000, "tax_rate": 18.00, "line_total": 7316.00, "product_id": "d61fe768-7f6e-4d65-b1f1-6f5621e2008b", "unit_price": 3100.0000, "description": "PV-GV-050 — Gate Valve 50mm WCB", "discount_pct": 0.00, "quotation_id": "e63491b4-3f5a-4319-a98b-80b04378bc0f"}], "quote": {"id": "e63491b4-3f5a-4319-a98b-80b04378bc0f", "notes": "Hydrotest certificates and MTCs included.", "org_id": "4a0f88e6-467f-406c-a37b-fde4abff9898", "status": "SENT", "lead_id": null, "version": 2, "currency": "INR", "revision": 1, "subtotal": 6200.00, "tax_total": 1116.00, "company_id": "3c5682c9-90ef-4c1a-a319-f763f49889d0", "contact_id": null, "created_at": "2026-10-27T14:05:25.261354+00:00", "created_by": "0258e002-4154-48b4-ad1d-2195882841be", "updated_at": "2026-10-27T14:05:25.270804+00:00", "updated_by": "0258e002-4154-48b4-ad1d-2195882841be", "grand_total": 7316.00, "valid_until": "2026-11-26", "quote_number": "QUO-2026-000008", "exchange_rate": 1.000000, "payment_terms": "NET30", "delivery_terms": "Ex-works, 8–10 weeks", "discount_total": 0.00, "parent_quote_id": null}}', 'Sent to customer', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:25.270804+00'),
	('81f2eb2c-3984-4ac1-bba8-9d3851ab00f8', '7668d975-423a-4704-a27d-3fb0c3478491', 1, '{"lines": [{"id": "5eca5935-9dd3-4cec-a787-489333dab678", "line_no": 1, "quantity": 2.000, "tax_rate": 18.00, "line_total": 19352.00, "product_id": "65e1cab5-04f9-4e45-9081-e07e65803ba9", "unit_price": 8200.0000, "description": "PV-BFV-200 — Butterfly Valve 200mm", "discount_pct": 0.00, "quotation_id": "7668d975-423a-4704-a27d-3fb0c3478491"}], "quote": {"id": "7668d975-423a-4704-a27d-3fb0c3478491", "notes": "Hydrotest certificates and MTCs included.", "org_id": "4a0f88e6-467f-406c-a37b-fde4abff9898", "status": "SENT", "lead_id": null, "version": 2, "currency": "INR", "revision": 1, "subtotal": 16400.00, "tax_total": 2952.00, "company_id": "b93cc6d0-2b05-44d6-ab87-2a4b9cf61a3e", "contact_id": null, "created_at": "2026-10-27T14:05:25.315186+00:00", "created_by": "0258e002-4154-48b4-ad1d-2195882841be", "updated_at": "2026-10-27T14:05:25.325617+00:00", "updated_by": "0258e002-4154-48b4-ad1d-2195882841be", "grand_total": 19352.00, "valid_until": "2026-11-26", "quote_number": "QUO-2026-000009", "exchange_rate": 1.000000, "payment_terms": "NET30", "delivery_terms": "Ex-works, 8–10 weeks", "discount_total": 0.00, "parent_quote_id": null}}', 'Sent to customer', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:25.325617+00'),
	('f77a741e-6dc4-4c85-bdc9-6e4f63fdf330', 'f983962b-2117-4356-b2f4-841a61b80e50', 1, '{"lines": [{"id": "8c6a2531-9412-4428-9856-b3dd3b0d4f33", "line_no": 1, "quantity": 6.000, "tax_rate": 18.00, "line_total": 47181.12, "product_id": "6f56aa1e-de31-44a5-b842-756c12aa7646", "unit_price": 6800.0000, "description": "PV-BV-100 — Ball Valve 100mm CF8M", "discount_pct": 2.00, "quotation_id": "f983962b-2117-4356-b2f4-841a61b80e50"}], "quote": {"id": "f983962b-2117-4356-b2f4-841a61b80e50", "notes": "Hydrotest certificates and MTCs included.", "org_id": "4a0f88e6-467f-406c-a37b-fde4abff9898", "status": "SENT", "lead_id": null, "version": 2, "currency": "INR", "revision": 1, "subtotal": 40800.00, "tax_total": 7197.12, "company_id": "15a84750-6559-46aa-b0a2-6f1920761e68", "contact_id": null, "created_at": "2026-10-27T14:05:25.372984+00:00", "created_by": "0258e002-4154-48b4-ad1d-2195882841be", "updated_at": "2026-10-27T14:05:25.382619+00:00", "updated_by": "0258e002-4154-48b4-ad1d-2195882841be", "grand_total": 47181.12, "valid_until": "2026-11-26", "quote_number": "QUO-2026-000010", "exchange_rate": 1.000000, "payment_terms": "NET30", "delivery_terms": "Ex-works, 8–10 weeks", "discount_total": 816.00, "parent_quote_id": null}}', 'Sent to customer', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:25.382619+00'),
	('8cc1de49-510f-492d-b2ad-a9df14da90b9', '54b98a5d-b260-477a-9f41-9ac2378f3f54', 1, '{"lines": [{"id": "1fec21b6-7aac-4e9d-9d07-46b393078529", "line_no": 1, "quantity": 4.000, "tax_rate": 18.00, "line_total": 38704.00, "product_id": "65e1cab5-04f9-4e45-9081-e07e65803ba9", "unit_price": 8200.0000, "description": "PV-BFV-200 — Butterfly Valve 200mm", "discount_pct": 0.00, "quotation_id": "54b98a5d-b260-477a-9f41-9ac2378f3f54"}], "quote": {"id": "54b98a5d-b260-477a-9f41-9ac2378f3f54", "notes": "Hydrotest certificates and MTCs included.", "org_id": "4a0f88e6-467f-406c-a37b-fde4abff9898", "status": "SENT", "lead_id": null, "version": 2, "currency": "INR", "revision": 1, "subtotal": 32800.00, "tax_total": 5904.00, "company_id": "8adb0ee1-eb89-41e7-871d-e685e2e1ff38", "contact_id": null, "created_at": "2026-10-27T14:05:25.425011+00:00", "created_by": "0258e002-4154-48b4-ad1d-2195882841be", "updated_at": "2026-10-27T14:05:25.434301+00:00", "updated_by": "0258e002-4154-48b4-ad1d-2195882841be", "grand_total": 38704.00, "valid_until": "2026-11-26", "quote_number": "QUO-2026-000011", "exchange_rate": 1.000000, "payment_terms": "NET30", "delivery_terms": "Ex-works, 8–10 weeks", "discount_total": 0.00, "parent_quote_id": null}}', 'Sent to customer', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:25.434301+00'),
	('7f5ce50b-7170-4185-9809-ba178d85b85f', 'fc153539-b57b-41dd-a1ca-c3771f81640a', 1, '{"lines": [{"id": "3ee994fa-0191-4327-9162-ca482a65c4d7", "line_no": 1, "quantity": 10.000, "tax_rate": 18.00, "line_total": 16254.50, "product_id": "82048a24-aa7e-422f-bee0-1642d75bd996", "unit_price": 1450.0000, "description": "PV-BV-025 — Ball Valve 25mm SS316", "discount_pct": 5.00, "quotation_id": "fc153539-b57b-41dd-a1ca-c3771f81640a"}], "quote": {"id": "fc153539-b57b-41dd-a1ca-c3771f81640a", "notes": "Hydrotest certificates and MTCs included.", "org_id": "4a0f88e6-467f-406c-a37b-fde4abff9898", "status": "SENT", "lead_id": null, "version": 2, "currency": "INR", "revision": 1, "subtotal": 14500.00, "tax_total": 2479.50, "company_id": "234b9a3f-6df9-4272-8c0f-7487c2af1990", "contact_id": null, "created_at": "2026-10-27T14:05:25.477025+00:00", "created_by": "0258e002-4154-48b4-ad1d-2195882841be", "updated_at": "2026-10-27T14:05:25.485315+00:00", "updated_by": "0258e002-4154-48b4-ad1d-2195882841be", "grand_total": 16254.50, "valid_until": "2026-11-26", "quote_number": "QUO-2026-000012", "exchange_rate": 1.000000, "payment_terms": "NET30", "delivery_terms": "Ex-works, 8–10 weeks", "discount_total": 725.00, "parent_quote_id": null}}', 'Sent to customer', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:25.485315+00'),
	('8d1e65e7-99c6-4230-afdc-52e486e0e67c', 'cb8dc1b9-2f62-4e6c-8067-e22f2579145e', 1, '{"lines": [{"id": "90625c01-2129-4ee0-a669-67e2e6f9f38e", "line_no": 1, "quantity": 6.000, "tax_rate": 18.00, "line_total": 24072.00, "product_id": "77a428fe-4dd9-4a6e-8138-36a5f4efc6b2", "unit_price": 3400.0000, "description": "PV-GLV-050 — Globe Valve 50mm SS316", "discount_pct": 0.00, "quotation_id": "cb8dc1b9-2f62-4e6c-8067-e22f2579145e"}], "quote": {"id": "cb8dc1b9-2f62-4e6c-8067-e22f2579145e", "notes": "Hydrotest certificates and MTCs included.", "org_id": "4a0f88e6-467f-406c-a37b-fde4abff9898", "status": "SENT", "lead_id": null, "version": 2, "currency": "INR", "revision": 1, "subtotal": 20400.00, "tax_total": 3672.00, "company_id": "25da1635-b03a-4c1a-be08-0ad7d91e99e4", "contact_id": null, "created_at": "2026-10-27T14:05:25.52703+00:00", "created_by": "0258e002-4154-48b4-ad1d-2195882841be", "updated_at": "2026-10-27T14:05:25.535353+00:00", "updated_by": "0258e002-4154-48b4-ad1d-2195882841be", "grand_total": 24072.00, "valid_until": "2026-11-26", "quote_number": "QUO-2026-000013", "exchange_rate": 1.000000, "payment_terms": "NET30", "delivery_terms": "Ex-works, 8–10 weeks", "discount_total": 0.00, "parent_quote_id": null}}', 'Sent to customer', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:25.535353+00'),
	('9d3744dc-dbbe-4d14-b2bc-d70219eb8494', '2a5d0fe2-6b3a-4833-b653-5bb1a354d68d', 1, '{"lines": [{"id": "c7302569-ef0e-4897-ad12-5a6dfaeb8a44", "line_no": 1, "quantity": 8.000, "tax_rate": 18.00, "line_total": 52354.24, "product_id": "eb07eab2-eba7-4b97-88f8-9066662e9a5e", "unit_price": 5900.0000, "description": "PV-GV-080 — Gate Valve 80mm CF8M", "discount_pct": 6.00, "quotation_id": "2a5d0fe2-6b3a-4833-b653-5bb1a354d68d"}], "quote": {"id": "2a5d0fe2-6b3a-4833-b653-5bb1a354d68d", "notes": "Hydrotest certificates and MTCs included.", "org_id": "4a0f88e6-467f-406c-a37b-fde4abff9898", "status": "SENT", "lead_id": null, "version": 2, "currency": "INR", "revision": 1, "subtotal": 47200.00, "tax_total": 7986.24, "company_id": "94b43258-4d8e-48ac-a5b3-04e8607fe937", "contact_id": null, "created_at": "2026-10-27T14:05:25.55128+00:00", "created_by": "0258e002-4154-48b4-ad1d-2195882841be", "updated_at": "2026-10-27T14:05:25.560227+00:00", "updated_by": "0258e002-4154-48b4-ad1d-2195882841be", "grand_total": 52354.24, "valid_until": "2026-11-26", "quote_number": "QUO-2026-000014", "exchange_rate": 1.000000, "payment_terms": "NET30", "delivery_terms": "Ex-works, 8–10 weeks", "discount_total": 2832.00, "parent_quote_id": null}}', 'Sent to customer', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:25.560227+00');


--
-- Data for Name: rate_limits; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.roles VALUES
	('168d5303-7a76-4843-8294-49316f0b0908', 'super_admin', 'Super Admin', NULL, '2026-10-27 14:05:21.445587+00', '2026-10-27 14:05:21.445587+00', 1),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'management', 'Management', NULL, '2026-10-27 14:05:21.445587+00', '2026-10-27 14:05:21.445587+00', 1),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'sales', 'Sales', NULL, '2026-10-27 14:05:21.445587+00', '2026-10-27 14:05:21.445587+00', 1),
	('ec86363f-200b-45f3-b362-989523aef41f', 'engineering', 'Engineering', NULL, '2026-10-27 14:05:21.445587+00', '2026-10-27 14:05:21.445587+00', 1),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'procurement', 'Procurement', NULL, '2026-10-27 14:05:21.445587+00', '2026-10-27 14:05:21.445587+00', 1),
	('4015fd98-58b9-4f93-ac67-74a0855428f1', 'inventory', 'Inventory', NULL, '2026-10-27 14:05:21.445587+00', '2026-10-27 14:05:21.445587+00', 1),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'accounts', 'Accounts', NULL, '2026-10-27 14:05:21.445587+00', '2026-10-27 14:05:21.445587+00', 1),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'quality', 'Quality', NULL, '2026-10-27 14:05:21.445587+00', '2026-10-27 14:05:21.445587+00', 1),
	('6c7b62bf-65e1-4280-9d6a-b0515ea8b8ba', 'production', 'Production', NULL, '2026-10-27 14:05:21.445587+00', '2026-10-27 14:05:21.445587+00', 1),
	('30d88163-7bc7-4173-8ef4-abf80c255d69', 'project_manager', 'Project Manager', NULL, '2026-10-27 14:05:21.445587+00', '2026-10-27 14:05:21.445587+00', 1);


--
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.role_permissions VALUES
	('168d5303-7a76-4843-8294-49316f0b0908', '*'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'lead.view'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'lead.create'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'lead.edit'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'lead.delete'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'lead.approve'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'lead.export'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'lead.manage'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'company.view'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'company.create'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'company.edit'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'company.delete'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'company.approve'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'company.export'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'company.manage'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'contact.view'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'contact.create'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'contact.edit'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'contact.delete'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'contact.approve'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'contact.export'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'contact.manage'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'product.view'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'product.create'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'product.edit'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'product.delete'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'product.approve'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'product.export'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'product.manage'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'partnumber.view'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'partnumber.create'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'partnumber.edit'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'partnumber.delete'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'partnumber.approve'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'partnumber.export'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'partnumber.manage'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'quote.view'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'quote.create'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'quote.edit'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'quote.delete'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'quote.approve'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'quote.export'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'quote.manage'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'order.view'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'order.create'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'order.edit'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'order.delete'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'order.approve'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'order.export'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'order.manage');
INSERT INTO public.role_permissions VALUES
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'engineering.view'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'engineering.create'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'engineering.edit'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'engineering.delete'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'engineering.approve'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'engineering.export'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'engineering.manage'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'drawing.view'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'drawing.create'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'drawing.edit'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'drawing.delete'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'drawing.approve'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'drawing.export'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'drawing.manage'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'bom.view'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'bom.create'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'bom.edit'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'bom.delete'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'bom.approve'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'bom.export'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'bom.manage'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'inventory.view'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'inventory.create'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'inventory.edit'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'inventory.delete'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'inventory.approve'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'inventory.export'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'inventory.manage'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'mrp.view'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'mrp.create'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'mrp.edit'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'mrp.delete'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'mrp.approve'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'mrp.export'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'mrp.manage'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'procurement.view'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'procurement.create'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'procurement.edit'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'procurement.delete'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'procurement.approve'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'procurement.export'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'procurement.manage'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'grn.view'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'grn.create'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'grn.edit'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'grn.delete'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'grn.approve'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'grn.export'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'grn.manage'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'project.view');
INSERT INTO public.role_permissions VALUES
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'project.create'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'project.edit'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'project.delete'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'project.approve'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'project.export'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'project.manage'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'task.view'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'task.create'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'task.edit'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'task.delete'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'task.approve'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'task.export'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'task.manage'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'invoice.view'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'invoice.create'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'invoice.edit'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'invoice.delete'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'invoice.approve'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'invoice.export'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'invoice.manage'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'payment.view'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'payment.create'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'payment.edit'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'payment.delete'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'payment.approve'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'payment.export'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'payment.manage'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'expense.view'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'expense.create'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'expense.edit'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'expense.delete'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'expense.approve'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'expense.export'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'expense.manage'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'document.view'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'document.create'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'document.edit'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'document.delete'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'document.approve'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'document.export'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'document.manage'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'report.view'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'report.create'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'report.edit'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'report.delete'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'report.approve'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'report.export'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'report.manage'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'dashboard.view'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'dashboard.create');
INSERT INTO public.role_permissions VALUES
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'dashboard.edit'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'dashboard.delete'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'dashboard.approve'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'dashboard.export'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'dashboard.manage'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'search.view'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'search.create'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'search.edit'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'search.delete'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'search.approve'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'search.export'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'search.manage'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'admin.view'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'admin.create'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'admin.edit'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'admin.delete'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'admin.approve'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'admin.export'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'admin.manage'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'finance.view'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'finance.create'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'finance.edit'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'finance.delete'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'finance.approve'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'finance.export'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'finance.manage'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'quality.view'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'quality.create'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'quality.edit'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'quality.delete'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'quality.approve'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'quality.export'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'quality.manage'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'production.view'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'production.create'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'production.edit'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'production.delete'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'production.approve'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'production.export'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'production.manage'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'subcontract.view'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'subcontract.create'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'subcontract.edit'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'subcontract.delete'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'subcontract.approve'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'subcontract.export'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'subcontract.manage'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'shipment.view'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'shipment.create'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'shipment.edit');
INSERT INTO public.role_permissions VALUES
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'shipment.delete'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'shipment.approve'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'shipment.export'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'shipment.manage'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'approval.view'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'approval.create'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'approval.edit'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'approval.delete'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'approval.approve'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'approval.export'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'approval.manage'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'integration.view'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'integration.create'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'integration.edit'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'integration.delete'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'integration.approve'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'integration.export'),
	('cf70bbe1-df29-4305-aa5a-1d895a86453f', 'integration.manage'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'lead.view'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'lead.create'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'lead.edit'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'lead.export'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'company.view'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'company.create'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'company.edit'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'company.export'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'contact.view'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'contact.create'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'contact.edit'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'contact.export'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'product.view'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'product.create'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'product.edit'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'product.export'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'quote.view'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'quote.create'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'quote.edit'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'quote.export'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'order.view'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'order.create'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'order.edit'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'order.export'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'task.view'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'task.create'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'task.edit'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'task.export'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'document.view'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'document.create'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'document.edit'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'document.export');
INSERT INTO public.role_permissions VALUES
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'report.view'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'report.create'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'report.edit'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'report.export'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'dashboard.view'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'dashboard.create'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'dashboard.edit'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'dashboard.export'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'search.view'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'search.create'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'search.edit'),
	('4662e854-037e-4e5f-9dd0-ae3c13f73a87', 'search.export'),
	('ec86363f-200b-45f3-b362-989523aef41f', 'product.view'),
	('ec86363f-200b-45f3-b362-989523aef41f', 'product.create'),
	('ec86363f-200b-45f3-b362-989523aef41f', 'product.edit'),
	('ec86363f-200b-45f3-b362-989523aef41f', 'product.approve'),
	('ec86363f-200b-45f3-b362-989523aef41f', 'partnumber.view'),
	('ec86363f-200b-45f3-b362-989523aef41f', 'partnumber.create'),
	('ec86363f-200b-45f3-b362-989523aef41f', 'partnumber.edit'),
	('ec86363f-200b-45f3-b362-989523aef41f', 'partnumber.approve'),
	('ec86363f-200b-45f3-b362-989523aef41f', 'order.view'),
	('ec86363f-200b-45f3-b362-989523aef41f', 'order.create'),
	('ec86363f-200b-45f3-b362-989523aef41f', 'order.edit'),
	('ec86363f-200b-45f3-b362-989523aef41f', 'order.approve'),
	('ec86363f-200b-45f3-b362-989523aef41f', 'engineering.view'),
	('ec86363f-200b-45f3-b362-989523aef41f', 'engineering.create'),
	('ec86363f-200b-45f3-b362-989523aef41f', 'engineering.edit'),
	('ec86363f-200b-45f3-b362-989523aef41f', 'engineering.approve'),
	('ec86363f-200b-45f3-b362-989523aef41f', 'drawing.view'),
	('ec86363f-200b-45f3-b362-989523aef41f', 'drawing.create'),
	('ec86363f-200b-45f3-b362-989523aef41f', 'drawing.edit'),
	('ec86363f-200b-45f3-b362-989523aef41f', 'drawing.approve'),
	('ec86363f-200b-45f3-b362-989523aef41f', 'bom.view'),
	('ec86363f-200b-45f3-b362-989523aef41f', 'bom.create'),
	('ec86363f-200b-45f3-b362-989523aef41f', 'bom.edit'),
	('ec86363f-200b-45f3-b362-989523aef41f', 'bom.approve'),
	('ec86363f-200b-45f3-b362-989523aef41f', 'task.view'),
	('ec86363f-200b-45f3-b362-989523aef41f', 'task.create'),
	('ec86363f-200b-45f3-b362-989523aef41f', 'task.edit'),
	('ec86363f-200b-45f3-b362-989523aef41f', 'task.approve'),
	('ec86363f-200b-45f3-b362-989523aef41f', 'document.view'),
	('ec86363f-200b-45f3-b362-989523aef41f', 'document.create'),
	('ec86363f-200b-45f3-b362-989523aef41f', 'document.edit'),
	('ec86363f-200b-45f3-b362-989523aef41f', 'document.approve'),
	('ec86363f-200b-45f3-b362-989523aef41f', 'dashboard.view'),
	('ec86363f-200b-45f3-b362-989523aef41f', 'dashboard.create'),
	('ec86363f-200b-45f3-b362-989523aef41f', 'dashboard.edit'),
	('ec86363f-200b-45f3-b362-989523aef41f', 'dashboard.approve'),
	('ec86363f-200b-45f3-b362-989523aef41f', 'search.view'),
	('ec86363f-200b-45f3-b362-989523aef41f', 'search.create');
INSERT INTO public.role_permissions VALUES
	('ec86363f-200b-45f3-b362-989523aef41f', 'search.edit'),
	('ec86363f-200b-45f3-b362-989523aef41f', 'search.approve'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'company.view'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'company.create'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'company.edit'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'company.approve'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'product.view'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'product.create'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'product.edit'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'product.approve'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'order.view'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'order.create'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'order.edit'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'order.approve'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'inventory.view'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'inventory.create'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'inventory.edit'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'inventory.approve'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'mrp.view'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'mrp.create'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'mrp.edit'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'mrp.approve'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'procurement.view'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'procurement.create'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'procurement.edit'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'procurement.approve'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'grn.view'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'grn.create'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'grn.edit'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'grn.approve'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'task.view'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'task.create'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'task.edit'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'task.approve'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'document.view'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'document.create'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'document.edit'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'document.approve'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'dashboard.view'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'dashboard.create'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'dashboard.edit'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'dashboard.approve'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'search.view'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'search.create'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'search.edit'),
	('9b0b7b8c-4197-49cc-af59-e240e96a60e7', 'search.approve'),
	('4015fd98-58b9-4f93-ac67-74a0855428f1', 'product.view'),
	('4015fd98-58b9-4f93-ac67-74a0855428f1', 'product.create'),
	('4015fd98-58b9-4f93-ac67-74a0855428f1', 'product.edit'),
	('4015fd98-58b9-4f93-ac67-74a0855428f1', 'inventory.view');
INSERT INTO public.role_permissions VALUES
	('4015fd98-58b9-4f93-ac67-74a0855428f1', 'inventory.create'),
	('4015fd98-58b9-4f93-ac67-74a0855428f1', 'inventory.edit'),
	('4015fd98-58b9-4f93-ac67-74a0855428f1', 'mrp.view'),
	('4015fd98-58b9-4f93-ac67-74a0855428f1', 'mrp.create'),
	('4015fd98-58b9-4f93-ac67-74a0855428f1', 'mrp.edit'),
	('4015fd98-58b9-4f93-ac67-74a0855428f1', 'grn.view'),
	('4015fd98-58b9-4f93-ac67-74a0855428f1', 'grn.create'),
	('4015fd98-58b9-4f93-ac67-74a0855428f1', 'grn.edit'),
	('4015fd98-58b9-4f93-ac67-74a0855428f1', 'task.view'),
	('4015fd98-58b9-4f93-ac67-74a0855428f1', 'task.create'),
	('4015fd98-58b9-4f93-ac67-74a0855428f1', 'task.edit'),
	('4015fd98-58b9-4f93-ac67-74a0855428f1', 'document.view'),
	('4015fd98-58b9-4f93-ac67-74a0855428f1', 'document.create'),
	('4015fd98-58b9-4f93-ac67-74a0855428f1', 'document.edit'),
	('4015fd98-58b9-4f93-ac67-74a0855428f1', 'dashboard.view'),
	('4015fd98-58b9-4f93-ac67-74a0855428f1', 'dashboard.create'),
	('4015fd98-58b9-4f93-ac67-74a0855428f1', 'dashboard.edit'),
	('4015fd98-58b9-4f93-ac67-74a0855428f1', 'search.view'),
	('4015fd98-58b9-4f93-ac67-74a0855428f1', 'search.create'),
	('4015fd98-58b9-4f93-ac67-74a0855428f1', 'search.edit'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'company.view'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'company.create'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'company.edit'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'company.approve'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'company.export'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'order.view'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'order.create'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'order.edit'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'order.approve'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'order.export'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'invoice.view'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'invoice.create'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'invoice.edit'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'invoice.approve'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'invoice.export'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'payment.view'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'payment.create'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'payment.edit'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'payment.approve'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'payment.export'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'expense.view'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'expense.create'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'expense.edit'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'expense.approve'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'expense.export'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'document.view'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'document.create'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'document.edit'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'document.approve'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'document.export');
INSERT INTO public.role_permissions VALUES
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'report.view'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'report.create'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'report.edit'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'report.approve'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'report.export'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'dashboard.view'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'dashboard.create'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'dashboard.edit'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'dashboard.approve'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'dashboard.export'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'search.view'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'search.create'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'search.edit'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'search.approve'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'search.export'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'finance.view'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'finance.create'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'finance.edit'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'finance.approve'),
	('222a746b-e855-46b5-9ee9-ef6a3f855592', 'finance.export'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'product.view'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'product.create'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'product.edit'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'product.approve'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'order.view'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'order.create'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'order.edit'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'order.approve'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'inventory.view'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'inventory.create'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'inventory.edit'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'inventory.approve'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'grn.view'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'grn.create'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'grn.edit'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'grn.approve'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'task.view'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'task.create'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'task.edit'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'task.approve'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'document.view'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'document.create'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'document.edit'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'document.approve'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'dashboard.view'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'dashboard.create'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'dashboard.edit'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'dashboard.approve'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'search.view'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'search.create');
INSERT INTO public.role_permissions VALUES
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'search.edit'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'search.approve'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'quality.view'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'quality.create'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'quality.edit'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'quality.approve'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'production.view'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'production.create'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'production.edit'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'production.approve'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'shipment.view'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'shipment.create'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'shipment.edit'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'shipment.approve'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'approval.view'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'approval.create'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'approval.edit'),
	('6654d60b-bffc-4d51-ac64-19aedd897182', 'approval.approve'),
	('6c7b62bf-65e1-4280-9d6a-b0515ea8b8ba', 'product.view'),
	('6c7b62bf-65e1-4280-9d6a-b0515ea8b8ba', 'product.create'),
	('6c7b62bf-65e1-4280-9d6a-b0515ea8b8ba', 'product.edit'),
	('6c7b62bf-65e1-4280-9d6a-b0515ea8b8ba', 'order.view'),
	('6c7b62bf-65e1-4280-9d6a-b0515ea8b8ba', 'order.create'),
	('6c7b62bf-65e1-4280-9d6a-b0515ea8b8ba', 'order.edit'),
	('6c7b62bf-65e1-4280-9d6a-b0515ea8b8ba', 'inventory.view'),
	('6c7b62bf-65e1-4280-9d6a-b0515ea8b8ba', 'inventory.create'),
	('6c7b62bf-65e1-4280-9d6a-b0515ea8b8ba', 'inventory.edit'),
	('6c7b62bf-65e1-4280-9d6a-b0515ea8b8ba', 'task.view'),
	('6c7b62bf-65e1-4280-9d6a-b0515ea8b8ba', 'task.create'),
	('6c7b62bf-65e1-4280-9d6a-b0515ea8b8ba', 'task.edit'),
	('6c7b62bf-65e1-4280-9d6a-b0515ea8b8ba', 'document.view'),
	('6c7b62bf-65e1-4280-9d6a-b0515ea8b8ba', 'document.create'),
	('6c7b62bf-65e1-4280-9d6a-b0515ea8b8ba', 'document.edit'),
	('6c7b62bf-65e1-4280-9d6a-b0515ea8b8ba', 'dashboard.view'),
	('6c7b62bf-65e1-4280-9d6a-b0515ea8b8ba', 'dashboard.create'),
	('6c7b62bf-65e1-4280-9d6a-b0515ea8b8ba', 'dashboard.edit'),
	('6c7b62bf-65e1-4280-9d6a-b0515ea8b8ba', 'search.view'),
	('6c7b62bf-65e1-4280-9d6a-b0515ea8b8ba', 'search.create'),
	('6c7b62bf-65e1-4280-9d6a-b0515ea8b8ba', 'search.edit'),
	('6c7b62bf-65e1-4280-9d6a-b0515ea8b8ba', 'quality.view'),
	('6c7b62bf-65e1-4280-9d6a-b0515ea8b8ba', 'quality.create'),
	('6c7b62bf-65e1-4280-9d6a-b0515ea8b8ba', 'quality.edit'),
	('6c7b62bf-65e1-4280-9d6a-b0515ea8b8ba', 'production.view'),
	('6c7b62bf-65e1-4280-9d6a-b0515ea8b8ba', 'production.create'),
	('6c7b62bf-65e1-4280-9d6a-b0515ea8b8ba', 'production.edit'),
	('6c7b62bf-65e1-4280-9d6a-b0515ea8b8ba', 'subcontract.view'),
	('6c7b62bf-65e1-4280-9d6a-b0515ea8b8ba', 'subcontract.create'),
	('6c7b62bf-65e1-4280-9d6a-b0515ea8b8ba', 'subcontract.edit'),
	('6c7b62bf-65e1-4280-9d6a-b0515ea8b8ba', 'shipment.view'),
	('6c7b62bf-65e1-4280-9d6a-b0515ea8b8ba', 'shipment.create');
INSERT INTO public.role_permissions VALUES
	('6c7b62bf-65e1-4280-9d6a-b0515ea8b8ba', 'shipment.edit'),
	('30d88163-7bc7-4173-8ef4-abf80c255d69', 'order.view'),
	('30d88163-7bc7-4173-8ef4-abf80c255d69', 'order.create'),
	('30d88163-7bc7-4173-8ef4-abf80c255d69', 'order.edit'),
	('30d88163-7bc7-4173-8ef4-abf80c255d69', 'order.approve'),
	('30d88163-7bc7-4173-8ef4-abf80c255d69', 'project.view'),
	('30d88163-7bc7-4173-8ef4-abf80c255d69', 'project.create'),
	('30d88163-7bc7-4173-8ef4-abf80c255d69', 'project.edit'),
	('30d88163-7bc7-4173-8ef4-abf80c255d69', 'project.approve'),
	('30d88163-7bc7-4173-8ef4-abf80c255d69', 'task.view'),
	('30d88163-7bc7-4173-8ef4-abf80c255d69', 'task.create'),
	('30d88163-7bc7-4173-8ef4-abf80c255d69', 'task.edit'),
	('30d88163-7bc7-4173-8ef4-abf80c255d69', 'task.approve'),
	('30d88163-7bc7-4173-8ef4-abf80c255d69', 'document.view'),
	('30d88163-7bc7-4173-8ef4-abf80c255d69', 'document.create'),
	('30d88163-7bc7-4173-8ef4-abf80c255d69', 'document.edit'),
	('30d88163-7bc7-4173-8ef4-abf80c255d69', 'document.approve'),
	('30d88163-7bc7-4173-8ef4-abf80c255d69', 'dashboard.view'),
	('30d88163-7bc7-4173-8ef4-abf80c255d69', 'dashboard.create'),
	('30d88163-7bc7-4173-8ef4-abf80c255d69', 'dashboard.edit'),
	('30d88163-7bc7-4173-8ef4-abf80c255d69', 'dashboard.approve'),
	('30d88163-7bc7-4173-8ef4-abf80c255d69', 'search.view'),
	('30d88163-7bc7-4173-8ef4-abf80c255d69', 'search.create'),
	('30d88163-7bc7-4173-8ef4-abf80c255d69', 'search.edit'),
	('30d88163-7bc7-4173-8ef4-abf80c255d69', 'search.approve');


--
-- Data for Name: sales_order_lines; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.sales_order_lines VALUES
	('f5ea5fb4-d6d9-4039-9e60-7a139b57e019', '84f16360-acd8-4658-a08c-5095e56335a6', 2, 'abe0ed52-e0fd-424a-b2d4-00c1c625767f', 'PV-SEAT-01 — PTFE Seat Ring', 3.000, 180.0000, 0.00, 18.00, 637.20, 0.000, 0.000),
	('7679569c-3ad5-4953-9932-f5b3ee58131c', '08c81785-76c6-4ce9-9c02-f0d075c9befc', 1, '82048a24-aa7e-422f-bee0-1642d75bd996', 'PV-BV-025 — Ball Valve 25mm SS316', 3.000, 1450.0000, 0.00, 18.00, 5133.00, 0.000, 0.000),
	('8f69fc43-0f4f-4784-85a6-dc90141e3f9e', '5150e791-ad57-45a1-9173-962ee330f78f', 1, '77a428fe-4dd9-4a6e-8138-36a5f4efc6b2', 'PV-GLV-050 — Globe Valve 50mm SS316', 3.000, 3400.0000, 0.00, 18.00, 12036.00, 0.000, 0.000),
	('6367a2f2-09a4-42ce-9cf6-5222cafbd6d7', 'd7896924-f01a-474e-afe1-ef33836afd2f', 1, '6f56aa1e-de31-44a5-b842-756c12aa7646', 'PV-BV-100 — Ball Valve 100mm CF8M', 2.000, 6800.0000, 0.00, 18.00, 16048.00, 0.000, 0.000),
	('277314a5-9ea5-408b-b43d-e79c21975c91', '498e3f4d-22ff-4b1e-a1ab-43e37332b591', 1, '9152c8e7-6ed4-495d-a58c-ee509367659f', 'PV-GV-150 — Gate Valve 150mm CF8M', 4.000, 12900.0000, 4.00, 18.00, 58452.48, 0.000, 0.000),
	('03614c84-da91-4f1c-9da5-2181a6a3b9b1', '4e36052e-0a7c-47ae-94dd-8c74ff17ee6e', 1, 'd61fe768-7f6e-4d65-b1f1-6f5621e2008b', 'PV-GV-050 — Gate Valve 50mm WCB', 2.000, 3100.0000, 0.00, 18.00, 7316.00, 0.000, 0.000),
	('1607d249-4c7c-4be1-9431-617b1133f4cf', 'c8daa3b5-bd9e-41fe-83ca-f53a2138d16d', 1, '65e1cab5-04f9-4e45-9081-e07e65803ba9', 'PV-BFV-200 — Butterfly Valve 200mm', 2.000, 8200.0000, 0.00, 18.00, 19352.00, 0.000, 0.000),
	('3413434c-047b-4348-8b13-20843d2e6978', '17faff62-40d5-4b82-a2bb-e6c64e3162be', 1, '6f56aa1e-de31-44a5-b842-756c12aa7646', 'PV-BV-100 — Ball Valve 100mm CF8M', 6.000, 6800.0000, 2.00, 18.00, 47181.12, 0.000, 0.000),
	('b2bd5c6a-c6b5-49fd-a543-00fd5f61f75b', '23f877c9-0add-44dc-b617-5e7e48c1e841', 1, '65e1cab5-04f9-4e45-9081-e07e65803ba9', 'PV-BFV-200 — Butterfly Valve 200mm', 4.000, 8200.0000, 0.00, 18.00, 38704.00, 0.000, 0.000),
	('59b2668c-9261-4a3e-90b8-8d3cf086e937', 'afc38366-3c26-4a27-a1cc-e811550d9b5c', 1, '82048a24-aa7e-422f-bee0-1642d75bd996', 'PV-BV-025 — Ball Valve 25mm SS316', 10.000, 1450.0000, 5.00, 18.00, 16254.50, 0.000, 0.000),
	('5d578c24-f602-4206-ab29-654e884a54dc', '84f16360-acd8-4658-a08c-5095e56335a6', 1, '6e212887-960b-4eed-ade6-18715e05c5cb', 'PV-BV-050 — Ball Valve 50mm SS316', 3.000, 2100.0000, 5.00, 18.00, 7062.30, 3.000, 0.000),
	('a2989571-dfe2-4672-90dd-426bc01a6c87', '0bbed72f-1aff-49df-867f-4201b53b165f', 1, 'eb07eab2-eba7-4b97-88f8-9066662e9a5e', 'PV-GV-080 — Gate Valve 80mm CF8M', 4.000, 5900.0000, 3.00, 18.00, 27012.56, 2.000, 0.000),
	('67b6978b-7660-4cdb-b8c0-e1f07e922f32', 'bc2c7461-b1cd-4c66-8996-611e28098035', 1, '92a93794-1287-4b7d-8868-7b9b81b87cb2', 'PV-CV-050 — Check Valve 50mm SS316', 2.000, 2400.0000, 0.00, 18.00, 5664.00, 2.000, 0.000);


--
-- Data for Name: serial_units; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.serial_units VALUES
	('e026d7e0-1793-48a6-8e1d-55052368ee86', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PV-2026-00006', 'TAG-GV--105', 'eb07eab2-eba7-4b97-88f8-9066662e9a5e', '6f1dd7e0-32bb-4c8a-a0d9-25e051a1a9b1', '0bbed72f-1aff-49df-867f-4201b53b165f', 'DRW-2026-000005 Rev 1', '{"assembled_at": "2026-10-27T14:05:27.550Z", "assembled_by": "Suresh Pillai (Production)"}', 'AWAITING_FINAL', '[{"ok": true, "name": "Torque check"}, {"ok": true, "name": "Stem travel / operation"}]', '2026-10-27 14:05:27.546297+00', NULL),
	('1e0f70f6-1106-4b94-bbf5-f54796d3349d', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PV-2026-00007', 'TAG-GV--106', 'eb07eab2-eba7-4b97-88f8-9066662e9a5e', '6f1dd7e0-32bb-4c8a-a0d9-25e051a1a9b1', '0bbed72f-1aff-49df-867f-4201b53b165f', 'DRW-2026-000005 Rev 1', '{"assembled_at": "2026-10-27T14:05:27.563Z", "assembled_by": "Suresh Pillai (Production)"}', 'AWAITING_FINAL', '[{"ok": true, "name": "Torque check"}, {"ok": true, "name": "Stem travel / operation"}]', '2026-10-27 14:05:27.559672+00', NULL),
	('889f17af-4522-46de-a212-c9fc160fe4c5', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PV-2026-00011', 'TAG-GLV-110', '77a428fe-4dd9-4a6e-8138-36a5f4efc6b2', 'd996f72b-9fab-4c89-878a-34c63fe6f3ea', '5150e791-ad57-45a1-9173-962ee330f78f', 'DRW-2026-000007 Rev 1', '{"assembled_at": "2026-10-27T14:05:27.619Z", "assembled_by": "Suresh Pillai (Production)"}', 'AWAITING_FINAL', '[{"ok": true, "name": "Torque check"}, {"ok": true, "name": "Stem travel / operation"}]', '2026-10-27 14:05:27.615477+00', NULL),
	('e7390bf4-8562-4115-ba09-42cec5480e45', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PV-2026-00012', 'TAG-GLV-111', '77a428fe-4dd9-4a6e-8138-36a5f4efc6b2', 'd996f72b-9fab-4c89-878a-34c63fe6f3ea', '5150e791-ad57-45a1-9173-962ee330f78f', 'DRW-2026-000007 Rev 1', '{"assembled_at": "2026-10-27T14:05:27.635Z", "assembled_by": "Suresh Pillai (Production)"}', 'AWAITING_FINAL', '[{"ok": true, "name": "Torque check"}, {"ok": true, "name": "Stem travel / operation"}]', '2026-10-27 14:05:27.630934+00', NULL),
	('38b43ff4-03c6-4021-a195-4b8973395fdc', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PV-2026-00013', 'TAG-GLV-112', '77a428fe-4dd9-4a6e-8138-36a5f4efc6b2', 'd996f72b-9fab-4c89-878a-34c63fe6f3ea', '5150e791-ad57-45a1-9173-962ee330f78f', 'DRW-2026-000007 Rev 1', '{"assembled_at": "2026-10-27T14:05:27.650Z", "assembled_by": "Suresh Pillai (Production)"}', 'AWAITING_FINAL', '[{"ok": true, "name": "Torque check"}, {"ok": true, "name": "Stem travel / operation"}]', '2026-10-27 14:05:27.645378+00', NULL),
	('e612e4b3-497c-470c-8396-74a36728f675', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PV-2026-00008', 'TAG-BV--107', '82048a24-aa7e-422f-bee0-1642d75bd996', 'a96efb75-c93f-4af2-b48a-4962753900cd', '08c81785-76c6-4ce9-9c02-f0d075c9befc', 'DRW-2026-000001 Rev 1', '{"assembled_at": "2026-10-27T14:05:27.577Z", "assembled_by": "Suresh Pillai (Production)"}', 'RELEASED', '[{"ok": true, "name": "Torque check"}, {"ok": true, "name": "Stem travel / operation"}]', '2026-10-27 14:05:27.572718+00', '2026-10-27 14:05:28.089233+00'),
	('326a1502-8dcd-4de5-acf8-f5b56b4ec57c', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PV-2026-00009', 'TAG-BV--108', '82048a24-aa7e-422f-bee0-1642d75bd996', 'a96efb75-c93f-4af2-b48a-4962753900cd', '08c81785-76c6-4ce9-9c02-f0d075c9befc', 'DRW-2026-000001 Rev 1', '{"assembled_at": "2026-10-27T14:05:27.592Z", "assembled_by": "Suresh Pillai (Production)"}', 'RELEASED', '[{"ok": true, "name": "Torque check"}, {"ok": true, "name": "Stem travel / operation"}]', '2026-10-27 14:05:27.58727+00', '2026-10-27 14:05:28.137957+00'),
	('1f31d15f-0bf3-45b3-991b-db09ef7af236', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PV-2026-00018', 'TAG-GV--117', 'd61fe768-7f6e-4d65-b1f1-6f5621e2008b', '8ebcb809-6629-4f68-add0-926ef84e4337', '4e36052e-0a7c-47ae-94dd-8c74ff17ee6e', 'DRW-2026-000004 Rev 1', '{"assembled_at": "2026-10-27T14:05:27.728Z", "assembled_by": "Suresh Pillai (Production)"}', 'RELEASED', '[{"ok": true, "name": "Torque check"}, {"ok": true, "name": "Stem travel / operation"}]', '2026-10-27 14:05:27.722353+00', '2026-10-27 14:05:28.303184+00'),
	('92d9db2b-a78c-4256-bbf9-24dfafbec521', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PV-2026-00019', 'TAG-GV--118', 'd61fe768-7f6e-4d65-b1f1-6f5621e2008b', '8ebcb809-6629-4f68-add0-926ef84e4337', '4e36052e-0a7c-47ae-94dd-8c74ff17ee6e', 'DRW-2026-000004 Rev 1', '{"assembled_at": "2026-10-27T14:05:27.745Z", "assembled_by": "Suresh Pillai (Production)"}', 'RELEASED', '[{"ok": true, "name": "Torque check"}, {"ok": true, "name": "Stem travel / operation"}]', '2026-10-27 14:05:27.739742+00', '2026-10-27 14:05:28.367684+00'),
	('b23230f2-f025-43ed-82dc-75a1c78a3ea1', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PV-2026-00020', 'TAG-BFV-119', '65e1cab5-04f9-4e45-9081-e07e65803ba9', 'b4d2e412-f532-4bd4-8101-e08fd008857d', 'c8daa3b5-bd9e-41fe-83ca-f53a2138d16d', 'DRW-2026-000008 Rev 1', '{"assembled_at": "2026-10-27T14:05:27.760Z", "assembled_by": "Suresh Pillai (Production)"}', 'RELEASED', '[{"ok": true, "name": "Torque check"}, {"ok": true, "name": "Stem travel / operation"}]', '2026-10-27 14:05:27.754994+00', '2026-10-27 14:05:28.428867+00'),
	('6140c882-132d-428a-9759-c01123be0297', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PV-2026-00021', 'TAG-BFV-120', '65e1cab5-04f9-4e45-9081-e07e65803ba9', 'b4d2e412-f532-4bd4-8101-e08fd008857d', 'c8daa3b5-bd9e-41fe-83ca-f53a2138d16d', 'DRW-2026-000008 Rev 1', '{"assembled_at": "2026-10-27T14:05:27.777Z", "assembled_by": "Suresh Pillai (Production)"}', 'RELEASED', '[{"ok": true, "name": "Torque check"}, {"ok": true, "name": "Stem travel / operation"}]', '2026-10-27 14:05:27.772201+00', '2026-10-27 14:05:28.486223+00'),
	('25dd99d8-20bf-48f8-bece-c7e4f0bf1514', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PV-2026-00010', 'TAG-BV--109', '82048a24-aa7e-422f-bee0-1642d75bd996', 'a96efb75-c93f-4af2-b48a-4962753900cd', '08c81785-76c6-4ce9-9c02-f0d075c9befc', 'DRW-2026-000001 Rev 1', '{"assembled_at": "2026-10-27T14:05:27.605Z", "assembled_by": "Suresh Pillai (Production)"}', 'RELEASED', '[{"ok": true, "name": "Torque check"}, {"ok": true, "name": "Stem travel / operation"}]', '2026-10-27 14:05:27.601432+00', '2026-10-27 14:05:28.568526+00'),
	('59f83746-e6fc-49f4-a77b-cb821493e11f', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PV-2026-00002', 'TAG-BV--101', '6e212887-960b-4eed-ade6-18715e05c5cb', '71cb5f2d-7cf9-4623-a70b-7baeb9c1b66c', '84f16360-acd8-4658-a08c-5095e56335a6', 'DRW-2026-000002 Rev 1', '{"assembled_at": "2026-10-27T14:05:27.491Z", "assembled_by": "Suresh Pillai (Production)"}', 'SHIPPED', '[{"ok": true, "name": "Torque check"}, {"ok": true, "name": "Stem travel / operation"}]', '2026-10-27 14:05:27.48586+00', '2026-10-27 14:05:27.88256+00'),
	('a54cf213-c4dd-4f12-a524-d401753e81b5', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PV-2026-00016', 'TAG-BV--115', '6f56aa1e-de31-44a5-b842-756c12aa7646', '56925ee4-f597-4196-b51e-59ca9740cc60', 'd7896924-f01a-474e-afe1-ef33836afd2f', 'DRW-2026-000003 Rev 1', '{"assembled_at": "2026-10-27T14:05:27.694Z", "assembled_by": "Suresh Pillai (Production)"}', 'QUARANTINE', '[{"ok": true, "name": "Torque check"}, {"ok": true, "name": "Stem travel / operation"}]', '2026-10-27 14:05:27.688292+00', NULL),
	('afdd35b7-be62-4847-a82c-64b8ddf1b75f', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PV-2026-00017', 'TAG-BV--116', '6f56aa1e-de31-44a5-b842-756c12aa7646', '56925ee4-f597-4196-b51e-59ca9740cc60', 'd7896924-f01a-474e-afe1-ef33836afd2f', 'DRW-2026-000003 Rev 1', '{"assembled_at": "2026-10-27T14:05:27.712Z", "assembled_by": "Suresh Pillai (Production)"}', 'RELEASED', '[{"ok": true, "name": "Torque check"}, {"ok": true, "name": "Stem travel / operation"}]', '2026-10-27 14:05:27.705546+00', '2026-10-27 14:05:28.663419+00'),
	('400708e9-52e1-4214-b07c-c7837dbeeb2c', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PV-2026-00004', 'TAG-GV--103', 'eb07eab2-eba7-4b97-88f8-9066662e9a5e', '6f1dd7e0-32bb-4c8a-a0d9-25e051a1a9b1', '0bbed72f-1aff-49df-867f-4201b53b165f', 'DRW-2026-000005 Rev 1', '{"assembled_at": "2026-10-27T14:05:27.521Z", "assembled_by": "Suresh Pillai (Production)"}', 'SHIPPED', '[{"ok": true, "name": "Torque check"}, {"ok": true, "name": "Stem travel / operation"}]', '2026-10-27 14:05:27.515924+00', '2026-10-27 14:05:27.991128+00'),
	('f287ea25-7179-4e4d-a695-4bb1414938da', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PV-2026-00005', 'TAG-GV--104', 'eb07eab2-eba7-4b97-88f8-9066662e9a5e', '6f1dd7e0-32bb-4c8a-a0d9-25e051a1a9b1', '0bbed72f-1aff-49df-867f-4201b53b165f', 'DRW-2026-000005 Rev 1', '{"assembled_at": "2026-10-27T14:05:27.536Z", "assembled_by": "Suresh Pillai (Production)"}', 'SHIPPED', '[{"ok": true, "name": "Torque check"}, {"ok": true, "name": "Stem travel / operation"}]', '2026-10-27 14:05:27.532344+00', '2026-10-27 14:05:28.040789+00'),
	('c8b7b4fb-6148-494b-990d-b2b14b6350b3', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PV-2026-00014', 'TAG-CV--113', '92a93794-1287-4b7d-8868-7b9b81b87cb2', 'aed5986d-07e3-4fc5-9aae-74d6c3de22ff', 'bc2c7461-b1cd-4c66-8996-611e28098035', 'DRW-2026-000006 Rev 1', '{"assembled_at": "2026-10-27T14:05:27.664Z", "assembled_by": "Suresh Pillai (Production)"}', 'SHIPPED', '[{"ok": true, "name": "Torque check"}, {"ok": true, "name": "Stem travel / operation"}]', '2026-10-27 14:05:27.659945+00', '2026-10-27 14:05:28.188109+00'),
	('451711cb-bdb5-46aa-a135-e7bb6ce9a477', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PV-2026-00015', 'TAG-CV--114', '92a93794-1287-4b7d-8868-7b9b81b87cb2', 'aed5986d-07e3-4fc5-9aae-74d6c3de22ff', 'bc2c7461-b1cd-4c66-8996-611e28098035', 'DRW-2026-000006 Rev 1', '{"assembled_at": "2026-10-27T14:05:27.679Z", "assembled_by": "Suresh Pillai (Production)"}', 'SHIPPED', '[{"ok": true, "name": "Torque check"}, {"ok": true, "name": "Stem travel / operation"}]', '2026-10-27 14:05:27.674511+00', '2026-10-27 14:05:28.241875+00'),
	('4cb646d1-3878-4424-b41c-fdcf1caceca0', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PV-2026-00003', 'TAG-BV--102', '6e212887-960b-4eed-ade6-18715e05c5cb', '71cb5f2d-7cf9-4623-a70b-7baeb9c1b66c', '84f16360-acd8-4658-a08c-5095e56335a6', 'DRW-2026-000002 Rev 1', '{"assembled_at": "2026-10-27T14:05:27.505Z", "assembled_by": "Suresh Pillai (Production)"}', 'SHIPPED', '[{"ok": true, "name": "Torque check"}, {"ok": true, "name": "Stem travel / operation"}]', '2026-10-27 14:05:27.500975+00', '2026-10-27 14:05:27.935548+00'),
	('4ec63d7c-4c91-4963-834e-c9837b80f2d6', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'PV-2026-00001', 'TAG-BV--100', '6e212887-960b-4eed-ade6-18715e05c5cb', '71cb5f2d-7cf9-4623-a70b-7baeb9c1b66c', '84f16360-acd8-4658-a08c-5095e56335a6', 'DRW-2026-000002 Rev 1', '{"assembled_at": "2026-10-27T14:05:27.473Z", "assembled_by": "Suresh Pillai (Production)"}', 'SHIPPED', '[{"ok": true, "name": "Torque check"}, {"ok": true, "name": "Stem travel / operation"}]', '2026-10-27 14:05:27.465974+00', '2026-10-27 14:05:27.83035+00');


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: settings; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: shipments; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.shipments VALUES
	('9daa4c8a-5c46-42d9-9043-fd3f27894ce6', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SHP-2026-000001', '84f16360-acd8-4658-a08c-5095e56335a6', 'SHIPPED', false, NULL, NULL, 'Blue Dart Freight', NULL, '{"mtc": true, "export_docs": true, "packing_list": true}', '2026-10-27 14:05:28.697137+00', NULL, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:28.674673+00', '2026-10-27 14:05:28.697137+00', 3),
	('e69f1135-e2e7-4789-b7d8-0338d785cd5d', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SHP-2026-000002', '0bbed72f-1aff-49df-867f-4201b53b165f', 'SHIPPED', true, NULL, NULL, 'VRL Logistics', NULL, '{"mtc": true, "export_docs": true, "packing_list": true}', '2026-10-27 14:05:28.733323+00', NULL, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:28.71413+00', '2026-10-27 14:05:28.733323+00', 3),
	('34487842-ee98-451e-b927-f22db4697158', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SHP-2026-000003', 'bc2c7461-b1cd-4c66-8996-611e28098035', 'SHIPPED', false, NULL, NULL, 'DTDC Industrial', NULL, '{"mtc": true, "export_docs": true, "packing_list": true}', '2026-10-27 14:05:28.765626+00', NULL, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:28.747875+00', '2026-10-27 14:05:28.765626+00', 3),
	('d1930648-ceec-440d-becc-0dfe724e9b41', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SHP-2026-000004', '08c81785-76c6-4ce9-9c02-f0d075c9befc', 'BLOCKED', false, 'Customer documents: Missing: material/test certificates [owner: Dispatch]', NULL, 'Gati', NULL, '{"packing_list": true}', NULL, NULL, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:28.779478+00', '2026-10-27 14:05:28.797765+00', 3),
	('771f7e34-04fa-493e-9e97-226ee5bf4110', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SHP-2026-000005', '4e36052e-0a7c-47ae-94dd-8c74ff17ee6e', 'BLOCKED', false, 'Credit check: Sahara Fertilizers Ltd is on credit hold [owner: Accounts]', NULL, 'Safexpress', NULL, '{"mtc": true, "export_docs": true, "packing_list": true}', NULL, NULL, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:28.80925+00', '2026-10-27 14:05:28.826736+00', 3),
	('9c0b36db-59e8-4b76-b738-1b18d474c762', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SHP-2026-000006', 'c8daa3b5-bd9e-41fe-83ca-f53a2138d16d', 'BLOCKED', false, 'Export clearance: Customer not export-cleared (screening pending) [owner: Logistics]', NULL, 'Maersk Line', NULL, '{"mtc": true, "packing_list": true}', NULL, NULL, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:28.83771+00', '2026-10-27 14:05:28.857648+00', 3),
	('728bbe23-7529-49c9-a6f7-aeba8655c86e', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SHP-2026-000007', '5150e791-ad57-45a1-9173-962ee330f78f', 'BLOCKED', false, 'Quality release: PV-2026-00011 (AWAITING_FINAL), PV-2026-00012 (AWAITING_FINAL), PV-2026-00013 (AWAITING_FINAL) not quality-released [owner: Quality]', NULL, 'Gati', NULL, '{"mtc": true, "export_docs": true, "packing_list": true}', NULL, NULL, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:28.868824+00', '2026-10-27 14:05:28.890217+00', 3),
	('075652c1-3e13-42cb-9cc8-ceecdf6b1dff', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SHP-2026-000008', 'd7896924-f01a-474e-afe1-ef33836afd2f', 'DRAFT', true, NULL, NULL, 'TCI Freight', NULL, '{"mtc": true, "export_docs": true, "packing_list": true}', NULL, NULL, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:28.901936+00', '2026-10-27 14:05:28.913787+00', 2);


--
-- Data for Name: shipment_lines; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.shipment_lines VALUES
	('582e02e5-925e-48b6-8463-4830aab635d5', '9daa4c8a-5c46-42d9-9043-fd3f27894ce6', '4ec63d7c-4c91-4963-834e-c9837b80f2d6'),
	('362599b1-c3d8-455f-91f2-65c411322976', '9daa4c8a-5c46-42d9-9043-fd3f27894ce6', '59f83746-e6fc-49f4-a77b-cb821493e11f'),
	('4864db9b-fe6d-4f15-baae-919ba8263fc0', '9daa4c8a-5c46-42d9-9043-fd3f27894ce6', '4cb646d1-3878-4424-b41c-fdcf1caceca0'),
	('7b822c0f-4631-42d4-a150-277b33c3151c', 'e69f1135-e2e7-4789-b7d8-0338d785cd5d', '400708e9-52e1-4214-b07c-c7837dbeeb2c'),
	('b001e61e-6e92-4e27-9d7d-ceb2a6f24ed7', 'e69f1135-e2e7-4789-b7d8-0338d785cd5d', 'f287ea25-7179-4e4d-a695-4bb1414938da'),
	('bd0b2f0e-ec73-49a1-a0ec-ad481779149c', '34487842-ee98-451e-b927-f22db4697158', 'c8b7b4fb-6148-494b-990d-b2b14b6350b3'),
	('079ec995-d1f7-40c6-9d29-8c425fa794cd', '34487842-ee98-451e-b927-f22db4697158', '451711cb-bdb5-46aa-a135-e7bb6ce9a477'),
	('6aebe04b-9cd2-45da-aa52-a38093c94624', 'd1930648-ceec-440d-becc-0dfe724e9b41', 'e612e4b3-497c-470c-8396-74a36728f675'),
	('3dc0e290-963c-4808-ba6a-aa1c6b255ed2', 'd1930648-ceec-440d-becc-0dfe724e9b41', '326a1502-8dcd-4de5-acf8-f5b56b4ec57c'),
	('ce447ef8-78df-4088-9882-bb436881dfe0', 'd1930648-ceec-440d-becc-0dfe724e9b41', '25dd99d8-20bf-48f8-bece-c7e4f0bf1514'),
	('91d24542-e63c-4c6e-acff-3fa6df9095a0', '771f7e34-04fa-493e-9e97-226ee5bf4110', '1f31d15f-0bf3-45b3-991b-db09ef7af236'),
	('4793f9f9-1707-4565-af5f-a6537d3424eb', '771f7e34-04fa-493e-9e97-226ee5bf4110', '92d9db2b-a78c-4256-bbf9-24dfafbec521'),
	('1cacf6d0-9863-498f-a466-e2f016914f57', '9c0b36db-59e8-4b76-b738-1b18d474c762', 'b23230f2-f025-43ed-82dc-75a1c78a3ea1'),
	('2e97e132-ef9e-4e54-aa12-ac7e6ad4e698', '9c0b36db-59e8-4b76-b738-1b18d474c762', '6140c882-132d-428a-9759-c01123be0297'),
	('9bf7401b-efb8-46fd-a333-15b672c7d21f', '728bbe23-7529-49c9-a6f7-aeba8655c86e', '889f17af-4522-46de-a212-c9fc160fe4c5'),
	('5c3d2578-54da-4ed8-b20d-a966b364c943', '728bbe23-7529-49c9-a6f7-aeba8655c86e', 'e7390bf4-8562-4115-ba09-42cec5480e45'),
	('8c7d96b3-8205-49cf-908e-476dc1e386b6', '728bbe23-7529-49c9-a6f7-aeba8655c86e', '38b43ff4-03c6-4021-a195-4b8973395fdc'),
	('560e700c-5778-4d08-b2f8-7c7276dadc32', '075652c1-3e13-42cb-9cc8-ceecdf6b1dff', 'afdd35b7-be62-4847-a82c-64b8ddf1b75f');


--
-- Data for Name: status_transitions; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.status_transitions VALUES
	(1, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', 'b0136396-fcf8-4945-8445-6dae8f2b11ef', 'DRAFT', 'REVIEW', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:23.649922+00'),
	(2, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', 'b0136396-fcf8-4945-8445-6dae8f2b11ef', 'REVIEW', 'INTERNAL_APPROVAL', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:23.663837+00'),
	(3, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', 'b0136396-fcf8-4945-8445-6dae8f2b11ef', 'INTERNAL_APPROVAL', 'RELEASED', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:23.673067+00'),
	(4, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', 'f63b6b4f-d129-4a20-a4b7-9b2f7c8e0dee', 'DRAFT', 'REVIEW', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:23.693551+00'),
	(5, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', 'f63b6b4f-d129-4a20-a4b7-9b2f7c8e0dee', 'REVIEW', 'INTERNAL_APPROVAL', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:23.70317+00'),
	(6, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', 'f63b6b4f-d129-4a20-a4b7-9b2f7c8e0dee', 'INTERNAL_APPROVAL', 'RELEASED', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:23.713698+00'),
	(7, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', '10a944da-25c6-44cd-91ef-d47c6b9e6864', 'DRAFT', 'REVIEW', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:23.732209+00'),
	(8, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', '10a944da-25c6-44cd-91ef-d47c6b9e6864', 'REVIEW', 'INTERNAL_APPROVAL', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:23.742366+00'),
	(9, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', '10a944da-25c6-44cd-91ef-d47c6b9e6864', 'INTERNAL_APPROVAL', 'RELEASED', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:23.751662+00'),
	(10, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', 'fec6b539-a669-4d0f-b164-b2ffdfd25166', 'DRAFT', 'REVIEW', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:23.770992+00'),
	(11, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', 'fec6b539-a669-4d0f-b164-b2ffdfd25166', 'REVIEW', 'INTERNAL_APPROVAL', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:23.781821+00'),
	(12, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', 'fec6b539-a669-4d0f-b164-b2ffdfd25166', 'INTERNAL_APPROVAL', 'RELEASED', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:23.791731+00'),
	(13, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', 'e6939dc8-15bb-4a22-a933-cd6405398fd2', 'DRAFT', 'REVIEW', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:23.810135+00'),
	(14, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', 'e6939dc8-15bb-4a22-a933-cd6405398fd2', 'REVIEW', 'INTERNAL_APPROVAL', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:23.819557+00'),
	(15, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', 'e6939dc8-15bb-4a22-a933-cd6405398fd2', 'INTERNAL_APPROVAL', 'RELEASED', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:23.830267+00'),
	(16, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', '060e77a1-8d88-4eef-a393-1de10264d450', 'DRAFT', 'REVIEW', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:23.84906+00'),
	(17, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', '060e77a1-8d88-4eef-a393-1de10264d450', 'REVIEW', 'INTERNAL_APPROVAL', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:23.859901+00'),
	(18, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', '060e77a1-8d88-4eef-a393-1de10264d450', 'INTERNAL_APPROVAL', 'RELEASED', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:23.870205+00'),
	(19, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', '639d20b4-bf47-4805-ad8e-96e6a90e1ccd', 'DRAFT', 'REVIEW', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:23.889022+00'),
	(20, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', '639d20b4-bf47-4805-ad8e-96e6a90e1ccd', 'REVIEW', 'INTERNAL_APPROVAL', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:23.900185+00'),
	(21, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', '639d20b4-bf47-4805-ad8e-96e6a90e1ccd', 'INTERNAL_APPROVAL', 'RELEASED', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:23.911936+00'),
	(22, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', '88e3f2dd-70ac-4ce7-829d-259afacab83f', 'DRAFT', 'REVIEW', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:23.931614+00'),
	(23, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', '88e3f2dd-70ac-4ce7-829d-259afacab83f', 'REVIEW', 'INTERNAL_APPROVAL', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:23.941493+00'),
	(24, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', '88e3f2dd-70ac-4ce7-829d-259afacab83f', 'INTERNAL_APPROVAL', 'RELEASED', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:23.951786+00'),
	(25, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'drawing', 'eb5b314f-9980-45ae-a923-da2778ed2170', 'DRAFT', 'REVIEW', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:23.970266+00'),
	(26, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '6b2a26bc-9e8b-420d-8c63-abc2f3f1a5a5', 'NEW', 'CONTACTED', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', NULL, '2026-10-27 14:05:24.377802+00'),
	(27, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '6b2a26bc-9e8b-420d-8c63-abc2f3f1a5a5', 'CONTACTED', 'QUALIFIED', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', NULL, '2026-10-27 14:05:24.387068+00'),
	(28, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '29cd3cd5-e05d-41cd-a90e-3d10db43f833', 'NEW', 'CONTACTED', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', NULL, '2026-10-27 14:05:24.4063+00'),
	(29, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '97220804-111c-432c-817f-6995ea0508ea', 'NEW', 'CONTACTED', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', NULL, '2026-10-27 14:05:24.431354+00'),
	(30, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '97220804-111c-432c-817f-6995ea0508ea', 'CONTACTED', 'QUALIFIED', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', NULL, '2026-10-27 14:05:24.441988+00'),
	(31, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '97220804-111c-432c-817f-6995ea0508ea', 'QUALIFIED', 'MEETING', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', NULL, '2026-10-27 14:05:24.452699+00'),
	(32, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '9c0b5d27-c5df-4eeb-b77b-816a5ba8c684', 'NEW', 'CONTACTED', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', NULL, '2026-10-27 14:05:24.478494+00'),
	(33, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '9c0b5d27-c5df-4eeb-b77b-816a5ba8c684', 'CONTACTED', 'QUALIFIED', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', NULL, '2026-10-27 14:05:24.494482+00'),
	(34, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '9c0b5d27-c5df-4eeb-b77b-816a5ba8c684', 'QUALIFIED', 'QUOTATION', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', NULL, '2026-10-27 14:05:24.507395+00'),
	(35, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '1d7082ad-817e-47d0-a6dd-f1fb0757c36d', 'NEW', 'LOST', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', NULL, '2026-10-27 14:05:24.539055+00'),
	(36, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', 'c5ce13c6-6264-4afa-b0de-ee49b5fb3e5f', 'NEW', 'CONTACTED', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', NULL, '2026-10-27 14:05:24.572152+00'),
	(37, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', 'c5ce13c6-6264-4afa-b0de-ee49b5fb3e5f', 'CONTACTED', 'QUALIFIED', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', NULL, '2026-10-27 14:05:24.58663+00'),
	(38, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', 'f4452124-f2ce-4ec5-9e66-148677a631a4', 'NEW', 'CONTACTED', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', NULL, '2026-10-27 14:05:24.613351+00'),
	(39, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', 'f4452124-f2ce-4ec5-9e66-148677a631a4', 'CONTACTED', 'QUALIFIED', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', NULL, '2026-10-27 14:05:24.623131+00'),
	(40, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', 'f4452124-f2ce-4ec5-9e66-148677a631a4', 'QUALIFIED', 'QUOTATION', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', NULL, '2026-10-27 14:05:24.63443+00'),
	(41, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '00ebac3b-8252-4275-b9a9-6f94e2184918', 'NEW', 'CONTACTED', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', NULL, '2026-10-27 14:05:24.654722+00'),
	(42, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '00ebac3b-8252-4275-b9a9-6f94e2184918', 'CONTACTED', 'QUALIFIED', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', NULL, '2026-10-27 14:05:24.667182+00'),
	(43, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '00ebac3b-8252-4275-b9a9-6f94e2184918', 'QUALIFIED', 'MEETING', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', NULL, '2026-10-27 14:05:24.679138+00'),
	(44, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '328cf045-2a7e-4a4b-9418-8758969e6a8f', 'NEW', 'CONTACTED', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', NULL, '2026-10-27 14:05:24.702283+00'),
	(45, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', 'd00adf8d-ad63-431b-a1a9-5a980ce375ce', 'NEW', 'CONTACTED', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', NULL, '2026-10-27 14:05:24.724232+00'),
	(46, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', 'd00adf8d-ad63-431b-a1a9-5a980ce375ce', 'CONTACTED', 'QUALIFIED', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', NULL, '2026-10-27 14:05:24.73342+00'),
	(47, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '8870458f-25e2-4ed3-bdef-99e2a1ae7f60', 'NEW', 'CONTACTED', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', NULL, '2026-10-27 14:05:24.769977+00'),
	(48, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '8870458f-25e2-4ed3-bdef-99e2a1ae7f60', 'CONTACTED', 'QUALIFIED', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', NULL, '2026-10-27 14:05:24.779106+00'),
	(49, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '8870458f-25e2-4ed3-bdef-99e2a1ae7f60', 'QUALIFIED', 'QUOTATION', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', NULL, '2026-10-27 14:05:24.78777+00'),
	(50, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '8870458f-25e2-4ed3-bdef-99e2a1ae7f60', 'QUOTATION', 'NEGOTIATION', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', NULL, '2026-10-27 14:05:24.79714+00');
INSERT INTO public.status_transitions VALUES
	(51, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '355e1dd8-e5da-4ce5-9109-36fa00b8aa92', 'NEW', 'LOST', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', NULL, '2026-10-27 14:05:24.815354+00'),
	(52, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'lead', '6399bb36-6142-456b-a179-6f02916d8dcf', 'NEW', 'CONTACTED', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', NULL, '2026-10-27 14:05:24.833105+00'),
	(53, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', 'acc2a4f1-4770-4991-917e-d6e9f93ccb93', 'DRAFT', 'SENT', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', NULL, '2026-10-27 14:05:24.856638+00'),
	(54, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', 'fc114276-1b5f-4018-9a2a-fd523fff4926', 'DRAFT', 'SENT', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', NULL, '2026-10-27 14:05:24.937436+00'),
	(55, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', '44dde98c-02b8-43f3-a22b-f6d914f1df1b', 'DRAFT', 'SENT', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', NULL, '2026-10-27 14:05:25.000286+00'),
	(56, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', '14ebed78-c91d-4508-9a0e-43af0dfad235', 'DRAFT', 'SENT', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', NULL, '2026-10-27 14:05:25.058961+00'),
	(57, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', 'd8d170b5-2ae9-4b08-9031-ed036c67fb26', 'DRAFT', 'SENT', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', NULL, '2026-10-27 14:05:25.111519+00'),
	(58, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', 'eabc6dfb-091b-4a26-8690-736a3a331a0f', 'DRAFT', 'SENT', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', NULL, '2026-10-27 14:05:25.163366+00'),
	(59, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', '023b8d39-f4e0-4672-9c1c-79b54478612e', 'DRAFT', 'SENT', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', NULL, '2026-10-27 14:05:25.218005+00'),
	(60, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', 'e63491b4-3f5a-4319-a98b-80b04378bc0f', 'DRAFT', 'SENT', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', NULL, '2026-10-27 14:05:25.270804+00'),
	(61, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', '7668d975-423a-4704-a27d-3fb0c3478491', 'DRAFT', 'SENT', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', NULL, '2026-10-27 14:05:25.325617+00'),
	(62, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', 'f983962b-2117-4356-b2f4-841a61b80e50', 'DRAFT', 'SENT', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', NULL, '2026-10-27 14:05:25.382619+00'),
	(63, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', '54b98a5d-b260-477a-9f41-9ac2378f3f54', 'DRAFT', 'SENT', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', NULL, '2026-10-27 14:05:25.434301+00'),
	(64, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', 'fc153539-b57b-41dd-a1ca-c3771f81640a', 'DRAFT', 'SENT', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', NULL, '2026-10-27 14:05:25.485315+00'),
	(65, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', 'cb8dc1b9-2f62-4e6c-8067-e22f2579145e', 'DRAFT', 'SENT', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', NULL, '2026-10-27 14:05:25.535353+00'),
	(66, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'quote', '2a5d0fe2-6b3a-4833-b653-5bb1a354d68d', 'DRAFT', 'SENT', '0258e002-4154-48b4-ad1d-2195882841be', 'Ravi Kumar (Sales)', NULL, '2026-10-27 14:05:25.560227+00'),
	(67, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'po', 'ce93a67c-9fed-4963-afb5-0ba101288930', 'DRAFT', 'SENT', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:25.676845+00'),
	(68, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'po', 'ce93a67c-9fed-4963-afb5-0ba101288930', 'SENT', 'CONFIRMED', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:25.687543+00'),
	(69, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'po', '71578b63-a1db-494a-adca-f340552bf4f9', 'DRAFT', 'SENT', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:25.781371+00'),
	(70, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'po', '71578b63-a1db-494a-adca-f340552bf4f9', 'SENT', 'CONFIRMED', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:25.793031+00'),
	(71, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'po', '4753aa94-8b49-4c00-903e-ac1ef9478495', 'DRAFT', 'SENT', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:25.87055+00'),
	(72, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'po', '4753aa94-8b49-4c00-903e-ac1ef9478495', 'SENT', 'CONFIRMED', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:25.882985+00'),
	(73, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'po', '9c2ea34b-bc2f-4e8c-a28a-29f19d040c87', 'DRAFT', 'SENT', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:25.966618+00'),
	(74, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'po', '9c2ea34b-bc2f-4e8c-a28a-29f19d040c87', 'SENT', 'CONFIRMED', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:25.978671+00'),
	(75, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'po', '4507d976-1c8e-445c-912f-afb72176e7f9', 'DRAFT', 'SENT', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:26.053261+00'),
	(76, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'po', '5b1af53a-3402-449f-ac83-b285bb733ab5', 'DRAFT', 'PENDING_APPROVAL', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:26.072984+00'),
	(77, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'order', '84f16360-acd8-4658-a08c-5095e56335a6', 'CONFIRMED', 'ENGINEERING', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:28.920514+00'),
	(78, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'order', '84f16360-acd8-4658-a08c-5095e56335a6', 'ENGINEERING', 'MATERIAL_CHECK', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:28.931983+00'),
	(79, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'order', '84f16360-acd8-4658-a08c-5095e56335a6', 'MATERIAL_CHECK', 'PROCUREMENT', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:28.94159+00'),
	(80, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'order', '84f16360-acd8-4658-a08c-5095e56335a6', 'PROCUREMENT', 'READY', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:28.952358+00'),
	(81, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'invoice', 'b5b3c1d7-f38b-4cf8-a6fa-83982def8785', 'DRAFT', 'ISSUED', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:28.997868+00'),
	(82, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'order', 'bc2c7461-b1cd-4c66-8996-611e28098035', 'CONFIRMED', 'ENGINEERING', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:29.036034+00'),
	(83, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'order', 'bc2c7461-b1cd-4c66-8996-611e28098035', 'ENGINEERING', 'MATERIAL_CHECK', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:29.048653+00'),
	(84, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'order', 'bc2c7461-b1cd-4c66-8996-611e28098035', 'MATERIAL_CHECK', 'PROCUREMENT', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:29.05917+00'),
	(85, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'invoice', 'af319e29-79f3-42e0-8a7b-0f905462b0f1', 'DRAFT', 'ISSUED', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:29.104438+00'),
	(86, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'invoice', 'a526920e-7321-4968-b2ca-ffa2b379e6d9', 'DRAFT', 'ISSUED', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:29.145986+00'),
	(87, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'invoice', 'a526920e-7321-4968-b2ca-ffa2b379e6d9', 'ISSUED', 'OVERDUE', 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'System Admin', NULL, '2026-10-27 14:05:29.161616+00');


--
-- Data for Name: stock_items; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.stock_items VALUES
	('4b4bec05-49ca-4d15-abd7-957a78fbabab', '4a0f88e6-467f-406c-a37b-fde4abff9898', '6e212887-960b-4eed-ade6-18715e05c5cb', 'e4804dc7-b2ff-4c92-9b17-767e229aec84', 13.000, 0.000, 0.000, 0.000, 0.000, '2026-10-27 14:05:21.445587+00', 1),
	('259b3c96-3c9a-4177-bcb7-cc3c8f649baf', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'd14a8056-467a-425a-a517-b0f08e05e8ec', 'e4804dc7-b2ff-4c92-9b17-767e229aec84', 100.000, 0.000, 0.000, 0.000, 0.000, '2026-10-27 14:05:25.687543+00', 1),
	('b8b1c9a1-7dc8-468d-a19d-e194827aa6ce', '4a0f88e6-467f-406c-a37b-fde4abff9898', '961b2013-58fb-45fb-8a7c-618c84887c18', 'e4804dc7-b2ff-4c92-9b17-767e229aec84', 125.000, 0.000, 0.000, 0.000, 0.000, '2026-10-27 14:05:21.445587+00', 1),
	('e0217b88-06c4-42e6-9f26-fcf358391c23', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'abe0ed52-e0fd-424a-b2d4-00c1c625767f', 'e4804dc7-b2ff-4c92-9b17-767e229aec84', 140.000, 0.000, 0.000, 0.000, 0.000, '2026-10-27 14:05:21.445587+00', 1),
	('261e03fd-82ae-43fd-aa4a-d38b8f96001a', '4a0f88e6-467f-406c-a37b-fde4abff9898', '2488bae2-79d6-4ce2-95c8-385344da703b', 'e4804dc7-b2ff-4c92-9b17-767e229aec84', 100.000, 0.000, 0.000, 0.000, 0.000, '2026-10-27 14:05:25.978671+00', 1);


--
-- Data for Name: stock_movements; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.stock_movements VALUES
	(1, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'abe0ed52-e0fd-424a-b2d4-00c1c625767f', 'e4804dc7-b2ff-4c92-9b17-767e229aec84', 'RECEIPT', 40.000, 40.000, NULL, NULL, 'Opening stock', NULL, '2026-10-27 14:05:21.445587+00'),
	(2, '4a0f88e6-467f-406c-a37b-fde4abff9898', '961b2013-58fb-45fb-8a7c-618c84887c18', 'e4804dc7-b2ff-4c92-9b17-767e229aec84', 'RECEIPT', 25.000, 25.000, NULL, NULL, 'Opening stock', NULL, '2026-10-27 14:05:21.445587+00'),
	(3, '4a0f88e6-467f-406c-a37b-fde4abff9898', '6e212887-960b-4eed-ade6-18715e05c5cb', 'e4804dc7-b2ff-4c92-9b17-767e229aec84', 'RECEIPT', 13.000, 13.000, NULL, NULL, 'Opening stock', NULL, '2026-10-27 14:05:21.445587+00'),
	(4, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'd14a8056-467a-425a-a517-b0f08e05e8ec', 'e4804dc7-b2ff-4c92-9b17-767e229aec84', 'RECEIPT', 20.000, 20.000, 'grn', 'e1d2578b-4bf7-4a4c-8fab-6e13f71549eb', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.705063+00'),
	(5, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'd14a8056-467a-425a-a517-b0f08e05e8ec', 'e4804dc7-b2ff-4c92-9b17-767e229aec84', 'RECEIPT', 20.000, 40.000, 'grn', 'e1d2578b-4bf7-4a4c-8fab-6e13f71549eb', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.705063+00'),
	(6, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'd14a8056-467a-425a-a517-b0f08e05e8ec', 'e4804dc7-b2ff-4c92-9b17-767e229aec84', 'RECEIPT', 20.000, 60.000, 'grn', 'e1d2578b-4bf7-4a4c-8fab-6e13f71549eb', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.705063+00'),
	(7, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'd14a8056-467a-425a-a517-b0f08e05e8ec', 'e4804dc7-b2ff-4c92-9b17-767e229aec84', 'RECEIPT', 20.000, 80.000, 'grn', 'e1d2578b-4bf7-4a4c-8fab-6e13f71549eb', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.705063+00'),
	(8, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'd14a8056-467a-425a-a517-b0f08e05e8ec', 'e4804dc7-b2ff-4c92-9b17-767e229aec84', 'RECEIPT', 20.000, 100.000, 'grn', 'e1d2578b-4bf7-4a4c-8fab-6e13f71549eb', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.705063+00'),
	(9, '4a0f88e6-467f-406c-a37b-fde4abff9898', '961b2013-58fb-45fb-8a7c-618c84887c18', 'e4804dc7-b2ff-4c92-9b17-767e229aec84', 'RECEIPT', 20.000, 45.000, 'grn', '39849164-7e5a-4cf4-a7c0-51985752ccf4', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.807881+00'),
	(10, '4a0f88e6-467f-406c-a37b-fde4abff9898', '961b2013-58fb-45fb-8a7c-618c84887c18', 'e4804dc7-b2ff-4c92-9b17-767e229aec84', 'RECEIPT', 20.000, 65.000, 'grn', '39849164-7e5a-4cf4-a7c0-51985752ccf4', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.807881+00'),
	(11, '4a0f88e6-467f-406c-a37b-fde4abff9898', '961b2013-58fb-45fb-8a7c-618c84887c18', 'e4804dc7-b2ff-4c92-9b17-767e229aec84', 'RECEIPT', 20.000, 85.000, 'grn', '39849164-7e5a-4cf4-a7c0-51985752ccf4', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.807881+00'),
	(12, '4a0f88e6-467f-406c-a37b-fde4abff9898', '961b2013-58fb-45fb-8a7c-618c84887c18', 'e4804dc7-b2ff-4c92-9b17-767e229aec84', 'RECEIPT', 20.000, 105.000, 'grn', '39849164-7e5a-4cf4-a7c0-51985752ccf4', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.807881+00'),
	(13, '4a0f88e6-467f-406c-a37b-fde4abff9898', '961b2013-58fb-45fb-8a7c-618c84887c18', 'e4804dc7-b2ff-4c92-9b17-767e229aec84', 'RECEIPT', 20.000, 125.000, 'grn', '39849164-7e5a-4cf4-a7c0-51985752ccf4', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.807881+00'),
	(14, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'abe0ed52-e0fd-424a-b2d4-00c1c625767f', 'e4804dc7-b2ff-4c92-9b17-767e229aec84', 'RECEIPT', 20.000, 60.000, 'grn', '2d427e21-6868-4293-848c-907d2ecb3544', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.900835+00'),
	(15, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'abe0ed52-e0fd-424a-b2d4-00c1c625767f', 'e4804dc7-b2ff-4c92-9b17-767e229aec84', 'RECEIPT', 20.000, 80.000, 'grn', '2d427e21-6868-4293-848c-907d2ecb3544', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.900835+00'),
	(16, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'abe0ed52-e0fd-424a-b2d4-00c1c625767f', 'e4804dc7-b2ff-4c92-9b17-767e229aec84', 'RECEIPT', 20.000, 100.000, 'grn', '2d427e21-6868-4293-848c-907d2ecb3544', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.900835+00'),
	(17, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'abe0ed52-e0fd-424a-b2d4-00c1c625767f', 'e4804dc7-b2ff-4c92-9b17-767e229aec84', 'RECEIPT', 20.000, 120.000, 'grn', '2d427e21-6868-4293-848c-907d2ecb3544', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.900835+00'),
	(18, '4a0f88e6-467f-406c-a37b-fde4abff9898', 'abe0ed52-e0fd-424a-b2d4-00c1c625767f', 'e4804dc7-b2ff-4c92-9b17-767e229aec84', 'RECEIPT', 20.000, 140.000, 'grn', '2d427e21-6868-4293-848c-907d2ecb3544', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.900835+00'),
	(19, '4a0f88e6-467f-406c-a37b-fde4abff9898', '2488bae2-79d6-4ce2-95c8-385344da703b', 'e4804dc7-b2ff-4c92-9b17-767e229aec84', 'RECEIPT', 20.000, 20.000, 'grn', '25c5720f-01ba-401d-be7c-1cd37e709753', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.994935+00'),
	(20, '4a0f88e6-467f-406c-a37b-fde4abff9898', '2488bae2-79d6-4ce2-95c8-385344da703b', 'e4804dc7-b2ff-4c92-9b17-767e229aec84', 'RECEIPT', 20.000, 40.000, 'grn', '25c5720f-01ba-401d-be7c-1cd37e709753', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.994935+00'),
	(21, '4a0f88e6-467f-406c-a37b-fde4abff9898', '2488bae2-79d6-4ce2-95c8-385344da703b', 'e4804dc7-b2ff-4c92-9b17-767e229aec84', 'RECEIPT', 20.000, 60.000, 'grn', '25c5720f-01ba-401d-be7c-1cd37e709753', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.994935+00'),
	(22, '4a0f88e6-467f-406c-a37b-fde4abff9898', '2488bae2-79d6-4ce2-95c8-385344da703b', 'e4804dc7-b2ff-4c92-9b17-767e229aec84', 'RECEIPT', 20.000, 80.000, 'grn', '25c5720f-01ba-401d-be7c-1cd37e709753', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.994935+00'),
	(23, '4a0f88e6-467f-406c-a37b-fde4abff9898', '2488bae2-79d6-4ce2-95c8-385344da703b', 'e4804dc7-b2ff-4c92-9b17-767e229aec84', 'RECEIPT', 20.000, 100.000, 'grn', '25c5720f-01ba-401d-be7c-1cd37e709753', NULL, 'cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '2026-10-27 14:05:25.994935+00');


--
-- Data for Name: stock_reservations; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: subcontract_orders; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.subcontract_orders VALUES
	('67fe8e31-5628-4f20-a0fc-b1885b2434a1', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SC-2026-000001', '71cb5f2d-7cf9-4623-a70b-7baeb9c1b66c', '15390c7c-a37d-4ee6-ae7d-8ab0c9d23fa9', '6e212887-960b-4eed-ade6-18715e05c5cb', 'Heat treatment', 3.000, 3.000, 3.000, 0.000, 4500.00, 'RECONCILED', '2026-10-27', '2026-10-25', NULL, '1b0292cb-4999-40df-893a-e2e9c3dc6101'),
	('928bcc07-9351-4024-8527-17b852b05b83', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SC-2026-000002', '6f1dd7e0-32bb-4c8a-a0d9-25e051a1a9b1', '15390c7c-a37d-4ee6-ae7d-8ab0c9d23fa9', 'eb07eab2-eba7-4b97-88f8-9066662e9a5e', 'Heat treatment', 4.000, 4.000, 4.000, 0.000, 6000.00, 'RECONCILED', '2026-10-27', '2026-10-25', NULL, '1b0292cb-4999-40df-893a-e2e9c3dc6101'),
	('5c8276ce-93e7-4872-a094-e1d04a02dc09', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SC-2026-000003', 'a96efb75-c93f-4af2-b48a-4962753900cd', '362c5ed7-df92-47df-bc90-a7ed326e1ac2', '82048a24-aa7e-422f-bee0-1642d75bd996', 'Stellite hard-facing', 3.000, 2.000, 2.000, 1.000, 7800.00, 'RECONCILED', '2026-10-27', '2026-10-25', 'One piece rejected at supplier — cracking after quench', '1b0292cb-4999-40df-893a-e2e9c3dc6101'),
	('afb1546c-d580-4537-b6d5-eda3606f40e1', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SC-2026-000004', 'd996f72b-9fab-4c89-878a-34c63fe6f3ea', '15390c7c-a37d-4ee6-ae7d-8ab0c9d23fa9', '77a428fe-4dd9-4a6e-8138-36a5f4efc6b2', 'Heat treatment', 3.000, 3.000, 3.000, 0.000, 4500.00, 'RECONCILED', '2026-10-27', '2026-10-25', NULL, '1b0292cb-4999-40df-893a-e2e9c3dc6101'),
	('473a7904-d69f-4a5f-8567-35026e1621cd', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SC-2026-000005', 'aed5986d-07e3-4fc5-9aae-74d6c3de22ff', '362c5ed7-df92-47df-bc90-a7ed326e1ac2', '92a93794-1287-4b7d-8868-7b9b81b87cb2', 'Plating', 2.000, 2.000, 2.000, 0.000, 3200.00, 'RECONCILED', '2026-10-27', '2026-10-25', NULL, '1b0292cb-4999-40df-893a-e2e9c3dc6101'),
	('bd842578-e6d3-42f0-8827-bba74d1a62c2', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SC-2026-000006', '56925ee4-f597-4196-b51e-59ca9740cc60', '15390c7c-a37d-4ee6-ae7d-8ab0c9d23fa9', '6f56aa1e-de31-44a5-b842-756c12aa7646', 'Heat treatment', 2.000, 2.000, 2.000, 0.000, 3000.00, 'RECONCILED', '2026-10-27', '2026-10-25', NULL, '1b0292cb-4999-40df-893a-e2e9c3dc6101'),
	('23df83cd-8aa9-413e-9976-f733c6c5ff31', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SC-2026-000007', '8ebcb809-6629-4f68-add0-926ef84e4337', '362c5ed7-df92-47df-bc90-a7ed326e1ac2', 'd61fe768-7f6e-4d65-b1f1-6f5621e2008b', 'Hard-facing', 2.000, 2.000, 2.000, 0.000, 3900.00, 'RECONCILED', '2026-10-27', '2026-10-25', NULL, '1b0292cb-4999-40df-893a-e2e9c3dc6101'),
	('0b892b0e-aea9-4c02-8197-4e4f9132c365', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SC-2026-000008', 'b4d2e412-f532-4bd4-8101-e08fd008857d', '15390c7c-a37d-4ee6-ae7d-8ab0c9d23fa9', '65e1cab5-04f9-4e45-9081-e07e65803ba9', 'Heat treatment', 2.000, 2.000, 2.000, 0.000, 3000.00, 'RECONCILED', '2026-10-27', '2026-10-25', NULL, '1b0292cb-4999-40df-893a-e2e9c3dc6101'),
	('fa6f8c53-b906-4212-82d8-6b007c924da7', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SC-2026-000009', '076f8a96-8f7a-4b69-a2db-b257e115f802', '15390c7c-a37d-4ee6-ae7d-8ab0c9d23fa9', '9152c8e7-6ed4-495d-a58c-ee509367659f', 'Heat treatment', 4.000, 0.000, 0.000, 0.000, 6400.00, 'SENT', '2026-10-27', '2026-11-01', NULL, '1b0292cb-4999-40df-893a-e2e9c3dc6101'),
	('8ae950a0-81b7-400a-adba-50cb2039bb66', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'SC-2026-000010', '17d9f431-383d-4e86-9ba9-5c2e555fd89e', '362c5ed7-df92-47df-bc90-a7ed326e1ac2', '6f56aa1e-de31-44a5-b842-756c12aa7646', 'Hard-facing', 6.000, 4.000, 5.000, 0.000, 9600.00, 'MISMATCH', '2026-10-27', '2026-11-03', 'Supplier DC shows 5 processed but only 4 received — raised with supplier', '1b0292cb-4999-40df-893a-e2e9c3dc6101');


--
-- Data for Name: tasks; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.tasks VALUES
	('29ea8304-52ec-4fd2-8d38-88f6d948cc24', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TASK-2026-000001', 'Contact lead LEAD-2026-000001 — Deccan Petrochem Ltd', NULL, 'lead', '6b2a26bc-9e8b-420d-8c63-abc2f3f1a5a5', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 19:05:24.361718+00', 'OPEN', 'NORMAL', 'lead-followup-6b2a26bc-9e8b-420d-8c63-abc2f3f1a5a5', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.361718+00', '2026-10-27 14:05:24.361718+00', 1),
	('8ff8b707-9a2e-4b56-8287-98179a20ec01', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TASK-2026-000002', 'Contact lead LEAD-2026-000002 — Coastal Power Ltd', NULL, 'lead', '29cd3cd5-e05d-41cd-a90e-3d10db43f833', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 19:05:24.395242+00', 'OPEN', 'NORMAL', 'lead-followup-29cd3cd5-e05d-41cd-a90e-3d10db43f833', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.395242+00', '2026-10-27 14:05:24.395242+00', 1),
	('c62beeaf-835b-47e7-9c48-b888231d3615', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TASK-2026-000003', 'Contact lead LEAD-2026-000003 — Nagpur Steel Works', NULL, 'lead', '97220804-111c-432c-817f-6995ea0508ea', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 19:05:24.417416+00', 'OPEN', 'NORMAL', 'lead-followup-97220804-111c-432c-817f-6995ea0508ea', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.417416+00', '2026-10-27 14:05:24.417416+00', 1),
	('f86d81a5-da3a-401f-875e-685e85116e33', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TASK-2026-000004', 'Contact lead LEAD-2026-000004 — Iberia Water S.L.', NULL, 'lead', '9c0b5d27-c5df-4eeb-b77b-816a5ba8c684', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 19:05:24.46274+00', 'OPEN', 'NORMAL', 'lead-followup-9c0b5d27-c5df-4eeb-b77b-816a5ba8c684', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.46274+00', '2026-10-27 14:05:24.46274+00', 1),
	('a366d9db-f658-40ac-990c-3e96bfba0665', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TASK-2026-000005', 'Contact lead LEAD-2026-000005 — Metro Utilities', NULL, 'lead', '1d7082ad-817e-47d0-a6dd-f1fb0757c36d', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 19:05:24.519991+00', 'OPEN', 'NORMAL', 'lead-followup-1d7082ad-817e-47d0-a6dd-f1fb0757c36d', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.519991+00', '2026-10-27 14:05:24.519991+00', 1),
	('239ba34f-0cff-4d5c-8ffc-e8ea74c25443', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TASK-2026-000006', 'Contact lead LEAD-2026-000006 — Kaveri Water Board', NULL, 'lead', 'c5ce13c6-6264-4afa-b0de-ee49b5fb3e5f', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 19:05:24.55127+00', 'OPEN', 'NORMAL', 'lead-followup-c5ce13c6-6264-4afa-b0de-ee49b5fb3e5f', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.55127+00', '2026-10-27 14:05:24.55127+00', 1),
	('a88af2d4-307b-4b63-9f21-2c50dde2836e', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TASK-2026-000007', 'Contact lead LEAD-2026-000007 — Hamburg Process GmbH', NULL, 'lead', 'f4452124-f2ce-4ec5-9e66-148677a631a4', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 19:05:24.599408+00', 'OPEN', 'NORMAL', 'lead-followup-f4452124-f2ce-4ec5-9e66-148677a631a4', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.599408+00', '2026-10-27 14:05:24.599408+00', 1),
	('e62935d8-6ea6-4b8e-9336-3c4121efa2b3', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TASK-2026-000008', 'Contact lead LEAD-2026-000008 — Tata Process Systems', NULL, 'lead', '00ebac3b-8252-4275-b9a9-6f94e2184918', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 19:05:24.643095+00', 'OPEN', 'NORMAL', 'lead-followup-00ebac3b-8252-4275-b9a9-6f94e2184918', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.643095+00', '2026-10-27 14:05:24.643095+00', 1),
	('63104976-a65c-4ff4-aec6-4f6525568950', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TASK-2026-000009', 'Contact lead LEAD-2026-000009 — Reliance Marine Services', NULL, 'lead', '328cf045-2a7e-4a4b-9418-8758969e6a8f', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 19:05:24.688476+00', 'OPEN', 'NORMAL', 'lead-followup-328cf045-2a7e-4a4b-9418-8758969e6a8f', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.688476+00', '2026-10-27 14:05:24.688476+00', 1),
	('621e97ef-84ea-4887-9fa1-9cfad83f5acd', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TASK-2026-000010', 'Contact lead LEAD-2026-000010 — Bharat Oilfield Services', NULL, 'lead', 'd00adf8d-ad63-431b-a1a9-5a980ce375ce', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 19:05:24.712965+00', 'OPEN', 'NORMAL', 'lead-followup-d00adf8d-ad63-431b-a1a9-5a980ce375ce', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.712965+00', '2026-10-27 14:05:24.712965+00', 1),
	('389484ac-ad9f-422f-ab69-594718add9a7', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TASK-2026-000011', 'Contact lead LEAD-2026-000011 — Sunrise Pharma', NULL, 'lead', 'bce778f5-fe67-4d47-8c15-a616dfb4060f', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 19:05:24.741915+00', 'OPEN', 'NORMAL', 'lead-followup-bce778f5-fe67-4d47-8c15-a616dfb4060f', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.741915+00', '2026-10-27 14:05:24.741915+00', 1),
	('27668f89-8c67-43ae-a9cd-9cbb45eaf8fc', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TASK-2026-000012', 'Contact lead LEAD-2026-000012 — Eastern Fertilizers', NULL, 'lead', '6441fbd3-7866-425b-b69c-9340501592e1', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 19:05:24.750787+00', 'OPEN', 'NORMAL', 'lead-followup-6441fbd3-7866-425b-b69c-9340501592e1', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.750787+00', '2026-10-27 14:05:24.750787+00', 1),
	('42bff976-6c35-41fe-ab94-7abf4e90e826', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TASK-2026-000013', 'Contact lead LEAD-2026-000013 — Gulf Refining Co.', NULL, 'lead', '8870458f-25e2-4ed3-bdef-99e2a1ae7f60', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 19:05:24.760062+00', 'OPEN', 'NORMAL', 'lead-followup-8870458f-25e2-4ed3-bdef-99e2a1ae7f60', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.760062+00', '2026-10-27 14:05:24.760062+00', 1),
	('4abe8bb0-81dc-4713-a028-4ba947bfa608', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TASK-2026-000014', 'Contact lead LEAD-2026-000014 — Pune Auto Components', NULL, 'lead', '355e1dd8-e5da-4ce5-9109-36fa00b8aa92', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 19:05:24.804949+00', 'OPEN', 'NORMAL', 'lead-followup-355e1dd8-e5da-4ce5-9109-36fa00b8aa92', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.804949+00', '2026-10-27 14:05:24.804949+00', 1),
	('e35261ae-0775-4b3f-a3db-880917e19457', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TASK-2026-000015', 'Contact lead LEAD-2026-000015 — Hindustan Chemicals', NULL, 'lead', '6399bb36-6142-456b-a179-6f02916d8dcf', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 19:05:24.822573+00', 'OPEN', 'NORMAL', 'lead-followup-6399bb36-6142-456b-a179-6f02916d8dcf', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.822573+00', '2026-10-27 14:05:24.822573+00', 1),
	('9d11b9ef-95c3-409b-a6f5-e77b5a76697e', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TASK-2026-000016', 'Follow up on quotation', NULL, 'quote', 'acc2a4f1-4770-4991-917e-d6e9f93ccb93', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-30 14:05:24.856638+00', 'OPEN', 'NORMAL', 'quote-followup-acc2a4f1-4770-4991-917e-d6e9f93ccb93', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.856638+00', '2026-10-27 14:05:24.856638+00', 1),
	('6c8fa29f-9ac9-4ff7-9e55-165b6d82f9c7', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TASK-2026-000017', 'Follow up on quotation', NULL, 'quote', 'fc114276-1b5f-4018-9a2a-fd523fff4926', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-30 14:05:24.937436+00', 'OPEN', 'NORMAL', 'quote-followup-fc114276-1b5f-4018-9a2a-fd523fff4926', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:24.937436+00', '2026-10-27 14:05:24.937436+00', 1),
	('efd49bf1-c65f-4833-b474-a8d428e258b9', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TASK-2026-000018', 'Follow up on quotation', NULL, 'quote', '44dde98c-02b8-43f3-a22b-f6d914f1df1b', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-30 14:05:25.000286+00', 'OPEN', 'NORMAL', 'quote-followup-44dde98c-02b8-43f3-a22b-f6d914f1df1b', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:25.000286+00', '2026-10-27 14:05:25.000286+00', 1),
	('8797f0b5-3744-4970-b544-d39c368cc67b', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TASK-2026-000019', 'Follow up on quotation', NULL, 'quote', '14ebed78-c91d-4508-9a0e-43af0dfad235', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-30 14:05:25.058961+00', 'OPEN', 'NORMAL', 'quote-followup-14ebed78-c91d-4508-9a0e-43af0dfad235', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:25.058961+00', '2026-10-27 14:05:25.058961+00', 1),
	('446b27aa-bb7e-4cc2-92d6-d8bf7c11f409', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TASK-2026-000020', 'Follow up on quotation', NULL, 'quote', 'd8d170b5-2ae9-4b08-9031-ed036c67fb26', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-30 14:05:25.111519+00', 'OPEN', 'NORMAL', 'quote-followup-d8d170b5-2ae9-4b08-9031-ed036c67fb26', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:25.111519+00', '2026-10-27 14:05:25.111519+00', 1),
	('84984ead-1428-4eba-9dd0-2df3fc22b05c', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TASK-2026-000021', 'Follow up on quotation', NULL, 'quote', 'eabc6dfb-091b-4a26-8690-736a3a331a0f', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-30 14:05:25.163366+00', 'OPEN', 'NORMAL', 'quote-followup-eabc6dfb-091b-4a26-8690-736a3a331a0f', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:25.163366+00', '2026-10-27 14:05:25.163366+00', 1),
	('890be4bc-000f-4ff4-8090-6289871a93ac', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TASK-2026-000022', 'Follow up on quotation', NULL, 'quote', '023b8d39-f4e0-4672-9c1c-79b54478612e', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-30 14:05:25.218005+00', 'OPEN', 'NORMAL', 'quote-followup-023b8d39-f4e0-4672-9c1c-79b54478612e', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:25.218005+00', '2026-10-27 14:05:25.218005+00', 1),
	('cb8e492f-f17a-4711-98ce-c6cd0fd89a5b', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TASK-2026-000023', 'Follow up on quotation', NULL, 'quote', 'e63491b4-3f5a-4319-a98b-80b04378bc0f', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-30 14:05:25.270804+00', 'OPEN', 'NORMAL', 'quote-followup-e63491b4-3f5a-4319-a98b-80b04378bc0f', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:25.270804+00', '2026-10-27 14:05:25.270804+00', 1),
	('50b3ac35-f729-4ed5-9021-b355b8dfacad', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TASK-2026-000024', 'Follow up on quotation', NULL, 'quote', '7668d975-423a-4704-a27d-3fb0c3478491', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-30 14:05:25.325617+00', 'OPEN', 'NORMAL', 'quote-followup-7668d975-423a-4704-a27d-3fb0c3478491', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:25.325617+00', '2026-10-27 14:05:25.325617+00', 1),
	('6cf05252-30e6-4db7-931b-c9d0a626554a', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TASK-2026-000025', 'Follow up on quotation', NULL, 'quote', 'f983962b-2117-4356-b2f4-841a61b80e50', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-30 14:05:25.382619+00', 'OPEN', 'NORMAL', 'quote-followup-f983962b-2117-4356-b2f4-841a61b80e50', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:25.382619+00', '2026-10-27 14:05:25.382619+00', 1),
	('8c8c6be0-044d-470d-8efb-fa843f5c2f2d', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TASK-2026-000026', 'Follow up on quotation', NULL, 'quote', '54b98a5d-b260-477a-9f41-9ac2378f3f54', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-30 14:05:25.434301+00', 'OPEN', 'NORMAL', 'quote-followup-54b98a5d-b260-477a-9f41-9ac2378f3f54', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:25.434301+00', '2026-10-27 14:05:25.434301+00', 1),
	('86d01af7-91fd-4a46-bc88-25ba647c493d', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TASK-2026-000027', 'Follow up on quotation', NULL, 'quote', 'fc153539-b57b-41dd-a1ca-c3771f81640a', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-30 14:05:25.485315+00', 'OPEN', 'NORMAL', 'quote-followup-fc153539-b57b-41dd-a1ca-c3771f81640a', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:25.485315+00', '2026-10-27 14:05:25.485315+00', 1),
	('c8e1f157-e013-4f01-92c1-a4caabf81886', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TASK-2026-000028', 'Follow up on quotation', NULL, 'quote', 'cb8dc1b9-2f62-4e6c-8067-e22f2579145e', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-30 14:05:25.535353+00', 'OPEN', 'NORMAL', 'quote-followup-cb8dc1b9-2f62-4e6c-8067-e22f2579145e', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:25.535353+00', '2026-10-27 14:05:25.535353+00', 1),
	('71ba45e9-5190-488d-a73c-d33a6f7a0ab9', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TASK-2026-000029', 'Follow up on quotation', NULL, 'quote', '2a5d0fe2-6b3a-4833-b653-5bb1a354d68d', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-30 14:05:25.560227+00', 'OPEN', 'NORMAL', 'quote-followup-2a5d0fe2-6b3a-4833-b653-5bb1a354d68d', '0258e002-4154-48b4-ad1d-2195882841be', '2026-10-27 14:05:25.560227+00', '2026-10-27 14:05:25.560227+00', 1);


--
-- Data for Name: tax_rates; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: test_records; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.test_records VALUES
	('653233f8-cb9e-4e75-8062-ecf672dc3b8e', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000001', '4ec63d7c-4c91-4963-834e-c9837b80f2d6', 'SHELL_PRESSURE', 150.00, 15, 'No visible leakage', 'No leakage', 'PASS', '39ed37f2-99b8-4f7b-b5ab-a93be10edabb', 'CERT-SHE-7105', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:27.802951+00'),
	('e6ccb44b-bcab-4199-bb44-392f23b16f39', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000002', '4ec63d7c-4c91-4963-834e-c9837b80f2d6', 'SEAT_LEAK', 110.00, 5, 'Max 0 bubbles/min (ISO 5208 Rate A)', '0 bubbles/min', 'PASS', 'cc9a4be8-38c2-4db9-bfed-ec7800379a51', 'CERT-SEA-2173', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:27.813308+00'),
	('27ffdfd4-919a-4c49-aadf-da7211ba1413', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000003', '4ec63d7c-4c91-4963-834e-c9837b80f2d6', 'FUNCTIONAL', NULL, NULL, 'Smooth operation, torque ≤ 85 Nm', '62 Nm', 'PASS', 'a2a098da-54a8-4ef7-b096-25c580473149', 'CERT-FUN-1484', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:27.820407+00'),
	('74a764f7-676a-4ad8-b923-e754c94ec26b', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000004', '59f83746-e6fc-49f4-a77b-cb821493e11f', 'SHELL_PRESSURE', 150.00, 15, 'No visible leakage', 'No leakage', 'PASS', '39ed37f2-99b8-4f7b-b5ab-a93be10edabb', 'CERT-SHE-6299', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:27.855337+00'),
	('5dea3393-4643-4f1c-a6d0-757f4b2c2b7b', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000005', '59f83746-e6fc-49f4-a77b-cb821493e11f', 'SEAT_LEAK', 110.00, 5, 'Max 0 bubbles/min (ISO 5208 Rate A)', '0 bubbles/min', 'PASS', 'cc9a4be8-38c2-4db9-bfed-ec7800379a51', 'CERT-SEA-7471', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:27.866497+00'),
	('c0a7adf8-4930-4a27-84c2-1218d899279d', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000006', '59f83746-e6fc-49f4-a77b-cb821493e11f', 'FUNCTIONAL', NULL, NULL, 'Smooth operation, torque ≤ 85 Nm', '62 Nm', 'PASS', 'a2a098da-54a8-4ef7-b096-25c580473149', 'CERT-FUN-2754', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:27.874693+00'),
	('8ae22a03-32b1-4748-8bf1-d87d65e87239', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000007', '4cb646d1-3878-4424-b41c-fdcf1caceca0', 'SHELL_PRESSURE', 150.00, 15, 'No visible leakage', 'No leakage', 'PASS', '39ed37f2-99b8-4f7b-b5ab-a93be10edabb', 'CERT-SHE-3997', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:27.908265+00'),
	('99ce4b0e-6f9a-4800-afa2-988dfad83639', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000008', '4cb646d1-3878-4424-b41c-fdcf1caceca0', 'SEAT_LEAK', 110.00, 5, 'Max 0 bubbles/min (ISO 5208 Rate A)', '0 bubbles/min', 'PASS', 'cc9a4be8-38c2-4db9-bfed-ec7800379a51', 'CERT-SEA-6306', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:27.916456+00'),
	('77ceca33-0e5d-4e2a-9009-a34519185643', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000009', '4cb646d1-3878-4424-b41c-fdcf1caceca0', 'FUNCTIONAL', NULL, NULL, 'Smooth operation, torque ≤ 85 Nm', '62 Nm', 'PASS', 'a2a098da-54a8-4ef7-b096-25c580473149', 'CERT-FUN-1484', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:27.926332+00'),
	('f2fbeead-8578-4167-a51a-5d910769b3fc', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000010', '400708e9-52e1-4214-b07c-c7837dbeeb2c', 'SHELL_PRESSURE', 150.00, 15, 'No visible leakage', 'No leakage', 'PASS', '39ed37f2-99b8-4f7b-b5ab-a93be10edabb', 'CERT-SHE-5926', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:27.966175+00'),
	('155233ac-87b5-4dce-ad5a-c8e42fce1c1f', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000011', '400708e9-52e1-4214-b07c-c7837dbeeb2c', 'SEAT_LEAK', 110.00, 5, 'Max 0 bubbles/min (ISO 5208 Rate A)', '0 bubbles/min', 'PASS', 'cc9a4be8-38c2-4db9-bfed-ec7800379a51', 'CERT-SEA-2581', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:27.975098+00'),
	('cc6ddc70-2b29-4dff-b81f-bca9a8fe0686', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000012', '400708e9-52e1-4214-b07c-c7837dbeeb2c', 'FUNCTIONAL', NULL, NULL, 'Smooth operation, torque ≤ 85 Nm', '62 Nm', 'PASS', 'a2a098da-54a8-4ef7-b096-25c580473149', 'CERT-FUN-1270', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:27.983029+00'),
	('c0f5d4be-7476-4da7-a6eb-04ca82805220', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000013', 'f287ea25-7179-4e4d-a695-4bb1414938da', 'SHELL_PRESSURE', 150.00, 15, 'No visible leakage', 'No leakage', 'PASS', '39ed37f2-99b8-4f7b-b5ab-a93be10edabb', 'CERT-SHE-8596', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.01589+00'),
	('d8336e36-1ee0-4010-8f65-6a1c04ac94ab', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000014', 'f287ea25-7179-4e4d-a695-4bb1414938da', 'SEAT_LEAK', 110.00, 5, 'Max 0 bubbles/min (ISO 5208 Rate A)', '0 bubbles/min', 'PASS', 'cc9a4be8-38c2-4db9-bfed-ec7800379a51', 'CERT-SEA-3930', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.023793+00'),
	('45c74bd0-0ff9-426b-a1ec-5e19a05910f0', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000015', 'f287ea25-7179-4e4d-a695-4bb1414938da', 'FUNCTIONAL', NULL, NULL, 'Smooth operation, torque ≤ 85 Nm', '62 Nm', 'PASS', 'a2a098da-54a8-4ef7-b096-25c580473149', 'CERT-FUN-4651', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.032303+00'),
	('e432544b-f273-406b-aa9a-b1315a46ba35', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000016', 'e612e4b3-497c-470c-8396-74a36728f675', 'SHELL_PRESSURE', 150.00, 15, 'No visible leakage', 'No leakage', 'PASS', '39ed37f2-99b8-4f7b-b5ab-a93be10edabb', 'CERT-SHE-1228', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.065337+00'),
	('fad75148-c6a7-4a9d-bbe8-b3438b8ffd0d', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000017', 'e612e4b3-497c-470c-8396-74a36728f675', 'SEAT_LEAK', 110.00, 5, 'Max 0 bubbles/min (ISO 5208 Rate A)', '0 bubbles/min', 'PASS', 'cc9a4be8-38c2-4db9-bfed-ec7800379a51', 'CERT-SEA-2770', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.073399+00'),
	('591bd3fd-42ff-4f5a-9f9a-3a7db4e77474', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000018', 'e612e4b3-497c-470c-8396-74a36728f675', 'FUNCTIONAL', NULL, NULL, 'Smooth operation, torque ≤ 85 Nm', '62 Nm', 'PASS', 'a2a098da-54a8-4ef7-b096-25c580473149', 'CERT-FUN-9788', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.081155+00'),
	('2d75ff47-b033-44a2-95aa-a7dc352e0251', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000019', '326a1502-8dcd-4de5-acf8-f5b56b4ec57c', 'SHELL_PRESSURE', 150.00, 15, 'No visible leakage', 'No leakage', 'PASS', '39ed37f2-99b8-4f7b-b5ab-a93be10edabb', 'CERT-SHE-1602', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.114004+00'),
	('0d744884-012b-476f-a58a-b3e9829b295e', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000020', '326a1502-8dcd-4de5-acf8-f5b56b4ec57c', 'SEAT_LEAK', 110.00, 5, 'Max 0 bubbles/min (ISO 5208 Rate A)', '0 bubbles/min', 'PASS', 'cc9a4be8-38c2-4db9-bfed-ec7800379a51', 'CERT-SEA-5092', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.121591+00'),
	('de6fc941-2034-491e-afdf-266a89439dfc', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000021', '326a1502-8dcd-4de5-acf8-f5b56b4ec57c', 'FUNCTIONAL', NULL, NULL, 'Smooth operation, torque ≤ 85 Nm', '62 Nm', 'PASS', 'a2a098da-54a8-4ef7-b096-25c580473149', 'CERT-FUN-8315', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.130112+00'),
	('e22b2456-2241-4088-8c3f-47d35b88b9c8', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000022', 'c8b7b4fb-6148-494b-990d-b2b14b6350b3', 'SHELL_PRESSURE', 150.00, 15, 'No visible leakage', 'No leakage', 'PASS', '39ed37f2-99b8-4f7b-b5ab-a93be10edabb', 'CERT-SHE-5140', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.163738+00'),
	('1d811776-7fe6-4a93-9ed7-5fe92e2d6c94', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000023', 'c8b7b4fb-6148-494b-990d-b2b14b6350b3', 'SEAT_LEAK', 110.00, 5, 'Max 0 bubbles/min (ISO 5208 Rate A)', '0 bubbles/min', 'PASS', 'cc9a4be8-38c2-4db9-bfed-ec7800379a51', 'CERT-SEA-2939', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.171535+00'),
	('b5254f38-742d-4913-a206-993e02a1f0c6', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000024', 'c8b7b4fb-6148-494b-990d-b2b14b6350b3', 'FUNCTIONAL', NULL, NULL, 'Smooth operation, torque ≤ 85 Nm', '62 Nm', 'PASS', 'a2a098da-54a8-4ef7-b096-25c580473149', 'CERT-FUN-5557', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.180401+00'),
	('b6a2db42-5912-497a-bf8e-5aae16863a89', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000025', '451711cb-bdb5-46aa-a135-e7bb6ce9a477', 'SHELL_PRESSURE', 150.00, 15, 'No visible leakage', 'No leakage', 'PASS', '39ed37f2-99b8-4f7b-b5ab-a93be10edabb', 'CERT-SHE-9292', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.213474+00'),
	('8a4bb1f0-d646-49ea-8317-d6aa628d7f83', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000026', '451711cb-bdb5-46aa-a135-e7bb6ce9a477', 'SEAT_LEAK', 110.00, 5, 'Max 0 bubbles/min (ISO 5208 Rate A)', '0 bubbles/min', 'PASS', 'cc9a4be8-38c2-4db9-bfed-ec7800379a51', 'CERT-SEA-1695', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.224355+00'),
	('8a0134d1-bc8b-44bc-b930-630994317538', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000027', '451711cb-bdb5-46aa-a135-e7bb6ce9a477', 'FUNCTIONAL', NULL, NULL, 'Smooth operation, torque ≤ 85 Nm', '62 Nm', 'PASS', 'a2a098da-54a8-4ef7-b096-25c580473149', 'CERT-FUN-1184', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.232225+00'),
	('69d7ee45-d84f-42b6-b6f8-2fdeed29b46d', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000028', '1f31d15f-0bf3-45b3-991b-db09ef7af236', 'SHELL_PRESSURE', 150.00, 15, 'No visible leakage', 'No leakage', 'PASS', '39ed37f2-99b8-4f7b-b5ab-a93be10edabb', 'CERT-SHE-9422', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.268864+00'),
	('7dfa7962-03e8-42c1-84b0-9fcefeb22bce', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000029', '1f31d15f-0bf3-45b3-991b-db09ef7af236', 'SEAT_LEAK', 110.00, 5, 'Max 0 bubbles/min (ISO 5208 Rate A)', '0 bubbles/min', 'PASS', 'cc9a4be8-38c2-4db9-bfed-ec7800379a51', 'CERT-SEA-8460', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.279192+00'),
	('538a87fa-a8d9-4ee4-b143-378a185f0584', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000030', '1f31d15f-0bf3-45b3-991b-db09ef7af236', 'FUNCTIONAL', NULL, NULL, 'Smooth operation, torque ≤ 85 Nm', '62 Nm', 'PASS', 'a2a098da-54a8-4ef7-b096-25c580473149', 'CERT-FUN-7606', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.289637+00'),
	('c8e4b7b5-ef7c-4adc-8ad1-4c6af3ba1237', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000031', '92d9db2b-a78c-4256-bbf9-24dfafbec521', 'SHELL_PRESSURE', 150.00, 15, 'No visible leakage', 'No leakage', 'PASS', '39ed37f2-99b8-4f7b-b5ab-a93be10edabb', 'CERT-SHE-3838', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.337482+00'),
	('23127ce9-6d7b-4a05-832c-bb60219ccac2', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000032', '92d9db2b-a78c-4256-bbf9-24dfafbec521', 'SEAT_LEAK', 110.00, 5, 'Max 0 bubbles/min (ISO 5208 Rate A)', '0 bubbles/min', 'PASS', 'cc9a4be8-38c2-4db9-bfed-ec7800379a51', 'CERT-SEA-5445', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.347952+00'),
	('de9344f2-161a-411d-9cf7-87da967808a6', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000033', '92d9db2b-a78c-4256-bbf9-24dfafbec521', 'FUNCTIONAL', NULL, NULL, 'Smooth operation, torque ≤ 85 Nm', '62 Nm', 'PASS', 'a2a098da-54a8-4ef7-b096-25c580473149', 'CERT-FUN-2854', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.358038+00'),
	('63f23238-34b7-4c11-aa13-f06fefa7f946', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000034', 'b23230f2-f025-43ed-82dc-75a1c78a3ea1', 'SHELL_PRESSURE', 150.00, 15, 'No visible leakage', 'No leakage', 'PASS', '39ed37f2-99b8-4f7b-b5ab-a93be10edabb', 'CERT-SHE-8447', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.400044+00'),
	('c14deff2-d6e9-4353-9507-08d866c7453f', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000035', 'b23230f2-f025-43ed-82dc-75a1c78a3ea1', 'SEAT_LEAK', 110.00, 5, 'Max 0 bubbles/min (ISO 5208 Rate A)', '0 bubbles/min', 'PASS', 'cc9a4be8-38c2-4db9-bfed-ec7800379a51', 'CERT-SEA-4083', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.409752+00'),
	('7d856c5a-7f59-49cc-bd61-1765bfdd4ea4', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000036', 'b23230f2-f025-43ed-82dc-75a1c78a3ea1', 'FUNCTIONAL', NULL, NULL, 'Smooth operation, torque ≤ 85 Nm', '62 Nm', 'PASS', 'a2a098da-54a8-4ef7-b096-25c580473149', 'CERT-FUN-8784', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.419269+00'),
	('e10db956-431a-439c-93fd-1dccdcf33c29', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000037', '6140c882-132d-428a-9759-c01123be0297', 'SHELL_PRESSURE', 150.00, 15, 'No visible leakage', 'No leakage', 'PASS', '39ed37f2-99b8-4f7b-b5ab-a93be10edabb', 'CERT-SHE-1490', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.455106+00'),
	('8efe6337-8f17-428f-b776-ba1bfbf98c18', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000038', '6140c882-132d-428a-9759-c01123be0297', 'SEAT_LEAK', 110.00, 5, 'Max 0 bubbles/min (ISO 5208 Rate A)', '0 bubbles/min', 'PASS', 'cc9a4be8-38c2-4db9-bfed-ec7800379a51', 'CERT-SEA-5673', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.466261+00'),
	('a229b371-2a14-43db-a4a9-433d230ca32b', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000039', '6140c882-132d-428a-9759-c01123be0297', 'FUNCTIONAL', NULL, NULL, 'Smooth operation, torque ≤ 85 Nm', '62 Nm', 'PASS', 'a2a098da-54a8-4ef7-b096-25c580473149', 'CERT-FUN-5790', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.476759+00'),
	('13bf0ecf-b618-4e85-ae54-96b8fcc2923a', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000040', '25dd99d8-20bf-48f8-bece-c7e4f0bf1514', 'SHELL_PRESSURE', 150.00, 15, 'No visible leakage', 'No leakage', 'PASS', '39ed37f2-99b8-4f7b-b5ab-a93be10edabb', 'CERT-SHE-9841', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.498454+00'),
	('aadedcfe-763b-415f-974a-9ee47e39b3e2', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000041', '25dd99d8-20bf-48f8-bece-c7e4f0bf1514', 'SEAT_LEAK', 110.00, 5, 'Max 0 bubbles/min (ISO 5208 Rate A)', '12 bubbles/min', 'FAIL', 'cc9a4be8-38c2-4db9-bfed-ec7800379a51', 'CERT-SEA-7430', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.506525+00'),
	('69229ca5-2660-4d57-aa60-f01675b5aff0', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000042', '25dd99d8-20bf-48f8-bece-c7e4f0bf1514', 'SEAT_LEAK', 110.00, 5, 'Max 0 bubbles/min (ISO 5208 Rate A)', '0 bubbles/min', 'PASS', 'cc9a4be8-38c2-4db9-bfed-ec7800379a51', 'CERT-SEA-RETEST', 'aadedcfe-763b-415f-974a-9ee47e39b3e2', '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.538564+00'),
	('73aba2e3-ba1b-4562-8a34-98105cc76293', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000043', '25dd99d8-20bf-48f8-bece-c7e4f0bf1514', 'FUNCTIONAL', NULL, NULL, 'Smooth operation, torque ≤ 85 Nm', '62 Nm', 'PASS', 'a2a098da-54a8-4ef7-b096-25c580473149', 'CERT-FUN-1230', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.547529+00'),
	('d703876d-59a7-427a-a8bd-4f9ad37519e7', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000044', 'a54cf213-c4dd-4f12-a524-d401753e81b5', 'SHELL_PRESSURE', 150.00, 15, 'No visible leakage', 'No leakage', 'PASS', '39ed37f2-99b8-4f7b-b5ab-a93be10edabb', 'CERT-SHE-3301', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.596336+00'),
	('232602e7-5a1f-470f-8feb-ef489f3e3cc5', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000045', 'a54cf213-c4dd-4f12-a524-d401753e81b5', 'SEAT_LEAK', 110.00, 5, 'Max 0 bubbles/min (ISO 5208 Rate A)', '12 bubbles/min', 'FAIL', 'cc9a4be8-38c2-4db9-bfed-ec7800379a51', 'CERT-SEA-1717', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.604262+00'),
	('fe42fa29-de7c-497c-adcf-d496e04619c1', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000046', 'a54cf213-c4dd-4f12-a524-d401753e81b5', 'FUNCTIONAL', NULL, NULL, 'Smooth operation, torque ≤ 85 Nm', '62 Nm', 'PASS', 'a2a098da-54a8-4ef7-b096-25c580473149', 'CERT-FUN-6496', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.617526+00'),
	('2b6d2706-0a6d-41d0-bd33-5d1ba4246846', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000047', 'afdd35b7-be62-4847-a82c-64b8ddf1b75f', 'SHELL_PRESSURE', 150.00, 15, 'No visible leakage', 'No leakage', 'PASS', '39ed37f2-99b8-4f7b-b5ab-a93be10edabb', 'CERT-SHE-8844', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.639041+00'),
	('e745d095-4c67-4a4f-abe7-a13a4e4f73aa', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000048', 'afdd35b7-be62-4847-a82c-64b8ddf1b75f', 'SEAT_LEAK', 110.00, 5, 'Max 0 bubbles/min (ISO 5208 Rate A)', '0 bubbles/min', 'PASS', 'cc9a4be8-38c2-4db9-bfed-ec7800379a51', 'CERT-SEA-3193', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.647338+00'),
	('dfb8c529-2c60-427b-96eb-6cccf01a0c4a', '4a0f88e6-467f-406c-a37b-fde4abff9898', 'TST-2026-000049', 'afdd35b7-be62-4847-a82c-64b8ddf1b75f', 'FUNCTIONAL', NULL, NULL, 'Smooth operation, torque ≤ 85 Nm', '62 Nm', 'PASS', 'a2a098da-54a8-4ef7-b096-25c580473149', 'CERT-FUN-8008', NULL, '693a2518-49d6-4f23-8d7c-089491e70217', '2026-10-27 14:05:28.654748+00');


--
-- Data for Name: unit_components; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.unit_components VALUES
	('ba4a5cc4-1a4d-4cb8-b56e-196528fe61ee', '4ec63d7c-4c91-4963-834e-c9837b80f2d6', 'Body', '95d5f8ff-3e0e-4e8c-83a3-5a2302d2179c', NULL, true, 1.000),
	('0299b147-ddfb-4a27-9632-92cc7ca29512', '4ec63d7c-4c91-4963-834e-c9837b80f2d6', 'Stem', '4f97209e-2450-473b-9fa2-202f7f292a52', NULL, true, 1.000),
	('fc5d5d81-6248-499f-b737-359a6a8c8434', '4ec63d7c-4c91-4963-834e-c9837b80f2d6', 'Seat', 'd7bf700f-7b18-4e2b-b49b-b4a40562d9b0', NULL, true, 1.000),
	('44da4768-28cd-4fd2-b13f-106bfc40b03c', '4ec63d7c-4c91-4963-834e-c9837b80f2d6', 'Bonnet', 'a3951547-845b-4e82-97bb-5f68f0b32aaa', NULL, true, 1.000),
	('c2ea871d-4425-4234-8562-58808f068e2f', '4ec63d7c-4c91-4963-834e-c9837b80f2d6', 'Heat-treated stem (subcontract)', NULL, '67fe8e31-5628-4f20-a0fc-b1885b2434a1', true, 1.000),
	('6261ebe2-c009-47e5-8f00-d06244015580', '59f83746-e6fc-49f4-a77b-cb821493e11f', 'Body', '58a3b02d-323f-4467-98e1-e7a6fa301605', NULL, true, 1.000),
	('f3452840-dde5-4e37-9f13-cabd22bc933a', '59f83746-e6fc-49f4-a77b-cb821493e11f', 'Stem', '5f814b84-9601-463b-a2e3-30d480bf2957', NULL, true, 1.000),
	('5c72e6f0-f21c-4670-b328-b19a2e78aab3', '59f83746-e6fc-49f4-a77b-cb821493e11f', 'Seat', 'ac69d498-8678-482a-a1f8-b88b8aa5ff2d', NULL, true, 1.000),
	('f46f91a4-577e-45ff-bd8c-d8fb1615f68f', '59f83746-e6fc-49f4-a77b-cb821493e11f', 'Bonnet', 'b0650c06-a99d-4de4-b7f8-088489f58662', NULL, true, 1.000),
	('6766813f-e803-44b8-a2af-e403ece3286d', '4cb646d1-3878-4424-b41c-fdcf1caceca0', 'Body', '6b284d86-e253-4eb6-8042-ffff725e5290', NULL, true, 1.000),
	('95abcb9c-578c-4d06-915a-e26b6ea463a9', '4cb646d1-3878-4424-b41c-fdcf1caceca0', 'Stem', 'a72dcfd1-1cf8-4783-9663-76c21c970d92', NULL, true, 1.000),
	('b07def39-80b0-4086-92d2-cb5c2637de6f', '4cb646d1-3878-4424-b41c-fdcf1caceca0', 'Seat', 'd1d4171d-c2fb-4670-9e30-492d79057522', NULL, true, 1.000),
	('d107ec47-470d-4127-af35-eddc0cb3d378', '4cb646d1-3878-4424-b41c-fdcf1caceca0', 'Bonnet', 'ff2523c8-97a5-490f-a0ec-9a6282f4f47e', NULL, true, 1.000),
	('13f6e51b-5987-4161-b096-c822321aa11e', '400708e9-52e1-4214-b07c-c7837dbeeb2c', 'Body', '048db9a3-8ba6-4d10-bd7b-58a7f4d5f0f2', NULL, true, 1.000),
	('6c10f3fd-8436-45e5-a34f-a98c2a06fe22', '400708e9-52e1-4214-b07c-c7837dbeeb2c', 'Stem', '0120e309-58a4-4109-8fc0-3d73ec38cb1e', NULL, true, 1.000),
	('4f5a73b2-1795-4be1-a8ad-3ee714d93f8a', '400708e9-52e1-4214-b07c-c7837dbeeb2c', 'Seat', 'f68863e2-74c6-4938-a665-6b13c9844f68', NULL, true, 1.000),
	('ec8f490b-a7a3-4550-856b-e73c05c5113f', '400708e9-52e1-4214-b07c-c7837dbeeb2c', 'Bonnet', 'eebe2eea-b930-4d79-829a-bd637b413497', NULL, true, 1.000),
	('f8de7444-ac8c-4dd7-9868-729443b9e04e', '400708e9-52e1-4214-b07c-c7837dbeeb2c', 'Heat-treated stem (subcontract)', NULL, '928bcc07-9351-4024-8527-17b852b05b83', true, 1.000),
	('d9c34eb9-8d13-4f53-89c9-737e65625c19', 'f287ea25-7179-4e4d-a695-4bb1414938da', 'Body', '95d5f8ff-3e0e-4e8c-83a3-5a2302d2179c', NULL, true, 1.000),
	('bc47ef9e-3b71-4acd-9b22-bd76a2d96f25', 'f287ea25-7179-4e4d-a695-4bb1414938da', 'Stem', '4f97209e-2450-473b-9fa2-202f7f292a52', NULL, true, 1.000),
	('a715813a-0c95-4da5-b20f-ade948760e0c', 'f287ea25-7179-4e4d-a695-4bb1414938da', 'Seat', 'd7bf700f-7b18-4e2b-b49b-b4a40562d9b0', NULL, true, 1.000),
	('64523fbf-ef18-43c1-b4cb-bac1678d0226', 'f287ea25-7179-4e4d-a695-4bb1414938da', 'Bonnet', 'a3951547-845b-4e82-97bb-5f68f0b32aaa', NULL, true, 1.000),
	('a2b1cb93-600d-4d37-bf01-3f0b47bd01bd', 'e026d7e0-1793-48a6-8e1d-55052368ee86', 'Body', '58a3b02d-323f-4467-98e1-e7a6fa301605', NULL, true, 1.000),
	('ae80fabc-58e6-4c7c-abdb-4cd9e7f0390b', 'e026d7e0-1793-48a6-8e1d-55052368ee86', 'Stem', '5f814b84-9601-463b-a2e3-30d480bf2957', NULL, true, 1.000),
	('59251e87-6789-4ca5-8138-8804597ab198', 'e026d7e0-1793-48a6-8e1d-55052368ee86', 'Seat', 'ac69d498-8678-482a-a1f8-b88b8aa5ff2d', NULL, true, 1.000),
	('4817785b-3611-4ffa-ac29-7747127be874', 'e026d7e0-1793-48a6-8e1d-55052368ee86', 'Bonnet', 'b0650c06-a99d-4de4-b7f8-088489f58662', NULL, true, 1.000),
	('25832047-2ef1-4e85-835c-49e9690f3ab0', '1e0f70f6-1106-4b94-bbf5-f54796d3349d', 'Body', '6b284d86-e253-4eb6-8042-ffff725e5290', NULL, true, 1.000),
	('f0893056-6404-4d10-8ba8-2b3aa0752a3f', '1e0f70f6-1106-4b94-bbf5-f54796d3349d', 'Stem', 'a72dcfd1-1cf8-4783-9663-76c21c970d92', NULL, true, 1.000),
	('06433cfb-ebf7-43e0-991d-65194061e862', '1e0f70f6-1106-4b94-bbf5-f54796d3349d', 'Seat', 'd1d4171d-c2fb-4670-9e30-492d79057522', NULL, true, 1.000),
	('dcc1e8b5-bb78-4e9b-b3f3-ea65027f59eb', '1e0f70f6-1106-4b94-bbf5-f54796d3349d', 'Bonnet', 'ff2523c8-97a5-490f-a0ec-9a6282f4f47e', NULL, true, 1.000),
	('0b51bc1d-8dcf-4d99-8de8-94e2d0291344', 'e612e4b3-497c-470c-8396-74a36728f675', 'Body', '048db9a3-8ba6-4d10-bd7b-58a7f4d5f0f2', NULL, true, 1.000),
	('be764b08-d34b-4f3d-baae-f9835d7ae839', 'e612e4b3-497c-470c-8396-74a36728f675', 'Stem', '0120e309-58a4-4109-8fc0-3d73ec38cb1e', NULL, true, 1.000),
	('2b610412-a58c-47ff-bea9-fae488df77e0', 'e612e4b3-497c-470c-8396-74a36728f675', 'Seat', 'f68863e2-74c6-4938-a665-6b13c9844f68', NULL, true, 1.000),
	('81a6b1eb-70c7-4968-8a80-8a7ce80b6a52', 'e612e4b3-497c-470c-8396-74a36728f675', 'Bonnet', 'eebe2eea-b930-4d79-829a-bd637b413497', NULL, true, 1.000),
	('f69f0639-6417-4662-a13b-f3e910b9bb36', 'e612e4b3-497c-470c-8396-74a36728f675', 'Heat-treated stem (subcontract)', NULL, '5c8276ce-93e7-4872-a094-e1d04a02dc09', true, 1.000),
	('e26f0b37-fd45-435e-b7ed-d3b9e7927279', '326a1502-8dcd-4de5-acf8-f5b56b4ec57c', 'Body', '95d5f8ff-3e0e-4e8c-83a3-5a2302d2179c', NULL, true, 1.000),
	('0e6a745b-88b4-43cd-bfb4-a52c69818505', '326a1502-8dcd-4de5-acf8-f5b56b4ec57c', 'Stem', '4f97209e-2450-473b-9fa2-202f7f292a52', NULL, true, 1.000),
	('621af921-8180-47da-bfde-b443d8d87cf9', '326a1502-8dcd-4de5-acf8-f5b56b4ec57c', 'Seat', 'd7bf700f-7b18-4e2b-b49b-b4a40562d9b0', NULL, true, 1.000),
	('94b77988-4f56-4d7b-a22b-5d4f2dd07224', '326a1502-8dcd-4de5-acf8-f5b56b4ec57c', 'Bonnet', 'a3951547-845b-4e82-97bb-5f68f0b32aaa', NULL, true, 1.000),
	('b9ebe7e4-5a05-4587-8eaa-60139bcaf9d8', '25dd99d8-20bf-48f8-bece-c7e4f0bf1514', 'Body', '58a3b02d-323f-4467-98e1-e7a6fa301605', NULL, true, 1.000),
	('6411cb8e-c4a5-4f51-8e43-4790bc0b37e8', '25dd99d8-20bf-48f8-bece-c7e4f0bf1514', 'Stem', '5f814b84-9601-463b-a2e3-30d480bf2957', NULL, true, 1.000),
	('01eda511-b813-487c-a12d-c49744eef574', '25dd99d8-20bf-48f8-bece-c7e4f0bf1514', 'Seat', 'ac69d498-8678-482a-a1f8-b88b8aa5ff2d', NULL, true, 1.000),
	('8771c0ee-2cdb-4339-b742-e63efddd8880', '25dd99d8-20bf-48f8-bece-c7e4f0bf1514', 'Bonnet', 'b0650c06-a99d-4de4-b7f8-088489f58662', NULL, true, 1.000),
	('35e0df85-acfa-420b-8f27-5f4e91329a8b', '889f17af-4522-46de-a212-c9fc160fe4c5', 'Body', '6b284d86-e253-4eb6-8042-ffff725e5290', NULL, true, 1.000),
	('8cbc52c5-417f-4309-a6f6-0e7a1a2f0d33', '889f17af-4522-46de-a212-c9fc160fe4c5', 'Stem', 'a72dcfd1-1cf8-4783-9663-76c21c970d92', NULL, true, 1.000),
	('7eed3a17-8c37-458f-84b5-bc4a08c6c719', '889f17af-4522-46de-a212-c9fc160fe4c5', 'Seat', 'd1d4171d-c2fb-4670-9e30-492d79057522', NULL, true, 1.000),
	('44c19659-b91b-4b74-b79f-e3c0ebf87633', '889f17af-4522-46de-a212-c9fc160fe4c5', 'Bonnet', 'ff2523c8-97a5-490f-a0ec-9a6282f4f47e', NULL, true, 1.000),
	('7921e9e4-7d6c-4a63-9f37-1f69c0adef98', '889f17af-4522-46de-a212-c9fc160fe4c5', 'Heat-treated stem (subcontract)', NULL, 'afb1546c-d580-4537-b6d5-eda3606f40e1', true, 1.000),
	('0c5fde81-2f68-4526-b649-73c2bed965b7', 'e7390bf4-8562-4115-ba09-42cec5480e45', 'Body', '048db9a3-8ba6-4d10-bd7b-58a7f4d5f0f2', NULL, true, 1.000),
	('60ae8da4-4e94-436c-978c-f4b6f88554ab', 'e7390bf4-8562-4115-ba09-42cec5480e45', 'Stem', '0120e309-58a4-4109-8fc0-3d73ec38cb1e', NULL, true, 1.000);
INSERT INTO public.unit_components VALUES
	('925bd9ee-7949-4aab-bef7-febf2fe3cb2c', 'e7390bf4-8562-4115-ba09-42cec5480e45', 'Seat', 'f68863e2-74c6-4938-a665-6b13c9844f68', NULL, true, 1.000),
	('8901d0c9-7a71-451b-95f9-da1b979bf02d', 'e7390bf4-8562-4115-ba09-42cec5480e45', 'Bonnet', 'eebe2eea-b930-4d79-829a-bd637b413497', NULL, true, 1.000),
	('f7880f8b-4353-49ca-9fcc-81326fc14694', '38b43ff4-03c6-4021-a195-4b8973395fdc', 'Body', '95d5f8ff-3e0e-4e8c-83a3-5a2302d2179c', NULL, true, 1.000),
	('ca54cb94-845a-44dc-b458-efa27714b0f8', '38b43ff4-03c6-4021-a195-4b8973395fdc', 'Stem', '4f97209e-2450-473b-9fa2-202f7f292a52', NULL, true, 1.000),
	('4df72f9b-9406-4e63-9d8c-b978dedd6c69', '38b43ff4-03c6-4021-a195-4b8973395fdc', 'Seat', 'd7bf700f-7b18-4e2b-b49b-b4a40562d9b0', NULL, true, 1.000),
	('3e22ccbe-a45c-43b7-9658-79aa40c86ac7', '38b43ff4-03c6-4021-a195-4b8973395fdc', 'Bonnet', 'a3951547-845b-4e82-97bb-5f68f0b32aaa', NULL, true, 1.000),
	('f1f97c7c-8457-4815-9f8f-30deef6afa37', 'c8b7b4fb-6148-494b-990d-b2b14b6350b3', 'Body', '58a3b02d-323f-4467-98e1-e7a6fa301605', NULL, true, 1.000),
	('5c5ff281-cbe6-48e4-a568-ae125f3ce11f', 'c8b7b4fb-6148-494b-990d-b2b14b6350b3', 'Stem', '5f814b84-9601-463b-a2e3-30d480bf2957', NULL, true, 1.000),
	('ec520f0d-89bb-4558-bbc3-2ad526fc70e2', 'c8b7b4fb-6148-494b-990d-b2b14b6350b3', 'Seat', 'ac69d498-8678-482a-a1f8-b88b8aa5ff2d', NULL, true, 1.000),
	('0ce1f403-9658-40a2-a010-bd475fdd3b3b', 'c8b7b4fb-6148-494b-990d-b2b14b6350b3', 'Bonnet', 'b0650c06-a99d-4de4-b7f8-088489f58662', NULL, true, 1.000),
	('38b4d04e-8b4b-4c16-a25b-1306a66e3dd8', 'c8b7b4fb-6148-494b-990d-b2b14b6350b3', 'Heat-treated stem (subcontract)', NULL, '473a7904-d69f-4a5f-8567-35026e1621cd', true, 1.000),
	('b139b9f6-8642-4a3e-8794-dd90e3946df1', '451711cb-bdb5-46aa-a135-e7bb6ce9a477', 'Body', '6b284d86-e253-4eb6-8042-ffff725e5290', NULL, true, 1.000),
	('a852652e-444b-4135-8a7a-0edc28258301', '451711cb-bdb5-46aa-a135-e7bb6ce9a477', 'Stem', 'a72dcfd1-1cf8-4783-9663-76c21c970d92', NULL, true, 1.000),
	('0d6f6c80-2256-47d4-a381-07362d9c77d4', '451711cb-bdb5-46aa-a135-e7bb6ce9a477', 'Seat', 'd1d4171d-c2fb-4670-9e30-492d79057522', NULL, true, 1.000),
	('f50618cc-6e70-4bb1-9d21-00006be43b4d', '451711cb-bdb5-46aa-a135-e7bb6ce9a477', 'Bonnet', 'ff2523c8-97a5-490f-a0ec-9a6282f4f47e', NULL, true, 1.000),
	('bbbba270-db0d-41c5-b852-e738e1574d50', 'a54cf213-c4dd-4f12-a524-d401753e81b5', 'Body', '048db9a3-8ba6-4d10-bd7b-58a7f4d5f0f2', NULL, true, 1.000),
	('79e1c622-7b27-4ac0-948e-665139707aa5', 'a54cf213-c4dd-4f12-a524-d401753e81b5', 'Stem', '0120e309-58a4-4109-8fc0-3d73ec38cb1e', NULL, true, 1.000),
	('b27c6fda-407d-4b37-9a06-dc7672e57e81', 'a54cf213-c4dd-4f12-a524-d401753e81b5', 'Seat', 'f68863e2-74c6-4938-a665-6b13c9844f68', NULL, true, 1.000),
	('a3e658f3-be4a-4fd7-ae37-c5ef2462aed5', 'a54cf213-c4dd-4f12-a524-d401753e81b5', 'Bonnet', 'eebe2eea-b930-4d79-829a-bd637b413497', NULL, true, 1.000),
	('7d4db706-6894-4940-8cae-0cb5eb37b910', 'a54cf213-c4dd-4f12-a524-d401753e81b5', 'Heat-treated stem (subcontract)', NULL, 'bd842578-e6d3-42f0-8827-bba74d1a62c2', true, 1.000),
	('8e734181-f157-42fe-9aea-3e45755ffd2d', 'afdd35b7-be62-4847-a82c-64b8ddf1b75f', 'Body', '95d5f8ff-3e0e-4e8c-83a3-5a2302d2179c', NULL, true, 1.000),
	('42e0d099-c7a9-4522-b1c9-822f897c73f8', 'afdd35b7-be62-4847-a82c-64b8ddf1b75f', 'Stem', '4f97209e-2450-473b-9fa2-202f7f292a52', NULL, true, 1.000),
	('162ca427-fef0-4149-9280-5b5af4f242b2', 'afdd35b7-be62-4847-a82c-64b8ddf1b75f', 'Seat', 'd7bf700f-7b18-4e2b-b49b-b4a40562d9b0', NULL, true, 1.000),
	('6823b9b5-8ce6-4050-848f-035a9b26348d', 'afdd35b7-be62-4847-a82c-64b8ddf1b75f', 'Bonnet', 'a3951547-845b-4e82-97bb-5f68f0b32aaa', NULL, true, 1.000),
	('e8bd3b19-3fdc-42c6-b2a0-1d42b4f6d5d6', '1f31d15f-0bf3-45b3-991b-db09ef7af236', 'Body', '58a3b02d-323f-4467-98e1-e7a6fa301605', NULL, true, 1.000),
	('b7598091-a281-42c1-8b96-2386b4a929cb', '1f31d15f-0bf3-45b3-991b-db09ef7af236', 'Stem', '5f814b84-9601-463b-a2e3-30d480bf2957', NULL, true, 1.000),
	('6b0103b7-e9aa-4549-9bf4-8325a6b6b4df', '1f31d15f-0bf3-45b3-991b-db09ef7af236', 'Seat', 'ac69d498-8678-482a-a1f8-b88b8aa5ff2d', NULL, true, 1.000),
	('e0c69927-d5c5-4d10-a9e9-77e95360eb1a', '1f31d15f-0bf3-45b3-991b-db09ef7af236', 'Bonnet', 'b0650c06-a99d-4de4-b7f8-088489f58662', NULL, true, 1.000),
	('ceb80169-0479-4227-95d9-93b4a92fd9dc', '1f31d15f-0bf3-45b3-991b-db09ef7af236', 'Heat-treated stem (subcontract)', NULL, '23df83cd-8aa9-413e-9976-f733c6c5ff31', true, 1.000),
	('22778cca-ad44-468f-a362-1cda65388c48', '92d9db2b-a78c-4256-bbf9-24dfafbec521', 'Body', '6b284d86-e253-4eb6-8042-ffff725e5290', NULL, true, 1.000),
	('314a7d32-1e3c-43c3-87ef-474be16ca368', '92d9db2b-a78c-4256-bbf9-24dfafbec521', 'Stem', 'a72dcfd1-1cf8-4783-9663-76c21c970d92', NULL, true, 1.000),
	('6c6a3010-15a9-405d-ab20-0134b56ada72', '92d9db2b-a78c-4256-bbf9-24dfafbec521', 'Seat', 'd1d4171d-c2fb-4670-9e30-492d79057522', NULL, true, 1.000),
	('eb30b536-b41f-411b-a44c-16a4f8e13b36', '92d9db2b-a78c-4256-bbf9-24dfafbec521', 'Bonnet', 'ff2523c8-97a5-490f-a0ec-9a6282f4f47e', NULL, true, 1.000),
	('0e0ef10d-cf8f-456b-9d32-bf00b5459dc0', 'b23230f2-f025-43ed-82dc-75a1c78a3ea1', 'Body', '048db9a3-8ba6-4d10-bd7b-58a7f4d5f0f2', NULL, true, 1.000),
	('a6869a6a-c7e7-4d85-a76c-d8efba093630', 'b23230f2-f025-43ed-82dc-75a1c78a3ea1', 'Stem', '0120e309-58a4-4109-8fc0-3d73ec38cb1e', NULL, true, 1.000),
	('7cf231e6-8ad8-4476-99cf-ff21be1f490a', 'b23230f2-f025-43ed-82dc-75a1c78a3ea1', 'Seat', 'f68863e2-74c6-4938-a665-6b13c9844f68', NULL, true, 1.000),
	('a75aec33-e9a2-4e77-9e66-7317d9ce4aa3', 'b23230f2-f025-43ed-82dc-75a1c78a3ea1', 'Bonnet', 'eebe2eea-b930-4d79-829a-bd637b413497', NULL, true, 1.000),
	('adfb5788-c56c-4afb-a6f1-a5457cea40d6', 'b23230f2-f025-43ed-82dc-75a1c78a3ea1', 'Heat-treated stem (subcontract)', NULL, '0b892b0e-aea9-4c02-8197-4e4f9132c365', true, 1.000),
	('475c82a7-b829-4044-8568-0c95b2a50008', '6140c882-132d-428a-9759-c01123be0297', 'Body', '95d5f8ff-3e0e-4e8c-83a3-5a2302d2179c', NULL, true, 1.000),
	('bfdee441-b883-4926-9f16-e5c25c6841f2', '6140c882-132d-428a-9759-c01123be0297', 'Stem', '4f97209e-2450-473b-9fa2-202f7f292a52', NULL, true, 1.000),
	('1b0f71ff-7cdd-4fc4-a27c-75a204fc1285', '6140c882-132d-428a-9759-c01123be0297', 'Seat', 'd7bf700f-7b18-4e2b-b49b-b4a40562d9b0', NULL, true, 1.000),
	('b87aefef-c5d1-4c6e-ac56-e976ab551318', '6140c882-132d-428a-9759-c01123be0297', 'Bonnet', 'a3951547-845b-4e82-97bb-5f68f0b32aaa', NULL, true, 1.000);


--
-- Data for Name: user_organizations; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.user_organizations VALUES
	('cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '4a0f88e6-467f-406c-a37b-fde4abff9898'),
	('cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', 'b10f5674-4156-474a-864f-22de1bbc6757'),
	('0258e002-4154-48b4-ad1d-2195882841be', '4a0f88e6-467f-406c-a37b-fde4abff9898'),
	('693a2518-49d6-4f23-8d7c-089491e70217', '4a0f88e6-467f-406c-a37b-fde4abff9898'),
	('1b0292cb-4999-40df-893a-e2e9c3dc6101', '4a0f88e6-467f-406c-a37b-fde4abff9898'),
	('6b544707-dfa2-4b3b-8cf6-5d69641b903c', '4a0f88e6-467f-406c-a37b-fde4abff9898');


--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.user_roles VALUES
	('cc923352-cc34-40ba-b8f6-f8d8d5fdf82a', '168d5303-7a76-4843-8294-49316f0b0908'),
	('0258e002-4154-48b4-ad1d-2195882841be', '4662e854-037e-4e5f-9dd0-ae3c13f73a87'),
	('693a2518-49d6-4f23-8d7c-089491e70217', '6654d60b-bffc-4d51-ac64-19aedd897182'),
	('1b0292cb-4999-40df-893a-e2e9c3dc6101', '6c7b62bf-65e1-4280-9d6a-b0515ea8b8ba'),
	('6b544707-dfa2-4b3b-8cf6-5d69641b903c', 'cf70bbe1-df29-4305-aa5a-1d895a86453f');


--
-- Data for Name: wo_material_issues; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.wo_material_issues VALUES
	('4dc82f38-8da2-4a9e-b6c2-4b44bd54d793', '71cb5f2d-7cf9-4623-a70b-7baeb9c1b66c', '95d5f8ff-3e0e-4e8c-83a3-5a2302d2179c', 'd14a8056-467a-425a-a517-b0f08e05e8ec', 3.000, 620.0000, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:26.602547+00'),
	('2491e3d4-8a4c-4e59-88ea-970dffa837f3', '71cb5f2d-7cf9-4623-a70b-7baeb9c1b66c', '4f97209e-2450-473b-9fa2-202f7f292a52', '961b2013-58fb-45fb-8a7c-618c84887c18', 3.000, 220.0000, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:26.616645+00'),
	('a42877a0-aac9-461a-921e-288fb89dc48a', '6f1dd7e0-32bb-4c8a-a0d9-25e051a1a9b1', '58a3b02d-323f-4467-98e1-e7a6fa301605', 'd14a8056-467a-425a-a517-b0f08e05e8ec', 4.000, 620.0000, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:26.641006+00'),
	('8df121c9-e3fa-4d36-b6d1-02743e074aa0', '6f1dd7e0-32bb-4c8a-a0d9-25e051a1a9b1', '5f814b84-9601-463b-a2e3-30d480bf2957', '961b2013-58fb-45fb-8a7c-618c84887c18', 4.000, 220.0000, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:26.653087+00'),
	('7bdb6c30-caba-47bc-9bc8-712ea98b8e7e', 'a96efb75-c93f-4af2-b48a-4962753900cd', '6b284d86-e253-4eb6-8042-ffff725e5290', 'd14a8056-467a-425a-a517-b0f08e05e8ec', 3.000, 620.0000, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:26.677734+00'),
	('46562911-d258-405b-b0b5-384f1db12bf6', 'a96efb75-c93f-4af2-b48a-4962753900cd', 'a72dcfd1-1cf8-4783-9663-76c21c970d92', '961b2013-58fb-45fb-8a7c-618c84887c18', 3.000, 220.0000, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:26.687537+00'),
	('b05f200c-fbc3-4fc9-aa98-5687c93cf8ae', 'd996f72b-9fab-4c89-878a-34c63fe6f3ea', '048db9a3-8ba6-4d10-bd7b-58a7f4d5f0f2', 'd14a8056-467a-425a-a517-b0f08e05e8ec', 3.000, 620.0000, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:26.710697+00'),
	('996931bd-dce2-4a36-8dec-855362615c16', 'd996f72b-9fab-4c89-878a-34c63fe6f3ea', '0120e309-58a4-4109-8fc0-3d73ec38cb1e', '961b2013-58fb-45fb-8a7c-618c84887c18', 3.000, 220.0000, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:26.720027+00'),
	('30d244cd-337f-4d43-ba7b-47c3588c79fb', 'aed5986d-07e3-4fc5-9aae-74d6c3de22ff', '95d5f8ff-3e0e-4e8c-83a3-5a2302d2179c', 'd14a8056-467a-425a-a517-b0f08e05e8ec', 2.000, 620.0000, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:26.739791+00'),
	('59bc5707-5128-4bae-949b-463ff4562231', 'aed5986d-07e3-4fc5-9aae-74d6c3de22ff', '4f97209e-2450-473b-9fa2-202f7f292a52', '961b2013-58fb-45fb-8a7c-618c84887c18', 2.000, 220.0000, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:26.749376+00'),
	('01898ad7-0199-4307-9590-641380a878a0', '56925ee4-f597-4196-b51e-59ca9740cc60', '58a3b02d-323f-4467-98e1-e7a6fa301605', 'd14a8056-467a-425a-a517-b0f08e05e8ec', 2.000, 620.0000, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:26.768954+00'),
	('fdd597c7-fff7-47c8-bb55-447fcf48b3db', '56925ee4-f597-4196-b51e-59ca9740cc60', '5f814b84-9601-463b-a2e3-30d480bf2957', '961b2013-58fb-45fb-8a7c-618c84887c18', 2.000, 220.0000, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:26.778034+00'),
	('a19340c5-919b-44c7-8b34-1ee066857ce1', 'b4d2e412-f532-4bd4-8101-e08fd008857d', '048db9a3-8ba6-4d10-bd7b-58a7f4d5f0f2', 'd14a8056-467a-425a-a517-b0f08e05e8ec', 2.000, 620.0000, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:26.802374+00'),
	('6c964256-c454-4df5-8d5b-64c9a593b6d1', 'b4d2e412-f532-4bd4-8101-e08fd008857d', '0120e309-58a4-4109-8fc0-3d73ec38cb1e', '961b2013-58fb-45fb-8a7c-618c84887c18', 2.000, 220.0000, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:26.811276+00'),
	('3e9af087-2218-4c20-a6be-6223c47ecf91', '17d9f431-383d-4e86-9ba9-5c2e555fd89e', '58a3b02d-323f-4467-98e1-e7a6fa301605', 'd14a8056-467a-425a-a517-b0f08e05e8ec', 6.000, 620.0000, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:26.83555+00'),
	('8e662d01-f93b-42af-a1d6-5d34df5638b2', '17d9f431-383d-4e86-9ba9-5c2e555fd89e', '5f814b84-9601-463b-a2e3-30d480bf2957', '961b2013-58fb-45fb-8a7c-618c84887c18', 6.000, 220.0000, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:26.845001+00'),
	('1976d12a-de92-4a53-9b44-cb98d7055a2b', 'e215079d-260a-4bf0-9aa5-bf2a931bc28c', '6b284d86-e253-4eb6-8042-ffff725e5290', 'd14a8056-467a-425a-a517-b0f08e05e8ec', 4.000, 620.0000, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:26.865721+00'),
	('fff8de7b-5fac-47a4-9af6-fc1c8ae01040', 'e215079d-260a-4bf0-9aa5-bf2a931bc28c', 'a72dcfd1-1cf8-4783-9663-76c21c970d92', '961b2013-58fb-45fb-8a7c-618c84887c18', 4.000, 220.0000, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:26.874918+00'),
	('335c9cd7-5b0d-479a-babb-dd8ecfa1e1ca', 'ed7ae99b-3958-4efa-922f-7bf0e92beaf7', '048db9a3-8ba6-4d10-bd7b-58a7f4d5f0f2', 'd14a8056-467a-425a-a517-b0f08e05e8ec', 10.000, 620.0000, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:26.895078+00'),
	('403987b4-e9a4-4c25-985b-5d2372be80a8', 'ed7ae99b-3958-4efa-922f-7bf0e92beaf7', '0120e309-58a4-4109-8fc0-3d73ec38cb1e', '961b2013-58fb-45fb-8a7c-618c84887c18', 10.000, 220.0000, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:26.904587+00'),
	('856b7814-d569-4fbc-989c-2fbb03f450d2', '7aadadef-4d0a-4ddb-9052-9fa3df733888', '95d5f8ff-3e0e-4e8c-83a3-5a2302d2179c', 'd14a8056-467a-425a-a517-b0f08e05e8ec', 8.000, 620.0000, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:26.923211+00'),
	('682ce647-6ddf-4d66-8545-9fd45bb88908', '7aadadef-4d0a-4ddb-9052-9fa3df733888', '4f97209e-2450-473b-9fa2-202f7f292a52', '961b2013-58fb-45fb-8a7c-618c84887c18', 8.000, 220.0000, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:26.933127+00'),
	('a5798b58-8528-487a-9131-3a6557b1e114', 'c87a5b27-1f37-4ba1-98cc-a7c64214737b', '58a3b02d-323f-4467-98e1-e7a6fa301605', 'd14a8056-467a-425a-a517-b0f08e05e8ec', 5.000, 620.0000, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:26.95006+00'),
	('0e17f612-b5db-42ee-bc64-44ad5bb3f42e', 'c87a5b27-1f37-4ba1-98cc-a7c64214737b', '5f814b84-9601-463b-a2e3-30d480bf2957', '961b2013-58fb-45fb-8a7c-618c84887c18', 5.000, 220.0000, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:26.958748+00'),
	('c5dcf288-be18-40bf-acfb-7f92cd61863f', '6e4d3be3-969c-4555-9e96-ca9f6b65a201', '6b284d86-e253-4eb6-8042-ffff725e5290', 'd14a8056-467a-425a-a517-b0f08e05e8ec', 6.000, 620.0000, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:26.975924+00'),
	('0e9a87f0-5d2d-4274-b819-b1e18d91f810', '6e4d3be3-969c-4555-9e96-ca9f6b65a201', 'a72dcfd1-1cf8-4783-9663-76c21c970d92', '961b2013-58fb-45fb-8a7c-618c84887c18', 6.000, 220.0000, '1b0292cb-4999-40df-893a-e2e9c3dc6101', '2026-10-27 14:05:26.984644+00');


--
-- Data for Name: work_order_operations; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.work_order_operations VALUES
	('310288e6-f265-469c-a2fc-eac5db531d63', '8ebcb809-6629-4f68-add0-926ef84e4337', 10, 'Material cut & forge/casting prep', 'Stores/Saw', false, 'PENDING', 4.00, 0.00, 450.00, 0.000, 0.000, 0, NULL, NULL),
	('707c274e-0197-46e0-873e-2aae35b6509d', '8ebcb809-6629-4f68-add0-926ef84e4337', 20, 'CNC machining (body, bonnet, stem)', 'CNC', false, 'PENDING', 12.00, 0.00, 450.00, 0.000, 0.000, 0, NULL, NULL),
	('98fe1fdc-85ae-45f6-b3ec-5a5fe02669c6', '8ebcb809-6629-4f68-add0-926ef84e4337', 40, 'Seat lapping & deburr', 'Finishing', false, 'PENDING', 4.00, 0.00, 450.00, 0.000, 0.000, 0, NULL, NULL),
	('ab5c9ae3-3597-4192-b6e7-a0d0b567fe8f', '8ebcb809-6629-4f68-add0-926ef84e4337', 50, 'Assembly', 'Assembly', false, 'PENDING', 6.00, 0.00, 450.00, 0.000, 0.000, 0, NULL, NULL),
	('4410dc43-32bb-4452-a5d9-4067f639d795', '076f8a96-8f7a-4b69-a2db-b257e115f802', 10, 'Material cut & forge/casting prep', 'Stores/Saw', false, 'PENDING', 8.00, 0.00, 450.00, 0.000, 0.000, 0, NULL, NULL),
	('95c98c66-903a-4f99-876a-a88a78419e69', '076f8a96-8f7a-4b69-a2db-b257e115f802', 20, 'CNC machining (body, bonnet, stem)', 'CNC', false, 'PENDING', 24.00, 0.00, 450.00, 0.000, 0.000, 0, NULL, NULL),
	('b2ce19ad-82ce-411a-97b5-3231ea7ae008', '076f8a96-8f7a-4b69-a2db-b257e115f802', 30, 'Heat treatment / surface hardening', 'Subcontract', true, 'PENDING', 0.00, 0.00, 450.00, 0.000, 0.000, 0, NULL, NULL),
	('53498a4d-21d5-4c8e-807a-0214a9af14c2', '076f8a96-8f7a-4b69-a2db-b257e115f802', 40, 'Seat lapping & deburr', 'Finishing', false, 'PENDING', 8.00, 0.00, 450.00, 0.000, 0.000, 0, NULL, NULL),
	('a1708010-a999-41a5-adb6-787ba1f989ba', '076f8a96-8f7a-4b69-a2db-b257e115f802', 50, 'Assembly', 'Assembly', false, 'PENDING', 12.00, 0.00, 450.00, 0.000, 0.000, 0, NULL, NULL),
	('8dea0ca3-3723-4ba8-9102-af0358c34f9d', '17d9f431-383d-4e86-9ba9-5c2e555fd89e', 30, 'Heat treatment / surface hardening', 'Subcontract', true, 'PENDING', 0.00, 0.00, 450.00, 0.000, 0.000, 0, NULL, NULL),
	('82a5c026-38d8-454f-a425-bef9e6904f18', '17d9f431-383d-4e86-9ba9-5c2e555fd89e', 40, 'Seat lapping & deburr', 'Finishing', false, 'PENDING', 12.00, 0.00, 450.00, 0.000, 0.000, 0, NULL, NULL),
	('33813974-c4a4-46cd-a71f-b32b636a86bf', '17d9f431-383d-4e86-9ba9-5c2e555fd89e', 50, 'Assembly', 'Assembly', false, 'PENDING', 18.00, 0.00, 450.00, 0.000, 0.000, 0, NULL, NULL),
	('ffc4b10c-abfe-4617-ae25-c7c731edc1e8', 'e215079d-260a-4bf0-9aa5-bf2a931bc28c', 30, 'Heat treatment / surface hardening', 'Subcontract', true, 'PENDING', 0.00, 0.00, 450.00, 0.000, 0.000, 0, NULL, NULL),
	('d2e42bb7-e5bf-4add-b34e-24804d156263', 'e215079d-260a-4bf0-9aa5-bf2a931bc28c', 40, 'Seat lapping & deburr', 'Finishing', false, 'PENDING', 8.00, 0.00, 450.00, 0.000, 0.000, 0, NULL, NULL),
	('6a96aa8a-6c94-46a5-9899-bcf910e84158', 'e215079d-260a-4bf0-9aa5-bf2a931bc28c', 50, 'Assembly', 'Assembly', false, 'PENDING', 12.00, 0.00, 450.00, 0.000, 0.000, 0, NULL, NULL),
	('3dd99418-eee2-42f5-b5d6-2ab93535cfa0', '71cb5f2d-7cf9-4623-a70b-7baeb9c1b66c', 20, 'CNC machining (body, bonnet, stem)', 'CNC', false, 'DONE', 18.00, 18.00, 450.00, 0.000, 0.000, 35, 'R. Kumar', '2026-10-27 14:05:27.00442+00'),
	('ef0e9b67-4521-4c6f-84f2-f4075691a145', '71cb5f2d-7cf9-4623-a70b-7baeb9c1b66c', 40, 'Seat lapping & deburr', 'Finishing', false, 'DONE', 6.00, 6.00, 450.00, 0.000, 0.000, 0, 'R. Kumar', '2026-10-27 14:05:27.013682+00'),
	('727ea12c-4a00-42a7-b2ec-a81b395f98b8', '71cb5f2d-7cf9-4623-a70b-7baeb9c1b66c', 50, 'Assembly', 'Assembly', false, 'DONE', 9.00, 9.00, 450.00, 0.000, 0.000, 0, 'R. Kumar', '2026-10-27 14:05:27.021486+00'),
	('1b55915f-691d-40c6-86b5-9ff193fd0f11', '6f1dd7e0-32bb-4c8a-a0d9-25e051a1a9b1', 20, 'CNC machining (body, bonnet, stem)', 'CNC', false, 'DONE', 24.00, 25.92, 450.00, 0.000, 0.000, 0, 'S. Iyer', '2026-10-27 14:05:27.039556+00'),
	('0a74d72e-1328-462d-8bb3-5f9f0ae14b89', '6f1dd7e0-32bb-4c8a-a0d9-25e051a1a9b1', 40, 'Seat lapping & deburr', 'Finishing', false, 'DONE', 8.00, 8.64, 450.00, 0.000, 0.000, 0, 'S. Iyer', '2026-10-27 14:05:27.048437+00'),
	('c4e49a30-9ac7-4901-ad86-7328f114c695', '6f1dd7e0-32bb-4c8a-a0d9-25e051a1a9b1', 50, 'Assembly', 'Assembly', false, 'DONE', 12.00, 12.96, 450.00, 0.000, 0.000, 0, 'S. Iyer', '2026-10-27 14:05:27.05602+00'),
	('5ac40732-682c-4df3-8bc2-73640c561339', 'a96efb75-c93f-4af2-b48a-4962753900cd', 10, 'Material cut & forge/casting prep', 'Stores/Saw', false, 'DONE', 6.00, 6.96, 450.00, 0.000, 0.000, 0, 'P. Das', '2026-10-27 14:05:27.067086+00'),
	('1a307273-1513-4b7a-9798-b2d131a25e40', 'a96efb75-c93f-4af2-b48a-4962753900cd', 20, 'CNC machining (body, bonnet, stem)', 'CNC', false, 'DONE', 18.00, 20.88, 450.00, 1.000, 0.000, 0, 'P. Das', '2026-10-27 14:05:27.077006+00'),
	('6e4fc9fa-0c74-4251-a6be-136ff3066162', 'a96efb75-c93f-4af2-b48a-4962753900cd', 40, 'Seat lapping & deburr', 'Finishing', false, 'DONE', 6.00, 6.96, 450.00, 0.000, 0.000, 0, 'P. Das', '2026-10-27 14:05:27.088509+00'),
	('16666322-ee00-4dc3-bcf8-c1e699ce86a8', 'a96efb75-c93f-4af2-b48a-4962753900cd', 50, 'Assembly', 'Assembly', false, 'DONE', 9.00, 10.44, 450.00, 0.000, 0.000, 0, 'P. Das', '2026-10-27 14:05:27.097576+00'),
	('896ac1a7-79e4-4112-acde-178fa30477a6', 'd996f72b-9fab-4c89-878a-34c63fe6f3ea', 10, 'Material cut & forge/casting prep', 'Stores/Saw', false, 'DONE', 6.00, 6.00, 450.00, 0.000, 0.000, 0, 'R. Kumar', '2026-10-27 14:05:27.109367+00'),
	('ec2c8433-6c3c-46b9-9a8f-6be28e3160d3', 'd996f72b-9fab-4c89-878a-34c63fe6f3ea', 20, 'CNC machining (body, bonnet, stem)', 'CNC', false, 'DONE', 18.00, 18.00, 450.00, 0.000, 0.000, 0, 'R. Kumar', '2026-10-27 14:05:27.117824+00'),
	('42da3906-7120-4e45-be64-e99f56462d57', 'd996f72b-9fab-4c89-878a-34c63fe6f3ea', 40, 'Seat lapping & deburr', 'Finishing', false, 'DONE', 6.00, 6.00, 450.00, 0.000, 0.000, 0, 'R. Kumar', '2026-10-27 14:05:27.126016+00'),
	('22b388d8-71a6-4b73-845b-1952dbbe7dab', 'd996f72b-9fab-4c89-878a-34c63fe6f3ea', 50, 'Assembly', 'Assembly', false, 'DONE', 9.00, 9.00, 450.00, 0.000, 0.000, 0, 'R. Kumar', '2026-10-27 14:05:27.133717+00'),
	('70d6aa2b-d59d-4928-9e7c-103d20b6ea0d', 'aed5986d-07e3-4fc5-9aae-74d6c3de22ff', 10, 'Material cut & forge/casting prep', 'Stores/Saw', false, 'DONE', 4.00, 4.32, 450.00, 0.000, 0.000, 0, 'S. Iyer', '2026-10-27 14:05:27.143891+00'),
	('30cb1385-e4a9-40ee-973b-5b7a86ecd26d', 'aed5986d-07e3-4fc5-9aae-74d6c3de22ff', 20, 'CNC machining (body, bonnet, stem)', 'CNC', false, 'DONE', 12.00, 12.96, 450.00, 0.000, 0.000, 35, 'S. Iyer', '2026-10-27 14:05:27.151668+00'),
	('94a0ffbc-9a1b-40ad-9e46-978cd6ec89ee', 'aed5986d-07e3-4fc5-9aae-74d6c3de22ff', 50, 'Assembly', 'Assembly', false, 'DONE', 6.00, 6.48, 450.00, 0.000, 0.000, 0, 'S. Iyer', '2026-10-27 14:05:27.16789+00'),
	('5bbca289-e182-4590-b8a1-b2450d630c2e', '56925ee4-f597-4196-b51e-59ca9740cc60', 10, 'Material cut & forge/casting prep', 'Stores/Saw', false, 'DONE', 4.00, 4.64, 450.00, 0.000, 0.000, 0, 'P. Das', '2026-10-27 14:05:27.177764+00'),
	('5ab09acf-7a5d-4794-8841-fd6af3d123f1', '56925ee4-f597-4196-b51e-59ca9740cc60', 20, 'CNC machining (body, bonnet, stem)', 'CNC', false, 'DONE', 12.00, 13.92, 450.00, 0.000, 0.000, 0, 'P. Das', '2026-10-27 14:05:27.185548+00'),
	('089fe30f-f852-4816-858f-215e1c1ee83c', '56925ee4-f597-4196-b51e-59ca9740cc60', 40, 'Seat lapping & deburr', 'Finishing', false, 'DONE', 4.00, 4.64, 450.00, 0.000, 0.000, 0, 'P. Das', '2026-10-27 14:05:27.194968+00'),
	('fac5b63f-3e87-4b29-a08a-9eca9547856d', '56925ee4-f597-4196-b51e-59ca9740cc60', 50, 'Assembly', 'Assembly', false, 'DONE', 6.00, 6.96, 450.00, 0.000, 0.000, 0, 'P. Das', '2026-10-27 14:05:27.202868+00'),
	('d8d1c0ba-f131-4a0c-a2f6-5ceab06363b5', 'b4d2e412-f532-4bd4-8101-e08fd008857d', 10, 'Material cut & forge/casting prep', 'Stores/Saw', false, 'DONE', 4.00, 4.32, 450.00, 0.000, 0.000, 0, 'S. Iyer', '2026-10-27 14:05:27.214925+00'),
	('7a173401-86c8-40da-9373-583bb6a6c5ce', 'b4d2e412-f532-4bd4-8101-e08fd008857d', 20, 'CNC machining (body, bonnet, stem)', 'CNC', false, 'DONE', 12.00, 12.96, 450.00, 0.000, 0.000, 0, 'S. Iyer', '2026-10-27 14:05:27.222436+00'),
	('4efb4fd5-0e5f-43aa-a1d9-b88e5d4b5a07', 'b4d2e412-f532-4bd4-8101-e08fd008857d', 40, 'Seat lapping & deburr', 'Finishing', false, 'DONE', 4.00, 4.32, 450.00, 0.000, 0.000, 0, 'S. Iyer', '2026-10-27 14:05:27.23134+00'),
	('be13a862-e481-4ab4-b56e-8f08bb1953d8', 'b4d2e412-f532-4bd4-8101-e08fd008857d', 50, 'Assembly', 'Assembly', false, 'DONE', 6.00, 6.48, 450.00, 0.000, 0.000, 0, 'S. Iyer', '2026-10-27 14:05:27.238937+00'),
	('64ae7e21-d61e-4214-95ea-a70f9f98686e', '17d9f431-383d-4e86-9ba9-5c2e555fd89e', 10, 'Material cut & forge/casting prep', 'Stores/Saw', false, 'DONE', 12.00, 12.00, 450.00, 0.000, 0.000, 0, 'R. Kumar', '2026-10-27 14:05:27.251299+00'),
	('f6cccde2-3aee-4bbf-952d-50b01b5be77f', '17d9f431-383d-4e86-9ba9-5c2e555fd89e', 20, 'CNC machining (body, bonnet, stem)', 'CNC', false, 'DONE', 36.00, 36.00, 450.00, 0.000, 0.000, 0, 'R. Kumar', '2026-10-27 14:05:27.259234+00'),
	('85cb4c6b-921f-4fb9-ab0c-2c637dea0c6e', 'e215079d-260a-4bf0-9aa5-bf2a931bc28c', 20, 'CNC machining (body, bonnet, stem)', 'CNC', false, 'DONE', 24.00, 25.92, 450.00, 0.000, 0.000, 0, 'S. Iyer', '2026-10-27 14:05:27.27671+00'),
	('4ad2ef68-156e-4c3f-bb32-ec96bd4d345b', 'ed7ae99b-3958-4efa-922f-7bf0e92beaf7', 10, 'Material cut & forge/casting prep', 'Stores/Saw', false, 'DONE', 20.00, 23.20, 450.00, 0.000, 0.000, 0, 'P. Das', '2026-10-27 14:05:27.286537+00'),
	('4c3c487b-5186-4f68-91f4-7930a3c83bf6', '71cb5f2d-7cf9-4623-a70b-7baeb9c1b66c', 30, 'Heat treatment / surface hardening', 'Subcontract', true, 'DONE', 0.00, 0.00, 450.00, 0.000, 0.000, 0, NULL, '2026-10-27 14:05:27.317863+00'),
	('8f677e04-ee00-4fd0-970a-76bf9df48f9e', '6f1dd7e0-32bb-4c8a-a0d9-25e051a1a9b1', 30, 'Heat treatment / surface hardening', 'Subcontract', true, 'DONE', 0.00, 0.00, 450.00, 0.000, 0.000, 0, NULL, '2026-10-27 14:05:27.338065+00'),
	('74f1da79-e82e-467c-ac7d-aef070572ebb', 'a96efb75-c93f-4af2-b48a-4962753900cd', 30, 'Heat treatment / surface hardening', 'Subcontract', true, 'DONE', 0.00, 0.00, 450.00, 0.000, 0.000, 0, NULL, '2026-10-27 14:05:27.354316+00'),
	('4b410b17-6a94-4861-97c5-e38b5dca7495', 'd996f72b-9fab-4c89-878a-34c63fe6f3ea', 30, 'Heat treatment / surface hardening', 'Subcontract', true, 'DONE', 0.00, 0.00, 450.00, 0.000, 0.000, 0, NULL, '2026-10-27 14:05:27.369989+00'),
	('34832ac7-ba20-4076-bee8-d10d2bac0864', 'aed5986d-07e3-4fc5-9aae-74d6c3de22ff', 30, 'Heat treatment / surface hardening', 'Subcontract', true, 'DONE', 0.00, 0.00, 450.00, 0.000, 0.000, 0, NULL, '2026-10-27 14:05:27.386036+00'),
	('4f5157c3-ab6f-4db1-baf5-aa8fdf7d2aad', '56925ee4-f597-4196-b51e-59ca9740cc60', 30, 'Heat treatment / surface hardening', 'Subcontract', true, 'DONE', 0.00, 0.00, 450.00, 0.000, 0.000, 0, NULL, '2026-10-27 14:05:27.403324+00');
INSERT INTO public.work_order_operations VALUES
	('7facca97-b3ac-4a07-8f09-18021264fd2c', '8ebcb809-6629-4f68-add0-926ef84e4337', 30, 'Heat treatment / surface hardening', 'Subcontract', true, 'DONE', 0.00, 0.00, 450.00, 0.000, 0.000, 0, NULL, '2026-10-27 14:05:27.419416+00'),
	('b3dce367-643d-4f3e-8170-99e782d993b6', 'b4d2e412-f532-4bd4-8101-e08fd008857d', 30, 'Heat treatment / surface hardening', 'Subcontract', true, 'DONE', 0.00, 0.00, 450.00, 0.000, 0.000, 0, NULL, '2026-10-27 14:05:27.434262+00'),
	('ac6379c3-bde4-4e4a-8a0f-1470fb4b8ab7', 'ed7ae99b-3958-4efa-922f-7bf0e92beaf7', 30, 'Heat treatment / surface hardening', 'Subcontract', true, 'PENDING', 0.00, 0.00, 450.00, 0.000, 0.000, 0, NULL, NULL),
	('10ba4896-ca06-4d79-9152-258cd05a9817', 'ed7ae99b-3958-4efa-922f-7bf0e92beaf7', 40, 'Seat lapping & deburr', 'Finishing', false, 'PENDING', 20.00, 0.00, 450.00, 0.000, 0.000, 0, NULL, NULL),
	('55ad5045-0543-4b0d-942d-50a09ff171ea', 'ed7ae99b-3958-4efa-922f-7bf0e92beaf7', 50, 'Assembly', 'Assembly', false, 'PENDING', 30.00, 0.00, 450.00, 0.000, 0.000, 0, NULL, NULL),
	('94fa5aa8-d98a-46c8-b326-be4f4905f974', '7aadadef-4d0a-4ddb-9052-9fa3df733888', 10, 'Material cut & forge/casting prep', 'Stores/Saw', false, 'PENDING', 16.00, 0.00, 450.00, 0.000, 0.000, 0, NULL, NULL),
	('603d7eda-8d5b-43b7-af3e-0af76a2ebf18', '7aadadef-4d0a-4ddb-9052-9fa3df733888', 20, 'CNC machining (body, bonnet, stem)', 'CNC', false, 'PENDING', 48.00, 0.00, 450.00, 0.000, 0.000, 0, NULL, NULL),
	('1c70de8a-dfc4-4375-9323-eae9147cd9dc', '7aadadef-4d0a-4ddb-9052-9fa3df733888', 30, 'Heat treatment / surface hardening', 'Subcontract', true, 'PENDING', 0.00, 0.00, 450.00, 0.000, 0.000, 0, NULL, NULL),
	('cee2cca1-dcc0-4139-9d0b-9c46da681a73', '7aadadef-4d0a-4ddb-9052-9fa3df733888', 40, 'Seat lapping & deburr', 'Finishing', false, 'PENDING', 16.00, 0.00, 450.00, 0.000, 0.000, 0, NULL, NULL),
	('73785e26-11a8-476e-a931-c9aa28089312', '7aadadef-4d0a-4ddb-9052-9fa3df733888', 50, 'Assembly', 'Assembly', false, 'PENDING', 24.00, 0.00, 450.00, 0.000, 0.000, 0, NULL, NULL),
	('ae2c84c5-3333-44a4-b9ce-7d4dda5ad397', 'c87a5b27-1f37-4ba1-98cc-a7c64214737b', 10, 'Material cut & forge/casting prep', 'Stores/Saw', false, 'PENDING', 10.00, 0.00, 450.00, 0.000, 0.000, 0, NULL, NULL),
	('10cdc9de-df46-4919-b1dd-84d6192d89ce', 'c87a5b27-1f37-4ba1-98cc-a7c64214737b', 20, 'CNC machining (body, bonnet, stem)', 'CNC', false, 'PENDING', 30.00, 0.00, 450.00, 0.000, 0.000, 0, NULL, NULL),
	('b61a65bd-c97e-4193-9894-e8d133fd355b', 'c87a5b27-1f37-4ba1-98cc-a7c64214737b', 30, 'Heat treatment / surface hardening', 'Subcontract', true, 'PENDING', 0.00, 0.00, 450.00, 0.000, 0.000, 0, NULL, NULL),
	('f4a76188-4b30-4744-9d04-ce213f79fd4a', 'c87a5b27-1f37-4ba1-98cc-a7c64214737b', 40, 'Seat lapping & deburr', 'Finishing', false, 'PENDING', 10.00, 0.00, 450.00, 0.000, 0.000, 0, NULL, NULL),
	('6444a4f2-2161-47b5-b707-e401fdf6948c', 'c87a5b27-1f37-4ba1-98cc-a7c64214737b', 50, 'Assembly', 'Assembly', false, 'PENDING', 15.00, 0.00, 450.00, 0.000, 0.000, 0, NULL, NULL),
	('296b498a-d674-47ce-9f02-96886b6c539c', '6e4d3be3-969c-4555-9e96-ca9f6b65a201', 10, 'Material cut & forge/casting prep', 'Stores/Saw', false, 'PENDING', 12.00, 0.00, 450.00, 0.000, 0.000, 0, NULL, NULL),
	('71fea22c-6f99-467c-83bf-d91c7deb15e8', '6e4d3be3-969c-4555-9e96-ca9f6b65a201', 20, 'CNC machining (body, bonnet, stem)', 'CNC', false, 'PENDING', 36.00, 0.00, 450.00, 0.000, 0.000, 0, NULL, NULL),
	('1ba65c6f-2b10-43ba-b48f-8ab959b22300', '6e4d3be3-969c-4555-9e96-ca9f6b65a201', 30, 'Heat treatment / surface hardening', 'Subcontract', true, 'PENDING', 0.00, 0.00, 450.00, 0.000, 0.000, 0, NULL, NULL),
	('8dc9113a-8ede-4e04-b41c-c285fb152ec7', '6e4d3be3-969c-4555-9e96-ca9f6b65a201', 40, 'Seat lapping & deburr', 'Finishing', false, 'PENDING', 12.00, 0.00, 450.00, 0.000, 0.000, 0, NULL, NULL),
	('4dae1f1c-959e-4a85-99c4-23403934400a', '6e4d3be3-969c-4555-9e96-ca9f6b65a201', 50, 'Assembly', 'Assembly', false, 'PENDING', 18.00, 0.00, 450.00, 0.000, 0.000, 0, NULL, NULL),
	('934bf102-afa1-4280-bdc2-e684c4cc4e64', '71cb5f2d-7cf9-4623-a70b-7baeb9c1b66c', 10, 'Material cut & forge/casting prep', 'Stores/Saw', false, 'DONE', 6.00, 6.00, 450.00, 0.000, 0.000, 0, 'R. Kumar', '2026-10-27 14:05:26.995598+00'),
	('ba9a55f0-e8e6-4d90-ab4b-8b734ac898e2', '6f1dd7e0-32bb-4c8a-a0d9-25e051a1a9b1', 10, 'Material cut & forge/casting prep', 'Stores/Saw', false, 'DONE', 8.00, 8.64, 450.00, 0.000, 0.000, 0, 'S. Iyer', '2026-10-27 14:05:27.032042+00'),
	('5c1882ec-df08-4f5d-b551-ba1e898a7959', 'aed5986d-07e3-4fc5-9aae-74d6c3de22ff', 40, 'Seat lapping & deburr', 'Finishing', false, 'DONE', 4.00, 4.32, 450.00, 0.000, 1.000, 0, 'S. Iyer', '2026-10-27 14:05:27.15995+00'),
	('e95b3148-4e47-4561-a75c-28997b9d2440', 'e215079d-260a-4bf0-9aa5-bf2a931bc28c', 10, 'Material cut & forge/casting prep', 'Stores/Saw', false, 'DONE', 8.00, 8.64, 450.00, 0.000, 0.000, 0, 'S. Iyer', '2026-10-27 14:05:27.26888+00'),
	('712a38c1-65ef-4c80-8a29-87ad96dcd05d', 'ed7ae99b-3958-4efa-922f-7bf0e92beaf7', 20, 'CNC machining (body, bonnet, stem)', 'CNC', false, 'DONE', 60.00, 69.60, 450.00, 0.000, 0.000, 0, 'P. Das', '2026-10-27 14:05:27.295248+00');


--
-- Name: activities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.activities_id_seq', 200, true);


--
-- Name: audit_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.audit_logs_id_seq', 338, true);


--
-- Name: email_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.email_log_id_seq', 22, true);


--
-- Name: inquiry_submissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.inquiry_submissions_id_seq', 1, false);


--
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.notifications_id_seq', 11, true);


--
-- Name: status_transitions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.status_transitions_id_seq', 87, true);


--
-- Name: stock_movements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.stock_movements_id_seq', 23, true);


--
-- PostgreSQL database dump complete
--


