--
-- PostgreSQL database dump
--

\restrict nZifXVaB0eWAWGqyeIcqkOSsBLmAbVc1Gqpp3XQL2ZgTsyQT1VqDLsiF22PCbWt

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
-- Name: aanbodperiode; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.aanbodperiode (
    begindatum date NOT NULL,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    cohort bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    naam character varying(255)
);


ALTER TABLE public.aanbodperiode OWNER TO postgres;

--
-- Name: aanleiding; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.aanleiding (
    gearchiveerd boolean NOT NULL,
    bijzonderheid bigint,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    traject bigint NOT NULL,
    begeleidingshandeling bigint,
    deelnemertest bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    incident bigint,
    notitie bigint,
    organisatie bigint NOT NULL,
    version bigint
);


ALTER TABLE public.aanleiding OWNER TO postgres;

--
-- Name: aanleidingtemplate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.aanleidingtemplate (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    bijzonderheidcategorie bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    testdefinitie bigint,
    trajecttemplate bigint NOT NULL,
    version bigint,
    type character varying(255) NOT NULL,
    CONSTRAINT aanleidingtemplate_type_check CHECK (((type)::text = ANY ((ARRAY['Test'::character varying, 'Bijzonderheid'::character varying])::text[])))
);


ALTER TABLE public.aanleidingtemplate OWNER TO postgres;

--
-- Name: aanmelding; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.aanmelding (
    begindatum date NOT NULL,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    intakegesprek bigint NOT NULL,
    organisatie bigint NOT NULL,
    verbintenis bigint NOT NULL,
    version bigint,
    status character varying(255) NOT NULL,
    CONSTRAINT aanmelding_status_check CHECK (((status)::text = ANY ((ARRAY['Nieuw'::character varying, 'NaderOnderzoek'::character varying, 'Goedgekeurd'::character varying, 'Geparkeerd'::character varying])::text[])))
);


ALTER TABLE public.aanmelding OWNER TO postgres;

--
-- Name: aanwezigentemplate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.aanwezigentemplate (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    handelingtemplate bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    persoon bigint,
    version bigint,
    type character varying(255) NOT NULL,
    CONSTRAINT aanwezigentemplate_type_check CHECK (((type)::text = ANY ((ARRAY['Mentor'::character varying, 'EersteUitvoerende'::character varying, 'AlleUitvoerenden'::character varying, 'Verantwoordelijke'::character varying, 'Deelnemer'::character varying, 'OudersVerzorgers'::character varying, 'GeselecteerdePersoon'::character varying])::text[])))
);


ALTER TABLE public.aanwezigentemplate OWNER TO postgres;

--
-- Name: absentiemelding; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.absentiemelding (
    afgehandeld boolean NOT NULL,
    beginlesuur integer,
    eindlesuur integer,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    absentiereden bigint NOT NULL,
    begindatumtijd timestamp(6) without time zone NOT NULL,
    deelnemer bigint NOT NULL,
    einddatumtijd timestamp(6) without time zone,
    herhalendeabsentiemelding bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    opmerkingen character varying(1024)
);


ALTER TABLE public.absentiemelding OWNER TO postgres;

--
-- Name: absentiereden; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.absentiereden (
    actief boolean,
    afkorting character varying(2) NOT NULL,
    automatichafgehandeld boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    geoorloofd boolean NOT NULL,
    standaardafgehandeld boolean NOT NULL,
    standaardzondereinddatum boolean NOT NULL,
    toegestaanvoordeelnemers boolean NOT NULL,
    tonenbijwaarnemingen boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    locatie bigint,
    organisatie bigint NOT NULL,
    organisatieeenheid bigint NOT NULL,
    version bigint,
    omschrijving character varying(30) NOT NULL,
    absentiesoort character varying(255) NOT NULL,
    CONSTRAINT absentiereden_absentiesoort_check CHECK (((absentiesoort)::text = ANY ((ARRAY['Absent'::character varying, 'Telaat'::character varying, 'Verwijderd'::character varying])::text[])))
);


ALTER TABLE public.absentiereden OWNER TO postgres;

--
-- Name: abstractdeelnemerevent; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.abstractdeelnemerevent (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    deelnemerid bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    hash character varying(100),
    onderwerp character varying(200),
    omschrijving oid
);


ALTER TABLE public.abstractdeelnemerevent OWNER TO postgres;

--
-- Name: abstractrelatie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.abstractrelatie (
    begindatum date NOT NULL,
    betalingsplichtige boolean,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    wettelijkevertegenwoordiger boolean,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    instelling bigint,
    organisatie bigint NOT NULL,
    persoon bigint NOT NULL,
    relatiesoort bigint,
    version bigint,
    verzorger bigint,
    type character varying(31) NOT NULL,
    CONSTRAINT abstractrelatie_check CHECK ((((type)::text <> 'P'::text) OR ((betalingsplichtige IS NOT NULL) AND (wettelijkevertegenwoordiger IS NOT NULL)))),
    CONSTRAINT abstractrelatie_check1 CHECK ((((type)::text <> 'O'::text) OR ((betalingsplichtige IS NOT NULL) AND (wettelijkevertegenwoordiger IS NOT NULL)))),
    CONSTRAINT abstractrelatie_type_check CHECK (((type)::text = ANY ((ARRAY['P'::character varying, 'O'::character varying])::text[])))
);


ALTER TABLE public.abstractrelatie OWNER TO postgres;

--
-- Name: account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    deelnemer bigint,
    externeorganisatiecontpers bigint,
    id bigint NOT NULL,
    medewerker bigint,
    organisatie bigint NOT NULL,
    version bigint,
    dtype character varying(31) NOT NULL,
    gebruikersnaam character varying(50) NOT NULL,
    wachtwoord character varying(50) NOT NULL,
    ipadressen character varying(200),
    authorisatieniveau character varying(255) NOT NULL,
    CONSTRAINT account_authorisatieniveau_check CHECK (((authorisatieniveau)::text = ANY ((ARRAY['SUPER'::character varying, 'APPLICATIE'::character varying, 'REST'::character varying])::text[]))),
    CONSTRAINT account_dtype_check CHECK (((dtype)::text = ANY ((ARRAY['DigitaalAanmelderAccount'::character varying, 'BeheerderAccount'::character varying, 'MedewerkerAccount'::character varying, 'DeelnemerAccount'::character varying, 'ExtOrgContPersAccount'::character varying])::text[])))
);


ALTER TABLE public.account OWNER TO postgres;

--
-- Name: accountrol; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.accountrol (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    account bigint NOT NULL,
    id bigint NOT NULL,
    organisatie bigint NOT NULL,
    rol bigint NOT NULL,
    version bigint
);


ALTER TABLE public.accountrol OWNER TO postgres;

--
-- Name: adres; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.adres (
    gearchiveerd boolean NOT NULL,
    geheim boolean NOT NULL,
    huisnummertoevoeging character varying(5),
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    gemeente bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    land bigint NOT NULL,
    organisatie bigint,
    provincie bigint,
    version bigint,
    postcode character varying(12),
    huisnummer character varying(15),
    duitsedeelstaat character varying(30),
    locatie character varying(35),
    plaats character varying(60) NOT NULL,
    straat character varying(60),
    CONSTRAINT adres_duitsedeelstaat_check CHECK (((duitsedeelstaat)::text = ANY ((ARRAY['Bremen'::character varying, 'NederSaksen'::character varying, 'Noord_Rijnland_Westfalen'::character varying, 'Overig'::character varying])::text[])))
);


ALTER TABLE public.adres OWNER TO postgres;

--
-- Name: adresentiteit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.adresentiteit (
    begindatum date NOT NULL,
    einddatum date,
    einddatumnotnull date NOT NULL,
    factuuradres boolean NOT NULL,
    fysiekadres boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    postadres boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    adres bigint NOT NULL,
    externeorganisatie bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    locatie bigint,
    organisatie bigint,
    organisatieeenheid bigint,
    persoon bigint,
    version bigint,
    dtype character varying(31) NOT NULL,
    CONSTRAINT adresentiteit_dtype_check CHECK (((dtype)::text = ANY ((ARRAY['LocatieAdres'::character varying, 'PersoonAdres'::character varying, 'OrganisatieEenheidAdres'::character varying, 'ExterneOrganisatieAdres'::character varying])::text[])))
);


ALTER TABLE public.adresentiteit OWNER TO postgres;

--
-- Name: afspraak; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.afspraak (
    beginlesuur integer,
    eindlesuur integer,
    gearchiveerd boolean NOT NULL,
    minuteniivo integer NOT NULL,
    presentiedoordeelnemer boolean NOT NULL,
    presentieregistratieverplicht boolean NOT NULL,
    presentieregistratieverwerkt boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    afspraaktype bigint NOT NULL,
    auteur bigint,
    basisrooster bigint,
    begindatumtijd timestamp(6) without time zone,
    cacheregion bigint,
    einddatumtijd timestamp(6) without time zone,
    herhalendeafspraak bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    inloopcollege bigint,
    locatie bigint,
    onderwijsproduct bigint,
    organisatie bigint NOT NULL,
    organisatieeenheid bigint NOT NULL,
    version bigint,
    afspraaklocatie character varying(100),
    externid character varying(500),
    externsysteem character varying(255),
    titel character varying(255) NOT NULL,
    omschrijving oid,
    CONSTRAINT afspraak_externsysteem_check CHECK (((externsysteem)::text = ANY ((ARRAY['Overig'::character varying, 'gpUntis'::character varying])::text[])))
);


ALTER TABLE public.afspraak OWNER TO postgres;

--
-- Name: afspraakdeelnemer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.afspraakdeelnemer (
    afspraak bigint,
    contract bigint,
    deelnemer bigint,
    organisatie bigint NOT NULL,
    id character varying(255) NOT NULL,
    uitnodigingstatus character varying(255) NOT NULL,
    CONSTRAINT afspraakdeelnemer_uitnodigingstatus_check CHECK (((uitnodigingstatus)::text = ANY ((ARRAY['DIRECTE_PLAATSING'::character varying, 'UITGENODIGD'::character varying, 'GEACCEPTEERD'::character varying, 'GEWEIGERD'::character varying, 'INGETEKEND'::character varying])::text[])))
);


ALTER TABLE public.afspraakdeelnemer OWNER TO postgres;

--
-- Name: afspraakparticipant; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.afspraakparticipant (
    gearchiveerd boolean NOT NULL,
    uitnodigingverstuurd boolean,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    afspraak bigint NOT NULL,
    contract bigint,
    deelnemer bigint,
    externe bigint,
    groep bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    medewerker bigint,
    organisatie bigint NOT NULL,
    persoonlijkegroep bigint,
    version bigint,
    uitnodigingstatus character varying(255) NOT NULL,
    CONSTRAINT afspraakparticipant_uitnodigingstatus_check CHECK (((uitnodigingstatus)::text = ANY ((ARRAY['DIRECTE_PLAATSING'::character varying, 'UITGENODIGD'::character varying, 'GEACCEPTEERD'::character varying, 'GEWEIGERD'::character varying, 'INGETEKEND'::character varying])::text[])))
);


ALTER TABLE public.afspraakparticipant OWNER TO postgres;

--
-- Name: afspraaktype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.afspraaktype (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    medewerkeronly boolean NOT NULL,
    percentageiivo integer NOT NULL,
    presentieregistratiedefault boolean NOT NULL,
    standaardkleur integer NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    locatie bigint,
    organisatie bigint NOT NULL,
    organisatieeenheid bigint NOT NULL,
    version bigint,
    naam character varying(30) NOT NULL,
    omschrijving character varying(1000) NOT NULL,
    category character varying(255) NOT NULL,
    onderwijsproductgebruik character varying(255) NOT NULL,
    presentieregistratie character varying(255) NOT NULL,
    uitnodigingenversturen character varying(255) NOT NULL,
    CONSTRAINT afspraaktype_category_check CHECK (((category)::text = ANY ((ARRAY['INDIVIDUEEL'::character varying, 'ROOSTER'::character varying, 'PRIVE'::character varying, 'BESCHERMD'::character varying, 'EXTERN'::character varying])::text[]))),
    CONSTRAINT afspraaktype_onderwijsproductgebruik_check CHECK (((onderwijsproductgebruik)::text = ANY ((ARRAY['ONGEBRUIKT'::character varying, 'OPTIONEEL'::character varying, 'VERPLICHT'::character varying])::text[]))),
    CONSTRAINT afspraaktype_presentieregistratie_check CHECK (((presentieregistratie)::text = ANY ((ARRAY['NIET'::character varying, 'STANDAARD_UIT'::character varying, 'STANDAARD_AAN'::character varying])::text[]))),
    CONSTRAINT afspraaktype_uitnodigingenversturen_check CHECK (((uitnodigingenversturen)::text = ANY ((ARRAY['NIET'::character varying, 'HANDMATIGE_AFSPRAKEN'::character varying, 'AUTOMATISCH_AFSPRAKEN'::character varying, 'ALLE'::character varying])::text[])))
);


ALTER TABLE public.afspraaktype OWNER TO postgres;

--
-- Name: agendainstellingen; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.agendainstellingen (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    persoon bigint NOT NULL,
    version bigint,
    delenmetdeelnemer character varying(255) NOT NULL,
    delenmetwerknemer character varying(255) NOT NULL,
    printopmaak character varying(255) NOT NULL,
    CONSTRAINT agendainstellingen_delenmetdeelnemer_check CHECK (((delenmetdeelnemer)::text = ANY ((ARRAY['VOLLEDIG'::character varying, 'TIJD_EN_TYPE'::character varying, 'HALF'::character varying, 'GEEN'::character varying])::text[]))),
    CONSTRAINT agendainstellingen_delenmetwerknemer_check CHECK (((delenmetwerknemer)::text = ANY ((ARRAY['VOLLEDIG'::character varying, 'TIJD_EN_TYPE'::character varying, 'HALF'::character varying, 'GEEN'::character varying])::text[]))),
    CONSTRAINT agendainstellingen_printopmaak_check CHECK (((printopmaak)::text = ANY ((ARRAY['KLEUR'::character varying, 'GRIJS'::character varying])::text[])))
);


ALTER TABLE public.agendainstellingen OWNER TO postgres;

--
-- Name: aggregatieniveau; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.aggregatieniveau (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    niveau integer,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    code character varying(10) NOT NULL,
    naam character varying(100) NOT NULL
);


ALTER TABLE public.aggregatieniveau OWNER TO postgres;

--
-- Name: basisrooster; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.basisrooster (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    organisatieeenheid bigint NOT NULL,
    version bigint,
    naam character varying(60) NOT NULL,
    externsysteem character varying(255),
    CONSTRAINT basisrooster_externsysteem_check CHECK (((externsysteem)::text = ANY ((ARRAY['Overig'::character varying, 'gpUntis'::character varying])::text[])))
);


ALTER TABLE public.basisrooster OWNER TO postgres;

--
-- Name: begeleidingshandeling; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.begeleidingshandeling (
    deadlinestatusovergang date,
    eindhandeling boolean,
    gearchiveerd boolean NOT NULL,
    gelezen boolean NOT NULL,
    geweigerd boolean NOT NULL,
    uitnodigingenversturen boolean,
    verslagversturen boolean,
    created_at timestamp(6) without time zone,
    created_by bigint,
    eigenaar bigint NOT NULL,
    gespreksoort bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    taaksoort bigint,
    testdefinitie bigint,
    traject bigint NOT NULL,
    verantwoordelijke bigint,
    afspraak bigint,
    deelnemertest bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    dtype character varying(31) NOT NULL,
    soort character varying(32) NOT NULL,
    aanleiding character varying(512),
    omschrijving character varying(255),
    status character varying(255) NOT NULL,
    opmerkingen oid,
    samenvatting oid,
    CONSTRAINT begeleidingshandeling_check CHECK ((((dtype)::text <> 'TestAfname'::text) OR ((uitnodigingenversturen IS NOT NULL) AND (verslagversturen IS NOT NULL)))),
    CONSTRAINT begeleidingshandeling_check1 CHECK ((((dtype)::text <> 'Taak'::text) OR (eindhandeling IS NOT NULL))),
    CONSTRAINT begeleidingshandeling_check2 CHECK ((((dtype)::text <> 'Gesprek'::text) OR ((uitnodigingenversturen IS NOT NULL) AND (verslagversturen IS NOT NULL)))),
    CONSTRAINT begeleidingshandeling_dtype_check CHECK (((dtype)::text = ANY ((ARRAY['TestAfname'::character varying, 'Gesprek'::character varying, 'Taak'::character varying])::text[]))),
    CONSTRAINT begeleidingshandeling_status_check CHECK (((status)::text = ANY ((ARRAY['Inplannen'::character varying, 'Uitvoeren'::character varying, 'Bespreken'::character varying, 'Voltooid'::character varying, 'Geannuleerd'::character varying])::text[])))
);


ALTER TABLE public.begeleidingshandeling OWNER TO postgres;

--
-- Name: begeleidingshandelingtemplate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.begeleidingshandelingtemplate (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    eigenaar bigint NOT NULL,
    gespreksoort bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    planning bigint NOT NULL,
    taaksoort bigint,
    testdefinitie bigint,
    toegekendaan bigint NOT NULL,
    version bigint,
    dtype character varying(31) NOT NULL,
    omschrijving character varying(255) NOT NULL,
    CONSTRAINT begeleidingshandelingtemplate_dtype_check CHECK (((dtype)::text = ANY ((ARRAY['TestAfnameTemplate'::character varying, 'GesprekTemplate'::character varying, 'TaakTemplate'::character varying])::text[])))
);


ALTER TABLE public.begeleidingshandelingtemplate OWNER TO postgres;

--
-- Name: beghandstatovrgang; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.beghandstatovrgang (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    begeleidingshandeling bigint,
    datumtijd timestamp(6) without time zone NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    medewerker bigint NOT NULL,
    organisatie bigint NOT NULL,
    version bigint,
    naarstatus character varying(255) NOT NULL,
    vanstatus character varying(255),
    CONSTRAINT beghandstatovrgang_naarstatus_check CHECK (((naarstatus)::text = ANY ((ARRAY['Inplannen'::character varying, 'Uitvoeren'::character varying, 'Bespreken'::character varying, 'Voltooid'::character varying, 'Geannuleerd'::character varying])::text[]))),
    CONSTRAINT beghandstatovrgang_vanstatus_check CHECK (((vanstatus)::text = ANY ((ARRAY['Inplannen'::character varying, 'Uitvoeren'::character varying, 'Bespreken'::character varying, 'Voltooid'::character varying, 'Geannuleerd'::character varying])::text[])))
);


ALTER TABLE public.beghandstatovrgang OWNER TO postgres;

--
-- Name: bekostigingsperiode; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bekostigingsperiode (
    begindatum date NOT NULL,
    bekostigd boolean NOT NULL,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    verbintenis bigint NOT NULL,
    version bigint
);


ALTER TABLE public.bekostigingsperiode OWNER TO postgres;

--
-- Name: betrokkenmedewerker; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.betrokkenmedewerker (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    incident bigint NOT NULL,
    medewerker bigint NOT NULL,
    organisatie bigint NOT NULL,
    version bigint
);


ALTER TABLE public.betrokkenmedewerker OWNER TO postgres;

--
-- Name: bijlage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bijlage (
    gearchiveerd boolean NOT NULL,
    geldigtot date,
    ontvangstdatum date,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    bestandsize bigint,
    documenttype bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    bestandsnaam character varying(200),
    documentnummer character varying(200),
    locatie character varying(200),
    omschrijving character varying(200),
    link character varying(1000),
    typebijlage character varying(255) NOT NULL,
    bestand oid,
    CONSTRAINT bijlage_typebijlage_check CHECK (((typebijlage)::text = ANY ((ARRAY['Link'::character varying, 'Bestand'::character varying, 'Overig'::character varying])::text[])))
);


ALTER TABLE public.bijlage OWNER TO postgres;

--
-- Name: bijlageentiteit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bijlageentiteit (
    begindatum date NOT NULL,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    afspraak bigint,
    begeleidingshandeling bigint,
    bijlage bigint NOT NULL,
    bijzonderheid bigint,
    bpvinschrijving bigint,
    deelnemer bigint,
    examendeelname bigint,
    externeorganisatie bigint,
    groep bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    incident bigint,
    irisincident bigint,
    notitie bigint,
    onderwijsproduct bigint,
    opleiding bigint,
    organisatie bigint NOT NULL,
    persoon bigint,
    test bigint,
    traject bigint,
    trajecttemplate bigint,
    verbintenis bigint,
    version bigint,
    dtype character varying(31) NOT NULL,
    CONSTRAINT bijlageentiteit_check CHECK ((((dtype)::text <> 'DeelnemerBijlage'::text) OR (deelnemer IS NOT NULL))),
    CONSTRAINT bijlageentiteit_check1 CHECK ((((dtype)::text <> 'NotitieBijlage'::text) OR (deelnemer IS NOT NULL))),
    CONSTRAINT bijlageentiteit_check2 CHECK ((((dtype)::text <> 'VerbintenisBijlage'::text) OR (deelnemer IS NOT NULL))),
    CONSTRAINT bijlageentiteit_check3 CHECK ((((dtype)::text <> 'ExamendeelnameBijlage'::text) OR (deelnemer IS NOT NULL))),
    CONSTRAINT bijlageentiteit_check4 CHECK ((((dtype)::text <> 'IncidentBijlage'::text) OR (deelnemer IS NOT NULL))),
    CONSTRAINT bijlageentiteit_check5 CHECK ((((dtype)::text <> 'BPVInschrijvingBijlage'::text) OR (deelnemer IS NOT NULL))),
    CONSTRAINT bijlageentiteit_check6 CHECK ((((dtype)::text <> 'TrajectBijlage'::text) OR (deelnemer IS NOT NULL))),
    CONSTRAINT bijlageentiteit_check7 CHECK ((((dtype)::text <> 'TestBijlage'::text) OR (deelnemer IS NOT NULL))),
    CONSTRAINT bijlageentiteit_check8 CHECK ((((dtype)::text <> 'BijzonderheidBijlage'::text) OR (deelnemer IS NOT NULL))),
    CONSTRAINT bijlageentiteit_check9 CHECK ((((dtype)::text <> 'BegeleidingsBijlage'::text) OR (deelnemer IS NOT NULL))),
    CONSTRAINT bijlageentiteit_dtype_check CHECK (((dtype)::text = ANY ((ARRAY['NotitieBijlage'::character varying, 'VerbintenisBijlage'::character varying, 'ExamendeelnameBijlage'::character varying, 'IncidentBijlage'::character varying, 'BPVInschrijvingBijlage'::character varying, 'TrajectBijlage'::character varying, 'TestBijlage'::character varying, 'BijzonderheidBijlage'::character varying, 'BegeleidingsBijlage'::character varying, 'DeelnemerBijlage'::character varying, 'IrisIncidentBijlage'::character varying, 'GroepBijlage'::character varying, 'TrajectTemplateBijlage'::character varying, 'AfspraakBijlage'::character varying, 'PersoonBijlage'::character varying, 'OpleidingBijlage'::character varying, 'OnderwijsproductBijlage'::character varying, 'ExterneOrganisatieBijlage'::character varying])::text[])))
);


ALTER TABLE public.bijlageentiteit OWNER TO postgres;

--
-- Name: bijzonderheid; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bijzonderheid (
    gearchiveerd boolean NOT NULL,
    tonenalswaarschuwing boolean NOT NULL,
    tonenopdeelnemerkaart boolean NOT NULL,
    vertrouwelijk boolean NOT NULL,
    zorglijn integer,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    auteur bigint NOT NULL,
    categorie bigint NOT NULL,
    datuminvoer timestamp(6) without time zone NOT NULL,
    deelnemer bigint NOT NULL,
    handelingsinstructies bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    titel character varying(50) NOT NULL,
    omschrijving oid
);


ALTER TABLE public.bijzonderheid OWNER TO postgres;

--
-- Name: bijzonderheidcategorie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bijzonderheidcategorie (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint,
    version bigint,
    code character varying(10) NOT NULL,
    naam character varying(50) NOT NULL
);


ALTER TABLE public.bijzonderheidcategorie OWNER TO postgres;

--
-- Name: bookmark; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bookmark (
    gearchiveerd boolean NOT NULL,
    pageprivate boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    account bigint NOT NULL,
    bookmarkfolder bigint,
    id bigint NOT NULL,
    organisatie bigint NOT NULL,
    version bigint,
    omschrijving character varying(100) NOT NULL,
    pageclass character varying(256) NOT NULL,
    soort character varying(255) NOT NULL,
    CONSTRAINT bookmark_soort_check CHECK (((soort)::text = ANY ((ARRAY['Bookmark'::character varying, 'ToDo'::character varying])::text[])))
);


ALTER TABLE public.bookmark OWNER TO postgres;

--
-- Name: bookmarkconstructorargument; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bookmarkconstructorargument (
    gearchiveerd boolean NOT NULL,
    haaluitcontext boolean NOT NULL,
    volgorde integer NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    bookmark bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    classname character varying(256) NOT NULL,
    waarde oid
);


ALTER TABLE public.bookmarkconstructorargument OWNER TO postgres;

--
-- Name: bookmarkfolder; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bookmarkfolder (
    gearchiveerd boolean NOT NULL,
    volgorde integer NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    account bigint NOT NULL,
    id bigint NOT NULL,
    organisatie bigint NOT NULL,
    version bigint,
    naam character varying(60) NOT NULL
);


ALTER TABLE public.bookmarkfolder OWNER TO postgres;

--
-- Name: bpvbedrijfsgegeven; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bpvbedrijfsgegeven (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    brin bigint NOT NULL,
    externeorganisatie bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    relatienummer character varying(20),
    codeleerbedrijf character varying(40),
    herkomstcode character varying(255),
    CONSTRAINT bpvbedrijfsgegeven_herkomstcode_check CHECK (((herkomstcode)::text = ANY ((ARRAY['Invoer'::character varying, 'Systeem'::character varying, 'BRON'::character varying, 'COLO'::character varying])::text[])))
);


ALTER TABLE public.bpvbedrijfsgegeven OWNER TO postgres;

--
-- Name: bpvcoloplaats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bpvcoloplaats (
    aantalgeregistreerdeleerlingen integer,
    gearchiveerd boolean NOT NULL,
    leerplaatsaantal integer,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    leerplaatsid bigint,
    organisatie bigint NOT NULL,
    version bigint,
    codeleerbedrijf character varying(255) NOT NULL,
    land character varying(255),
    leerbedrijfnaam character varying(255),
    leerplaatssoort character varying(255),
    leerweg character varying(255),
    plaats character varying(255),
    postcode character varying(255),
    straat character varying(255),
    vacatureleerplaatsomschrijving character varying(255)
);


ALTER TABLE public.bpvcoloplaats OWNER TO postgres;

--
-- Name: bpvcriteria; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bpvcriteria (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    toegestaankoppelextorg boolean NOT NULL,
    toegestaankoppelop boolean NOT NULL,
    toegestaankoppelstagekandidaat boolean NOT NULL,
    toegestaankoppelstageplaats boolean NOT NULL,
    toegestaankoppelstageprofiel boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    naam character varying(255) NOT NULL,
    omschrijving character varying(255) NOT NULL
);


ALTER TABLE public.bpvcriteria OWNER TO postgres;

--
-- Name: bpvcriteriabpvdeelnemerprofiel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bpvcriteriabpvdeelnemerprofiel (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    bpvcriteria bigint NOT NULL,
    bpvdeelnemerprofiel bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    status character varying(255) NOT NULL,
    CONSTRAINT bpvcriteriabpvdeelnemerprofiel_status_check CHECK (((status)::text = ANY ((ARRAY['Nieuw'::character varying, 'Goedgekeurd'::character varying, 'Afgekeurd'::character varying])::text[])))
);


ALTER TABLE public.bpvcriteriabpvdeelnemerprofiel OWNER TO postgres;

--
-- Name: bpvcriteriabpvkandidaat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bpvcriteriabpvkandidaat (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    bpvcriteria bigint NOT NULL,
    bpvkandidaat bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    status character varying(255) NOT NULL,
    CONSTRAINT bpvcriteriabpvkandidaat_status_check CHECK (((status)::text = ANY ((ARRAY['Nieuw'::character varying, 'Goedgekeurd'::character varying, 'Afgekeurd'::character varying])::text[])))
);


ALTER TABLE public.bpvcriteriabpvkandidaat OWNER TO postgres;

--
-- Name: bpvcriteriabpvplaats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bpvcriteriabpvplaats (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    bpvcriteria bigint NOT NULL,
    bpvplaats bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    status character varying(255) NOT NULL,
    CONSTRAINT bpvcriteriabpvplaats_status_check CHECK (((status)::text = ANY ((ARRAY['Nieuw'::character varying, 'Goedgekeurd'::character varying, 'Afgekeurd'::character varying])::text[])))
);


ALTER TABLE public.bpvcriteriabpvplaats OWNER TO postgres;

--
-- Name: bpvcriteriaexterneorganisatie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bpvcriteriaexterneorganisatie (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    bpvcriteria bigint NOT NULL,
    externeorganisatie bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    status character varying(255) NOT NULL,
    CONSTRAINT bpvcriteriaexterneorganisatie_status_check CHECK (((status)::text = ANY ((ARRAY['Nieuw'::character varying, 'Goedgekeurd'::character varying, 'Afgekeurd'::character varying])::text[])))
);


ALTER TABLE public.bpvcriteriaexterneorganisatie OWNER TO postgres;

--
-- Name: bpvcriteriaonderwijsproduct; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bpvcriteriaonderwijsproduct (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    bpvcriteria bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    onderwijsproduct bigint NOT NULL,
    organisatie bigint NOT NULL,
    version bigint,
    status character varying(255) NOT NULL,
    CONSTRAINT bpvcriteriaonderwijsproduct_status_check CHECK (((status)::text = ANY ((ARRAY['Nieuw'::character varying, 'Goedgekeurd'::character varying, 'Afgekeurd'::character varying])::text[])))
);


ALTER TABLE public.bpvcriteriaonderwijsproduct OWNER TO postgres;

--
-- Name: bpvdeelnemerprofiel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bpvdeelnemerprofiel (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint
);


ALTER TABLE public.bpvdeelnemerprofiel OWNER TO postgres;

--
-- Name: bpvinschrijving; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bpvinschrijving (
    afsluitdatum date,
    begindatum date NOT NULL,
    dagenperweek integer,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    gerealiseerdeomvang integer,
    neemtbetalingsplichtover boolean,
    opnemeninbron boolean NOT NULL,
    totaleomvang integer,
    urenperweek numeric(12,2),
    verwachteeinddatum date,
    volgnummer integer NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    bedrijfsgegeven bigint,
    bpvbedrijf bigint NOT NULL,
    bpvplaats bigint,
    brondatum timestamp(6) without time zone,
    contactpersoonbpvbedrijf bigint,
    contactpersooncontractpartner bigint,
    contractpartner bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    overeenkomstnummer bigint NOT NULL,
    praktijkbegeleider bigint,
    praktijkopleiderbpvbedrijf bigint,
    redenuitschrijving bigint,
    verbintenis bigint NOT NULL,
    version bigint,
    locatiepok character varying(30),
    werkdagen character varying(30),
    naampraktijkopleiderbpvbedrijf character varying(100),
    bronstatus character varying(255),
    praktijkbiedendeorganisatie character varying(255),
    status character varying(255) NOT NULL,
    opmerkingen oid,
    toelichtingbeeindiging oid,
    CONSTRAINT bpvinschrijving_bronstatus_check CHECK (((bronstatus)::text = ANY ((ARRAY['Geen'::character varying, 'Wachtrij'::character varying, 'WachtrijWelInBron'::character varying, 'InBehandeling'::character varying, 'InBehandelingWelInBron'::character varying, 'Goedgekeurd'::character varying, 'Afgekeurd'::character varying, 'AfgekeurdWelInBron'::character varying])::text[]))),
    CONSTRAINT bpvinschrijving_praktijkbiedendeorganisatie_check CHECK (((praktijkbiedendeorganisatie)::text = ANY ((ARRAY['BPVBEDRIJF'::character varying, 'CONTRACTPARTNER'::character varying])::text[]))),
    CONSTRAINT bpvinschrijving_status_check CHECK (((status)::text = ANY ((ARRAY['Voorlopig'::character varying, 'Volledig'::character varying, 'OvereenkomstAfgedrukt'::character varying, 'Definitief'::character varying, 'Beëindigd'::character varying, 'Afgemeld'::character varying, 'Afgewezen'::character varying])::text[])))
);


ALTER TABLE public.bpvinschrijving OWNER TO postgres;

--
-- Name: COLUMN bpvinschrijving.neemtbetalingsplichtover; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.bpvinschrijving.neemtbetalingsplichtover IS 'Geeft aan dat het BPV-bedrijf de betalingsplicht van alle kosten overneemt.';


--
-- Name: COLUMN bpvinschrijving.totaleomvang; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.bpvinschrijving.totaleomvang IS '40/52 van het aantal uren per week over de periode tussen begin- en verwachte einddatum, met een maximum van 5120';


--
-- Name: COLUMN bpvinschrijving.contractpartner; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.bpvinschrijving.contractpartner IS 'De contractpartner, in gevallen waarbij bij de BPV-overeenkomst niet alleen het geaccrediteerde BPV-bedrijf betrokken is, maar ook een contractpartner die optreedt als werkgever, holding of bijv. uitzendbureau.';


--
-- Name: bpvkandidaat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bpvkandidaat (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    bpvinschrijving bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    verbintenis bigint NOT NULL,
    version bigint,
    matchingstatus character varying(255) NOT NULL,
    matchingtype character varying(255) NOT NULL,
    CONSTRAINT bpvkandidaat_matchingstatus_check CHECK (((matchingstatus)::text = ANY ((ARRAY['Kandidaat'::character varying, 'Gematched'::character varying, 'MatchAkkoord'::character varying, 'BPVAangemaakt'::character varying, 'Geannuleerd'::character varying])::text[]))),
    CONSTRAINT bpvkandidaat_matchingtype_check CHECK (((matchingtype)::text = ANY ((ARRAY['Instelling'::character varying, 'Deelnemer'::character varying, 'Profiel'::character varying])::text[])))
);


ALTER TABLE public.bpvkandidaat OWNER TO postgres;

--
-- Name: bpvkandidaatonderwijsproduct; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bpvkandidaatonderwijsproduct (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    bpvkandidaat bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    onderwijsproduct bigint NOT NULL,
    organisatie bigint NOT NULL,
    version bigint
);


ALTER TABLE public.bpvkandidaatonderwijsproduct OWNER TO postgres;

--
-- Name: bpvmatch; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bpvmatch (
    gearchiveerd boolean NOT NULL,
    keuzevervallen boolean NOT NULL,
    keuzevolgnummer integer NOT NULL,
    matchakkoord boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    bpvcoloplaats bigint,
    bpvkandidaat bigint NOT NULL,
    bpvplaats bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint
);


ALTER TABLE public.bpvmatch OWNER TO postgres;

--
-- Name: bpvplaats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bpvplaats (
    aantalplaatsen integer NOT NULL,
    aantalstudenten integer NOT NULL,
    begeleidingsuren integer NOT NULL,
    dagenperweek integer,
    gearchiveerd boolean NOT NULL,
    matchingdoorinstelling boolean NOT NULL,
    matchingdoorstudenten boolean NOT NULL,
    urenperweek numeric(12,2),
    vergoeding numeric(20,10),
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    begindatum timestamp(6) without time zone,
    contactpersoonbpvbedrijf bigint,
    einddatum timestamp(6) without time zone,
    externeorganisatie bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    opdrachtomschrijving character varying(255),
    type character varying(255),
    CONSTRAINT bpvplaats_type_check CHECK (((type)::text = ANY ((ARRAY['AfstudeerStage'::character varying, 'Tussenstage'::character varying])::text[])))
);


ALTER TABLE public.bpvplaats OWNER TO postgres;

--
-- Name: bpvplaatsopleiding; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bpvplaatsopleiding (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    bpvplaats bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    opleiding bigint NOT NULL,
    organisatie bigint NOT NULL,
    version bigint
);


ALTER TABLE public.bpvplaatsopleiding OWNER TO postgres;

--
-- Name: budget; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.budget (
    aantaluur integer NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    onderwijsproduct bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    verbintenis bigint NOT NULL,
    version bigint
);


ALTER TABLE public.budget OWNER TO postgres;

--
-- Name: cacheregion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cacheregion (
    dirty boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    regionenddate date NOT NULL,
    regionstartdate date NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    externeagenda bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    lastupdate timestamp(6) without time zone NOT NULL,
    organisatie bigint NOT NULL,
    version bigint
);


ALTER TABLE public.cacheregion OWNER TO postgres;

--
-- Name: cohort; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cohort (
    begindatum date NOT NULL,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    version bigint,
    naam character varying(20) NOT NULL
);


ALTER TABLE public.cohort OWNER TO postgres;

--
-- Name: competentie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.competentie (
    code character varying(1) NOT NULL,
    gearchiveerd boolean NOT NULL,
    nummer integer NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    version bigint,
    titel character varying(128) NOT NULL
);


ALTER TABLE public.competentie OWNER TO postgres;

--
-- Name: competentiecomponent; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.competentiecomponent (
    gearchiveerd boolean NOT NULL,
    nummer integer NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    competentie bigint NOT NULL,
    id bigint NOT NULL,
    version bigint,
    titel character varying(128) NOT NULL
);


ALTER TABLE public.competentiecomponent OWNER TO postgres;

--
-- Name: competentieniveau; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.competentieniveau (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    leerpunt bigint NOT NULL,
    niveauverzameling bigint NOT NULL,
    organisatie bigint NOT NULL,
    score bigint,
    version bigint
);


ALTER TABLE public.competentieniveau OWNER TO postgres;

--
-- Name: competentieniveauverzameling; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.competentieniveauverzameling (
    datum date,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    cohort bigint,
    deelnemer bigint,
    groep bigint,
    groepsbeoordeling bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    matrix bigint NOT NULL,
    medewerker bigint,
    meeteenheid bigint NOT NULL,
    opgenomenin bigint,
    opleiding bigint,
    organisatie bigint NOT NULL,
    version bigint,
    dtype character varying(31) NOT NULL,
    naam character varying(100) NOT NULL,
    type character varying(255),
    commentaar oid,
    CONSTRAINT competentieniveauverzameling_dtype_check CHECK (((dtype)::text = ANY ((ARRAY['GroepsbeoordelingOverschrijving'::character varying, 'Groepsbeoordeling'::character varying, 'Beoordeling'::character varying, 'IJkpunt'::character varying, 'LokaalCompetentieMaximum'::character varying])::text[]))),
    CONSTRAINT competentieniveauverzameling_type_check CHECK (((type)::text = ANY ((ARRAY['EVC_EVK'::character varying, 'BEOORDELING'::character varying, 'DOCENTBEOORDELING'::character varying])::text[])))
);


ALTER TABLE public.competentieniveauverzameling OWNER TO postgres;

--
-- Name: contactpersoon; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contactpersoon (
    begindatum date NOT NULL,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    bijorganisatieeenheid bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    persoon bigint NOT NULL,
    version bigint,
    voororganisatieeenheid bigint
);


ALTER TABLE public.contactpersoon OWNER TO postgres;

--
-- Name: contract; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contract (
    begindatum date NOT NULL,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    kostprijs numeric(19,2),
    maximumaantaldeelnemers integer,
    minimumaantaldeelnemers integer,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    beheerder bigint,
    contactpersoon bigint,
    eindeinstroom timestamp(6) without time zone NOT NULL,
    externeorganisatie bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    organisatieeenheid bigint,
    soortcontract bigint NOT NULL,
    typefinanciering bigint,
    version bigint,
    externnummer character varying(20),
    aanwezigbij character varying(30),
    code character varying(30) NOT NULL,
    onderaannemingbij character varying(50),
    naam character varying(100) NOT NULL,
    onderaanneming character varying(255),
    toelichting oid,
    CONSTRAINT contract_onderaanneming_check CHECK (((onderaanneming)::text = ANY ((ARRAY['Geen'::character varying, 'GeheelUitbesteed'::character varying, 'GedeeltelijkUitbesteed'::character varying, 'InOnderaanneming'::character varying])::text[])))
);


ALTER TABLE public.contract OWNER TO postgres;

--
-- Name: contractlocatiekoppeling; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contractlocatiekoppeling (
    contract_id bigint NOT NULL,
    locatie_id bigint NOT NULL
);


ALTER TABLE public.contractlocatiekoppeling OWNER TO postgres;

--
-- Name: contractonderdeel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contractonderdeel (
    begindatum date NOT NULL,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    maximumaantaldeelnemers integer,
    minimumaantaldeelnemers integer,
    prijs numeric(19,2),
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    contract bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    begeleidingsintensiteit character varying(25),
    frequentieaanwezigheid character varying(25),
    groepsgrootte character varying(25),
    studiebelasting character varying(25),
    naam character varying(100) NOT NULL
);


ALTER TABLE public.contractonderdeel OWNER TO postgres;

--
-- Name: contractverplichting; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contractverplichting (
    begindatum date NOT NULL,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    uitgevoerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    contract bigint NOT NULL,
    datumuitgevoerd timestamp(6) without time zone,
    id bigint NOT NULL,
    idinoudpakket bigint,
    medewerker bigint,
    organisatie bigint NOT NULL,
    version bigint,
    omschrijving character varying(100) NOT NULL
);


ALTER TABLE public.contractverplichting OWNER TO postgres;

--
-- Name: criterium; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.criterium (
    gearchiveerd boolean NOT NULL,
    volgnummer integer NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    cohort bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    opleiding bigint,
    organisatie bigint,
    verbintenisgebied bigint,
    version bigint,
    melding character varying(500) NOT NULL,
    naam character varying(500) NOT NULL,
    formule oid NOT NULL
);


ALTER TABLE public.criterium OWNER TO postgres;

--
-- Name: crohoopleidingaanbod; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.crohoopleidingaanbod (
    aanvullendeeisen boolean NOT NULL,
    begindatum date NOT NULL,
    beroepsvereisten boolean,
    datumaccreditatiebesluit date,
    datumeindeinstroomaccreditatie date,
    datumuitsteltotaccreditatie date,
    datumvervallenaccreditatie date,
    decentraleselectie boolean NOT NULL,
    deficientie boolean,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    propedeutischexamen boolean NOT NULL,
    studielast integer NOT NULL,
    studielastvt integer NOT NULL,
    werkzaamheden boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    brin bigint NOT NULL,
    crohoopleiding bigint NOT NULL,
    datumeindeinstroom timestamp(6) without time zone,
    id bigint NOT NULL,
    version bigint,
    vervaldatumdecentraleselectie timestamp(6) without time zone,
    onderdeel character varying(30) NOT NULL,
    bekostiging character varying(255) NOT NULL,
    opleidingsvorm character varying(255) NOT NULL,
    soortaanmelding character varying(255) NOT NULL,
    soortfixus character varying(255),
    CONSTRAINT crohoopleidingaanbod_bekostiging_check CHECK (((bekostiging)::text = ANY ((ARRAY['Bekostigd'::character varying, 'Aangewezen'::character varying, 'OpenBestel'::character varying, 'Overig'::character varying])::text[]))),
    CONSTRAINT crohoopleidingaanbod_onderdeel_check CHECK (((onderdeel)::text = ANY ((ARRAY['Economie'::character varying, 'GedragEnMaatschappij'::character varying, 'Gezondheidszorg'::character varying, 'LandbouwEnNatuurlijkeOmgeving'::character varying, 'Natuur'::character varying, 'Onderwijs'::character varying, 'Recht'::character varying, 'Sectoroverstijgend'::character varying, 'TaalEnCultuur'::character varying, 'Techniek'::character varying])::text[]))),
    CONSTRAINT crohoopleidingaanbod_opleidingsvorm_check CHECK (((opleidingsvorm)::text = ANY ((ARRAY['Voltijd'::character varying, 'Deeltijd'::character varying, 'Duaal'::character varying])::text[]))),
    CONSTRAINT crohoopleidingaanbod_soortaanmelding_check CHECK (((soortaanmelding)::text = ANY ((ARRAY['Centraal'::character varying, 'Instelling'::character varying])::text[]))),
    CONSTRAINT crohoopleidingaanbod_soortfixus_check CHECK (((soortfixus)::text = ANY ((ARRAY['Studiefixus'::character varying, 'Instellingsfixus'::character varying])::text[])))
);


ALTER TABLE public.crohoopleidingaanbod OWNER TO postgres;

--
-- Name: curriculum; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.curriculum (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    cohort bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    locatie bigint,
    opleiding bigint NOT NULL,
    organisatie bigint NOT NULL,
    organisatieeenheid bigint NOT NULL,
    version bigint
);


ALTER TABLE public.curriculum OWNER TO postgres;

--
-- Name: curriculumonderwijsproduct; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.curriculumonderwijsproduct (
    gearchiveerd boolean NOT NULL,
    leerjaar integer NOT NULL,
    onderwijstijd numeric(20,10),
    periode integer NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    curriculum bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    onderwijsproduct bigint NOT NULL,
    organisatie bigint NOT NULL,
    version bigint
);


ALTER TABLE public.curriculumonderwijsproduct OWNER TO postgres;

--
-- Name: deelnemer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.deelnemer (
    allochtoon boolean,
    dapersgegegensconflict boolean,
    deelnemernummer integer NOT NULL,
    gbarelatie boolean,
    gearchiveerd boolean NOT NULL,
    heeftbachelorgraad boolean,
    heeftmastergraad boolean,
    lgf boolean NOT NULL,
    registratiedatum date,
    startkwalificatieplichtigtot date,
    studielinknummer integer,
    uitsluitenvanfacturatie boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    brondatum timestamp(6) without time zone,
    id bigint NOT NULL,
    idinoudpakket bigint,
    ocwnummer bigint,
    onderwijsnummer bigint,
    organisatie bigint NOT NULL,
    persoon bigint NOT NULL,
    version bigint,
    bronstatus character varying(255),
    CONSTRAINT deelnemer_bronstatus_check CHECK (((bronstatus)::text = ANY ((ARRAY['Geen'::character varying, 'Wachtrij'::character varying, 'WachtrijWelInBron'::character varying, 'InBehandeling'::character varying, 'InBehandelingWelInBron'::character varying, 'Goedgekeurd'::character varying, 'Afgekeurd'::character varying, 'AfgekeurdWelInBron'::character varying])::text[])))
);


ALTER TABLE public.deelnemer OWNER TO postgres;

--
-- Name: COLUMN deelnemer.lgf; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.deelnemer.lgf IS 'Leerling Gebonden Financiering geeft aan of de Commissie voor Indicatiestelling extra middelen heeft toegekend voor ondersteuning en begeleiding van de deelnemer met een bepaalde handicap of beperking. Ook bekend als het "rugzakje".';


--
-- Name: COLUMN deelnemer.uitsluitenvanfacturatie; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.deelnemer.uitsluitenvanfacturatie IS 'Zorgt dat de deelnemer geen facturen meer krijgt, totdat dit veld is uitgeschakeld.';


--
-- Name: deelnemerkenmerk; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.deelnemerkenmerk (
    begindatum date NOT NULL,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    deelnemer bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    kenmerk bigint NOT NULL,
    organisatie bigint NOT NULL,
    version bigint,
    toelichting oid
);


ALTER TABLE public.deelnemerkenmerk OWNER TO postgres;

--
-- Name: deelnemermatrix; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.deelnemermatrix (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    deelnemer bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    matrix bigint NOT NULL,
    meeteenheid bigint,
    organisatie bigint NOT NULL,
    version bigint
);


ALTER TABLE public.deelnemermatrix OWNER TO postgres;

--
-- Name: deelnemermedewerkergroepview; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.deelnemermedewerkergroepview (
    organisatie bigint NOT NULL,
    code character varying(100) NOT NULL,
    naam character varying(100) NOT NULL,
    omschrijving character varying(100) NOT NULL,
    type character varying(100) NOT NULL,
    voorletters character varying(100) NOT NULL,
    voornamen character varying(100) NOT NULL,
    voorvoegsel character varying(100) NOT NULL,
    id character varying(255) NOT NULL,
    CONSTRAINT deelnemermedewerkergroepview_type_check CHECK (((type)::text = ANY ((ARRAY['deelnemer'::character varying, 'medewerker'::character varying, 'groep'::character varying])::text[])))
);


ALTER TABLE public.deelnemermedewerkergroepview OWNER TO postgres;

--
-- Name: deelnemerpersoonlijkegroep; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.deelnemerpersoonlijkegroep (
    begindatum date NOT NULL,
    einddatum date NOT NULL,
    deelnemer bigint NOT NULL,
    groep bigint NOT NULL,
    organisatie bigint NOT NULL,
    id character varying(255) NOT NULL
);


ALTER TABLE public.deelnemerpersoonlijkegroep OWNER TO postgres;

--
-- Name: deelnemerresultaatversie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.deelnemerresultaatversie (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    deelnemer bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    resultaatstructuur bigint NOT NULL,
    versie bigint NOT NULL,
    version bigint
);


ALTER TABLE public.deelnemerresultaatversie OWNER TO postgres;

--
-- Name: deelnemertest; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.deelnemertest (
    afnamedatum date NOT NULL,
    gearchiveerd boolean NOT NULL,
    vertrouwelijk boolean NOT NULL,
    zorglijn integer,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    deelnemer bigint NOT NULL,
    groeptest bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    testdefinitie bigint NOT NULL,
    version bigint
);


ALTER TABLE public.deelnemertest OWNER TO postgres;

--
-- Name: deelnemertoetsbevriezing; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.deelnemertoetsbevriezing (
    gearchiveerd boolean NOT NULL,
    ingeleverd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    bevrorenpogingen bigint NOT NULL,
    deelnemer bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    toets bigint NOT NULL,
    version bigint
);


ALTER TABLE public.deelnemertoetsbevriezing OWNER TO postgres;

--
-- Name: deelnemerzoekopdracht; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.deelnemerzoekopdracht (
    gearchiveerd boolean NOT NULL,
    kolommenvastzetten boolean NOT NULL,
    peildatumvastzetten boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    account bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    omschrijving character varying(200) NOT NULL,
    filter oid
);


ALTER TABLE public.deelnemerzoekopdracht OWNER TO postgres;

--
-- Name: deelnemerzoekopdrachtrecht; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.deelnemerzoekopdrachtrecht (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    rol bigint NOT NULL,
    version bigint,
    zoekopdracht bigint NOT NULL
);


ALTER TABLE public.deelnemerzoekopdrachtrecht OWNER TO postgres;

--
-- Name: documentcategorie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.documentcategorie (
    actief boolean NOT NULL,
    beperkautorisatie boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    code character varying(10) NOT NULL,
    naam character varying(100) NOT NULL
);


ALTER TABLE public.documentcategorie OWNER TO postgres;

--
-- Name: documenttemplate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.documenttemplate (
    actief boolean NOT NULL,
    beperkautorisatie boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    kopiebijcontext boolean NOT NULL,
    sectieperelement boolean NOT NULL,
    valid boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    documenttype bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    taxonomie bigint,
    version bigint,
    dtype character varying(31) NOT NULL,
    bestandsnaam character varying(200) NOT NULL,
    omschrijving character varying(200) NOT NULL,
    categorie character varying(255),
    context character varying(255) NOT NULL,
    examendocumenttype character varying(255),
    forceertype character varying(255),
    type character varying(255),
    zzzbestand oid,
    CONSTRAINT documenttemplate_categorie_check CHECK (((categorie)::text = ANY ((ARRAY['Intake'::character varying, 'Identiteit'::character varying, 'Verbintenis'::character varying, 'Brieven'::character varying, 'Resultaten'::character varying, 'Examens'::character varying, 'Onderwijsovereenkomst'::character varying, 'BPVOvereenkomst'::character varying, 'Overig'::character varying])::text[]))),
    CONSTRAINT documenttemplate_context_check CHECK (((context)::text = ANY ((ARRAY['Verbintenis'::character varying, 'BPVVerbintenis'::character varying, 'Groep'::character varying, 'Examendeelname'::character varying, 'Opleiding'::character varying, 'Debiteur'::character varying, 'Factuur'::character varying])::text[]))),
    CONSTRAINT documenttemplate_dtype_check CHECK (((dtype)::text = ANY ((ARRAY['DocumentTemplate'::character varying, 'OnderwijsDocumentTemplate'::character varying])::text[]))),
    CONSTRAINT documenttemplate_examendocumenttype_check CHECK (((examendocumenttype)::text = ANY ((ARRAY['Onderwijsovereenkomst'::character varying, 'BPVovereenkomst'::character varying, 'Diploma'::character varying, 'Cijferlijst'::character varying, 'Certificaat'::character varying])::text[]))),
    CONSTRAINT documenttemplate_forceertype_check CHECK (((forceertype)::text = ANY ((ARRAY['CSV'::character varying, 'RTF'::character varying, 'JRXML'::character varying, 'PDF'::character varying, 'XLS'::character varying, 'XLSX'::character varying, 'DOCX'::character varying, 'DOTX'::character varying, 'DOCM'::character varying, 'DOTM'::character varying, 'HTML'::character varying, 'ZIP'::character varying, 'XML'::character varying, 'XHTML'::character varying])::text[]))),
    CONSTRAINT documenttemplate_type_check CHECK (((type)::text = ANY ((ARRAY['CSV'::character varying, 'RTF'::character varying, 'JRXML'::character varying, 'PDF'::character varying, 'XLS'::character varying, 'XLSX'::character varying, 'DOCX'::character varying, 'DOTX'::character varying, 'DOCM'::character varying, 'DOTM'::character varying, 'HTML'::character varying, 'ZIP'::character varying, 'XML'::character varying, 'XHTML'::character varying])::text[])))
);


ALTER TABLE public.documenttemplate OWNER TO postgres;

--
-- Name: COLUMN documenttemplate.documenttype; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.documenttemplate.documenttype IS 'Het documenttype dat aan de gegenereerde documenten gekoppeld moet worden';


--
-- Name: COLUMN documenttemplate.forceertype; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.documenttemplate.forceertype IS 'Selecteer hier een andere waarde wanneer het niet gewenst is om het gegenereerde document in het orginele formaat te downloaden.';


--
-- Name: documenttemplaterecht; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.documenttemplaterecht (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    documentcategorie bigint,
    documenttemplate bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    rol bigint NOT NULL,
    version bigint,
    actionclassname character varying(200) NOT NULL
);


ALTER TABLE public.documenttemplaterecht OWNER TO postgres;

--
-- Name: documenttype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.documenttype (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    categorie bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    code character varying(10) NOT NULL,
    naam character varying(100) NOT NULL
);


ALTER TABLE public.documenttype OWNER TO postgres;

--
-- Name: edvcs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.edvcs (
    gearchiveerd boolean NOT NULL,
    "position" integer NOT NULL,
    visible boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    account bigint NOT NULL,
    id bigint NOT NULL,
    organisatie bigint NOT NULL,
    version bigint,
    headerid character varying(256) NOT NULL,
    panelid character varying(512) NOT NULL
);


ALTER TABLE public.edvcs OWNER TO postgres;

--
-- Name: eigenaartemplate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.eigenaartemplate (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    persoon bigint,
    version bigint,
    rol character varying(255) NOT NULL,
    CONSTRAINT eigenaartemplate_rol_check CHECK (((rol)::text = ANY ((ARRAY['EersteUitvoerende'::character varying, 'GeselecteerdePersoon'::character varying, 'Mentor'::character varying, 'Verantwoordelijke'::character varying])::text[])))
);


ALTER TABLE public.eigenaartemplate OWNER TO postgres;

--
-- Name: eventabonnementconfiguration; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.eventabonnementconfiguration (
    config_value integer,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    dtype character varying(31) NOT NULL,
    CONSTRAINT eventabonnementconfiguration_check CHECK ((((dtype)::text <> 'DeadlineEventAbonnementConf'::text) OR (config_value IS NOT NULL))),
    CONSTRAINT eventabonnementconfiguration_dtype_check CHECK (((dtype)::text = ANY ((ARRAY['DeadlineEventAbonnementConf'::character varying, 'VerzuimTaakEventAboConf'::character varying])::text[])))
);


ALTER TABLE public.eventabonnementconfiguration OWNER TO postgres;

--
-- Name: eventabonnementsetting; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.eventabonnementsetting (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    configuratie bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    persoon bigint,
    version bigint,
    dtype character varying(31) NOT NULL,
    eventclassname character varying(200) NOT NULL,
    transportclassname character varying(200) NOT NULL,
    type character varying(255) NOT NULL,
    waarde character varying(255) NOT NULL,
    CONSTRAINT eventabonnementsetting_dtype_check CHECK (((dtype)::text = ANY ((ARRAY['PersoonlijkAbonnementSetting'::character varying, 'GlobaalAbonnementSetting'::character varying])::text[]))),
    CONSTRAINT eventabonnementsetting_type_check CHECK (((type)::text = ANY ((ARRAY['Mentor'::character varying, 'Docent'::character varying, 'Uitvoerende'::character varying, 'Verantwoordelijke'::character varying, 'GeselecteerdeGroepen'::character varying, 'GeselecteerdeDeelnemers'::character varying, 'TaakGerelateerd'::character varying, 'SelfService'::character varying, 'ExterneOrganisatieContactpersoon'::character varying])::text[]))),
    CONSTRAINT eventabonnementsetting_waarde_check CHECK (((waarde)::text = ANY ((ARRAY['Uit'::character varying, 'Aan'::character varying, 'Verplicht'::character varying])::text[])))
);


ALTER TABLE public.eventabonnementsetting OWNER TO postgres;

--
-- Name: examendeelname; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.examendeelname (
    bekostigd boolean NOT NULL,
    datumuitslag date,
    examenjaar integer,
    examennummer integer,
    gearchiveerd boolean NOT NULL,
    gewijzigd boolean NOT NULL,
    meenemeninvolgendebronbatch boolean NOT NULL,
    tijdvak integer,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    brondatum timestamp(6) without time zone,
    datumlaatstestatusovergang timestamp(6) without time zone NOT NULL,
    examenstatus bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    verbintenis bigint NOT NULL,
    version bigint,
    examennummerprefix character varying(20),
    bronstatus character varying(255),
    CONSTRAINT examendeelname_bronstatus_check CHECK (((bronstatus)::text = ANY ((ARRAY['Geen'::character varying, 'Wachtrij'::character varying, 'WachtrijWelInBron'::character varying, 'InBehandeling'::character varying, 'InBehandelingWelInBron'::character varying, 'Goedgekeurd'::character varying, 'Afgekeurd'::character varying, 'AfgekeurdWelInBron'::character varying])::text[])))
);


ALTER TABLE public.examendeelname OWNER TO postgres;

--
-- Name: examenstatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.examenstatus (
    beginstatus boolean NOT NULL,
    criteriumbankcontrole boolean NOT NULL,
    eindstatus boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    geslaagd boolean NOT NULL,
    volgnummer integer NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    examenworkflow bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint,
    version bigint,
    naam character varying(50) NOT NULL
);


ALTER TABLE public.examenstatus OWNER TO postgres;

--
-- Name: examenstatusovergang; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.examenstatusovergang (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    datumtijd timestamp(6) without time zone NOT NULL,
    examendeelname bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    naarstatus bigint NOT NULL,
    organisatie bigint NOT NULL,
    vanstatus bigint,
    version bigint,
    opmerkingen character varying(4000)
);


ALTER TABLE public.examenstatusovergang OWNER TO postgres;

--
-- Name: examenworkflow; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.examenworkflow (
    gearchiveerd boolean NOT NULL,
    heefttijdvakken boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint,
    version bigint,
    naam character varying(30) NOT NULL
);


ALTER TABLE public.examenworkflow OWNER TO postgres;

--
-- Name: examenworkflowtax; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.examenworkflowtax (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    examenworkflow bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint,
    taxonomie bigint NOT NULL,
    version bigint
);


ALTER TABLE public.examenworkflowtax OWNER TO postgres;

--
-- Name: externeagenda; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.externeagenda (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    eigenaar_id bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    koppeling_id bigint NOT NULL,
    organisatie bigint NOT NULL,
    version bigint,
    naam character varying(50) NOT NULL,
    gebruikersnaam character varying(100),
    wachtwoord character varying(100)
);


ALTER TABLE public.externeagenda OWNER TO postgres;

--
-- Name: externeagendakoppeling; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.externeagendakoppeling (
    actief boolean NOT NULL,
    automatisch boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    geldigheidsduur integer NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    afspraaktype_id bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    locatie_id bigint,
    organisatie bigint NOT NULL,
    organisatieeenheid_id bigint NOT NULL,
    version bigint,
    dtype character varying(31) NOT NULL,
    eventfeedurlsuffix character varying(50),
    naam character varying(50) NOT NULL,
    applicationname character varying(100),
    metafeedurlbase character varying(200),
    CONSTRAINT externeagendakoppeling_check CHECK ((((dtype)::text <> 'GoogleCalendarKoppeling'::text) OR ((applicationname IS NOT NULL) AND (eventfeedurlsuffix IS NOT NULL) AND (metafeedurlbase IS NOT NULL)))),
    CONSTRAINT externeagendakoppeling_dtype_check CHECK (((dtype)::text = 'GoogleCalendarKoppeling'::text))
);


ALTER TABLE public.externeagendakoppeling OWNER TO postgres;

--
-- Name: externeorganisatie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.externeorganisatie (
    begindatum date NOT NULL,
    betalingstermijn integer,
    bpvbedrijf boolean NOT NULL,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    nietgeschiktvoorbpvdeelnemers boolean,
    nietgeschiktvoorbpvmatch boolean,
    nogcontroleren boolean,
    verzamelfacturen boolean NOT NULL,
    code character varying(6),
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    debiteurennummer bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    laatsteexportdatum timestamp(6) without time zone,
    ondertekeningbpvodoor bigint,
    organisatie bigint,
    soortexterneorganisatie bigint,
    version bigint,
    bankrekeningnummer character varying(11),
    factuurbetaalwijze character varying(30),
    dtype character varying(31) NOT NULL,
    verkortenaam character varying(50) NOT NULL,
    naam character varying(100) NOT NULL,
    controleresultaat character varying(255),
    onderwijssector character varying(255),
    omschrijving oid,
    toelichtingnietgeschiktvoorbpv oid,
    CONSTRAINT externeorganisatie_controleresultaat_check CHECK (((controleresultaat)::text = ANY ((ARRAY['ONBEKEND'::character varying, 'GELIJK'::character varying, 'VERSCHILLEND'::character varying])::text[]))),
    CONSTRAINT externeorganisatie_dtype_check CHECK (((dtype)::text = ANY ((ARRAY['ExterneOrganisatie'::character varying, 'Brin'::character varying])::text[]))),
    CONSTRAINT externeorganisatie_factuurbetaalwijze_check CHECK (((factuurbetaalwijze)::text = ANY ((ARRAY['OVERIG'::character varying, 'AUTOMATISCHE_INCASSO'::character varying, 'ACCEPTEMAIL'::character varying])::text[]))),
    CONSTRAINT externeorganisatie_onderwijssector_check CHECK (((onderwijssector)::text = ANY ((ARRAY['AK'::character varying, 'AMB'::character varying, 'AOC'::character varying, 'AOCV'::character varying, 'BAS'::character varying, 'BBAS'::character varying, 'BGRE'::character varying, 'BGCD'::character varying, 'BGCA'::character varying, 'BGTC'::character varying, 'BINS'::character varying, 'BSM'::character varying, 'BVOS'::character varying, 'CASO'::character varying, 'CDPO'::character varying, 'DOV'::character varying, 'EDU'::character varying, 'EDUV'::character varying, 'ERK'::character varying, 'EXA'::character varying, 'FAC'::character varying, 'GJI'::character varying, 'HAS'::character varying, 'HBOS'::character varying, 'ILOC'::character varying, 'ISWV'::character varying, 'IBR'::character varying, 'IEB'::character varying, 'JJI'::character varying, 'LOB'::character varying, 'LAOV'::character varying, 'LOA'::character varying, 'LOC'::character varying, 'NAUT'::character varying, 'PROS'::character varying, 'REC'::character varying, 'REFR'::character varying, 'RGN'::character varying, 'RGNE'::character varying, 'RGNS'::character varying, 'ROC'::character varying, 'ROCV'::character varying, 'RVC'::character varying, 'RVT'::character varying, 'SGM'::character varying, 'SWOP'::character varying, 'SWPO'::character varying, 'SBD'::character varying, 'SBAS'::character varying, 'SPEC'::character varying, 'SWVO'::character varying, 'TEC'::character varying, 'TVST'::character varying, 'TOE'::character varying, 'UNIV'::character varying, 'VAK'::character varying, 'VAKV'::character varying, 'VOS'::character varying, 'VST'::character varying, 'VSTS'::character varying, 'VSTZ'::character varying])::text[])))
);


ALTER TABLE public.externeorganisatie OWNER TO postgres;

--
-- Name: COLUMN externeorganisatie.betalingstermijn; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.externeorganisatie.betalingstermijn IS 'Specifieke betalingstermijn voor deze debiteur (in dagen).';


--
-- Name: COLUMN externeorganisatie.nietgeschiktvoorbpvmatch; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.externeorganisatie.nietgeschiktvoorbpvmatch IS 'Stage/BPV-plaatsen van dit bedrijf zijn niet bedoeld om mee te nemen in de matching procedure.';


--
-- Name: COLUMN externeorganisatie.verzamelfacturen; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.externeorganisatie.verzamelfacturen IS 'Geeft aan of dit bedrijf verzamelfacturen wil ontvangen voor meerdere deelnemers.';


--
-- Name: COLUMN externeorganisatie.ondertekeningbpvodoor; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.externeorganisatie.ondertekeningbpvodoor IS 'Geeft aan dat een andere organisatie (bijv. holding) verantwoordelijk is voor de ondertekening van BPV-overeenkomsten gesloten met deze organisatie.';


--
-- Name: externeorganisatiekenmerk; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.externeorganisatiekenmerk (
    begindatum date NOT NULL,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    externeorganisatie bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    kenmerk bigint NOT NULL,
    organisatie bigint NOT NULL,
    version bigint,
    toelichting oid
);


ALTER TABLE public.externeorganisatiekenmerk OWNER TO postgres;

--
-- Name: externeorganisatieopmerking; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.externeorganisatieopmerking (
    gearchiveerd boolean NOT NULL,
    tonenbijmatching boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    auteur bigint,
    datum timestamp(6) without time zone,
    externeorganisatie bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    opmerking oid NOT NULL
);


ALTER TABLE public.externeorganisatieopmerking OWNER TO postgres;

--
-- Name: externewaarneming; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.externewaarneming (
    beginlesuur integer,
    begintijd time(0) without time zone,
    datum date NOT NULL,
    eindlesuur integer,
    eindtijd time(0) without time zone,
    gearchiveerd boolean NOT NULL,
    verwerkt boolean,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    deelnemernummer bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    organisatienummer bigint,
    version bigint,
    lokaalcode character varying(10),
    roostercode character varying(10),
    waarnemingsoort character varying(255) NOT NULL
);


ALTER TABLE public.externewaarneming OWNER TO postgres;

--
-- Name: externpersoon; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.externpersoon (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    email character varying(255) NOT NULL
);


ALTER TABLE public.externpersoon OWNER TO postgres;

--
-- Name: extorgcontactgegeven; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.extorgcontactgegeven (
    gearchiveerd boolean NOT NULL,
    geheim boolean NOT NULL,
    volgorde integer NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    externeorganisatie bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint,
    soortcontactgegeven bigint,
    version bigint,
    contactgegeven character varying(60) NOT NULL
);


ALTER TABLE public.extorgcontactgegeven OWNER TO postgres;

--
-- Name: extorgcontactpersoon; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.extorgcontactpersoon (
    begindatum date NOT NULL,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    externeorganisatie bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    rol bigint,
    version bigint,
    emailadres character varying(60),
    mobiel character varying(60),
    telefoon character varying(60),
    naam character varying(80) NOT NULL,
    geslacht character varying(255) NOT NULL,
    CONSTRAINT extorgcontactpersoon_geslacht_check CHECK (((geslacht)::text = ANY ((ARRAY['Man'::character varying, 'Vrouw'::character varying, 'Onbekend'::character varying])::text[])))
);


ALTER TABLE public.extorgcontactpersoon OWNER TO postgres;

--
-- Name: extorgcontpersrol; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.extorgcontpersrol (
    actief boolean NOT NULL,
    contactpersoonbpv boolean,
    gearchiveerd boolean NOT NULL,
    praktijkopleiderbpv boolean,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    naam character varying(120) NOT NULL
);


ALTER TABLE public.extorgcontpersrol OWNER TO postgres;

--
-- Name: extorgpraktijkbegeleider; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.extorgpraktijkbegeleider (
    gearchiveerd boolean NOT NULL,
    laatstgebruiktemedewerker boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    externeorganisatie bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    medewerker bigint NOT NULL,
    organisatie bigint NOT NULL,
    version bigint
);


ALTER TABLE public.extorgpraktijkbegeleider OWNER TO postgres;

--
-- Name: fase; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fase (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint,
    version bigint,
    volgendefase bigint,
    code character varying(10) NOT NULL,
    naam character varying(50) NOT NULL,
    hoofdfase character varying(255) NOT NULL,
    CONSTRAINT fase_hoofdfase_check CHECK (((hoofdfase)::text = ANY ((ARRAY['PropBach'::character varying, 'Bachelor'::character varying, 'Propedeuse'::character varying, 'Master'::character varying, 'Vervolgopl'::character varying, 'Kandidaats'::character varying, 'Initieel'::character varying, 'AssDegree'::character varying])::text[])))
);


ALTER TABLE public.fase OWNER TO postgres;

--
-- Name: functie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.functie (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    code character varying(10) NOT NULL,
    naam character varying(100) NOT NULL
);


ALTER TABLE public.functie OWNER TO postgres;

--
-- Name: gebruiksmiddel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gebruiksmiddel (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    code character varying(10) NOT NULL,
    naam character varying(100) NOT NULL
);


ALTER TABLE public.gebruiksmiddel OWNER TO postgres;

--
-- Name: gedrag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gedrag (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint
);


ALTER TABLE public.gedrag OWNER TO postgres;

--
-- Name: gekoppeldetemplate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gekoppeldetemplate (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    medewerker bigint,
    organisatie bigint NOT NULL,
    rol bigint,
    trajecttemplate bigint NOT NULL,
    version bigint,
    koppelingsrol character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    CONSTRAINT gekoppeldetemplate_koppelingsrol_check CHECK (((koppelingsrol)::text = ANY ((ARRAY['UITVOERENDE'::character varying, 'VERANTWOORDELIJKE'::character varying])::text[]))),
    CONSTRAINT gekoppeldetemplate_type_check CHECK (((type)::text = ANY ((ARRAY['Mentor'::character varying, 'Rol'::character varying, 'Medewerker'::character varying])::text[])))
);


ALTER TABLE public.gekoppeldetemplate OWNER TO postgres;

--
-- Name: gemeente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gemeente (
    begindatum date NOT NULL,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    nieuwegemeente bigint,
    version bigint,
    code character varying(10) NOT NULL,
    naam character varying(100) NOT NULL
);


ALTER TABLE public.gemeente OWNER TO postgres;

--
-- Name: gespreksamenvattingtemplate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gespreksamenvattingtemplate (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    naam character varying(30) NOT NULL,
    template oid NOT NULL
);


ALTER TABLE public.gespreksamenvattingtemplate OWNER TO postgres;

--
-- Name: gespreksamenvattingzin; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gespreksamenvattingzin (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    zin character varying(1024) NOT NULL
);


ALTER TABLE public.gespreksamenvattingzin OWNER TO postgres;

--
-- Name: gespreksoort; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gespreksoort (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    oudersuitnodigen boolean NOT NULL,
    standaardverslagversturen boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    afspraaktype bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    locatie bigint,
    organisatie bigint NOT NULL,
    organisatieeenheid bigint NOT NULL,
    version bigint,
    naam character varying(41) NOT NULL,
    standaardstatus character varying(255),
    verslagtemplate oid,
    CONSTRAINT gespreksoort_standaardstatus_check CHECK (((standaardstatus)::text = ANY ((ARRAY['Inplannen'::character varying, 'Uitvoeren'::character varying, 'Bespreken'::character varying, 'Voltooid'::character varying, 'Geannuleerd'::character varying])::text[])))
);


ALTER TABLE public.gespreksoort OWNER TO postgres;

--
-- Name: groep; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.groep (
    begindatum date NOT NULL,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    gedeeld boolean NOT NULL,
    leerjaar integer,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    deelnemer bigint,
    groepstype bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    locatie bigint,
    medewerker bigint,
    organisatie bigint NOT NULL,
    organisatieeenheid bigint NOT NULL,
    version bigint,
    code character varying(20) NOT NULL,
    dtype character varying(31) NOT NULL,
    naam character varying(100) NOT NULL,
    omschrijving character varying(240) NOT NULL,
    CONSTRAINT groep_dtype_check CHECK (((dtype)::text = ANY ((ARRAY['Groep'::character varying, 'PersoonlijkeGroep'::character varying])::text[])))
);


ALTER TABLE public.groep OWNER TO postgres;

--
-- Name: groepdocent; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.groepdocent (
    begindatum date NOT NULL,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    groep bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    medewerker bigint NOT NULL,
    organisatie bigint NOT NULL,
    version bigint
);


ALTER TABLE public.groepdocent OWNER TO postgres;

--
-- Name: groepmentor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.groepmentor (
    begindatum date NOT NULL,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    groep bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    medewerker bigint NOT NULL,
    organisatie bigint NOT NULL,
    version bigint
);


ALTER TABLE public.groepmentor OWNER TO postgres;

--
-- Name: groepresultaatfilterinst; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.groepresultaatfilterinst (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    cohort bigint NOT NULL,
    filterinstelling bigint NOT NULL,
    groep bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    onderwijsproduct bigint,
    organisatie bigint NOT NULL,
    version bigint
);


ALTER TABLE public.groepresultaatfilterinst OWNER TO postgres;

--
-- Name: groepsdeelname; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.groepsdeelname (
    begindatum date NOT NULL,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    jarenpraktijkonderwijs integer,
    leerjaar integer,
    lwoo boolean,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    bevatgroep bigint,
    contract bigint,
    deelnemer bigint,
    fase bigint,
    groep bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    verbintenis bigint,
    version bigint,
    dtype character varying(31) NOT NULL,
    inschrijvingsvorm character varying(255),
    opleidingsvorm character varying(255),
    CONSTRAINT groepsdeelname_check CHECK ((((dtype)::text <> 'Plaatsing'::text) OR (lwoo IS NOT NULL))),
    CONSTRAINT groepsdeelname_dtype_check CHECK (((dtype)::text = ANY ((ARRAY['Groepsdeelname'::character varying, 'Plaatsing'::character varying, 'PersoonlijkeGroepDeelnemer'::character varying])::text[]))),
    CONSTRAINT groepsdeelname_inschrijvingsvorm_check CHECK (((inschrijvingsvorm)::text = ANY ((ARRAY['Extraneus'::character varying, 'Student'::character varying])::text[]))),
    CONSTRAINT groepsdeelname_opleidingsvorm_check CHECK (((opleidingsvorm)::text = ANY ((ARRAY['Voltijd'::character varying, 'Deeltijd'::character varying, 'Duaal'::character varying])::text[])))
);


ALTER TABLE public.groepsdeelname OWNER TO postgres;

--
-- Name: groepstype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.groepstype (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    plaatsingsgroep boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    code character varying(10) NOT NULL,
    naam character varying(100) NOT NULL
);


ALTER TABLE public.groepstype OWNER TO postgres;

--
-- Name: groeptest; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.groeptest (
    afnamedatum date,
    gearchiveerd boolean NOT NULL,
    tonen boolean NOT NULL,
    vertrouwelijk boolean NOT NULL,
    zorglijn integer,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    groep bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    testdefinitie bigint NOT NULL,
    version bigint
);


ALTER TABLE public.groeptest OWNER TO postgres;

--
-- Name: grouppropertysetting; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grouppropertysetting (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    account bigint NOT NULL,
    id bigint NOT NULL,
    organisatie bigint NOT NULL,
    version bigint,
    property character varying(256),
    panelid character varying(512) NOT NULL
);


ALTER TABLE public.grouppropertysetting OWNER TO postgres;

--
-- Name: herhalendeabsentiemelding; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.herhalendeabsentiemelding (
    begindatum date NOT NULL,
    einddatum date NOT NULL,
    gearchiveerd boolean NOT NULL,
    weekcyclus integer NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint
);


ALTER TABLE public.herhalendeabsentiemelding OWNER TO postgres;

--
-- Name: herhalendeafspraak; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.herhalendeafspraak (
    begindatum date NOT NULL,
    cyclus integer NOT NULL,
    dagen integer NOT NULL,
    einddatum date,
    gearchiveerd boolean NOT NULL,
    maxherhalingen integer,
    skip integer NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    type character varying(255) NOT NULL,
    CONSTRAINT herhalendeafspraak_type_check CHECK (((type)::text = ANY ((ARRAY['DAGELIJKS'::character varying, 'WEKELIJKS'::character varying, 'MAANDELIJKS'::character varying])::text[])))
);


ALTER TABLE public.herhalendeafspraak OWNER TO postgres;

--
-- Name: hibernate_sequence; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hibernate_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.hibernate_sequence OWNER TO postgres;

--
-- Name: hulpmiddel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hulpmiddel (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint,
    version bigint,
    code character varying(10) NOT NULL,
    naam character varying(50) NOT NULL
);


ALTER TABLE public.hulpmiddel OWNER TO postgres;

--
-- Name: ibgverzuimdag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ibgverzuimdag (
    gearchiveerd boolean NOT NULL,
    heledag boolean NOT NULL,
    lesuur1 boolean,
    lesuur10 boolean,
    lesuur11 boolean,
    lesuur12 boolean,
    lesuur2 boolean,
    lesuur3 boolean,
    lesuur4 boolean,
    lesuur5 boolean,
    lesuur6 boolean,
    lesuur7 boolean,
    lesuur8 boolean,
    lesuur9 boolean,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    datum timestamp(6) without time zone NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    verzuimmelding bigint NOT NULL
);


ALTER TABLE public.ibgverzuimdag OWNER TO postgres;

--
-- Name: ibgverzuimmelding; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ibgverzuimmelding (
    actieondernemen boolean,
    allelessengemist boolean,
    begindatum date NOT NULL,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    meldingsnummer numeric(38,0) NOT NULL,
    verzonden boolean NOT NULL,
    verzuimdaggespecificeerd boolean,
    netnummermelder character varying(5),
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    begindatumselectie timestamp(6) without time zone,
    id bigint NOT NULL,
    idinoudpakket bigint,
    laatstemutatiedatum timestamp(6) without time zone,
    laatstemutatietijd timestamp(6) without time zone,
    locatie bigint,
    melddatumtijd timestamp(6) without time zone,
    organisatie bigint NOT NULL,
    verbintenis bigint NOT NULL,
    version bigint,
    abonneenummermelder character varying(10),
    functiemelder character varying(60),
    aanduidingcontactpersoon character varying(100) NOT NULL,
    emailadresmelder character varying(100) NOT NULL,
    toelichting character varying(100),
    vermoedelijkereden character varying(200) NOT NULL,
    ccemailontvanger character varying(255),
    status character varying(255),
    verzuimsoort character varying(255) NOT NULL,
    toelichtingactiegewenst oid,
    toelichtingondernomenactie oid,
    CONSTRAINT ibgverzuimmelding_ccemailontvanger_check CHECK (((ccemailontvanger)::text = ANY ((ARRAY['Contactpersoon'::character varying, 'Behandelaar'::character varying, 'Beide'::character varying])::text[]))),
    CONSTRAINT ibgverzuimmelding_status_check CHECK (((status)::text = ANY ((ARRAY['W'::character varying, 'R'::character varying, 'B'::character varying, 'G'::character varying, 'K'::character varying, 'D'::character varying, 'I'::character varying])::text[]))),
    CONSTRAINT ibgverzuimmelding_verzuimsoort_check CHECK (((verzuimsoort)::text = ANY ((ARRAY['V1'::character varying, 'V2'::character varying, 'V3'::character varying, 'V4'::character varying, 'RMC'::character varying, 'L'::character varying, 'LRV'::character varying, 'O'::character varying])::text[])))
);


ALTER TABLE public.ibgverzuimmelding OWNER TO postgres;

--
-- Name: incident; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.incident (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    deelnemer bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    consequenties oid
);


ALTER TABLE public.incident OWNER TO postgres;

--
-- Name: incidentcategorie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.incidentcategorie (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint,
    version bigint,
    code character varying(10) NOT NULL,
    naam character varying(50) NOT NULL,
    irisvoorval character varying(255),
    CONSTRAINT incidentcategorie_irisvoorval_check CHECK (((irisvoorval)::text = ANY ((ARRAY['VerbaalGeweld'::character varying, 'Bedreiging'::character varying, 'FysiekGeweld'::character varying, 'GrovePesterijen'::character varying, 'Pesterijen'::character varying, 'Afpersing'::character varying, 'ValseBeschuldiging'::character varying, 'Groepsknokpartij'::character varying, 'SeksueleIntimidatie'::character varying, 'SeksueelMisbruik'::character varying, 'Loverboygirl'::character varying, 'Ordeverstoring'::character varying, 'OnwaarheidSpreken'::character varying, 'HangenSamenscholen'::character varying, 'Vernieling'::character varying, 'OnbevoegdAanwezig'::character varying, 'Diefstal'::character varying, 'Heling'::character varying, 'Fraude'::character varying, 'Inbraak'::character varying, 'Brandstichting'::character varying, 'Bommelding'::character varying, 'Wapenbezit'::character varying, 'Wapengebruik'::character varying, 'Wapenverkoop'::character varying, 'Drugsbezit'::character varying, 'Drugsgebruik'::character varying, 'Drugsverkoop'::character varying, 'Alcoholgebruik'::character varying, 'Tabaksgebruik'::character varying, 'Energiedrank'::character varying, 'Vuurwerk'::character varying, 'OnacceptabeleKleding'::character varying, 'Gezondheid'::character varying, 'Ongeval'::character varying, 'Anders'::character varying])::text[])))
);


ALTER TABLE public.incidentcategorie OWNER TO postgres;

--
-- Name: inloopcollege; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inloopcollege (
    gearchiveerd boolean NOT NULL,
    heleherhaling boolean NOT NULL,
    inschrijfbegindatum date NOT NULL,
    inschrijfeinddatum date NOT NULL,
    maxdeelnemers integer,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    omschrijving character varying(100) NOT NULL,
    opmerking oid
);


ALTER TABLE public.inloopcollege OWNER TO postgres;

--
-- Name: inloopcollegegroep; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inloopcollegegroep (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    groep bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    inloopcollege bigint NOT NULL,
    organisatie bigint NOT NULL,
    version bigint
);


ALTER TABLE public.inloopcollegegroep OWNER TO postgres;

--
-- Name: inloopcollegeopleiding; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inloopcollegeopleiding (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    inloopcollege bigint NOT NULL,
    opleiding bigint NOT NULL,
    organisatie bigint NOT NULL,
    version bigint
);


ALTER TABLE public.inloopcollegeopleiding OWNER TO postgres;

--
-- Name: inschrijvingsverzoek; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inschrijvingsverzoek (
    betaald boolean NOT NULL,
    betalingtermijnen boolean,
    duplicaat boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    herinschrijving boolean NOT NULL,
    toestemmingsverklaring boolean,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    betalingdatum timestamp(6) without time zone,
    gbaverificatiebrin bigint,
    gbaverificatiedatum timestamp(6) without time zone,
    id bigint NOT NULL,
    idinoudpakket bigint,
    instroommoment bigint,
    lotingstatusdatum timestamp(6) without time zone,
    organisatie bigint NOT NULL,
    plaatsing bigint,
    studielinkbericht bigint NOT NULL,
    verbintenis bigint,
    version bigint,
    gbaverificatiedocumentnummer character varying(15),
    gbaverificatiedocument character varying(30),
    gbaverificatiedoormedewerker character varying(35),
    gbaverificatieopmerking character varying(1000),
    aanvullendeeisenstatus character varying(255) NOT NULL,
    betaalwijze character varying(255),
    betaler character varying(255),
    deficientiestatus character varying(255),
    eerstejaars character varying(255) NOT NULL,
    gbaverificatiestatus character varying(255) NOT NULL,
    lotingstatus character varying(255),
    lotingvorm character varying(255),
    status character varying(255) NOT NULL,
    taaltoetsstatus character varying(255) NOT NULL,
    werkzaamhedenstatus character varying(255) NOT NULL,
    CONSTRAINT inschrijvingsverzoek_aanvullendeeisenstatus_check CHECK (((aanvullendeeisenstatus)::text = ANY ((ARRAY['NVT'::character varying, 'Open'::character varying, 'Afgewezen'::character varying, 'GeselGeslgd'::character varying])::text[]))),
    CONSTRAINT inschrijvingsverzoek_betaalwijze_check CHECK (((betaalwijze)::text = ANY ((ARRAY['Acceptgiro'::character varying, 'MachtAfdrInst'::character varying, 'MachtAfdrStud'::character varying, 'BuitlndsReknr'::character varying, 'Anders'::character varying, 'DigBetalen'::character varying, 'DigMachtiging'::character varying])::text[]))),
    CONSTRAINT inschrijvingsverzoek_betaler_check CHECK (((betaler)::text = ANY ((ARRAY['Ander'::character varying, 'Ouders'::character varying, 'Zelf'::character varying, 'Elders'::character varying, 'EerdDoorgegvn'::character varying])::text[]))),
    CONSTRAINT inschrijvingsverzoek_deficientiestatus_check CHECK (((deficientiestatus)::text = ANY ((ARRAY['DefInst'::character varying, 'DefIB'::character varying, 'NogNietBep'::character varying, 'Sufficiënt'::character varying, 'NietDefIB'::character varying, 'VoorlNietDefIB'::character varying, 'VoorlNietDefInst'::character varying])::text[]))),
    CONSTRAINT inschrijvingsverzoek_eerstejaars_check CHECK (((eerstejaars)::text = ANY ((ARRAY['NVT'::character varying, 'Geaccepteerd'::character varying, 'NietGeaccepteerd'::character varying])::text[]))),
    CONSTRAINT inschrijvingsverzoek_gbaverificatiestatus_check CHECK (((gbaverificatiestatus)::text = ANY ((ARRAY['Afmelden'::character varying, 'DecentrlGeverifrdInst'::character varying, 'NietGeverifrdInst'::character varying, 'DecentrlGeverifrdIB'::character varying, 'CentrlGeverifrd'::character varying, 'InBewerking'::character varying, 'GeenGBAAdres'::character varying, 'CentrlGeidentificrd'::character varying, 'NietGeverifieerd'::character varying])::text[]))),
    CONSTRAINT inschrijvingsverzoek_lotingstatus_check CHECK (((lotingstatus)::text = ANY ((ARRAY['Ingeloot'::character varying, 'CentrUitgeloot'::character varying, 'DecentrUitgeloot'::character varying, 'DecentrIngeloot'::character varying, 'VoorlPlaatsbewijs'::character varying, 'OnderVoorbIngel'::character varying])::text[]))),
    CONSTRAINT inschrijvingsverzoek_lotingvorm_check CHECK (((lotingvorm)::text = ANY ((ARRAY['DecentrLoting'::character varying, 'CentrLoting'::character varying, 'GeenLoting'::character varying])::text[]))),
    CONSTRAINT inschrijvingsverzoek_status_check CHECK (((status)::text = ANY ((ARRAY['AanmeldVervolg'::character varying, 'Inschrijving'::character varying, 'GeannlIngetrk'::character varying, 'Uitgeschreven'::character varying, 'StudieStaken'::character varying, 'Afgewezen'::character varying, 'VerzoekInschr'::character varying])::text[]))),
    CONSTRAINT inschrijvingsverzoek_taaltoetsstatus_check CHECK (((taaltoetsstatus)::text = ANY ((ARRAY['NVT'::character varying, 'Open'::character varying, 'Afgewezen'::character varying, 'GeselGeslgdInst'::character varying, 'GeselGeslgdIB'::character varying])::text[]))),
    CONSTRAINT inschrijvingsverzoek_werkzaamhedenstatus_check CHECK (((werkzaamhedenstatus)::text = ANY ((ARRAY['NVT'::character varying, 'Open'::character varying, 'Afgewezen'::character varying, 'GeselGeslgd'::character varying])::text[])))
);


ALTER TABLE public.inschrijvingsverzoek OWNER TO postgres;

--
-- Name: instellingsequence; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instellingsequence (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    maximum bigint NOT NULL,
    organisatie bigint NOT NULL,
    startwaarde bigint NOT NULL,
    version bigint,
    naam character varying(255) NOT NULL
);


ALTER TABLE public.instellingsequence OWNER TO postgres;

--
-- Name: instellingslogo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instellingslogo (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    bijlage bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint
);


ALTER TABLE public.instellingslogo OWNER TO postgres;

--
-- Name: instroommoment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instroommoment (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    code character varying(10) NOT NULL,
    naam character varying(100) NOT NULL
);


ALTER TABLE public.instroommoment OWNER TO postgres;

--
-- Name: intakegesprek; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.intakegesprek (
    gearchiveerd boolean NOT NULL,
    gewenstebegindatum date,
    gewensteeinddatum date,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    datumtijd timestamp(6) without time zone,
    gewenstebpv bigint,
    gewenstegroep bigint,
    gewenstelocatie bigint,
    gewensteopleiding bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    intaker bigint,
    locatie bigint,
    organisatie bigint NOT NULL,
    organisatieeenheid bigint NOT NULL,
    uitkomstintakegesprek bigint,
    verbintenis bigint NOT NULL,
    version bigint,
    contactpersoonwerkgever character varying(100),
    naamwerkgever character varying(100),
    plaatswerkgever character varying(100),
    intakeroverig character varying(255),
    kamer character varying(255),
    status character varying(255) NOT NULL,
    opmerking oid,
    CONSTRAINT intakegesprek_status_check CHECK (((status)::text = ANY ((ARRAY['NogNietGepland'::character varying, 'Uitvoeren'::character varying, 'Uitgevoerd'::character varying, 'Geannuleerd'::character varying])::text[])))
);


ALTER TABLE public.intakegesprek OWNER TO postgres;

--
-- Name: irisbetrokkene; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.irisbetrokkene (
    gearchiveerd boolean NOT NULL,
    letsel boolean NOT NULL,
    rolbijincidentcode integer,
    rolopschoolcode integer NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    incident bigint,
    irisincident bigint NOT NULL,
    medewerker bigint,
    organisatie bigint NOT NULL,
    version bigint,
    ingevoerdgeslacht character varying(255),
    ingevoerdenaam character varying(255),
    toelichting character varying(255),
    CONSTRAINT irisbetrokkene_ingevoerdgeslacht_check CHECK (((ingevoerdgeslacht)::text = ANY ((ARRAY['Man'::character varying, 'Vrouw'::character varying, 'Onbekend'::character varying])::text[])))
);


ALTER TABLE public.irisbetrokkene OWNER TO postgres;

--
-- Name: irisbetrokkeneafhandeling; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.irisbetrokkeneafhandeling (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    betrokkene bigint NOT NULL,
    id bigint NOT NULL,
    version bigint,
    afhandeling character varying(255) NOT NULL,
    CONSTRAINT irisbetrokkeneafhandeling_afhandeling_check CHECK (((afhandeling)::text = ANY ((ARRAY['Leraar'::character varying, 'Ouders'::character varying, 'SociaalEmotioneleExpertise'::character varying, 'ExpertiseGedragsverbetering'::character varying, 'Nazorg'::character varying, 'Waarschuwing'::character varying, 'OntzeggingLes'::character varying, 'OntzeggingSchool'::character varying, 'SchoolTaakStraf'::character varying, 'VerliesVanPrivilege'::character varying, 'NablijvenTijdInhalen'::character varying, 'Timeout'::character varying, 'Schorsing'::character varying, 'AndereSchool'::character varying, 'AansprakelijkStellen'::character varying, 'Vertrouwenspersoon'::character varying, 'ZAT'::character varying, 'Coordinator'::character varying, 'Collegiaaloverleg'::character varying, 'Scholing'::character varying, 'SamenwerkingAndereSchool'::character varying, 'Ehbo'::character varying, 'Spoedeisendehulp'::character varying, 'OverigMedisch'::character varying, 'Jeugdzorg'::character varying, 'Vertrouwensinspecteur'::character varying, 'Maatschappelijkwerk'::character varying, 'Leerlplichtambtenaar'::character varying, 'Wijkagent'::character varying, 'Alarmnummer'::character varying, 'Slachtofferhulp'::character varying, 'Schadeexpert'::character varying, 'Aangifte'::character varying, 'Prosociaalgedrag'::character varying, 'Mediator'::character varying, 'Pleinwacht'::character varying, 'Streetwatcher'::character varying, 'Anders'::character varying])::text[])))
);


ALTER TABLE public.irisbetrokkeneafhandeling OWNER TO postgres;

--
-- Name: irisbetrokkenemotief; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.irisbetrokkenemotief (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    betrokkene bigint NOT NULL,
    id bigint NOT NULL,
    version bigint,
    motief character varying(255) NOT NULL,
    CONSTRAINT irisbetrokkenemotief_motief_check CHECK (((motief)::text = ANY ((ARRAY['Persoonskenmerken'::character varying, 'Onrechtmatigbehandeld'::character varying, 'Agressie'::character varying, 'Langdurigconflict'::character varying, 'Problematischegezinskenmerken'::character varying, 'Schoolproblemen'::character varying, 'Schoolprestaties'::character varying, 'Socialeisolatie'::character varying, 'Groepsvorming'::character varying, 'Problematischewijk'::character varying, 'Seksuelegeaardheid'::character varying, 'Geloof'::character varying, 'Beperking'::character varying, 'Rascisme'::character varying, 'Cultureleverschillen'::character varying, 'Eerwraak'::character varying, 'Geldelijkgewin'::character varying, 'Onduidelijk'::character varying, 'Anders'::character varying])::text[])))
);


ALTER TABLE public.irisbetrokkenemotief OWNER TO postgres;

--
-- Name: irisincident; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.irisincident (
    afgerond boolean NOT NULL,
    begindatum date NOT NULL,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    onzeker boolean NOT NULL,
    vertrouwelijk boolean NOT NULL,
    zorglijn integer,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    auteur bigint NOT NULL,
    categorie bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    organisatieeenheid_id bigint,
    version bigint,
    titel character varying(50) NOT NULL,
    dagdeel character varying(255),
    irisincidentnummer character varying(255),
    kleur character varying(255) NOT NULL,
    tijdtype character varying(255) NOT NULL,
    tijdstip character varying(255),
    toelichting oid,
    CONSTRAINT irisincident_dagdeel_check CHECK (((dagdeel)::text = ANY ((ARRAY['VOOR_SCHOOLTIJD'::character varying, 'LESUUR_OCHTEND'::character varying, 'OCHTENDPAUZE'::character varying, 'LUNCHPAUZE'::character varying, 'MIDDAGPAUZE'::character varying, 'LESUUR_MIDDAG'::character varying, 'NA_SCHOOLTIJD'::character varying])::text[]))),
    CONSTRAINT irisincident_kleur_check CHECK (((kleur)::text = ANY ((ARRAY['Rood'::character varying, 'Oranje'::character varying, 'Groen'::character varying, 'Wit'::character varying, 'Grijs'::character varying])::text[]))),
    CONSTRAINT irisincident_tijdtype_check CHECK (((tijdtype)::text = ANY ((ARRAY['TIJDSTIP'::character varying, 'PERIODE'::character varying])::text[])))
);


ALTER TABLE public.irisincident OWNER TO postgres;

--
-- Name: irisincidentlocatie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.irisincidentlocatie (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    incident bigint NOT NULL,
    version bigint,
    locatie character varying(255) NOT NULL,
    CONSTRAINT irisincidentlocatie_locatie_check CHECK (((locatie)::text = ANY ((ARRAY['HalEntree'::character varying, 'ConciergeruimteReceptie'::character varying, 'Klas'::character varying, 'Lokaal'::character varying, 'Aula'::character varying, 'Gangen'::character varying, 'Trappen'::character varying, 'Lift'::character varying, 'KantineOverblijfruimte'::character varying, 'Toiletten'::character varying, 'Kluisjes'::character varying, 'Openleercentrum'::character varying, 'Bibliotheek'::character varying, 'ComputerlokaalMediatheek'::character varying, 'Administratieruimte'::character varying, 'Kantoor'::character varying, 'LerarenDocentenruimte'::character varying, 'Magazijn'::character varying, 'Kleedkamer'::character varying, 'GymSportzaal'::character varying, 'Schoolplein'::character varying, 'Fietsenstalling'::character varying, 'Parkeerterrein'::character varying, 'DeurenRamen'::character varying, 'BuitenmurenGevels'::character varying, 'Dak'::character varying, 'Straat'::character varying, 'Sportveld'::character varying, 'Stageplek'::character varying, 'ThuisSlachtoffers'::character varying, 'ThuisDaders'::character varying, 'VanNaarSchool'::character varying, 'Bus'::character varying, 'Anders'::character varying])::text[])))
);


ALTER TABLE public.irisincidentlocatie OWNER TO postgres;

--
-- Name: irisincidentvoorwerp; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.irisincidentvoorwerp (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    incident bigint NOT NULL,
    version bigint,
    voorwerp character varying(255) NOT NULL,
    CONSTRAINT irisincidentvoorwerp_voorwerp_check CHECK (((voorwerp)::text = ANY ((ARRAY['Steekwapens'::character varying, 'Vuurwapens'::character varying, 'SlagStootwapens'::character varying, 'ImitatieVuurwapens'::character varying, 'Overigegebruiksvoorwerpen'::character varying, 'ViaInternetOpSchool'::character varying, 'ViaInternet'::character varying, 'ViaMobieleTelefoon'::character varying, 'AndereDigitaleDiensten'::character varying, 'Anders'::character varying])::text[])))
);


ALTER TABLE public.irisincidentvoorwerp OWNER TO postgres;

--
-- Name: iriskoppelingkey; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.iriskoppelingkey (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    privatekeyinbytes oid NOT NULL,
    publickeyinbytes oid NOT NULL
);


ALTER TABLE public.iriskoppelingkey OWNER TO postgres;

--
-- Name: kenmerk; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kenmerk (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    categorie bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    code character varying(10) NOT NULL,
    naam character varying(100) NOT NULL
);


ALTER TABLE public.kenmerk OWNER TO postgres;

--
-- Name: kenmerkcategorie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kenmerkcategorie (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    code character varying(10) NOT NULL,
    naam character varying(100) NOT NULL
);


ALTER TABLE public.kenmerkcategorie OWNER TO postgres;

--
-- Name: land; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.land (
    begindatum date NOT NULL,
    code character varying(4) NOT NULL,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    isocode character varying(2),
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    version bigint,
    naam character varying(100) NOT NULL
);


ALTER TABLE public.land OWNER TO postgres;

--
-- Name: leerpuntcomponent; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.leerpuntcomponent (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    competentiecomponent bigint NOT NULL,
    id bigint NOT NULL,
    leerpunt bigint NOT NULL,
    version bigint
);


ALTER TABLE public.leerpuntcomponent OWNER TO postgres;

--
-- Name: leerpuntvaardigheid; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.leerpuntvaardigheid (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    leerpunt bigint NOT NULL,
    vaardigheid bigint NOT NULL,
    version bigint
);


ALTER TABLE public.leerpuntvaardigheid OWNER TO postgres;

--
-- Name: leerstijl; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.leerstijl (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    code character varying(10) NOT NULL,
    naam character varying(100) NOT NULL
);


ALTER TABLE public.leerstijl OWNER TO postgres;

--
-- Name: lesdagindeling; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lesdagindeling (
    dag character varying(2) NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    lesweekindeling bigint NOT NULL,
    organisatie bigint NOT NULL,
    version bigint
);


ALTER TABLE public.lesdagindeling OWNER TO postgres;

--
-- Name: lesuurindeling; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lesuurindeling (
    begintijd time(0) without time zone NOT NULL,
    eindtijd time(0) without time zone NOT NULL,
    gearchiveerd boolean NOT NULL,
    lesuur integer NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    lesdagindeling bigint NOT NULL,
    organisatie bigint NOT NULL,
    version bigint
);


ALTER TABLE public.lesuurindeling OWNER TO postgres;

--
-- Name: lesweekindeling; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lesweekindeling (
    actief boolean,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    naam character varying(25) NOT NULL,
    omschrijving character varying(60)
);


ALTER TABLE public.lesweekindeling OWNER TO postgres;

--
-- Name: lesweekindelingorgloc; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lesweekindelingorgloc (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    lesweekindeling bigint NOT NULL,
    locatie bigint,
    organisatie bigint NOT NULL,
    organisatieeenheid bigint NOT NULL,
    version bigint
);


ALTER TABLE public.lesweekindelingorgloc OWNER TO postgres;

--
-- Name: locatie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.locatie (
    begindatum date NOT NULL,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    code bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    afkorting character varying(10) NOT NULL,
    naam character varying(100) NOT NULL
);


ALTER TABLE public.locatie OWNER TO postgres;

--
-- Name: locatiecontactgegeven; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.locatiecontactgegeven (
    gearchiveerd boolean NOT NULL,
    geheim boolean NOT NULL,
    volgorde integer NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    locatie bigint NOT NULL,
    organisatie bigint NOT NULL,
    soortcontactgegeven bigint,
    version bigint,
    contactgegeven character varying(60) NOT NULL
);


ALTER TABLE public.locatiecontactgegeven OWNER TO postgres;

--
-- Name: maatregel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.maatregel (
    actief boolean NOT NULL,
    automatischemaatregeltonen boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    locatie bigint,
    organisatie bigint NOT NULL,
    organisatieeenheid bigint NOT NULL,
    version bigint,
    omschrijving character varying(50) NOT NULL
);


ALTER TABLE public.maatregel OWNER TO postgres;

--
-- Name: maatregeltoekenning; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.maatregeltoekenning (
    automatischtoegekend boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    nagekomen boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    deelnemer bigint NOT NULL,
    eigenaardeelnemer bigint,
    eigenaarmedewerker bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    maatregel bigint NOT NULL,
    maatregeldatum timestamp(6) without time zone NOT NULL,
    organisatie bigint NOT NULL,
    veroorzaaktdoor bigint,
    version bigint,
    opmerkingen character varying(1024)
);


ALTER TABLE public.maatregeltoekenning OWNER TO postgres;

--
-- Name: maatregeltoekenningsregel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.maatregeltoekenningsregel (
    aantalmeldingen integer NOT NULL,
    aantalvrijemeldingen integer NOT NULL,
    aantalweken integer,
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    absentiereden bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    locatie bigint,
    maatregel bigint NOT NULL,
    organisatie bigint NOT NULL,
    organisatieeenheid bigint NOT NULL,
    periode bigint,
    version bigint,
    maatregeltoekennenop character varying(255) NOT NULL,
    periodetype character varying(255) NOT NULL,
    regelsoort character varying(255) NOT NULL,
    CONSTRAINT maatregeltoekenningsregel_maatregeltoekennenop_check CHECK (((maatregeltoekennenop)::text = ANY ((ARRAY['Dezelfde_Dag'::character varying, 'Volgende_Schooldag'::character varying, 'Ongedefinieerd'::character varying])::text[]))),
    CONSTRAINT maatregeltoekenningsregel_periodetype_check CHECK (((periodetype)::text = ANY ((ARRAY['Schooljaar'::character varying, 'Laatste_x_weken'::character varying, 'Periode'::character varying])::text[]))),
    CONSTRAINT maatregeltoekenningsregel_regelsoort_check CHECK (((regelsoort)::text = ANY ((ARRAY['Gelijk_Aan'::character varying, 'Elke_X_Meldingen'::character varying])::text[])))
);


ALTER TABLE public.maatregeltoekenningsregel OWNER TO postgres;

--
-- Name: medewerker; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medewerker (
    begindatum date NOT NULL,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    uitgeslotenvancorres boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    functie bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    persoon bigint NOT NULL,
    redenuitdienst bigint,
    version bigint,
    afkorting character varying(10) NOT NULL,
    redenuitgeslotenvancorres character varying(200)
);


ALTER TABLE public.medewerker OWNER TO postgres;

--
-- Name: medewerkerdeelnemerabonnering; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medewerkerdeelnemerabonnering (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    deelnemer bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    medewerker bigint NOT NULL,
    organisatie bigint NOT NULL,
    version bigint
);


ALTER TABLE public.medewerkerdeelnemerabonnering OWNER TO postgres;

--
-- Name: medewerkergroepabonnering; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medewerkergroepabonnering (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    groep bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    medewerker bigint NOT NULL,
    organisatie bigint NOT NULL,
    version bigint
);


ALTER TABLE public.medewerkergroepabonnering OWNER TO postgres;

--
-- Name: medewerkerkenmerk; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medewerkerkenmerk (
    begindatum date NOT NULL,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    kenmerk bigint NOT NULL,
    medewerker bigint NOT NULL,
    organisatie bigint NOT NULL,
    version bigint,
    toelichting oid
);


ALTER TABLE public.medewerkerkenmerk OWNER TO postgres;

--
-- Name: meeteenheid; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.meeteenheid (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint,
    version bigint,
    naam character varying(128) NOT NULL,
    omschrijving character varying(128) NOT NULL
);


ALTER TABLE public.meeteenheid OWNER TO postgres;

--
-- Name: meeteenheidkoppel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.meeteenheidkoppel (
    automatischaangemaakt boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    vastgezet boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    cohort bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    meeteenheid bigint NOT NULL,
    opleiding bigint,
    organisatie bigint NOT NULL,
    organisatieeenheid bigint,
    version bigint,
    type character varying(255) NOT NULL,
    CONSTRAINT meeteenheidkoppel_type_check CHECK (((type)::text = ANY ((ARRAY['Algemeen'::character varying, 'LLB'::character varying, 'Taal'::character varying, 'Vrij'::character varying])::text[])))
);


ALTER TABLE public.meeteenheidkoppel OWNER TO postgres;

--
-- Name: meeteenheidwaarde; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.meeteenheidwaarde (
    gearchiveerd boolean NOT NULL,
    label character varying(2) NOT NULL,
    waarde integer NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    meeteenheid bigint NOT NULL,
    organisatie bigint,
    version bigint
);


ALTER TABLE public.meeteenheidwaarde OWNER TO postgres;

--
-- Name: modernetaal; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.modernetaal (
    gearchiveerd boolean NOT NULL,
    voorgedefinieerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint,
    version bigint,
    afkorting character varying(255),
    code character varying(255),
    omschrijving character varying(255)
);


ALTER TABLE public.modernetaal OWNER TO postgres;

--
-- Name: moduleafname; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.moduleafname (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    organisatie bigint NOT NULL,
    version bigint,
    checksum character varying(100) NOT NULL,
    modulename character varying(100) NOT NULL,
    organizationname character varying(100) NOT NULL
);


ALTER TABLE public.moduleafname OWNER TO postgres;

--
-- Name: mogelijkeaanleiding; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mogelijkeaanleiding (
    vertrouwelijk boolean NOT NULL,
    zorglijn integer,
    datum timestamp(6) without time zone NOT NULL,
    deelnemer bigint NOT NULL,
    entiteitid bigint NOT NULL,
    organisatie bigint NOT NULL,
    id character varying(255) NOT NULL,
    omschrijving character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    CONSTRAINT mogelijkeaanleiding_type_check CHECK (((type)::text = ANY ((ARRAY['INCIDENT'::character varying, 'NOTITIE'::character varying, 'DEELNEMER_TEST'::character varying, 'BIJZONDERHEID'::character varying, 'GESPREK'::character varying, 'TEST_AFNAME'::character varying, 'TAAK'::character varying])::text[])))
);


ALTER TABLE public.mogelijkeaanleiding OWNER TO postgres;

--
-- Name: nationaliteit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nationaliteit (
    begindatum date NOT NULL,
    eer boolean NOT NULL,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    version bigint,
    naam character varying(100),
    code character varying(255) NOT NULL
);


ALTER TABLE public.nationaliteit OWNER TO postgres;

--
-- Name: niettoneninzorgvierkant; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.niettoneninzorgvierkant (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    bijzonderheid bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    irisincident bigint,
    medewerker bigint NOT NULL,
    notitie bigint,
    organisatie bigint NOT NULL,
    test bigint,
    traject bigint,
    version bigint,
    dtype character varying(255) NOT NULL,
    CONSTRAINT niettoneninzorgvierkant_dtype_check CHECK (((dtype)::text = ANY ((ARRAY['TrajectNietTonenInZorgvierkant'::character varying, 'BijzonderheidNietTonenInZorgvierkant'::character varying, 'DeelnemerTestNietTonenInZorgvierkant'::character varying, 'NotitieNietTonenInZorgvierkant'::character varying, 'IrisIncidentNietTonenInZorgvierkant'::character varying])::text[])))
);


ALTER TABLE public.niettoneninzorgvierkant OWNER TO postgres;

--
-- Name: notitie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notitie (
    dossiereinddatum date NOT NULL,
    gearchiveerd boolean NOT NULL,
    vertrouwelijk boolean NOT NULL,
    zorglijn integer,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    auteur bigint NOT NULL,
    datuminvoer timestamp(6) without time zone NOT NULL,
    deelnemer bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    titel character varying(50) NOT NULL,
    kleur character varying(255) NOT NULL,
    omschrijving oid,
    CONSTRAINT notitie_kleur_check CHECK (((kleur)::text = ANY ((ARRAY['Rood'::character varying, 'Oranje'::character varying, 'Groen'::character varying, 'Wit'::character varying, 'Grijs'::character varying])::text[])))
);


ALTER TABLE public.notitie OWNER TO postgres;

--
-- Name: olclocatie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.olclocatie (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    afspraaktype bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    locatie bigint,
    organisatie bigint NOT NULL,
    organisatieeenheid bigint NOT NULL,
    version bigint,
    code character varying(10) NOT NULL,
    naam character varying(100) NOT NULL
);


ALTER TABLE public.olclocatie OWNER TO postgres;

--
-- Name: olcwaarneming; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.olcwaarneming (
    begintijd time(0) without time zone NOT NULL,
    datum date NOT NULL,
    eindtijd time(0) without time zone,
    gearchiveerd boolean NOT NULL,
    verwerkt boolean,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    afspraaktype bigint NOT NULL,
    deelnemer bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    medewerker bigint,
    olclocatie bigint NOT NULL,
    organisatie bigint NOT NULL,
    version bigint
);


ALTER TABLE public.olcwaarneming OWNER TO postgres;

--
-- Name: onderwijsproduct; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.onderwijsproduct (
    aantalweken integer,
    alleenextern boolean NOT NULL,
    begeleid boolean,
    begindatum date NOT NULL,
    belasting numeric(20,10),
    belastingec numeric(20,10),
    belastingoverig numeric(20,10),
    bijintake boolean NOT NULL,
    credits integer,
    einddatum date,
    einddatumnotnull date NOT NULL,
    frequentieperweek integer,
    gearchiveerd boolean NOT NULL,
    heeftwerkstuktitel boolean NOT NULL,
    individueel boolean,
    kostprijs numeric(19,2),
    maximumaantaldeelnemers integer,
    minimumaantaldeelnemers integer,
    omvang numeric(20,10),
    onafhankelijk boolean,
    startonderwijsproduct boolean NOT NULL,
    tijdpereenheid numeric(20,10),
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    aggregatieniveau bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    leerstijl bigint,
    niveauaanduiding bigint,
    organisatie bigint NOT NULL,
    soortpraktijklokaal bigint,
    soortproduct bigint NOT NULL,
    typelocatie bigint,
    typetoets bigint,
    version bigint,
    code character varying(20) NOT NULL,
    internationaletitel character varying(100),
    titel character varying(100) NOT NULL,
    leerstofdrager character varying(500),
    gebruiksrecht character varying(2000),
    juridischeigenaar character varying(2000),
    kalender character varying(2000),
    personeelbevoegdheid character varying(2000),
    personeelcompetenties character varying(2000),
    personeelkennisgebiedenniveau character varying(2000),
    personeelwettelijkevereisten character varying(2000),
    uitvoeringsfrequentie character varying(2000),
    status character varying(255) NOT NULL,
    docentactiviteiten oid,
    hulpmiddelen oid,
    internationaleomschrijving oid,
    literatuur oid,
    omschrijving oid,
    toegankelijkheid oid,
    vereistevoorkennis oid,
    CONSTRAINT onderwijsproduct_status_check CHECK (((status)::text = ANY ((ARRAY['Aangevraagd'::character varying, 'InOntwikkeling'::character varying, 'Beschikbaar'::character varying, 'Vervallen'::character varying, 'NietBeschikbaar'::character varying])::text[])))
);


ALTER TABLE public.onderwijsproduct OWNER TO postgres;

--
-- Name: onderwijsproductaanbod; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.onderwijsproductaanbod (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    locatie bigint,
    onderwijsproduct bigint NOT NULL,
    organisatie bigint NOT NULL,
    organisatieeenheid bigint NOT NULL,
    version bigint
);


ALTER TABLE public.onderwijsproductaanbod OWNER TO postgres;

--
-- Name: onderwijsproductaanbodperiode; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.onderwijsproductaanbodperiode (
    begindatum date NOT NULL,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    minimaalaantalinschrijvingen integer CONSTRAINT onderwijsproductaanbodperio_minimaalaantalinschrijving_not_null NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    aanbodperiode bigint NOT NULL,
    begindatuminschrijving timestamp(6) without time zone,
    begindatumlesperiode timestamp(6) without time zone,
    einddatuminschrijving timestamp(6) without time zone,
    einddatumlesperiode timestamp(6) without time zone,
    id bigint NOT NULL,
    idinoudpakket bigint,
    onderwijsproductaanbod bigint NOT NULL,
    organisatie bigint NOT NULL,
    version bigint
);


ALTER TABLE public.onderwijsproductaanbodperiode OWNER TO postgres;

--
-- Name: onderwijsproductafname; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.onderwijsproductafname (
    begindatum date NOT NULL,
    credits integer,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    bpvinschrijving bigint,
    cohort bigint NOT NULL,
    deelnemer bigint NOT NULL,
    externeorganisatie bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    onderwijsproduct bigint NOT NULL,
    organisatie bigint NOT NULL,
    version bigint,
    vrijstellingtype character varying(15) NOT NULL,
    werkstuktitel character varying(200),
    CONSTRAINT onderwijsproductafname_vrijstellingtype_check CHECK (((vrijstellingtype)::text = ANY ((ARRAY['Geen'::character varying, 'EVC'::character varying, 'Vervallen'::character varying])::text[])))
);


ALTER TABLE public.onderwijsproductafname OWNER TO postgres;

--
-- Name: onderwijsproductafnamecontext; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.onderwijsproductafnamecontext (
    certificaatbehaald boolean NOT NULL,
    diplomavak boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    toonopcijferlijst boolean NOT NULL,
    verwezennaarvolgendtijdvak boolean CONSTRAINT onderwijsproductafnameconte_verwezennaarvolgendtijdvak_not_null NOT NULL,
    volgnummer integer,
    werkstukhoortbijproduct boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    brondatum timestamp(6) without time zone,
    id bigint NOT NULL,
    idinoudpakket bigint,
    onderwijsproductafname bigint NOT NULL,
    organisatie bigint NOT NULL,
    productregel bigint NOT NULL,
    verbintenis bigint NOT NULL,
    version bigint,
    bronstatus character varying(255),
    toepassingresultaat character varying(255),
    toepassingresultaatexamenvak character varying(255),
    CONSTRAINT onderwijsproductafnamecontex_toepassingresultaatexamenvak_check CHECK (((toepassingresultaatexamenvak)::text = 'GeexamineerdInJaarMelding'::text)),
    CONSTRAINT onderwijsproductafnamecontext_bronstatus_check CHECK (((bronstatus)::text = ANY ((ARRAY['Geen'::character varying, 'Wachtrij'::character varying, 'WachtrijWelInBron'::character varying, 'InBehandeling'::character varying, 'InBehandelingWelInBron'::character varying, 'Goedgekeurd'::character varying, 'Afgekeurd'::character varying, 'AfgekeurdWelInBron'::character varying])::text[]))),
    CONSTRAINT onderwijsproductafnamecontext_toepassingresultaat_check CHECK (((toepassingresultaat)::text = 'GeexamineerdInJaarVanMelding'::text))
);


ALTER TABLE public.onderwijsproductafnamecontext OWNER TO postgres;

--
-- Name: onderwijsproductniveau; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.onderwijsproductniveau (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    code character varying(10) NOT NULL,
    naam character varying(100) NOT NULL
);


ALTER TABLE public.onderwijsproductniveau OWNER TO postgres;

--
-- Name: onderwijsproductopvolger; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.onderwijsproductopvolger (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    nieuwproduct bigint NOT NULL,
    organisatie bigint NOT NULL,
    oudproduct bigint NOT NULL,
    version bigint
);


ALTER TABLE public.onderwijsproductopvolger OWNER TO postgres;

--
-- Name: onderwijsproductsamenstelling; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.onderwijsproductsamenstelling (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    child bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    parent bigint NOT NULL,
    version bigint
);


ALTER TABLE public.onderwijsproductsamenstelling OWNER TO postgres;

--
-- Name: onderwijsproducttaxonomie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.onderwijsproducttaxonomie (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    onderwijsproduct bigint NOT NULL,
    organisatie bigint NOT NULL,
    taxonomieelement bigint NOT NULL,
    version bigint
);


ALTER TABLE public.onderwijsproducttaxonomie OWNER TO postgres;

--
-- Name: onderwijsproductvoorwaarde; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.onderwijsproductvoorwaarde (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    voorwaardevoor bigint NOT NULL,
    voorwaardelijkproduct bigint NOT NULL
);


ALTER TABLE public.onderwijsproductvoorwaarde OWNER TO postgres;

--
-- Name: onderwijsproductzoekterm; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.onderwijsproductzoekterm (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    onderwijsproduct bigint NOT NULL,
    organisatie bigint NOT NULL,
    version bigint,
    zoekterm character varying(100) NOT NULL
);


ALTER TABLE public.onderwijsproductzoekterm OWNER TO postgres;

--
-- Name: ondprodgebruiksmiddel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ondprodgebruiksmiddel (
    aantal integer,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    gebruiksmiddel bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    onderwijsproduct bigint NOT NULL,
    organisatie bigint NOT NULL,
    version bigint
);


ALTER TABLE public.ondprodgebruiksmiddel OWNER TO postgres;

--
-- Name: ondprodverbruiksmiddel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ondprodverbruiksmiddel (
    aantal integer,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    onderwijsproduct bigint NOT NULL,
    organisatie bigint NOT NULL,
    verbruiksmiddel bigint NOT NULL,
    version bigint
);


ALTER TABLE public.ondprodverbruiksmiddel OWNER TO postgres;

--
-- Name: opaanbodperiodeopafname; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.opaanbodperiodeopafname (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    onderwijsproductaanbodperiode bigint NOT NULL,
    onderwijsproductafname bigint NOT NULL,
    organisatie bigint NOT NULL,
    version bigint
);


ALTER TABLE public.opaanbodperiodeopafname OWNER TO postgres;

--
-- Name: opleiding; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.opleiding (
    beginleerjaar integer,
    begindatum date NOT NULL,
    communicerenmetbron boolean NOT NULL,
    duurinmaanden integer,
    eindleerjaar integer,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    instroomvariant boolean,
    kieskenniscentrum boolean NOT NULL,
    negeerlandelijkecriteria boolean NOT NULL,
    negeerlandelijkeproductregels boolean NOT NULL,
    uitstroomvariant boolean,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    datumlaatsteinschrijving timestamp(6) without time zone,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    parent bigint NOT NULL,
    verbintenisgebied bigint NOT NULL,
    version bigint,
    code character varying(20) NOT NULL,
    dtype character varying(31) NOT NULL,
    defaultintensiteit character varying(100),
    internationalenaam character varying(100),
    naam character varying(100) NOT NULL,
    wervingsnaam character varying(100) NOT NULL,
    diplomatekst1 character varying(1000),
    diplomatekst2 character varying(1000),
    diplomatekst3 character varying(1000),
    leerweg character varying(255),
    CONSTRAINT opleiding_check CHECK ((((dtype)::text <> 'Opleidingsvariant'::text) OR ((instroomvariant IS NOT NULL) AND (uitstroomvariant IS NOT NULL)))),
    CONSTRAINT opleiding_defaultintensiteit_check CHECK (((defaultintensiteit)::text = ANY ((ARRAY['Voltijd'::character varying, 'Deeltijd'::character varying])::text[]))),
    CONSTRAINT opleiding_dtype_check CHECK (((dtype)::text = ANY ((ARRAY['Opleiding'::character varying, 'Opleidingsvariant'::character varying])::text[]))),
    CONSTRAINT opleiding_leerweg_check CHECK (((leerweg)::text = ANY ((ARRAY['BOL'::character varying, 'BBL'::character varying, 'COL'::character varying, 'CBL'::character varying])::text[])))
);


ALTER TABLE public.opleiding OWNER TO postgres;

--
-- Name: COLUMN opleiding.defaultintensiteit; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.opleiding.defaultintensiteit IS 'De default intensiteit voor deelnemers die ingeschreven worden op deze opleiding';


--
-- Name: COLUMN opleiding.wervingsnaam; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.opleiding.wervingsnaam IS 'Deze naam kan gebruikt worden bij bijvoorbeeld een digitaal aanmeld portaal';


--
-- Name: opleidingaanbod; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.opleidingaanbod (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    locatie bigint NOT NULL,
    opleiding bigint NOT NULL,
    organisatie bigint NOT NULL,
    organisatieeenheid bigint NOT NULL,
    team bigint,
    version bigint
);


ALTER TABLE public.opleidingaanbod OWNER TO postgres;

--
-- Name: opleidingfase; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.opleidingfase (
    credits integer,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    opleiding bigint NOT NULL,
    organisatie bigint NOT NULL,
    version bigint,
    hoofdfase character varying(255) NOT NULL,
    opleidingsvorm character varying(255) NOT NULL,
    CONSTRAINT opleidingfase_hoofdfase_check CHECK (((hoofdfase)::text = ANY ((ARRAY['PropBach'::character varying, 'Bachelor'::character varying, 'Propedeuse'::character varying, 'Master'::character varying, 'Vervolgopl'::character varying, 'Kandidaats'::character varying, 'Initieel'::character varying, 'AssDegree'::character varying])::text[]))),
    CONSTRAINT opleidingfase_opleidingsvorm_check CHECK (((opleidingsvorm)::text = ANY ((ARRAY['Voltijd'::character varying, 'Deeltijd'::character varying, 'Duaal'::character varying])::text[])))
);


ALTER TABLE public.opleidingfase OWNER TO postgres;

--
-- Name: organisatie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organisatie (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    code bigint,
    id bigint NOT NULL,
    version bigint,
    dtype character varying(31) NOT NULL,
    naam character varying(100) NOT NULL,
    wikipassword character varying(300),
    wikiuser character varying(300),
    CONSTRAINT organisatie_dtype_check CHECK (((dtype)::text = ANY ((ARRAY['Instelling'::character varying, 'Beheer'::character varying])::text[])))
);


ALTER TABLE public.organisatie OWNER TO postgres;

--
-- Name: organisatieeenheid; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organisatieeenheid (
    begindatum date NOT NULL,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    intakewizardstap3overslaan boolean NOT NULL,
    tonenbijdigitaalaanmelden boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    parent bigint,
    soortorganisatieeenheid bigint NOT NULL,
    version bigint,
    afkorting character varying(10) NOT NULL,
    bankrekeningnummer character varying(11),
    naam character varying(100) NOT NULL,
    officielenaam character varying(150)
);


ALTER TABLE public.organisatieeenheid OWNER TO postgres;

--
-- Name: COLUMN organisatieeenheid.intakewizardstap3overslaan; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.organisatieeenheid.intakewizardstap3overslaan IS 'Indicatie die aangeeft of stap-3 van de intake wizard overgeslagen moet worden als deze organisatie-eenheid gekozen is';


--
-- Name: COLUMN organisatieeenheid.tonenbijdigitaalaanmelden; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.organisatieeenheid.tonenbijdigitaalaanmelden IS 'Indicatie die aangeeft of de organisatie-eenheid getoont moet worden als keuze bij digitaal aanmelden';


--
-- Name: organisatieeenheidcg; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organisatieeenheidcg (
    gearchiveerd boolean NOT NULL,
    geheim boolean NOT NULL,
    volgorde integer NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    organisatieeenheid bigint NOT NULL,
    soortcontactgegeven bigint,
    version bigint,
    contactgegeven character varying(60) NOT NULL
);


ALTER TABLE public.organisatieeenheidcg OWNER TO postgres;

--
-- Name: organisatieeenheidlocatie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organisatieeenheidlocatie (
    begindatum date NOT NULL,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    locatie bigint NOT NULL,
    organisatie bigint NOT NULL,
    organisatieeenheid bigint NOT NULL,
    version bigint
);


ALTER TABLE public.organisatieeenheidlocatie OWNER TO postgres;

--
-- Name: organisatiemedewerker; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organisatiemedewerker (
    begindatum date NOT NULL,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    locatie bigint,
    medewerker bigint,
    organisatie bigint NOT NULL,
    organisatieeenheid bigint NOT NULL,
    version bigint
);


ALTER TABLE public.organisatiemedewerker OWNER TO postgres;

--
-- Name: organisatiesetting; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organisatiesetting (
    absentiepresentie smallint,
    actief boolean,
    blokkadedatumbpv date,
    blokkadedatumverbintenis date,
    booleanvalue boolean,
    deelnemernummerisdebiteurnr boolean,
    gearchiveerd boolean NOT NULL,
    gezamenlijkerange boolean,
    hoofdletters boolean,
    intvalue integer,
    leestekens boolean,
    lengte integer,
    loginpogingactief boolean,
    pogingen integer,
    poortnummer integer,
    sessietimeout integer,
    timeout integer,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    account bigint,
    id bigint NOT NULL,
    lesweekindeling bigint,
    organisatie bigint NOT NULL,
    organisatieeenheid bigint,
    version bigint,
    apikey character varying(32),
    ipadressen character varying(4000),
    dtype character varying(255) NOT NULL,
    maniervanaanmelden character varying(255),
    host character varying(255),
    stringvalue character varying(255),
    wachtwoord character varying(255),
    CONSTRAINT organisatiesetting_absentiepresentie_check CHECK (((absentiepresentie >= 0) AND (absentiepresentie <= 3))),
    CONSTRAINT organisatiesetting_check CHECK ((((dtype)::text <> 'AbsentiePresentieSetting'::text) OR (absentiepresentie IS NOT NULL))),
    CONSTRAINT organisatiesetting_check1 CHECK ((((dtype)::text <> 'DpOneindigeMeldingSetting'::text) OR (booleanvalue IS NOT NULL))),
    CONSTRAINT organisatiesetting_check2 CHECK ((((dtype)::text <> 'ManierVanAanmeldenSetting'::text) OR (maniervanaanmelden IS NOT NULL))),
    CONSTRAINT organisatiesetting_dtype_check CHECK (((dtype)::text = ANY ((ARRAY['AbsentiePresentieSetting'::character varying, 'ManierVanAanmeldenSetting'::character varying, 'DefaultLesweekIndeling'::character varying, 'LandelijkeExtOrganisaties'::character varying, 'DeelnemerportaalMeldingstermijnSetting'::character varying, 'DeelnemerportaalWelkomsttekstSetting'::character varying, 'MutatieBlokkedatumSetting'::character varying, 'OrganisatieIpAdresSetting'::character varying, 'DpOneindigeMeldingSetting'::character varying, 'RadiusServerSetting'::character varying, 'LoginSetting'::character varying, 'DebiteurNummerSetting'::character varying, 'VascoTokensSetting'::character varying, 'PasswordSetting'::character varying, 'ResultaatControleSetting'::character varying, 'ScreenSaverSetting'::character varying, 'APIKeySetting'::character varying])::text[]))),
    CONSTRAINT organisatiesetting_maniervanaanmelden_check CHECK (((maniervanaanmelden)::text = ANY ((ARRAY['NietGebruiken'::character varying, 'AanmeldenViaGroep'::character varying, 'AanmeldenViaOpleiding'::character varying])::text[])))
);


ALTER TABLE public.organisatiesetting OWNER TO postgres;

--
-- Name: COLUMN organisatiesetting.sessietimeout; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.organisatiesetting.sessietimeout IS 'Het aantal minuten waarna de gebruiker uitgelogd wordt, als de screensaver actief is.';


--
-- Name: COLUMN organisatiesetting.apikey; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.organisatiesetting.apikey IS 'Pas op. Het wijzigen van de API sleutel heeft als gevolg dat iedereen, die gebruik maakt van de webservices, de nieuwe sleutel dient te ontvangen. Zonder de nieuwe sleutel kan men geen gebruik meer maken van de webservices.';


--
-- Name: COLUMN organisatiesetting.ipadressen; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.organisatiesetting.ipadressen IS 'Alleen toegang toestaan (voor de hele organisatie) vanaf de hier ingevulde IP adressen. Meerdere adressen worden gescheiden door een komma. Als het adres eindigt op .0 (bijvoorbeeld 192.168.1.0) heeft de hele range 192.168.1.1 t/m 192.168.1.254 toegang.';


--
-- Name: orgehdcontactpersoon; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orgehdcontactpersoon (
    begindatum date NOT NULL,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    organisatieeenheid bigint NOT NULL,
    rol bigint,
    version bigint,
    emailadres character varying(60),
    mobiel character varying(60),
    telefoon character varying(60),
    naam character varying(80) NOT NULL,
    geslacht character varying(255) NOT NULL,
    CONSTRAINT orgehdcontactpersoon_geslacht_check CHECK (((geslacht)::text = ANY ((ARRAY['Man'::character varying, 'Vrouw'::character varying, 'Onbekend'::character varying])::text[])))
);


ALTER TABLE public.orgehdcontactpersoon OWNER TO postgres;

--
-- Name: periode; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.periode (
    gearchiveerd boolean NOT NULL,
    volgnummer integer NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    datumbegin timestamp(6) without time zone NOT NULL,
    datumeind timestamp(6) without time zone NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    periodeindeling bigint NOT NULL,
    version bigint
);


ALTER TABLE public.periode OWNER TO postgres;

--
-- Name: periodeindeling; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.periodeindeling (
    gearchiveerd boolean NOT NULL,
    schooljaar integer NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    organisatieeenheid bigint NOT NULL,
    version bigint,
    omschrijving character varying(100) NOT NULL
);


ALTER TABLE public.periodeindeling OWNER TO postgres;

--
-- Name: persoon; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.persoon (
    betalingstermijn integer,
    datuminnederland date,
    datumoverlijden date,
    gearchiveerd boolean NOT NULL,
    geboortedatum date,
    nietverstrekkenaanderden boolean NOT NULL,
    nieuwkomer boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    afbeelding bigint,
    automatischeincassoeinddatum timestamp(6) without time zone,
    bsn bigint,
    debiteurennummer bigint,
    geboortegemeente bigint,
    geboorteland bigint,
    geboortelandouder1 bigint,
    geboortelandouder2 bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    laatsteexportdatum timestamp(6) without time zone,
    landbank bigint,
    nationaliteit1 bigint,
    nationaliteit2 bigint,
    organisatie bigint NOT NULL,
    verblijfsvergunning bigint,
    version bigint,
    bankrekeningnummer character varying(11),
    automatischeincasso character varying(20) NOT NULL,
    officielevoorvoegsel character varying(20),
    voorletters character varying(24),
    factuurbetaalwijze character varying(30) NOT NULL,
    buitenlandsbankrekeningnummer character varying(34),
    roepnaam character varying(40),
    buitenlandsebanknaam character varying(50),
    bankrekeningtenaamstelling character varying(60),
    achternaam character varying(80) NOT NULL,
    lowercaseachternaam character varying(80) NOT NULL,
    officieleachternaam character varying(80) NOT NULL,
    voornamen character varying(80),
    wachtwoord character varying(128),
    berekendezoeknaam character varying(165) NOT NULL,
    burgerlijkestaat character varying(255),
    correspondentietaal character varying(255),
    cumicategorie character varying(255),
    cumiratio character varying(255),
    geboorteplaats character varying(255),
    geslacht character varying(255),
    toepassinggeboortedatum character varying(255),
    voorvoegsel character varying(255),
    CONSTRAINT persoon_automatischeincasso_check CHECK (((automatischeincasso)::text = ANY ((ARRAY['Geen'::character varying, 'AlleenCursusgeld'::character varying, 'Alles'::character varying])::text[]))),
    CONSTRAINT persoon_burgerlijkestaat_check CHECK (((burgerlijkestaat)::text = ANY ((ARRAY['GEHUWD'::character varying, 'GEREGISTREERDPARTNERSCHAP'::character varying, 'GESCHEIDEN'::character varying, 'ONGEHUWD'::character varying, 'ONTBONDENGEREGISTREERDPARTNERSCHAP'::character varying, 'WEDUWE_WEDUWNAAR'::character varying])::text[]))),
    CONSTRAINT persoon_correspondentietaal_check CHECK (((correspondentietaal)::text = ANY ((ARRAY['Nederlands'::character varying, 'Engels'::character varying, 'Duits'::character varying])::text[]))),
    CONSTRAINT persoon_cumicategorie_check CHECK (((cumicategorie)::text = 'Categorie4a'::text)),
    CONSTRAINT persoon_cumiratio_check CHECK (((cumiratio)::text = ANY ((ARRAY['d1'::character varying, 'd2'::character varying])::text[]))),
    CONSTRAINT persoon_factuurbetaalwijze_check CHECK (((factuurbetaalwijze)::text = ANY ((ARRAY['OVERIG'::character varying, 'AUTOMATISCHE_INCASSO'::character varying, 'ACCEPTEMAIL'::character varying])::text[]))),
    CONSTRAINT persoon_geslacht_check CHECK (((geslacht)::text = ANY ((ARRAY['Man'::character varying, 'Vrouw'::character varying, 'Onbekend'::character varying])::text[]))),
    CONSTRAINT persoon_toepassinggeboortedatum_check CHECK (((toepassinggeboortedatum)::text = ANY ((ARRAY['GeboortemaandEnJaar'::character varying, 'Geboortejaar'::character varying])::text[])))
);


ALTER TABLE public.persoon OWNER TO postgres;

--
-- Name: COLUMN persoon.betalingstermijn; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.persoon.betalingstermijn IS 'Specifieke betalingstermijn voor deze debiteur (in dagen).';


--
-- Name: COLUMN persoon.nietverstrekkenaanderden; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.persoon.nietverstrekkenaanderden IS 'Indicatie die aangeeft of informatie over deze deelnemer verstrekt mag worden aan derden';


--
-- Name: COLUMN persoon.automatischeincassoeinddatum; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.persoon.automatischeincassoeinddatum IS 'Einddatum van de machtiging. Na deze datum zullen geen bedragen automatisch meer worden geïncasseerd.';


--
-- Name: COLUMN persoon.wachtwoord; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.persoon.wachtwoord IS 'Extern wachtwoord dat niet gekoppeld is aan het account van deze persoon.';


--
-- Name: persooncontactgegeven; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.persooncontactgegeven (
    gearchiveerd boolean NOT NULL,
    geheim boolean NOT NULL,
    volgorde integer NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    persoon bigint NOT NULL,
    soortcontactgegeven bigint NOT NULL,
    version bigint,
    contactgegeven character varying(320) NOT NULL
);


ALTER TABLE public.persooncontactgegeven OWNER TO postgres;

--
-- Name: persoonextorgcontactpersoon; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.persoonextorgcontactpersoon (
    begindatum date NOT NULL,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    extorgcontactpersoon bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    persoonexterneorganisatie bigint NOT NULL,
    version bigint
);


ALTER TABLE public.persoonextorgcontactpersoon OWNER TO postgres;

--
-- Name: persoonlijketoetscode; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.persoonlijketoetscode (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    medewerker bigint NOT NULL,
    organisatie bigint NOT NULL,
    toets bigint NOT NULL,
    version bigint,
    code character varying(10) NOT NULL
);


ALTER TABLE public.persoonlijketoetscode OWNER TO postgres;

--
-- Name: plaats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.plaats (
    gearchiveerd boolean NOT NULL,
    uniek boolean NOT NULL,
    uniekmetprovincie boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    gemeente bigint,
    id bigint NOT NULL,
    provincie bigint,
    version bigint,
    naam character varying(100) NOT NULL,
    sorteernaam character varying(100) NOT NULL
);


ALTER TABLE public.plaats OWNER TO postgres;

--
-- Name: planningtemplate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.planningtemplate (
    aantaleenhedennaaanvang integer NOT NULL,
    aantaleenhedentussenherhaling integer,
    gearchiveerd boolean NOT NULL,
    stoptnaaantaleenheden integer,
    stoptnaaantalkeer integer NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    eenheidtussenherhaling character varying(255),
    stoptnaeenheid character varying(255),
    tijdeenheid character varying(255) NOT NULL,
    CONSTRAINT planningtemplate_eenheidtussenherhaling_check CHECK (((eenheidtussenherhaling)::text = ANY ((ARRAY['Dagen'::character varying, 'Weken'::character varying, 'Maanden'::character varying, 'Jaren'::character varying])::text[]))),
    CONSTRAINT planningtemplate_stoptnaeenheid_check CHECK (((stoptnaeenheid)::text = ANY ((ARRAY['Dagen'::character varying, 'Weken'::character varying, 'Maanden'::character varying, 'Jaren'::character varying])::text[]))),
    CONSTRAINT planningtemplate_tijdeenheid_check CHECK (((tijdeenheid)::text = ANY ((ARRAY['Dagen'::character varying, 'Weken'::character varying, 'Maanden'::character varying, 'Jaren'::character varying])::text[])))
);


ALTER TABLE public.planningtemplate OWNER TO postgres;

--
-- Name: productregel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.productregel (
    aantaldecimalen integer NOT NULL,
    gearchiveerd boolean NOT NULL,
    minimalewaarde numeric(20,10),
    verplicht boolean NOT NULL,
    volgnummer integer NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    alleonderwprodtoestaanvan bigint,
    cohort bigint NOT NULL,
    fase bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    opleiding bigint,
    organisatie bigint,
    soortproductregel bigint NOT NULL,
    verbintenisgebied bigint NOT NULL,
    version bigint,
    minimalewaardetekst character varying(10),
    afkorting character varying(20) NOT NULL,
    naam character varying(255) NOT NULL,
    typeproductregel character varying(255) NOT NULL,
    CONSTRAINT productregel_typeproductregel_check CHECK (((typeproductregel)::text = ANY ((ARRAY['Productregel'::character varying, 'AfgeleideProductregel'::character varying])::text[])))
);


ALTER TABLE public.productregel OWNER TO postgres;

--
-- Name: provincie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.provincie (
    begindatum date NOT NULL,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    version bigint,
    afkorting character varying(10) NOT NULL,
    code character varying(10) NOT NULL,
    naam character varying(100) NOT NULL
);


ALTER TABLE public.provincie OWNER TO postgres;

--
-- Name: rapportagetemplate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rapportagetemplate (
    begindatum date NOT NULL,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    includellb boolean NOT NULL,
    includetaal boolean NOT NULL,
    includeuitstroom boolean NOT NULL,
    includevrijematrices boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    medewerker bigint NOT NULL,
    organisatie bigint,
    samenvoegenhtml bigint NOT NULL,
    samenvoegenpdfconfig bigint NOT NULL,
    version bigint,
    voortganghtmlconfig bigint NOT NULL,
    voortgangpdfconfig bigint NOT NULL,
    naam character varying(255) NOT NULL,
    outputform character varying(255) NOT NULL,
    purpose character varying(255) NOT NULL,
    CONSTRAINT rapportagetemplate_outputform_check CHECK (((outputform)::text = ANY ((ARRAY['HTML'::character varying, 'PDF'::character varying])::text[]))),
    CONSTRAINT rapportagetemplate_purpose_check CHECK (((purpose)::text = ANY ((ARRAY['HUIDIGE_STAND'::character varying, 'SAMENVOEGEN'::character varying, 'DETAILS'::character varying])::text[])))
);


ALTER TABLE public.rapportagetemplate OWNER TO postgres;

--
-- Name: rapportagetemplateijkpunt; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rapportagetemplateijkpunt (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    config bigint,
    configpdf bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    ijkpunt bigint NOT NULL,
    organisatie bigint NOT NULL,
    version bigint
);


ALTER TABLE public.rapportagetemplateijkpunt OWNER TO postgres;

--
-- Name: recht; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recht (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    organisatie bigint NOT NULL,
    rol bigint NOT NULL,
    version bigint,
    actionclassname character varying(200) NOT NULL,
    principalsourceclassname character varying(200) NOT NULL
);


ALTER TABLE public.recht OWNER TO postgres;

--
-- Name: redenuitdienst; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.redenuitdienst (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    code character varying(10) NOT NULL,
    naam character varying(100) NOT NULL
);


ALTER TABLE public.redenuitdienst OWNER TO postgres;

--
-- Name: redenuitschrijving; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.redenuitschrijving (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    geslaagd boolean NOT NULL,
    overlijden boolean NOT NULL,
    tonenbijbpv boolean NOT NULL,
    tonenbijverbintenis boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    code character varying(10) NOT NULL,
    naam character varying(100) NOT NULL,
    redenuitval character varying(255),
    uitstroomredenwi character varying(255),
    CONSTRAINT redenuitschrijving_redenuitval_check CHECK (((redenuitval)::text = ANY ((ARRAY['PersoonsgebondenGeenInvloed'::character varying, 'PersoonsgebondenOpvang'::character varying, 'Instellingsgebonden'::character varying, 'StudieBeroepsgebonden'::character varying, 'ArbeidsmarktOmgeving'::character varying, 'GeenDiplomaWelSuccesvol'::character varying, 'Onbekend'::character varying, 'Experimenteel'::character varying, 'Wanbetaler'::character varying])::text[]))),
    CONSTRAINT redenuitschrijving_uitstroomredenwi_check CHECK (((uitstroomredenwi)::text = ANY ((ARRAY['Afgerond'::character varying, 'Kinderopvang'::character varying, 'Aanbod'::character varying, 'Werk'::character varying, 'MeerStudiebelasting'::character varying, 'VerwachteStudiebelasting'::character varying, 'LangdurigZiek'::character varying, 'AndereRoute'::character varying, 'Vrijgesteld'::character varying, 'Verhuizing'::character varying, 'NietVerschenen'::character varying, 'Zwangerschap'::character varying, 'Overlijden'::character varying, 'Overig'::character varying])::text[])))
);


ALTER TABLE public.redenuitschrijving OWNER TO postgres;

--
-- Name: COLUMN redenuitschrijving.geslaagd; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.redenuitschrijving.geslaagd IS 'Selecteer dit wanneer deze reden betekent dat het diploma is behaald.';


--
-- Name: COLUMN redenuitschrijving.overlijden; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.redenuitschrijving.overlijden IS 'Selecteer dit wanneer het om de reden van uitschrijven mbt Verbintenis gaat en het de reden van overlijden is. Niet te wijzigingen als deze reden al aan een verbintenis of BPV inschrijving gekoppeld is.';


--
-- Name: COLUMN redenuitschrijving.tonenbijbpv; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.redenuitschrijving.tonenbijbpv IS 'Selecteer dit wanneer het om de reden van uitschrijven mbt BPV gaat';


--
-- Name: COLUMN redenuitschrijving.tonenbijverbintenis; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.redenuitschrijving.tonenbijverbintenis IS 'Selecteer dit wanneer het om de reden van uitschrijven mbt een verbintenis gaat';


--
-- Name: COLUMN redenuitschrijving.redenuitval; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.redenuitschrijving.redenuitval IS 'Bij uitval: de hoofdcategorie van de uitvalsredenen zoals gespecificeerd door de MBO-raad. Dit wordt bij BVE-deelnemers aangeleverd aan BRON';


--
-- Name: regio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.regio (
    begindatum date NOT NULL,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    version bigint,
    code character varying(10) NOT NULL,
    naam character varying(100) NOT NULL
);


ALTER TABLE public.regio OWNER TO postgres;

--
-- Name: relatiesoort; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.relatiesoort (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    organisatieopname boolean NOT NULL,
    persoonopname boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    code character varying(10) NOT NULL,
    naam character varying(100) NOT NULL
);


ALTER TABLE public.relatiesoort OWNER TO postgres;

--
-- Name: COLUMN relatiesoort.organisatieopname; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.relatiesoort.organisatieopname IS 'Selecteer dit wanneer de Relatiesoort gebruikt kan worden bij een organisatie';


--
-- Name: COLUMN relatiesoort.persoonopname; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.relatiesoort.persoonopname IS 'Selecteer dit wanneer  de Relatiesoort gebruikt kan worden bij een persoon';


--
-- Name: resultaat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resultaat (
    actueel boolean NOT NULL,
    cijfer numeric(20,10),
    datumbehaald date,
    gearchiveerd boolean NOT NULL,
    geldend boolean NOT NULL,
    herkansingsnummer integer NOT NULL,
    insamengesteld boolean NOT NULL,
    onafgerondcijfer numeric(20,10),
    score integer,
    studiepunten integer NOT NULL,
    weging integer,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    deelnemer bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    ingevoerddoor bigint,
    organisatie bigint NOT NULL,
    overschrijft bigint,
    toets bigint NOT NULL,
    version bigint,
    waarde bigint,
    soort character varying(255) NOT NULL,
    berekening oid,
    notitie oid,
    CONSTRAINT resultaat_soort_check CHECK (((soort)::text = ANY ((ARRAY['Ingevoerd'::character varying, 'Overschreven'::character varying, 'Verwezen'::character varying, 'Berekend'::character varying, 'Tijdelijk'::character varying, 'Alternatief'::character varying])::text[])))
);


ALTER TABLE public.resultaat OWNER TO postgres;

--
-- Name: resultaatstructuur; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resultaatstructuur (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    specifiek boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    auteur bigint,
    categorie bigint,
    cohort bigint NOT NULL,
    eindresultaat bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    onderwijsproduct bigint NOT NULL,
    organisatie bigint NOT NULL,
    version bigint,
    code character varying(10) NOT NULL,
    naam character varying(100) NOT NULL,
    status character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    CONSTRAINT resultaatstructuur_status_check CHECK (((status)::text = ANY ((ARRAY['IN_HERBEREKENING'::character varying, 'BESCHIKBAAR'::character varying, 'IN_ONDERHOUD'::character varying, 'FOUTIEF'::character varying])::text[]))),
    CONSTRAINT resultaatstructuur_type_check CHECK (((type)::text = ANY ((ARRAY['SUMMATIEF'::character varying, 'FORMATIEF'::character varying])::text[])))
);


ALTER TABLE public.resultaatstructuur OWNER TO postgres;

--
-- Name: resultaatstructuurcategorie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resultaatstructuurcategorie (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    naam character varying(100) NOT NULL
);


ALTER TABLE public.resultaatstructuurcategorie OWNER TO postgres;

--
-- Name: resultaatstructuurdeelnemer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resultaatstructuurdeelnemer (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    deelnemer bigint,
    groep bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    resultaatstructuur bigint,
    version bigint
);


ALTER TABLE public.resultaatstructuurdeelnemer OWNER TO postgres;

--
-- Name: resultaatstructuurmedewerker; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resultaatstructuurmedewerker (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    medewerker bigint,
    organisatie bigint NOT NULL,
    resultaatstructuur bigint,
    version bigint
);


ALTER TABLE public.resultaatstructuurmedewerker OWNER TO postgres;

--
-- Name: resultaatzoekfilterinstelling; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resultaatzoekfilterinstelling (
    gearchiveerd boolean NOT NULL,
    gekoppeldaanverbintenis boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    categorie bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    medewerker bigint NOT NULL,
    organisatie bigint NOT NULL,
    version bigint,
    codepath character varying(255),
    type character varying(255),
    CONSTRAINT resultaatzoekfilterinstelling_type_check CHECK (((type)::text = ANY ((ARRAY['SUMMATIEF'::character varying, 'FORMATIEF'::character varying])::text[])))
);


ALTER TABLE public.resultaatzoekfilterinstelling OWNER TO postgres;

--
-- Name: rol; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rol (
    gearchiveerd boolean NOT NULL,
    zorglijn integer,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    organisatie bigint NOT NULL,
    version bigint,
    categorie character varying(50),
    naam character varying(100) NOT NULL,
    authorisatieniveau character varying(255) NOT NULL,
    rechtensoort character varying(255) NOT NULL,
    CONSTRAINT rol_authorisatieniveau_check CHECK (((authorisatieniveau)::text = ANY ((ARRAY['SUPER'::character varying, 'APPLICATIE'::character varying, 'REST'::character varying])::text[]))),
    CONSTRAINT rol_rechtensoort_check CHECK (((rechtensoort)::text = ANY ((ARRAY['BEHEER'::character varying, 'BESTUUR'::character varying, 'INSTELLING'::character varying, 'DEELNEMER'::character varying, 'OUDER'::character varying, 'ONDERVRAAGDE'::character varying, 'DIGITAALAANMELDER'::character varying, 'UPLOADER'::character varying, 'EXTERNEORGANISATIE'::character varying, 'ANONIEM'::character varying])::text[])))
);


ALTER TABLE public.rol OWNER TO postgres;

--
-- Name: samenvoegenhtmlconfig; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.samenvoegenhtmlconfig (
    begindatum date NOT NULL,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    samenvoegentot date,
    samenvoegenvanaf date,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    categoryproperty character varying(255) NOT NULL,
    graphtype character varying(255) NOT NULL,
    CONSTRAINT samenvoegenhtmlconfig_categoryproperty_check CHECK (((categoryproperty)::text = ANY ((ARRAY['WERKPROCESSEN'::character varying, 'COMPETENTIES'::character varying])::text[]))),
    CONSTRAINT samenvoegenhtmlconfig_graphtype_check CHECK (((graphtype)::text = ANY ((ARRAY['BAR'::character varying, 'BARCLUSTER'::character varying, 'BOXPLOT'::character varying, 'SPIDER'::character varying])::text[])))
);


ALTER TABLE public.samenvoegenhtmlconfig OWNER TO postgres;

--
-- Name: samenvoegenpdfconfig; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.samenvoegenpdfconfig (
    begindatum date NOT NULL,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    samenvoegentot date,
    samenvoegenvanaf date,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    categoryaggregation character varying(255) NOT NULL,
    categoryproperty character varying(255) NOT NULL,
    graphtype character varying(255) NOT NULL,
    CONSTRAINT samenvoegenpdfconfig_categoryaggregation_check CHECK (((categoryaggregation)::text = ANY ((ARRAY['WERKPROCESSEN'::character varying, 'KERNTAKEN'::character varying])::text[]))),
    CONSTRAINT samenvoegenpdfconfig_categoryproperty_check CHECK (((categoryproperty)::text = ANY ((ARRAY['WERKPROCESSEN'::character varying, 'COMPETENTIES'::character varying])::text[]))),
    CONSTRAINT samenvoegenpdfconfig_graphtype_check CHECK (((graphtype)::text = ANY ((ARRAY['BAR'::character varying, 'BARCLUSTER'::character varying, 'BOXPLOT'::character varying, 'SPIDER'::character varying])::text[])))
);


ALTER TABLE public.samenvoegenpdfconfig OWNER TO postgres;

--
-- Name: schaal; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schaal (
    aantaldecimalen integer,
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    maximum numeric(20,10),
    minimum numeric(20,10),
    minimumvoorbehaald numeric(20,10),
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    naam character varying(100) NOT NULL,
    schaaltype character varying(255) NOT NULL,
    CONSTRAINT schaal_schaaltype_check CHECK (((schaaltype)::text = ANY ((ARRAY['Cijfer'::character varying, 'Tekstueel'::character varying])::text[])))
);


ALTER TABLE public.schaal OWNER TO postgres;

--
-- Name: schaalwaarde; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schaalwaarde (
    behaald boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    nominalewaarde numeric(20,10) NOT NULL,
    totcijfer numeric(20,10),
    vanafcijfer numeric(20,10),
    volgnummer integer NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    schaal bigint NOT NULL,
    version bigint,
    externewaarde character varying(10) NOT NULL,
    internewaarde character varying(10) NOT NULL,
    naam character varying(100) NOT NULL
);


ALTER TABLE public.schaalwaarde OWNER TO postgres;

--
-- Name: schooladvies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schooladvies (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    naam character varying(100) NOT NULL
);


ALTER TABLE public.schooladvies OWNER TO postgres;

--
-- Name: scoreschaalwaarde; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.scoreschaalwaarde (
    gearchiveerd boolean NOT NULL,
    totscore integer NOT NULL,
    vanafscore integer NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    toets bigint NOT NULL,
    version bigint,
    waarde bigint NOT NULL,
    advies character varying(1000)
);


ALTER TABLE public.scoreschaalwaarde OWNER TO postgres;

--
-- Name: sessie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sessie (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    account bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    logintime timestamp(6) without time zone NOT NULL,
    organisatie bigint,
    version bigint
);


ALTER TABLE public.sessie OWNER TO postgres;

--
-- Name: signaal; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.signaal (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    datumgelezen timestamp(6) without time zone,
    event bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    ontvanger bigint NOT NULL,
    organisatie bigint NOT NULL,
    version bigint
);


ALTER TABLE public.signaal OWNER TO postgres;

--
-- Name: soortcontactgegeven; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.soortcontactgegeven (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    code character varying(10) NOT NULL,
    naam character varying(100) NOT NULL,
    standaardcontactgegeven character varying(255),
    typecontactgegeven character varying(255) NOT NULL,
    CONSTRAINT soortcontactgegeven_standaardcontactgegeven_check CHECK (((standaardcontactgegeven)::text = ANY ((ARRAY['StandaardTonenBijPersoon'::character varying, 'StandaardTonenBijOrganisatie'::character varying, 'StandaardTonen'::character varying])::text[]))),
    CONSTRAINT soortcontactgegeven_typecontactgegeven_check CHECK (((typecontactgegeven)::text = ANY ((ARRAY['Overig'::character varying, 'Telefoon'::character varying, 'Fax'::character varying, 'Mobieltelefoon'::character varying, 'Email'::character varying, 'Homepage'::character varying])::text[])))
);


ALTER TABLE public.soortcontactgegeven OWNER TO postgres;

--
-- Name: soortcontract; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.soortcontract (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    inburgering boolean,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    code character varying(10) NOT NULL,
    naam character varying(100) NOT NULL
);


ALTER TABLE public.soortcontract OWNER TO postgres;

--
-- Name: COLUMN soortcontract.inburgering; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.soortcontract.inburgering IS 'Geeft aan of contracten van deze soort inburgeringscontracten zijn. Inburgeringscontracten hebben extra velden t.b.v. het Kermerk Inburgeren.';


--
-- Name: soortcontractverplichting; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.soortcontractverplichting (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    code character varying(10) NOT NULL,
    naam character varying(100) NOT NULL
);


ALTER TABLE public.soortcontractverplichting OWNER TO postgres;

--
-- Name: soortexterneorganisatie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.soortexterneorganisatie (
    actief boolean NOT NULL,
    brin boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    tonenbijvooropleiding boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint,
    version bigint,
    code character varying(10) NOT NULL,
    naam character varying(50) NOT NULL
);


ALTER TABLE public.soortexterneorganisatie OWNER TO postgres;

--
-- Name: soortonderwijsproduct; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.soortonderwijsproduct (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    stage boolean NOT NULL,
    summatief boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    code character varying(10) NOT NULL,
    naam character varying(100) NOT NULL
);


ALTER TABLE public.soortonderwijsproduct OWNER TO postgres;

--
-- Name: soortorgehd; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.soortorgehd (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    code character varying(10) NOT NULL,
    naam character varying(100) NOT NULL
);


ALTER TABLE public.soortorgehd OWNER TO postgres;

--
-- Name: soortpraktijklokaal; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.soortpraktijklokaal (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    code character varying(10) NOT NULL,
    naam character varying(100) NOT NULL
);


ALTER TABLE public.soortpraktijklokaal OWNER TO postgres;

--
-- Name: soortproductregel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.soortproductregel (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    volgnummer integer NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint,
    taxonomie bigint NOT NULL,
    version bigint,
    diplomanaam character varying(30) NOT NULL,
    naam character varying(30) NOT NULL
);


ALTER TABLE public.soortproductregel OWNER TO postgres;

--
-- Name: soortvooropleiding; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.soortvooropleiding (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    code character varying(10) NOT NULL,
    naam character varying(100) NOT NULL,
    soortonderwijsmetdiploma character varying(255) NOT NULL,
    soortonderwijszonderdiploma character varying(255) NOT NULL,
    CONSTRAINT soortvooropleiding_soortonderwijsmetdiploma_check CHECK (((soortonderwijsmetdiploma)::text = ANY ((ARRAY['Geen'::character varying, 'Basisonderwijs'::character varying, 'Basisvorming'::character varying, 'VMBO'::character varying, 'VMBOTL'::character varying, 'HAVO'::character varying, 'VWO'::character varying, 'MBO12'::character varying, 'MBO34'::character varying, 'PropHBO'::character varying, 'HBO'::character varying, 'Colloquium'::character varying, 'BeschikkingWO'::character varying, 'PropWO'::character varying, 'Bachelor'::character varying, 'Master'::character varying])::text[]))),
    CONSTRAINT soortvooropleiding_soortonderwijszonderdiploma_check CHECK (((soortonderwijszonderdiploma)::text = ANY ((ARRAY['Geen'::character varying, 'Basisonderwijs'::character varying, 'Basisvorming'::character varying, 'VMBO'::character varying, 'VMBOTL'::character varying, 'HAVO'::character varying, 'VWO'::character varying, 'MBO12'::character varying, 'MBO34'::character varying, 'PropHBO'::character varying, 'HBO'::character varying, 'Colloquium'::character varying, 'BeschikkingWO'::character varying, 'PropWO'::character varying, 'Bachelor'::character varying, 'Master'::character varying])::text[])))
);


ALTER TABLE public.soortvooropleiding OWNER TO postgres;

--
-- Name: soortvooropleidingbuitenlands; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.soortvooropleidingbuitenlands (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    land bigint NOT NULL,
    version bigint,
    code character varying(10) NOT NULL,
    naam character varying(120) NOT NULL
);


ALTER TABLE public.soortvooropleidingbuitenlands OWNER TO postgres;

--
-- Name: soortvooropleidingho; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.soortvooropleidingho (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    version bigint,
    code character varying(10) NOT NULL,
    naam character varying(100) NOT NULL
);


ALTER TABLE public.soortvooropleidingho OWNER TO postgres;

--
-- Name: specifiekevraag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.specifiekevraag (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    inschrijvingsverzoek bigint,
    organisatie bigint NOT NULL,
    version bigint,
    vraagcode character varying(15) NOT NULL,
    vraag character varying(350) NOT NULL
);


ALTER TABLE public.specifiekevraag OWNER TO postgres;

--
-- Name: specifiekevraagantwoord; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.specifiekevraagantwoord (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    specifiekevraag bigint,
    version bigint,
    antwoordcode character varying(15) NOT NULL,
    antwoord character varying(350) NOT NULL
);


ALTER TABLE public.specifiekevraagantwoord OWNER TO postgres;

--
-- Name: sslcertificaat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sslcertificaat (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    subject character varying(255) NOT NULL,
    certificaat oid NOT NULL
);


ALTER TABLE public.sslcertificaat OWNER TO postgres;

--
-- Name: standaardtoetscodefilter; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.standaardtoetscodefilter (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    cohort bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    opleiding bigint NOT NULL,
    organisatie bigint NOT NULL,
    toetscodefilter bigint NOT NULL,
    version bigint
);


ALTER TABLE public.standaardtoetscodefilter OWNER TO postgres;

--
-- Name: studielinkbericht; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.studielinkbericht (
    gearchiveerd boolean NOT NULL,
    ontvanger character varying(4) NOT NULL,
    verzender character varying(4) NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    deelnemer bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    inschrijvingsverzoek bigint,
    organisatie bigint NOT NULL,
    version bigint,
    type character varying(50) NOT NULL,
    xmlresponse oid
);


ALTER TABLE public.studielinkbericht OWNER TO postgres;

--
-- Name: taaksoort; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.taaksoort (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    locatie bigint,
    organisatie bigint NOT NULL,
    organisatieeenheid bigint NOT NULL,
    version bigint,
    naam character varying(41) NOT NULL
);


ALTER TABLE public.taaksoort OWNER TO postgres;

--
-- Name: taalkeuze; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.taalkeuze (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    taal bigint NOT NULL,
    verbintenis bigint NOT NULL,
    version bigint
);


ALTER TABLE public.taalkeuze OWNER TO postgres;

--
-- Name: taalscore; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.taalscore (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    meeteenheidwaarde bigint NOT NULL,
    organisatie bigint,
    taalbeoordeling bigint NOT NULL,
    taalvaardigheid bigint NOT NULL,
    version bigint
);


ALTER TABLE public.taalscore OWNER TO postgres;

--
-- Name: taalscoreniveauverzameling; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.taalscoreniveauverzameling (
    datum date,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    deelnemer bigint,
    id bigint NOT NULL,
    medewerker bigint,
    meeteenheid bigint NOT NULL,
    taal bigint,
    taaltype bigint,
    uitstroom bigint,
    version bigint,
    dtype character varying(31) NOT NULL,
    mboniveau character varying(255),
    CONSTRAINT taalscoreniveauverzameling_dtype_check CHECK (((dtype)::text = ANY ((ARRAY['TaalvaardigheidseisLlb'::character varying, 'Taalbeoordeling'::character varying, 'Taalvaardigheidseis'::character varying])::text[]))),
    CONSTRAINT taalscoreniveauverzameling_mboniveau_check CHECK (((mboniveau)::text = ANY ((ARRAY['Niveau1'::character varying, 'Niveau2'::character varying, 'Niveau3'::character varying, 'Niveau4'::character varying])::text[])))
);


ALTER TABLE public.taalscoreniveauverzameling OWNER TO postgres;

--
-- Name: taaltype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.taaltype (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    version bigint,
    titel character varying(256) NOT NULL
);


ALTER TABLE public.taaltype OWNER TO postgres;

--
-- Name: taaltypekoppel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.taaltypekoppel (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint,
    taal bigint NOT NULL,
    type bigint NOT NULL,
    version bigint
);


ALTER TABLE public.taaltypekoppel OWNER TO postgres;

--
-- Name: taalvaardigheid; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.taalvaardigheid (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    version bigint,
    titel character varying(255)
);


ALTER TABLE public.taalvaardigheid OWNER TO postgres;

--
-- Name: taxonomieelement; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.taxonomieelement (
    begindatum date NOT NULL,
    brinkenniscentrum character varying(4),
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    hoofdstuk integer,
    lwoo boolean,
    nummer integer,
    prijsfactor numeric(20,10),
    studiebelastingsuren integer,
    uitzonderlijk boolean NOT NULL,
    volgnummer integer NOT NULL,
    wettelijkeeisen boolean,
    code character varying(5) NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    competentie bigint,
    competentiematrix bigint,
    deelnemer bigint,
    dossier bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    kerntaak bigint,
    lwootaxonomieelement bigint,
    meeteenheid bigint,
    organisatie bigint,
    parent bigint,
    taxonomie bigint,
    taxonomieelementtype bigint NOT NULL,
    version bigint,
    werkproces bigint,
    bronwettelijkeeisen character varying(20),
    codecoordinatiepunt character varying(20),
    externecode character varying(20),
    dtype character varying(31) NOT NULL,
    afkorting character varying(50) NOT NULL,
    naamkenniscentrum character varying(100),
    diplomanaam character varying(200),
    internationalenaam character varying(200),
    naam character varying(200) NOT NULL,
    taxonomiecode character varying(200) NOT NULL,
    zoekparentcode character varying(201) NOT NULL,
    sorteercode character varying(1000) NOT NULL,
    niveau character varying(255),
    profiel character varying(255),
    sector character varying(255),
    soortopleiding character varying(255),
    titel character varying(255),
    uitstroomtype character varying(255),
    indicator oid,
    omschrijving oid,
    resultaat oid,
    CONSTRAINT taxonomieelement_check CHECK ((((dtype)::text <> 'Uitstroom'::text) OR (nummer IS NOT NULL))),
    CONSTRAINT taxonomieelement_check1 CHECK ((((dtype)::text <> 'Kerntaak'::text) OR (nummer IS NOT NULL))),
    CONSTRAINT taxonomieelement_dtype_check CHECK (((dtype)::text = ANY ((ARRAY['Kwalificatiedossier'::character varying, 'VrijeMatrix'::character varying, 'Uitstroom'::character varying, 'LLBMatrix'::character varying, 'Opleidingsdomein'::character varying, 'Diplomagebied'::character varying, 'Kwalificatie'::character varying, 'DoelInburgering'::character varying, 'Elementcode'::character varying, 'BasiseducatieElementcode'::character varying, 'CrohoOpleiding'::character varying, 'Werkproces'::character varying, 'Deelkwalificatie'::character varying, 'InburgeringExamenonderdeel'::character varying, 'Leerpunt'::character varying, 'LandelijkVak'::character varying, 'BasiseducatieVak'::character varying, 'Kerntaak'::character varying, 'Verbintenisgebied'::character varying, 'Deelgebied'::character varying, 'Taxonomie'::character varying])::text[]))),
    CONSTRAINT taxonomieelement_niveau_check CHECK (((niveau)::text = ANY ((ARRAY['Niveau1'::character varying, 'Niveau2'::character varying, 'Niveau3'::character varying, 'Niveau4'::character varying])::text[]))),
    CONSTRAINT taxonomieelement_profiel_check CHECK (((profiel)::text = ANY ((ARRAY['NT'::character varying, 'NG'::character varying, 'EM'::character varying, 'CM'::character varying, 'NTNG'::character varying, 'NTEM'::character varying, 'NTCM'::character varying, 'NGEM'::character varying, 'NGCM'::character varying, 'EMCM'::character varying])::text[]))),
    CONSTRAINT taxonomieelement_sector_check CHECK (((sector)::text = ANY ((ARRAY['Techniek'::character varying, 'ZorgEnWelzijn'::character varying, 'Economie'::character varying, 'Landbouw'::character varying])::text[]))),
    CONSTRAINT taxonomieelement_soortopleiding_check CHECK (((soortopleiding)::text = ANY ((ARRAY['Assistentopleiding'::character varying, 'Basisberoepsopleiding'::character varying, 'Middenkaderopleiding'::character varying, 'Specialistenopleiding'::character varying, 'Vakopleiding'::character varying])::text[]))),
    CONSTRAINT taxonomieelement_uitstroomtype_check CHECK (((uitstroomtype)::text = ANY ((ARRAY['StandaardUitstroom'::character varying, 'DossierUitstroom'::character varying])::text[])))
);


ALTER TABLE public.taxonomieelement OWNER TO postgres;

--
-- Name: taxonomieelementmboleerweg; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.taxonomieelementmboleerweg (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    taxonomieelement bigint NOT NULL,
    version bigint,
    mboleerweg character varying(255) NOT NULL,
    CONSTRAINT taxonomieelementmboleerweg_mboleerweg_check CHECK (((mboleerweg)::text = ANY ((ARRAY['BOL'::character varying, 'BBL'::character varying, 'COL'::character varying, 'CBL'::character varying])::text[])))
);


ALTER TABLE public.taxonomieelementmboleerweg OWNER TO postgres;

--
-- Name: taxonomieelementtype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.taxonomieelementtype (
    diplomeerbaar boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    inschrijfbaar boolean NOT NULL,
    volgnummer integer NOT NULL,
    afkorting character varying(5) NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint,
    parent bigint,
    taxonomie bigint,
    version bigint,
    naam character varying(100) NOT NULL,
    soort character varying(255) NOT NULL,
    CONSTRAINT taxonomieelementtype_soort_check CHECK (((soort)::text = ANY ((ARRAY['Taxonomie'::character varying, 'Verbintenisgebied'::character varying, 'Deelgebied'::character varying])::text[])))
);


ALTER TABLE public.taxonomieelementtype OWNER TO postgres;

--
-- Name: team; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.team (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    code character varying(10) NOT NULL,
    naam character varying(100) NOT NULL
);


ALTER TABLE public.team OWNER TO postgres;

--
-- Name: tekenbevoegdheid; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tekenbevoegdheid (
    begindatum date NOT NULL,
    bpvovereenkomst boolean NOT NULL,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    onderwijsovereenkomst boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    medewerker bigint NOT NULL,
    organisatie bigint NOT NULL,
    organisatieeenheid bigint NOT NULL,
    version bigint
);


ALTER TABLE public.tekenbevoegdheid OWNER TO postgres;

--
-- Name: testcategorie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.testcategorie (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint,
    version bigint,
    code character varying(10) NOT NULL,
    naam character varying(50) NOT NULL
);


ALTER TABLE public.testcategorie OWNER TO postgres;

--
-- Name: testdefinitie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.testdefinitie (
    actief boolean NOT NULL,
    besprekentonen boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    afspraaktype bigint NOT NULL,
    categorie bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    naam character varying(100) NOT NULL
);


ALTER TABLE public.testdefinitie OWNER TO postgres;

--
-- Name: testveld; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.testveld (
    gearchiveerd boolean NOT NULL,
    hoofdscoreveld boolean NOT NULL,
    maximumwaarde integer,
    minimumwaarde integer,
    verplicht boolean NOT NULL,
    volgnummer integer NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint,
    testdefinitie bigint NOT NULL,
    version bigint,
    naam character varying(100) NOT NULL,
    type character varying(255) NOT NULL,
    CONSTRAINT testveld_type_check CHECK (((type)::text = ANY ((ARRAY['Tekst'::character varying, 'Numeriek'::character varying])::text[])))
);


ALTER TABLE public.testveld OWNER TO postgres;

--
-- Name: toegekendhulpmiddel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.toegekendhulpmiddel (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    bijzonderheid bigint NOT NULL,
    hulpmiddel bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint
);


ALTER TABLE public.toegekendhulpmiddel OWNER TO postgres;

--
-- Name: toegestaandeelgebied; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.toegestaandeelgebied (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    deelgebied bigint NOT NULL,
    id bigint NOT NULL,
    productregel bigint NOT NULL,
    version bigint
);


ALTER TABLE public.toegestaandeelgebied OWNER TO postgres;

--
-- Name: toegestaanhulpmiddel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.toegestaanhulpmiddel (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    bijzonderheidcategorie bigint NOT NULL,
    hulpmiddel bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint,
    version bigint
);


ALTER TABLE public.toegestaanhulpmiddel OWNER TO postgres;

--
-- Name: toegestaanonderwijsproduct; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.toegestaanonderwijsproduct (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    onderwijsproduct bigint NOT NULL,
    organisatie bigint NOT NULL,
    productregel bigint NOT NULL,
    version bigint
);


ALTER TABLE public.toegestaanonderwijsproduct OWNER TO postgres;

--
-- Name: toegestanebeginstatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.toegestanebeginstatus (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    examenstatus bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint,
    toegestaneexamenstatusovergang bigint NOT NULL,
    version bigint
);


ALTER TABLE public.toegestanebeginstatus OWNER TO postgres;

--
-- Name: toegestanestatussoort; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.toegestanestatussoort (
    defaultstatus boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    trajectstatussoort bigint NOT NULL,
    trajectsoort bigint NOT NULL,
    version bigint
);


ALTER TABLE public.toegestanestatussoort OWNER TO postgres;

--
-- Name: toegexamenstatusovergang; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.toegexamenstatusovergang (
    bepaaltdatumuitslag boolean NOT NULL,
    examennummerstoekennen boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    handmatigopmerkingeninvoeren boolean NOT NULL,
    tijdvakaangeven boolean NOT NULL,
    volgnummer integer NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    afgewezenexamenstatus bigint,
    examenworkflow bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    naarexamenstatus bigint,
    organisatie bigint,
    version bigint,
    actie character varying(100) NOT NULL,
    actieindividueel character varying(100) NOT NULL,
    actieindividueelkort character varying(100)
);


ALTER TABLE public.toegexamenstatusovergang OWNER TO postgres;

--
-- Name: toets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.toets (
    aantalherkansingen integer,
    alternatiefcombinerenmethoofd boolean NOT NULL,
    alternatiefresultaatmogelijk boolean NOT NULL,
    automatischeweging boolean NOT NULL,
    compenseerbaarvanaf numeric(20,10),
    eindtoets boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    handmatiginleveren boolean NOT NULL,
    maxaantalingevuld integer,
    maxaantalnietbehaald integer,
    minaantalingevuld integer,
    minstudiepuntenvoorbehaald integer,
    overschrijfbaar boolean NOT NULL,
    referentieversie integer,
    samengesteld boolean NOT NULL,
    samengesteldmetherkansing boolean NOT NULL,
    samengesteldmetvarianten boolean NOT NULL,
    scoreschaallengtetijdvak1 integer,
    scoreschaallengtetijdvak2 integer,
    scoreschaallengtetijdvak3 integer,
    scoreschaalnormeringtijdvak1 numeric(20,10),
    scoreschaalnormeringtijdvak2 numeric(20,10),
    scoreschaalnormeringtijdvak3 numeric(20,10),
    studiepunten integer,
    variantvoorpoging integer,
    verplicht boolean NOT NULL,
    verwijsbaar boolean NOT NULL,
    volgnummer integer NOT NULL,
    weging integer,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    bevrorenpogingen bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    parent bigint,
    resultaatstructuur bigint NOT NULL,
    schaal bigint NOT NULL,
    version bigint,
    code character varying(10) NOT NULL,
    referentiecode character varying(20),
    naam character varying(100) NOT NULL,
    codepath character varying(200) NOT NULL,
    formule character varying(1000),
    rekenregel character varying(255) NOT NULL,
    scorebijherkansing character varying(255),
    scoreschaal character varying(255) NOT NULL,
    soort character varying(255) NOT NULL,
    CONSTRAINT toets_rekenregel_check CHECK (((rekenregel)::text = ANY ((ARRAY['Gemiddelde'::character varying, 'Prioriteit'::character varying, 'Formule'::character varying])::text[]))),
    CONSTRAINT toets_scorebijherkansing_check CHECK (((scorebijherkansing)::text = ANY ((ARRAY['Hoogste'::character varying, 'Laatste'::character varying])::text[]))),
    CONSTRAINT toets_scoreschaal_check CHECK (((scoreschaal)::text = ANY ((ARRAY['Geen'::character varying, 'Lineair'::character varying, 'Tabel'::character varying])::text[]))),
    CONSTRAINT toets_soort_check CHECK (((soort)::text = ANY ((ARRAY['Toets'::character varying, 'Schoolexamen'::character varying, 'CentraalExamen'::character varying, 'Spreken'::character varying, 'Luisteren'::character varying, 'Lezen'::character varying, 'Schrijven'::character varying, 'Gesprekken'::character varying, 'Instroomniveau'::character varying, 'BehaaldNiveau'::character varying, 'Getallen'::character varying, 'RuimteVorm'::character varying, 'Gegevensverwerking'::character varying, 'Verbanden'::character varying, 'ExamenonderdeelInburgering'::character varying])::text[])))
);


ALTER TABLE public.toets OWNER TO postgres;

--
-- Name: toetscodefilter; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.toetscodefilter (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    medewerker bigint,
    organisatie bigint NOT NULL,
    version bigint,
    naam character varying(100) NOT NULL,
    toetscodes character varying(1000) NOT NULL
);


ALTER TABLE public.toetscodefilter OWNER TO postgres;

--
-- Name: toetscodefilterorgehdloc; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.toetscodefilterorgehdloc (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    locatie bigint NOT NULL,
    organisatie bigint NOT NULL,
    organisatieeenheid bigint NOT NULL,
    toetscodefilter bigint,
    version bigint
);


ALTER TABLE public.toetscodefilterorgehdloc OWNER TO postgres;

--
-- Name: toetsverwijzing; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.toetsverwijzing (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    lezenuit bigint,
    organisatie bigint NOT NULL,
    schrijvenin bigint,
    version bigint
);


ALTER TABLE public.toetsverwijzing OWNER TO postgres;

--
-- Name: traject; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.traject (
    begindatum date NOT NULL,
    beoogdeeinddatum date,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    vertrouwelijk boolean NOT NULL,
    zorglijn integer,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    template bigint,
    verantwoordelijke bigint NOT NULL,
    deelnemer bigint NOT NULL,
    eindhandelingtemplate bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    trajectsoort bigint NOT NULL,
    trajectstatussoort bigint NOT NULL,
    verbintenis bigint,
    version bigint,
    omschrijving character varying(1024) NOT NULL,
    titel character varying(255) NOT NULL,
    aanleiding oid,
    beginsituatie oid,
    doelen oid,
    handelingen oid
);


ALTER TABLE public.traject OWNER TO postgres;

--
-- Name: COLUMN traject.template; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.traject.template IS 'Met trajecttemplate kunnen de meeste velden van een traject automatisch gevuld worden. Let op: bij het wijzigen van dit veld zullen waardes overschreven worden. Koppelingen naar aanleidingen zullen alleen gelegd worden indien de benodigde rechten aanwezig zijn.';


--
-- Name: trajectbeghandelingtemplate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trajectbeghandelingtemplate (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    begeleidingshandeling bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    trajecttemplate bigint NOT NULL,
    version bigint
);


ALTER TABLE public.trajectbeghandelingtemplate OWNER TO postgres;

--
-- Name: trajectsoort; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trajectsoort (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    handelingsplan boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    defaultgespreksoort bigint,
    defaulttaaksoort bigint,
    defaulttestdefinitie bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    locatie bigint,
    organisatie bigint NOT NULL,
    organisatieeenheid bigint NOT NULL,
    version bigint,
    kwadrant character varying(255) NOT NULL,
    naam character varying(255) NOT NULL,
    beginsituatietemplate oid,
    doelentemplate oid,
    handelingentemplate oid,
    CONSTRAINT trajectsoort_kwadrant_check CHECK (((kwadrant)::text = ANY ((ARRAY['Studievoortgang'::character varying, 'Gedrag'::character varying, 'Capaciteiten'::character varying, 'Ontwikkeling'::character varying])::text[])))
);


ALTER TABLE public.trajectsoort OWNER TO postgres;

--
-- Name: trajectstatusovergang; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trajectstatusovergang (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    datumtijd timestamp(6) without time zone NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    medewerker bigint NOT NULL,
    naarstatus bigint NOT NULL,
    organisatie bigint NOT NULL,
    traject bigint NOT NULL,
    vanstatus bigint,
    version bigint
);


ALTER TABLE public.trajectstatusovergang OWNER TO postgres;

--
-- Name: trajectstatussoort; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trajectstatussoort (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    trajectafgesloten boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    omschrijving character varying(255) NOT NULL
);


ALTER TABLE public.trajectstatussoort OWNER TO postgres;

--
-- Name: trajecttemplate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trajecttemplate (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    opeerstedagschooljaar boolean NOT NULL,
    tijdsduuraantal integer NOT NULL,
    zorglijn integer,
    created_at timestamp(6) without time zone,
    created_by bigint,
    eindhandelingtemplate bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    automatischekoppeling bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    locatie bigint,
    organisatie bigint NOT NULL,
    organisatieeenheid bigint NOT NULL,
    trajectsoort bigint NOT NULL,
    version bigint,
    naam character varying(128) NOT NULL,
    omschrijving character varying(512) NOT NULL,
    tijdsduureenheid character varying(255) NOT NULL,
    CONSTRAINT trajecttemplate_tijdsduureenheid_check CHECK (((tijdsduureenheid)::text = ANY ((ARRAY['Dagen'::character varying, 'Weken'::character varying, 'Maanden'::character varying, 'Jaren'::character varying])::text[])))
);


ALTER TABLE public.trajecttemplate OWNER TO postgres;

--
-- Name: trajecttemplatekoppeling; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trajecttemplatekoppeling (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    kenmerk bigint,
    opleiding bigint,
    organisatie bigint NOT NULL,
    organisatieeenheid bigint,
    trajtemplautokopp bigint NOT NULL,
    version bigint,
    dtype character varying(31) NOT NULL,
    CONSTRAINT trajecttemplatekoppeling_dtype_check CHECK (((dtype)::text = ANY ((ARRAY['TTKoppelingKenmerk'::character varying, 'TTKoppelingOpleiding'::character varying, 'TTKoppelingOrganisatie'::character varying])::text[])))
);


ALTER TABLE public.trajecttemplatekoppeling OWNER TO postgres;

--
-- Name: trajectuitvoerder; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trajectuitvoerder (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    medewerker bigint NOT NULL,
    traject bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint
);


ALTER TABLE public.trajectuitvoerder OWNER TO postgres;

--
-- Name: trajtemplautokopp; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trajtemplautokopp (
    alleenintakestatussen boolean,
    alleennieuwedeelnemers boolean,
    datumbeschikbaar date NOT NULL,
    datumeindebeschikbaar date,
    gearchiveerd boolean NOT NULL,
    indicatiegehandicapt boolean,
    indicatielwoo boolean,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint
);


ALTER TABLE public.trajtemplautokopp OWNER TO postgres;

--
-- Name: typefinanciering; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.typefinanciering (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    code character varying(10) NOT NULL,
    naam character varying(100) NOT NULL
);


ALTER TABLE public.typefinanciering OWNER TO postgres;

--
-- Name: typelocatie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.typelocatie (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    code character varying(10) NOT NULL,
    naam character varying(100) NOT NULL
);


ALTER TABLE public.typelocatie OWNER TO postgres;

--
-- Name: typetoets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.typetoets (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    code character varying(10) NOT NULL,
    naam character varying(100) NOT NULL
);


ALTER TABLE public.typetoets OWNER TO postgres;

--
-- Name: uitkomstintakegesprek; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.uitkomstintakegesprek (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    succesvol boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    code character varying(10) NOT NULL,
    naam character varying(100) NOT NULL
);


ALTER TABLE public.uitkomstintakegesprek OWNER TO postgres;

--
-- Name: vaardigheid; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vaardigheid (
    gearchiveerd boolean NOT NULL,
    nummer integer NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    dossier bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint,
    version bigint,
    titel character varying(256) NOT NULL
);


ALTER TABLE public.vaardigheid OWNER TO postgres;

--
-- Name: vakantie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vakantie (
    begindatum date NOT NULL,
    einddatum date NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    basisrooster bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    naam character varying(60) NOT NULL
);


ALTER TABLE public.vakantie OWNER TO postgres;

--
-- Name: vasco_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vasco_tokens (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    gebruiker bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    applicatie character varying(32) NOT NULL,
    serienummer character varying(32) NOT NULL,
    digipassdata character varying(248) NOT NULL,
    initieledata character varying(248) NOT NULL,
    status character varying(255) NOT NULL,
    CONSTRAINT vasco_tokens_status_check CHECK (((status)::text = ANY ((ARRAY['Beschikbaar'::character varying, 'Uitgegeven'::character varying, 'Geblokkeerd'::character varying, 'Defect'::character varying])::text[])))
);


ALTER TABLE public.vasco_tokens OWNER TO postgres;

--
-- Name: veldwaarde; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.veldwaarde (
    gearchiveerd boolean NOT NULL,
    intwaarde integer,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    test bigint NOT NULL,
    testveld bigint NOT NULL,
    version bigint,
    dtype character varying(31) NOT NULL,
    stringwaarde character varying(255),
    CONSTRAINT veldwaarde_dtype_check CHECK (((dtype)::text = ANY ((ARRAY['NumeriekeVeldwaarde'::character varying, 'TekstueleVeldwaarde'::character varying])::text[])))
);


ALTER TABLE public.veldwaarde OWNER TO postgres;

--
-- Name: verbintenis; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.verbintenis (
    begindatum date NOT NULL,
    contacturenperweek numeric(20,10),
    datumaanmelden date,
    datumakkoord date,
    datumdefinitief date,
    datumeersteactiviteit date,
    datumgeplaatst date,
    datumovereenkomstondertekend date,
    datumvoorlopig date,
    deelcursus boolean,
    einddatum date,
    einddatumnotnull date NOT NULL,
    examendatum date,
    gearchiveerd boolean NOT NULL,
    geplandeeinddatum date,
    indicatiegehandicapt boolean NOT NULL,
    negeerwettcollgeldvoorwaarden boolean,
    uitsluitenvanfacturatie boolean NOT NULL,
    volgnummer integer NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    brin bigint,
    brondatum timestamp(6) without time zone,
    cohort bigint,
    deelnemer bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    locatie bigint,
    opleiding bigint,
    organisatie bigint NOT NULL,
    organisatieeenheid bigint NOT NULL,
    overeenkomstnummer bigint NOT NULL,
    redenuitschrijving bigint,
    relevanteverbintenis bigint,
    relevantevooropleiding bigint,
    version bigint,
    vervolgonderwijs bigint,
    afwijkendeexternecode character varying(20),
    beginnivschrvaardigheden character varying(255),
    bekostigd character varying(255) NOT NULL,
    bronstatus character varying(255),
    eindnivschrvaardigheden character varying(255),
    intensiteit character varying(255),
    leerprofiel character varying(255),
    profielinburgering character varying(255),
    redeninburgering character varying(255),
    soortpraktijkexamen character varying(255),
    staatsexamentype character varying(255),
    status character varying(255) NOT NULL,
    vertrekstatus character varying(255),
    volgnummerinoudpakket character varying(255),
    toelichting oid,
    CONSTRAINT verbintenis_beginnivschrvaardigheden_check CHECK (((beginnivschrvaardigheden)::text = ANY ((ARRAY['Nul'::character varying, 'A1'::character varying, 'A2'::character varying, 'B1'::character varying, 'B2'::character varying, 'C1'::character varying, 'C2'::character varying])::text[]))),
    CONSTRAINT verbintenis_bekostigd_check CHECK (((bekostigd)::text = ANY ((ARRAY['Ja'::character varying, 'Nee'::character varying, 'Gedeeltelijk'::character varying])::text[]))),
    CONSTRAINT verbintenis_bronstatus_check CHECK (((bronstatus)::text = ANY ((ARRAY['Geen'::character varying, 'Wachtrij'::character varying, 'WachtrijWelInBron'::character varying, 'InBehandeling'::character varying, 'InBehandelingWelInBron'::character varying, 'Goedgekeurd'::character varying, 'Afgekeurd'::character varying, 'AfgekeurdWelInBron'::character varying])::text[]))),
    CONSTRAINT verbintenis_eindnivschrvaardigheden_check CHECK (((eindnivschrvaardigheden)::text = ANY ((ARRAY['Nul'::character varying, 'A1'::character varying, 'A2'::character varying, 'B1'::character varying, 'B2'::character varying, 'C1'::character varying, 'C2'::character varying])::text[]))),
    CONSTRAINT verbintenis_intensiteit_check CHECK (((intensiteit)::text = ANY ((ARRAY['Voltijd'::character varying, 'Deeltijd'::character varying])::text[]))),
    CONSTRAINT verbintenis_leerprofiel_check CHECK (((leerprofiel)::text = ANY ((ARRAY['P1a'::character varying, 'P1b'::character varying, 'P1c'::character varying, 'P2'::character varying, 'P3'::character varying, 'P4'::character varying])::text[]))),
    CONSTRAINT verbintenis_profielinburgering_check CHECK (((profielinburgering)::text = ANY ((ARRAY['OGO'::character varying, 'Werk'::character varying, 'Ondernemerschap'::character varying, 'MaatschappelijkeParticipatie'::character varying])::text[]))),
    CONSTRAINT verbintenis_redeninburgering_check CHECK (((redeninburgering)::text = ANY ((ARRAY['Inburgeringsplichtig'::character varying, 'Inburgeringsbehoeftig'::character varying])::text[]))),
    CONSTRAINT verbintenis_soortpraktijkexamen_check CHECK (((soortpraktijkexamen)::text = ANY ((ARRAY['Portfolio'::character varying, 'Assessment'::character varying, 'Combinatie'::character varying])::text[]))),
    CONSTRAINT verbintenis_staatsexamentype_check CHECK (((staatsexamentype)::text = ANY ((ARRAY['StaatsExamen1'::character varying, 'StaatsExamen2'::character varying])::text[]))),
    CONSTRAINT verbintenis_status_check CHECK (((status)::text = ANY ((ARRAY['Aangemeld'::character varying, 'Intake'::character varying, 'Voorlopig'::character varying, 'Volledig'::character varying, 'Afgedrukt'::character varying, 'Definitief'::character varying, 'Beeindigd'::character varying, 'Afgemeld'::character varying, 'Afgewezen'::character varying])::text[]))),
    CONSTRAINT verbintenis_vertrekstatus_check CHECK (((vertrekstatus)::text = ANY ((ARRAY['Vertrokken'::character varying, 'BevorderdVMBOBL'::character varying, 'BevorderdVMBOKL'::character varying, 'BevorderdVMBOGL'::character varying, 'BevorderdVMBOTL'::character varying, 'BevorderdHAVO'::character varying, 'BevorderdVWO'::character varying, 'NietBevorderd'::character varying, 'AndereOpleiding'::character varying, 'Geslaagd'::character varying, 'Afgewezen'::character varying])::text[])))
);


ALTER TABLE public.verbintenis OWNER TO postgres;

--
-- Name: COLUMN verbintenis.datumaanmelden; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.verbintenis.datumaanmelden IS 'Als verbintenis onder een inburgeringscontract valt, is dit de datum waarop de opdrachtgever de cursist heeft aangemeld. Nodig voor rapportage aan het keurmerk inburgering.';


--
-- Name: COLUMN verbintenis.datumakkoord; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.verbintenis.datumakkoord IS 'Als verbintenis NIET onder een inburgeringscontract valt, is dit de datum waarop de cursist de onderwijsovereenkomst heeft getekend. Nodig voor rapportage aan het keurmerk inburgering.';


--
-- Name: COLUMN verbintenis.negeerwettcollgeldvoorwaarden; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.verbintenis.negeerwettcollgeldvoorwaarden IS 'Breng voor deze verbintenis alleen wettelijk collegegeld in rekening, ook als de student niet aan de voorwaarden m.b.t. nationaliteit, woonadres of behaalde graad voldoet.';


--
-- Name: COLUMN verbintenis.uitsluitenvanfacturatie; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.verbintenis.uitsluitenvanfacturatie IS 'Zorgt dat de deelnemer op basis van deze verbintenis geen facturen meer krijgt, totdat dit veld is uitgeschakeld.';


--
-- Name: verbinteniscontract; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.verbinteniscontract (
    begindatum date NOT NULL,
    datumbeschikking date,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    contract bigint NOT NULL,
    extorgcontactpersoon bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    onderdeel bigint,
    organisatie bigint NOT NULL,
    verbintenis bigint NOT NULL,
    version bigint,
    externnummer character varying(255)
);


ALTER TABLE public.verbinteniscontract OWNER TO postgres;

--
-- Name: verbintenisfasecredits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.verbintenisfasecredits (
    bevroren boolean NOT NULL,
    credits numeric(20,10) NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    fase bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    verbintenis bigint NOT NULL,
    version bigint
);


ALTER TABLE public.verbintenisfasecredits OWNER TO postgres;

--
-- Name: verbintenisgebiedonderdeel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.verbintenisgebiedonderdeel (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    child bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint,
    parent bigint NOT NULL,
    version bigint
);


ALTER TABLE public.verbintenisgebiedonderdeel OWNER TO postgres;

--
-- Name: verblijfsvergunning; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.verblijfsvergunning (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    version bigint,
    code character varying(10) NOT NULL,
    naam character varying(125) NOT NULL
);


ALTER TABLE public.verblijfsvergunning OWNER TO postgres;

--
-- Name: verbruiksmiddel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.verbruiksmiddel (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    code character varying(10) NOT NULL,
    naam character varying(100) NOT NULL
);


ALTER TABLE public.verbruiksmiddel OWNER TO postgres;

--
-- Name: vertasigdefevconkoppel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vertasigdefevconkoppel (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    abonnementconfiguration bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    signaaldefinitie bigint NOT NULL,
    version bigint
);


ALTER TABLE public.vertasigdefevconkoppel OWNER TO postgres;

--
-- Name: vervolghandeling; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vervolghandeling (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    vervolg bigint NOT NULL,
    voorafgaand bigint NOT NULL
);


ALTER TABLE public.vervolghandeling OWNER TO postgres;

--
-- Name: vervolgonderwijs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vervolgonderwijs (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    code bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    naam character varying(100),
    plaats character varying(100),
    soortvervolgonderwijs character varying(255) NOT NULL,
    CONSTRAINT vervolgonderwijs_soortvervolgonderwijs_check CHECK (((soortvervolgonderwijs)::text = ANY ((ARRAY['Intern'::character varying, 'BRIN'::character varying, 'Overig'::character varying, 'Onbekend'::character varying])::text[])))
);


ALTER TABLE public.vervolgonderwijs OWNER TO postgres;

--
-- Name: verzuimtaaksignaaldefinitie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.verzuimtaaksignaaldefinitie (
    aantalweken integer NOT NULL,
    aantalwekenaaneen integer NOT NULL,
    aantalklokuren integer NOT NULL,
    gearchiveerd boolean NOT NULL,
    ongeoorlooft boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    omschrijving character varying(255),
    signaalnaam character varying(255),
    soortdeelnemer character varying(255),
    CONSTRAINT verzuimtaaksignaaldefinitie_soortdeelnemer_check CHECK (((soortdeelnemer)::text = ANY ((ARRAY['LEERPLICHTIG'::character varying, 'KWALIFICATIE_PLICHTIG'::character varying, 'VSV'::character varying, 'WTOS_WSF'::character varying, 'VANAF_23_JAAR'::character varying])::text[])))
);


ALTER TABLE public.verzuimtaaksignaaldefinitie OWNER TO postgres;

--
-- Name: vooropleiding; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vooropleiding (
    aantaljarenonderwijs integer,
    aantaljarenzelfinvullen boolean NOT NULL,
    begindatum date,
    citoscore integer,
    diplomabehaald boolean NOT NULL,
    einddatum date,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    deelnemer bigint NOT NULL,
    externeorganisatie bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    land bigint,
    organisatie bigint NOT NULL,
    schooladvies bigint,
    soortvooropleiding bigint,
    soortvooropleidingbuitenlands bigint,
    soortvooropleidingcroho bigint,
    soortvooropleidingho bigint,
    verificatiebrin bigint,
    verificatiedatum timestamp(6) without time zone,
    version bigint,
    verificatiedoormedewerker character varying(35),
    verificatiedoorinstelling character varying(70),
    naam character varying(100),
    plaats character varying(100),
    vooropleidingnaam character varying(100),
    soortorganisatie character varying(255) NOT NULL,
    verificatiestatus character varying(255),
    CONSTRAINT vooropleiding_soortorganisatie_check CHECK (((soortorganisatie)::text = ANY ((ARRAY['ExterneOrganisatie'::character varying, 'Buitenland'::character varying, 'Overig'::character varying])::text[]))),
    CONSTRAINT vooropleiding_verificatiestatus_check CHECK (((verificatiestatus)::text = ANY ((ARRAY['Afmelden'::character varying, 'CentrGeverifrd'::character varying, 'StudVolgtOpl'::character varying, 'NietGeverifrdIB'::character varying, 'GeenToest'::character varying, 'NietMogelijk'::character varying, 'ToestOnbekend'::character varying, 'DecentrlGeverifrdInst'::character varying, 'DecentrlGeverifrdIB'::character varying, 'NietGeverifrdIBInst'::character varying])::text[])))
);


ALTER TABLE public.vooropleiding OWNER TO postgres;

--
-- Name: vooropleidingsignaalcode; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vooropleidingsignaalcode (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    vooropleiding bigint,
    signaalcode character varying(255) NOT NULL,
    CONSTRAINT vooropleidingsignaalcode_signaalcode_check CHECK (((signaalcode)::text = ANY ((ARRAY['BrinNrOnglk'::character varying, 'DatumDimplomaOnglk'::character varying])::text[])))
);


ALTER TABLE public.vooropleidingsignaalcode OWNER TO postgres;

--
-- Name: vooropleidingvak; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vooropleidingvak (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    version bigint,
    code character varying(10) NOT NULL,
    naam character varying(100) NOT NULL
);


ALTER TABLE public.vooropleidingvak OWNER TO postgres;

--
-- Name: vooropleidingvakresultaat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vooropleidingvakresultaat (
    gearchiveerd boolean NOT NULL,
    letter character(1),
    score integer,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    vak bigint NOT NULL,
    version bigint,
    vooropleiding bigint NOT NULL,
    status character varying(255) NOT NULL,
    CONSTRAINT vooropleidingvakresultaat_status_check CHECK (((status)::text = ANY ((ARRAY['VakUitslagGeverif'::character varying, 'VakGeverif'::character varying, 'VakNietGeverif'::character varying, 'NietGeverif'::character varying])::text[])))
);


ALTER TABLE public.vooropleidingvakresultaat OWNER TO postgres;

--
-- Name: voortganghtmlconfig; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.voortganghtmlconfig (
    aantalbeoordelingen integer NOT NULL,
    begindatum date NOT NULL,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    includeevcevk boolean NOT NULL,
    includeinvidueleijkpunten boolean NOT NULL,
    includelokaalmaximum boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    categoryproperty character varying(255) NOT NULL,
    graphtype character varying(255) NOT NULL,
    CONSTRAINT voortganghtmlconfig_categoryproperty_check CHECK (((categoryproperty)::text = ANY ((ARRAY['WERKPROCESSEN'::character varying, 'COMPETENTIES'::character varying])::text[]))),
    CONSTRAINT voortganghtmlconfig_graphtype_check CHECK (((graphtype)::text = ANY ((ARRAY['BAR'::character varying, 'BARCLUSTER'::character varying, 'BOXPLOT'::character varying, 'SPIDER'::character varying])::text[])))
);


ALTER TABLE public.voortganghtmlconfig OWNER TO postgres;

--
-- Name: voortgangpdfconfig; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.voortgangpdfconfig (
    aantalbeoordelingen integer NOT NULL,
    begindatum date NOT NULL,
    einddatum date,
    einddatumnotnull date NOT NULL,
    gearchiveerd boolean NOT NULL,
    includeevcevk boolean NOT NULL,
    includeinvidueleijkpunten boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    categoryaggregation character varying(255) NOT NULL,
    categoryproperty character varying(255) NOT NULL,
    graphtype character varying(255) NOT NULL,
    CONSTRAINT voortgangpdfconfig_categoryaggregation_check CHECK (((categoryaggregation)::text = ANY ((ARRAY['WERKPROCESSEN'::character varying, 'KERNTAKEN'::character varying])::text[]))),
    CONSTRAINT voortgangpdfconfig_categoryproperty_check CHECK (((categoryproperty)::text = ANY ((ARRAY['WERKPROCESSEN'::character varying, 'COMPETENTIES'::character varying])::text[]))),
    CONSTRAINT voortgangpdfconfig_graphtype_check CHECK (((graphtype)::text = ANY ((ARRAY['BAR'::character varying, 'BARCLUSTER'::character varying, 'BOXPLOT'::character varying, 'SPIDER'::character varying])::text[])))
);


ALTER TABLE public.voortgangpdfconfig OWNER TO postgres;

--
-- Name: voorvoegsel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.voorvoegsel (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    version bigint,
    naam character varying(50) NOT NULL
);


ALTER TABLE public.voorvoegsel OWNER TO postgres;

--
-- Name: vrijveld; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vrijveld (
    actief boolean NOT NULL,
    dossierscherm boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    intakescherm boolean NOT NULL,
    uitgebreidzoeken boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    taxonomie bigint,
    version bigint,
    categorie character varying(255) NOT NULL,
    naam character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    CONSTRAINT vrijveld_categorie_check CHECK (((categorie)::text = ANY ((ARRAY['DEELNEMERPERSONALIA'::character varying, 'INTAKE'::character varying, 'VOOROPLEIDING'::character varying, 'VERBINTENIS'::character varying, 'PLAATSING'::character varying, 'UITSCHRIJVING'::character varying, 'RELATIE'::character varying, 'MEDEWERKERPERSONALIA'::character varying, 'MEDEWERKERAANSTELLING'::character varying, 'ONDERWIJSPRODUCT'::character varying, 'OPLEIDING'::character varying, 'EXTERNEORGANISATIE'::character varying, 'GROEP'::character varying, 'CONTRACT'::character varying, 'BPV_INSCHRIJVING'::character varying, 'DA_DEELNEMERPERSONALIA'::character varying, 'DA_INTAKE'::character varying, 'DA_VOOROPLEIDING'::character varying, 'DA_RELATIE'::character varying])::text[]))),
    CONSTRAINT vrijveld_type_check CHECK (((type)::text = ANY ((ARRAY['TEKST'::character varying, 'LANGETEKST'::character varying, 'DATUM'::character varying, 'NUMERIEK'::character varying, 'AANKRUISVAK'::character varying, 'KEUZELIJST'::character varying, 'MULTISELECTKEUZELIJST'::character varying])::text[])))
);


ALTER TABLE public.vrijveld OWNER TO postgres;

--
-- Name: vrijveldentiteit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vrijveldentiteit (
    checkwaarde boolean,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    bpvinschrijving bigint,
    contract bigint,
    datewaarde timestamp(6) without time zone,
    externeorganisatie bigint,
    groep bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    intakegesprek bigint,
    keuze bigint,
    medewerker bigint,
    numberwaarde bigint,
    onderwijsproduct bigint,
    opleiding bigint,
    organisatie bigint,
    persoon bigint,
    plaatsing bigint,
    relatie bigint,
    verbintenis bigint,
    version bigint,
    vooropleiding bigint,
    vrijveld bigint NOT NULL,
    dtype character varying(31) NOT NULL,
    textwaarde character varying(255),
    longtextwaarde oid,
    CONSTRAINT vrijveldentiteit_dtype_check CHECK (((dtype)::text = ANY ((ARRAY['MedewerkerVrijVeld'::character varying, 'GroepVrijVeld'::character varying, 'ContractVrijVeld'::character varying, 'BPVInschrijvingVrijVeld'::character varying, 'VooropleidingVrijVeld'::character varying, 'RelatieVrijVeld'::character varying, 'OpleidingVrijVeld'::character varying, 'OnderwijsproductVrijVeld'::character varying, 'PlaatsingVrijVeld'::character varying, 'VerbintenisVrijVeld'::character varying, 'ExterneOrganisatieVrijVeld'::character varying, 'PersoonVrijVeld'::character varying, 'IntakegesprekVrijVeld'::character varying])::text[])))
);


ALTER TABLE public.vrijveldentiteit OWNER TO postgres;

--
-- Name: vrijveldkeuzeoptie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vrijveldkeuzeoptie (
    actief boolean NOT NULL,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    id bigint NOT NULL,
    idinoudpakket bigint,
    organisatie bigint NOT NULL,
    version bigint,
    vrijveld bigint NOT NULL,
    naam character varying(255) NOT NULL
);


ALTER TABLE public.vrijveldkeuzeoptie OWNER TO postgres;

--
-- Name: vrijveldoptiekeuze; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vrijveldoptiekeuze (
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    entiteit bigint NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    optie bigint NOT NULL,
    organisatie bigint NOT NULL,
    version bigint
);


ALTER TABLE public.vrijveldoptiekeuze OWNER TO postgres;

--
-- Name: waarneming; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.waarneming (
    afgehandeld boolean NOT NULL,
    beginlesuur integer,
    eindlesuur integer,
    gearchiveerd boolean NOT NULL,
    created_at timestamp(6) without time zone,
    created_by bigint,
    last_modified_at timestamp(6) without time zone,
    last_modified_by bigint,
    absentiemelding bigint,
    afspraak bigint,
    begindatumtijd timestamp(6) without time zone NOT NULL,
    deelnemer bigint NOT NULL,
    einddatumtijd timestamp(6) without time zone NOT NULL,
    id bigint NOT NULL,
    idinoudpakket bigint,
    onderwijsproduct bigint,
    organisatie bigint NOT NULL,
    version bigint,
    waarnemingsoort character varying(255) NOT NULL,
    CONSTRAINT waarneming_waarnemingsoort_check CHECK (((waarnemingsoort)::text = ANY ((ARRAY['Aanwezig'::character varying, 'Afwezig'::character varying, 'Nvt'::character varying, 'DeelsAfwezig'::character varying])::text[])))
);


ALTER TABLE public.waarneming OWNER TO postgres;

--
-- Data for Name: aanbodperiode; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.aanbodperiode (begindatum, einddatum, einddatumnotnull, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, cohort, id, idinoudpakket, organisatie, version, naam) FROM stdin;
\.


--
-- Data for Name: aanleiding; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.aanleiding (gearchiveerd, bijzonderheid, created_at, created_by, last_modified_at, last_modified_by, traject, begeleidingshandeling, deelnemertest, id, idinoudpakket, incident, notitie, organisatie, version) FROM stdin;
\.


--
-- Data for Name: aanleidingtemplate; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.aanleidingtemplate (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, bijzonderheidcategorie, id, idinoudpakket, organisatie, testdefinitie, trajecttemplate, version, type) FROM stdin;
\.


--
-- Data for Name: aanmelding; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.aanmelding (begindatum, einddatum, einddatumnotnull, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, intakegesprek, organisatie, verbintenis, version, status) FROM stdin;
\.


--
-- Data for Name: aanwezigentemplate; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.aanwezigentemplate (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, handelingtemplate, id, idinoudpakket, organisatie, persoon, version, type) FROM stdin;
\.


--
-- Data for Name: absentiemelding; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.absentiemelding (afgehandeld, beginlesuur, eindlesuur, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, absentiereden, begindatumtijd, deelnemer, einddatumtijd, herhalendeabsentiemelding, id, idinoudpakket, organisatie, version, opmerkingen) FROM stdin;
\.


--
-- Data for Name: absentiereden; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.absentiereden (actief, afkorting, automatichafgehandeld, gearchiveerd, geoorloofd, standaardafgehandeld, standaardzondereinddatum, toegestaanvoordeelnemers, tonenbijwaarnemingen, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, locatie, organisatie, organisatieeenheid, version, omschrijving, absentiesoort) FROM stdin;
\.


--
-- Data for Name: abstractdeelnemerevent; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.abstractdeelnemerevent (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, deelnemerid, id, idinoudpakket, organisatie, version, hash, onderwerp, omschrijving) FROM stdin;
\.


--
-- Data for Name: abstractrelatie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.abstractrelatie (begindatum, betalingsplichtige, einddatum, einddatumnotnull, gearchiveerd, wettelijkevertegenwoordiger, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, instelling, organisatie, persoon, relatiesoort, version, verzorger, type) FROM stdin;
\.


--
-- Data for Name: account; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.account (actief, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, deelnemer, externeorganisatiecontpers, id, medewerker, organisatie, version, dtype, gebruikersnaam, wachtwoord, ipadressen, authorisatieniveau) FROM stdin;
\.


--
-- Data for Name: accountrol; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.accountrol (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, account, id, organisatie, rol, version) FROM stdin;
\.


--
-- Data for Name: adres; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.adres (gearchiveerd, geheim, huisnummertoevoeging, created_at, created_by, last_modified_at, last_modified_by, gemeente, id, idinoudpakket, land, organisatie, provincie, version, postcode, huisnummer, duitsedeelstaat, locatie, plaats, straat) FROM stdin;
\.


--
-- Data for Name: adresentiteit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.adresentiteit (begindatum, einddatum, einddatumnotnull, factuuradres, fysiekadres, gearchiveerd, postadres, created_at, created_by, last_modified_at, last_modified_by, adres, externeorganisatie, id, idinoudpakket, locatie, organisatie, organisatieeenheid, persoon, version, dtype) FROM stdin;
\.


--
-- Data for Name: afspraak; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.afspraak (beginlesuur, eindlesuur, gearchiveerd, minuteniivo, presentiedoordeelnemer, presentieregistratieverplicht, presentieregistratieverwerkt, created_at, created_by, last_modified_at, last_modified_by, afspraaktype, auteur, basisrooster, begindatumtijd, cacheregion, einddatumtijd, herhalendeafspraak, id, idinoudpakket, inloopcollege, locatie, onderwijsproduct, organisatie, organisatieeenheid, version, afspraaklocatie, externid, externsysteem, titel, omschrijving) FROM stdin;
\.


--
-- Data for Name: afspraakdeelnemer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.afspraakdeelnemer (afspraak, contract, deelnemer, organisatie, id, uitnodigingstatus) FROM stdin;
\.


--
-- Data for Name: afspraakparticipant; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.afspraakparticipant (gearchiveerd, uitnodigingverstuurd, created_at, created_by, last_modified_at, last_modified_by, afspraak, contract, deelnemer, externe, groep, id, idinoudpakket, medewerker, organisatie, persoonlijkegroep, version, uitnodigingstatus) FROM stdin;
\.


--
-- Data for Name: afspraaktype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.afspraaktype (actief, gearchiveerd, medewerkeronly, percentageiivo, presentieregistratiedefault, standaardkleur, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, locatie, organisatie, organisatieeenheid, version, naam, omschrijving, category, onderwijsproductgebruik, presentieregistratie, uitnodigingenversturen) FROM stdin;
\.


--
-- Data for Name: agendainstellingen; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.agendainstellingen (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, persoon, version, delenmetdeelnemer, delenmetwerknemer, printopmaak) FROM stdin;
\.


--
-- Data for Name: aggregatieniveau; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.aggregatieniveau (actief, gearchiveerd, niveau, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, code, naam) FROM stdin;
\.


--
-- Data for Name: basisrooster; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.basisrooster (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, organisatieeenheid, version, naam, externsysteem) FROM stdin;
\.


--
-- Data for Name: begeleidingshandeling; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.begeleidingshandeling (deadlinestatusovergang, eindhandeling, gearchiveerd, gelezen, geweigerd, uitnodigingenversturen, verslagversturen, created_at, created_by, eigenaar, gespreksoort, last_modified_at, last_modified_by, taaksoort, testdefinitie, traject, verantwoordelijke, afspraak, deelnemertest, id, idinoudpakket, organisatie, version, dtype, soort, aanleiding, omschrijving, status, opmerkingen, samenvatting) FROM stdin;
\.


--
-- Data for Name: begeleidingshandelingtemplate; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.begeleidingshandelingtemplate (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, eigenaar, gespreksoort, id, idinoudpakket, organisatie, planning, taaksoort, testdefinitie, toegekendaan, version, dtype, omschrijving) FROM stdin;
\.


--
-- Data for Name: beghandstatovrgang; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.beghandstatovrgang (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, begeleidingshandeling, datumtijd, id, idinoudpakket, medewerker, organisatie, version, naarstatus, vanstatus) FROM stdin;
\.


--
-- Data for Name: bekostigingsperiode; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bekostigingsperiode (begindatum, bekostigd, einddatum, einddatumnotnull, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, verbintenis, version) FROM stdin;
\.


--
-- Data for Name: betrokkenmedewerker; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.betrokkenmedewerker (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, incident, medewerker, organisatie, version) FROM stdin;
\.


--
-- Data for Name: bijlage; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bijlage (gearchiveerd, geldigtot, ontvangstdatum, created_at, created_by, last_modified_at, last_modified_by, bestandsize, documenttype, id, idinoudpakket, organisatie, version, bestandsnaam, documentnummer, locatie, omschrijving, link, typebijlage, bestand) FROM stdin;
\.


--
-- Data for Name: bijlageentiteit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bijlageentiteit (begindatum, einddatum, einddatumnotnull, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, afspraak, begeleidingshandeling, bijlage, bijzonderheid, bpvinschrijving, deelnemer, examendeelname, externeorganisatie, groep, id, idinoudpakket, incident, irisincident, notitie, onderwijsproduct, opleiding, organisatie, persoon, test, traject, trajecttemplate, verbintenis, version, dtype) FROM stdin;
\.


--
-- Data for Name: bijzonderheid; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bijzonderheid (gearchiveerd, tonenalswaarschuwing, tonenopdeelnemerkaart, vertrouwelijk, zorglijn, created_at, created_by, last_modified_at, last_modified_by, auteur, categorie, datuminvoer, deelnemer, handelingsinstructies, id, idinoudpakket, organisatie, version, titel, omschrijving) FROM stdin;
\.


--
-- Data for Name: bijzonderheidcategorie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bijzonderheidcategorie (actief, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, code, naam) FROM stdin;
\.


--
-- Data for Name: bookmark; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bookmark (gearchiveerd, pageprivate, created_at, created_by, last_modified_at, last_modified_by, account, bookmarkfolder, id, organisatie, version, omschrijving, pageclass, soort) FROM stdin;
\.


--
-- Data for Name: bookmarkconstructorargument; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bookmarkconstructorargument (gearchiveerd, haaluitcontext, volgorde, created_at, created_by, last_modified_at, last_modified_by, bookmark, id, idinoudpakket, organisatie, version, classname, waarde) FROM stdin;
\.


--
-- Data for Name: bookmarkfolder; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bookmarkfolder (gearchiveerd, volgorde, created_at, created_by, last_modified_at, last_modified_by, account, id, organisatie, version, naam) FROM stdin;
\.


--
-- Data for Name: bpvbedrijfsgegeven; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bpvbedrijfsgegeven (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, brin, externeorganisatie, id, idinoudpakket, organisatie, version, relatienummer, codeleerbedrijf, herkomstcode) FROM stdin;
\.


--
-- Data for Name: bpvcoloplaats; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bpvcoloplaats (aantalgeregistreerdeleerlingen, gearchiveerd, leerplaatsaantal, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, leerplaatsid, organisatie, version, codeleerbedrijf, land, leerbedrijfnaam, leerplaatssoort, leerweg, plaats, postcode, straat, vacatureleerplaatsomschrijving) FROM stdin;
\.


--
-- Data for Name: bpvcriteria; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bpvcriteria (actief, gearchiveerd, toegestaankoppelextorg, toegestaankoppelop, toegestaankoppelstagekandidaat, toegestaankoppelstageplaats, toegestaankoppelstageprofiel, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, naam, omschrijving) FROM stdin;
\.


--
-- Data for Name: bpvcriteriabpvdeelnemerprofiel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bpvcriteriabpvdeelnemerprofiel (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, bpvcriteria, bpvdeelnemerprofiel, id, idinoudpakket, organisatie, version, status) FROM stdin;
\.


--
-- Data for Name: bpvcriteriabpvkandidaat; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bpvcriteriabpvkandidaat (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, bpvcriteria, bpvkandidaat, id, idinoudpakket, organisatie, version, status) FROM stdin;
\.


--
-- Data for Name: bpvcriteriabpvplaats; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bpvcriteriabpvplaats (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, bpvcriteria, bpvplaats, id, idinoudpakket, organisatie, version, status) FROM stdin;
\.


--
-- Data for Name: bpvcriteriaexterneorganisatie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bpvcriteriaexterneorganisatie (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, bpvcriteria, externeorganisatie, id, idinoudpakket, organisatie, version, status) FROM stdin;
\.


--
-- Data for Name: bpvcriteriaonderwijsproduct; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bpvcriteriaonderwijsproduct (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, bpvcriteria, id, idinoudpakket, onderwijsproduct, organisatie, version, status) FROM stdin;
\.


--
-- Data for Name: bpvdeelnemerprofiel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bpvdeelnemerprofiel (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version) FROM stdin;
\.


--
-- Data for Name: bpvinschrijving; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bpvinschrijving (afsluitdatum, begindatum, dagenperweek, einddatum, einddatumnotnull, gearchiveerd, gerealiseerdeomvang, neemtbetalingsplichtover, opnemeninbron, totaleomvang, urenperweek, verwachteeinddatum, volgnummer, created_at, created_by, last_modified_at, last_modified_by, bedrijfsgegeven, bpvbedrijf, bpvplaats, brondatum, contactpersoonbpvbedrijf, contactpersooncontractpartner, contractpartner, id, idinoudpakket, organisatie, overeenkomstnummer, praktijkbegeleider, praktijkopleiderbpvbedrijf, redenuitschrijving, verbintenis, version, locatiepok, werkdagen, naampraktijkopleiderbpvbedrijf, bronstatus, praktijkbiedendeorganisatie, status, opmerkingen, toelichtingbeeindiging) FROM stdin;
\.


--
-- Data for Name: bpvkandidaat; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bpvkandidaat (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, bpvinschrijving, id, idinoudpakket, organisatie, verbintenis, version, matchingstatus, matchingtype) FROM stdin;
\.


--
-- Data for Name: bpvkandidaatonderwijsproduct; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bpvkandidaatonderwijsproduct (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, bpvkandidaat, id, idinoudpakket, onderwijsproduct, organisatie, version) FROM stdin;
\.


--
-- Data for Name: bpvmatch; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bpvmatch (gearchiveerd, keuzevervallen, keuzevolgnummer, matchakkoord, created_at, created_by, last_modified_at, last_modified_by, bpvcoloplaats, bpvkandidaat, bpvplaats, id, idinoudpakket, organisatie, version) FROM stdin;
\.


--
-- Data for Name: bpvplaats; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bpvplaats (aantalplaatsen, aantalstudenten, begeleidingsuren, dagenperweek, gearchiveerd, matchingdoorinstelling, matchingdoorstudenten, urenperweek, vergoeding, created_at, created_by, last_modified_at, last_modified_by, begindatum, contactpersoonbpvbedrijf, einddatum, externeorganisatie, id, idinoudpakket, organisatie, version, opdrachtomschrijving, type) FROM stdin;
\.


--
-- Data for Name: bpvplaatsopleiding; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bpvplaatsopleiding (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, bpvplaats, id, idinoudpakket, opleiding, organisatie, version) FROM stdin;
\.


--
-- Data for Name: budget; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.budget (aantaluur, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, onderwijsproduct, id, idinoudpakket, organisatie, verbintenis, version) FROM stdin;
\.


--
-- Data for Name: cacheregion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cacheregion (dirty, gearchiveerd, regionenddate, regionstartdate, created_at, created_by, last_modified_at, last_modified_by, externeagenda, id, idinoudpakket, lastupdate, organisatie, version) FROM stdin;
\.


--
-- Data for Name: cohort; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cohort (begindatum, einddatum, einddatumnotnull, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, version, naam) FROM stdin;
\.


--
-- Data for Name: competentie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.competentie (code, gearchiveerd, nummer, created_at, created_by, last_modified_at, last_modified_by, id, version, titel) FROM stdin;
\.


--
-- Data for Name: competentiecomponent; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.competentiecomponent (gearchiveerd, nummer, created_at, created_by, last_modified_at, last_modified_by, competentie, id, version, titel) FROM stdin;
\.


--
-- Data for Name: competentieniveau; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.competentieniveau (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, leerpunt, niveauverzameling, organisatie, score, version) FROM stdin;
\.


--
-- Data for Name: competentieniveauverzameling; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.competentieniveauverzameling (datum, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, cohort, deelnemer, groep, groepsbeoordeling, id, idinoudpakket, matrix, medewerker, meeteenheid, opgenomenin, opleiding, organisatie, version, dtype, naam, type, commentaar) FROM stdin;
\.


--
-- Data for Name: contactpersoon; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contactpersoon (begindatum, einddatum, einddatumnotnull, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, bijorganisatieeenheid, id, idinoudpakket, organisatie, persoon, version, voororganisatieeenheid) FROM stdin;
\.


--
-- Data for Name: contract; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contract (begindatum, einddatum, einddatumnotnull, gearchiveerd, kostprijs, maximumaantaldeelnemers, minimumaantaldeelnemers, created_at, created_by, last_modified_at, last_modified_by, beheerder, contactpersoon, eindeinstroom, externeorganisatie, id, idinoudpakket, organisatie, organisatieeenheid, soortcontract, typefinanciering, version, externnummer, aanwezigbij, code, onderaannemingbij, naam, onderaanneming, toelichting) FROM stdin;
\.


--
-- Data for Name: contractlocatiekoppeling; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contractlocatiekoppeling (contract_id, locatie_id) FROM stdin;
\.


--
-- Data for Name: contractonderdeel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contractonderdeel (begindatum, einddatum, einddatumnotnull, gearchiveerd, maximumaantaldeelnemers, minimumaantaldeelnemers, prijs, created_at, created_by, last_modified_at, last_modified_by, contract, id, idinoudpakket, organisatie, version, begeleidingsintensiteit, frequentieaanwezigheid, groepsgrootte, studiebelasting, naam) FROM stdin;
\.


--
-- Data for Name: contractverplichting; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contractverplichting (begindatum, einddatum, einddatumnotnull, gearchiveerd, uitgevoerd, created_at, created_by, last_modified_at, last_modified_by, contract, datumuitgevoerd, id, idinoudpakket, medewerker, organisatie, version, omschrijving) FROM stdin;
\.


--
-- Data for Name: criterium; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.criterium (gearchiveerd, volgnummer, created_at, created_by, last_modified_at, last_modified_by, cohort, id, idinoudpakket, opleiding, organisatie, verbintenisgebied, version, melding, naam, formule) FROM stdin;
\.


--
-- Data for Name: crohoopleidingaanbod; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.crohoopleidingaanbod (aanvullendeeisen, begindatum, beroepsvereisten, datumaccreditatiebesluit, datumeindeinstroomaccreditatie, datumuitsteltotaccreditatie, datumvervallenaccreditatie, decentraleselectie, deficientie, einddatum, einddatumnotnull, gearchiveerd, propedeutischexamen, studielast, studielastvt, werkzaamheden, created_at, created_by, last_modified_at, last_modified_by, brin, crohoopleiding, datumeindeinstroom, id, version, vervaldatumdecentraleselectie, onderdeel, bekostiging, opleidingsvorm, soortaanmelding, soortfixus) FROM stdin;
\.


--
-- Data for Name: curriculum; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.curriculum (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, cohort, id, idinoudpakket, locatie, opleiding, organisatie, organisatieeenheid, version) FROM stdin;
\.


--
-- Data for Name: curriculumonderwijsproduct; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.curriculumonderwijsproduct (gearchiveerd, leerjaar, onderwijstijd, periode, created_at, created_by, last_modified_at, last_modified_by, curriculum, id, idinoudpakket, onderwijsproduct, organisatie, version) FROM stdin;
\.


--
-- Data for Name: deelnemer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.deelnemer (allochtoon, dapersgegegensconflict, deelnemernummer, gbarelatie, gearchiveerd, heeftbachelorgraad, heeftmastergraad, lgf, registratiedatum, startkwalificatieplichtigtot, studielinknummer, uitsluitenvanfacturatie, created_at, created_by, last_modified_at, last_modified_by, brondatum, id, idinoudpakket, ocwnummer, onderwijsnummer, organisatie, persoon, version, bronstatus) FROM stdin;
\.


--
-- Data for Name: deelnemerkenmerk; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.deelnemerkenmerk (begindatum, einddatum, einddatumnotnull, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, deelnemer, id, idinoudpakket, kenmerk, organisatie, version, toelichting) FROM stdin;
\.


--
-- Data for Name: deelnemermatrix; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.deelnemermatrix (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, deelnemer, id, idinoudpakket, matrix, meeteenheid, organisatie, version) FROM stdin;
\.


--
-- Data for Name: deelnemermedewerkergroepview; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.deelnemermedewerkergroepview (organisatie, code, naam, omschrijving, type, voorletters, voornamen, voorvoegsel, id) FROM stdin;
\.


--
-- Data for Name: deelnemerpersoonlijkegroep; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.deelnemerpersoonlijkegroep (begindatum, einddatum, deelnemer, groep, organisatie, id) FROM stdin;
\.


--
-- Data for Name: deelnemerresultaatversie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.deelnemerresultaatversie (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, deelnemer, id, idinoudpakket, organisatie, resultaatstructuur, versie, version) FROM stdin;
\.


--
-- Data for Name: deelnemertest; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.deelnemertest (afnamedatum, gearchiveerd, vertrouwelijk, zorglijn, created_at, created_by, last_modified_at, last_modified_by, deelnemer, groeptest, id, idinoudpakket, organisatie, testdefinitie, version) FROM stdin;
\.


--
-- Data for Name: deelnemertoetsbevriezing; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.deelnemertoetsbevriezing (gearchiveerd, ingeleverd, created_at, created_by, last_modified_at, last_modified_by, bevrorenpogingen, deelnemer, id, idinoudpakket, organisatie, toets, version) FROM stdin;
\.


--
-- Data for Name: deelnemerzoekopdracht; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.deelnemerzoekopdracht (gearchiveerd, kolommenvastzetten, peildatumvastzetten, created_at, created_by, last_modified_at, last_modified_by, account, id, idinoudpakket, organisatie, version, omschrijving, filter) FROM stdin;
\.


--
-- Data for Name: deelnemerzoekopdrachtrecht; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.deelnemerzoekopdrachtrecht (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, rol, version, zoekopdracht) FROM stdin;
\.


--
-- Data for Name: documentcategorie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.documentcategorie (actief, beperkautorisatie, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, code, naam) FROM stdin;
\.


--
-- Data for Name: documenttemplate; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.documenttemplate (actief, beperkautorisatie, gearchiveerd, kopiebijcontext, sectieperelement, valid, created_at, created_by, last_modified_at, last_modified_by, documenttype, id, idinoudpakket, organisatie, taxonomie, version, dtype, bestandsnaam, omschrijving, categorie, context, examendocumenttype, forceertype, type, zzzbestand) FROM stdin;
\.


--
-- Data for Name: documenttemplaterecht; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.documenttemplaterecht (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, documentcategorie, documenttemplate, id, idinoudpakket, organisatie, rol, version, actionclassname) FROM stdin;
\.


--
-- Data for Name: documenttype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.documenttype (actief, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, categorie, id, idinoudpakket, organisatie, version, code, naam) FROM stdin;
\.


--
-- Data for Name: edvcs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.edvcs (gearchiveerd, "position", visible, created_at, created_by, last_modified_at, last_modified_by, account, id, organisatie, version, headerid, panelid) FROM stdin;
\.


--
-- Data for Name: eigenaartemplate; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.eigenaartemplate (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, persoon, version, rol) FROM stdin;
\.


--
-- Data for Name: eventabonnementconfiguration; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.eventabonnementconfiguration (config_value, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, dtype) FROM stdin;
\.


--
-- Data for Name: eventabonnementsetting; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.eventabonnementsetting (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, configuratie, id, idinoudpakket, organisatie, persoon, version, dtype, eventclassname, transportclassname, type, waarde) FROM stdin;
\.


--
-- Data for Name: examendeelname; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.examendeelname (bekostigd, datumuitslag, examenjaar, examennummer, gearchiveerd, gewijzigd, meenemeninvolgendebronbatch, tijdvak, created_at, created_by, last_modified_at, last_modified_by, brondatum, datumlaatstestatusovergang, examenstatus, id, idinoudpakket, organisatie, verbintenis, version, examennummerprefix, bronstatus) FROM stdin;
\.


--
-- Data for Name: examenstatus; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.examenstatus (beginstatus, criteriumbankcontrole, eindstatus, gearchiveerd, geslaagd, volgnummer, created_at, created_by, last_modified_at, last_modified_by, examenworkflow, id, idinoudpakket, organisatie, version, naam) FROM stdin;
\.


--
-- Data for Name: examenstatusovergang; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.examenstatusovergang (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, datumtijd, examendeelname, id, idinoudpakket, naarstatus, organisatie, vanstatus, version, opmerkingen) FROM stdin;
\.


--
-- Data for Name: examenworkflow; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.examenworkflow (gearchiveerd, heefttijdvakken, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, naam) FROM stdin;
\.


--
-- Data for Name: examenworkflowtax; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.examenworkflowtax (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, examenworkflow, id, idinoudpakket, organisatie, taxonomie, version) FROM stdin;
\.


--
-- Data for Name: externeagenda; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.externeagenda (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, eigenaar_id, id, idinoudpakket, koppeling_id, organisatie, version, naam, gebruikersnaam, wachtwoord) FROM stdin;
\.


--
-- Data for Name: externeagendakoppeling; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.externeagendakoppeling (actief, automatisch, gearchiveerd, geldigheidsduur, created_at, created_by, last_modified_at, last_modified_by, afspraaktype_id, id, idinoudpakket, locatie_id, organisatie, organisatieeenheid_id, version, dtype, eventfeedurlsuffix, naam, applicationname, metafeedurlbase) FROM stdin;
\.


--
-- Data for Name: externeorganisatie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.externeorganisatie (begindatum, betalingstermijn, bpvbedrijf, einddatum, einddatumnotnull, gearchiveerd, nietgeschiktvoorbpvdeelnemers, nietgeschiktvoorbpvmatch, nogcontroleren, verzamelfacturen, code, created_at, created_by, last_modified_at, last_modified_by, debiteurennummer, id, idinoudpakket, laatsteexportdatum, ondertekeningbpvodoor, organisatie, soortexterneorganisatie, version, bankrekeningnummer, factuurbetaalwijze, dtype, verkortenaam, naam, controleresultaat, onderwijssector, omschrijving, toelichtingnietgeschiktvoorbpv) FROM stdin;
\.


--
-- Data for Name: externeorganisatiekenmerk; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.externeorganisatiekenmerk (begindatum, einddatum, einddatumnotnull, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, externeorganisatie, id, idinoudpakket, kenmerk, organisatie, version, toelichting) FROM stdin;
\.


--
-- Data for Name: externeorganisatieopmerking; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.externeorganisatieopmerking (gearchiveerd, tonenbijmatching, created_at, created_by, last_modified_at, last_modified_by, auteur, datum, externeorganisatie, id, idinoudpakket, organisatie, version, opmerking) FROM stdin;
\.


--
-- Data for Name: externewaarneming; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.externewaarneming (beginlesuur, begintijd, datum, eindlesuur, eindtijd, gearchiveerd, verwerkt, created_at, created_by, last_modified_at, last_modified_by, deelnemernummer, id, idinoudpakket, organisatie, organisatienummer, version, lokaalcode, roostercode, waarnemingsoort) FROM stdin;
\.


--
-- Data for Name: externpersoon; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.externpersoon (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, email) FROM stdin;
\.


--
-- Data for Name: extorgcontactgegeven; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.extorgcontactgegeven (gearchiveerd, geheim, volgorde, created_at, created_by, last_modified_at, last_modified_by, externeorganisatie, id, idinoudpakket, organisatie, soortcontactgegeven, version, contactgegeven) FROM stdin;
\.


--
-- Data for Name: extorgcontactpersoon; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.extorgcontactpersoon (begindatum, einddatum, einddatumnotnull, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, externeorganisatie, id, idinoudpakket, organisatie, rol, version, emailadres, mobiel, telefoon, naam, geslacht) FROM stdin;
\.


--
-- Data for Name: extorgcontpersrol; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.extorgcontpersrol (actief, contactpersoonbpv, gearchiveerd, praktijkopleiderbpv, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, naam) FROM stdin;
\.


--
-- Data for Name: extorgpraktijkbegeleider; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.extorgpraktijkbegeleider (gearchiveerd, laatstgebruiktemedewerker, created_at, created_by, last_modified_at, last_modified_by, externeorganisatie, id, idinoudpakket, medewerker, organisatie, version) FROM stdin;
\.


--
-- Data for Name: fase; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fase (actief, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, volgendefase, code, naam, hoofdfase) FROM stdin;
\.


--
-- Data for Name: functie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.functie (actief, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, code, naam) FROM stdin;
\.


--
-- Data for Name: gebruiksmiddel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.gebruiksmiddel (actief, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, code, naam) FROM stdin;
\.


--
-- Data for Name: gedrag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.gedrag (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version) FROM stdin;
\.


--
-- Data for Name: gekoppeldetemplate; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.gekoppeldetemplate (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, medewerker, organisatie, rol, trajecttemplate, version, koppelingsrol, type) FROM stdin;
\.


--
-- Data for Name: gemeente; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.gemeente (begindatum, einddatum, einddatumnotnull, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, nieuwegemeente, version, code, naam) FROM stdin;
\.


--
-- Data for Name: gespreksamenvattingtemplate; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.gespreksamenvattingtemplate (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, naam, template) FROM stdin;
\.


--
-- Data for Name: gespreksamenvattingzin; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.gespreksamenvattingzin (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, zin) FROM stdin;
\.


--
-- Data for Name: gespreksoort; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.gespreksoort (actief, gearchiveerd, oudersuitnodigen, standaardverslagversturen, created_at, created_by, last_modified_at, last_modified_by, afspraaktype, id, idinoudpakket, locatie, organisatie, organisatieeenheid, version, naam, standaardstatus, verslagtemplate) FROM stdin;
\.


--
-- Data for Name: groep; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.groep (begindatum, einddatum, einddatumnotnull, gearchiveerd, gedeeld, leerjaar, created_at, created_by, last_modified_at, last_modified_by, deelnemer, groepstype, id, idinoudpakket, locatie, medewerker, organisatie, organisatieeenheid, version, code, dtype, naam, omschrijving) FROM stdin;
\.


--
-- Data for Name: groepdocent; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.groepdocent (begindatum, einddatum, einddatumnotnull, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, groep, id, idinoudpakket, medewerker, organisatie, version) FROM stdin;
\.


--
-- Data for Name: groepmentor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.groepmentor (begindatum, einddatum, einddatumnotnull, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, groep, id, idinoudpakket, medewerker, organisatie, version) FROM stdin;
\.


--
-- Data for Name: groepresultaatfilterinst; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.groepresultaatfilterinst (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, cohort, filterinstelling, groep, id, idinoudpakket, onderwijsproduct, organisatie, version) FROM stdin;
\.


--
-- Data for Name: groepsdeelname; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.groepsdeelname (begindatum, einddatum, einddatumnotnull, gearchiveerd, jarenpraktijkonderwijs, leerjaar, lwoo, created_at, created_by, last_modified_at, last_modified_by, bevatgroep, contract, deelnemer, fase, groep, id, idinoudpakket, organisatie, verbintenis, version, dtype, inschrijvingsvorm, opleidingsvorm) FROM stdin;
\.


--
-- Data for Name: groepstype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.groepstype (actief, gearchiveerd, plaatsingsgroep, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, code, naam) FROM stdin;
\.


--
-- Data for Name: groeptest; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.groeptest (afnamedatum, gearchiveerd, tonen, vertrouwelijk, zorglijn, created_at, created_by, last_modified_at, last_modified_by, groep, id, idinoudpakket, organisatie, testdefinitie, version) FROM stdin;
\.


--
-- Data for Name: grouppropertysetting; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.grouppropertysetting (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, account, id, organisatie, version, property, panelid) FROM stdin;
\.


--
-- Data for Name: herhalendeabsentiemelding; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.herhalendeabsentiemelding (begindatum, einddatum, gearchiveerd, weekcyclus, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version) FROM stdin;
\.


--
-- Data for Name: herhalendeafspraak; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.herhalendeafspraak (begindatum, cyclus, dagen, einddatum, gearchiveerd, maxherhalingen, skip, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, type) FROM stdin;
\.


--
-- Data for Name: hulpmiddel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hulpmiddel (actief, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, code, naam) FROM stdin;
\.


--
-- Data for Name: ibgverzuimdag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ibgverzuimdag (gearchiveerd, heledag, lesuur1, lesuur10, lesuur11, lesuur12, lesuur2, lesuur3, lesuur4, lesuur5, lesuur6, lesuur7, lesuur8, lesuur9, created_at, created_by, last_modified_at, last_modified_by, datum, id, idinoudpakket, organisatie, version, verzuimmelding) FROM stdin;
\.


--
-- Data for Name: ibgverzuimmelding; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ibgverzuimmelding (actieondernemen, allelessengemist, begindatum, einddatum, einddatumnotnull, gearchiveerd, meldingsnummer, verzonden, verzuimdaggespecificeerd, netnummermelder, created_at, created_by, last_modified_at, last_modified_by, begindatumselectie, id, idinoudpakket, laatstemutatiedatum, laatstemutatietijd, locatie, melddatumtijd, organisatie, verbintenis, version, abonneenummermelder, functiemelder, aanduidingcontactpersoon, emailadresmelder, toelichting, vermoedelijkereden, ccemailontvanger, status, verzuimsoort, toelichtingactiegewenst, toelichtingondernomenactie) FROM stdin;
\.


--
-- Data for Name: incident; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.incident (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, deelnemer, id, idinoudpakket, organisatie, version, consequenties) FROM stdin;
\.


--
-- Data for Name: incidentcategorie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.incidentcategorie (actief, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, code, naam, irisvoorval) FROM stdin;
\.


--
-- Data for Name: inloopcollege; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inloopcollege (gearchiveerd, heleherhaling, inschrijfbegindatum, inschrijfeinddatum, maxdeelnemers, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, omschrijving, opmerking) FROM stdin;
\.


--
-- Data for Name: inloopcollegegroep; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inloopcollegegroep (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, groep, id, idinoudpakket, inloopcollege, organisatie, version) FROM stdin;
\.


--
-- Data for Name: inloopcollegeopleiding; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inloopcollegeopleiding (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, inloopcollege, opleiding, organisatie, version) FROM stdin;
\.


--
-- Data for Name: inschrijvingsverzoek; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inschrijvingsverzoek (betaald, betalingtermijnen, duplicaat, gearchiveerd, herinschrijving, toestemmingsverklaring, created_at, created_by, last_modified_at, last_modified_by, betalingdatum, gbaverificatiebrin, gbaverificatiedatum, id, idinoudpakket, instroommoment, lotingstatusdatum, organisatie, plaatsing, studielinkbericht, verbintenis, version, gbaverificatiedocumentnummer, gbaverificatiedocument, gbaverificatiedoormedewerker, gbaverificatieopmerking, aanvullendeeisenstatus, betaalwijze, betaler, deficientiestatus, eerstejaars, gbaverificatiestatus, lotingstatus, lotingvorm, status, taaltoetsstatus, werkzaamhedenstatus) FROM stdin;
\.


--
-- Data for Name: instellingsequence; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instellingsequence (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, maximum, organisatie, startwaarde, version, naam) FROM stdin;
\.


--
-- Data for Name: instellingslogo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instellingslogo (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, bijlage, id, idinoudpakket, organisatie, version) FROM stdin;
\.


--
-- Data for Name: instroommoment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instroommoment (actief, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, code, naam) FROM stdin;
\.


--
-- Data for Name: intakegesprek; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.intakegesprek (gearchiveerd, gewenstebegindatum, gewensteeinddatum, created_at, created_by, last_modified_at, last_modified_by, datumtijd, gewenstebpv, gewenstegroep, gewenstelocatie, gewensteopleiding, id, idinoudpakket, intaker, locatie, organisatie, organisatieeenheid, uitkomstintakegesprek, verbintenis, version, contactpersoonwerkgever, naamwerkgever, plaatswerkgever, intakeroverig, kamer, status, opmerking) FROM stdin;
\.


--
-- Data for Name: irisbetrokkene; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.irisbetrokkene (gearchiveerd, letsel, rolbijincidentcode, rolopschoolcode, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, incident, irisincident, medewerker, organisatie, version, ingevoerdgeslacht, ingevoerdenaam, toelichting) FROM stdin;
\.


--
-- Data for Name: irisbetrokkeneafhandeling; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.irisbetrokkeneafhandeling (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, betrokkene, id, version, afhandeling) FROM stdin;
\.


--
-- Data for Name: irisbetrokkenemotief; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.irisbetrokkenemotief (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, betrokkene, id, version, motief) FROM stdin;
\.


--
-- Data for Name: irisincident; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.irisincident (afgerond, begindatum, einddatum, einddatumnotnull, gearchiveerd, onzeker, vertrouwelijk, zorglijn, created_at, created_by, last_modified_at, last_modified_by, auteur, categorie, id, idinoudpakket, organisatie, organisatieeenheid_id, version, titel, dagdeel, irisincidentnummer, kleur, tijdtype, tijdstip, toelichting) FROM stdin;
\.


--
-- Data for Name: irisincidentlocatie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.irisincidentlocatie (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, incident, version, locatie) FROM stdin;
\.


--
-- Data for Name: irisincidentvoorwerp; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.irisincidentvoorwerp (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, incident, version, voorwerp) FROM stdin;
\.


--
-- Data for Name: iriskoppelingkey; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.iriskoppelingkey (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, privatekeyinbytes, publickeyinbytes) FROM stdin;
\.


--
-- Data for Name: kenmerk; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kenmerk (actief, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, categorie, id, idinoudpakket, organisatie, version, code, naam) FROM stdin;
\.


--
-- Data for Name: kenmerkcategorie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kenmerkcategorie (actief, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, code, naam) FROM stdin;
\.


--
-- Data for Name: land; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.land (begindatum, code, einddatum, einddatumnotnull, gearchiveerd, isocode, created_at, created_by, last_modified_at, last_modified_by, id, version, naam) FROM stdin;
\.


--
-- Data for Name: leerpuntcomponent; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.leerpuntcomponent (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, competentiecomponent, id, leerpunt, version) FROM stdin;
\.


--
-- Data for Name: leerpuntvaardigheid; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.leerpuntvaardigheid (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, leerpunt, vaardigheid, version) FROM stdin;
\.


--
-- Data for Name: leerstijl; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.leerstijl (actief, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, code, naam) FROM stdin;
\.


--
-- Data for Name: lesdagindeling; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lesdagindeling (dag, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, lesweekindeling, organisatie, version) FROM stdin;
\.


--
-- Data for Name: lesuurindeling; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lesuurindeling (begintijd, eindtijd, gearchiveerd, lesuur, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, lesdagindeling, organisatie, version) FROM stdin;
\.


--
-- Data for Name: lesweekindeling; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lesweekindeling (actief, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, naam, omschrijving) FROM stdin;
\.


--
-- Data for Name: lesweekindelingorgloc; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lesweekindelingorgloc (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, lesweekindeling, locatie, organisatie, organisatieeenheid, version) FROM stdin;
\.


--
-- Data for Name: locatie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.locatie (begindatum, einddatum, einddatumnotnull, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, code, id, idinoudpakket, organisatie, version, afkorting, naam) FROM stdin;
\.


--
-- Data for Name: locatiecontactgegeven; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.locatiecontactgegeven (gearchiveerd, geheim, volgorde, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, locatie, organisatie, soortcontactgegeven, version, contactgegeven) FROM stdin;
\.


--
-- Data for Name: maatregel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.maatregel (actief, automatischemaatregeltonen, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, locatie, organisatie, organisatieeenheid, version, omschrijving) FROM stdin;
\.


--
-- Data for Name: maatregeltoekenning; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.maatregeltoekenning (automatischtoegekend, gearchiveerd, nagekomen, created_at, created_by, last_modified_at, last_modified_by, deelnemer, eigenaardeelnemer, eigenaarmedewerker, id, idinoudpakket, maatregel, maatregeldatum, organisatie, veroorzaaktdoor, version, opmerkingen) FROM stdin;
\.


--
-- Data for Name: maatregeltoekenningsregel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.maatregeltoekenningsregel (aantalmeldingen, aantalvrijemeldingen, aantalweken, actief, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, absentiereden, id, idinoudpakket, locatie, maatregel, organisatie, organisatieeenheid, periode, version, maatregeltoekennenop, periodetype, regelsoort) FROM stdin;
\.


--
-- Data for Name: medewerker; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.medewerker (begindatum, einddatum, einddatumnotnull, gearchiveerd, uitgeslotenvancorres, created_at, created_by, last_modified_at, last_modified_by, functie, id, idinoudpakket, organisatie, persoon, redenuitdienst, version, afkorting, redenuitgeslotenvancorres) FROM stdin;
\.


--
-- Data for Name: medewerkerdeelnemerabonnering; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.medewerkerdeelnemerabonnering (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, deelnemer, id, idinoudpakket, medewerker, organisatie, version) FROM stdin;
\.


--
-- Data for Name: medewerkergroepabonnering; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.medewerkergroepabonnering (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, groep, id, idinoudpakket, medewerker, organisatie, version) FROM stdin;
\.


--
-- Data for Name: medewerkerkenmerk; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.medewerkerkenmerk (begindatum, einddatum, einddatumnotnull, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, kenmerk, medewerker, organisatie, version, toelichting) FROM stdin;
\.


--
-- Data for Name: meeteenheid; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.meeteenheid (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, naam, omschrijving) FROM stdin;
\.


--
-- Data for Name: meeteenheidkoppel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.meeteenheidkoppel (automatischaangemaakt, gearchiveerd, vastgezet, created_at, created_by, last_modified_at, last_modified_by, cohort, id, idinoudpakket, meeteenheid, opleiding, organisatie, organisatieeenheid, version, type) FROM stdin;
\.


--
-- Data for Name: meeteenheidwaarde; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.meeteenheidwaarde (gearchiveerd, label, waarde, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, meeteenheid, organisatie, version) FROM stdin;
\.


--
-- Data for Name: modernetaal; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.modernetaal (gearchiveerd, voorgedefinieerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, afkorting, code, omschrijving) FROM stdin;
\.


--
-- Data for Name: moduleafname; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.moduleafname (actief, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, organisatie, version, checksum, modulename, organizationname) FROM stdin;
\.


--
-- Data for Name: mogelijkeaanleiding; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mogelijkeaanleiding (vertrouwelijk, zorglijn, datum, deelnemer, entiteitid, organisatie, id, omschrijving, type) FROM stdin;
\.


--
-- Data for Name: nationaliteit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nationaliteit (begindatum, eer, einddatum, einddatumnotnull, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, version, naam, code) FROM stdin;
\.


--
-- Data for Name: niettoneninzorgvierkant; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.niettoneninzorgvierkant (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, bijzonderheid, id, idinoudpakket, irisincident, medewerker, notitie, organisatie, test, traject, version, dtype) FROM stdin;
\.


--
-- Data for Name: notitie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notitie (dossiereinddatum, gearchiveerd, vertrouwelijk, zorglijn, created_at, created_by, last_modified_at, last_modified_by, auteur, datuminvoer, deelnemer, id, idinoudpakket, organisatie, version, titel, kleur, omschrijving) FROM stdin;
\.


--
-- Data for Name: olclocatie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.olclocatie (actief, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, afspraaktype, id, idinoudpakket, locatie, organisatie, organisatieeenheid, version, code, naam) FROM stdin;
\.


--
-- Data for Name: olcwaarneming; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.olcwaarneming (begintijd, datum, eindtijd, gearchiveerd, verwerkt, created_at, created_by, last_modified_at, last_modified_by, afspraaktype, deelnemer, id, idinoudpakket, medewerker, olclocatie, organisatie, version) FROM stdin;
\.


--
-- Data for Name: onderwijsproduct; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.onderwijsproduct (aantalweken, alleenextern, begeleid, begindatum, belasting, belastingec, belastingoverig, bijintake, credits, einddatum, einddatumnotnull, frequentieperweek, gearchiveerd, heeftwerkstuktitel, individueel, kostprijs, maximumaantaldeelnemers, minimumaantaldeelnemers, omvang, onafhankelijk, startonderwijsproduct, tijdpereenheid, created_at, created_by, last_modified_at, last_modified_by, aggregatieniveau, id, idinoudpakket, leerstijl, niveauaanduiding, organisatie, soortpraktijklokaal, soortproduct, typelocatie, typetoets, version, code, internationaletitel, titel, leerstofdrager, gebruiksrecht, juridischeigenaar, kalender, personeelbevoegdheid, personeelcompetenties, personeelkennisgebiedenniveau, personeelwettelijkevereisten, uitvoeringsfrequentie, status, docentactiviteiten, hulpmiddelen, internationaleomschrijving, literatuur, omschrijving, toegankelijkheid, vereistevoorkennis) FROM stdin;
\.


--
-- Data for Name: onderwijsproductaanbod; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.onderwijsproductaanbod (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, locatie, onderwijsproduct, organisatie, organisatieeenheid, version) FROM stdin;
\.


--
-- Data for Name: onderwijsproductaanbodperiode; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.onderwijsproductaanbodperiode (begindatum, einddatum, einddatumnotnull, gearchiveerd, minimaalaantalinschrijvingen, created_at, created_by, last_modified_at, last_modified_by, aanbodperiode, begindatuminschrijving, begindatumlesperiode, einddatuminschrijving, einddatumlesperiode, id, idinoudpakket, onderwijsproductaanbod, organisatie, version) FROM stdin;
\.


--
-- Data for Name: onderwijsproductafname; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.onderwijsproductafname (begindatum, credits, einddatum, einddatumnotnull, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, bpvinschrijving, cohort, deelnemer, externeorganisatie, id, idinoudpakket, onderwijsproduct, organisatie, version, vrijstellingtype, werkstuktitel) FROM stdin;
\.


--
-- Data for Name: onderwijsproductafnamecontext; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.onderwijsproductafnamecontext (certificaatbehaald, diplomavak, gearchiveerd, toonopcijferlijst, verwezennaarvolgendtijdvak, volgnummer, werkstukhoortbijproduct, created_at, created_by, last_modified_at, last_modified_by, brondatum, id, idinoudpakket, onderwijsproductafname, organisatie, productregel, verbintenis, version, bronstatus, toepassingresultaat, toepassingresultaatexamenvak) FROM stdin;
\.


--
-- Data for Name: onderwijsproductniveau; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.onderwijsproductniveau (actief, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, code, naam) FROM stdin;
\.


--
-- Data for Name: onderwijsproductopvolger; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.onderwijsproductopvolger (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, nieuwproduct, organisatie, oudproduct, version) FROM stdin;
\.


--
-- Data for Name: onderwijsproductsamenstelling; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.onderwijsproductsamenstelling (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, child, id, idinoudpakket, organisatie, parent, version) FROM stdin;
\.


--
-- Data for Name: onderwijsproducttaxonomie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.onderwijsproducttaxonomie (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, onderwijsproduct, organisatie, taxonomieelement, version) FROM stdin;
\.


--
-- Data for Name: onderwijsproductvoorwaarde; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.onderwijsproductvoorwaarde (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, voorwaardevoor, voorwaardelijkproduct) FROM stdin;
\.


--
-- Data for Name: onderwijsproductzoekterm; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.onderwijsproductzoekterm (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, onderwijsproduct, organisatie, version, zoekterm) FROM stdin;
\.


--
-- Data for Name: ondprodgebruiksmiddel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ondprodgebruiksmiddel (aantal, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, gebruiksmiddel, id, idinoudpakket, onderwijsproduct, organisatie, version) FROM stdin;
\.


--
-- Data for Name: ondprodverbruiksmiddel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ondprodverbruiksmiddel (aantal, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, onderwijsproduct, organisatie, verbruiksmiddel, version) FROM stdin;
\.


--
-- Data for Name: opaanbodperiodeopafname; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.opaanbodperiodeopafname (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, onderwijsproductaanbodperiode, onderwijsproductafname, organisatie, version) FROM stdin;
\.


--
-- Data for Name: opleiding; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.opleiding (beginleerjaar, begindatum, communicerenmetbron, duurinmaanden, eindleerjaar, einddatum, einddatumnotnull, gearchiveerd, instroomvariant, kieskenniscentrum, negeerlandelijkecriteria, negeerlandelijkeproductregels, uitstroomvariant, created_at, created_by, last_modified_at, last_modified_by, datumlaatsteinschrijving, id, idinoudpakket, organisatie, parent, verbintenisgebied, version, code, dtype, defaultintensiteit, internationalenaam, naam, wervingsnaam, diplomatekst1, diplomatekst2, diplomatekst3, leerweg) FROM stdin;
\.


--
-- Data for Name: opleidingaanbod; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.opleidingaanbod (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, locatie, opleiding, organisatie, organisatieeenheid, team, version) FROM stdin;
\.


--
-- Data for Name: opleidingfase; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.opleidingfase (credits, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, opleiding, organisatie, version, hoofdfase, opleidingsvorm) FROM stdin;
\.


--
-- Data for Name: organisatie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organisatie (actief, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, code, id, version, dtype, naam, wikipassword, wikiuser) FROM stdin;
\.


--
-- Data for Name: organisatieeenheid; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organisatieeenheid (begindatum, einddatum, einddatumnotnull, gearchiveerd, intakewizardstap3overslaan, tonenbijdigitaalaanmelden, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, parent, soortorganisatieeenheid, version, afkorting, bankrekeningnummer, naam, officielenaam) FROM stdin;
\.


--
-- Data for Name: organisatieeenheidcg; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organisatieeenheidcg (gearchiveerd, geheim, volgorde, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, organisatieeenheid, soortcontactgegeven, version, contactgegeven) FROM stdin;
\.


--
-- Data for Name: organisatieeenheidlocatie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organisatieeenheidlocatie (begindatum, einddatum, einddatumnotnull, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, locatie, organisatie, organisatieeenheid, version) FROM stdin;
\.


--
-- Data for Name: organisatiemedewerker; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organisatiemedewerker (begindatum, einddatum, einddatumnotnull, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, locatie, medewerker, organisatie, organisatieeenheid, version) FROM stdin;
\.


--
-- Data for Name: organisatiesetting; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organisatiesetting (absentiepresentie, actief, blokkadedatumbpv, blokkadedatumverbintenis, booleanvalue, deelnemernummerisdebiteurnr, gearchiveerd, gezamenlijkerange, hoofdletters, intvalue, leestekens, lengte, loginpogingactief, pogingen, poortnummer, sessietimeout, timeout, created_at, created_by, last_modified_at, last_modified_by, account, id, lesweekindeling, organisatie, organisatieeenheid, version, apikey, ipadressen, dtype, maniervanaanmelden, host, stringvalue, wachtwoord) FROM stdin;
\.


--
-- Data for Name: orgehdcontactpersoon; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orgehdcontactpersoon (begindatum, einddatum, einddatumnotnull, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, organisatieeenheid, rol, version, emailadres, mobiel, telefoon, naam, geslacht) FROM stdin;
\.


--
-- Data for Name: periode; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.periode (gearchiveerd, volgnummer, created_at, created_by, last_modified_at, last_modified_by, datumbegin, datumeind, id, idinoudpakket, organisatie, periodeindeling, version) FROM stdin;
\.


--
-- Data for Name: periodeindeling; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.periodeindeling (gearchiveerd, schooljaar, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, organisatieeenheid, version, omschrijving) FROM stdin;
\.


--
-- Data for Name: persoon; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.persoon (betalingstermijn, datuminnederland, datumoverlijden, gearchiveerd, geboortedatum, nietverstrekkenaanderden, nieuwkomer, created_at, created_by, last_modified_at, last_modified_by, afbeelding, automatischeincassoeinddatum, bsn, debiteurennummer, geboortegemeente, geboorteland, geboortelandouder1, geboortelandouder2, id, idinoudpakket, laatsteexportdatum, landbank, nationaliteit1, nationaliteit2, organisatie, verblijfsvergunning, version, bankrekeningnummer, automatischeincasso, officielevoorvoegsel, voorletters, factuurbetaalwijze, buitenlandsbankrekeningnummer, roepnaam, buitenlandsebanknaam, bankrekeningtenaamstelling, achternaam, lowercaseachternaam, officieleachternaam, voornamen, wachtwoord, berekendezoeknaam, burgerlijkestaat, correspondentietaal, cumicategorie, cumiratio, geboorteplaats, geslacht, toepassinggeboortedatum, voorvoegsel) FROM stdin;
\.


--
-- Data for Name: persooncontactgegeven; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.persooncontactgegeven (gearchiveerd, geheim, volgorde, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, persoon, soortcontactgegeven, version, contactgegeven) FROM stdin;
\.


--
-- Data for Name: persoonextorgcontactpersoon; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.persoonextorgcontactpersoon (begindatum, einddatum, einddatumnotnull, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, extorgcontactpersoon, id, idinoudpakket, organisatie, persoonexterneorganisatie, version) FROM stdin;
\.


--
-- Data for Name: persoonlijketoetscode; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.persoonlijketoetscode (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, medewerker, organisatie, toets, version, code) FROM stdin;
\.


--
-- Data for Name: plaats; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.plaats (gearchiveerd, uniek, uniekmetprovincie, created_at, created_by, last_modified_at, last_modified_by, gemeente, id, provincie, version, naam, sorteernaam) FROM stdin;
\.


--
-- Data for Name: planningtemplate; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.planningtemplate (aantaleenhedennaaanvang, aantaleenhedentussenherhaling, gearchiveerd, stoptnaaantaleenheden, stoptnaaantalkeer, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, eenheidtussenherhaling, stoptnaeenheid, tijdeenheid) FROM stdin;
\.


--
-- Data for Name: productregel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.productregel (aantaldecimalen, gearchiveerd, minimalewaarde, verplicht, volgnummer, created_at, created_by, last_modified_at, last_modified_by, alleonderwprodtoestaanvan, cohort, fase, id, idinoudpakket, opleiding, organisatie, soortproductregel, verbintenisgebied, version, minimalewaardetekst, afkorting, naam, typeproductregel) FROM stdin;
\.


--
-- Data for Name: provincie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.provincie (begindatum, einddatum, einddatumnotnull, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, version, afkorting, code, naam) FROM stdin;
\.


--
-- Data for Name: rapportagetemplate; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rapportagetemplate (begindatum, einddatum, einddatumnotnull, gearchiveerd, includellb, includetaal, includeuitstroom, includevrijematrices, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, medewerker, organisatie, samenvoegenhtml, samenvoegenpdfconfig, version, voortganghtmlconfig, voortgangpdfconfig, naam, outputform, purpose) FROM stdin;
\.


--
-- Data for Name: rapportagetemplateijkpunt; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rapportagetemplateijkpunt (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, config, configpdf, id, idinoudpakket, ijkpunt, organisatie, version) FROM stdin;
\.


--
-- Data for Name: recht; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recht (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, organisatie, rol, version, actionclassname, principalsourceclassname) FROM stdin;
\.


--
-- Data for Name: redenuitdienst; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.redenuitdienst (actief, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, code, naam) FROM stdin;
\.


--
-- Data for Name: redenuitschrijving; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.redenuitschrijving (actief, gearchiveerd, geslaagd, overlijden, tonenbijbpv, tonenbijverbintenis, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, code, naam, redenuitval, uitstroomredenwi) FROM stdin;
\.


--
-- Data for Name: regio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.regio (begindatum, einddatum, einddatumnotnull, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, version, code, naam) FROM stdin;
\.


--
-- Data for Name: relatiesoort; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.relatiesoort (actief, gearchiveerd, organisatieopname, persoonopname, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, code, naam) FROM stdin;
\.


--
-- Data for Name: resultaat; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resultaat (actueel, cijfer, datumbehaald, gearchiveerd, geldend, herkansingsnummer, insamengesteld, onafgerondcijfer, score, studiepunten, weging, created_at, created_by, last_modified_at, last_modified_by, deelnemer, id, idinoudpakket, ingevoerddoor, organisatie, overschrijft, toets, version, waarde, soort, berekening, notitie) FROM stdin;
\.


--
-- Data for Name: resultaatstructuur; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resultaatstructuur (actief, gearchiveerd, specifiek, created_at, created_by, last_modified_at, last_modified_by, auteur, categorie, cohort, eindresultaat, id, idinoudpakket, onderwijsproduct, organisatie, version, code, naam, status, type) FROM stdin;
\.


--
-- Data for Name: resultaatstructuurcategorie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resultaatstructuurcategorie (actief, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, naam) FROM stdin;
\.


--
-- Data for Name: resultaatstructuurdeelnemer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resultaatstructuurdeelnemer (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, deelnemer, groep, id, idinoudpakket, organisatie, resultaatstructuur, version) FROM stdin;
\.


--
-- Data for Name: resultaatstructuurmedewerker; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resultaatstructuurmedewerker (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, medewerker, organisatie, resultaatstructuur, version) FROM stdin;
\.


--
-- Data for Name: resultaatzoekfilterinstelling; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resultaatzoekfilterinstelling (gearchiveerd, gekoppeldaanverbintenis, created_at, created_by, last_modified_at, last_modified_by, categorie, id, idinoudpakket, medewerker, organisatie, version, codepath, type) FROM stdin;
\.


--
-- Data for Name: rol; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rol (gearchiveerd, zorglijn, created_at, created_by, last_modified_at, last_modified_by, id, organisatie, version, categorie, naam, authorisatieniveau, rechtensoort) FROM stdin;
\.


--
-- Data for Name: samenvoegenhtmlconfig; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.samenvoegenhtmlconfig (begindatum, einddatum, einddatumnotnull, gearchiveerd, samenvoegentot, samenvoegenvanaf, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, categoryproperty, graphtype) FROM stdin;
\.


--
-- Data for Name: samenvoegenpdfconfig; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.samenvoegenpdfconfig (begindatum, einddatum, einddatumnotnull, gearchiveerd, samenvoegentot, samenvoegenvanaf, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, categoryaggregation, categoryproperty, graphtype) FROM stdin;
\.


--
-- Data for Name: schaal; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.schaal (aantaldecimalen, actief, gearchiveerd, maximum, minimum, minimumvoorbehaald, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, naam, schaaltype) FROM stdin;
\.


--
-- Data for Name: schaalwaarde; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.schaalwaarde (behaald, gearchiveerd, nominalewaarde, totcijfer, vanafcijfer, volgnummer, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, schaal, version, externewaarde, internewaarde, naam) FROM stdin;
\.


--
-- Data for Name: schooladvies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.schooladvies (actief, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, naam) FROM stdin;
\.


--
-- Data for Name: scoreschaalwaarde; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.scoreschaalwaarde (gearchiveerd, totscore, vanafscore, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, toets, version, waarde, advies) FROM stdin;
\.


--
-- Data for Name: sessie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sessie (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, account, id, idinoudpakket, logintime, organisatie, version) FROM stdin;
\.


--
-- Data for Name: signaal; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.signaal (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, datumgelezen, event, id, idinoudpakket, ontvanger, organisatie, version) FROM stdin;
\.


--
-- Data for Name: soortcontactgegeven; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.soortcontactgegeven (actief, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, code, naam, standaardcontactgegeven, typecontactgegeven) FROM stdin;
\.


--
-- Data for Name: soortcontract; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.soortcontract (actief, gearchiveerd, inburgering, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, code, naam) FROM stdin;
\.


--
-- Data for Name: soortcontractverplichting; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.soortcontractverplichting (actief, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, code, naam) FROM stdin;
\.


--
-- Data for Name: soortexterneorganisatie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.soortexterneorganisatie (actief, brin, gearchiveerd, tonenbijvooropleiding, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, code, naam) FROM stdin;
\.


--
-- Data for Name: soortonderwijsproduct; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.soortonderwijsproduct (actief, gearchiveerd, stage, summatief, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, code, naam) FROM stdin;
\.


--
-- Data for Name: soortorgehd; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.soortorgehd (actief, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, code, naam) FROM stdin;
\.


--
-- Data for Name: soortpraktijklokaal; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.soortpraktijklokaal (actief, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, code, naam) FROM stdin;
\.


--
-- Data for Name: soortproductregel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.soortproductregel (actief, gearchiveerd, volgnummer, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, taxonomie, version, diplomanaam, naam) FROM stdin;
\.


--
-- Data for Name: soortvooropleiding; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.soortvooropleiding (actief, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, code, naam, soortonderwijsmetdiploma, soortonderwijszonderdiploma) FROM stdin;
\.


--
-- Data for Name: soortvooropleidingbuitenlands; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.soortvooropleidingbuitenlands (actief, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, land, version, code, naam) FROM stdin;
\.


--
-- Data for Name: soortvooropleidingho; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.soortvooropleidingho (actief, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, version, code, naam) FROM stdin;
\.


--
-- Data for Name: specifiekevraag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.specifiekevraag (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, inschrijvingsverzoek, organisatie, version, vraagcode, vraag) FROM stdin;
\.


--
-- Data for Name: specifiekevraagantwoord; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.specifiekevraagantwoord (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, specifiekevraag, version, antwoordcode, antwoord) FROM stdin;
\.


--
-- Data for Name: sslcertificaat; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sslcertificaat (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, subject, certificaat) FROM stdin;
\.


--
-- Data for Name: standaardtoetscodefilter; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.standaardtoetscodefilter (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, cohort, id, idinoudpakket, opleiding, organisatie, toetscodefilter, version) FROM stdin;
\.


--
-- Data for Name: studielinkbericht; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.studielinkbericht (gearchiveerd, ontvanger, verzender, created_at, created_by, last_modified_at, last_modified_by, deelnemer, id, idinoudpakket, inschrijvingsverzoek, organisatie, version, type, xmlresponse) FROM stdin;
\.


--
-- Data for Name: taaksoort; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.taaksoort (actief, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, locatie, organisatie, organisatieeenheid, version, naam) FROM stdin;
\.


--
-- Data for Name: taalkeuze; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.taalkeuze (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, taal, verbintenis, version) FROM stdin;
\.


--
-- Data for Name: taalscore; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.taalscore (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, meeteenheidwaarde, organisatie, taalbeoordeling, taalvaardigheid, version) FROM stdin;
\.


--
-- Data for Name: taalscoreniveauverzameling; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.taalscoreniveauverzameling (datum, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, deelnemer, id, medewerker, meeteenheid, taal, taaltype, uitstroom, version, dtype, mboniveau) FROM stdin;
\.


--
-- Data for Name: taaltype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.taaltype (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, version, titel) FROM stdin;
\.


--
-- Data for Name: taaltypekoppel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.taaltypekoppel (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, taal, type, version) FROM stdin;
\.


--
-- Data for Name: taalvaardigheid; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.taalvaardigheid (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, version, titel) FROM stdin;
\.


--
-- Data for Name: taxonomieelement; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.taxonomieelement (begindatum, brinkenniscentrum, einddatum, einddatumnotnull, gearchiveerd, hoofdstuk, lwoo, nummer, prijsfactor, studiebelastingsuren, uitzonderlijk, volgnummer, wettelijkeeisen, code, created_at, created_by, last_modified_at, last_modified_by, competentie, competentiematrix, deelnemer, dossier, id, idinoudpakket, kerntaak, lwootaxonomieelement, meeteenheid, organisatie, parent, taxonomie, taxonomieelementtype, version, werkproces, bronwettelijkeeisen, codecoordinatiepunt, externecode, dtype, afkorting, naamkenniscentrum, diplomanaam, internationalenaam, naam, taxonomiecode, zoekparentcode, sorteercode, niveau, profiel, sector, soortopleiding, titel, uitstroomtype, indicator, omschrijving, resultaat) FROM stdin;
\.


--
-- Data for Name: taxonomieelementmboleerweg; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.taxonomieelementmboleerweg (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, taxonomieelement, version, mboleerweg) FROM stdin;
\.


--
-- Data for Name: taxonomieelementtype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.taxonomieelementtype (diplomeerbaar, gearchiveerd, inschrijfbaar, volgnummer, afkorting, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, parent, taxonomie, version, naam, soort) FROM stdin;
\.


--
-- Data for Name: team; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.team (actief, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, code, naam) FROM stdin;
\.


--
-- Data for Name: tekenbevoegdheid; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tekenbevoegdheid (begindatum, bpvovereenkomst, einddatum, einddatumnotnull, gearchiveerd, onderwijsovereenkomst, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, medewerker, organisatie, organisatieeenheid, version) FROM stdin;
\.


--
-- Data for Name: testcategorie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.testcategorie (actief, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, code, naam) FROM stdin;
\.


--
-- Data for Name: testdefinitie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.testdefinitie (actief, besprekentonen, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, afspraaktype, categorie, id, idinoudpakket, organisatie, version, naam) FROM stdin;
\.


--
-- Data for Name: testveld; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.testveld (gearchiveerd, hoofdscoreveld, maximumwaarde, minimumwaarde, verplicht, volgnummer, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, testdefinitie, version, naam, type) FROM stdin;
\.


--
-- Data for Name: toegekendhulpmiddel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.toegekendhulpmiddel (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, bijzonderheid, hulpmiddel, id, idinoudpakket, organisatie, version) FROM stdin;
\.


--
-- Data for Name: toegestaandeelgebied; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.toegestaandeelgebied (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, deelgebied, id, productregel, version) FROM stdin;
\.


--
-- Data for Name: toegestaanhulpmiddel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.toegestaanhulpmiddel (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, bijzonderheidcategorie, hulpmiddel, id, idinoudpakket, organisatie, version) FROM stdin;
\.


--
-- Data for Name: toegestaanonderwijsproduct; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.toegestaanonderwijsproduct (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, onderwijsproduct, organisatie, productregel, version) FROM stdin;
\.


--
-- Data for Name: toegestanebeginstatus; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.toegestanebeginstatus (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, examenstatus, id, idinoudpakket, organisatie, toegestaneexamenstatusovergang, version) FROM stdin;
\.


--
-- Data for Name: toegestanestatussoort; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.toegestanestatussoort (defaultstatus, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, trajectstatussoort, trajectsoort, version) FROM stdin;
\.


--
-- Data for Name: toegexamenstatusovergang; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.toegexamenstatusovergang (bepaaltdatumuitslag, examennummerstoekennen, gearchiveerd, handmatigopmerkingeninvoeren, tijdvakaangeven, volgnummer, created_at, created_by, last_modified_at, last_modified_by, afgewezenexamenstatus, examenworkflow, id, idinoudpakket, naarexamenstatus, organisatie, version, actie, actieindividueel, actieindividueelkort) FROM stdin;
\.


--
-- Data for Name: toets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.toets (aantalherkansingen, alternatiefcombinerenmethoofd, alternatiefresultaatmogelijk, automatischeweging, compenseerbaarvanaf, eindtoets, gearchiveerd, handmatiginleveren, maxaantalingevuld, maxaantalnietbehaald, minaantalingevuld, minstudiepuntenvoorbehaald, overschrijfbaar, referentieversie, samengesteld, samengesteldmetherkansing, samengesteldmetvarianten, scoreschaallengtetijdvak1, scoreschaallengtetijdvak2, scoreschaallengtetijdvak3, scoreschaalnormeringtijdvak1, scoreschaalnormeringtijdvak2, scoreschaalnormeringtijdvak3, studiepunten, variantvoorpoging, verplicht, verwijsbaar, volgnummer, weging, created_at, created_by, last_modified_at, last_modified_by, bevrorenpogingen, id, idinoudpakket, organisatie, parent, resultaatstructuur, schaal, version, code, referentiecode, naam, codepath, formule, rekenregel, scorebijherkansing, scoreschaal, soort) FROM stdin;
\.


--
-- Data for Name: toetscodefilter; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.toetscodefilter (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, medewerker, organisatie, version, naam, toetscodes) FROM stdin;
\.


--
-- Data for Name: toetscodefilterorgehdloc; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.toetscodefilterorgehdloc (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, locatie, organisatie, organisatieeenheid, toetscodefilter, version) FROM stdin;
\.


--
-- Data for Name: toetsverwijzing; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.toetsverwijzing (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, lezenuit, organisatie, schrijvenin, version) FROM stdin;
\.


--
-- Data for Name: traject; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.traject (begindatum, beoogdeeinddatum, einddatum, einddatumnotnull, gearchiveerd, vertrouwelijk, zorglijn, created_at, created_by, last_modified_at, last_modified_by, template, verantwoordelijke, deelnemer, eindhandelingtemplate, id, idinoudpakket, organisatie, trajectsoort, trajectstatussoort, verbintenis, version, omschrijving, titel, aanleiding, beginsituatie, doelen, handelingen) FROM stdin;
\.


--
-- Data for Name: trajectbeghandelingtemplate; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.trajectbeghandelingtemplate (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, begeleidingshandeling, id, idinoudpakket, organisatie, trajecttemplate, version) FROM stdin;
\.


--
-- Data for Name: trajectsoort; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.trajectsoort (actief, gearchiveerd, handelingsplan, created_at, created_by, last_modified_at, last_modified_by, defaultgespreksoort, defaulttaaksoort, defaulttestdefinitie, id, idinoudpakket, locatie, organisatie, organisatieeenheid, version, kwadrant, naam, beginsituatietemplate, doelentemplate, handelingentemplate) FROM stdin;
\.


--
-- Data for Name: trajectstatusovergang; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.trajectstatusovergang (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, datumtijd, id, idinoudpakket, medewerker, naarstatus, organisatie, traject, vanstatus, version) FROM stdin;
\.


--
-- Data for Name: trajectstatussoort; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.trajectstatussoort (actief, gearchiveerd, trajectafgesloten, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, omschrijving) FROM stdin;
\.


--
-- Data for Name: trajecttemplate; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.trajecttemplate (actief, gearchiveerd, opeerstedagschooljaar, tijdsduuraantal, zorglijn, created_at, created_by, eindhandelingtemplate, last_modified_at, last_modified_by, automatischekoppeling, id, idinoudpakket, locatie, organisatie, organisatieeenheid, trajectsoort, version, naam, omschrijving, tijdsduureenheid) FROM stdin;
\.


--
-- Data for Name: trajecttemplatekoppeling; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.trajecttemplatekoppeling (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, kenmerk, opleiding, organisatie, organisatieeenheid, trajtemplautokopp, version, dtype) FROM stdin;
\.


--
-- Data for Name: trajectuitvoerder; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.trajectuitvoerder (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, medewerker, traject, id, idinoudpakket, organisatie, version) FROM stdin;
\.


--
-- Data for Name: trajtemplautokopp; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.trajtemplautokopp (alleenintakestatussen, alleennieuwedeelnemers, datumbeschikbaar, datumeindebeschikbaar, gearchiveerd, indicatiegehandicapt, indicatielwoo, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version) FROM stdin;
\.


--
-- Data for Name: typefinanciering; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.typefinanciering (actief, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, code, naam) FROM stdin;
\.


--
-- Data for Name: typelocatie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.typelocatie (actief, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, code, naam) FROM stdin;
\.


--
-- Data for Name: typetoets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.typetoets (actief, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, code, naam) FROM stdin;
\.


--
-- Data for Name: uitkomstintakegesprek; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.uitkomstintakegesprek (actief, gearchiveerd, succesvol, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, code, naam) FROM stdin;
\.


--
-- Data for Name: vaardigheid; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vaardigheid (gearchiveerd, nummer, created_at, created_by, last_modified_at, last_modified_by, dossier, id, idinoudpakket, organisatie, version, titel) FROM stdin;
\.


--
-- Data for Name: vakantie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vakantie (begindatum, einddatum, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, basisrooster, id, idinoudpakket, organisatie, version, naam) FROM stdin;
\.


--
-- Data for Name: vasco_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vasco_tokens (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, gebruiker, id, idinoudpakket, organisatie, version, applicatie, serienummer, digipassdata, initieledata, status) FROM stdin;
\.


--
-- Data for Name: veldwaarde; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.veldwaarde (gearchiveerd, intwaarde, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, test, testveld, version, dtype, stringwaarde) FROM stdin;
\.


--
-- Data for Name: verbintenis; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.verbintenis (begindatum, contacturenperweek, datumaanmelden, datumakkoord, datumdefinitief, datumeersteactiviteit, datumgeplaatst, datumovereenkomstondertekend, datumvoorlopig, deelcursus, einddatum, einddatumnotnull, examendatum, gearchiveerd, geplandeeinddatum, indicatiegehandicapt, negeerwettcollgeldvoorwaarden, uitsluitenvanfacturatie, volgnummer, created_at, created_by, last_modified_at, last_modified_by, brin, brondatum, cohort, deelnemer, id, idinoudpakket, locatie, opleiding, organisatie, organisatieeenheid, overeenkomstnummer, redenuitschrijving, relevanteverbintenis, relevantevooropleiding, version, vervolgonderwijs, afwijkendeexternecode, beginnivschrvaardigheden, bekostigd, bronstatus, eindnivschrvaardigheden, intensiteit, leerprofiel, profielinburgering, redeninburgering, soortpraktijkexamen, staatsexamentype, status, vertrekstatus, volgnummerinoudpakket, toelichting) FROM stdin;
\.


--
-- Data for Name: verbinteniscontract; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.verbinteniscontract (begindatum, datumbeschikking, einddatum, einddatumnotnull, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, contract, extorgcontactpersoon, id, idinoudpakket, onderdeel, organisatie, verbintenis, version, externnummer) FROM stdin;
\.


--
-- Data for Name: verbintenisfasecredits; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.verbintenisfasecredits (bevroren, credits, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, fase, id, idinoudpakket, organisatie, verbintenis, version) FROM stdin;
\.


--
-- Data for Name: verbintenisgebiedonderdeel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.verbintenisgebiedonderdeel (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, child, id, idinoudpakket, organisatie, parent, version) FROM stdin;
\.


--
-- Data for Name: verblijfsvergunning; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.verblijfsvergunning (actief, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, version, code, naam) FROM stdin;
\.


--
-- Data for Name: verbruiksmiddel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.verbruiksmiddel (actief, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, code, naam) FROM stdin;
\.


--
-- Data for Name: vertasigdefevconkoppel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vertasigdefevconkoppel (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, abonnementconfiguration, id, idinoudpakket, organisatie, signaaldefinitie, version) FROM stdin;
\.


--
-- Data for Name: vervolghandeling; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vervolghandeling (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, vervolg, voorafgaand) FROM stdin;
\.


--
-- Data for Name: vervolgonderwijs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vervolgonderwijs (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, code, id, idinoudpakket, organisatie, version, naam, plaats, soortvervolgonderwijs) FROM stdin;
\.


--
-- Data for Name: verzuimtaaksignaaldefinitie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.verzuimtaaksignaaldefinitie (aantalweken, aantalwekenaaneen, aantalklokuren, gearchiveerd, ongeoorlooft, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, omschrijving, signaalnaam, soortdeelnemer) FROM stdin;
\.


--
-- Data for Name: vooropleiding; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vooropleiding (aantaljarenonderwijs, aantaljarenzelfinvullen, begindatum, citoscore, diplomabehaald, einddatum, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, deelnemer, externeorganisatie, id, idinoudpakket, land, organisatie, schooladvies, soortvooropleiding, soortvooropleidingbuitenlands, soortvooropleidingcroho, soortvooropleidingho, verificatiebrin, verificatiedatum, version, verificatiedoormedewerker, verificatiedoorinstelling, naam, plaats, vooropleidingnaam, soortorganisatie, verificatiestatus) FROM stdin;
\.


--
-- Data for Name: vooropleidingsignaalcode; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vooropleidingsignaalcode (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, vooropleiding, signaalcode) FROM stdin;
\.


--
-- Data for Name: vooropleidingvak; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vooropleidingvak (actief, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, version, code, naam) FROM stdin;
\.


--
-- Data for Name: vooropleidingvakresultaat; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vooropleidingvakresultaat (gearchiveerd, letter, score, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, vak, version, vooropleiding, status) FROM stdin;
\.


--
-- Data for Name: voortganghtmlconfig; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.voortganghtmlconfig (aantalbeoordelingen, begindatum, einddatum, einddatumnotnull, gearchiveerd, includeevcevk, includeinvidueleijkpunten, includelokaalmaximum, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, categoryproperty, graphtype) FROM stdin;
\.


--
-- Data for Name: voortgangpdfconfig; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.voortgangpdfconfig (aantalbeoordelingen, begindatum, einddatum, einddatumnotnull, gearchiveerd, includeevcevk, includeinvidueleijkpunten, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, categoryaggregation, categoryproperty, graphtype) FROM stdin;
\.


--
-- Data for Name: voorvoegsel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.voorvoegsel (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, version, naam) FROM stdin;
\.


--
-- Data for Name: vrijveld; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vrijveld (actief, dossierscherm, gearchiveerd, intakescherm, uitgebreidzoeken, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, taxonomie, version, categorie, naam, type) FROM stdin;
\.


--
-- Data for Name: vrijveldentiteit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vrijveldentiteit (checkwaarde, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, bpvinschrijving, contract, datewaarde, externeorganisatie, groep, id, idinoudpakket, intakegesprek, keuze, medewerker, numberwaarde, onderwijsproduct, opleiding, organisatie, persoon, plaatsing, relatie, verbintenis, version, vooropleiding, vrijveld, dtype, textwaarde, longtextwaarde) FROM stdin;
\.


--
-- Data for Name: vrijveldkeuzeoptie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vrijveldkeuzeoptie (actief, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, id, idinoudpakket, organisatie, version, vrijveld, naam) FROM stdin;
\.


--
-- Data for Name: vrijveldoptiekeuze; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vrijveldoptiekeuze (gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, entiteit, id, idinoudpakket, optie, organisatie, version) FROM stdin;
\.


--
-- Data for Name: waarneming; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.waarneming (afgehandeld, beginlesuur, eindlesuur, gearchiveerd, created_at, created_by, last_modified_at, last_modified_by, absentiemelding, afspraak, begindatumtijd, deelnemer, einddatumtijd, id, idinoudpakket, onderwijsproduct, organisatie, version, waarnemingsoort) FROM stdin;
\.


--
-- Name: hibernate_sequence; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.hibernate_sequence', 1, false);


--
-- Name: aanbodperiode aanbodperiode_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aanbodperiode
    ADD CONSTRAINT aanbodperiode_pkey PRIMARY KEY (id);


--
-- Name: aanleiding aanleiding_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aanleiding
    ADD CONSTRAINT aanleiding_pkey PRIMARY KEY (id);


--
-- Name: aanleidingtemplate aanleidingtemplate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aanleidingtemplate
    ADD CONSTRAINT aanleidingtemplate_pkey PRIMARY KEY (id);


--
-- Name: aanmelding aanmelding_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aanmelding
    ADD CONSTRAINT aanmelding_pkey PRIMARY KEY (id);


--
-- Name: aanwezigentemplate aanwezigentemplate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aanwezigentemplate
    ADD CONSTRAINT aanwezigentemplate_pkey PRIMARY KEY (id);


--
-- Name: absentiemelding absentiemelding_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.absentiemelding
    ADD CONSTRAINT absentiemelding_pkey PRIMARY KEY (id);


--
-- Name: absentiereden absentiereden_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.absentiereden
    ADD CONSTRAINT absentiereden_pkey PRIMARY KEY (id);


--
-- Name: abstractdeelnemerevent abstractdeelnemerevent_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.abstractdeelnemerevent
    ADD CONSTRAINT abstractdeelnemerevent_pkey PRIMARY KEY (id);


--
-- Name: abstractrelatie abstractrelatie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.abstractrelatie
    ADD CONSTRAINT abstractrelatie_pkey PRIMARY KEY (id);


--
-- Name: abstractrelatie abstractrelatie_relatiesoort_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.abstractrelatie
    ADD CONSTRAINT abstractrelatie_relatiesoort_key UNIQUE (relatiesoort);


--
-- Name: account account_gebruikersnaam_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_gebruikersnaam_organisatie_key UNIQUE (gebruikersnaam, organisatie);


--
-- Name: account account_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_pkey PRIMARY KEY (id);


--
-- Name: accountrol accountrol_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accountrol
    ADD CONSTRAINT accountrol_pkey PRIMARY KEY (id);


--
-- Name: adres adres_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adres
    ADD CONSTRAINT adres_pkey PRIMARY KEY (id);


--
-- Name: adresentiteit adresentiteit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adresentiteit
    ADD CONSTRAINT adresentiteit_pkey PRIMARY KEY (id);


--
-- Name: afspraak afspraak_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.afspraak
    ADD CONSTRAINT afspraak_pkey PRIMARY KEY (id);


--
-- Name: afspraakdeelnemer afspraakdeelnemer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.afspraakdeelnemer
    ADD CONSTRAINT afspraakdeelnemer_pkey PRIMARY KEY (id);


--
-- Name: afspraakparticipant afspraakparticipant_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.afspraakparticipant
    ADD CONSTRAINT afspraakparticipant_pkey PRIMARY KEY (id);


--
-- Name: afspraaktype afspraaktype_naam_organisatieeenheid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.afspraaktype
    ADD CONSTRAINT afspraaktype_naam_organisatieeenheid_key UNIQUE (naam, organisatieeenheid);


--
-- Name: afspraaktype afspraaktype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.afspraaktype
    ADD CONSTRAINT afspraaktype_pkey PRIMARY KEY (id);


--
-- Name: agendainstellingen agendainstellingen_persoon_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.agendainstellingen
    ADD CONSTRAINT agendainstellingen_persoon_key UNIQUE (persoon);


--
-- Name: agendainstellingen agendainstellingen_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.agendainstellingen
    ADD CONSTRAINT agendainstellingen_pkey PRIMARY KEY (id);


--
-- Name: aggregatieniveau aggregatieniveau_code_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aggregatieniveau
    ADD CONSTRAINT aggregatieniveau_code_organisatie_key UNIQUE (code, organisatie);


--
-- Name: aggregatieniveau aggregatieniveau_niveau_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aggregatieniveau
    ADD CONSTRAINT aggregatieniveau_niveau_organisatie_key UNIQUE (niveau, organisatie);


--
-- Name: aggregatieniveau aggregatieniveau_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aggregatieniveau
    ADD CONSTRAINT aggregatieniveau_pkey PRIMARY KEY (id);


--
-- Name: basisrooster basisrooster_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.basisrooster
    ADD CONSTRAINT basisrooster_pkey PRIMARY KEY (id);


--
-- Name: begeleidingshandeling begeleidingshandeling_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.begeleidingshandeling
    ADD CONSTRAINT begeleidingshandeling_pkey PRIMARY KEY (id);


--
-- Name: begeleidingshandelingtemplate begeleidingshandelingtemplate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.begeleidingshandelingtemplate
    ADD CONSTRAINT begeleidingshandelingtemplate_pkey PRIMARY KEY (id);


--
-- Name: begeleidingshandelingtemplate begeleidingshandelingtemplate_planning_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.begeleidingshandelingtemplate
    ADD CONSTRAINT begeleidingshandelingtemplate_planning_key UNIQUE (planning);


--
-- Name: beghandstatovrgang beghandstatovrgang_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.beghandstatovrgang
    ADD CONSTRAINT beghandstatovrgang_pkey PRIMARY KEY (id);


--
-- Name: bekostigingsperiode bekostigingsperiode_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bekostigingsperiode
    ADD CONSTRAINT bekostigingsperiode_pkey PRIMARY KEY (id);


--
-- Name: betrokkenmedewerker betrokkenmedewerker_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.betrokkenmedewerker
    ADD CONSTRAINT betrokkenmedewerker_pkey PRIMARY KEY (id);


--
-- Name: bijlage bijlage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bijlage
    ADD CONSTRAINT bijlage_pkey PRIMARY KEY (id);


--
-- Name: bijlageentiteit bijlageentiteit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bijlageentiteit
    ADD CONSTRAINT bijlageentiteit_pkey PRIMARY KEY (id);


--
-- Name: bijzonderheid bijzonderheid_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bijzonderheid
    ADD CONSTRAINT bijzonderheid_pkey PRIMARY KEY (id);


--
-- Name: bijzonderheidcategorie bijzonderheidcategorie_code_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bijzonderheidcategorie
    ADD CONSTRAINT bijzonderheidcategorie_code_organisatie_key UNIQUE (code, organisatie);


--
-- Name: bijzonderheidcategorie bijzonderheidcategorie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bijzonderheidcategorie
    ADD CONSTRAINT bijzonderheidcategorie_pkey PRIMARY KEY (id);


--
-- Name: bookmark bookmark_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookmark
    ADD CONSTRAINT bookmark_pkey PRIMARY KEY (id);


--
-- Name: bookmarkconstructorargument bookmarkconstructorargument_bookmark_volgorde_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookmarkconstructorargument
    ADD CONSTRAINT bookmarkconstructorargument_bookmark_volgorde_key UNIQUE (bookmark, volgorde);


--
-- Name: bookmarkconstructorargument bookmarkconstructorargument_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookmarkconstructorargument
    ADD CONSTRAINT bookmarkconstructorargument_pkey PRIMARY KEY (id);


--
-- Name: bookmarkfolder bookmarkfolder_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookmarkfolder
    ADD CONSTRAINT bookmarkfolder_pkey PRIMARY KEY (id);


--
-- Name: bpvbedrijfsgegeven bpvbedrijfsgegeven_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvbedrijfsgegeven
    ADD CONSTRAINT bpvbedrijfsgegeven_pkey PRIMARY KEY (id);


--
-- Name: bpvcoloplaats bpvcoloplaats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvcoloplaats
    ADD CONSTRAINT bpvcoloplaats_pkey PRIMARY KEY (id);


--
-- Name: bpvcriteria bpvcriteria_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvcriteria
    ADD CONSTRAINT bpvcriteria_pkey PRIMARY KEY (id);


--
-- Name: bpvcriteriabpvdeelnemerprofiel bpvcriteriabpvdeelnemerprofiel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvcriteriabpvdeelnemerprofiel
    ADD CONSTRAINT bpvcriteriabpvdeelnemerprofiel_pkey PRIMARY KEY (id);


--
-- Name: bpvcriteriabpvkandidaat bpvcriteriabpvkandidaat_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvcriteriabpvkandidaat
    ADD CONSTRAINT bpvcriteriabpvkandidaat_pkey PRIMARY KEY (id);


--
-- Name: bpvcriteriabpvplaats bpvcriteriabpvplaats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvcriteriabpvplaats
    ADD CONSTRAINT bpvcriteriabpvplaats_pkey PRIMARY KEY (id);


--
-- Name: bpvcriteriaexterneorganisatie bpvcriteriaexterneorganisatie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvcriteriaexterneorganisatie
    ADD CONSTRAINT bpvcriteriaexterneorganisatie_pkey PRIMARY KEY (id);


--
-- Name: bpvcriteriaonderwijsproduct bpvcriteriaonderwijsproduct_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvcriteriaonderwijsproduct
    ADD CONSTRAINT bpvcriteriaonderwijsproduct_pkey PRIMARY KEY (id);


--
-- Name: bpvdeelnemerprofiel bpvdeelnemerprofiel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvdeelnemerprofiel
    ADD CONSTRAINT bpvdeelnemerprofiel_pkey PRIMARY KEY (id);


--
-- Name: bpvinschrijving bpvinschrijving_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvinschrijving
    ADD CONSTRAINT bpvinschrijving_pkey PRIMARY KEY (id);


--
-- Name: bpvkandidaat bpvkandidaat_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvkandidaat
    ADD CONSTRAINT bpvkandidaat_pkey PRIMARY KEY (id);


--
-- Name: bpvkandidaatonderwijsproduct bpvkandidaatonderwijsproduct_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvkandidaatonderwijsproduct
    ADD CONSTRAINT bpvkandidaatonderwijsproduct_pkey PRIMARY KEY (id);


--
-- Name: bpvmatch bpvmatch_bpvkandidaat_keuzevolgnummer_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvmatch
    ADD CONSTRAINT bpvmatch_bpvkandidaat_keuzevolgnummer_key UNIQUE (bpvkandidaat, keuzevolgnummer);


--
-- Name: bpvmatch bpvmatch_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvmatch
    ADD CONSTRAINT bpvmatch_pkey PRIMARY KEY (id);


--
-- Name: bpvplaats bpvplaats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvplaats
    ADD CONSTRAINT bpvplaats_pkey PRIMARY KEY (id);


--
-- Name: bpvplaatsopleiding bpvplaatsopleiding_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvplaatsopleiding
    ADD CONSTRAINT bpvplaatsopleiding_pkey PRIMARY KEY (id);


--
-- Name: budget budget_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.budget
    ADD CONSTRAINT budget_pkey PRIMARY KEY (id);


--
-- Name: cacheregion cacheregion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cacheregion
    ADD CONSTRAINT cacheregion_pkey PRIMARY KEY (id);


--
-- Name: cohort cohort_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cohort
    ADD CONSTRAINT cohort_pkey PRIMARY KEY (id);


--
-- Name: competentie competentie_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.competentie
    ADD CONSTRAINT competentie_code_key UNIQUE (code);


--
-- Name: competentie competentie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.competentie
    ADD CONSTRAINT competentie_pkey PRIMARY KEY (id);


--
-- Name: competentiecomponent competentiecomponent_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.competentiecomponent
    ADD CONSTRAINT competentiecomponent_pkey PRIMARY KEY (id);


--
-- Name: competentieniveau competentieniveau_leerpunt_niveauverzameling_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.competentieniveau
    ADD CONSTRAINT competentieniveau_leerpunt_niveauverzameling_key UNIQUE (leerpunt, niveauverzameling);


--
-- Name: competentieniveau competentieniveau_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.competentieniveau
    ADD CONSTRAINT competentieniveau_pkey PRIMARY KEY (id);


--
-- Name: competentieniveauverzameling competentieniveauverzameling_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.competentieniveauverzameling
    ADD CONSTRAINT competentieniveauverzameling_pkey PRIMARY KEY (id);


--
-- Name: contactpersoon contactpersoon_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contactpersoon
    ADD CONSTRAINT contactpersoon_pkey PRIMARY KEY (id);


--
-- Name: contract contract_code_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contract
    ADD CONSTRAINT contract_code_organisatie_key UNIQUE (code, organisatie);


--
-- Name: contract contract_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contract
    ADD CONSTRAINT contract_pkey PRIMARY KEY (id);


--
-- Name: contractonderdeel contractonderdeel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contractonderdeel
    ADD CONSTRAINT contractonderdeel_pkey PRIMARY KEY (id);


--
-- Name: contractverplichting contractverplichting_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contractverplichting
    ADD CONSTRAINT contractverplichting_pkey PRIMARY KEY (id);


--
-- Name: criterium criterium_opleiding_verbintenisgebied_cohort_volgnummer_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.criterium
    ADD CONSTRAINT criterium_opleiding_verbintenisgebied_cohort_volgnummer_key UNIQUE (opleiding, verbintenisgebied, cohort, volgnummer);


--
-- Name: criterium criterium_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.criterium
    ADD CONSTRAINT criterium_pkey PRIMARY KEY (id);


--
-- Name: crohoopleidingaanbod crohoopleidingaanbod_crohoopleiding_brin_opleidingsvorm_beg_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crohoopleidingaanbod
    ADD CONSTRAINT crohoopleidingaanbod_crohoopleiding_brin_opleidingsvorm_beg_key UNIQUE (crohoopleiding, brin, opleidingsvorm, begindatum);


--
-- Name: crohoopleidingaanbod crohoopleidingaanbod_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crohoopleidingaanbod
    ADD CONSTRAINT crohoopleidingaanbod_pkey PRIMARY KEY (id);


--
-- Name: curriculum curriculum_opleiding_cohort_organisatieeenheid_locatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.curriculum
    ADD CONSTRAINT curriculum_opleiding_cohort_organisatieeenheid_locatie_key UNIQUE (opleiding, cohort, organisatieeenheid, locatie);


--
-- Name: curriculum curriculum_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.curriculum
    ADD CONSTRAINT curriculum_pkey PRIMARY KEY (id);


--
-- Name: curriculumonderwijsproduct curriculumonderwijsproduct_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.curriculumonderwijsproduct
    ADD CONSTRAINT curriculumonderwijsproduct_pkey PRIMARY KEY (id);


--
-- Name: deelnemer deelnemer_organisatie_deelnemernummer_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deelnemer
    ADD CONSTRAINT deelnemer_organisatie_deelnemernummer_key UNIQUE (organisatie, deelnemernummer);


--
-- Name: deelnemer deelnemer_persoon_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deelnemer
    ADD CONSTRAINT deelnemer_persoon_key UNIQUE (persoon);


--
-- Name: deelnemer deelnemer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deelnemer
    ADD CONSTRAINT deelnemer_pkey PRIMARY KEY (id);


--
-- Name: deelnemerkenmerk deelnemerkenmerk_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deelnemerkenmerk
    ADD CONSTRAINT deelnemerkenmerk_pkey PRIMARY KEY (id);


--
-- Name: deelnemermatrix deelnemermatrix_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deelnemermatrix
    ADD CONSTRAINT deelnemermatrix_pkey PRIMARY KEY (id);


--
-- Name: deelnemermedewerkergroepview deelnemermedewerkergroepview_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deelnemermedewerkergroepview
    ADD CONSTRAINT deelnemermedewerkergroepview_pkey PRIMARY KEY (id);


--
-- Name: deelnemerpersoonlijkegroep deelnemerpersoonlijkegroep_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deelnemerpersoonlijkegroep
    ADD CONSTRAINT deelnemerpersoonlijkegroep_pkey PRIMARY KEY (id);


--
-- Name: deelnemerresultaatversie deelnemerresultaatversie_deelnemer_resultaatstructuur_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deelnemerresultaatversie
    ADD CONSTRAINT deelnemerresultaatversie_deelnemer_resultaatstructuur_key UNIQUE (deelnemer, resultaatstructuur);


--
-- Name: deelnemerresultaatversie deelnemerresultaatversie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deelnemerresultaatversie
    ADD CONSTRAINT deelnemerresultaatversie_pkey PRIMARY KEY (id);


--
-- Name: deelnemertest deelnemertest_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deelnemertest
    ADD CONSTRAINT deelnemertest_pkey PRIMARY KEY (id);


--
-- Name: deelnemertoetsbevriezing deelnemertoetsbevriezing_deelnemer_toets_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deelnemertoetsbevriezing
    ADD CONSTRAINT deelnemertoetsbevriezing_deelnemer_toets_key UNIQUE (deelnemer, toets);


--
-- Name: deelnemertoetsbevriezing deelnemertoetsbevriezing_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deelnemertoetsbevriezing
    ADD CONSTRAINT deelnemertoetsbevriezing_pkey PRIMARY KEY (id);


--
-- Name: deelnemerzoekopdracht deelnemerzoekopdracht_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deelnemerzoekopdracht
    ADD CONSTRAINT deelnemerzoekopdracht_pkey PRIMARY KEY (id);


--
-- Name: deelnemerzoekopdrachtrecht deelnemerzoekopdrachtrecht_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deelnemerzoekopdrachtrecht
    ADD CONSTRAINT deelnemerzoekopdrachtrecht_pkey PRIMARY KEY (id);


--
-- Name: documentcategorie documentcategorie_code_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documentcategorie
    ADD CONSTRAINT documentcategorie_code_organisatie_key UNIQUE (code, organisatie);


--
-- Name: documentcategorie documentcategorie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documentcategorie
    ADD CONSTRAINT documentcategorie_pkey PRIMARY KEY (id);


--
-- Name: documenttemplate documenttemplate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documenttemplate
    ADD CONSTRAINT documenttemplate_pkey PRIMARY KEY (id);


--
-- Name: documenttemplaterecht documenttemplaterecht_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documenttemplaterecht
    ADD CONSTRAINT documenttemplaterecht_pkey PRIMARY KEY (id);


--
-- Name: documenttype documenttype_code_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documenttype
    ADD CONSTRAINT documenttype_code_organisatie_key UNIQUE (code, organisatie);


--
-- Name: documenttype documenttype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documenttype
    ADD CONSTRAINT documenttype_pkey PRIMARY KEY (id);


--
-- Name: edvcs edvcs_account_panelid_headerid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.edvcs
    ADD CONSTRAINT edvcs_account_panelid_headerid_key UNIQUE (account, panelid, headerid);


--
-- Name: edvcs edvcs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.edvcs
    ADD CONSTRAINT edvcs_pkey PRIMARY KEY (id);


--
-- Name: eigenaartemplate eigenaartemplate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eigenaartemplate
    ADD CONSTRAINT eigenaartemplate_pkey PRIMARY KEY (id);


--
-- Name: eventabonnementconfiguration eventabonnementconfiguration_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eventabonnementconfiguration
    ADD CONSTRAINT eventabonnementconfiguration_pkey PRIMARY KEY (id);


--
-- Name: eventabonnementsetting eventabonnementsetting_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eventabonnementsetting
    ADD CONSTRAINT eventabonnementsetting_pkey PRIMARY KEY (id);


--
-- Name: examendeelname examendeelname_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.examendeelname
    ADD CONSTRAINT examendeelname_pkey PRIMARY KEY (id);


--
-- Name: examenstatus examenstatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.examenstatus
    ADD CONSTRAINT examenstatus_pkey PRIMARY KEY (id);


--
-- Name: examenstatusovergang examenstatusovergang_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.examenstatusovergang
    ADD CONSTRAINT examenstatusovergang_pkey PRIMARY KEY (id);


--
-- Name: examenworkflow examenworkflow_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.examenworkflow
    ADD CONSTRAINT examenworkflow_pkey PRIMARY KEY (id);


--
-- Name: examenworkflowtax examenworkflowtax_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.examenworkflowtax
    ADD CONSTRAINT examenworkflowtax_pkey PRIMARY KEY (id);


--
-- Name: externeagenda externeagenda_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.externeagenda
    ADD CONSTRAINT externeagenda_pkey PRIMARY KEY (id);


--
-- Name: externeagendakoppeling externeagendakoppeling_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.externeagendakoppeling
    ADD CONSTRAINT externeagendakoppeling_pkey PRIMARY KEY (id);


--
-- Name: externeorganisatie externeorganisatie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.externeorganisatie
    ADD CONSTRAINT externeorganisatie_pkey PRIMARY KEY (id);


--
-- Name: externeorganisatiekenmerk externeorganisatiekenmerk_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.externeorganisatiekenmerk
    ADD CONSTRAINT externeorganisatiekenmerk_pkey PRIMARY KEY (id);


--
-- Name: externeorganisatieopmerking externeorganisatieopmerking_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.externeorganisatieopmerking
    ADD CONSTRAINT externeorganisatieopmerking_pkey PRIMARY KEY (id);


--
-- Name: externewaarneming externewaarneming_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.externewaarneming
    ADD CONSTRAINT externewaarneming_pkey PRIMARY KEY (id);


--
-- Name: externpersoon externpersoon_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.externpersoon
    ADD CONSTRAINT externpersoon_pkey PRIMARY KEY (id);


--
-- Name: extorgcontactgegeven extorgcontactgegeven_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extorgcontactgegeven
    ADD CONSTRAINT extorgcontactgegeven_pkey PRIMARY KEY (id);


--
-- Name: extorgcontactpersoon extorgcontactpersoon_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extorgcontactpersoon
    ADD CONSTRAINT extorgcontactpersoon_pkey PRIMARY KEY (id);


--
-- Name: extorgcontpersrol extorgcontpersrol_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extorgcontpersrol
    ADD CONSTRAINT extorgcontpersrol_pkey PRIMARY KEY (id);


--
-- Name: extorgpraktijkbegeleider extorgpraktijkbegeleider_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extorgpraktijkbegeleider
    ADD CONSTRAINT extorgpraktijkbegeleider_pkey PRIMARY KEY (id);


--
-- Name: fase fase_code_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fase
    ADD CONSTRAINT fase_code_organisatie_key UNIQUE (code, organisatie);


--
-- Name: fase fase_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fase
    ADD CONSTRAINT fase_pkey PRIMARY KEY (id);


--
-- Name: functie functie_code_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.functie
    ADD CONSTRAINT functie_code_organisatie_key UNIQUE (code, organisatie);


--
-- Name: functie functie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.functie
    ADD CONSTRAINT functie_pkey PRIMARY KEY (id);


--
-- Name: gebruiksmiddel gebruiksmiddel_code_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gebruiksmiddel
    ADD CONSTRAINT gebruiksmiddel_code_organisatie_key UNIQUE (code, organisatie);


--
-- Name: gebruiksmiddel gebruiksmiddel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gebruiksmiddel
    ADD CONSTRAINT gebruiksmiddel_pkey PRIMARY KEY (id);


--
-- Name: gedrag gedrag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gedrag
    ADD CONSTRAINT gedrag_pkey PRIMARY KEY (id);


--
-- Name: gekoppeldetemplate gekoppeldetemplate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gekoppeldetemplate
    ADD CONSTRAINT gekoppeldetemplate_pkey PRIMARY KEY (id);


--
-- Name: gemeente gemeente_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gemeente
    ADD CONSTRAINT gemeente_pkey PRIMARY KEY (id);


--
-- Name: gespreksamenvattingtemplate gespreksamenvattingtemplate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gespreksamenvattingtemplate
    ADD CONSTRAINT gespreksamenvattingtemplate_pkey PRIMARY KEY (id);


--
-- Name: gespreksamenvattingzin gespreksamenvattingzin_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gespreksamenvattingzin
    ADD CONSTRAINT gespreksamenvattingzin_pkey PRIMARY KEY (id);


--
-- Name: gespreksoort gespreksoort_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gespreksoort
    ADD CONSTRAINT gespreksoort_pkey PRIMARY KEY (id);


--
-- Name: groep groep_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groep
    ADD CONSTRAINT groep_pkey PRIMARY KEY (id);


--
-- Name: groepdocent groepdocent_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groepdocent
    ADD CONSTRAINT groepdocent_pkey PRIMARY KEY (id);


--
-- Name: groepmentor groepmentor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groepmentor
    ADD CONSTRAINT groepmentor_pkey PRIMARY KEY (id);


--
-- Name: groepresultaatfilterinst groepresultaatfilterinst_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groepresultaatfilterinst
    ADD CONSTRAINT groepresultaatfilterinst_pkey PRIMARY KEY (id);


--
-- Name: groepsdeelname groepsdeelname_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groepsdeelname
    ADD CONSTRAINT groepsdeelname_pkey PRIMARY KEY (id);


--
-- Name: groepstype groepstype_code_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groepstype
    ADD CONSTRAINT groepstype_code_organisatie_key UNIQUE (code, organisatie);


--
-- Name: groepstype groepstype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groepstype
    ADD CONSTRAINT groepstype_pkey PRIMARY KEY (id);


--
-- Name: groeptest groeptest_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groeptest
    ADD CONSTRAINT groeptest_pkey PRIMARY KEY (id);


--
-- Name: grouppropertysetting grouppropertysetting_account_panelid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grouppropertysetting
    ADD CONSTRAINT grouppropertysetting_account_panelid_key UNIQUE (account, panelid);


--
-- Name: grouppropertysetting grouppropertysetting_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grouppropertysetting
    ADD CONSTRAINT grouppropertysetting_pkey PRIMARY KEY (id);


--
-- Name: herhalendeabsentiemelding herhalendeabsentiemelding_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.herhalendeabsentiemelding
    ADD CONSTRAINT herhalendeabsentiemelding_pkey PRIMARY KEY (id);


--
-- Name: herhalendeafspraak herhalendeafspraak_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.herhalendeafspraak
    ADD CONSTRAINT herhalendeafspraak_pkey PRIMARY KEY (id);


--
-- Name: hulpmiddel hulpmiddel_code_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hulpmiddel
    ADD CONSTRAINT hulpmiddel_code_organisatie_key UNIQUE (code, organisatie);


--
-- Name: hulpmiddel hulpmiddel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hulpmiddel
    ADD CONSTRAINT hulpmiddel_pkey PRIMARY KEY (id);


--
-- Name: ibgverzuimdag ibgverzuimdag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ibgverzuimdag
    ADD CONSTRAINT ibgverzuimdag_pkey PRIMARY KEY (id);


--
-- Name: ibgverzuimmelding ibgverzuimmelding_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ibgverzuimmelding
    ADD CONSTRAINT ibgverzuimmelding_pkey PRIMARY KEY (id);


--
-- Name: incident incident_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incident
    ADD CONSTRAINT incident_pkey PRIMARY KEY (id);


--
-- Name: incidentcategorie incidentcategorie_code_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidentcategorie
    ADD CONSTRAINT incidentcategorie_code_organisatie_key UNIQUE (code, organisatie);


--
-- Name: incidentcategorie incidentcategorie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidentcategorie
    ADD CONSTRAINT incidentcategorie_pkey PRIMARY KEY (id);


--
-- Name: inloopcollege inloopcollege_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inloopcollege
    ADD CONSTRAINT inloopcollege_pkey PRIMARY KEY (id);


--
-- Name: inloopcollegegroep inloopcollegegroep_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inloopcollegegroep
    ADD CONSTRAINT inloopcollegegroep_pkey PRIMARY KEY (id);


--
-- Name: inloopcollegeopleiding inloopcollegeopleiding_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inloopcollegeopleiding
    ADD CONSTRAINT inloopcollegeopleiding_pkey PRIMARY KEY (id);


--
-- Name: inschrijvingsverzoek inschrijvingsverzoek_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inschrijvingsverzoek
    ADD CONSTRAINT inschrijvingsverzoek_pkey PRIMARY KEY (id);


--
-- Name: inschrijvingsverzoek inschrijvingsverzoek_studielinkbericht_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inschrijvingsverzoek
    ADD CONSTRAINT inschrijvingsverzoek_studielinkbericht_key UNIQUE (studielinkbericht);


--
-- Name: instellingsequence instellingsequence_naam_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instellingsequence
    ADD CONSTRAINT instellingsequence_naam_organisatie_key UNIQUE (naam, organisatie);


--
-- Name: instellingsequence instellingsequence_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instellingsequence
    ADD CONSTRAINT instellingsequence_pkey PRIMARY KEY (id);


--
-- Name: instellingslogo instellingslogo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instellingslogo
    ADD CONSTRAINT instellingslogo_pkey PRIMARY KEY (id);


--
-- Name: instroommoment instroommoment_code_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instroommoment
    ADD CONSTRAINT instroommoment_code_organisatie_key UNIQUE (code, organisatie);


--
-- Name: instroommoment instroommoment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instroommoment
    ADD CONSTRAINT instroommoment_pkey PRIMARY KEY (id);


--
-- Name: intakegesprek intakegesprek_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intakegesprek
    ADD CONSTRAINT intakegesprek_pkey PRIMARY KEY (id);


--
-- Name: irisbetrokkene irisbetrokkene_incident_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.irisbetrokkene
    ADD CONSTRAINT irisbetrokkene_incident_key UNIQUE (incident);


--
-- Name: irisbetrokkene irisbetrokkene_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.irisbetrokkene
    ADD CONSTRAINT irisbetrokkene_pkey PRIMARY KEY (id);


--
-- Name: irisbetrokkeneafhandeling irisbetrokkeneafhandeling_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.irisbetrokkeneafhandeling
    ADD CONSTRAINT irisbetrokkeneafhandeling_pkey PRIMARY KEY (id);


--
-- Name: irisbetrokkenemotief irisbetrokkenemotief_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.irisbetrokkenemotief
    ADD CONSTRAINT irisbetrokkenemotief_pkey PRIMARY KEY (id);


--
-- Name: irisincident irisincident_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.irisincident
    ADD CONSTRAINT irisincident_pkey PRIMARY KEY (id);


--
-- Name: irisincidentlocatie irisincidentlocatie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.irisincidentlocatie
    ADD CONSTRAINT irisincidentlocatie_pkey PRIMARY KEY (id);


--
-- Name: irisincidentvoorwerp irisincidentvoorwerp_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.irisincidentvoorwerp
    ADD CONSTRAINT irisincidentvoorwerp_pkey PRIMARY KEY (id);


--
-- Name: iriskoppelingkey iriskoppelingkey_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.iriskoppelingkey
    ADD CONSTRAINT iriskoppelingkey_pkey PRIMARY KEY (id);


--
-- Name: kenmerk kenmerk_categorie_code_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kenmerk
    ADD CONSTRAINT kenmerk_categorie_code_organisatie_key UNIQUE (categorie, code, organisatie);


--
-- Name: kenmerk kenmerk_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kenmerk
    ADD CONSTRAINT kenmerk_pkey PRIMARY KEY (id);


--
-- Name: kenmerkcategorie kenmerkcategorie_code_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kenmerkcategorie
    ADD CONSTRAINT kenmerkcategorie_code_organisatie_key UNIQUE (code, organisatie);


--
-- Name: kenmerkcategorie kenmerkcategorie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kenmerkcategorie
    ADD CONSTRAINT kenmerkcategorie_pkey PRIMARY KEY (id);


--
-- Name: land land_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.land
    ADD CONSTRAINT land_pkey PRIMARY KEY (id);


--
-- Name: leerpuntcomponent leerpuntcomponent_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leerpuntcomponent
    ADD CONSTRAINT leerpuntcomponent_pkey PRIMARY KEY (id);


--
-- Name: leerpuntvaardigheid leerpuntvaardigheid_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leerpuntvaardigheid
    ADD CONSTRAINT leerpuntvaardigheid_pkey PRIMARY KEY (id);


--
-- Name: leerstijl leerstijl_code_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leerstijl
    ADD CONSTRAINT leerstijl_code_organisatie_key UNIQUE (code, organisatie);


--
-- Name: leerstijl leerstijl_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leerstijl
    ADD CONSTRAINT leerstijl_pkey PRIMARY KEY (id);


--
-- Name: lesdagindeling lesdagindeling_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesdagindeling
    ADD CONSTRAINT lesdagindeling_pkey PRIMARY KEY (id);


--
-- Name: lesuurindeling lesuurindeling_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesuurindeling
    ADD CONSTRAINT lesuurindeling_pkey PRIMARY KEY (id);


--
-- Name: lesweekindeling lesweekindeling_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesweekindeling
    ADD CONSTRAINT lesweekindeling_pkey PRIMARY KEY (id);


--
-- Name: lesweekindelingorgloc lesweekindelingorgloc_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesweekindelingorgloc
    ADD CONSTRAINT lesweekindelingorgloc_pkey PRIMARY KEY (id);


--
-- Name: locatie locatie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locatie
    ADD CONSTRAINT locatie_pkey PRIMARY KEY (id);


--
-- Name: locatiecontactgegeven locatiecontactgegeven_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locatiecontactgegeven
    ADD CONSTRAINT locatiecontactgegeven_pkey PRIMARY KEY (id);


--
-- Name: maatregel maatregel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maatregel
    ADD CONSTRAINT maatregel_pkey PRIMARY KEY (id);


--
-- Name: maatregeltoekenning maatregeltoekenning_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maatregeltoekenning
    ADD CONSTRAINT maatregeltoekenning_pkey PRIMARY KEY (id);


--
-- Name: maatregeltoekenningsregel maatregeltoekenningsregel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maatregeltoekenningsregel
    ADD CONSTRAINT maatregeltoekenningsregel_pkey PRIMARY KEY (id);


--
-- Name: medewerker medewerker_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medewerker
    ADD CONSTRAINT medewerker_pkey PRIMARY KEY (id);


--
-- Name: medewerkerdeelnemerabonnering medewerkerdeelnemerabonnering_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medewerkerdeelnemerabonnering
    ADD CONSTRAINT medewerkerdeelnemerabonnering_pkey PRIMARY KEY (id);


--
-- Name: medewerkergroepabonnering medewerkergroepabonnering_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medewerkergroepabonnering
    ADD CONSTRAINT medewerkergroepabonnering_pkey PRIMARY KEY (id);


--
-- Name: medewerkerkenmerk medewerkerkenmerk_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medewerkerkenmerk
    ADD CONSTRAINT medewerkerkenmerk_pkey PRIMARY KEY (id);


--
-- Name: meeteenheid meeteenheid_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meeteenheid
    ADD CONSTRAINT meeteenheid_pkey PRIMARY KEY (id);


--
-- Name: meeteenheidkoppel meeteenheidkoppel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meeteenheidkoppel
    ADD CONSTRAINT meeteenheidkoppel_pkey PRIMARY KEY (id);


--
-- Name: meeteenheidwaarde meeteenheidwaarde_meeteenheid_label_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meeteenheidwaarde
    ADD CONSTRAINT meeteenheidwaarde_meeteenheid_label_key UNIQUE (meeteenheid, label);


--
-- Name: meeteenheidwaarde meeteenheidwaarde_meeteenheid_waarde_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meeteenheidwaarde
    ADD CONSTRAINT meeteenheidwaarde_meeteenheid_waarde_key UNIQUE (meeteenheid, waarde);


--
-- Name: meeteenheidwaarde meeteenheidwaarde_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meeteenheidwaarde
    ADD CONSTRAINT meeteenheidwaarde_pkey PRIMARY KEY (id);


--
-- Name: modernetaal modernetaal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.modernetaal
    ADD CONSTRAINT modernetaal_pkey PRIMARY KEY (id);


--
-- Name: moduleafname moduleafname_organisatie_modulename_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moduleafname
    ADD CONSTRAINT moduleafname_organisatie_modulename_key UNIQUE (organisatie, modulename);


--
-- Name: moduleafname moduleafname_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moduleafname
    ADD CONSTRAINT moduleafname_pkey PRIMARY KEY (id);


--
-- Name: mogelijkeaanleiding mogelijkeaanleiding_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mogelijkeaanleiding
    ADD CONSTRAINT mogelijkeaanleiding_pkey PRIMARY KEY (id);


--
-- Name: nationaliteit nationaliteit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nationaliteit
    ADD CONSTRAINT nationaliteit_pkey PRIMARY KEY (id);


--
-- Name: niettoneninzorgvierkant niettoneninzorgvierkant_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.niettoneninzorgvierkant
    ADD CONSTRAINT niettoneninzorgvierkant_pkey PRIMARY KEY (id);


--
-- Name: notitie notitie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notitie
    ADD CONSTRAINT notitie_pkey PRIMARY KEY (id);


--
-- Name: olclocatie olclocatie_code_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.olclocatie
    ADD CONSTRAINT olclocatie_code_organisatie_key UNIQUE (code, organisatie);


--
-- Name: olclocatie olclocatie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.olclocatie
    ADD CONSTRAINT olclocatie_pkey PRIMARY KEY (id);


--
-- Name: olcwaarneming olcwaarneming_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.olcwaarneming
    ADD CONSTRAINT olcwaarneming_pkey PRIMARY KEY (id);


--
-- Name: onderwijsproduct onderwijsproduct_code_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproduct
    ADD CONSTRAINT onderwijsproduct_code_organisatie_key UNIQUE (code, organisatie);


--
-- Name: onderwijsproduct onderwijsproduct_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproduct
    ADD CONSTRAINT onderwijsproduct_pkey PRIMARY KEY (id);


--
-- Name: onderwijsproductaanbod onderwijsproductaanbod_organisatieeenheid_locatie_onderwijs_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproductaanbod
    ADD CONSTRAINT onderwijsproductaanbod_organisatieeenheid_locatie_onderwijs_key UNIQUE (organisatieeenheid, locatie, onderwijsproduct);


--
-- Name: onderwijsproductaanbod onderwijsproductaanbod_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproductaanbod
    ADD CONSTRAINT onderwijsproductaanbod_pkey PRIMARY KEY (id);


--
-- Name: onderwijsproductaanbodperiode onderwijsproductaanbodperiode_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproductaanbodperiode
    ADD CONSTRAINT onderwijsproductaanbodperiode_pkey PRIMARY KEY (id);


--
-- Name: onderwijsproductafname onderwijsproductafname_deelnemer_onderwijsproduct_cohort_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproductafname
    ADD CONSTRAINT onderwijsproductafname_deelnemer_onderwijsproduct_cohort_key UNIQUE (deelnemer, onderwijsproduct, cohort);


--
-- Name: onderwijsproductafname onderwijsproductafname_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproductafname
    ADD CONSTRAINT onderwijsproductafname_pkey PRIMARY KEY (id);


--
-- Name: onderwijsproductafnamecontext onderwijsproductafnamecontext_onderwijsproductafname_verbin_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproductafnamecontext
    ADD CONSTRAINT onderwijsproductafnamecontext_onderwijsproductafname_verbin_key UNIQUE (onderwijsproductafname, verbintenis);


--
-- Name: onderwijsproductafnamecontext onderwijsproductafnamecontext_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproductafnamecontext
    ADD CONSTRAINT onderwijsproductafnamecontext_pkey PRIMARY KEY (id);


--
-- Name: onderwijsproductafnamecontext onderwijsproductafnamecontext_productregel_verbintenis_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproductafnamecontext
    ADD CONSTRAINT onderwijsproductafnamecontext_productregel_verbintenis_key UNIQUE (productregel, verbintenis);


--
-- Name: onderwijsproductniveau onderwijsproductniveau_code_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproductniveau
    ADD CONSTRAINT onderwijsproductniveau_code_organisatie_key UNIQUE (code, organisatie);


--
-- Name: onderwijsproductniveau onderwijsproductniveau_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproductniveau
    ADD CONSTRAINT onderwijsproductniveau_pkey PRIMARY KEY (id);


--
-- Name: onderwijsproductopvolger onderwijsproductopvolger_oudproduct_nieuwproduct_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproductopvolger
    ADD CONSTRAINT onderwijsproductopvolger_oudproduct_nieuwproduct_key UNIQUE (oudproduct, nieuwproduct);


--
-- Name: onderwijsproductopvolger onderwijsproductopvolger_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproductopvolger
    ADD CONSTRAINT onderwijsproductopvolger_pkey PRIMARY KEY (id);


--
-- Name: onderwijsproductsamenstelling onderwijsproductsamenstelling_parent_child_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproductsamenstelling
    ADD CONSTRAINT onderwijsproductsamenstelling_parent_child_key UNIQUE (parent, child);


--
-- Name: onderwijsproductsamenstelling onderwijsproductsamenstelling_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproductsamenstelling
    ADD CONSTRAINT onderwijsproductsamenstelling_pkey PRIMARY KEY (id);


--
-- Name: onderwijsproducttaxonomie onderwijsproducttaxonomie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproducttaxonomie
    ADD CONSTRAINT onderwijsproducttaxonomie_pkey PRIMARY KEY (id);


--
-- Name: onderwijsproducttaxonomie onderwijsproducttaxonomie_taxonomieelement_onderwijsproduct_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproducttaxonomie
    ADD CONSTRAINT onderwijsproducttaxonomie_taxonomieelement_onderwijsproduct_key UNIQUE (taxonomieelement, onderwijsproduct);


--
-- Name: onderwijsproductvoorwaarde onderwijsproductvoorwaarde_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproductvoorwaarde
    ADD CONSTRAINT onderwijsproductvoorwaarde_pkey PRIMARY KEY (id);


--
-- Name: onderwijsproductvoorwaarde onderwijsproductvoorwaarde_voorwaardelijkproduct_voorwaarde_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproductvoorwaarde
    ADD CONSTRAINT onderwijsproductvoorwaarde_voorwaardelijkproduct_voorwaarde_key UNIQUE (voorwaardelijkproduct, voorwaardevoor);


--
-- Name: onderwijsproductzoekterm onderwijsproductzoekterm_onderwijsproduct_zoekterm_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproductzoekterm
    ADD CONSTRAINT onderwijsproductzoekterm_onderwijsproduct_zoekterm_key UNIQUE (onderwijsproduct, zoekterm);


--
-- Name: onderwijsproductzoekterm onderwijsproductzoekterm_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproductzoekterm
    ADD CONSTRAINT onderwijsproductzoekterm_pkey PRIMARY KEY (id);


--
-- Name: ondprodgebruiksmiddel ondprodgebruiksmiddel_onderwijsproduct_gebruiksmiddel_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ondprodgebruiksmiddel
    ADD CONSTRAINT ondprodgebruiksmiddel_onderwijsproduct_gebruiksmiddel_key UNIQUE (onderwijsproduct, gebruiksmiddel);


--
-- Name: ondprodgebruiksmiddel ondprodgebruiksmiddel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ondprodgebruiksmiddel
    ADD CONSTRAINT ondprodgebruiksmiddel_pkey PRIMARY KEY (id);


--
-- Name: ondprodverbruiksmiddel ondprodverbruiksmiddel_onderwijsproduct_verbruiksmiddel_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ondprodverbruiksmiddel
    ADD CONSTRAINT ondprodverbruiksmiddel_onderwijsproduct_verbruiksmiddel_key UNIQUE (onderwijsproduct, verbruiksmiddel);


--
-- Name: ondprodverbruiksmiddel ondprodverbruiksmiddel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ondprodverbruiksmiddel
    ADD CONSTRAINT ondprodverbruiksmiddel_pkey PRIMARY KEY (id);


--
-- Name: opaanbodperiodeopafname opaanbodperiodeopafname_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.opaanbodperiodeopafname
    ADD CONSTRAINT opaanbodperiodeopafname_pkey PRIMARY KEY (id);


--
-- Name: opleiding opleiding_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.opleiding
    ADD CONSTRAINT opleiding_pkey PRIMARY KEY (id);


--
-- Name: opleidingaanbod opleidingaanbod_organisatieeenheid_locatie_opleiding_team_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.opleidingaanbod
    ADD CONSTRAINT opleidingaanbod_organisatieeenheid_locatie_opleiding_team_key UNIQUE (organisatieeenheid, locatie, opleiding, team);


--
-- Name: opleidingaanbod opleidingaanbod_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.opleidingaanbod
    ADD CONSTRAINT opleidingaanbod_pkey PRIMARY KEY (id);


--
-- Name: opleidingfase opleidingfase_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.opleidingfase
    ADD CONSTRAINT opleidingfase_pkey PRIMARY KEY (id);


--
-- Name: organisatie organisatie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisatie
    ADD CONSTRAINT organisatie_pkey PRIMARY KEY (id);


--
-- Name: organisatieeenheid organisatieeenheid_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisatieeenheid
    ADD CONSTRAINT organisatieeenheid_pkey PRIMARY KEY (id);


--
-- Name: organisatieeenheidcg organisatieeenheidcg_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisatieeenheidcg
    ADD CONSTRAINT organisatieeenheidcg_pkey PRIMARY KEY (id);


--
-- Name: organisatieeenheidlocatie organisatieeenheidlocatie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisatieeenheidlocatie
    ADD CONSTRAINT organisatieeenheidlocatie_pkey PRIMARY KEY (id);


--
-- Name: organisatiemedewerker organisatiemedewerker_organisatieeenheid_locatie_medewerker_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisatiemedewerker
    ADD CONSTRAINT organisatiemedewerker_organisatieeenheid_locatie_medewerker_key UNIQUE (organisatieeenheid, locatie, medewerker);


--
-- Name: organisatiemedewerker organisatiemedewerker_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisatiemedewerker
    ADD CONSTRAINT organisatiemedewerker_pkey PRIMARY KEY (id);


--
-- Name: organisatiesetting organisatiesetting_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisatiesetting
    ADD CONSTRAINT organisatiesetting_pkey PRIMARY KEY (id);


--
-- Name: orgehdcontactpersoon orgehdcontactpersoon_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orgehdcontactpersoon
    ADD CONSTRAINT orgehdcontactpersoon_pkey PRIMARY KEY (id);


--
-- Name: periode periode_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.periode
    ADD CONSTRAINT periode_pkey PRIMARY KEY (id);


--
-- Name: periodeindeling periodeindeling_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.periodeindeling
    ADD CONSTRAINT periodeindeling_pkey PRIMARY KEY (id);


--
-- Name: persoon persoon_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persoon
    ADD CONSTRAINT persoon_pkey PRIMARY KEY (id);


--
-- Name: persooncontactgegeven persooncontactgegeven_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persooncontactgegeven
    ADD CONSTRAINT persooncontactgegeven_pkey PRIMARY KEY (id);


--
-- Name: persoonextorgcontactpersoon persoonextorgcontactpersoon_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persoonextorgcontactpersoon
    ADD CONSTRAINT persoonextorgcontactpersoon_pkey PRIMARY KEY (id);


--
-- Name: persoonlijketoetscode persoonlijketoetscode_medewerker_toets_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persoonlijketoetscode
    ADD CONSTRAINT persoonlijketoetscode_medewerker_toets_key UNIQUE (medewerker, toets);


--
-- Name: persoonlijketoetscode persoonlijketoetscode_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persoonlijketoetscode
    ADD CONSTRAINT persoonlijketoetscode_pkey PRIMARY KEY (id);


--
-- Name: plaats plaats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plaats
    ADD CONSTRAINT plaats_pkey PRIMARY KEY (id);


--
-- Name: planningtemplate planningtemplate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.planningtemplate
    ADD CONSTRAINT planningtemplate_pkey PRIMARY KEY (id);


--
-- Name: productregel productregel_afkorting_opleiding_verbintenisgebied_cohort_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productregel
    ADD CONSTRAINT productregel_afkorting_opleiding_verbintenisgebied_cohort_key UNIQUE (afkorting, opleiding, verbintenisgebied, cohort);


--
-- Name: productregel productregel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productregel
    ADD CONSTRAINT productregel_pkey PRIMARY KEY (id);


--
-- Name: productregel productregel_volgnummer_soortproductregel_opleiding_verbint_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productregel
    ADD CONSTRAINT productregel_volgnummer_soortproductregel_opleiding_verbint_key UNIQUE (volgnummer, soortproductregel, opleiding, verbintenisgebied, cohort);


--
-- Name: provincie provincie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provincie
    ADD CONSTRAINT provincie_pkey PRIMARY KEY (id);


--
-- Name: rapportagetemplate rapportagetemplate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rapportagetemplate
    ADD CONSTRAINT rapportagetemplate_pkey PRIMARY KEY (id);


--
-- Name: rapportagetemplateijkpunt rapportagetemplateijkpunt_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rapportagetemplateijkpunt
    ADD CONSTRAINT rapportagetemplateijkpunt_pkey PRIMARY KEY (id);


--
-- Name: recht recht_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recht
    ADD CONSTRAINT recht_pkey PRIMARY KEY (id);


--
-- Name: redenuitdienst redenuitdienst_code_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.redenuitdienst
    ADD CONSTRAINT redenuitdienst_code_organisatie_key UNIQUE (code, organisatie);


--
-- Name: redenuitdienst redenuitdienst_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.redenuitdienst
    ADD CONSTRAINT redenuitdienst_pkey PRIMARY KEY (id);


--
-- Name: redenuitschrijving redenuitschrijving_code_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.redenuitschrijving
    ADD CONSTRAINT redenuitschrijving_code_organisatie_key UNIQUE (code, organisatie);


--
-- Name: redenuitschrijving redenuitschrijving_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.redenuitschrijving
    ADD CONSTRAINT redenuitschrijving_pkey PRIMARY KEY (id);


--
-- Name: regio regio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.regio
    ADD CONSTRAINT regio_pkey PRIMARY KEY (id);


--
-- Name: relatiesoort relatiesoort_code_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relatiesoort
    ADD CONSTRAINT relatiesoort_code_organisatie_key UNIQUE (code, organisatie);


--
-- Name: relatiesoort relatiesoort_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relatiesoort
    ADD CONSTRAINT relatiesoort_pkey PRIMARY KEY (id);


--
-- Name: resultaat resultaat_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resultaat
    ADD CONSTRAINT resultaat_pkey PRIMARY KEY (id);


--
-- Name: resultaatstructuur resultaatstructuur_code_organisatie_cohort_onderwijsproduct_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resultaatstructuur
    ADD CONSTRAINT resultaatstructuur_code_organisatie_cohort_onderwijsproduct_key UNIQUE (code, organisatie, cohort, onderwijsproduct);


--
-- Name: resultaatstructuur resultaatstructuur_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resultaatstructuur
    ADD CONSTRAINT resultaatstructuur_pkey PRIMARY KEY (id);


--
-- Name: resultaatstructuurcategorie resultaatstructuurcategorie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resultaatstructuurcategorie
    ADD CONSTRAINT resultaatstructuurcategorie_pkey PRIMARY KEY (id);


--
-- Name: resultaatstructuurdeelnemer resultaatstructuurdeelnemer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resultaatstructuurdeelnemer
    ADD CONSTRAINT resultaatstructuurdeelnemer_pkey PRIMARY KEY (id);


--
-- Name: resultaatstructuurmedewerker resultaatstructuurmedewerker_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resultaatstructuurmedewerker
    ADD CONSTRAINT resultaatstructuurmedewerker_pkey PRIMARY KEY (id);


--
-- Name: resultaatzoekfilterinstelling resultaatzoekfilterinstelling_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resultaatzoekfilterinstelling
    ADD CONSTRAINT resultaatzoekfilterinstelling_pkey PRIMARY KEY (id);


--
-- Name: rol rol_naam_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rol
    ADD CONSTRAINT rol_naam_organisatie_key UNIQUE (naam, organisatie);


--
-- Name: rol rol_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rol
    ADD CONSTRAINT rol_pkey PRIMARY KEY (id);


--
-- Name: samenvoegenhtmlconfig samenvoegenhtmlconfig_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.samenvoegenhtmlconfig
    ADD CONSTRAINT samenvoegenhtmlconfig_pkey PRIMARY KEY (id);


--
-- Name: samenvoegenpdfconfig samenvoegenpdfconfig_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.samenvoegenpdfconfig
    ADD CONSTRAINT samenvoegenpdfconfig_pkey PRIMARY KEY (id);


--
-- Name: schaal schaal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schaal
    ADD CONSTRAINT schaal_pkey PRIMARY KEY (id);


--
-- Name: schaalwaarde schaalwaarde_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schaalwaarde
    ADD CONSTRAINT schaalwaarde_pkey PRIMARY KEY (id);


--
-- Name: schaalwaarde schaalwaarde_schaal_internewaarde_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schaalwaarde
    ADD CONSTRAINT schaalwaarde_schaal_internewaarde_key UNIQUE (schaal, internewaarde);


--
-- Name: schooladvies schooladvies_naam_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schooladvies
    ADD CONSTRAINT schooladvies_naam_organisatie_key UNIQUE (naam, organisatie);


--
-- Name: schooladvies schooladvies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schooladvies
    ADD CONSTRAINT schooladvies_pkey PRIMARY KEY (id);


--
-- Name: scoreschaalwaarde scoreschaalwaarde_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scoreschaalwaarde
    ADD CONSTRAINT scoreschaalwaarde_pkey PRIMARY KEY (id);


--
-- Name: sessie sessie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessie
    ADD CONSTRAINT sessie_pkey PRIMARY KEY (id);


--
-- Name: signaal signaal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.signaal
    ADD CONSTRAINT signaal_pkey PRIMARY KEY (id);


--
-- Name: soortcontactgegeven soortcontactgegeven_code_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.soortcontactgegeven
    ADD CONSTRAINT soortcontactgegeven_code_organisatie_key UNIQUE (code, organisatie);


--
-- Name: soortcontactgegeven soortcontactgegeven_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.soortcontactgegeven
    ADD CONSTRAINT soortcontactgegeven_pkey PRIMARY KEY (id);


--
-- Name: soortcontract soortcontract_code_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.soortcontract
    ADD CONSTRAINT soortcontract_code_organisatie_key UNIQUE (code, organisatie);


--
-- Name: soortcontract soortcontract_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.soortcontract
    ADD CONSTRAINT soortcontract_pkey PRIMARY KEY (id);


--
-- Name: soortcontractverplichting soortcontractverplichting_code_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.soortcontractverplichting
    ADD CONSTRAINT soortcontractverplichting_code_organisatie_key UNIQUE (code, organisatie);


--
-- Name: soortcontractverplichting soortcontractverplichting_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.soortcontractverplichting
    ADD CONSTRAINT soortcontractverplichting_pkey PRIMARY KEY (id);


--
-- Name: soortexterneorganisatie soortexterneorganisatie_code_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.soortexterneorganisatie
    ADD CONSTRAINT soortexterneorganisatie_code_organisatie_key UNIQUE (code, organisatie);


--
-- Name: soortexterneorganisatie soortexterneorganisatie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.soortexterneorganisatie
    ADD CONSTRAINT soortexterneorganisatie_pkey PRIMARY KEY (id);


--
-- Name: soortonderwijsproduct soortonderwijsproduct_code_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.soortonderwijsproduct
    ADD CONSTRAINT soortonderwijsproduct_code_organisatie_key UNIQUE (code, organisatie);


--
-- Name: soortonderwijsproduct soortonderwijsproduct_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.soortonderwijsproduct
    ADD CONSTRAINT soortonderwijsproduct_pkey PRIMARY KEY (id);


--
-- Name: soortorgehd soortorgehd_code_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.soortorgehd
    ADD CONSTRAINT soortorgehd_code_organisatie_key UNIQUE (code, organisatie);


--
-- Name: soortorgehd soortorgehd_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.soortorgehd
    ADD CONSTRAINT soortorgehd_pkey PRIMARY KEY (id);


--
-- Name: soortpraktijklokaal soortpraktijklokaal_code_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.soortpraktijklokaal
    ADD CONSTRAINT soortpraktijklokaal_code_organisatie_key UNIQUE (code, organisatie);


--
-- Name: soortpraktijklokaal soortpraktijklokaal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.soortpraktijklokaal
    ADD CONSTRAINT soortpraktijklokaal_pkey PRIMARY KEY (id);


--
-- Name: soortproductregel soortproductregel_naam_taxonomie_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.soortproductregel
    ADD CONSTRAINT soortproductregel_naam_taxonomie_organisatie_key UNIQUE (naam, taxonomie, organisatie);


--
-- Name: soortproductregel soortproductregel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.soortproductregel
    ADD CONSTRAINT soortproductregel_pkey PRIMARY KEY (id);


--
-- Name: soortproductregel soortproductregel_volgnummer_taxonomie_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.soortproductregel
    ADD CONSTRAINT soortproductregel_volgnummer_taxonomie_organisatie_key UNIQUE (volgnummer, taxonomie, organisatie);


--
-- Name: soortvooropleiding soortvooropleiding_code_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.soortvooropleiding
    ADD CONSTRAINT soortvooropleiding_code_organisatie_key UNIQUE (code, organisatie);


--
-- Name: soortvooropleiding soortvooropleiding_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.soortvooropleiding
    ADD CONSTRAINT soortvooropleiding_pkey PRIMARY KEY (id);


--
-- Name: soortvooropleidingbuitenlands soortvooropleidingbuitenlands_code_land_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.soortvooropleidingbuitenlands
    ADD CONSTRAINT soortvooropleidingbuitenlands_code_land_key UNIQUE (code, land);


--
-- Name: soortvooropleidingbuitenlands soortvooropleidingbuitenlands_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.soortvooropleidingbuitenlands
    ADD CONSTRAINT soortvooropleidingbuitenlands_pkey PRIMARY KEY (id);


--
-- Name: soortvooropleidingho soortvooropleidingho_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.soortvooropleidingho
    ADD CONSTRAINT soortvooropleidingho_code_key UNIQUE (code);


--
-- Name: soortvooropleidingho soortvooropleidingho_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.soortvooropleidingho
    ADD CONSTRAINT soortvooropleidingho_pkey PRIMARY KEY (id);


--
-- Name: specifiekevraag specifiekevraag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specifiekevraag
    ADD CONSTRAINT specifiekevraag_pkey PRIMARY KEY (id);


--
-- Name: specifiekevraagantwoord specifiekevraagantwoord_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specifiekevraagantwoord
    ADD CONSTRAINT specifiekevraagantwoord_pkey PRIMARY KEY (id);


--
-- Name: sslcertificaat sslcertificaat_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sslcertificaat
    ADD CONSTRAINT sslcertificaat_pkey PRIMARY KEY (id);


--
-- Name: standaardtoetscodefilter standaardtoetscodefilter_opleiding_cohort_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.standaardtoetscodefilter
    ADD CONSTRAINT standaardtoetscodefilter_opleiding_cohort_key UNIQUE (opleiding, cohort);


--
-- Name: standaardtoetscodefilter standaardtoetscodefilter_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.standaardtoetscodefilter
    ADD CONSTRAINT standaardtoetscodefilter_pkey PRIMARY KEY (id);


--
-- Name: studielinkbericht studielinkbericht_inschrijvingsverzoek_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.studielinkbericht
    ADD CONSTRAINT studielinkbericht_inschrijvingsverzoek_key UNIQUE (inschrijvingsverzoek);


--
-- Name: studielinkbericht studielinkbericht_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.studielinkbericht
    ADD CONSTRAINT studielinkbericht_pkey PRIMARY KEY (id);


--
-- Name: taaksoort taaksoort_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taaksoort
    ADD CONSTRAINT taaksoort_pkey PRIMARY KEY (id);


--
-- Name: taalkeuze taalkeuze_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taalkeuze
    ADD CONSTRAINT taalkeuze_pkey PRIMARY KEY (id);


--
-- Name: taalscore taalscore_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taalscore
    ADD CONSTRAINT taalscore_pkey PRIMARY KEY (id);


--
-- Name: taalscoreniveauverzameling taalscoreniveauverzameling_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taalscoreniveauverzameling
    ADD CONSTRAINT taalscoreniveauverzameling_pkey PRIMARY KEY (id);


--
-- Name: taaltype taaltype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taaltype
    ADD CONSTRAINT taaltype_pkey PRIMARY KEY (id);


--
-- Name: taaltypekoppel taaltypekoppel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taaltypekoppel
    ADD CONSTRAINT taaltypekoppel_pkey PRIMARY KEY (id);


--
-- Name: taalvaardigheid taalvaardigheid_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taalvaardigheid
    ADD CONSTRAINT taalvaardigheid_pkey PRIMARY KEY (id);


--
-- Name: taxonomieelement taxonomieelement_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxonomieelement
    ADD CONSTRAINT taxonomieelement_pkey PRIMARY KEY (id);


--
-- Name: taxonomieelement taxonomieelement_taxonomiecode_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxonomieelement
    ADD CONSTRAINT taxonomieelement_taxonomiecode_organisatie_key UNIQUE (taxonomiecode, organisatie);


--
-- Name: taxonomieelementmboleerweg taxonomieelementmboleerweg_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxonomieelementmboleerweg
    ADD CONSTRAINT taxonomieelementmboleerweg_pkey PRIMARY KEY (id);


--
-- Name: taxonomieelementmboleerweg taxonomieelementmboleerweg_taxonomieelement_mboleerweg_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxonomieelementmboleerweg
    ADD CONSTRAINT taxonomieelementmboleerweg_taxonomieelement_mboleerweg_key UNIQUE (taxonomieelement, mboleerweg);


--
-- Name: taxonomieelementtype taxonomieelementtype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxonomieelementtype
    ADD CONSTRAINT taxonomieelementtype_pkey PRIMARY KEY (id);


--
-- Name: taxonomieelementtype taxonomieelementtype_taxonomie_volgnummer_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxonomieelementtype
    ADD CONSTRAINT taxonomieelementtype_taxonomie_volgnummer_key UNIQUE (taxonomie, volgnummer);


--
-- Name: team team_code_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team
    ADD CONSTRAINT team_code_organisatie_key UNIQUE (code, organisatie);


--
-- Name: team team_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team
    ADD CONSTRAINT team_pkey PRIMARY KEY (id);


--
-- Name: tekenbevoegdheid tekenbevoegdheid_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tekenbevoegdheid
    ADD CONSTRAINT tekenbevoegdheid_pkey PRIMARY KEY (id);


--
-- Name: testcategorie testcategorie_code_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.testcategorie
    ADD CONSTRAINT testcategorie_code_organisatie_key UNIQUE (code, organisatie);


--
-- Name: testcategorie testcategorie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.testcategorie
    ADD CONSTRAINT testcategorie_pkey PRIMARY KEY (id);


--
-- Name: testdefinitie testdefinitie_naam_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.testdefinitie
    ADD CONSTRAINT testdefinitie_naam_organisatie_key UNIQUE (naam, organisatie);


--
-- Name: testdefinitie testdefinitie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.testdefinitie
    ADD CONSTRAINT testdefinitie_pkey PRIMARY KEY (id);


--
-- Name: testveld testveld_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.testveld
    ADD CONSTRAINT testveld_pkey PRIMARY KEY (id);


--
-- Name: testveld testveld_volgnummer_testdefinitie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.testveld
    ADD CONSTRAINT testveld_volgnummer_testdefinitie_key UNIQUE (volgnummer, testdefinitie);


--
-- Name: toegekendhulpmiddel toegekendhulpmiddel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toegekendhulpmiddel
    ADD CONSTRAINT toegekendhulpmiddel_pkey PRIMARY KEY (id);


--
-- Name: toegestaandeelgebied toegestaandeelgebied_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toegestaandeelgebied
    ADD CONSTRAINT toegestaandeelgebied_pkey PRIMARY KEY (id);


--
-- Name: toegestaanhulpmiddel toegestaanhulpmiddel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toegestaanhulpmiddel
    ADD CONSTRAINT toegestaanhulpmiddel_pkey PRIMARY KEY (id);


--
-- Name: toegestaanonderwijsproduct toegestaanonderwijsproduct_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toegestaanonderwijsproduct
    ADD CONSTRAINT toegestaanonderwijsproduct_pkey PRIMARY KEY (id);


--
-- Name: toegestanebeginstatus toegestanebeginstatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toegestanebeginstatus
    ADD CONSTRAINT toegestanebeginstatus_pkey PRIMARY KEY (id);


--
-- Name: toegestanestatussoort toegestanestatussoort_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toegestanestatussoort
    ADD CONSTRAINT toegestanestatussoort_pkey PRIMARY KEY (id);


--
-- Name: toegexamenstatusovergang toegexamenstatusovergang_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toegexamenstatusovergang
    ADD CONSTRAINT toegexamenstatusovergang_pkey PRIMARY KEY (id);


--
-- Name: toets toets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toets
    ADD CONSTRAINT toets_pkey PRIMARY KEY (id);


--
-- Name: toetscodefilter toetscodefilter_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toetscodefilter
    ADD CONSTRAINT toetscodefilter_pkey PRIMARY KEY (id);


--
-- Name: toetscodefilterorgehdloc toetscodefilterorgehdloc_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toetscodefilterorgehdloc
    ADD CONSTRAINT toetscodefilterorgehdloc_pkey PRIMARY KEY (id);


--
-- Name: toetsverwijzing toetsverwijzing_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toetsverwijzing
    ADD CONSTRAINT toetsverwijzing_pkey PRIMARY KEY (id);


--
-- Name: traject traject_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traject
    ADD CONSTRAINT traject_pkey PRIMARY KEY (id);


--
-- Name: trajectbeghandelingtemplate trajectbeghandelingtemplate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trajectbeghandelingtemplate
    ADD CONSTRAINT trajectbeghandelingtemplate_pkey PRIMARY KEY (id);


--
-- Name: trajectsoort trajectsoort_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trajectsoort
    ADD CONSTRAINT trajectsoort_pkey PRIMARY KEY (id);


--
-- Name: trajectstatusovergang trajectstatusovergang_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trajectstatusovergang
    ADD CONSTRAINT trajectstatusovergang_pkey PRIMARY KEY (id);


--
-- Name: trajectstatussoort trajectstatussoort_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trajectstatussoort
    ADD CONSTRAINT trajectstatussoort_pkey PRIMARY KEY (id);


--
-- Name: trajecttemplate trajecttemplate_automatischekoppeling_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trajecttemplate
    ADD CONSTRAINT trajecttemplate_automatischekoppeling_key UNIQUE (automatischekoppeling);


--
-- Name: trajecttemplate trajecttemplate_eindhandelingtemplate_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trajecttemplate
    ADD CONSTRAINT trajecttemplate_eindhandelingtemplate_key UNIQUE (eindhandelingtemplate);


--
-- Name: trajecttemplate trajecttemplate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trajecttemplate
    ADD CONSTRAINT trajecttemplate_pkey PRIMARY KEY (id);


--
-- Name: trajecttemplatekoppeling trajecttemplatekoppeling_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trajecttemplatekoppeling
    ADD CONSTRAINT trajecttemplatekoppeling_pkey PRIMARY KEY (id);


--
-- Name: trajectuitvoerder trajectuitvoerder_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trajectuitvoerder
    ADD CONSTRAINT trajectuitvoerder_pkey PRIMARY KEY (id);


--
-- Name: trajtemplautokopp trajtemplautokopp_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trajtemplautokopp
    ADD CONSTRAINT trajtemplautokopp_pkey PRIMARY KEY (id);


--
-- Name: typefinanciering typefinanciering_code_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.typefinanciering
    ADD CONSTRAINT typefinanciering_code_organisatie_key UNIQUE (code, organisatie);


--
-- Name: typefinanciering typefinanciering_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.typefinanciering
    ADD CONSTRAINT typefinanciering_pkey PRIMARY KEY (id);


--
-- Name: typelocatie typelocatie_code_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.typelocatie
    ADD CONSTRAINT typelocatie_code_organisatie_key UNIQUE (code, organisatie);


--
-- Name: typelocatie typelocatie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.typelocatie
    ADD CONSTRAINT typelocatie_pkey PRIMARY KEY (id);


--
-- Name: typetoets typetoets_code_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.typetoets
    ADD CONSTRAINT typetoets_code_organisatie_key UNIQUE (code, organisatie);


--
-- Name: typetoets typetoets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.typetoets
    ADD CONSTRAINT typetoets_pkey PRIMARY KEY (id);


--
-- Name: uitkomstintakegesprek uitkomstintakegesprek_code_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uitkomstintakegesprek
    ADD CONSTRAINT uitkomstintakegesprek_code_organisatie_key UNIQUE (code, organisatie);


--
-- Name: uitkomstintakegesprek uitkomstintakegesprek_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uitkomstintakegesprek
    ADD CONSTRAINT uitkomstintakegesprek_pkey PRIMARY KEY (id);


--
-- Name: vaardigheid vaardigheid_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vaardigheid
    ADD CONSTRAINT vaardigheid_pkey PRIMARY KEY (id);


--
-- Name: vakantie vakantie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vakantie
    ADD CONSTRAINT vakantie_pkey PRIMARY KEY (id);


--
-- Name: vasco_tokens vasco_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vasco_tokens
    ADD CONSTRAINT vasco_tokens_pkey PRIMARY KEY (id);


--
-- Name: veldwaarde veldwaarde_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.veldwaarde
    ADD CONSTRAINT veldwaarde_pkey PRIMARY KEY (id);


--
-- Name: verbintenis verbintenis_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verbintenis
    ADD CONSTRAINT verbintenis_pkey PRIMARY KEY (id);


--
-- Name: verbinteniscontract verbinteniscontract_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verbinteniscontract
    ADD CONSTRAINT verbinteniscontract_pkey PRIMARY KEY (id);


--
-- Name: verbintenisfasecredits verbintenisfasecredits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verbintenisfasecredits
    ADD CONSTRAINT verbintenisfasecredits_pkey PRIMARY KEY (id);


--
-- Name: verbintenisfasecredits verbintenisfasecredits_verbintenis_fase_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verbintenisfasecredits
    ADD CONSTRAINT verbintenisfasecredits_verbintenis_fase_key UNIQUE (verbintenis, fase);


--
-- Name: verbintenisgebiedonderdeel verbintenisgebiedonderdeel_parent_child_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verbintenisgebiedonderdeel
    ADD CONSTRAINT verbintenisgebiedonderdeel_parent_child_key UNIQUE (parent, child);


--
-- Name: verbintenisgebiedonderdeel verbintenisgebiedonderdeel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verbintenisgebiedonderdeel
    ADD CONSTRAINT verbintenisgebiedonderdeel_pkey PRIMARY KEY (id);


--
-- Name: verblijfsvergunning verblijfsvergunning_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verblijfsvergunning
    ADD CONSTRAINT verblijfsvergunning_pkey PRIMARY KEY (id);


--
-- Name: verbruiksmiddel verbruiksmiddel_code_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verbruiksmiddel
    ADD CONSTRAINT verbruiksmiddel_code_organisatie_key UNIQUE (code, organisatie);


--
-- Name: verbruiksmiddel verbruiksmiddel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verbruiksmiddel
    ADD CONSTRAINT verbruiksmiddel_pkey PRIMARY KEY (id);


--
-- Name: vertasigdefevconkoppel vertasigdefevconkoppel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vertasigdefevconkoppel
    ADD CONSTRAINT vertasigdefevconkoppel_pkey PRIMARY KEY (id);


--
-- Name: vervolghandeling vervolghandeling_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vervolghandeling
    ADD CONSTRAINT vervolghandeling_pkey PRIMARY KEY (id);


--
-- Name: vervolgonderwijs vervolgonderwijs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vervolgonderwijs
    ADD CONSTRAINT vervolgonderwijs_pkey PRIMARY KEY (id);


--
-- Name: verzuimtaaksignaaldefinitie verzuimtaaksignaaldefinitie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verzuimtaaksignaaldefinitie
    ADD CONSTRAINT verzuimtaaksignaaldefinitie_pkey PRIMARY KEY (id);


--
-- Name: vooropleiding vooropleiding_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vooropleiding
    ADD CONSTRAINT vooropleiding_pkey PRIMARY KEY (id);


--
-- Name: vooropleidingsignaalcode vooropleidingsignaalcode_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vooropleidingsignaalcode
    ADD CONSTRAINT vooropleidingsignaalcode_pkey PRIMARY KEY (id);


--
-- Name: vooropleidingvak vooropleidingvak_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vooropleidingvak
    ADD CONSTRAINT vooropleidingvak_code_key UNIQUE (code);


--
-- Name: vooropleidingvak vooropleidingvak_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vooropleidingvak
    ADD CONSTRAINT vooropleidingvak_pkey PRIMARY KEY (id);


--
-- Name: vooropleidingvakresultaat vooropleidingvakresultaat_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vooropleidingvakresultaat
    ADD CONSTRAINT vooropleidingvakresultaat_pkey PRIMARY KEY (id);


--
-- Name: voortganghtmlconfig voortganghtmlconfig_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.voortganghtmlconfig
    ADD CONSTRAINT voortganghtmlconfig_pkey PRIMARY KEY (id);


--
-- Name: voortgangpdfconfig voortgangpdfconfig_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.voortgangpdfconfig
    ADD CONSTRAINT voortgangpdfconfig_pkey PRIMARY KEY (id);


--
-- Name: voorvoegsel voorvoegsel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.voorvoegsel
    ADD CONSTRAINT voorvoegsel_pkey PRIMARY KEY (id);


--
-- Name: vrijveld vrijveld_naam_organisatie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vrijveld
    ADD CONSTRAINT vrijveld_naam_organisatie_key UNIQUE (naam, organisatie);


--
-- Name: vrijveld vrijveld_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vrijveld
    ADD CONSTRAINT vrijveld_pkey PRIMARY KEY (id);


--
-- Name: vrijveldentiteit vrijveldentiteit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vrijveldentiteit
    ADD CONSTRAINT vrijveldentiteit_pkey PRIMARY KEY (id);


--
-- Name: vrijveldkeuzeoptie vrijveldkeuzeoptie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vrijveldkeuzeoptie
    ADD CONSTRAINT vrijveldkeuzeoptie_pkey PRIMARY KEY (id);


--
-- Name: vrijveldoptiekeuze vrijveldoptiekeuze_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vrijveldoptiekeuze
    ADD CONSTRAINT vrijveldoptiekeuze_pkey PRIMARY KEY (id);


--
-- Name: waarneming waarneming_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.waarneming
    ADD CONSTRAINT waarneming_pkey PRIMARY KEY (id);


--
-- Name: idx_verbfasecred_fase; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_verbfasecred_fase ON public.verbintenisfasecredits USING btree (fase);


--
-- Name: idx_verbfasecred_gearchiveerd; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_verbfasecred_gearchiveerd ON public.verbintenisfasecredits USING btree (gearchiveerd);


--
-- Name: idx_verbfasecred_idinoudpakke; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_verbfasecred_idinoudpakke ON public.verbintenisfasecredits USING btree (idinoudpakket);


--
-- Name: idx_verbfasecred_organisatie; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_verbfasecred_organisatie ON public.verbintenisfasecredits USING btree (organisatie);


--
-- Name: idx_verbfasecred_ver; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_verbfasecred_ver ON public.verbintenisfasecredits USING btree (verbintenis);


--
-- Name: toegestaanonderwijsproduct fk10aw0roxoqsis9bag4ymfl27h; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toegestaanonderwijsproduct
    ADD CONSTRAINT fk10aw0roxoqsis9bag4ymfl27h FOREIGN KEY (onderwijsproduct) REFERENCES public.onderwijsproduct(id);


--
-- Name: toegestanebeginstatus fk12ms4jk8lrkokwcyxd25igbwg; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toegestanebeginstatus
    ADD CONSTRAINT fk12ms4jk8lrkokwcyxd25igbwg FOREIGN KEY (toegestaneexamenstatusovergang) REFERENCES public.toegexamenstatusovergang(id);


--
-- Name: toetscodefilter fk12p5l2ee43paopln73lae4jo0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toetscodefilter
    ADD CONSTRAINT fk12p5l2ee43paopln73lae4jo0 FOREIGN KEY (medewerker) REFERENCES public.medewerker(id);


--
-- Name: extorgcontactpersoon fk15wbb17iq0up93ibtc71q3mht; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extorgcontactpersoon
    ADD CONSTRAINT fk15wbb17iq0up93ibtc71q3mht FOREIGN KEY (externeorganisatie) REFERENCES public.externeorganisatie(id);


--
-- Name: bijlageentiteit fk16jurys21f9wugrynfry5n2rc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bijlageentiteit
    ADD CONSTRAINT fk16jurys21f9wugrynfry5n2rc FOREIGN KEY (externeorganisatie) REFERENCES public.externeorganisatie(id);


--
-- Name: groepsdeelname fk16x65oichsfbn3o41u0iwg2n7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groepsdeelname
    ADD CONSTRAINT fk16x65oichsfbn3o41u0iwg2n7 FOREIGN KEY (bevatgroep) REFERENCES public.groep(id);


--
-- Name: taxonomieelementtype fk1740v09yoemqh290de6wcgfe1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxonomieelementtype
    ADD CONSTRAINT fk1740v09yoemqh290de6wcgfe1 FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: toegestaandeelgebied fk182ly4cpp0hi939g9glx3h5m9; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toegestaandeelgebied
    ADD CONSTRAINT fk182ly4cpp0hi939g9glx3h5m9 FOREIGN KEY (deelgebied) REFERENCES public.taxonomieelement(id);


--
-- Name: productregel fk184nwpo5sr8vs1xgjyvkusr3y; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productregel
    ADD CONSTRAINT fk184nwpo5sr8vs1xgjyvkusr3y FOREIGN KEY (alleonderwprodtoestaanvan) REFERENCES public.organisatieeenheid(id);


--
-- Name: leerpuntcomponent fk189xj2pss563roc410xumwxrk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leerpuntcomponent
    ADD CONSTRAINT fk189xj2pss563roc410xumwxrk FOREIGN KEY (competentiecomponent) REFERENCES public.competentiecomponent(id);


--
-- Name: intakegesprek fk18odve5i4cshq88tsyy100mg8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intakegesprek
    ADD CONSTRAINT fk18odve5i4cshq88tsyy100mg8 FOREIGN KEY (uitkomstintakegesprek) REFERENCES public.uitkomstintakegesprek(id);


--
-- Name: vooropleiding fk192bayei9c30py43b5rjbf7t0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vooropleiding
    ADD CONSTRAINT fk192bayei9c30py43b5rjbf7t0 FOREIGN KEY (soortvooropleidingbuitenlands) REFERENCES public.soortvooropleidingbuitenlands(id);


--
-- Name: taaltypekoppel fk1a2hmrygobpwjxp8abyy0068a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taaltypekoppel
    ADD CONSTRAINT fk1a2hmrygobpwjxp8abyy0068a FOREIGN KEY (taal) REFERENCES public.modernetaal(id);


--
-- Name: toetsverwijzing fk1bo47dno421p7uwwh6vppvxm0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toetsverwijzing
    ADD CONSTRAINT fk1bo47dno421p7uwwh6vppvxm0 FOREIGN KEY (lezenuit) REFERENCES public.toets(id);


--
-- Name: medewerker fk1dssdoa3i5iah5gdl0k7odsua; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medewerker
    ADD CONSTRAINT fk1dssdoa3i5iah5gdl0k7odsua FOREIGN KEY (redenuitdienst) REFERENCES public.redenuitdienst(id);


--
-- Name: irisbetrokkeneafhandeling fk1h4lfidmtvwpor03i3ikxtx9v; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.irisbetrokkeneafhandeling
    ADD CONSTRAINT fk1h4lfidmtvwpor03i3ikxtx9v FOREIGN KEY (betrokkene) REFERENCES public.irisbetrokkene(id);


--
-- Name: bookmarkfolder fk1hhd555ajhdj133wbdfetvmx7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookmarkfolder
    ADD CONSTRAINT fk1hhd555ajhdj133wbdfetvmx7 FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: bookmark fk1ib87jl09ov0mek2gpb08s8j8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookmark
    ADD CONSTRAINT fk1ib87jl09ov0mek2gpb08s8j8 FOREIGN KEY (account) REFERENCES public.account(id);


--
-- Name: cacheregion fk1kgumruaw40ed3bahc51r5bsb; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cacheregion
    ADD CONSTRAINT fk1kgumruaw40ed3bahc51r5bsb FOREIGN KEY (externeagenda) REFERENCES public.externeagenda(id);


--
-- Name: taxonomieelement fk1kq04tf2lfj7f10gfsj6x6imy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxonomieelement
    ADD CONSTRAINT fk1kq04tf2lfj7f10gfsj6x6imy FOREIGN KEY (competentiematrix) REFERENCES public.taxonomieelement(id);


--
-- Name: taalscoreniveauverzameling fk1lapvjgq9uyop78w4gt0ijvwm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taalscoreniveauverzameling
    ADD CONSTRAINT fk1lapvjgq9uyop78w4gt0ijvwm FOREIGN KEY (taaltype) REFERENCES public.taaltype(id);


--
-- Name: taxonomieelement fk1ni3ymvoas0ocndybkxkc6cp2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxonomieelement
    ADD CONSTRAINT fk1ni3ymvoas0ocndybkxkc6cp2 FOREIGN KEY (kerntaak) REFERENCES public.taxonomieelement(id);


--
-- Name: rapportagetemplateijkpunt fk1sr80wv7ymxicjk75yn5n36d9; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rapportagetemplateijkpunt
    ADD CONSTRAINT fk1sr80wv7ymxicjk75yn5n36d9 FOREIGN KEY (config) REFERENCES public.voortganghtmlconfig(id);


--
-- Name: organisatiemedewerker fk1tpjof6ip6tkxstpx2j0as9re; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisatiemedewerker
    ADD CONSTRAINT fk1tpjof6ip6tkxstpx2j0as9re FOREIGN KEY (organisatieeenheid) REFERENCES public.organisatieeenheid(id);


--
-- Name: bpvcriteriabpvplaats fk1yawqlt23vnr26v1y71wgoen6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvcriteriabpvplaats
    ADD CONSTRAINT fk1yawqlt23vnr26v1y71wgoen6 FOREIGN KEY (bpvcriteria) REFERENCES public.bpvcriteria(id);


--
-- Name: vrijveldoptiekeuze fk2027k4ecklq8mc8tsxbmf3ija; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vrijveldoptiekeuze
    ADD CONSTRAINT fk2027k4ecklq8mc8tsxbmf3ija FOREIGN KEY (optie) REFERENCES public.vrijveldkeuzeoptie(id);


--
-- Name: waarneming fk202e6coryot6tsdw9o09dey6i; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.waarneming
    ADD CONSTRAINT fk202e6coryot6tsdw9o09dey6i FOREIGN KEY (deelnemer) REFERENCES public.deelnemer(id);


--
-- Name: bookmarkconstructorargument fk268c5e690xplc2bsrrg8emrl9; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookmarkconstructorargument
    ADD CONSTRAINT fk268c5e690xplc2bsrrg8emrl9 FOREIGN KEY (bookmark) REFERENCES public.bookmark(id);


--
-- Name: groepsdeelname fk27dqs4rnixp0xanmc14yt1vu6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groepsdeelname
    ADD CONSTRAINT fk27dqs4rnixp0xanmc14yt1vu6 FOREIGN KEY (fase) REFERENCES public.fase(id);


--
-- Name: bpvinschrijving fk27osujpwd3e0wwd836tsgo3g0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvinschrijving
    ADD CONSTRAINT fk27osujpwd3e0wwd836tsgo3g0 FOREIGN KEY (bpvplaats) REFERENCES public.bpvplaats(id);


--
-- Name: grouppropertysetting fk27w6jkbrfn360nepw83sk36ai; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grouppropertysetting
    ADD CONSTRAINT fk27w6jkbrfn360nepw83sk36ai FOREIGN KEY (account) REFERENCES public.account(id);


--
-- Name: bijlageentiteit fk28kx2qu4782hsn6ew6g092jgb; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bijlageentiteit
    ADD CONSTRAINT fk28kx2qu4782hsn6ew6g092jgb FOREIGN KEY (afspraak) REFERENCES public.afspraak(id);


--
-- Name: accountrol fk292wl29678t9segb1w5gyfllt; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accountrol
    ADD CONSTRAINT fk292wl29678t9segb1w5gyfllt FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: afspraakparticipant fk2asnt191pmu00tfhmqc5vh87d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.afspraakparticipant
    ADD CONSTRAINT fk2asnt191pmu00tfhmqc5vh87d FOREIGN KEY (afspraak) REFERENCES public.afspraak(id);


--
-- Name: criterium fk2at6ueysimxpmhrtjig3pp76v; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.criterium
    ADD CONSTRAINT fk2at6ueysimxpmhrtjig3pp76v FOREIGN KEY (cohort) REFERENCES public.cohort(id);


--
-- Name: contractlocatiekoppeling fk2c7mvcswjfychbkixllymsu31; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contractlocatiekoppeling
    ADD CONSTRAINT fk2c7mvcswjfychbkixllymsu31 FOREIGN KEY (contract_id) REFERENCES public.contract(id);


--
-- Name: vooropleiding fk2dwf4r4q90idvfsrfk7yq2tge; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vooropleiding
    ADD CONSTRAINT fk2dwf4r4q90idvfsrfk7yq2tge FOREIGN KEY (soortvooropleiding) REFERENCES public.soortvooropleiding(id);


--
-- Name: bookmarkfolder fk2e58vkhpq6vwvvxg87haolxy4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookmarkfolder
    ADD CONSTRAINT fk2e58vkhpq6vwvvxg87haolxy4 FOREIGN KEY (account) REFERENCES public.account(id);


--
-- Name: contractverplichting fk2ftrs02nilwnkgpn6shix1bn4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contractverplichting
    ADD CONSTRAINT fk2ftrs02nilwnkgpn6shix1bn4 FOREIGN KEY (contract) REFERENCES public.contract(id);


--
-- Name: meeteenheidkoppel fk2fw46jwufcmdglmwlp5ublqg3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meeteenheidkoppel
    ADD CONSTRAINT fk2fw46jwufcmdglmwlp5ublqg3 FOREIGN KEY (cohort) REFERENCES public.cohort(id);


--
-- Name: maatregeltoekenning fk2gc112td5gp6k8fe739a4p0lu; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maatregeltoekenning
    ADD CONSTRAINT fk2gc112td5gp6k8fe739a4p0lu FOREIGN KEY (veroorzaaktdoor) REFERENCES public.absentiemelding(id);


--
-- Name: bijlageentiteit fk2gt76lhlvcdk0xyydp7i8ucsq; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bijlageentiteit
    ADD CONSTRAINT fk2gt76lhlvcdk0xyydp7i8ucsq FOREIGN KEY (trajecttemplate) REFERENCES public.trajecttemplate(id);


--
-- Name: extorgcontactgegeven fk2gyjtogge9l0re9r6dkukv0ij; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extorgcontactgegeven
    ADD CONSTRAINT fk2gyjtogge9l0re9r6dkukv0ij FOREIGN KEY (soortcontactgegeven) REFERENCES public.soortcontactgegeven(id);


--
-- Name: onderwijsproductafname fk2i127wuj15itehan8fab95qdx; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproductafname
    ADD CONSTRAINT fk2i127wuj15itehan8fab95qdx FOREIGN KEY (deelnemer) REFERENCES public.deelnemer(id);


--
-- Name: organisatieeenheidlocatie fk2id1cuti4eonk49cs6mif8nk0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisatieeenheidlocatie
    ADD CONSTRAINT fk2id1cuti4eonk49cs6mif8nk0 FOREIGN KEY (organisatieeenheid) REFERENCES public.organisatieeenheid(id);


--
-- Name: onderwijsproductsamenstelling fk2jaao252fgrb46mvgil3yx0dt; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproductsamenstelling
    ADD CONSTRAINT fk2jaao252fgrb46mvgil3yx0dt FOREIGN KEY (child) REFERENCES public.onderwijsproduct(id);


--
-- Name: taxonomieelementmboleerweg fk2kvcxgkcxc1b1fg72mbme3gh4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxonomieelementmboleerweg
    ADD CONSTRAINT fk2kvcxgkcxc1b1fg72mbme3gh4 FOREIGN KEY (taxonomieelement) REFERENCES public.taxonomieelement(id);


--
-- Name: edvcs fk2lcpdfdvfc2a3aqt9ec65011a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.edvcs
    ADD CONSTRAINT fk2lcpdfdvfc2a3aqt9ec65011a FOREIGN KEY (account) REFERENCES public.account(id);


--
-- Name: bijlageentiteit fk2lg7bonxruj1bhef6h59t9bw1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bijlageentiteit
    ADD CONSTRAINT fk2lg7bonxruj1bhef6h59t9bw1 FOREIGN KEY (deelnemer) REFERENCES public.deelnemer(id);


--
-- Name: bpvinschrijving fk2nsk9ky551pbbest9y7h9h3uk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvinschrijving
    ADD CONSTRAINT fk2nsk9ky551pbbest9y7h9h3uk FOREIGN KEY (praktijkopleiderbpvbedrijf) REFERENCES public.extorgcontactpersoon(id);


--
-- Name: externeorganisatiekenmerk fk2nvhnh1v497tuit4uwrjpujsi; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.externeorganisatiekenmerk
    ADD CONSTRAINT fk2nvhnh1v497tuit4uwrjpujsi FOREIGN KEY (externeorganisatie) REFERENCES public.externeorganisatie(id);


--
-- Name: deelnemertoetsbevriezing fk2o02c4smt3pjv3hy9c7f6e3bn; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deelnemertoetsbevriezing
    ADD CONSTRAINT fk2o02c4smt3pjv3hy9c7f6e3bn FOREIGN KEY (toets) REFERENCES public.toets(id);


--
-- Name: contractlocatiekoppeling fk2uf1ab0xy3dchm36rjqv5e56f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contractlocatiekoppeling
    ADD CONSTRAINT fk2uf1ab0xy3dchm36rjqv5e56f FOREIGN KEY (locatie_id) REFERENCES public.locatie(id);


--
-- Name: medewerker fk2ya7fgu57j66cjpw8tu3x1d85; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medewerker
    ADD CONSTRAINT fk2ya7fgu57j66cjpw8tu3x1d85 FOREIGN KEY (functie) REFERENCES public.functie(id);


--
-- Name: meeteenheidkoppel fk30xd8jsdjmeer0pi3suwulw7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meeteenheidkoppel
    ADD CONSTRAINT fk30xd8jsdjmeer0pi3suwulw7 FOREIGN KEY (opleiding) REFERENCES public.opleiding(id);


--
-- Name: inschrijvingsverzoek fk31v7ibd7bgflt040s9edf5aod; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inschrijvingsverzoek
    ADD CONSTRAINT fk31v7ibd7bgflt040s9edf5aod FOREIGN KEY (studielinkbericht) REFERENCES public.studielinkbericht(id);


--
-- Name: resultaatstructuur fk32vu0q8ik2k67qpxhh8obrx3d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resultaatstructuur
    ADD CONSTRAINT fk32vu0q8ik2k67qpxhh8obrx3d FOREIGN KEY (categorie) REFERENCES public.resultaatstructuurcategorie(id);


--
-- Name: vakantie fk35p49pltsiypkha7kagiolmg2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vakantie
    ADD CONSTRAINT fk35p49pltsiypkha7kagiolmg2 FOREIGN KEY (basisrooster) REFERENCES public.basisrooster(id);


--
-- Name: medewerkergroepabonnering fk38bnjdk9u0tv55i9op19phnxe; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medewerkergroepabonnering
    ADD CONSTRAINT fk38bnjdk9u0tv55i9op19phnxe FOREIGN KEY (groep) REFERENCES public.groep(id);


--
-- Name: persoon fk3a5lke9jg3yf8rsu0yt9baiu4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persoon
    ADD CONSTRAINT fk3a5lke9jg3yf8rsu0yt9baiu4 FOREIGN KEY (landbank) REFERENCES public.land(id);


--
-- Name: ondprodgebruiksmiddel fk3dexq2dc6nvsr9xhjtjenidxa; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ondprodgebruiksmiddel
    ADD CONSTRAINT fk3dexq2dc6nvsr9xhjtjenidxa FOREIGN KEY (onderwijsproduct) REFERENCES public.onderwijsproduct(id);


--
-- Name: persoon fk3e85javk9n5gi1xqnibqdgr5t; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persoon
    ADD CONSTRAINT fk3e85javk9n5gi1xqnibqdgr5t FOREIGN KEY (afbeelding) REFERENCES public.bijlageentiteit(id);


--
-- Name: verbintenisgebiedonderdeel fk3ftspxdxisnxovjgesp818icr; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verbintenisgebiedonderdeel
    ADD CONSTRAINT fk3ftspxdxisnxovjgesp818icr FOREIGN KEY (parent) REFERENCES public.taxonomieelement(id);


--
-- Name: toets fk3he66ff5epv0gcxhckid6cn0x; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toets
    ADD CONSTRAINT fk3he66ff5epv0gcxhckid6cn0x FOREIGN KEY (parent) REFERENCES public.toets(id);


--
-- Name: inschrijvingsverzoek fk3hrofg5niy1y4h6r5offakfb7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inschrijvingsverzoek
    ADD CONSTRAINT fk3hrofg5niy1y4h6r5offakfb7 FOREIGN KEY (plaatsing) REFERENCES public.groepsdeelname(id);


--
-- Name: examendeelname fk3iio4t2w6dnfx3l28fu6rddwa; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.examendeelname
    ADD CONSTRAINT fk3iio4t2w6dnfx3l28fu6rddwa FOREIGN KEY (verbintenis) REFERENCES public.verbintenis(id);


--
-- Name: taalscoreniveauverzameling fk3ir3cn2uc17vgw9ebqsqjj8xm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taalscoreniveauverzameling
    ADD CONSTRAINT fk3ir3cn2uc17vgw9ebqsqjj8xm FOREIGN KEY (meeteenheid) REFERENCES public.meeteenheid(id);


--
-- Name: inschrijvingsverzoek fk3l59080muu6t5gmqlbk11nr5u; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inschrijvingsverzoek
    ADD CONSTRAINT fk3l59080muu6t5gmqlbk11nr5u FOREIGN KEY (verbintenis) REFERENCES public.verbintenis(id);


--
-- Name: documenttemplaterecht fk3p1pt2lhe4nnjamsvxgrtj922; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documenttemplaterecht
    ADD CONSTRAINT fk3p1pt2lhe4nnjamsvxgrtj922 FOREIGN KEY (documentcategorie) REFERENCES public.documentcategorie(id);


--
-- Name: afspraak fk410h290ww0pshjifjgb2g154n; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.afspraak
    ADD CONSTRAINT fk410h290ww0pshjifjgb2g154n FOREIGN KEY (herhalendeafspraak) REFERENCES public.herhalendeafspraak(id);


--
-- Name: vrijveldentiteit fk41bi22914alavd4rok0h1qkfo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vrijveldentiteit
    ADD CONSTRAINT fk41bi22914alavd4rok0h1qkfo FOREIGN KEY (verbintenis) REFERENCES public.verbintenis(id);


--
-- Name: instellingslogo fk42bgvn72qsltwxw6058mawvj4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instellingslogo
    ADD CONSTRAINT fk42bgvn72qsltwxw6058mawvj4 FOREIGN KEY (bijlage) REFERENCES public.bijlage(id);


--
-- Name: competentieniveauverzameling fk447mp6ar2xouge31obkwv5x5j; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.competentieniveauverzameling
    ADD CONSTRAINT fk447mp6ar2xouge31obkwv5x5j FOREIGN KEY (groep) REFERENCES public.groep(id);


--
-- Name: productregel fk44nmrfvj6b9uii5dyyadx88ob; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productregel
    ADD CONSTRAINT fk44nmrfvj6b9uii5dyyadx88ob FOREIGN KEY (fase) REFERENCES public.fase(id);


--
-- Name: productregel fk456up64qenkuyaug60mwpqjq2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productregel
    ADD CONSTRAINT fk456up64qenkuyaug60mwpqjq2 FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: externeorganisatie fk45qjltvltsahmsiahxo1d22sm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.externeorganisatie
    ADD CONSTRAINT fk45qjltvltsahmsiahxo1d22sm FOREIGN KEY (soortexterneorganisatie) REFERENCES public.soortexterneorganisatie(id);


--
-- Name: onderwijsproduct fk45tvv9ta58wff3x2vx288x09n; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproduct
    ADD CONSTRAINT fk45tvv9ta58wff3x2vx288x09n FOREIGN KEY (typelocatie) REFERENCES public.typelocatie(id);


--
-- Name: verbintenis fk45vsbd3g2w0mq6fycabsevc30; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verbintenis
    ADD CONSTRAINT fk45vsbd3g2w0mq6fycabsevc30 FOREIGN KEY (relevanteverbintenis) REFERENCES public.verbintenis(id);


--
-- Name: niettoneninzorgvierkant fk49lc496awo1csiepy58c0isl9; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.niettoneninzorgvierkant
    ADD CONSTRAINT fk49lc496awo1csiepy58c0isl9 FOREIGN KEY (notitie) REFERENCES public.notitie(id);


--
-- Name: onderwijsproduct fk4aktxushj4dqkbm3o1n3uckhe; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproduct
    ADD CONSTRAINT fk4aktxushj4dqkbm3o1n3uckhe FOREIGN KEY (soortpraktijklokaal) REFERENCES public.soortpraktijklokaal(id);


--
-- Name: leerpuntvaardigheid fk4b6uxadlw98l4v8efqkuivdoi; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leerpuntvaardigheid
    ADD CONSTRAINT fk4b6uxadlw98l4v8efqkuivdoi FOREIGN KEY (vaardigheid) REFERENCES public.vaardigheid(id);


--
-- Name: bijlageentiteit fk4f2sc6dxtooh0fa9s35dccd1w; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bijlageentiteit
    ADD CONSTRAINT fk4f2sc6dxtooh0fa9s35dccd1w FOREIGN KEY (persoon) REFERENCES public.persoon(id);


--
-- Name: persoon fk4ffma3ngok6hdqmsj0ay4w6ew; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persoon
    ADD CONSTRAINT fk4ffma3ngok6hdqmsj0ay4w6ew FOREIGN KEY (geboortegemeente) REFERENCES public.gemeente(id);


--
-- Name: competentieniveauverzameling fk4hfqnwux5fkbnax271sm481tt; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.competentieniveauverzameling
    ADD CONSTRAINT fk4hfqnwux5fkbnax271sm481tt FOREIGN KEY (deelnemer) REFERENCES public.deelnemer(id);


--
-- Name: organisatieeenheid fk4kc6yr0f3vh1dghphv865ry9c; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisatieeenheid
    ADD CONSTRAINT fk4kc6yr0f3vh1dghphv865ry9c FOREIGN KEY (soortorganisatieeenheid) REFERENCES public.soortorgehd(id);


--
-- Name: examenstatus fk4ku960isfsdwv61hix8ncwx0u; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.examenstatus
    ADD CONSTRAINT fk4ku960isfsdwv61hix8ncwx0u FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: account fk4lllrmwgp9d8qri6yys91x9vq; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT fk4lllrmwgp9d8qri6yys91x9vq FOREIGN KEY (externeorganisatiecontpers) REFERENCES public.extorgcontactpersoon(id);


--
-- Name: abstractdeelnemerevent fk4oje6wjsmo1wd3g9wpqi6oi1j; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.abstractdeelnemerevent
    ADD CONSTRAINT fk4oje6wjsmo1wd3g9wpqi6oi1j FOREIGN KEY (deelnemerid) REFERENCES public.deelnemer(id);


--
-- Name: afspraak fk4olb3t2uw14mqe432td0n0c7t; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.afspraak
    ADD CONSTRAINT fk4olb3t2uw14mqe432td0n0c7t FOREIGN KEY (auteur) REFERENCES public.persoon(id);


--
-- Name: bpvcriteriabpvkandidaat fk4q4ew342av0lmgjweq004m85r; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvcriteriabpvkandidaat
    ADD CONSTRAINT fk4q4ew342av0lmgjweq004m85r FOREIGN KEY (bpvcriteria) REFERENCES public.bpvcriteria(id);


--
-- Name: contractonderdeel fk4r794v3w4w6tp4nyq3wmnvkhw; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contractonderdeel
    ADD CONSTRAINT fk4r794v3w4w6tp4nyq3wmnvkhw FOREIGN KEY (contract) REFERENCES public.contract(id);


--
-- Name: externeorganisatieopmerking fk4rutxp3n3mr0sh55web61x121; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.externeorganisatieopmerking
    ADD CONSTRAINT fk4rutxp3n3mr0sh55web61x121 FOREIGN KEY (externeorganisatie) REFERENCES public.externeorganisatie(id);


--
-- Name: vooropleiding fk4vh65enc2ia1w788vwsc76tn9; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vooropleiding
    ADD CONSTRAINT fk4vh65enc2ia1w788vwsc76tn9 FOREIGN KEY (externeorganisatie) REFERENCES public.externeorganisatie(id);


--
-- Name: abstractrelatie fk51u9k1gpc7jproe8ncn5fvbtg; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.abstractrelatie
    ADD CONSTRAINT fk51u9k1gpc7jproe8ncn5fvbtg FOREIGN KEY (verzorger) REFERENCES public.persoon(id);


--
-- Name: examenstatusovergang fk55asf05q8hqovit88whnuhl6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.examenstatusovergang
    ADD CONSTRAINT fk55asf05q8hqovit88whnuhl6 FOREIGN KEY (examendeelname) REFERENCES public.examendeelname(id);


--
-- Name: organisatiesetting fk580jumhii5mny4e1lu3ioj8wa; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisatiesetting
    ADD CONSTRAINT fk580jumhii5mny4e1lu3ioj8wa FOREIGN KEY (organisatieeenheid) REFERENCES public.organisatieeenheid(id);


--
-- Name: afspraakparticipant fk5bg1wexax8rskktfed7jh8epv; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.afspraakparticipant
    ADD CONSTRAINT fk5bg1wexax8rskktfed7jh8epv FOREIGN KEY (deelnemer) REFERENCES public.deelnemer(id);


--
-- Name: rapportagetemplateijkpunt fk5cejrs8awe6eu0ghj2lex4qno; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rapportagetemplateijkpunt
    ADD CONSTRAINT fk5cejrs8awe6eu0ghj2lex4qno FOREIGN KEY (ijkpunt) REFERENCES public.competentieniveauverzameling(id);


--
-- Name: onderwijsproductafnamecontext fk5cnnxtg7hv5rlfmclo03ep1te; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproductafnamecontext
    ADD CONSTRAINT fk5cnnxtg7hv5rlfmclo03ep1te FOREIGN KEY (onderwijsproductafname) REFERENCES public.onderwijsproductafname(id);


--
-- Name: medewerkergroepabonnering fk5e6s3q6s9bgj5vqerdsl7pe4s; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medewerkergroepabonnering
    ADD CONSTRAINT fk5e6s3q6s9bgj5vqerdsl7pe4s FOREIGN KEY (medewerker) REFERENCES public.medewerker(id);


--
-- Name: deelnemertoetsbevriezing fk5f8mye586d3ujdp5eu929ek1n; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deelnemertoetsbevriezing
    ADD CONSTRAINT fk5f8mye586d3ujdp5eu929ek1n FOREIGN KEY (deelnemer) REFERENCES public.deelnemer(id);


--
-- Name: vooropleiding fk5fnpundn18xt52n8ig141tp8a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vooropleiding
    ADD CONSTRAINT fk5fnpundn18xt52n8ig141tp8a FOREIGN KEY (soortvooropleidingcroho) REFERENCES public.taxonomieelement(id);


--
-- Name: vervolgonderwijs fk5h4xk1gogxrcdajijtakcyne0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vervolgonderwijs
    ADD CONSTRAINT fk5h4xk1gogxrcdajijtakcyne0 FOREIGN KEY (code) REFERENCES public.externeorganisatie(id);


--
-- Name: ibgverzuimmelding fk5hs1hdu6fb7kga5yn5jv96p7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ibgverzuimmelding
    ADD CONSTRAINT fk5hs1hdu6fb7kga5yn5jv96p7 FOREIGN KEY (verbintenis) REFERENCES public.verbintenis(id);


--
-- Name: criterium fk5i56x29lb4ww385dn98q4fmgy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.criterium
    ADD CONSTRAINT fk5i56x29lb4ww385dn98q4fmgy FOREIGN KEY (opleiding) REFERENCES public.opleiding(id);


--
-- Name: onderwijsproduct fk5jp6tirond5m4lfm2fnjqtyit; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproduct
    ADD CONSTRAINT fk5jp6tirond5m4lfm2fnjqtyit FOREIGN KEY (aggregatieniveau) REFERENCES public.aggregatieniveau(id);


--
-- Name: resultaatstructuur fk5kxb825d593xvusf2jm2t0isb; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resultaatstructuur
    ADD CONSTRAINT fk5kxb825d593xvusf2jm2t0isb FOREIGN KEY (onderwijsproduct) REFERENCES public.onderwijsproduct(id);


--
-- Name: olclocatie fk5n8lvioujbyls2b2j62ku4w73; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.olclocatie
    ADD CONSTRAINT fk5n8lvioujbyls2b2j62ku4w73 FOREIGN KEY (locatie) REFERENCES public.locatie(id);


--
-- Name: account fk5vcpvcrrjrn3ddt1a41wy57o6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT fk5vcpvcrrjrn3ddt1a41wy57o6 FOREIGN KEY (medewerker) REFERENCES public.medewerker(id);


--
-- Name: externeagendakoppeling fk5vkbgvem4kcf7du9re02jpntv; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.externeagendakoppeling
    ADD CONSTRAINT fk5vkbgvem4kcf7du9re02jpntv FOREIGN KEY (afspraaktype_id) REFERENCES public.afspraaktype(id);


--
-- Name: onderwijsproductvoorwaarde fk5x0sxnd28830w47mhte6m4tmd; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproductvoorwaarde
    ADD CONSTRAINT fk5x0sxnd28830w47mhte6m4tmd FOREIGN KEY (voorwaardelijkproduct) REFERENCES public.onderwijsproduct(id);


--
-- Name: resultaatzoekfilterinstelling fk5ygsahw515gok1expxk4crpvk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resultaatzoekfilterinstelling
    ADD CONSTRAINT fk5ygsahw515gok1expxk4crpvk FOREIGN KEY (medewerker) REFERENCES public.medewerker(id);


--
-- Name: examenworkflowtax fk6073tienar1xwuwplvkwvx1qx; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.examenworkflowtax
    ADD CONSTRAINT fk6073tienar1xwuwplvkwvx1qx FOREIGN KEY (examenworkflow) REFERENCES public.examenworkflow(id);


--
-- Name: persoonlijketoetscode fk60cxvsnpe67qan1lqq23rkou9; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persoonlijketoetscode
    ADD CONSTRAINT fk60cxvsnpe67qan1lqq23rkou9 FOREIGN KEY (toets) REFERENCES public.toets(id);


--
-- Name: meeteenheidkoppel fk60sxnyevagr841ljf1hrbnbkm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meeteenheidkoppel
    ADD CONSTRAINT fk60sxnyevagr841ljf1hrbnbkm FOREIGN KEY (meeteenheid) REFERENCES public.meeteenheid(id);


--
-- Name: gespreksoort fk61d2mud3x477rxi9ej7husmxc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gespreksoort
    ADD CONSTRAINT fk61d2mud3x477rxi9ej7husmxc FOREIGN KEY (organisatieeenheid) REFERENCES public.organisatieeenheid(id);


--
-- Name: trajecttemplate fk63qdhi7rchkusktp5stfn0xm6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trajecttemplate
    ADD CONSTRAINT fk63qdhi7rchkusktp5stfn0xm6 FOREIGN KEY (locatie) REFERENCES public.locatie(id);


--
-- Name: locatiecontactgegeven fk659w2xv1dfm2qaf546gtylfsg; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locatiecontactgegeven
    ADD CONSTRAINT fk659w2xv1dfm2qaf546gtylfsg FOREIGN KEY (locatie) REFERENCES public.locatie(id);


--
-- Name: bijlageentiteit fk65vulvuxlbcixghbksh7rydov; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bijlageentiteit
    ADD CONSTRAINT fk65vulvuxlbcixghbksh7rydov FOREIGN KEY (begeleidingshandeling) REFERENCES public.begeleidingshandeling(id);


--
-- Name: absentiereden fk663jeujq1qtgplnwfv9xxib4k; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.absentiereden
    ADD CONSTRAINT fk663jeujq1qtgplnwfv9xxib4k FOREIGN KEY (locatie) REFERENCES public.locatie(id);


--
-- Name: deelnemerkenmerk fk671dnktqbao2uvo0rio8eprd0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deelnemerkenmerk
    ADD CONSTRAINT fk671dnktqbao2uvo0rio8eprd0 FOREIGN KEY (deelnemer) REFERENCES public.deelnemer(id);


--
-- Name: irisincident fk68ffprtk8akp19g6ih1slwno4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.irisincident
    ADD CONSTRAINT fk68ffprtk8akp19g6ih1slwno4 FOREIGN KEY (categorie) REFERENCES public.incidentcategorie(id);


--
-- Name: verbintenisgebiedonderdeel fk69g9rbi96xtvruku6ughqvgdg; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verbintenisgebiedonderdeel
    ADD CONSTRAINT fk69g9rbi96xtvruku6ughqvgdg FOREIGN KEY (child) REFERENCES public.taxonomieelement(id);


--
-- Name: competentieniveauverzameling fk6aosuh7maiuswpo9g8x33dpv6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.competentieniveauverzameling
    ADD CONSTRAINT fk6aosuh7maiuswpo9g8x33dpv6 FOREIGN KEY (meeteenheid) REFERENCES public.meeteenheid(id);


--
-- Name: vrijveldentiteit fk6blxg64hn4jy5d93bq6r555w3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vrijveldentiteit
    ADD CONSTRAINT fk6blxg64hn4jy5d93bq6r555w3 FOREIGN KEY (vooropleiding) REFERENCES public.vooropleiding(id);


--
-- Name: account fk6bmxeioeljcf69a9x8ba5xpaw; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT fk6bmxeioeljcf69a9x8ba5xpaw FOREIGN KEY (deelnemer) REFERENCES public.deelnemer(id);


--
-- Name: afspraakparticipant fk6en365kbyvtppg8n5anvcnc05; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.afspraakparticipant
    ADD CONSTRAINT fk6en365kbyvtppg8n5anvcnc05 FOREIGN KEY (persoonlijkegroep) REFERENCES public.groep(id);


--
-- Name: betrokkenmedewerker fk6euhooattwcvj9jsis4y89gjt; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.betrokkenmedewerker
    ADD CONSTRAINT fk6euhooattwcvj9jsis4y89gjt FOREIGN KEY (incident) REFERENCES public.incident(id);


--
-- Name: vooropleiding fk6fosv95fx6nydeqln6fx258ac; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vooropleiding
    ADD CONSTRAINT fk6fosv95fx6nydeqln6fx258ac FOREIGN KEY (land) REFERENCES public.land(id);


--
-- Name: intakegesprek fk6h0o06njchsk0wqq1fos151iq; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intakegesprek
    ADD CONSTRAINT fk6h0o06njchsk0wqq1fos151iq FOREIGN KEY (gewenstelocatie) REFERENCES public.locatie(id);


--
-- Name: eventabonnementsetting fk6i3ww8hgfohvroi7an7e9wnf3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eventabonnementsetting
    ADD CONSTRAINT fk6i3ww8hgfohvroi7an7e9wnf3 FOREIGN KEY (persoon) REFERENCES public.persoon(id);


--
-- Name: bijzonderheidcategorie fk6jqdoejfyhq6m0n8b4yaw9n2h; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bijzonderheidcategorie
    ADD CONSTRAINT fk6jqdoejfyhq6m0n8b4yaw9n2h FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: contactpersoon fk6kl8sqmqbry0kpq8x5oo5y6xq; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contactpersoon
    ADD CONSTRAINT fk6kl8sqmqbry0kpq8x5oo5y6xq FOREIGN KEY (voororganisatieeenheid) REFERENCES public.organisatieeenheid(id);


--
-- Name: criterium fk6p8iivbsrgohev9xjl7r9pknu; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.criterium
    ADD CONSTRAINT fk6p8iivbsrgohev9xjl7r9pknu FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: gespreksoort fk6p8jxudsfpeqguw9yoatojin1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gespreksoort
    ADD CONSTRAINT fk6p8jxudsfpeqguw9yoatojin1 FOREIGN KEY (locatie) REFERENCES public.locatie(id);


--
-- Name: groepmentor fk6pehg0loq0fchtrvm5kw82yhf; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groepmentor
    ADD CONSTRAINT fk6pehg0loq0fchtrvm5kw82yhf FOREIGN KEY (groep) REFERENCES public.groep(id);


--
-- Name: bpvkandidaat fk6s10t0wcn247qmh83cu6691he; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvkandidaat
    ADD CONSTRAINT fk6s10t0wcn247qmh83cu6691he FOREIGN KEY (bpvinschrijving) REFERENCES public.bpvinschrijving(id);


--
-- Name: taaksoort fk6tdlvpj3ja7ncwg6rrki7wkeg; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taaksoort
    ADD CONSTRAINT fk6tdlvpj3ja7ncwg6rrki7wkeg FOREIGN KEY (organisatieeenheid) REFERENCES public.organisatieeenheid(id);


--
-- Name: extorgcontactgegeven fk6xb1x4rlyojpls628aeqdy496; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extorgcontactgegeven
    ADD CONSTRAINT fk6xb1x4rlyojpls628aeqdy496 FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: deelnemerpersoonlijkegroep fk6xr75tp2yi75bhwgcuj4i7yw1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deelnemerpersoonlijkegroep
    ADD CONSTRAINT fk6xr75tp2yi75bhwgcuj4i7yw1 FOREIGN KEY (groep) REFERENCES public.groep(id);


--
-- Name: maatregeltoekenningsregel fk7127p63avoao7tsfpeh2irxle; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maatregeltoekenningsregel
    ADD CONSTRAINT fk7127p63avoao7tsfpeh2irxle FOREIGN KEY (maatregel) REFERENCES public.maatregel(id);


--
-- Name: bpvcriteriabpvdeelnemerprofiel fk72e4cbh8t17q9j3ed5e1hmgud; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvcriteriabpvdeelnemerprofiel
    ADD CONSTRAINT fk72e4cbh8t17q9j3ed5e1hmgud FOREIGN KEY (bpvcriteria) REFERENCES public.bpvcriteria(id);


--
-- Name: persoonextorgcontactpersoon fk74sa8xaxeid4di4hjsnqyfmrq; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persoonextorgcontactpersoon
    ADD CONSTRAINT fk74sa8xaxeid4di4hjsnqyfmrq FOREIGN KEY (persoonexterneorganisatie) REFERENCES public.abstractrelatie(id);


--
-- Name: afspraak fk773bacs2irouefldqg4atctdw; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.afspraak
    ADD CONSTRAINT fk773bacs2irouefldqg4atctdw FOREIGN KEY (inloopcollege) REFERENCES public.inloopcollege(id);


--
-- Name: crohoopleidingaanbod fk77o9ajrheqkxehiglrpad9isw; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crohoopleidingaanbod
    ADD CONSTRAINT fk77o9ajrheqkxehiglrpad9isw FOREIGN KEY (crohoopleiding) REFERENCES public.taxonomieelement(id);


--
-- Name: verbintenis fk78ay4h0sd8a7yeb93jp6jmgye; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verbintenis
    ADD CONSTRAINT fk78ay4h0sd8a7yeb93jp6jmgye FOREIGN KEY (locatie) REFERENCES public.locatie(id);


--
-- Name: ondprodverbruiksmiddel fk7b0n7dxrcsjd0x2u28hl2x776; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ondprodverbruiksmiddel
    ADD CONSTRAINT fk7b0n7dxrcsjd0x2u28hl2x776 FOREIGN KEY (onderwijsproduct) REFERENCES public.onderwijsproduct(id);


--
-- Name: niettoneninzorgvierkant fk7dh1b72rs31uftkfd8oaf0f5i; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.niettoneninzorgvierkant
    ADD CONSTRAINT fk7dh1b72rs31uftkfd8oaf0f5i FOREIGN KEY (test) REFERENCES public.deelnemertest(id);


--
-- Name: bpvinschrijving fk7dvvylvmwx6r7wkrh8k4ytpxx; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvinschrijving
    ADD CONSTRAINT fk7dvvylvmwx6r7wkrh8k4ytpxx FOREIGN KEY (bedrijfsgegeven) REFERENCES public.bpvbedrijfsgegeven(id);


--
-- Name: medewerkerkenmerk fk7fb1ctcptvp7ayrp4ssklqoa0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medewerkerkenmerk
    ADD CONSTRAINT fk7fb1ctcptvp7ayrp4ssklqoa0 FOREIGN KEY (kenmerk) REFERENCES public.kenmerk(id);


--
-- Name: groep fk7i2p274451pjrfgvokgn2wmc1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groep
    ADD CONSTRAINT fk7i2p274451pjrfgvokgn2wmc1 FOREIGN KEY (medewerker) REFERENCES public.medewerker(id);


--
-- Name: absentiemelding fk7imbj4w4u1cshulep456hm14w; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.absentiemelding
    ADD CONSTRAINT fk7imbj4w4u1cshulep456hm14w FOREIGN KEY (absentiereden) REFERENCES public.absentiereden(id);


--
-- Name: bpvbedrijfsgegeven fk7l01h3ot2fd1eoa3fohrwbf19; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvbedrijfsgegeven
    ADD CONSTRAINT fk7l01h3ot2fd1eoa3fohrwbf19 FOREIGN KEY (brin) REFERENCES public.externeorganisatie(id);


--
-- Name: deelnemerpersoonlijkegroep fk7mdb6sh90vkpoqi02yy7m2iv3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deelnemerpersoonlijkegroep
    ADD CONSTRAINT fk7mdb6sh90vkpoqi02yy7m2iv3 FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: basisrooster fk7ok0bihweqojrklagh82ciqm9; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.basisrooster
    ADD CONSTRAINT fk7ok0bihweqojrklagh82ciqm9 FOREIGN KEY (organisatieeenheid) REFERENCES public.organisatieeenheid(id);


--
-- Name: rapportagetemplate fk7rko19qkb1k710bjue8cp14c5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rapportagetemplate
    ADD CONSTRAINT fk7rko19qkb1k710bjue8cp14c5 FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: vrijveldentiteit fk7rq1a27oadcqjutgqwayk1p76; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vrijveldentiteit
    ADD CONSTRAINT fk7rq1a27oadcqjutgqwayk1p76 FOREIGN KEY (medewerker) REFERENCES public.medewerker(id);


--
-- Name: bpvinschrijving fk7webor69ld645bramk27aq8w1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvinschrijving
    ADD CONSTRAINT fk7webor69ld645bramk27aq8w1 FOREIGN KEY (praktijkbegeleider) REFERENCES public.medewerker(id);


--
-- Name: groepresultaatfilterinst fk81q9vxb6qhynrdp4cfwdte9jl; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groepresultaatfilterinst
    ADD CONSTRAINT fk81q9vxb6qhynrdp4cfwdte9jl FOREIGN KEY (filterinstelling) REFERENCES public.resultaatzoekfilterinstelling(id);


--
-- Name: vooropleiding fk81ujg55an6k6e9i68wgy56xx8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vooropleiding
    ADD CONSTRAINT fk81ujg55an6k6e9i68wgy56xx8 FOREIGN KEY (soortvooropleidingho) REFERENCES public.soortvooropleidingho(id);


--
-- Name: intakegesprek fk82g0fgm6e6udkqvd6pmtew62h; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intakegesprek
    ADD CONSTRAINT fk82g0fgm6e6udkqvd6pmtew62h FOREIGN KEY (locatie) REFERENCES public.locatie(id);


--
-- Name: toegestaanhulpmiddel fk88smo1tnqunk2h0v34eid9d1j; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toegestaanhulpmiddel
    ADD CONSTRAINT fk88smo1tnqunk2h0v34eid9d1j FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: soortexterneorganisatie fk8cuuksn8o7ubff0akc30itvye; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.soortexterneorganisatie
    ADD CONSTRAINT fk8cuuksn8o7ubff0akc30itvye FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: sessie fk8dkvqonnilk95a2osq8fs4ywu; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessie
    ADD CONSTRAINT fk8dkvqonnilk95a2osq8fs4ywu FOREIGN KEY (account) REFERENCES public.account(id);


--
-- Name: toegexamenstatusovergang fk8du4vh3sfg5lq04efw1qh9ugg; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toegexamenstatusovergang
    ADD CONSTRAINT fk8du4vh3sfg5lq04efw1qh9ugg FOREIGN KEY (examenworkflow) REFERENCES public.examenworkflow(id);


--
-- Name: studielinkbericht fk8engm09vi25bmxo8ls0dw8cfd; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.studielinkbericht
    ADD CONSTRAINT fk8engm09vi25bmxo8ls0dw8cfd FOREIGN KEY (deelnemer) REFERENCES public.deelnemer(id);


--
-- Name: soortproductregel fk8fa6acbij9hmluio33infhqol; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.soortproductregel
    ADD CONSTRAINT fk8fa6acbij9hmluio33infhqol FOREIGN KEY (taxonomie) REFERENCES public.taxonomieelement(id);


--
-- Name: resultaat fk8fbf8kpe9m0ifq2wsha0hmqi8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resultaat
    ADD CONSTRAINT fk8fbf8kpe9m0ifq2wsha0hmqi8 FOREIGN KEY (ingevoerddoor) REFERENCES public.medewerker(id);


--
-- Name: afspraaktype fk8jbtdmemtainm2i0cxpcxq1yt; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.afspraaktype
    ADD CONSTRAINT fk8jbtdmemtainm2i0cxpcxq1yt FOREIGN KEY (locatie) REFERENCES public.locatie(id);


--
-- Name: rapportagetemplate fk8mbc0vpjjto2a1juw1ismflyw; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rapportagetemplate
    ADD CONSTRAINT fk8mbc0vpjjto2a1juw1ismflyw FOREIGN KEY (samenvoegenpdfconfig) REFERENCES public.samenvoegenpdfconfig(id);


--
-- Name: onderwijsproductaanbodperiode fk8mrjlrmujblf1nmm3ujg68diy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproductaanbodperiode
    ADD CONSTRAINT fk8mrjlrmujblf1nmm3ujg68diy FOREIGN KEY (aanbodperiode) REFERENCES public.aanbodperiode(id);


--
-- Name: taalscore fk8re0fo8cn6xontv2tpk213fw; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taalscore
    ADD CONSTRAINT fk8re0fo8cn6xontv2tpk213fw FOREIGN KEY (meeteenheidwaarde) REFERENCES public.meeteenheidwaarde(id);


--
-- Name: competentieniveauverzameling fk8rg74m2kbmkjq7b3dd9sg6obm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.competentieniveauverzameling
    ADD CONSTRAINT fk8rg74m2kbmkjq7b3dd9sg6obm FOREIGN KEY (opleiding) REFERENCES public.opleiding(id);


--
-- Name: onderwijsproductzoekterm fk8uxa44hh3vpfo2ne89uyqih2v; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproductzoekterm
    ADD CONSTRAINT fk8uxa44hh3vpfo2ne89uyqih2v FOREIGN KEY (onderwijsproduct) REFERENCES public.onderwijsproduct(id);


--
-- Name: examendeelname fk8wg69l3kvydw9gbdckmrdcolr; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.examendeelname
    ADD CONSTRAINT fk8wg69l3kvydw9gbdckmrdcolr FOREIGN KEY (examenstatus) REFERENCES public.examenstatus(id);


--
-- Name: competentieniveau fk9124ey3957dkeefmtqdldi2wg; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.competentieniveau
    ADD CONSTRAINT fk9124ey3957dkeefmtqdldi2wg FOREIGN KEY (leerpunt) REFERENCES public.taxonomieelement(id);


--
-- Name: olcwaarneming fk9142vi24ougdmqy51qct2cclk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.olcwaarneming
    ADD CONSTRAINT fk9142vi24ougdmqy51qct2cclk FOREIGN KEY (deelnemer) REFERENCES public.deelnemer(id);


--
-- Name: resultaatstructuur fk956qcq3srmn7yi7mn58c2g9b; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resultaatstructuur
    ADD CONSTRAINT fk956qcq3srmn7yi7mn58c2g9b FOREIGN KEY (eindresultaat) REFERENCES public.toets(id);


--
-- Name: absentiereden fk958rdkwmybwpyjlmt5n78yld9; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.absentiereden
    ADD CONSTRAINT fk958rdkwmybwpyjlmt5n78yld9 FOREIGN KEY (organisatieeenheid) REFERENCES public.organisatieeenheid(id);


--
-- Name: groepdocent fk96nkvn8wgh525q18843v0ibpg; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groepdocent
    ADD CONSTRAINT fk96nkvn8wgh525q18843v0ibpg FOREIGN KEY (groep) REFERENCES public.groep(id);


--
-- Name: vrijveldentiteit fk97kef9rer3tjqa76o7xai3473; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vrijveldentiteit
    ADD CONSTRAINT fk97kef9rer3tjqa76o7xai3473 FOREIGN KEY (contract) REFERENCES public.contract(id);


--
-- Name: vrijveldentiteit fk9ae67yuvb8s55xdjwkrext4bo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vrijveldentiteit
    ADD CONSTRAINT fk9ae67yuvb8s55xdjwkrext4bo FOREIGN KEY (groep) REFERENCES public.groep(id);


--
-- Name: bpvinschrijving fk9c92eg1qts24y4fram6pyyhp7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvinschrijving
    ADD CONSTRAINT fk9c92eg1qts24y4fram6pyyhp7 FOREIGN KEY (contactpersooncontractpartner) REFERENCES public.extorgcontactpersoon(id);


--
-- Name: bookmark fk9cij82asgo1hhnrcc25lyuw0b; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookmark
    ADD CONSTRAINT fk9cij82asgo1hhnrcc25lyuw0b FOREIGN KEY (bookmarkfolder) REFERENCES public.bookmarkfolder(id);


--
-- Name: groepdocent fk9dbsucqials27ttnf0whnlfoj; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groepdocent
    ADD CONSTRAINT fk9dbsucqials27ttnf0whnlfoj FOREIGN KEY (medewerker) REFERENCES public.medewerker(id);


--
-- Name: taaltypekoppel fk9h7073x9r61r1lq8kygs24frj; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taaltypekoppel
    ADD CONSTRAINT fk9h7073x9r61r1lq8kygs24frj FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: taalkeuze fk9ip4uguln79svcsr3l8bk26sc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taalkeuze
    ADD CONSTRAINT fk9ip4uguln79svcsr3l8bk26sc FOREIGN KEY (taal) REFERENCES public.modernetaal(id);


--
-- Name: vooropleiding fk9ivawk57719win6957fu7h9mj; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vooropleiding
    ADD CONSTRAINT fk9ivawk57719win6957fu7h9mj FOREIGN KEY (verificatiebrin) REFERENCES public.externeorganisatie(id);


--
-- Name: competentieniveauverzameling fk9iytegtlhv7p21wfwvicda3fj; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.competentieniveauverzameling
    ADD CONSTRAINT fk9iytegtlhv7p21wfwvicda3fj FOREIGN KEY (groepsbeoordeling) REFERENCES public.competentieniveauverzameling(id);


--
-- Name: persooncontactgegeven fk9kr9hlcfvol8jh7hh8lftgn7b; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persooncontactgegeven
    ADD CONSTRAINT fk9kr9hlcfvol8jh7hh8lftgn7b FOREIGN KEY (persoon) REFERENCES public.persoon(id);


--
-- Name: verbinteniscontract fk9kupnwreua5yug0hl8mm54eik; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verbinteniscontract
    ADD CONSTRAINT fk9kupnwreua5yug0hl8mm54eik FOREIGN KEY (extorgcontactpersoon) REFERENCES public.extorgcontactpersoon(id);


--
-- Name: hulpmiddel fk9lqp2h73cgeoqa4dgpn1s3nle; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hulpmiddel
    ADD CONSTRAINT fk9lqp2h73cgeoqa4dgpn1s3nle FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: afspraaktype fk9n2le1tpn86uu70uf7q7ganh4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.afspraaktype
    ADD CONSTRAINT fk9n2le1tpn86uu70uf7q7ganh4 FOREIGN KEY (organisatieeenheid) REFERENCES public.organisatieeenheid(id);


--
-- Name: irisincidentvoorwerp fk9pgh6uh72km2j3yoxqwnq851c; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.irisincidentvoorwerp
    ADD CONSTRAINT fk9pgh6uh72km2j3yoxqwnq851c FOREIGN KEY (incident) REFERENCES public.irisincident(id);


--
-- Name: rapportagetemplate fk9tb5y7wu9r2dlqnrts43fi4gf; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rapportagetemplate
    ADD CONSTRAINT fk9tb5y7wu9r2dlqnrts43fi4gf FOREIGN KEY (samenvoegenhtml) REFERENCES public.samenvoegenhtmlconfig(id);


--
-- Name: vooropleidingvakresultaat fk9tn52r0vpnsqt1u65uve51dj7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vooropleidingvakresultaat
    ADD CONSTRAINT fk9tn52r0vpnsqt1u65uve51dj7 FOREIGN KEY (vak) REFERENCES public.vooropleidingvak(id);


--
-- Name: verbintenis fk9vol3n8plj3mu192y6e59snle; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verbintenis
    ADD CONSTRAINT fk9vol3n8plj3mu192y6e59snle FOREIGN KEY (vervolgonderwijs) REFERENCES public.vervolgonderwijs(id);


--
-- Name: plaats fk9vrg798qcsndocpc2ph9hcsks; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plaats
    ADD CONSTRAINT fk9vrg798qcsndocpc2ph9hcsks FOREIGN KEY (provincie) REFERENCES public.provincie(id);


--
-- Name: taxonomieelement fk9y7edukanls4l9qo7mnj885xs; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxonomieelement
    ADD CONSTRAINT fk9y7edukanls4l9qo7mnj885xs FOREIGN KEY (taxonomieelementtype) REFERENCES public.taxonomieelementtype(id);


--
-- Name: aanleiding fk_aanleiding_beghand; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aanleiding
    ADD CONSTRAINT fk_aanleiding_beghand FOREIGN KEY (begeleidingshandeling) REFERENCES public.begeleidingshandeling(id);


--
-- Name: aanleiding fk_aanleiding_bijzheid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aanleiding
    ADD CONSTRAINT fk_aanleiding_bijzheid FOREIGN KEY (bijzonderheid) REFERENCES public.bijzonderheid(id);


--
-- Name: aanleiding fk_aanleiding_incident; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aanleiding
    ADD CONSTRAINT fk_aanleiding_incident FOREIGN KEY (incident) REFERENCES public.incident(id);


--
-- Name: aanleiding fk_aanleiding_notitie; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aanleiding
    ADD CONSTRAINT fk_aanleiding_notitie FOREIGN KEY (notitie) REFERENCES public.notitie(id);


--
-- Name: aanleiding fk_aanleiding_test; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aanleiding
    ADD CONSTRAINT fk_aanleiding_test FOREIGN KEY (deelnemertest) REFERENCES public.deelnemertest(id);


--
-- Name: aanleiding fk_aanleiding_traject; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aanleiding
    ADD CONSTRAINT fk_aanleiding_traject FOREIGN KEY (traject) REFERENCES public.traject(id);


--
-- Name: aanleidingtemplate fk_aanltempl_categorie; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aanleidingtemplate
    ADD CONSTRAINT fk_aanltempl_categorie FOREIGN KEY (bijzonderheidcategorie) REFERENCES public.bijzonderheidcategorie(id);


--
-- Name: aanleidingtemplate fk_aanltempl_testdefinitie; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aanleidingtemplate
    ADD CONSTRAINT fk_aanltempl_testdefinitie FOREIGN KEY (testdefinitie) REFERENCES public.testdefinitie(id);


--
-- Name: aanleidingtemplate fk_aanltempl_trajecttemplate; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aanleidingtemplate
    ADD CONSTRAINT fk_aanltempl_trajecttemplate FOREIGN KEY (trajecttemplate) REFERENCES public.trajecttemplate(id);


--
-- Name: aanwezigentemplate fk_aanwetempl_handtempl; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aanwezigentemplate
    ADD CONSTRAINT fk_aanwetempl_handtempl FOREIGN KEY (handelingtemplate) REFERENCES public.begeleidingshandelingtemplate(id);


--
-- Name: aanwezigentemplate fk_aanwetempl_persoon; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aanwezigentemplate
    ADD CONSTRAINT fk_aanwetempl_persoon FOREIGN KEY (persoon) REFERENCES public.persoon(id);


--
-- Name: begeleidingshandeling fk_beghand_eig; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.begeleidingshandeling
    ADD CONSTRAINT fk_beghand_eig FOREIGN KEY (eigenaar) REFERENCES public.medewerker(id);


--
-- Name: begeleidingshandeling fk_beghand_toeg; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.begeleidingshandeling
    ADD CONSTRAINT fk_beghand_toeg FOREIGN KEY (verantwoordelijke) REFERENCES public.medewerker(id);


--
-- Name: begeleidingshandeling fk_beghand_traject; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.begeleidingshandeling
    ADD CONSTRAINT fk_beghand_traject FOREIGN KEY (traject) REFERENCES public.traject(id);


--
-- Name: begeleidingshandelingtemplate fk_beghandtemp_planning; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.begeleidingshandelingtemplate
    ADD CONSTRAINT fk_beghandtemp_planning FOREIGN KEY (planning) REFERENCES public.planningtemplate(id);


--
-- Name: beghandstatovrgang fk_bhstatus_beghand; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.beghandstatovrgang
    ADD CONSTRAINT fk_bhstatus_beghand FOREIGN KEY (begeleidingshandeling) REFERENCES public.begeleidingshandeling(id);


--
-- Name: beghandstatovrgang fk_bhstatus_medewerker; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.beghandstatovrgang
    ADD CONSTRAINT fk_bhstatus_medewerker FOREIGN KEY (medewerker) REFERENCES public.medewerker(id);


--
-- Name: toegekendhulpmiddel fk_bijzonder_toegekhulpm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toegekendhulpmiddel
    ADD CONSTRAINT fk_bijzonder_toegekhulpm FOREIGN KEY (bijzonderheid) REFERENCES public.bijzonderheid(id);


--
-- Name: toegestaanhulpmiddel fk_categbijz_toegesthulpm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toegestaanhulpmiddel
    ADD CONSTRAINT fk_categbijz_toegesthulpm FOREIGN KEY (bijzonderheidcategorie) REFERENCES public.bijzonderheidcategorie(id);


--
-- Name: deelnemertest fk_deelnemertest_deelnemer; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deelnemertest
    ADD CONSTRAINT fk_deelnemertest_deelnemer FOREIGN KEY (deelnemer) REFERENCES public.deelnemer(id);


--
-- Name: deelnemertest fk_deelnemertest_groeptest; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deelnemertest
    ADD CONSTRAINT fk_deelnemertest_groeptest FOREIGN KEY (groeptest) REFERENCES public.groeptest(id);


--
-- Name: deelnemertest fk_deelnemertest_testdef; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deelnemertest
    ADD CONSTRAINT fk_deelnemertest_testdef FOREIGN KEY (testdefinitie) REFERENCES public.testdefinitie(id);


--
-- Name: begeleidingshandelingtemplate fk_eigetempl_eigenaar; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.begeleidingshandelingtemplate
    ADD CONSTRAINT fk_eigetempl_eigenaar FOREIGN KEY (eigenaar) REFERENCES public.eigenaartemplate(id);


--
-- Name: eigenaartemplate fk_eigetempl_persoon; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eigenaartemplate
    ADD CONSTRAINT fk_eigetempl_persoon FOREIGN KEY (persoon) REFERENCES public.persoon(id);


--
-- Name: begeleidingshandelingtemplate fk_eigetempl_toegekendaan; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.begeleidingshandelingtemplate
    ADD CONSTRAINT fk_eigetempl_toegekendaan FOREIGN KEY (toegekendaan) REFERENCES public.eigenaartemplate(id);


--
-- Name: begeleidingshandeling fk_gesprek_soort; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.begeleidingshandeling
    ADD CONSTRAINT fk_gesprek_soort FOREIGN KEY (gespreksoort) REFERENCES public.gespreksoort(id);


--
-- Name: begeleidingshandelingtemplate fk_gesprektempl_soort; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.begeleidingshandelingtemplate
    ADD CONSTRAINT fk_gesprektempl_soort FOREIGN KEY (gespreksoort) REFERENCES public.gespreksoort(id);


--
-- Name: groeptest fk_groeptest_groep; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groeptest
    ADD CONSTRAINT fk_groeptest_groep FOREIGN KEY (groep) REFERENCES public.groep(id);


--
-- Name: groeptest fk_groeptest_testdef; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groeptest
    ADD CONSTRAINT fk_groeptest_testdef FOREIGN KEY (testdefinitie) REFERENCES public.testdefinitie(id);


--
-- Name: begeleidingshandeling fk_handeling_afspraak; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.begeleidingshandeling
    ADD CONSTRAINT fk_handeling_afspraak FOREIGN KEY (afspraak) REFERENCES public.afspraak(id);


--
-- Name: toegekendhulpmiddel fk_hulpmiddel_toegekhulpm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toegekendhulpmiddel
    ADD CONSTRAINT fk_hulpmiddel_toegekhulpm FOREIGN KEY (hulpmiddel) REFERENCES public.hulpmiddel(id);


--
-- Name: toegestaanhulpmiddel fk_hulpmiddel_toegesthulpm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toegestaanhulpmiddel
    ADD CONSTRAINT fk_hulpmiddel_toegesthulpm FOREIGN KEY (hulpmiddel) REFERENCES public.hulpmiddel(id);


--
-- Name: trajecttemplatekoppeling fk_koppkencat_kenm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trajecttemplatekoppeling
    ADD CONSTRAINT fk_koppkencat_kenm FOREIGN KEY (kenmerk) REFERENCES public.kenmerk(id);


--
-- Name: trajecttemplatekoppeling fk_koppopl_opl; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trajecttemplatekoppeling
    ADD CONSTRAINT fk_koppopl_opl FOREIGN KEY (opleiding) REFERENCES public.opleiding(id);


--
-- Name: trajecttemplatekoppeling fk_kopporgeenh_orgeenh; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trajecttemplatekoppeling
    ADD CONSTRAINT fk_kopporgeenh_orgeenh FOREIGN KEY (organisatieeenheid) REFERENCES public.organisatieeenheid(id);


--
-- Name: begeleidingshandeling fk_taak_soort; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.begeleidingshandeling
    ADD CONSTRAINT fk_taak_soort FOREIGN KEY (taaksoort) REFERENCES public.taaksoort(id);


--
-- Name: begeleidingshandelingtemplate fk_taaktempl_soort; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.begeleidingshandelingtemplate
    ADD CONSTRAINT fk_taaktempl_soort FOREIGN KEY (taaksoort) REFERENCES public.taaksoort(id);


--
-- Name: begeleidingshandeling fk_testafname_deelnemertest; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.begeleidingshandeling
    ADD CONSTRAINT fk_testafname_deelnemertest FOREIGN KEY (deelnemertest) REFERENCES public.deelnemertest(id);


--
-- Name: begeleidingshandeling fk_testafname_definitie; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.begeleidingshandeling
    ADD CONSTRAINT fk_testafname_definitie FOREIGN KEY (testdefinitie) REFERENCES public.testdefinitie(id);


--
-- Name: begeleidingshandelingtemplate fk_testafntempl_soort; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.begeleidingshandelingtemplate
    ADD CONSTRAINT fk_testafntempl_soort FOREIGN KEY (testdefinitie) REFERENCES public.testdefinitie(id);


--
-- Name: bijlageentiteit fk_testbijlage_test; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bijlageentiteit
    ADD CONSTRAINT fk_testbijlage_test FOREIGN KEY (test) REFERENCES public.deelnemertest(id);


--
-- Name: bijlageentiteit fk_testbijlage_traject; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bijlageentiteit
    ADD CONSTRAINT fk_testbijlage_traject FOREIGN KEY (traject) REFERENCES public.traject(id);


--
-- Name: testdefinitie fk_testdefinitie_categorie; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.testdefinitie
    ADD CONSTRAINT fk_testdefinitie_categorie FOREIGN KEY (categorie) REFERENCES public.testcategorie(id);


--
-- Name: toegestanestatussoort fk_toegss_trajstsrt; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toegestanestatussoort
    ADD CONSTRAINT fk_toegss_trajstsrt FOREIGN KEY (trajectstatussoort) REFERENCES public.trajectstatussoort(id);


--
-- Name: toegestanestatussoort fk_toegstatsrt_trajsrt; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toegestanestatussoort
    ADD CONSTRAINT fk_toegstatsrt_trajsrt FOREIGN KEY (trajectsoort) REFERENCES public.trajectsoort(id);


--
-- Name: traject fk_traject_deelnemer; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traject
    ADD CONSTRAINT fk_traject_deelnemer FOREIGN KEY (deelnemer) REFERENCES public.deelnemer(id);


--
-- Name: traject fk_traject_soort; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traject
    ADD CONSTRAINT fk_traject_soort FOREIGN KEY (trajectsoort) REFERENCES public.trajectsoort(id);


--
-- Name: traject fk_traject_template; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traject
    ADD CONSTRAINT fk_traject_template FOREIGN KEY (template) REFERENCES public.trajecttemplate(id);


--
-- Name: traject fk_traject_trajssrt; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traject
    ADD CONSTRAINT fk_traject_trajssrt FOREIGN KEY (trajectstatussoort) REFERENCES public.trajectstatussoort(id);


--
-- Name: traject fk_traject_verantw; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traject
    ADD CONSTRAINT fk_traject_verantw FOREIGN KEY (verantwoordelijke) REFERENCES public.medewerker(id);


--
-- Name: traject fk_traject_verbintenis; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traject
    ADD CONSTRAINT fk_traject_verbintenis FOREIGN KEY (verbintenis) REFERENCES public.verbintenis(id);


--
-- Name: trajectbeghandelingtemplate fk_trajectbeght_handeling; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trajectbeghandelingtemplate
    ADD CONSTRAINT fk_trajectbeght_handeling FOREIGN KEY (begeleidingshandeling) REFERENCES public.begeleidingshandelingtemplate(id);


--
-- Name: trajectbeghandelingtemplate fk_trajectbeght_traject; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trajectbeghandelingtemplate
    ADD CONSTRAINT fk_trajectbeght_traject FOREIGN KEY (trajecttemplate) REFERENCES public.trajecttemplate(id);


--
-- Name: trajectstatusovergang fk_trajstato_medewerker; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trajectstatusovergang
    ADD CONSTRAINT fk_trajstato_medewerker FOREIGN KEY (medewerker) REFERENCES public.medewerker(id);


--
-- Name: trajectstatusovergang fk_trajstato_naar; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trajectstatusovergang
    ADD CONSTRAINT fk_trajstato_naar FOREIGN KEY (naarstatus) REFERENCES public.trajectstatussoort(id);


--
-- Name: trajectstatusovergang fk_trajstato_traject; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trajectstatusovergang
    ADD CONSTRAINT fk_trajstato_traject FOREIGN KEY (traject) REFERENCES public.traject(id);


--
-- Name: trajectstatusovergang fk_trajstato_van; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trajectstatusovergang
    ADD CONSTRAINT fk_trajstato_van FOREIGN KEY (vanstatus) REFERENCES public.trajectstatussoort(id);


--
-- Name: trajecttemplate fk_trajtempl_soort; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trajecttemplate
    ADD CONSTRAINT fk_trajtempl_soort FOREIGN KEY (trajectsoort) REFERENCES public.trajectsoort(id);


--
-- Name: trajecttemplatekoppeling fk_trajtemplkopp_ttautokopp; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trajecttemplatekoppeling
    ADD CONSTRAINT fk_trajtemplkopp_ttautokopp FOREIGN KEY (trajtemplautokopp) REFERENCES public.trajtemplautokopp(id);


--
-- Name: trajectuitvoerder fk_trajuitv_medew; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trajectuitvoerder
    ADD CONSTRAINT fk_trajuitv_medew FOREIGN KEY (medewerker) REFERENCES public.medewerker(id);


--
-- Name: trajectuitvoerder fk_trajuitv_traj; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trajectuitvoerder
    ADD CONSTRAINT fk_trajuitv_traj FOREIGN KEY (traject) REFERENCES public.traject(id);


--
-- Name: gekoppeldetemplate fk_uitvoertempl_medewerker; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gekoppeldetemplate
    ADD CONSTRAINT fk_uitvoertempl_medewerker FOREIGN KEY (medewerker) REFERENCES public.medewerker(id);


--
-- Name: gekoppeldetemplate fk_uitvoertempl_rol; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gekoppeldetemplate
    ADD CONSTRAINT fk_uitvoertempl_rol FOREIGN KEY (rol) REFERENCES public.rol(id);


--
-- Name: gekoppeldetemplate fk_uitvoertempl_templ; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gekoppeldetemplate
    ADD CONSTRAINT fk_uitvoertempl_templ FOREIGN KEY (trajecttemplate) REFERENCES public.trajecttemplate(id);


--
-- Name: veldwaarde fk_veldwaarde_test; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.veldwaarde
    ADD CONSTRAINT fk_veldwaarde_test FOREIGN KEY (test) REFERENCES public.deelnemertest(id);


--
-- Name: veldwaarde fk_veldwaarde_testveld; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.veldwaarde
    ADD CONSTRAINT fk_veldwaarde_testveld FOREIGN KEY (testveld) REFERENCES public.testveld(id);


--
-- Name: vervolghandeling fk_vervhand_vervolg; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vervolghandeling
    ADD CONSTRAINT fk_vervhand_vervolg FOREIGN KEY (vervolg) REFERENCES public.begeleidingshandeling(id);


--
-- Name: vervolghandeling fk_vervhand_vooraf; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vervolghandeling
    ADD CONSTRAINT fk_vervhand_vooraf FOREIGN KEY (voorafgaand) REFERENCES public.begeleidingshandeling(id);


--
-- Name: moduleafname fka3yhmm0wqv3s7iivonpbnn505; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moduleafname
    ADD CONSTRAINT fka3yhmm0wqv3s7iivonpbnn505 FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: organisatieeenheidlocatie fka7175kd7y72sd047nq0qqgd7d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisatieeenheidlocatie
    ADD CONSTRAINT fka7175kd7y72sd047nq0qqgd7d FOREIGN KEY (locatie) REFERENCES public.locatie(id);


--
-- Name: deelnemermatrix fka96mdseb6enhp2esvda30t4j1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deelnemermatrix
    ADD CONSTRAINT fka96mdseb6enhp2esvda30t4j1 FOREIGN KEY (matrix) REFERENCES public.taxonomieelement(id);


--
-- Name: curriculumonderwijsproduct fkab20cvm42p585ych80mkuar4q; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.curriculumonderwijsproduct
    ADD CONSTRAINT fkab20cvm42p585ych80mkuar4q FOREIGN KEY (curriculum) REFERENCES public.curriculum(id);


--
-- Name: examenstatusovergang fkaegprra667d7lrtdyl6q6chll; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.examenstatusovergang
    ADD CONSTRAINT fkaegprra667d7lrtdyl6q6chll FOREIGN KEY (naarstatus) REFERENCES public.examenstatus(id);


--
-- Name: organisatieeenheid fkaf1jdk0c8161o9c5m20597t58; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisatieeenheid
    ADD CONSTRAINT fkaf1jdk0c8161o9c5m20597t58 FOREIGN KEY (parent) REFERENCES public.organisatieeenheid(id);


--
-- Name: toegestanebeginstatus fkag04l0kfe45ck442xqf40ppp3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toegestanebeginstatus
    ADD CONSTRAINT fkag04l0kfe45ck442xqf40ppp3 FOREIGN KEY (examenstatus) REFERENCES public.examenstatus(id);


--
-- Name: lesweekindelingorgloc fkag41mscyhhmkvq8ssdrsiefpc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesweekindelingorgloc
    ADD CONSTRAINT fkag41mscyhhmkvq8ssdrsiefpc FOREIGN KEY (organisatieeenheid) REFERENCES public.organisatieeenheid(id);


--
-- Name: externeagendakoppeling fkaihcf49o4esu0hnkwbsqkbd6x; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.externeagendakoppeling
    ADD CONSTRAINT fkaihcf49o4esu0hnkwbsqkbd6x FOREIGN KEY (locatie_id) REFERENCES public.locatie(id);


--
-- Name: resultaatstructuurmedewerker fkaksyb18a1fedswshs275rw4px; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resultaatstructuurmedewerker
    ADD CONSTRAINT fkaksyb18a1fedswshs275rw4px FOREIGN KEY (resultaatstructuur) REFERENCES public.resultaatstructuur(id);


--
-- Name: irisincident fkam8y325hb5stncjul8ch4tc2p; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.irisincident
    ADD CONSTRAINT fkam8y325hb5stncjul8ch4tc2p FOREIGN KEY (auteur) REFERENCES public.medewerker(id);


--
-- Name: tekenbevoegdheid fkanmtynlnlu25p21li3dbkckwf; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tekenbevoegdheid
    ADD CONSTRAINT fkanmtynlnlu25p21li3dbkckwf FOREIGN KEY (medewerker) REFERENCES public.medewerker(id);


--
-- Name: groepmentor fkas09y3wi654t0blqw99635ep6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groepmentor
    ADD CONSTRAINT fkas09y3wi654t0blqw99635ep6 FOREIGN KEY (medewerker) REFERENCES public.medewerker(id);


--
-- Name: competentieniveau fkas23oqo6v177nmnwff0mhu7qt; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.competentieniveau
    ADD CONSTRAINT fkas23oqo6v177nmnwff0mhu7qt FOREIGN KEY (niveauverzameling) REFERENCES public.competentieniveauverzameling(id);


--
-- Name: toegexamenstatusovergang fkat9njnv9cd23c95dyccno5d9d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toegexamenstatusovergang
    ADD CONSTRAINT fkat9njnv9cd23c95dyccno5d9d FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: inloopcollegeopleiding fkateyx4e1espo4e0nbyn274ef9; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inloopcollegeopleiding
    ADD CONSTRAINT fkateyx4e1espo4e0nbyn274ef9 FOREIGN KEY (opleiding) REFERENCES public.opleiding(id);


--
-- Name: taalscoreniveauverzameling fkauoe1ri18icckq18duklisu8f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taalscoreniveauverzameling
    ADD CONSTRAINT fkauoe1ri18icckq18duklisu8f FOREIGN KEY (taal) REFERENCES public.modernetaal(id);


--
-- Name: taxonomieelementtype fkaw9ntcv5r3k9sshxhq0cjhpkr; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxonomieelementtype
    ADD CONSTRAINT fkaw9ntcv5r3k9sshxhq0cjhpkr FOREIGN KEY (parent) REFERENCES public.taxonomieelementtype(id);


--
-- Name: bijzonderheid fkawy6oklvnu227fy5gp76r2do2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bijzonderheid
    ADD CONSTRAINT fkawy6oklvnu227fy5gp76r2do2 FOREIGN KEY (handelingsinstructies) REFERENCES public.bijlage(id);


--
-- Name: trajectsoort fkayxj1i26b27swkby6y88mkue5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trajectsoort
    ADD CONSTRAINT fkayxj1i26b27swkby6y88mkue5 FOREIGN KEY (organisatieeenheid) REFERENCES public.organisatieeenheid(id);


--
-- Name: fase fkb1d8jue7ubsgvg0gdc7xeju4m; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fase
    ADD CONSTRAINT fkb1d8jue7ubsgvg0gdc7xeju4m FOREIGN KEY (volgendefase) REFERENCES public.fase(id);


--
-- Name: onderwijsproductafname fkb4i5tu0g93wxq7i27tc23lnic; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproductafname
    ADD CONSTRAINT fkb4i5tu0g93wxq7i27tc23lnic FOREIGN KEY (externeorganisatie) REFERENCES public.externeorganisatie(id);


--
-- Name: organisatiesetting fkb5gnns0m949apwehma4fibkt2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisatiesetting
    ADD CONSTRAINT fkb5gnns0m949apwehma4fibkt2 FOREIGN KEY (lesweekindeling) REFERENCES public.lesweekindeling(id);


--
-- Name: opleidingaanbod fkb5lysm0fvb0dw6fvtpcnqirdq; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.opleidingaanbod
    ADD CONSTRAINT fkb5lysm0fvb0dw6fvtpcnqirdq FOREIGN KEY (team) REFERENCES public.team(id);


--
-- Name: maatregeltoekenningsregel fkb8lr3wk6oi029s5hhap97oiwl; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maatregeltoekenningsregel
    ADD CONSTRAINT fkb8lr3wk6oi029s5hhap97oiwl FOREIGN KEY (locatie) REFERENCES public.locatie(id);


--
-- Name: verbintenis fkb97nbugp44e3kurieqtyhplkd; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verbintenis
    ADD CONSTRAINT fkb97nbugp44e3kurieqtyhplkd FOREIGN KEY (opleiding) REFERENCES public.opleiding(id);


--
-- Name: opleiding fkb9pyyi0xkueuv9eagx1afasro; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.opleiding
    ADD CONSTRAINT fkb9pyyi0xkueuv9eagx1afasro FOREIGN KEY (verbintenisgebied) REFERENCES public.taxonomieelement(id);


--
-- Name: organisatiesetting fkba2xtm81hi45wlrst3lwjxxbl; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisatiesetting
    ADD CONSTRAINT fkba2xtm81hi45wlrst3lwjxxbl FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: eventabonnementsetting fkba71cq30txy5tlv1qkj0jp41i; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eventabonnementsetting
    ADD CONSTRAINT fkba71cq30txy5tlv1qkj0jp41i FOREIGN KEY (configuratie) REFERENCES public.eventabonnementconfiguration(id);


--
-- Name: examenworkflowtax fkbctk705ollvbaf418axh2242b; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.examenworkflowtax
    ADD CONSTRAINT fkbctk705ollvbaf418axh2242b FOREIGN KEY (taxonomie) REFERENCES public.taxonomieelement(id);


--
-- Name: curriculum fkbfkvf3tmoilhve8ejykbteu71; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.curriculum
    ADD CONSTRAINT fkbfkvf3tmoilhve8ejykbteu71 FOREIGN KEY (organisatieeenheid) REFERENCES public.organisatieeenheid(id);


--
-- Name: locatie fkbgxe81yp9nkto7w5idihhidoi; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locatie
    ADD CONSTRAINT fkbgxe81yp9nkto7w5idihhidoi FOREIGN KEY (code) REFERENCES public.externeorganisatie(id);


--
-- Name: rapportagetemplate fkblxufbwq6oq9pahqu89ga81ts; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rapportagetemplate
    ADD CONSTRAINT fkblxufbwq6oq9pahqu89ga81ts FOREIGN KEY (medewerker) REFERENCES public.medewerker(id);


--
-- Name: opleiding fkbplst2ecvynbejoyl7p42rbej; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.opleiding
    ADD CONSTRAINT fkbplst2ecvynbejoyl7p42rbej FOREIGN KEY (parent) REFERENCES public.opleiding(id);


--
-- Name: accountrol fkbsgn4xodg4rhab9b43fv0ktr4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accountrol
    ADD CONSTRAINT fkbsgn4xodg4rhab9b43fv0ktr4 FOREIGN KEY (account) REFERENCES public.account(id);


--
-- Name: vrijveldentiteit fkbu55c3qtwmls0vw3rwb09fq8f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vrijveldentiteit
    ADD CONSTRAINT fkbu55c3qtwmls0vw3rwb09fq8f FOREIGN KEY (keuze) REFERENCES public.vrijveldkeuzeoptie(id);


--
-- Name: afspraakparticipant fkbuwwk3ratktqopxstwk8sg2ah; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.afspraakparticipant
    ADD CONSTRAINT fkbuwwk3ratktqopxstwk8sg2ah FOREIGN KEY (groep) REFERENCES public.groep(id);


--
-- Name: waarneming fkc3rgjkub2fr3ipbnr18o8ob5v; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.waarneming
    ADD CONSTRAINT fkc3rgjkub2fr3ipbnr18o8ob5v FOREIGN KEY (absentiemelding) REFERENCES public.absentiemelding(id);


--
-- Name: taxonomieelement fkc4cw3rft67o0c2y786cd97e41; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxonomieelement
    ADD CONSTRAINT fkc4cw3rft67o0c2y786cd97e41 FOREIGN KEY (lwootaxonomieelement) REFERENCES public.taxonomieelement(id);


--
-- Name: aanmelding fkc78tnyjjukkqx6k44xxax9ju6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aanmelding
    ADD CONSTRAINT fkc78tnyjjukkqx6k44xxax9ju6 FOREIGN KEY (intakegesprek) REFERENCES public.intakegesprek(id);


--
-- Name: taxonomieelement fkc92uu0i2gxlmebc6a12l9xqf5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxonomieelement
    ADD CONSTRAINT fkc92uu0i2gxlmebc6a12l9xqf5 FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: trajectsoort fkcat8bbs5j26ui4mwi2jc16ko4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trajectsoort
    ADD CONSTRAINT fkcat8bbs5j26ui4mwi2jc16ko4 FOREIGN KEY (defaultgespreksoort) REFERENCES public.gespreksoort(id);


--
-- Name: onderwijsproductvoorwaarde fkcbcj0drae2y51nmwl25kocgdy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproductvoorwaarde
    ADD CONSTRAINT fkcbcj0drae2y51nmwl25kocgdy FOREIGN KEY (voorwaardevoor) REFERENCES public.onderwijsproduct(id);


--
-- Name: bijlageentiteit fkcbngvontqr79b78q2yqini555; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bijlageentiteit
    ADD CONSTRAINT fkcbngvontqr79b78q2yqini555 FOREIGN KEY (incident) REFERENCES public.incident(id);


--
-- Name: account fkcdabu22endg8ckn2kb68u632y; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT fkcdabu22endg8ckn2kb68u632y FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: curriculum fkcgiiw42nyks8ta48yxt6hp722; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.curriculum
    ADD CONSTRAINT fkcgiiw42nyks8ta48yxt6hp722 FOREIGN KEY (cohort) REFERENCES public.cohort(id);


--
-- Name: vrijveldentiteit fkchvc429bw667n1f1pcfkn2k5t; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vrijveldentiteit
    ADD CONSTRAINT fkchvc429bw667n1f1pcfkn2k5t FOREIGN KEY (plaatsing) REFERENCES public.groepsdeelname(id);


--
-- Name: productregel fkci7i7dt43ks7x230hn5axe4y9; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productregel
    ADD CONSTRAINT fkci7i7dt43ks7x230hn5axe4y9 FOREIGN KEY (opleiding) REFERENCES public.opleiding(id);


--
-- Name: bpvinschrijving fkckpf66s932aw35iwenv0fou3c; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvinschrijving
    ADD CONSTRAINT fkckpf66s932aw35iwenv0fou3c FOREIGN KEY (contactpersoonbpvbedrijf) REFERENCES public.extorgcontactpersoon(id);


--
-- Name: adresentiteit fkcl12876keuqa7du8nfiahovx7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adresentiteit
    ADD CONSTRAINT fkcl12876keuqa7du8nfiahovx7 FOREIGN KEY (locatie) REFERENCES public.locatie(id);


--
-- Name: groepresultaatfilterinst fkcmux45b78q0dkn3ef9qcgfqpp; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groepresultaatfilterinst
    ADD CONSTRAINT fkcmux45b78q0dkn3ef9qcgfqpp FOREIGN KEY (onderwijsproduct) REFERENCES public.onderwijsproduct(id);


--
-- Name: onderwijsproduct fkcqcq381ea4wubgqm5t2ioq1tr; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproduct
    ADD CONSTRAINT fkcqcq381ea4wubgqm5t2ioq1tr FOREIGN KEY (niveauaanduiding) REFERENCES public.onderwijsproductniveau(id);


--
-- Name: orgehdcontactpersoon fkcrmp9yp6u93ju381seao5modp; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orgehdcontactpersoon
    ADD CONSTRAINT fkcrmp9yp6u93ju381seao5modp FOREIGN KEY (rol) REFERENCES public.extorgcontpersrol(id);


--
-- Name: afspraak fkctpadngk6i1vl8gds186m4bhg; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.afspraak
    ADD CONSTRAINT fkctpadngk6i1vl8gds186m4bhg FOREIGN KEY (cacheregion) REFERENCES public.cacheregion(id);


--
-- Name: verbintenis fkcx7p5mniudfykd1ffcbbm7797; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verbintenis
    ADD CONSTRAINT fkcx7p5mniudfykd1ffcbbm7797 FOREIGN KEY (brin) REFERENCES public.externeorganisatie(id);


--
-- Name: bpvkandidaat fkd05qmwtq770yrls5fiqlrngqo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvkandidaat
    ADD CONSTRAINT fkd05qmwtq770yrls5fiqlrngqo FOREIGN KEY (verbintenis) REFERENCES public.verbintenis(id);


--
-- Name: trajectsoort fkd0uj1ufmbnc7l973vvmkuu81k; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trajectsoort
    ADD CONSTRAINT fkd0uj1ufmbnc7l973vvmkuu81k FOREIGN KEY (defaulttaaksoort) REFERENCES public.taaksoort(id);


--
-- Name: bpvcriteriaexterneorganisatie fkd3utxqiddr9t9iqke1hbhcrr0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvcriteriaexterneorganisatie
    ADD CONSTRAINT fkd3utxqiddr9t9iqke1hbhcrr0 FOREIGN KEY (bpvcriteria) REFERENCES public.bpvcriteria(id);


--
-- Name: examenstatusovergang fkd5s36qfwqo520nj8othgi0e9i; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.examenstatusovergang
    ADD CONSTRAINT fkd5s36qfwqo520nj8othgi0e9i FOREIGN KEY (vanstatus) REFERENCES public.examenstatus(id);


--
-- Name: taalscore fkd73jswb8jbak44gc823a5i9u5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taalscore
    ADD CONSTRAINT fkd73jswb8jbak44gc823a5i9u5 FOREIGN KEY (taalbeoordeling) REFERENCES public.taalscoreniveauverzameling(id);


--
-- Name: onderwijsproductafname fkd7sxjag8ubecfxdao6uotksdv; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproductafname
    ADD CONSTRAINT fkd7sxjag8ubecfxdao6uotksdv FOREIGN KEY (cohort) REFERENCES public.cohort(id);


--
-- Name: soortvooropleidingbuitenlands fkd929yf2ye5a6pn4rjangbjpnp; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.soortvooropleidingbuitenlands
    ADD CONSTRAINT fkd929yf2ye5a6pn4rjangbjpnp FOREIGN KEY (land) REFERENCES public.land(id);


--
-- Name: afspraakparticipant fkd9cejor6ox0b0v0bqn422es62; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.afspraakparticipant
    ADD CONSTRAINT fkd9cejor6ox0b0v0bqn422es62 FOREIGN KEY (contract) REFERENCES public.contract(id);


--
-- Name: specifiekevraag fkdfaykd1gnj91cp3x4fnc5642y; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specifiekevraag
    ADD CONSTRAINT fkdfaykd1gnj91cp3x4fnc5642y FOREIGN KEY (inschrijvingsverzoek) REFERENCES public.inschrijvingsverzoek(id);


--
-- Name: medewerkerdeelnemerabonnering fkdhp93ab9wya6x188qm01e324w; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medewerkerdeelnemerabonnering
    ADD CONSTRAINT fkdhp93ab9wya6x188qm01e324w FOREIGN KEY (medewerker) REFERENCES public.medewerker(id);


--
-- Name: taalscoreniveauverzameling fkdibd0dqu92saxp7v6bxd2gw39; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taalscoreniveauverzameling
    ADD CONSTRAINT fkdibd0dqu92saxp7v6bxd2gw39 FOREIGN KEY (deelnemer) REFERENCES public.deelnemer(id);


--
-- Name: externeagendakoppeling fkdjdp3r1fvnu70mnd9aq8wyb5y; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.externeagendakoppeling
    ADD CONSTRAINT fkdjdp3r1fvnu70mnd9aq8wyb5y FOREIGN KEY (organisatieeenheid_id) REFERENCES public.organisatieeenheid(id);


--
-- Name: plaats fkdl25l4rs0etag8nicw48qeox1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.plaats
    ADD CONSTRAINT fkdl25l4rs0etag8nicw48qeox1 FOREIGN KEY (gemeente) REFERENCES public.gemeente(id);


--
-- Name: bijlageentiteit fkdn5hwu7farmj3svfpwsgtvo2k; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bijlageentiteit
    ADD CONSTRAINT fkdn5hwu7farmj3svfpwsgtvo2k FOREIGN KEY (bpvinschrijving) REFERENCES public.bpvinschrijving(id);


--
-- Name: toets fkdnh1rddcjcipq0q0l08k1qfo8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toets
    ADD CONSTRAINT fkdnh1rddcjcipq0q0l08k1qfo8 FOREIGN KEY (schaal) REFERENCES public.schaal(id);


--
-- Name: productregel fkdo3yww15em2pf420vuyj1c4fn; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productregel
    ADD CONSTRAINT fkdo3yww15em2pf420vuyj1c4fn FOREIGN KEY (verbintenisgebied) REFERENCES public.taxonomieelement(id);


--
-- Name: toegestaandeelgebied fkdoheue81vslf9n49almfe3n2x; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toegestaandeelgebied
    ADD CONSTRAINT fkdoheue81vslf9n49almfe3n2x FOREIGN KEY (productregel) REFERENCES public.productregel(id);


--
-- Name: adresentiteit fkdqts56o744bq0usp8goegohp2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adresentiteit
    ADD CONSTRAINT fkdqts56o744bq0usp8goegohp2 FOREIGN KEY (adres) REFERENCES public.adres(id);


--
-- Name: onderwijsproductaanbod fkdsams1123gw6dng9dtdtmxbqk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproductaanbod
    ADD CONSTRAINT fkdsams1123gw6dng9dtdtmxbqk FOREIGN KEY (locatie) REFERENCES public.locatie(id);


--
-- Name: intakegesprek fkdtimyrufmx431mk4v6hfoxur6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intakegesprek
    ADD CONSTRAINT fkdtimyrufmx431mk4v6hfoxur6 FOREIGN KEY (organisatieeenheid) REFERENCES public.organisatieeenheid(id);


--
-- Name: absentiemelding fkdwnhluwxaagrg60uelysdmxj0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.absentiemelding
    ADD CONSTRAINT fkdwnhluwxaagrg60uelysdmxj0 FOREIGN KEY (herhalendeabsentiemelding) REFERENCES public.herhalendeabsentiemelding(id);


--
-- Name: taxonomieelement fkdyt4eprgc110uwv0obal92ufl; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxonomieelement
    ADD CONSTRAINT fkdyt4eprgc110uwv0obal92ufl FOREIGN KEY (competentie) REFERENCES public.competentie(id);


--
-- Name: vrijveldentiteit fke2v6r53ombvp8qt38q05a8oq7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vrijveldentiteit
    ADD CONSTRAINT fke2v6r53ombvp8qt38q05a8oq7 FOREIGN KEY (vrijveld) REFERENCES public.vrijveld(id);


--
-- Name: vrijveldentiteit fkebsyf4ch7eh2xl2vm2ere6ghy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vrijveldentiteit
    ADD CONSTRAINT fkebsyf4ch7eh2xl2vm2ere6ghy FOREIGN KEY (bpvinschrijving) REFERENCES public.bpvinschrijving(id);


--
-- Name: persoon fkecii20iqx29dp16mit19iuuul; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persoon
    ADD CONSTRAINT fkecii20iqx29dp16mit19iuuul FOREIGN KEY (geboortelandouder1) REFERENCES public.land(id);


--
-- Name: bpvplaatsopleiding fkecmwxjemeeevdf4sffi2mba22; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvplaatsopleiding
    ADD CONSTRAINT fkecmwxjemeeevdf4sffi2mba22 FOREIGN KEY (opleiding) REFERENCES public.opleiding(id);


--
-- Name: maatregeltoekenningsregel fkee4dqd872doexsrcbmye2s13f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maatregeltoekenningsregel
    ADD CONSTRAINT fkee4dqd872doexsrcbmye2s13f FOREIGN KEY (absentiereden) REFERENCES public.absentiereden(id);


--
-- Name: accountrol fkeek8ygadwc6c1aomeh3k62w2y; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accountrol
    ADD CONSTRAINT fkeek8ygadwc6c1aomeh3k62w2y FOREIGN KEY (rol) REFERENCES public.rol(id);


--
-- Name: trajecttemplate fkegq5k2i0082re9xhgl7wl0kd7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trajecttemplate
    ADD CONSTRAINT fkegq5k2i0082re9xhgl7wl0kd7 FOREIGN KEY (automatischekoppeling) REFERENCES public.trajtemplautokopp(id);


--
-- Name: competentieniveau fkek2oqldyn9dws5gj7cyxrcxdk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.competentieniveau
    ADD CONSTRAINT fkek2oqldyn9dws5gj7cyxrcxdk FOREIGN KEY (score) REFERENCES public.meeteenheidwaarde(id);


--
-- Name: intakegesprek fken5xsj0lsumnj39ectwbkght6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intakegesprek
    ADD CONSTRAINT fken5xsj0lsumnj39ectwbkght6 FOREIGN KEY (intaker) REFERENCES public.medewerker(id);


--
-- Name: trajectsoort fkenevxu1kpynahoofkgor261lw; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trajectsoort
    ADD CONSTRAINT fkenevxu1kpynahoofkgor261lw FOREIGN KEY (locatie) REFERENCES public.locatie(id);


--
-- Name: toegestanebeginstatus fkeqkuoajbg9eu64j6ji188pghl; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toegestanebeginstatus
    ADD CONSTRAINT fkeqkuoajbg9eu64j6ji188pghl FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: competentiecomponent fkerh91cr6dfeg46g5jh926615r; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.competentiecomponent
    ADD CONSTRAINT fkerh91cr6dfeg46g5jh926615r FOREIGN KEY (competentie) REFERENCES public.competentie(id);


--
-- Name: irisbetrokkenemotief fkevhfnecnu4aolv9r93ndhiygq; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.irisbetrokkenemotief
    ADD CONSTRAINT fkevhfnecnu4aolv9r93ndhiygq FOREIGN KEY (betrokkene) REFERENCES public.irisbetrokkene(id);


--
-- Name: groep fkewck8gg4n530pjc7r3o8hr13a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groep
    ADD CONSTRAINT fkewck8gg4n530pjc7r3o8hr13a FOREIGN KEY (deelnemer) REFERENCES public.deelnemer(id);


--
-- Name: bpvcriteriaonderwijsproduct fkewh4s9ak5yn97cpt9w6viqhhx; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvcriteriaonderwijsproduct
    ADD CONSTRAINT fkewh4s9ak5yn97cpt9w6viqhhx FOREIGN KEY (onderwijsproduct) REFERENCES public.onderwijsproduct(id);


--
-- Name: bpvinschrijving fkexf6rqn89f1gwkkpu8b2l2cb7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvinschrijving
    ADD CONSTRAINT fkexf6rqn89f1gwkkpu8b2l2cb7 FOREIGN KEY (verbintenis) REFERENCES public.verbintenis(id);


--
-- Name: bijlageentiteit fkf10fm3m7sb5sqk5gxgmwusyfm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bijlageentiteit
    ADD CONSTRAINT fkf10fm3m7sb5sqk5gxgmwusyfm FOREIGN KEY (irisincident) REFERENCES public.irisincident(id);


--
-- Name: resultaat fkf12gflfm9jcewi2h65cpvm2fr; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resultaat
    ADD CONSTRAINT fkf12gflfm9jcewi2h65cpvm2fr FOREIGN KEY (waarde) REFERENCES public.schaalwaarde(id);


--
-- Name: contract fkf1rius8o3ok57v6648832rpit; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contract
    ADD CONSTRAINT fkf1rius8o3ok57v6648832rpit FOREIGN KEY (soortcontract) REFERENCES public.soortcontract(id);


--
-- Name: externeorganisatie fkf42rk3nhoemh7gfbqfimo7akb; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.externeorganisatie
    ADD CONSTRAINT fkf42rk3nhoemh7gfbqfimo7akb FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: modernetaal fkf4tqo75yw0ct6nogvavqhfx7c; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.modernetaal
    ADD CONSTRAINT fkf4tqo75yw0ct6nogvavqhfx7c FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: niettoneninzorgvierkant fkf561kvwvjijijrsys6a4i71p4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.niettoneninzorgvierkant
    ADD CONSTRAINT fkf561kvwvjijijrsys6a4i71p4 FOREIGN KEY (bijzonderheid) REFERENCES public.bijzonderheid(id);


--
-- Name: maatregeltoekenning fkf7gfxjs6npau390y86ir4wdba; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maatregeltoekenning
    ADD CONSTRAINT fkf7gfxjs6npau390y86ir4wdba FOREIGN KEY (eigenaarmedewerker) REFERENCES public.medewerker(id);


--
-- Name: incident fkf7ix3gqemxjo83953uqq1332l; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incident
    ADD CONSTRAINT fkf7ix3gqemxjo83953uqq1332l FOREIGN KEY (deelnemer) REFERENCES public.deelnemer(id);


--
-- Name: persoonextorgcontactpersoon fkf8bvi66eljl596qftbrx8e4c; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persoonextorgcontactpersoon
    ADD CONSTRAINT fkf8bvi66eljl596qftbrx8e4c FOREIGN KEY (extorgcontactpersoon) REFERENCES public.extorgcontactpersoon(id);


--
-- Name: bpvplaats fkf98h4s627d4ij79xfp7k31llm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvplaats
    ADD CONSTRAINT fkf98h4s627d4ij79xfp7k31llm FOREIGN KEY (contactpersoonbpvbedrijf) REFERENCES public.extorgcontactpersoon(id);


--
-- Name: toetscodefilterorgehdloc fkfdgxm6543ynth1pf5md2xhnud; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toetscodefilterorgehdloc
    ADD CONSTRAINT fkfdgxm6543ynth1pf5md2xhnud FOREIGN KEY (toetscodefilter) REFERENCES public.toetscodefilter(id);


--
-- Name: rapportagetemplateijkpunt fkfi3vt658qcqiiiocbm38mk878; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rapportagetemplateijkpunt
    ADD CONSTRAINT fkfi3vt658qcqiiiocbm38mk878 FOREIGN KEY (configpdf) REFERENCES public.voortgangpdfconfig(id);


--
-- Name: onderwijsproductsamenstelling fkfjsrod7m1snqybsg9eg2dhmvs; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproductsamenstelling
    ADD CONSTRAINT fkfjsrod7m1snqybsg9eg2dhmvs FOREIGN KEY (parent) REFERENCES public.onderwijsproduct(id);


--
-- Name: medewerkerkenmerk fkfldea114p1v56rkjc84q98rf5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medewerkerkenmerk
    ADD CONSTRAINT fkfldea114p1v56rkjc84q98rf5 FOREIGN KEY (medewerker) REFERENCES public.medewerker(id);


--
-- Name: bpvplaats fkfmdxqxs1q80ugl6vrpp3nxi2w; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvplaats
    ADD CONSTRAINT fkfmdxqxs1q80ugl6vrpp3nxi2w FOREIGN KEY (externeorganisatie) REFERENCES public.externeorganisatie(id);


--
-- Name: studielinkbericht fkfoljb3mxi1lfkic30xshudh2y; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.studielinkbericht
    ADD CONSTRAINT fkfoljb3mxi1lfkic30xshudh2y FOREIGN KEY (inschrijvingsverzoek) REFERENCES public.inschrijvingsverzoek(id);


--
-- Name: groepresultaatfilterinst fkfs3xhgpedf3v5xcwu88k62x0m; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groepresultaatfilterinst
    ADD CONSTRAINT fkfs3xhgpedf3v5xcwu88k62x0m FOREIGN KEY (groep) REFERENCES public.groep(id);


--
-- Name: externeagenda fkfsd2mngowfau16b4va20kq1h; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.externeagenda
    ADD CONSTRAINT fkfsd2mngowfau16b4va20kq1h FOREIGN KEY (eigenaar_id) REFERENCES public.persoon(id);


--
-- Name: taalscoreniveauverzameling fkfx6q3ww5iorvyset3ml0v1vg8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taalscoreniveauverzameling
    ADD CONSTRAINT fkfx6q3ww5iorvyset3ml0v1vg8 FOREIGN KEY (medewerker) REFERENCES public.medewerker(id);


--
-- Name: verbinteniscontract fkfykrwtswgxwykc7cgq7v01axs; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verbinteniscontract
    ADD CONSTRAINT fkfykrwtswgxwykc7cgq7v01axs FOREIGN KEY (verbintenis) REFERENCES public.verbintenis(id);


--
-- Name: vrijveldentiteit fkg3ljtw63hqeovci92kvaaytlt; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vrijveldentiteit
    ADD CONSTRAINT fkg3ljtw63hqeovci92kvaaytlt FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: vaardigheid fkg3mek1rclllv630a11v59xt9i; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vaardigheid
    ADD CONSTRAINT fkg3mek1rclllv630a11v59xt9i FOREIGN KEY (dossier) REFERENCES public.taxonomieelement(id);


--
-- Name: vooropleidingsignaalcode fkg3wv0h5jv0r5d8y0qvbgo8p07; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vooropleidingsignaalcode
    ADD CONSTRAINT fkg3wv0h5jv0r5d8y0qvbgo8p07 FOREIGN KEY (vooropleiding) REFERENCES public.vooropleiding(id);


--
-- Name: persoon fkg6lg6omxgga3m8by6vfe20x5v; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persoon
    ADD CONSTRAINT fkg6lg6omxgga3m8by6vfe20x5v FOREIGN KEY (nationaliteit1) REFERENCES public.nationaliteit(id);


--
-- Name: adresentiteit fkg86ux2ms4amjvrbk8n9tc58un; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adresentiteit
    ADD CONSTRAINT fkg86ux2ms4amjvrbk8n9tc58un FOREIGN KEY (externeorganisatie) REFERENCES public.externeorganisatie(id);


--
-- Name: notitie fkg8jkm4ssdyxwk231sm6welgjk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notitie
    ADD CONSTRAINT fkg8jkm4ssdyxwk231sm6welgjk FOREIGN KEY (auteur) REFERENCES public.medewerker(id);


--
-- Name: trajectsoort fkg8mqyt9n8pc3lp8caouecmqy4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trajectsoort
    ADD CONSTRAINT fkg8mqyt9n8pc3lp8caouecmqy4 FOREIGN KEY (defaulttestdefinitie) REFERENCES public.testdefinitie(id);


--
-- Name: verbinteniscontract fkgapnlr2f10s357nhauxawub9k; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verbinteniscontract
    ADD CONSTRAINT fkgapnlr2f10s357nhauxawub9k FOREIGN KEY (onderdeel) REFERENCES public.contractonderdeel(id);


--
-- Name: testveld fkgc8661xnen6sa9nae9i33kob2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.testveld
    ADD CONSTRAINT fkgc8661xnen6sa9nae9i33kob2 FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: bpvmatch fkgcq0ae8ow3acgnxen98wsk5yu; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvmatch
    ADD CONSTRAINT fkgcq0ae8ow3acgnxen98wsk5yu FOREIGN KEY (bpvcoloplaats) REFERENCES public.bpvcoloplaats(id);


--
-- Name: organisatieeenheidcg fkgetn9ygtgtepq1yqn1ua1ic52; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisatieeenheidcg
    ADD CONSTRAINT fkgetn9ygtgtepq1yqn1ua1ic52 FOREIGN KEY (soortcontactgegeven) REFERENCES public.soortcontactgegeven(id);


--
-- Name: verbintenis fkggkitorpxd36ihp4yfpeg765h; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verbintenis
    ADD CONSTRAINT fkggkitorpxd36ihp4yfpeg765h FOREIGN KEY (deelnemer) REFERENCES public.deelnemer(id);


--
-- Name: bpvmatch fkgh73uykmqcgatxbgahhs3vchg; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvmatch
    ADD CONSTRAINT fkgh73uykmqcgatxbgahhs3vchg FOREIGN KEY (bpvplaats) REFERENCES public.bpvplaats(id);


--
-- Name: verbintenis fkgjn40gxvouynss7n68r5rwlpx; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verbintenis
    ADD CONSTRAINT fkgjn40gxvouynss7n68r5rwlpx FOREIGN KEY (cohort) REFERENCES public.cohort(id);


--
-- Name: maatregeltoekenning fkglurfcy6xr5pv2kyny0yakbb7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maatregeltoekenning
    ADD CONSTRAINT fkglurfcy6xr5pv2kyny0yakbb7 FOREIGN KEY (deelnemer) REFERENCES public.deelnemer(id);


--
-- Name: afspraak fkgq6n2f3q920ie2vr5793l539y; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.afspraak
    ADD CONSTRAINT fkgq6n2f3q920ie2vr5793l539y FOREIGN KEY (afspraaktype) REFERENCES public.afspraaktype(id);


--
-- Name: recht fkgren9tbh1vn5pbrhmxgw2li1a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recht
    ADD CONSTRAINT fkgren9tbh1vn5pbrhmxgw2li1a FOREIGN KEY (rol) REFERENCES public.rol(id);


--
-- Name: budget fkgscj32815b3h2hdqej63imkep; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.budget
    ADD CONSTRAINT fkgscj32815b3h2hdqej63imkep FOREIGN KEY (verbintenis) REFERENCES public.verbintenis(id);


--
-- Name: bpvcriteriabpvdeelnemerprofiel fkh1nq89wmfcfr8018c2pt9j4jm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvcriteriabpvdeelnemerprofiel
    ADD CONSTRAINT fkh1nq89wmfcfr8018c2pt9j4jm FOREIGN KEY (bpvdeelnemerprofiel) REFERENCES public.bpvdeelnemerprofiel(id);


--
-- Name: examenworkflowtax fkh1tv4ewvhube4y4o6mh09234h; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.examenworkflowtax
    ADD CONSTRAINT fkh1tv4ewvhube4y4o6mh09234h FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: inloopcollegegroep fkh4cya47qvp8ehc2sp3w1ue8b1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inloopcollegegroep
    ADD CONSTRAINT fkh4cya47qvp8ehc2sp3w1ue8b1 FOREIGN KEY (groep) REFERENCES public.groep(id);


--
-- Name: intakegesprek fkh4q2coea7wwuaph7yflv4070c; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intakegesprek
    ADD CONSTRAINT fkh4q2coea7wwuaph7yflv4070c FOREIGN KEY (verbintenis) REFERENCES public.verbintenis(id);


--
-- Name: onderwijsproductopvolger fkh54c2m4622qu7vrlkx2gs5il9; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproductopvolger
    ADD CONSTRAINT fkh54c2m4622qu7vrlkx2gs5il9 FOREIGN KEY (oudproduct) REFERENCES public.onderwijsproduct(id);


--
-- Name: taalscore fkh5o0t5pabgotnbds1t8m1tocf; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taalscore
    ADD CONSTRAINT fkh5o0t5pabgotnbds1t8m1tocf FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: groepresultaatfilterinst fkh6hsdc9w0gkiwsn4h6jefs9v4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groepresultaatfilterinst
    ADD CONSTRAINT fkh6hsdc9w0gkiwsn4h6jefs9v4 FOREIGN KEY (cohort) REFERENCES public.cohort(id);


--
-- Name: adres fkh6yhk1b5ysihuoy8tttnep470; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adres
    ADD CONSTRAINT fkh6yhk1b5ysihuoy8tttnep470 FOREIGN KEY (provincie) REFERENCES public.provincie(id);


--
-- Name: bijzonderheid fkh89wvvcu3d0vq27xtj8nck7k0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bijzonderheid
    ADD CONSTRAINT fkh89wvvcu3d0vq27xtj8nck7k0 FOREIGN KEY (categorie) REFERENCES public.bijzonderheidcategorie(id);


--
-- Name: mogelijkeaanleiding fkhdmmdlijngiubc2loqbi6h10f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mogelijkeaanleiding
    ADD CONSTRAINT fkhdmmdlijngiubc2loqbi6h10f FOREIGN KEY (deelnemer) REFERENCES public.deelnemer(id);


--
-- Name: schaalwaarde fkhgra5fsgduvtkgebbr66rrpb2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schaalwaarde
    ADD CONSTRAINT fkhgra5fsgduvtkgebbr66rrpb2 FOREIGN KEY (schaal) REFERENCES public.schaal(id);


--
-- Name: traject fkhh8eiu1xd5h28va27vn5ldif9; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traject
    ADD CONSTRAINT fkhh8eiu1xd5h28va27vn5ldif9 FOREIGN KEY (eindhandelingtemplate) REFERENCES public.begeleidingshandelingtemplate(id);


--
-- Name: verbintenis fkhl4entikv8t94wlnhnp1hfltj; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verbintenis
    ADD CONSTRAINT fkhl4entikv8t94wlnhnp1hfltj FOREIGN KEY (relevantevooropleiding) REFERENCES public.vooropleiding(id);


--
-- Name: abstractrelatie fkhp18ovf3h2v2kiv5s8for520u; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.abstractrelatie
    ADD CONSTRAINT fkhp18ovf3h2v2kiv5s8for520u FOREIGN KEY (persoon) REFERENCES public.persoon(id);


--
-- Name: organisatie fkhp2ksuvgid2qythehujlbnqxl; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisatie
    ADD CONSTRAINT fkhp2ksuvgid2qythehujlbnqxl FOREIGN KEY (code) REFERENCES public.externeorganisatie(id);


--
-- Name: meeteenheidwaarde fkht94qvm55cnnxv8tffgm54qjo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meeteenheidwaarde
    ADD CONSTRAINT fkht94qvm55cnnxv8tffgm54qjo FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: externeorganisatieopmerking fkhuv9k7pdrk3v23vx520p0db70; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.externeorganisatieopmerking
    ADD CONSTRAINT fkhuv9k7pdrk3v23vx520p0db70 FOREIGN KEY (auteur) REFERENCES public.medewerker(id);


--
-- Name: opleidingaanbod fkhuvt6tijvrm76v47kgircssw6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.opleidingaanbod
    ADD CONSTRAINT fkhuvt6tijvrm76v47kgircssw6 FOREIGN KEY (organisatieeenheid) REFERENCES public.organisatieeenheid(id);


--
-- Name: onderwijsproductopvolger fkhxomwfchj4umn6kx4hw2fhaej; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproductopvolger
    ADD CONSTRAINT fkhxomwfchj4umn6kx4hw2fhaej FOREIGN KEY (nieuwproduct) REFERENCES public.onderwijsproduct(id);


--
-- Name: competentieniveauverzameling fki20147tx8r51d3rqgbvkvxcl1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.competentieniveauverzameling
    ADD CONSTRAINT fki20147tx8r51d3rqgbvkvxcl1 FOREIGN KEY (cohort) REFERENCES public.cohort(id);


--
-- Name: onderwijsproduct fki3cit2cxoe06wxdo6d29rn4n1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproduct
    ADD CONSTRAINT fki3cit2cxoe06wxdo6d29rn4n1 FOREIGN KEY (soortproduct) REFERENCES public.soortonderwijsproduct(id);


--
-- Name: bijlageentiteit fki3m80i8lmpw2ie128an5n8kag; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bijlageentiteit
    ADD CONSTRAINT fki3m80i8lmpw2ie128an5n8kag FOREIGN KEY (notitie) REFERENCES public.notitie(id);


--
-- Name: vrijveldentiteit fki5s64vhpmny3s89c46jgneiwu; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vrijveldentiteit
    ADD CONSTRAINT fki5s64vhpmny3s89c46jgneiwu FOREIGN KEY (persoon) REFERENCES public.persoon(id);


--
-- Name: resultaat fki6eydidm61tke1iq1dktped13; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resultaat
    ADD CONSTRAINT fki6eydidm61tke1iq1dktped13 FOREIGN KEY (deelnemer) REFERENCES public.deelnemer(id);


--
-- Name: bpvmatch fki8nmrjel6ysco8vhhkyfu1j8e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvmatch
    ADD CONSTRAINT fki8nmrjel6ysco8vhhkyfu1j8e FOREIGN KEY (bpvkandidaat) REFERENCES public.bpvkandidaat(id);


--
-- Name: vooropleidingvakresultaat fkigbonjhx4gq90efbjyuq01y3q; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vooropleidingvakresultaat
    ADD CONSTRAINT fkigbonjhx4gq90efbjyuq01y3q FOREIGN KEY (vooropleiding) REFERENCES public.vooropleiding(id);


--
-- Name: competentieniveauverzameling fkigmm4jrqoebn4dbjiaxfjyiwr; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.competentieniveauverzameling
    ADD CONSTRAINT fkigmm4jrqoebn4dbjiaxfjyiwr FOREIGN KEY (matrix) REFERENCES public.taxonomieelement(id);


--
-- Name: vrijveldoptiekeuze fkigpghh0afinv0jb31tfw43ykt; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vrijveldoptiekeuze
    ADD CONSTRAINT fkigpghh0afinv0jb31tfw43ykt FOREIGN KEY (entiteit) REFERENCES public.vrijveldentiteit(id);


--
-- Name: taalkeuze fkiiiwfcd0dypmnw2g7x983c0in; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taalkeuze
    ADD CONSTRAINT fkiiiwfcd0dypmnw2g7x983c0in FOREIGN KEY (verbintenis) REFERENCES public.verbintenis(id);


--
-- Name: bijzonderheid fkikbddswvd20yoewu1hssbbfmw; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bijzonderheid
    ADD CONSTRAINT fkikbddswvd20yoewu1hssbbfmw FOREIGN KEY (deelnemer) REFERENCES public.deelnemer(id);


--
-- Name: toegexamenstatusovergang fkil6ng9kwm8566msjra8aoocqw; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toegexamenstatusovergang
    ADD CONSTRAINT fkil6ng9kwm8566msjra8aoocqw FOREIGN KEY (naarexamenstatus) REFERENCES public.examenstatus(id);


--
-- Name: documenttemplaterecht fkine0o43f276pl7jiodl7oe0xv; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documenttemplaterecht
    ADD CONSTRAINT fkine0o43f276pl7jiodl7oe0xv FOREIGN KEY (rol) REFERENCES public.rol(id);


--
-- Name: meeteenheid fkiogjudlq5jf1wtyylglbgsguu; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meeteenheid
    ADD CONSTRAINT fkiogjudlq5jf1wtyylglbgsguu FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: vertasigdefevconkoppel fkioysn6utay0ou6fhhtsvwkdpu; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vertasigdefevconkoppel
    ADD CONSTRAINT fkioysn6utay0ou6fhhtsvwkdpu FOREIGN KEY (signaaldefinitie) REFERENCES public.verzuimtaaksignaaldefinitie(id);


--
-- Name: groepsdeelname fkitbs4b8x2o903d9rc4hnw20wx; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groepsdeelname
    ADD CONSTRAINT fkitbs4b8x2o903d9rc4hnw20wx FOREIGN KEY (deelnemer) REFERENCES public.deelnemer(id);


--
-- Name: resultaatstructuurdeelnemer fkiw5lvqypopnl6e9f5kgrmqp93; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resultaatstructuurdeelnemer
    ADD CONSTRAINT fkiw5lvqypopnl6e9f5kgrmqp93 FOREIGN KEY (deelnemer) REFERENCES public.deelnemer(id);


--
-- Name: onderwijsproductaanbod fkj2pjki65eigshqav2g1vutpj0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproductaanbod
    ADD CONSTRAINT fkj2pjki65eigshqav2g1vutpj0 FOREIGN KEY (organisatieeenheid) REFERENCES public.organisatieeenheid(id);


--
-- Name: deelnemerzoekopdrachtrecht fkj3fwxfoqg0k68lqojr7jcsb0s; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deelnemerzoekopdrachtrecht
    ADD CONSTRAINT fkj3fwxfoqg0k68lqojr7jcsb0s FOREIGN KEY (rol) REFERENCES public.rol(id);


--
-- Name: deelnemermedewerkergroepview fkj4w80oh7fq4nius2ifs8w2rlq; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deelnemermedewerkergroepview
    ADD CONSTRAINT fkj4w80oh7fq4nius2ifs8w2rlq FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: ibgverzuimmelding fkj79lf1thmbmigw32ojmhxqixa; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ibgverzuimmelding
    ADD CONSTRAINT fkj79lf1thmbmigw32ojmhxqixa FOREIGN KEY (locatie) REFERENCES public.locatie(id);


--
-- Name: onderwijsproduct fkj7n07w2bnihj8o9tiuoxyvusm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproduct
    ADD CONSTRAINT fkj7n07w2bnihj8o9tiuoxyvusm FOREIGN KEY (typetoets) REFERENCES public.typetoets(id);


--
-- Name: toegexamenstatusovergang fkjcan9ehem5ber3y0tes1pk8hk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toegexamenstatusovergang
    ADD CONSTRAINT fkjcan9ehem5ber3y0tes1pk8hk FOREIGN KEY (afgewezenexamenstatus) REFERENCES public.examenstatus(id);


--
-- Name: bookmark fkjejsqkaxoden1250upw7euqx2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookmark
    ADD CONSTRAINT fkjejsqkaxoden1250upw7euqx2 FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: onderwijsproductaanbod fkjesewqtwsevkbsp9j15adhkl2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproductaanbod
    ADD CONSTRAINT fkjesewqtwsevkbsp9j15adhkl2 FOREIGN KEY (onderwijsproduct) REFERENCES public.onderwijsproduct(id);


--
-- Name: orgehdcontactpersoon fkjh40wd3y8o3lagm2lgurat8rs; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orgehdcontactpersoon
    ADD CONSTRAINT fkjh40wd3y8o3lagm2lgurat8rs FOREIGN KEY (organisatieeenheid) REFERENCES public.organisatieeenheid(id);


--
-- Name: tekenbevoegdheid fkjjxv8pxwgivvumipwwendmhsv; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tekenbevoegdheid
    ADD CONSTRAINT fkjjxv8pxwgivvumipwwendmhsv FOREIGN KEY (organisatieeenheid) REFERENCES public.organisatieeenheid(id);


--
-- Name: niettoneninzorgvierkant fkjksv26dxdhcehhinaok46xyqd; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.niettoneninzorgvierkant
    ADD CONSTRAINT fkjksv26dxdhcehhinaok46xyqd FOREIGN KEY (traject) REFERENCES public.traject(id);


--
-- Name: mogelijkeaanleiding fkju91il6o7vdn69iscjqrl8nte; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mogelijkeaanleiding
    ADD CONSTRAINT fkju91il6o7vdn69iscjqrl8nte FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: niettoneninzorgvierkant fkjvertrnaaa7427b2oh14g7g80; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.niettoneninzorgvierkant
    ADD CONSTRAINT fkjvertrnaaa7427b2oh14g7g80 FOREIGN KEY (medewerker) REFERENCES public.medewerker(id);


--
-- Name: contactpersoon fkjvjyj227e7bbx8o8syillfxvx; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contactpersoon
    ADD CONSTRAINT fkjvjyj227e7bbx8o8syillfxvx FOREIGN KEY (bijorganisatieeenheid) REFERENCES public.organisatieeenheid(id);


--
-- Name: bijlageentiteit fkk0ygkiuolnmfn9xvf4yv01q1h; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bijlageentiteit
    ADD CONSTRAINT fkk0ygkiuolnmfn9xvf4yv01q1h FOREIGN KEY (opleiding) REFERENCES public.opleiding(id);


--
-- Name: intakegesprek fkk19dedlrndcfebsrljk1sk2rs; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intakegesprek
    ADD CONSTRAINT fkk19dedlrndcfebsrljk1sk2rs FOREIGN KEY (gewenstegroep) REFERENCES public.groep(id);


--
-- Name: groepsdeelname fkk1voyoxyt1qhicd88molrpbxg; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groepsdeelname
    ADD CONSTRAINT fkk1voyoxyt1qhicd88molrpbxg FOREIGN KEY (groep) REFERENCES public.groep(id);


--
-- Name: toegestaanonderwijsproduct fkk41mwo17wryuttoymq3b2r2c4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toegestaanonderwijsproduct
    ADD CONSTRAINT fkk41mwo17wryuttoymq3b2r2c4 FOREIGN KEY (productregel) REFERENCES public.productregel(id);


--
-- Name: deelnemerresultaatversie fkk49iluujmtljuvur4yblve7nm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deelnemerresultaatversie
    ADD CONSTRAINT fkk49iluujmtljuvur4yblve7nm FOREIGN KEY (deelnemer) REFERENCES public.deelnemer(id);


--
-- Name: afspraak fkk7sy4rnrk6i50ka1mn2hq1len; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.afspraak
    ADD CONSTRAINT fkk7sy4rnrk6i50ka1mn2hq1len FOREIGN KEY (basisrooster) REFERENCES public.basisrooster(id);


--
-- Name: irisincident fkk8igntyldw5ni0nmqnfaysvxt; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.irisincident
    ADD CONSTRAINT fkk8igntyldw5ni0nmqnfaysvxt FOREIGN KEY (organisatieeenheid_id) REFERENCES public.organisatieeenheid(id);


--
-- Name: bpvcriteriabpvplaats fkkb357cpoqgdo730e4vh57crkb; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvcriteriabpvplaats
    ADD CONSTRAINT fkkb357cpoqgdo730e4vh57crkb FOREIGN KEY (bpvplaats) REFERENCES public.bpvplaats(id);


--
-- Name: standaardtoetscodefilter fkkbevwpqrx1tdpxqmiar0kgypo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.standaardtoetscodefilter
    ADD CONSTRAINT fkkbevwpqrx1tdpxqmiar0kgypo FOREIGN KEY (cohort) REFERENCES public.cohort(id);


--
-- Name: gemeente fkkdy1ic3dr3md3ytcyfoapfgdn; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gemeente
    ADD CONSTRAINT fkkdy1ic3dr3md3ytcyfoapfgdn FOREIGN KEY (nieuwegemeente) REFERENCES public.gemeente(id);


--
-- Name: incidentcategorie fkkelwapewaqot6jtsnt4nsyh67; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidentcategorie
    ADD CONSTRAINT fkkelwapewaqot6jtsnt4nsyh67 FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: locatiecontactgegeven fkkf9nhdwulag9iyavaxxfktkuv; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locatiecontactgegeven
    ADD CONSTRAINT fkkf9nhdwulag9iyavaxxfktkuv FOREIGN KEY (soortcontactgegeven) REFERENCES public.soortcontactgegeven(id);


--
-- Name: budget fkkfjgcbgfc87fxjwci1x2cp0y1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.budget
    ADD CONSTRAINT fkkfjgcbgfc87fxjwci1x2cp0y1 FOREIGN KEY (onderwijsproduct) REFERENCES public.onderwijsproduct(id);


--
-- Name: curriculum fkkgc67enluy6j81tfkpef5rj82; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.curriculum
    ADD CONSTRAINT fkkgc67enluy6j81tfkpef5rj82 FOREIGN KEY (locatie) REFERENCES public.locatie(id);


--
-- Name: organisatiemedewerker fkkhvyploqhxksnpwfwli41cm1y; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisatiemedewerker
    ADD CONSTRAINT fkkhvyploqhxksnpwfwli41cm1y FOREIGN KEY (medewerker) REFERENCES public.medewerker(id);


--
-- Name: organisatieeenheidcg fkkjl84sy9rsj8bvei1rks6nwpx; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisatieeenheidcg
    ADD CONSTRAINT fkkjl84sy9rsj8bvei1rks6nwpx FOREIGN KEY (organisatieeenheid) REFERENCES public.organisatieeenheid(id);


--
-- Name: betrokkenmedewerker fkkjvjw0tiu5cshcncpooguwk1i; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.betrokkenmedewerker
    ADD CONSTRAINT fkkjvjw0tiu5cshcncpooguwk1i FOREIGN KEY (medewerker) REFERENCES public.medewerker(id);


--
-- Name: resultaat fkkon1m7wyqhu009bycjovod5i5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resultaat
    ADD CONSTRAINT fkkon1m7wyqhu009bycjovod5i5 FOREIGN KEY (toets) REFERENCES public.toets(id);


--
-- Name: afspraakdeelnemer fkkr1sxxyqe2wgffhnawlk92i6o; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.afspraakdeelnemer
    ADD CONSTRAINT fkkr1sxxyqe2wgffhnawlk92i6o FOREIGN KEY (deelnemer) REFERENCES public.deelnemer(id);


--
-- Name: groepsdeelname fkkrkvbjrwbsn85amp6ejv9fb9n; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groepsdeelname
    ADD CONSTRAINT fkkrkvbjrwbsn85amp6ejv9fb9n FOREIGN KEY (verbintenis) REFERENCES public.verbintenis(id);


--
-- Name: vrijveldentiteit fkkruuhkpbhiela8537vqrdtbnt; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vrijveldentiteit
    ADD CONSTRAINT fkkruuhkpbhiela8537vqrdtbnt FOREIGN KEY (relatie) REFERENCES public.abstractrelatie(id);


--
-- Name: inloopcollegegroep fkksg2aagfll26ukhanhdbwwj1b; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inloopcollegegroep
    ADD CONSTRAINT fkksg2aagfll26ukhanhdbwwj1b FOREIGN KEY (inloopcollege) REFERENCES public.inloopcollege(id);


--
-- Name: notitie fkkswthycckfq9g74d9wcunpv7e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notitie
    ADD CONSTRAINT fkkswthycckfq9g74d9wcunpv7e FOREIGN KEY (deelnemer) REFERENCES public.deelnemer(id);


--
-- Name: onderwijsproducttaxonomie fkkt9bpfcv19shsmel3glocpokq; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproducttaxonomie
    ADD CONSTRAINT fkkt9bpfcv19shsmel3glocpokq FOREIGN KEY (onderwijsproduct) REFERENCES public.onderwijsproduct(id);


--
-- Name: abstractrelatie fkktmpihloy3wptp0e3w6eshvqm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.abstractrelatie
    ADD CONSTRAINT fkktmpihloy3wptp0e3w6eshvqm FOREIGN KEY (instelling) REFERENCES public.externeorganisatie(id);


--
-- Name: signaal fkkvhhw3fksl1mi2aq282j8ln4w; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.signaal
    ADD CONSTRAINT fkkvhhw3fksl1mi2aq282j8ln4w FOREIGN KEY (ontvanger) REFERENCES public.persoon(id);


--
-- Name: documenttemplate fkkvncsuqhoj4ak0ys42vn8i8w8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documenttemplate
    ADD CONSTRAINT fkkvncsuqhoj4ak0ys42vn8i8w8 FOREIGN KEY (taxonomie) REFERENCES public.taxonomieelement(id);


--
-- Name: ondprodverbruiksmiddel fkkw05uynn5oyaxcpt50qg8fexc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ondprodverbruiksmiddel
    ADD CONSTRAINT fkkw05uynn5oyaxcpt50qg8fexc FOREIGN KEY (verbruiksmiddel) REFERENCES public.verbruiksmiddel(id);


--
-- Name: lesweekindelingorgloc fkkx2c21whch27qtc1cqmkwb30e; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesweekindelingorgloc
    ADD CONSTRAINT fkkx2c21whch27qtc1cqmkwb30e FOREIGN KEY (locatie) REFERENCES public.locatie(id);


--
-- Name: periode fkl0q62ciugtvp83cs0hnibwku4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.periode
    ADD CONSTRAINT fkl0q62ciugtvp83cs0hnibwku4 FOREIGN KEY (periodeindeling) REFERENCES public.periodeindeling(id);


--
-- Name: inloopcollegeopleiding fkl2rrgoxopnpm4dksr9tfp5bgd; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inloopcollegeopleiding
    ADD CONSTRAINT fkl2rrgoxopnpm4dksr9tfp5bgd FOREIGN KEY (inloopcollege) REFERENCES public.inloopcollege(id);


--
-- Name: testveld fkl5lji593viq7mf4blm34hk40x; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.testveld
    ADD CONSTRAINT fkl5lji593viq7mf4blm34hk40x FOREIGN KEY (testdefinitie) REFERENCES public.testdefinitie(id);


--
-- Name: vrijveld fkl6by6wd46op0qviypdi5e76dk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vrijveld
    ADD CONSTRAINT fkl6by6wd46op0qviypdi5e76dk FOREIGN KEY (taxonomie) REFERENCES public.taxonomieelement(id);


--
-- Name: opleidingaanbod fkl72ej42e980vlg2incly72fj1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.opleidingaanbod
    ADD CONSTRAINT fkl72ej42e980vlg2incly72fj1 FOREIGN KEY (locatie) REFERENCES public.locatie(id);


--
-- Name: waarneming fklbpb5386qnm7ak4wa1ad5nyaf; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.waarneming
    ADD CONSTRAINT fklbpb5386qnm7ak4wa1ad5nyaf FOREIGN KEY (onderwijsproduct) REFERENCES public.onderwijsproduct(id);


--
-- Name: ibgverzuimdag fklbtqg92mk0sd4qou22jyn1xc1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ibgverzuimdag
    ADD CONSTRAINT fklbtqg92mk0sd4qou22jyn1xc1 FOREIGN KEY (verzuimmelding) REFERENCES public.ibgverzuimmelding(id);


--
-- Name: extorgcontactpersoon fklbvmxdtmd3pglbnkfomvv9vtq; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extorgcontactpersoon
    ADD CONSTRAINT fklbvmxdtmd3pglbnkfomvv9vtq FOREIGN KEY (rol) REFERENCES public.extorgcontpersrol(id);


--
-- Name: curriculumonderwijsproduct fklc1fqrcivns2qa2vpmyximrm3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.curriculumonderwijsproduct
    ADD CONSTRAINT fklc1fqrcivns2qa2vpmyximrm3 FOREIGN KEY (onderwijsproduct) REFERENCES public.onderwijsproduct(id);


--
-- Name: aanmelding fklfjvhkmhjqtjm4eq2kph57xbx; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aanmelding
    ADD CONSTRAINT fklfjvhkmhjqtjm4eq2kph57xbx FOREIGN KEY (verbintenis) REFERENCES public.verbintenis(id);


--
-- Name: afspraak fklipg1tpjq3khhfkem036rmsag; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.afspraak
    ADD CONSTRAINT fklipg1tpjq3khhfkem036rmsag FOREIGN KEY (locatie) REFERENCES public.locatie(id);


--
-- Name: extorgpraktijkbegeleider fklp2o91geq95mqn7r7tvw02l8c; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extorgpraktijkbegeleider
    ADD CONSTRAINT fklp2o91geq95mqn7r7tvw02l8c FOREIGN KEY (medewerker) REFERENCES public.medewerker(id);


--
-- Name: persoon fklpkydatmspgpgvwdrrjwjmlxe; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persoon
    ADD CONSTRAINT fklpkydatmspgpgvwdrrjwjmlxe FOREIGN KEY (geboortelandouder2) REFERENCES public.land(id);


--
-- Name: contract fklqo5l3yi47ok3aoem6hnh556n; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contract
    ADD CONSTRAINT fklqo5l3yi47ok3aoem6hnh556n FOREIGN KEY (externeorganisatie) REFERENCES public.externeorganisatie(id);


--
-- Name: adresentiteit fklt27ch4pvn6h1ebh9r3cbr3a9; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adresentiteit
    ADD CONSTRAINT fklt27ch4pvn6h1ebh9r3cbr3a9 FOREIGN KEY (organisatieeenheid) REFERENCES public.organisatieeenheid(id);


--
-- Name: adres fklw8fihei1h65bp4417d894ply; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adres
    ADD CONSTRAINT fklw8fihei1h65bp4417d894ply FOREIGN KEY (land) REFERENCES public.land(id);


--
-- Name: deelnemerkenmerk fklx3xyte5w3po67hqdxw8qo1rw; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deelnemerkenmerk
    ADD CONSTRAINT fklx3xyte5w3po67hqdxw8qo1rw FOREIGN KEY (kenmerk) REFERENCES public.kenmerk(id);


--
-- Name: extorgpraktijkbegeleider fkm1r9dxdtu4whmsyv8dvl9gc3f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extorgpraktijkbegeleider
    ADD CONSTRAINT fkm1r9dxdtu4whmsyv8dvl9gc3f FOREIGN KEY (externeorganisatie) REFERENCES public.externeorganisatie(id);


--
-- Name: taxonomieelement fkm3a2n5h7b3a7is05leojjmbx0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxonomieelement
    ADD CONSTRAINT fkm3a2n5h7b3a7is05leojjmbx0 FOREIGN KEY (dossier) REFERENCES public.taxonomieelement(id);


--
-- Name: intakegesprek fkm4vwnydudgshkm09ox5lndsgx; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intakegesprek
    ADD CONSTRAINT fkm4vwnydudgshkm09ox5lndsgx FOREIGN KEY (gewenstebpv) REFERENCES public.externeorganisatie(id);


--
-- Name: olcwaarneming fkm5wu1hnc9665ecsy4edjgbyv4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.olcwaarneming
    ADD CONSTRAINT fkm5wu1hnc9665ecsy4edjgbyv4 FOREIGN KEY (afspraaktype) REFERENCES public.afspraaktype(id);


--
-- Name: vaardigheid fkmam9adoesbaswuoudf0fd4rqh; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vaardigheid
    ADD CONSTRAINT fkmam9adoesbaswuoudf0fd4rqh FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: deelnemer fkmcuslhcssqxkbje0mwgdyadju; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deelnemer
    ADD CONSTRAINT fkmcuslhcssqxkbje0mwgdyadju FOREIGN KEY (persoon) REFERENCES public.persoon(id);


--
-- Name: testdefinitie fkmg9x4k2ox3a0dj8ha5l7b4n61; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.testdefinitie
    ADD CONSTRAINT fkmg9x4k2ox3a0dj8ha5l7b4n61 FOREIGN KEY (afspraaktype) REFERENCES public.afspraaktype(id);


--
-- Name: leerpuntcomponent fkmgkn9p7is88cer3nirauw7hkm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leerpuntcomponent
    ADD CONSTRAINT fkmgkn9p7is88cer3nirauw7hkm FOREIGN KEY (leerpunt) REFERENCES public.taxonomieelement(id);


--
-- Name: persooncontactgegeven fkmkmy26vfmn1psaa4qutgh6qgd; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persooncontactgegeven
    ADD CONSTRAINT fkmkmy26vfmn1psaa4qutgh6qgd FOREIGN KEY (soortcontactgegeven) REFERENCES public.soortcontactgegeven(id);


--
-- Name: irisbetrokkene fkml5rpn31h97cv5e6fegbsswta; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.irisbetrokkene
    ADD CONSTRAINT fkml5rpn31h97cv5e6fegbsswta FOREIGN KEY (irisincident) REFERENCES public.irisincident(id);


--
-- Name: olcwaarneming fkmlomr5vfd3b25gsitbdix6gw4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.olcwaarneming
    ADD CONSTRAINT fkmlomr5vfd3b25gsitbdix6gw4 FOREIGN KEY (medewerker) REFERENCES public.medewerker(id);


--
-- Name: bpvinschrijving fkmm4pdirkkybj5p1ajgig0ix19; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvinschrijving
    ADD CONSTRAINT fkmm4pdirkkybj5p1ajgig0ix19 FOREIGN KEY (contractpartner) REFERENCES public.externeorganisatie(id);


--
-- Name: maatregeltoekenningsregel fkmo9g3tnobwiw7yps54jy5wtsc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maatregeltoekenningsregel
    ADD CONSTRAINT fkmo9g3tnobwiw7yps54jy5wtsc FOREIGN KEY (organisatieeenheid) REFERENCES public.organisatieeenheid(id);


--
-- Name: vasco_tokens fkmtq97wf49468p8a8c95omu38k; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vasco_tokens
    ADD CONSTRAINT fkmtq97wf49468p8a8c95omu38k FOREIGN KEY (gebruiker) REFERENCES public.account(id);


--
-- Name: resultaat fkmw13q8qrx9k88atox6oag82j8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resultaat
    ADD CONSTRAINT fkmw13q8qrx9k88atox6oag82j8 FOREIGN KEY (overschrijft) REFERENCES public.resultaat(id);


--
-- Name: onderwijsproducttaxonomie fkmw44dcjubykj3difsop4h6dvu; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproducttaxonomie
    ADD CONSTRAINT fkmw44dcjubykj3difsop4h6dvu FOREIGN KEY (taxonomieelement) REFERENCES public.taxonomieelement(id);


--
-- Name: standaardtoetscodefilter fkmw5l9ys3qr0vayumed7hdt9xg; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.standaardtoetscodefilter
    ADD CONSTRAINT fkmw5l9ys3qr0vayumed7hdt9xg FOREIGN KEY (toetscodefilter) REFERENCES public.toetscodefilter(id);


--
-- Name: vooropleiding fkmw8m3t78ebmjodq1tfcsnga7s; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vooropleiding
    ADD CONSTRAINT fkmw8m3t78ebmjodq1tfcsnga7s FOREIGN KEY (schooladvies) REFERENCES public.schooladvies(id);


--
-- Name: verbintenisfasecredits fkn1v1gpajovh2d5nechp8cmkxx; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verbintenisfasecredits
    ADD CONSTRAINT fkn1v1gpajovh2d5nechp8cmkxx FOREIGN KEY (verbintenis) REFERENCES public.verbintenis(id);


--
-- Name: contract fkn215uqhdr9vl8j8vljh33x1lo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contract
    ADD CONSTRAINT fkn215uqhdr9vl8j8vljh33x1lo FOREIGN KEY (contactpersoon) REFERENCES public.extorgcontactpersoon(id);


--
-- Name: vrijveldentiteit fkn21qkgdv2y4tqx2wkfwci0fa3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vrijveldentiteit
    ADD CONSTRAINT fkn21qkgdv2y4tqx2wkfwci0fa3 FOREIGN KEY (externeorganisatie) REFERENCES public.externeorganisatie(id);


--
-- Name: deelnemerzoekopdracht fkn28xacuku40loa6059rlljis1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deelnemerzoekopdracht
    ADD CONSTRAINT fkn28xacuku40loa6059rlljis1 FOREIGN KEY (account) REFERENCES public.account(id);


--
-- Name: groep fkn3mpilicwpisopl9ogw941dod; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groep
    ADD CONSTRAINT fkn3mpilicwpisopl9ogw941dod FOREIGN KEY (locatie) REFERENCES public.locatie(id);


--
-- Name: examenworkflow fkn44h5elahuap40nbdr5dlwuvj; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.examenworkflow
    ADD CONSTRAINT fkn44h5elahuap40nbdr5dlwuvj FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: taxonomieelement fkn5fbw8brxwg0e3g4an1sj23cc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxonomieelement
    ADD CONSTRAINT fkn5fbw8brxwg0e3g4an1sj23cc FOREIGN KEY (taxonomie) REFERENCES public.taxonomieelement(id);


--
-- Name: persoon fkn9fdvwaurh3oekx5b2ene0b3s; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persoon
    ADD CONSTRAINT fkn9fdvwaurh3oekx5b2ene0b3s FOREIGN KEY (geboorteland) REFERENCES public.land(id);


--
-- Name: irisbetrokkene fkn9vsguidbgchyj2r2kd4c0nao; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.irisbetrokkene
    ADD CONSTRAINT fkn9vsguidbgchyj2r2kd4c0nao FOREIGN KEY (medewerker) REFERENCES public.medewerker(id);


--
-- Name: olcwaarneming fknbd9ird5nrkw86vn2f7khyrlh; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.olcwaarneming
    ADD CONSTRAINT fknbd9ird5nrkw86vn2f7khyrlh FOREIGN KEY (olclocatie) REFERENCES public.olclocatie(id);


--
-- Name: verbinteniscontract fknbh53bks6byx7acsgpnxpdnuu; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verbinteniscontract
    ADD CONSTRAINT fknbh53bks6byx7acsgpnxpdnuu FOREIGN KEY (contract) REFERENCES public.contract(id);


--
-- Name: scoreschaalwaarde fkncxxna0edpf3795m6enalqh86; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scoreschaalwaarde
    ADD CONSTRAINT fkncxxna0edpf3795m6enalqh86 FOREIGN KEY (waarde) REFERENCES public.schaalwaarde(id);


--
-- Name: bpvcriteriaexterneorganisatie fkndnj9s0gakd982ldx8lpoxi64; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvcriteriaexterneorganisatie
    ADD CONSTRAINT fkndnj9s0gakd982ldx8lpoxi64 FOREIGN KEY (externeorganisatie) REFERENCES public.externeorganisatie(id);


--
-- Name: deelnemerzoekopdrachtrecht fknfxnu6hq4g7ymbeorueuv3k34; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deelnemerzoekopdrachtrecht
    ADD CONSTRAINT fknfxnu6hq4g7ymbeorueuv3k34 FOREIGN KEY (zoekopdracht) REFERENCES public.deelnemerzoekopdracht(id);


--
-- Name: afspraak fknhbnutfqyolcsuftekepcvgju; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.afspraak
    ADD CONSTRAINT fknhbnutfqyolcsuftekepcvgju FOREIGN KEY (onderwijsproduct) REFERENCES public.onderwijsproduct(id);


--
-- Name: inschrijvingsverzoek fknhh6smeoqp0v9duc9arxxd5hv; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inschrijvingsverzoek
    ADD CONSTRAINT fknhh6smeoqp0v9duc9arxxd5hv FOREIGN KEY (gbaverificatiebrin) REFERENCES public.externeorganisatie(id);


--
-- Name: soortproductregel fknj9uxrx2g9m9ns55kfu7h03n0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.soortproductregel
    ADD CONSTRAINT fknj9uxrx2g9m9ns55kfu7h03n0 FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: groepsdeelname fknmffxtgo2anf700wsl0igvlx7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groepsdeelname
    ADD CONSTRAINT fknmffxtgo2anf700wsl0igvlx7 FOREIGN KEY (contract) REFERENCES public.contract(id);


--
-- Name: contract fkno4ealmullp3wnb0ugw2kq2es; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contract
    ADD CONSTRAINT fkno4ealmullp3wnb0ugw2kq2es FOREIGN KEY (beheerder) REFERENCES public.medewerker(id);


--
-- Name: bpvcriteriabpvkandidaat fkno6ah0crxlxk5s2g10lgm24wy; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvcriteriabpvkandidaat
    ADD CONSTRAINT fkno6ah0crxlxk5s2g10lgm24wy FOREIGN KEY (bpvkandidaat) REFERENCES public.bpvkandidaat(id);


--
-- Name: resultaatzoekfilterinstelling fknpu19dy8vwy7sdrqrsvncl68x; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resultaatzoekfilterinstelling
    ADD CONSTRAINT fknpu19dy8vwy7sdrqrsvncl68x FOREIGN KEY (categorie) REFERENCES public.resultaatstructuurcategorie(id);


--
-- Name: taxonomieelement fknqd91qxwvvl878icdv8kabyvx; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxonomieelement
    ADD CONSTRAINT fknqd91qxwvvl878icdv8kabyvx FOREIGN KEY (deelnemer) REFERENCES public.deelnemer(id);


--
-- Name: periodeindeling fknsyajd04jsdbi8werqq7fpdqx; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.periodeindeling
    ADD CONSTRAINT fknsyajd04jsdbi8werqq7fpdqx FOREIGN KEY (organisatieeenheid) REFERENCES public.organisatieeenheid(id);


--
-- Name: leerpuntvaardigheid fknu2bwwi6u08f9ojdi16ojivuh; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leerpuntvaardigheid
    ADD CONSTRAINT fknu2bwwi6u08f9ojdi16ojivuh FOREIGN KEY (leerpunt) REFERENCES public.taxonomieelement(id);


--
-- Name: scoreschaalwaarde fknuwxtyrn3sacyoholscyeu512; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scoreschaalwaarde
    ADD CONSTRAINT fknuwxtyrn3sacyoholscyeu512 FOREIGN KEY (toets) REFERENCES public.toets(id);


--
-- Name: criterium fknw3ksketijagmb82ertfcct4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.criterium
    ADD CONSTRAINT fknw3ksketijagmb82ertfcct4 FOREIGN KEY (verbintenisgebied) REFERENCES public.taxonomieelement(id);


--
-- Name: afspraakparticipant fknwyj6r2ft8hesmdu75pcf04ol; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.afspraakparticipant
    ADD CONSTRAINT fknwyj6r2ft8hesmdu75pcf04ol FOREIGN KEY (externe) REFERENCES public.externpersoon(id);


--
-- Name: toetscodefilterorgehdloc fko1nti3t1b5gms3m3nodheer9v; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toetscodefilterorgehdloc
    ADD CONSTRAINT fko1nti3t1b5gms3m3nodheer9v FOREIGN KEY (locatie) REFERENCES public.locatie(id);


--
-- Name: vrijveldkeuzeoptie fko2g5kjl8rocm5yu919rtevwvm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vrijveldkeuzeoptie
    ADD CONSTRAINT fko2g5kjl8rocm5yu919rtevwvm FOREIGN KEY (vrijveld) REFERENCES public.vrijveld(id);


--
-- Name: irisbetrokkene fko6yqxxx5u3dggkmedwk3uv4gi; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.irisbetrokkene
    ADD CONSTRAINT fko6yqxxx5u3dggkmedwk3uv4gi FOREIGN KEY (incident) REFERENCES public.incident(id);


--
-- Name: bijlageentiteit fkobvt54up22svdfx4q1dqsl41a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bijlageentiteit
    ADD CONSTRAINT fkobvt54up22svdfx4q1dqsl41a FOREIGN KEY (bijzonderheid) REFERENCES public.bijzonderheid(id);


--
-- Name: maatregeltoekenningsregel fkoc6s3cdia5dhro80wr32emxcr; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maatregeltoekenningsregel
    ADD CONSTRAINT fkoc6s3cdia5dhro80wr32emxcr FOREIGN KEY (periode) REFERENCES public.periodeindeling(id);


--
-- Name: taaksoort fkodp2hrm0fuwxfdx9dcyaerp99; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taaksoort
    ADD CONSTRAINT fkodp2hrm0fuwxfdx9dcyaerp99 FOREIGN KEY (locatie) REFERENCES public.locatie(id);


--
-- Name: bijlageentiteit fkoebvuhorxu58brase4fdnd8h3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bijlageentiteit
    ADD CONSTRAINT fkoebvuhorxu58brase4fdnd8h3 FOREIGN KEY (onderwijsproduct) REFERENCES public.onderwijsproduct(id);


--
-- Name: verbintenisfasecredits fkofc5rwais4dco1ix4plpi20uk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verbintenisfasecredits
    ADD CONSTRAINT fkofc5rwais4dco1ix4plpi20uk FOREIGN KEY (fase) REFERENCES public.fase(id);


--
-- Name: rol fkoga95ltk4m82ps467edqubgnn; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rol
    ADD CONSTRAINT fkoga95ltk4m82ps467edqubgnn FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: examenstatus fkoi6fend1okihvvdkxuiri23vq; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.examenstatus
    ADD CONSTRAINT fkoi6fend1okihvvdkxuiri23vq FOREIGN KEY (examenworkflow) REFERENCES public.examenworkflow(id);


--
-- Name: adres fkok3xvtvd18pe7edxb2imfv47l; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adres
    ADD CONSTRAINT fkok3xvtvd18pe7edxb2imfv47l FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: opaanbodperiodeopafname fkokejjtlr38uyt6gha78k3j8sh; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.opaanbodperiodeopafname
    ADD CONSTRAINT fkokejjtlr38uyt6gha78k3j8sh FOREIGN KEY (onderwijsproductaanbodperiode) REFERENCES public.onderwijsproductaanbodperiode(id);


--
-- Name: recht fkon3l48pw426kalltlriih6qmb; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recht
    ADD CONSTRAINT fkon3l48pw426kalltlriih6qmb FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: bijzonderheid fkoohoirhq6qhg8i4a3f0v70my2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bijzonderheid
    ADD CONSTRAINT fkoohoirhq6qhg8i4a3f0v70my2 FOREIGN KEY (auteur) REFERENCES public.medewerker(id);


--
-- Name: productregel fkoomwcqtotajdvtx6j319dnehw; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productregel
    ADD CONSTRAINT fkoomwcqtotajdvtx6j319dnehw FOREIGN KEY (cohort) REFERENCES public.cohort(id);


--
-- Name: bpvinschrijving fkopkmryp9pn1e3wysxqv7rkcuv; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvinschrijving
    ADD CONSTRAINT fkopkmryp9pn1e3wysxqv7rkcuv FOREIGN KEY (redenuitschrijving) REFERENCES public.redenuitschrijving(id);


--
-- Name: lesdagindeling fkoreurgiko5u3ruh7hs23sjldf; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesdagindeling
    ADD CONSTRAINT fkoreurgiko5u3ruh7hs23sjldf FOREIGN KEY (lesweekindeling) REFERENCES public.lesweekindeling(id);


--
-- Name: absentiemelding fkori3w7hovkrj3v1uw4e0n366p; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.absentiemelding
    ADD CONSTRAINT fkori3w7hovkrj3v1uw4e0n366p FOREIGN KEY (deelnemer) REFERENCES public.deelnemer(id);


--
-- Name: documenttype fkorkf8ohenmi5updph80yge6ol; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documenttype
    ADD CONSTRAINT fkorkf8ohenmi5updph80yge6ol FOREIGN KEY (categorie) REFERENCES public.documentcategorie(id);


--
-- Name: medewerker fkovtv6bxv47b7s0jnkk0a5ggil; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medewerker
    ADD CONSTRAINT fkovtv6bxv47b7s0jnkk0a5ggil FOREIGN KEY (persoon) REFERENCES public.persoon(id);


--
-- Name: edvcs fkp049b5xp6g3pboe1o1fwg4okr; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.edvcs
    ADD CONSTRAINT fkp049b5xp6g3pboe1o1fwg4okr FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: deelnemermatrix fkp0vochlymoc2qt0o3uqny01th; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deelnemermatrix
    ADD CONSTRAINT fkp0vochlymoc2qt0o3uqny01th FOREIGN KEY (meeteenheid) REFERENCES public.meeteenheid(id);


--
-- Name: taxonomieelement fkp12n6taeams3p80ras0ntxopa; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxonomieelement
    ADD CONSTRAINT fkp12n6taeams3p80ras0ntxopa FOREIGN KEY (werkproces) REFERENCES public.taxonomieelement(id);


--
-- Name: afspraakparticipant fkp1nvdd5uvsxqb4bt2ilptttp2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.afspraakparticipant
    ADD CONSTRAINT fkp1nvdd5uvsxqb4bt2ilptttp2 FOREIGN KEY (medewerker) REFERENCES public.medewerker(id);


--
-- Name: bijlageentiteit fkp37rbc21ata8hab3bcp0csqs6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bijlageentiteit
    ADD CONSTRAINT fkp37rbc21ata8hab3bcp0csqs6 FOREIGN KEY (bijlage) REFERENCES public.bijlage(id);


--
-- Name: lesweekindelingorgloc fkp45p2xkm3eej8ynkk6f7ingm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesweekindelingorgloc
    ADD CONSTRAINT fkp45p2xkm3eej8ynkk6f7ingm FOREIGN KEY (lesweekindeling) REFERENCES public.lesweekindeling(id);


--
-- Name: persoon fkp50bq05spt1lwveisc1md6cde; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persoon
    ADD CONSTRAINT fkp50bq05spt1lwveisc1md6cde FOREIGN KEY (verblijfsvergunning) REFERENCES public.verblijfsvergunning(id);


--
-- Name: opaanbodperiodeopafname fkpc28p7us2nhc58x863uwoj3bq; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.opaanbodperiodeopafname
    ADD CONSTRAINT fkpc28p7us2nhc58x863uwoj3bq FOREIGN KEY (onderwijsproductafname) REFERENCES public.onderwijsproductafname(id);


--
-- Name: sessie fkpcyt6oaayka3w2kd39upbkait; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessie
    ADD CONSTRAINT fkpcyt6oaayka3w2kd39upbkait FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: inschrijvingsverzoek fkpf4g9qv1dd0b04p875xi709x1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inschrijvingsverzoek
    ADD CONSTRAINT fkpf4g9qv1dd0b04p875xi709x1 FOREIGN KEY (instroommoment) REFERENCES public.instroommoment(id);


--
-- Name: bijlageentiteit fkpgovx3riomoriph5q9xqb5hb3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bijlageentiteit
    ADD CONSTRAINT fkpgovx3riomoriph5q9xqb5hb3 FOREIGN KEY (groep) REFERENCES public.groep(id);


--
-- Name: bpvcriteriaonderwijsproduct fkph4h1xv7i2soqdbt38c9o7hwl; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvcriteriaonderwijsproduct
    ADD CONSTRAINT fkph4h1xv7i2soqdbt38c9o7hwl FOREIGN KEY (bpvcriteria) REFERENCES public.bpvcriteria(id);


--
-- Name: contractverplichting fkphmv4quwo8hqyvn2dsw8hclqo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contractverplichting
    ADD CONSTRAINT fkphmv4quwo8hqyvn2dsw8hclqo FOREIGN KEY (medewerker) REFERENCES public.medewerker(id);


--
-- Name: meeteenheidkoppel fkpjbbbkvvgmf2w19x7btoctxa0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meeteenheidkoppel
    ADD CONSTRAINT fkpjbbbkvvgmf2w19x7btoctxa0 FOREIGN KEY (organisatieeenheid) REFERENCES public.organisatieeenheid(id);


--
-- Name: opleidingaanbod fkpmo2lvvl2dpxjqswwq763rlwn; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.opleidingaanbod
    ADD CONSTRAINT fkpmo2lvvl2dpxjqswwq763rlwn FOREIGN KEY (opleiding) REFERENCES public.opleiding(id);


--
-- Name: toetscodefilterorgehdloc fkpnqht7nw14mrsmtv31kdbad21; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toetscodefilterorgehdloc
    ADD CONSTRAINT fkpnqht7nw14mrsmtv31kdbad21 FOREIGN KEY (organisatieeenheid) REFERENCES public.organisatieeenheid(id);


--
-- Name: fase fkpqyc1v4772atfc2h3f11oahbq; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fase
    ADD CONSTRAINT fkpqyc1v4772atfc2h3f11oahbq FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: documenttemplate fkprarvbr975a8rhcebi3lowypu; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documenttemplate
    ADD CONSTRAINT fkprarvbr975a8rhcebi3lowypu FOREIGN KEY (documenttype) REFERENCES public.documenttype(id);


--
-- Name: olclocatie fkprtggm23o7mc3stytkyp57p70; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.olclocatie
    ADD CONSTRAINT fkprtggm23o7mc3stytkyp57p70 FOREIGN KEY (afspraaktype) REFERENCES public.afspraaktype(id);


--
-- Name: taxonomieelement fkpsbctik8atp15250u28qse7jt; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxonomieelement
    ADD CONSTRAINT fkpsbctik8atp15250u28qse7jt FOREIGN KEY (meeteenheid) REFERENCES public.meeteenheid(id);


--
-- Name: onderwijsproductafname fkpthycqln7rcqmy86vm4hfpe7p; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproductafname
    ADD CONSTRAINT fkpthycqln7rcqmy86vm4hfpe7p FOREIGN KEY (bpvinschrijving) REFERENCES public.bpvinschrijving(id);


--
-- Name: onderwijsproductaanbodperiode fkpv3wbysdtrseqgty66u4geiup; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproductaanbodperiode
    ADD CONSTRAINT fkpv3wbysdtrseqgty66u4geiup FOREIGN KEY (onderwijsproductaanbod) REFERENCES public.onderwijsproductaanbod(id);


--
-- Name: trajecttemplate fkpv7c3eiva5ef52msstjuxvje9; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trajecttemplate
    ADD CONSTRAINT fkpv7c3eiva5ef52msstjuxvje9 FOREIGN KEY (eindhandelingtemplate) REFERENCES public.begeleidingshandelingtemplate(id);


--
-- Name: taaltypekoppel fkpv9bbjnhg8bs553a4aqlyyrgs; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taaltypekoppel
    ADD CONSTRAINT fkpv9bbjnhg8bs553a4aqlyyrgs FOREIGN KEY (type) REFERENCES public.taaltype(id);


--
-- Name: contract fkpvm0pix7083kjo3sib3q5cn0l; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contract
    ADD CONSTRAINT fkpvm0pix7083kjo3sib3q5cn0l FOREIGN KEY (organisatieeenheid) REFERENCES public.organisatieeenheid(id);


--
-- Name: resultaatstructuur fkpxnygymoh8an0xx65i5tpqaa3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resultaatstructuur
    ADD CONSTRAINT fkpxnygymoh8an0xx65i5tpqaa3 FOREIGN KEY (cohort) REFERENCES public.cohort(id);


--
-- Name: taalscore fkpy0ys8cfx2248dejw6lhvvu1a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taalscore
    ADD CONSTRAINT fkpy0ys8cfx2248dejw6lhvvu1a FOREIGN KEY (taalvaardigheid) REFERENCES public.taalvaardigheid(id);


--
-- Name: bpvinschrijving fkq3q4s7gri604muu86wpjxa4vk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvinschrijving
    ADD CONSTRAINT fkq3q4s7gri604muu86wpjxa4vk FOREIGN KEY (bpvbedrijf) REFERENCES public.externeorganisatie(id);


--
-- Name: bpvkandidaatonderwijsproduct fkq3rff8tfyt3qurs9mpx5ioiwm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvkandidaatonderwijsproduct
    ADD CONSTRAINT fkq3rff8tfyt3qurs9mpx5ioiwm FOREIGN KEY (onderwijsproduct) REFERENCES public.onderwijsproduct(id);


--
-- Name: afspraakdeelnemer fkq55hv2r9g7o9vp81hvydbbbpg; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.afspraakdeelnemer
    ADD CONSTRAINT fkq55hv2r9g7o9vp81hvydbbbpg FOREIGN KEY (contract) REFERENCES public.contract(id);


--
-- Name: niettoneninzorgvierkant fkq8o1vp55djhw127ukivsp0yky; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.niettoneninzorgvierkant
    ADD CONSTRAINT fkq8o1vp55djhw127ukivsp0yky FOREIGN KEY (irisincident) REFERENCES public.irisincident(id);


--
-- Name: maatregeltoekenning fkqax5c78jh1owxn9wybmfels6d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maatregeltoekenning
    ADD CONSTRAINT fkqax5c78jh1owxn9wybmfels6d FOREIGN KEY (maatregel) REFERENCES public.maatregel(id);


--
-- Name: deelnemermatrix fkqba0wv5o8ecdh0y81v89ku9un; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deelnemermatrix
    ADD CONSTRAINT fkqba0wv5o8ecdh0y81v89ku9un FOREIGN KEY (deelnemer) REFERENCES public.deelnemer(id);


--
-- Name: resultaatstructuur fkqbt5psde2lfr6qoif6uvxfg30; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resultaatstructuur
    ADD CONSTRAINT fkqbt5psde2lfr6qoif6uvxfg30 FOREIGN KEY (auteur) REFERENCES public.medewerker(id);


--
-- Name: intakegesprek fkqc4x0k283ob4vgev33qsix4qo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.intakegesprek
    ADD CONSTRAINT fkqc4x0k283ob4vgev33qsix4qo FOREIGN KEY (gewensteopleiding) REFERENCES public.opleiding(id);


--
-- Name: taalscoreniveauverzameling fkqfi04i8ocvrtkox6sgs3a3f6o; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taalscoreniveauverzameling
    ADD CONSTRAINT fkqfi04i8ocvrtkox6sgs3a3f6o FOREIGN KEY (uitstroom) REFERENCES public.taxonomieelement(id);


--
-- Name: toetsverwijzing fkqg5wp5s49g4tqug79hstllqlo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toetsverwijzing
    ADD CONSTRAINT fkqg5wp5s49g4tqug79hstllqlo FOREIGN KEY (schrijvenin) REFERENCES public.toets(id);


--
-- Name: vrijveldentiteit fkqhdseoc5hl82ncgbapw9ta1lh; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vrijveldentiteit
    ADD CONSTRAINT fkqhdseoc5hl82ncgbapw9ta1lh FOREIGN KEY (onderwijsproduct) REFERENCES public.onderwijsproduct(id);


--
-- Name: maatregel fkqi4vfra8xcmonq8vfc3r47gqb; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maatregel
    ADD CONSTRAINT fkqi4vfra8xcmonq8vfc3r47gqb FOREIGN KEY (organisatieeenheid) REFERENCES public.organisatieeenheid(id);


--
-- Name: persoonlijketoetscode fkqix0vtgvitdnv454ifg462tn6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persoonlijketoetscode
    ADD CONSTRAINT fkqix0vtgvitdnv454ifg462tn6 FOREIGN KEY (medewerker) REFERENCES public.medewerker(id);


--
-- Name: extorgcontactgegeven fkql67mn54hdqr5v01crpvfchvt; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extorgcontactgegeven
    ADD CONSTRAINT fkql67mn54hdqr5v01crpvfchvt FOREIGN KEY (externeorganisatie) REFERENCES public.externeorganisatie(id);


--
-- Name: waarneming fkqo7p7ns8ha2brw5gxp6x7kom2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.waarneming
    ADD CONSTRAINT fkqo7p7ns8ha2brw5gxp6x7kom2 FOREIGN KEY (afspraak) REFERENCES public.afspraak(id);


--
-- Name: grouppropertysetting fkqolwc8q7scvwd29fjv8jh144w; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grouppropertysetting
    ADD CONSTRAINT fkqolwc8q7scvwd29fjv8jh144w FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: deelnemerresultaatversie fkqw6efqm1ah029bm4udvm55drk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deelnemerresultaatversie
    ADD CONSTRAINT fkqw6efqm1ah029bm4udvm55drk FOREIGN KEY (resultaatstructuur) REFERENCES public.resultaatstructuur(id);


--
-- Name: onderwijsproductafnamecontext fkqxvu1e9daiargeh1gjvg30ugv; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproductafnamecontext
    ADD CONSTRAINT fkqxvu1e9daiargeh1gjvg30ugv FOREIGN KEY (productregel) REFERENCES public.productregel(id);


--
-- Name: toets fkr1y98ieail5xb6578t6ln9x25; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toets
    ADD CONSTRAINT fkr1y98ieail5xb6578t6ln9x25 FOREIGN KEY (resultaatstructuur) REFERENCES public.resultaatstructuur(id);


--
-- Name: externeorganisatie fkr2dxbt75e8d0r6e2w0b06rmhv; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.externeorganisatie
    ADD CONSTRAINT fkr2dxbt75e8d0r6e2w0b06rmhv FOREIGN KEY (ondertekeningbpvodoor) REFERENCES public.externeorganisatie(id);


--
-- Name: rapportagetemplate fkr48cmbk38y1q3vgqbfm1h7im5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rapportagetemplate
    ADD CONSTRAINT fkr48cmbk38y1q3vgqbfm1h7im5 FOREIGN KEY (voortgangpdfconfig) REFERENCES public.voortgangpdfconfig(id);


--
-- Name: contactpersoon fkr6e0fsk4m3a2mxtk4joik4xt6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contactpersoon
    ADD CONSTRAINT fkr6e0fsk4m3a2mxtk4joik4xt6 FOREIGN KEY (persoon) REFERENCES public.persoon(id);


--
-- Name: vrijveldentiteit fkr7g8xtpj7io25ouhpnutixkv2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vrijveldentiteit
    ADD CONSTRAINT fkr7g8xtpj7io25ouhpnutixkv2 FOREIGN KEY (intakegesprek) REFERENCES public.intakegesprek(id);


--
-- Name: standaardtoetscodefilter fkr8altejpbw71dtyqgjxsueexo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.standaardtoetscodefilter
    ADD CONSTRAINT fkr8altejpbw71dtyqgjxsueexo FOREIGN KEY (opleiding) REFERENCES public.opleiding(id);


--
-- Name: kenmerk fkraa7c56cu15cprrkww55ccrpm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kenmerk
    ADD CONSTRAINT fkraa7c56cu15cprrkww55ccrpm FOREIGN KEY (categorie) REFERENCES public.kenmerkcategorie(id);


--
-- Name: taxonomieelementtype fkrebib0isqlkv88hghkd282uvg; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxonomieelementtype
    ADD CONSTRAINT fkrebib0isqlkv88hghkd282uvg FOREIGN KEY (taxonomie) REFERENCES public.taxonomieelement(id);


--
-- Name: maatregel fkrehexewd4gr6o2e2supykcu9; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maatregel
    ADD CONSTRAINT fkrehexewd4gr6o2e2supykcu9 FOREIGN KEY (locatie) REFERENCES public.locatie(id);


--
-- Name: curriculum fkreprxojtlgsqc4cmvbk6b41gp; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.curriculum
    ADD CONSTRAINT fkreprxojtlgsqc4cmvbk6b41gp FOREIGN KEY (opleiding) REFERENCES public.opleiding(id);


--
-- Name: ondprodgebruiksmiddel fkrgc6luxa37ursacgy473wl81q; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ondprodgebruiksmiddel
    ADD CONSTRAINT fkrgc6luxa37ursacgy473wl81q FOREIGN KEY (gebruiksmiddel) REFERENCES public.gebruiksmiddel(id);


--
-- Name: competentieniveauverzameling fkrha49gy3m1i72g8jlqw4ufc54; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.competentieniveauverzameling
    ADD CONSTRAINT fkrha49gy3m1i72g8jlqw4ufc54 FOREIGN KEY (medewerker) REFERENCES public.medewerker(id);


--
-- Name: productregel fkrjkna717d5d5puk0x36cvyv50; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productregel
    ADD CONSTRAINT fkrjkna717d5d5puk0x36cvyv50 FOREIGN KEY (soortproductregel) REFERENCES public.soortproductregel(id);


--
-- Name: resultaatstructuurdeelnemer fkrjx2fymb7rlnuw13m45b2oecu; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resultaatstructuurdeelnemer
    ADD CONSTRAINT fkrjx2fymb7rlnuw13m45b2oecu FOREIGN KEY (resultaatstructuur) REFERENCES public.resultaatstructuur(id);


--
-- Name: lesuurindeling fkrm2ux19460afa2u7q89ddr59o; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesuurindeling
    ADD CONSTRAINT fkrm2ux19460afa2u7q89ddr59o FOREIGN KEY (lesdagindeling) REFERENCES public.lesdagindeling(id);


--
-- Name: vertasigdefevconkoppel fkrmbk87310gyx8ur4lje50aa5p; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vertasigdefevconkoppel
    ADD CONSTRAINT fkrmbk87310gyx8ur4lje50aa5p FOREIGN KEY (abonnementconfiguration) REFERENCES public.eventabonnementconfiguration(id);


--
-- Name: documenttemplaterecht fkrninhlklgvus2l5pkbx9jchg3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documenttemplaterecht
    ADD CONSTRAINT fkrninhlklgvus2l5pkbx9jchg3 FOREIGN KEY (documenttemplate) REFERENCES public.documenttemplate(id);


--
-- Name: rapportagetemplate fkrouo64yqfy86gl7qkp879gci3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rapportagetemplate
    ADD CONSTRAINT fkrouo64yqfy86gl7qkp879gci3 FOREIGN KEY (voortganghtmlconfig) REFERENCES public.voortganghtmlconfig(id);


--
-- Name: groep fkrq47dxd25prjnf8dbxyv9lbbj; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groep
    ADD CONSTRAINT fkrq47dxd25prjnf8dbxyv9lbbj FOREIGN KEY (groepstype) REFERENCES public.groepstype(id);


--
-- Name: persoon fkrrjburttouxedjbuyrqeu3r28; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persoon
    ADD CONSTRAINT fkrrjburttouxedjbuyrqeu3r28 FOREIGN KEY (nationaliteit2) REFERENCES public.nationaliteit(id);


--
-- Name: gespreksoort fkrsr39i12c8t6i32goe5o7ptms; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gespreksoort
    ADD CONSTRAINT fkrsr39i12c8t6i32goe5o7ptms FOREIGN KEY (afspraaktype) REFERENCES public.afspraaktype(id);


--
-- Name: onderwijsproductafname fkrtba8somn5fst1wf0yhvidavd; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproductafname
    ADD CONSTRAINT fkrtba8somn5fst1wf0yhvidavd FOREIGN KEY (onderwijsproduct) REFERENCES public.onderwijsproduct(id);


--
-- Name: bpvkandidaatonderwijsproduct fkrv1lgl11hhybh396mbnk3n1a3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvkandidaatonderwijsproduct
    ADD CONSTRAINT fkrv1lgl11hhybh396mbnk3n1a3 FOREIGN KEY (bpvkandidaat) REFERENCES public.bpvkandidaat(id);


--
-- Name: maatregeltoekenning fkrvm22phfe4hqvk0ipghwqvg7j; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maatregeltoekenning
    ADD CONSTRAINT fkrvm22phfe4hqvk0ipghwqvg7j FOREIGN KEY (eigenaardeelnemer) REFERENCES public.deelnemer(id);


--
-- Name: meeteenheidwaarde fkrvqs1tqq8o0p3pne0eo85wod; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.meeteenheidwaarde
    ADD CONSTRAINT fkrvqs1tqq8o0p3pne0eo85wod FOREIGN KEY (meeteenheid) REFERENCES public.meeteenheid(id);


--
-- Name: competentieniveauverzameling fkrwco5wq8xx1gy31yn9f1c6u0f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.competentieniveauverzameling
    ADD CONSTRAINT fkrwco5wq8xx1gy31yn9f1c6u0f FOREIGN KEY (opgenomenin) REFERENCES public.competentieniveauverzameling(id);


--
-- Name: externeagenda fkrwes8sfp5etxb1lj8tqq3g6fl; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.externeagenda
    ADD CONSTRAINT fkrwes8sfp5etxb1lj8tqq3g6fl FOREIGN KEY (koppeling_id) REFERENCES public.externeagendakoppeling(id);


--
-- Name: bpvbedrijfsgegeven fks432vgdlsgnqtc5dle5k5bra6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvbedrijfsgegeven
    ADD CONSTRAINT fks432vgdlsgnqtc5dle5k5bra6 FOREIGN KEY (externeorganisatie) REFERENCES public.externeorganisatie(id);


--
-- Name: contract fks64j2mddprhqrytwckpecrrih; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contract
    ADD CONSTRAINT fks64j2mddprhqrytwckpecrrih FOREIGN KEY (typefinanciering) REFERENCES public.typefinanciering(id);


--
-- Name: taxonomieelement fks7m4k3kqa20jvv09m2uj0wfga; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxonomieelement
    ADD CONSTRAINT fks7m4k3kqa20jvv09m2uj0wfga FOREIGN KEY (parent) REFERENCES public.taxonomieelement(id);


--
-- Name: testcategorie fks8ogdx8pm7vjvi0bhj90hrtmh; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.testcategorie
    ADD CONSTRAINT fks8ogdx8pm7vjvi0bhj90hrtmh FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: bijlageentiteit fks952076dxjfwqvsxdqrammv6a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bijlageentiteit
    ADD CONSTRAINT fks952076dxjfwqvsxdqrammv6a FOREIGN KEY (examendeelname) REFERENCES public.examendeelname(id);


--
-- Name: afspraakdeelnemer fksbcmvc5g4jc5p2wng5d6xtoc3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.afspraakdeelnemer
    ADD CONSTRAINT fksbcmvc5g4jc5p2wng5d6xtoc3 FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: adresentiteit fksbn44ao3l5laq639boy3qnfxq; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adresentiteit
    ADD CONSTRAINT fksbn44ao3l5laq639boy3qnfxq FOREIGN KEY (persoon) REFERENCES public.persoon(id);


--
-- Name: adresentiteit fksd5i1x8fovun9u4n6bpdtyrr8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adresentiteit
    ADD CONSTRAINT fksd5i1x8fovun9u4n6bpdtyrr8 FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: deelnemerpersoonlijkegroep fkshbvpw1h1dgdfo461u153d13x; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deelnemerpersoonlijkegroep
    ADD CONSTRAINT fkshbvpw1h1dgdfo461u153d13x FOREIGN KEY (deelnemer) REFERENCES public.deelnemer(id);


--
-- Name: bekostigingsperiode fksikv2oaugo04k1lrxnmsik5qk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bekostigingsperiode
    ADD CONSTRAINT fksikv2oaugo04k1lrxnmsik5qk FOREIGN KEY (verbintenis) REFERENCES public.verbintenis(id);


--
-- Name: resultaatstructuurmedewerker fkslmwwjeuvfjy0addvt8ma81yf; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resultaatstructuurmedewerker
    ADD CONSTRAINT fkslmwwjeuvfjy0addvt8ma81yf FOREIGN KEY (medewerker) REFERENCES public.medewerker(id);


--
-- Name: externeorganisatiekenmerk fkspxcqqtkt5fchu8kvaa3gk2hm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.externeorganisatiekenmerk
    ADD CONSTRAINT fkspxcqqtkt5fchu8kvaa3gk2hm FOREIGN KEY (kenmerk) REFERENCES public.kenmerk(id);


--
-- Name: irisincidentlocatie fkst1n3bi4whujb2tcqikx2f3me; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.irisincidentlocatie
    ADD CONSTRAINT fkst1n3bi4whujb2tcqikx2f3me FOREIGN KEY (incident) REFERENCES public.irisincident(id);


--
-- Name: afspraak fkstw9xxj5fx7rgmn1vxqb73ol7; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.afspraak
    ADD CONSTRAINT fkstw9xxj5fx7rgmn1vxqb73ol7 FOREIGN KEY (organisatieeenheid) REFERENCES public.organisatieeenheid(id);


--
-- Name: groep fksu3amm1v2ry5cedwljc8p6ovq; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groep
    ADD CONSTRAINT fksu3amm1v2ry5cedwljc8p6ovq FOREIGN KEY (organisatieeenheid) REFERENCES public.organisatieeenheid(id);


--
-- Name: specifiekevraagantwoord fksumwjm24rxqx7op7dwf76vivv; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specifiekevraagantwoord
    ADD CONSTRAINT fksumwjm24rxqx7op7dwf76vivv FOREIGN KEY (specifiekevraag) REFERENCES public.specifiekevraag(id);


--
-- Name: bpvplaatsopleiding fkswi1dof84141ssawykd2plmen; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bpvplaatsopleiding
    ADD CONSTRAINT fkswi1dof84141ssawykd2plmen FOREIGN KEY (bpvplaats) REFERENCES public.bpvplaats(id);


--
-- Name: crohoopleidingaanbod fksxjabelu3n7x71k7esdsmefd4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crohoopleidingaanbod
    ADD CONSTRAINT fksxjabelu3n7x71k7esdsmefd4 FOREIGN KEY (brin) REFERENCES public.externeorganisatie(id);


--
-- Name: onderwijsproduct fksyludofeqhfp9ab7lnbbg2cm5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproduct
    ADD CONSTRAINT fksyludofeqhfp9ab7lnbbg2cm5 FOREIGN KEY (leerstijl) REFERENCES public.leerstijl(id);


--
-- Name: verbintenis fkt0pr6mk710icqkcdd0snx3qo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verbintenis
    ADD CONSTRAINT fkt0pr6mk710icqkcdd0snx3qo FOREIGN KEY (organisatieeenheid) REFERENCES public.organisatieeenheid(id);


--
-- Name: medewerkerdeelnemerabonnering fkt3wl0kvm9x2cb238dcehqlt3g; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medewerkerdeelnemerabonnering
    ADD CONSTRAINT fkt3wl0kvm9x2cb238dcehqlt3g FOREIGN KEY (deelnemer) REFERENCES public.deelnemer(id);


--
-- Name: opleidingfase fkt47tofuct8l8ne21140xrxukb; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.opleidingfase
    ADD CONSTRAINT fkt47tofuct8l8ne21140xrxukb FOREIGN KEY (opleiding) REFERENCES public.opleiding(id);


--
-- Name: trajecttemplate fkt8dlb5psrs4o77rldqw0u1skh; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trajecttemplate
    ADD CONSTRAINT fkt8dlb5psrs4o77rldqw0u1skh FOREIGN KEY (organisatieeenheid) REFERENCES public.organisatieeenheid(id);


--
-- Name: bijlage fktcly2wuoreyvy16uvdik6gmrp; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bijlage
    ADD CONSTRAINT fktcly2wuoreyvy16uvdik6gmrp FOREIGN KEY (documenttype) REFERENCES public.documenttype(id);


--
-- Name: bijlageentiteit fktdxlus0dj998agnfnjq75208a; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bijlageentiteit
    ADD CONSTRAINT fktdxlus0dj998agnfnjq75208a FOREIGN KEY (verbintenis) REFERENCES public.verbintenis(id);


--
-- Name: resultaatstructuurdeelnemer fkte7seg4daj2y81ex3exltgua6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resultaatstructuurdeelnemer
    ADD CONSTRAINT fkte7seg4daj2y81ex3exltgua6 FOREIGN KEY (groep) REFERENCES public.groep(id);


--
-- Name: afspraakdeelnemer fktgviin4v13qdmlcubm790yxgv; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.afspraakdeelnemer
    ADD CONSTRAINT fktgviin4v13qdmlcubm790yxgv FOREIGN KEY (afspraak) REFERENCES public.afspraak(id);


--
-- Name: vrijveldentiteit fktkf1r31ok4dlvbkf06r6w7utw; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vrijveldentiteit
    ADD CONSTRAINT fktkf1r31ok4dlvbkf06r6w7utw FOREIGN KEY (opleiding) REFERENCES public.opleiding(id);


--
-- Name: aanbodperiode fktlaxgq51ov741uus475eiheyl; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aanbodperiode
    ADD CONSTRAINT fktlaxgq51ov741uus475eiheyl FOREIGN KEY (cohort) REFERENCES public.cohort(id);


--
-- Name: verbintenisgebiedonderdeel fktlpn92euc9fwc4w3u2js0si4k; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verbintenisgebiedonderdeel
    ADD CONSTRAINT fktlpn92euc9fwc4w3u2js0si4k FOREIGN KEY (organisatie) REFERENCES public.organisatie(id);


--
-- Name: organisatiesetting fktltm82c5a6pxu517w02h643ae; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisatiesetting
    ADD CONSTRAINT fktltm82c5a6pxu517w02h643ae FOREIGN KEY (account) REFERENCES public.account(id);


--
-- Name: adres fktonl6hhd2byeilqee42r8n88d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adres
    ADD CONSTRAINT fktonl6hhd2byeilqee42r8n88d FOREIGN KEY (gemeente) REFERENCES public.gemeente(id);


--
-- Name: organisatiemedewerker fktq64mhdqnns8cdy47ifclovt8; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisatiemedewerker
    ADD CONSTRAINT fktq64mhdqnns8cdy47ifclovt8 FOREIGN KEY (locatie) REFERENCES public.locatie(id);


--
-- Name: vooropleiding fktrlxxjjot52al0yhoby07hl94; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vooropleiding
    ADD CONSTRAINT fktrlxxjjot52al0yhoby07hl94 FOREIGN KEY (deelnemer) REFERENCES public.deelnemer(id);


--
-- Name: onderwijsproductafnamecontext fktrwr80vxun6jqmtxjdmhte5b3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.onderwijsproductafnamecontext
    ADD CONSTRAINT fktrwr80vxun6jqmtxjdmhte5b3 FOREIGN KEY (verbintenis) REFERENCES public.verbintenis(id);


--
-- Name: abstractrelatie fktsa54ujxe7rn2cf9x6fvun5o; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.abstractrelatie
    ADD CONSTRAINT fktsa54ujxe7rn2cf9x6fvun5o FOREIGN KEY (relatiesoort) REFERENCES public.relatiesoort(id);


--
-- Name: agendainstellingen fkue0lhro7bdvs6u2hlysgsyux; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.agendainstellingen
    ADD CONSTRAINT fkue0lhro7bdvs6u2hlysgsyux FOREIGN KEY (persoon) REFERENCES public.persoon(id);


--
-- Name: olclocatie fkuls12bhwd15yugbvgbc6epbq; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.olclocatie
    ADD CONSTRAINT fkuls12bhwd15yugbvgbc6epbq FOREIGN KEY (organisatieeenheid) REFERENCES public.organisatieeenheid(id);


--
-- Name: verbintenis fkymv7kf8fku8yqlvt6t2jucjf; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verbintenis
    ADD CONSTRAINT fkymv7kf8fku8yqlvt6t2jucjf FOREIGN KEY (redenuitschrijving) REFERENCES public.redenuitschrijving(id);


--
-- PostgreSQL database dump complete
--

\unrestrict nZifXVaB0eWAWGqyeIcqkOSsBLmAbVc1Gqpp3XQL2ZgTsyQT1VqDLsiF22PCbWt

