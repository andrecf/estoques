--
-- PostgreSQL database dump
--

-- Dumped from database version 9.2.3
-- Dumped by pg_dump version 9.2.0
-- Started on 2013-05-04 10:13:31

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 2898 (class 1262 OID 16863)
-- Name: estoque; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE estoque WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'pt_BR.utf8' LC_CTYPE = 'pt_BR.utf8';


ALTER DATABASE estoque OWNER TO postgres;

\connect estoque

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 185 (class 3079 OID 16864)
-- Name: plperl; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plperl WITH SCHEMA pg_catalog;


--
-- TOC entry 2900 (class 0 OID 0)
-- Dependencies: 185
-- Name: EXTENSION plperl; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plperl IS 'PL/Perl procedural language';


--
-- TOC entry 184 (class 3079 OID 16869)
-- Name: plperlu; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plperlu WITH SCHEMA pg_catalog;


--
-- TOC entry 2901 (class 0 OID 0)
-- Dependencies: 184
-- Name: EXTENSION plperlu; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plperlu IS 'PL/PerlU untrusted procedural language';


--
-- TOC entry 186 (class 3079 OID 12322)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2902 (class 0 OID 0)
-- Dependencies: 186
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 183 (class 3079 OID 16876)
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- TOC entry 2903 (class 0 OID 0)
-- Dependencies: 183
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


--
-- TOC entry 192 (class 3079 OID 16885)
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- TOC entry 2904 (class 0 OID 0)
-- Dependencies: 192
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- TOC entry 191 (class 3079 OID 17002)
-- Name: insert_username; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS insert_username WITH SCHEMA public;


--
-- TOC entry 2905 (class 0 OID 0)
-- Dependencies: 191
-- Name: EXTENSION insert_username; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION insert_username IS 'functions for tracking who changed a table';


--
-- TOC entry 190 (class 3079 OID 17004)
-- Name: ltree; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS ltree WITH SCHEMA public;


--
-- TOC entry 2906 (class 0 OID 0)
-- Dependencies: 190
-- Name: EXTENSION ltree; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION ltree IS 'data type for hierarchical tree-like structures';


--
-- TOC entry 189 (class 3079 OID 17179)
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- TOC entry 2907 (class 0 OID 0)
-- Dependencies: 189
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track execution statistics of all SQL statements executed';


--
-- TOC entry 188 (class 3079 OID 17186)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- TOC entry 2908 (class 0 OID 0)
-- Dependencies: 188
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- TOC entry 187 (class 3079 OID 17290)
-- Name: pldbgapi; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pldbgapi WITH SCHEMA public;


--
-- TOC entry 2909 (class 0 OID 0)
-- Dependencies: 187
-- Name: EXTENSION pldbgapi; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pldbgapi IS 'server-side support for debugging PL/pgSQL functions';


SET search_path = public, pg_catalog;

