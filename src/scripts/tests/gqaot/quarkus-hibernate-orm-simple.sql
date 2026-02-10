--
-- PostgreSQL database dump
--

\restrict dD4f58gSffZFT9OSqVuhbcdoavbX2XigutZnoHpf8eWoVAWcVYZjfFJxsoNGVxn

-- Dumped from database version 18.1 (Debian 18.1-1.pgdg13+2)
-- Dumped by pg_dump version 18.1

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: fruit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fruit (
    id integer NOT NULL,
    name character varying(40)
);


ALTER TABLE public.fruit OWNER TO postgres;

--
-- Name: fruit_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fruit_seq
    START WITH 1
    INCREMENT BY 50
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fruit_seq OWNER TO postgres;

--
-- Data for Name: fruit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fruit (id, name) FROM stdin;
1	Cherry
2	Apple
3	Banana
\.


--
-- Name: fruit_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fruit_seq', 4, false);


--
-- Name: fruit fruit_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fruit
    ADD CONSTRAINT fruit_name_key UNIQUE (name);


--
-- Name: fruit fruit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fruit
    ADD CONSTRAINT fruit_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

\unrestrict dD4f58gSffZFT9OSqVuhbcdoavbX2XigutZnoHpf8eWoVAWcVYZjfFJxsoNGVxn