--
-- TOC entry 386 (class 1255 OID 17332)
-- Name: andre(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION andre(entrou integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$begin 
return entrou*4;
end$$;


ALTER FUNCTION public.andre(entrou integer) OWNER TO postgres;

--
-- TOC entry 364 (class 1255 OID 17220)
-- Name: show_table_opts(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION show_table_opts(schemaname text, relname text) RETURNS TABLE(nspname name, relname name, relopts text)
    LANGUAGE sql
    AS $_$
SELECT n.nspname, c.relname,
pg_catalog.array_to_string(c.reloptions || array(
select 'toast.' ||
x from pg_catalog.unnest(tc.reloptions) x),', ')
as relopts
FROM pg_catalog.pg_class c LEFT JOIN
pg_catalog.pg_class tc ON (c.reltoastrelid = tc.oid)
JOIN
pg_namespace n ON c.relnamespace = n.oid
WHERE c.relkind = 'r'
AND nspname = $1
AND c.relname = $2
;
$_$;


ALTER FUNCTION public.show_table_opts(schemaname text, relname text) OWNER TO postgres;

--
-- TOC entry 169 (class 1259 OID 17221)
-- Name: av_needed; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW av_needed AS
    SELECT av.relation, av.n_tup_ins, av.n_tup_upd, av.n_tup_del, av.hot_update_ratio, av.n_live_tup, av.n_dead_tup, av.reltuples, av.av_threshold, av.last_vacuum, av.last_analyze, ((av.n_dead_tup)::double precision > av.av_threshold) AS av_needed, CASE WHEN (av.reltuples > (0)::double precision) THEN round((((100.0 * (av.n_dead_tup)::numeric))::double precision / av.reltuples)) ELSE (0)::double precision END AS pct_dead FROM (SELECT (((n.nspname)::text || '.'::text) || (c.relname)::text) AS relation, pg_stat_get_tuples_inserted(c.oid) AS n_tup_ins, pg_stat_get_tuples_updated(c.oid) AS n_tup_upd, pg_stat_get_tuples_deleted(c.oid) AS n_tup_del, CASE WHEN (pg_stat_get_tuples_updated(c.oid) > 0) THEN ((pg_stat_get_tuples_hot_updated(c.oid))::real / (pg_stat_get_tuples_updated(c.oid))::double precision) ELSE (0)::double precision END AS hot_update_ratio, pg_stat_get_live_tuples(c.oid) AS n_live_tup, pg_stat_get_dead_tuples(c.oid) AS n_dead_tup, c.reltuples, round((((current_setting('autovacuum_vacuum_threshold'::text))::integer)::double precision + (((current_setting('autovacuum_vacuum_scale_factor'::text))::numeric)::double precision * c.reltuples))) AS av_threshold, date_trunc('minute'::text, GREATEST(pg_stat_get_last_vacuum_time(c.oid), pg_stat_get_last_autovacuum_time(c.oid))) AS last_vacuum, date_trunc('minute'::text, GREATEST(pg_stat_get_last_analyze_time(c.oid), pg_stat_get_last_analyze_time(c.oid))) AS last_analyze FROM ((pg_class c LEFT JOIN pg_index i ON ((c.oid = i.indrelid))) LEFT JOIN pg_namespace n ON ((n.oid = c.relnamespace))) WHERE (((c.relkind = ANY (ARRAY['r'::"char", 't'::"char"])) AND (n.nspname <> ALL (ARRAY['pg_catalog'::name, 'information_schema'::name]))) AND (n.nspname !~ '^pg_toast'::text))) av ORDER BY ((av.n_dead_tup)::double precision > av.av_threshold) DESC, av.n_dead_tup DESC;


ALTER TABLE public.av_needed OWNER TO postgres;

SET default_with_oids = true;

--
-- TOC entry 170 (class 1259 OID 17226)
-- Name: categoria; Type: TABLE; Schema: public; Owner: andre
--

CREATE TABLE categoria (
    categoria character varying(50) NOT NULL
);


ALTER TABLE public.categoria OWNER TO andre;

--
-- TOC entry 171 (class 1259 OID 17229)
-- Name: estoque; Type: TABLE; Schema: public; Owner: andre
--

CREATE TABLE estoque (
    quantidade integer DEFAULT 0 NOT NULL,
    local_local character varying(100),
    produto_produto character varying(120)
);


ALTER TABLE public.estoque OWNER TO andre;

--
-- TOC entry 172 (class 1259 OID 17233)
-- Name: indexes_not_stored_with_tables; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW indexes_not_stored_with_tables AS
    SELECT i.relname AS indexname, tsi.spcname AS index_spcname, t.relname AS tablename, tst.spcname AS table_spcname FROM ((((pg_class t JOIN pg_tablespace tst ON ((t.reltablespace = tst.oid))) JOIN pg_index pgi ON ((pgi.indrelid = t.oid))) JOIN pg_class i ON ((pgi.indexrelid = i.oid))) JOIN pg_tablespace tsi ON ((i.reltablespace = tsi.oid))) WHERE ((i.relname !~~ 'pg_toast%'::text) AND (i.reltablespace <> t.reltablespace));


ALTER TABLE public.indexes_not_stored_with_tables OWNER TO postgres;

--
-- TOC entry 173 (class 1259 OID 17238)
-- Name: local; Type: TABLE; Schema: public; Owner: andre
--

CREATE TABLE local (
    local character varying(100) NOT NULL
);


ALTER TABLE public.local OWNER TO andre;

--
-- TOC entry 174 (class 1259 OID 17241)
-- Name: produto; Type: TABLE; Schema: public; Owner: andre
--

CREATE TABLE produto (
    produto character varying(120) NOT NULL,
    quantidade_minima integer DEFAULT 1 NOT NULL,
    categoria_categoria character varying(50),
    unidade_unidade_medida character varying(50)
);


ALTER TABLE public.produto OWNER TO andre;

--
-- TOC entry 175 (class 1259 OID 17245)
-- Name: unidade_medida; Type: TABLE; Schema: public; Owner: andre
--

CREATE TABLE unidade_medida (
    unidade character varying(50) NOT NULL
);


ALTER TABLE public.unidade_medida OWNER TO andre;

--
-- TOC entry 176 (class 1259 OID 17248)
-- Name: user_tablespace_objects; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW user_tablespace_objects AS
    SELECT ts.spcname, c.relname, CASE WHEN (c.relkind = 'r'::"char") THEN 'table'::text WHEN (c.relkind = 'v'::"char") THEN 'view'::text WHEN (c.relkind = 'S'::"char") THEN 'sequence'::text WHEN (c.relkind = 'c'::"char") THEN 'type'::text ELSE 'index'::text END AS objtype FROM (pg_class c JOIN pg_tablespace ts ON ((CASE WHEN (c.reltablespace = (0)::oid) THEN (SELECT pg_database.dattablespace FROM pg_database WHERE (pg_database.datname = current_database())) ELSE c.reltablespace END = ts.oid))) WHERE ((c.relname !~~ 'pg_toast%'::text) AND (NOT (c.relnamespace IN (SELECT pg_namespace.oid FROM pg_namespace WHERE (pg_namespace.nspname = ANY (ARRAY['pg_catalog'::name, 'information_schema'::name]))))));


ALTER TABLE public.user_tablespace_objects OWNER TO postgres;

SET default_with_oids = false;

--
-- TOC entry 177 (class 1259 OID 17253)
-- Name: usuario; Type: TABLE; Schema: public; Owner: andre
--

CREATE TABLE usuario (
    usuario character varying(100) NOT NULL,
    senha text NOT NULL,
    ativo boolean DEFAULT true NOT NULL
);


ALTER TABLE public.usuario OWNER TO andre;

--
-- TOC entry 2888 (class 0 OID 17226)
-- Dependencies: 170
-- Data for Name: categoria; Type: TABLE DATA; Schema: public; Owner: andre
--



--
-- TOC entry 2889 (class 0 OID 17229)
-- Dependencies: 171
-- Data for Name: estoque; Type: TABLE DATA; Schema: public; Owner: andre
--



--
-- TOC entry 2890 (class 0 OID 17238)
-- Dependencies: 173
-- Data for Name: local; Type: TABLE DATA; Schema: public; Owner: andre
--



--
-- TOC entry 2891 (class 0 OID 17241)
-- Dependencies: 174
-- Data for Name: produto; Type: TABLE DATA; Schema: public; Owner: andre
--



--
-- TOC entry 2892 (class 0 OID 17245)
-- Dependencies: 175
-- Data for Name: unidade_medida; Type: TABLE DATA; Schema: public; Owner: andre
--



--
-- TOC entry 2893 (class 0 OID 17253)
-- Dependencies: 177
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: andre
--

--INSERT INTO usuario (usuario, senha, ativo) VALUES ('user1', '$1$AmmupcBr$3r8T92eJWuGsamnUQebY20', true);


--
-- TOC entry 2875 (class 2606 OID 17261)
-- Name: pk_categoria; Type: CONSTRAINT; Schema: public; Owner: andre
--

ALTER TABLE ONLY categoria
    ADD CONSTRAINT pk_categoria PRIMARY KEY (categoria);


--
-- TOC entry 2877 (class 2606 OID 17263)
-- Name: pk_local; Type: CONSTRAINT; Schema: public; Owner: andre
--

ALTER TABLE ONLY local
    ADD CONSTRAINT pk_local PRIMARY KEY (local);


--
-- TOC entry 2879 (class 2606 OID 17265)
-- Name: pk_produto; Type: CONSTRAINT; Schema: public; Owner: andre
--

ALTER TABLE ONLY produto
    ADD CONSTRAINT pk_produto PRIMARY KEY (produto);


--
-- TOC entry 2881 (class 2606 OID 17267)
-- Name: pk_unidade_medida; Type: CONSTRAINT; Schema: public; Owner: andre
--

ALTER TABLE ONLY unidade_medida
    ADD CONSTRAINT pk_unidade_medida PRIMARY KEY (unidade);


--
-- TOC entry 2883 (class 2606 OID 17269)
-- Name: usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: andre
--

ALTER TABLE ONLY usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (usuario);


--
-- TOC entry 2886 (class 2606 OID 17270)
-- Name: categoria_fk; Type: FK CONSTRAINT; Schema: public; Owner: andre
--

ALTER TABLE ONLY produto
    ADD CONSTRAINT categoria_fk FOREIGN KEY (categoria_categoria) REFERENCES categoria(categoria) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 2884 (class 2606 OID 17275)
-- Name: local_fk; Type: FK CONSTRAINT; Schema: public; Owner: andre
--

ALTER TABLE ONLY estoque
    ADD CONSTRAINT local_fk FOREIGN KEY (local_local) REFERENCES local(local) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 2885 (class 2606 OID 17280)
-- Name: produto_fk; Type: FK CONSTRAINT; Schema: public; Owner: andre
--

ALTER TABLE ONLY estoque
    ADD CONSTRAINT produto_fk FOREIGN KEY (produto_produto) REFERENCES produto(produto) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 2887 (class 2606 OID 17285)
-- Name: unidade_medida_fk; Type: FK CONSTRAINT; Schema: public; Owner: andre
--

ALTER TABLE ONLY produto
    ADD CONSTRAINT unidade_medida_fk FOREIGN KEY (unidade_unidade_medida) REFERENCES unidade_medida(unidade) MATCH FULL ON UPDATE CASCADE ON DELETE SET NULL;


-- Completed on 2013-05-04 10:13:52

--
-- PostgreSQL database dump complete
--

