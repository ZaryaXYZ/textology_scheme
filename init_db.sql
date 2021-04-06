/* TEKSTUJO INTERNACIO ĜENERALA PROEKTO DE DATUMBAZO */

CREATE DATABASE textology OWNER paupers;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE "Lingva familioj"
(
    "Kodo" int PRIMARY KEY,
    "Nomo" varchar(32) NOT NULL
);

CREATE TABLE "Lingvoj"
(
    "ISO 639-3"      char(3) PRIMARY KEY,
    "Nomo originala" text NOT NULL,
    "Nomo"           text,
    "Familio"        int  NOT NULL,
    "ISO 639-1"      char(2),
    CONSTRAINT Lingvoj_Lingva_familioj_FK FOREIGN KEY ("Familio") REFERENCES "Lingva familioj" ("Kodo")
);

CREATE TABLE "Eldonejoj"
(
    "Kodo"                     uuid        NOT NULL DEFAULT uuid_generate_v4(),
    "Loko"                     text        NOT NULL,
    "Nomo internacia"          text        NOT NULL,
    "Loko OSM"                 varchar NULL,
    "Originala lingvo de nomo" varchar(3)  NOT NULL,
    "Uzanto"                   varchar(64) NOT NULL DEFAULT user,
    "Tempo"                    timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT "Eldonejoj_pk" PRIMARY KEY ("Kodo"),
    CONSTRAINT "Eldonejoj_Lingvoj_FK" FOREIGN KEY ("Originala lingvo de nomo") REFERENCES "Lingvoj" ("ISO 639-3")
);

CREATE TABLE "Eldonejoj - nomoj"
(
    "Eldonejo" uuid       NOT NULL,
    "Lingvo"   varchar(3) NOT NULL,
    "Nomo"     text       NOT NULL,
    CONSTRAINT "Eldonejoj_nomoj_pk" PRIMARY KEY ("Eldonejo", "Lingvo"),
    CONSTRAINT "Eldonejoj_nomoj_Eldonejoj_FK" FOREIGN KEY ("Eldonejo") REFERENCES "Eldonejoj" ("Kodo"),
    CONSTRAINT "Eldonejoj_nomoj_Lingvoj_FK" FOREIGN KEY ("Lingvo") REFERENCES "Lingvoj" ("ISO 639-3")
);

CREATE TABLE "Libroj"
(
    "Kodo"                    uuid        NOT NULL DEFAULT uuid_generate_v4(),
    "Nomo originalo - lingvo" varchar(3)  NOT NULL,
    "ISBN"                    varchar(32) NULL,
    "Publikacio"              date        NOT NULL,
    "Numero de eldono"        int2        NOT NULL DEFAULT 1,
    "Uzanto"                  varchar(64) NOT NULL DEFAULT user,
    "Tempo"                   timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT "Libroj_pk" PRIMARY KEY ("Kodo"),
    CONSTRAINT "Libroj_Lingvoj_FK" FOREIGN KEY ("Nomo originalo - lingvo") REFERENCES "Lingvoj" ("ISO 639-3")
);

CREATE TABLE "Libroj - nomoj"
(
    "Libro"  uuid        NOT NULL,
    "Lingvo" varchar(3)  NOT NULL,
    "Nomo"   text        NOT NULL,
    "Uzanto" varchar(64) NOT NULL DEFAULT user,
    "Tempo"  timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT "Libroj_nomoj_pk" PRIMARY KEY ("Libro", "Lingvo"),
    CONSTRAINT "Libroj_nomoj_Libroj_FK" FOREIGN KEY ("Libro") REFERENCES "Libroj" ("Kodo"),
    CONSTRAINT "Libroj_nomoj_Lingvoj_FK" FOREIGN KEY ("Lingvo") REFERENCES "Lingvoj" ("ISO 639-3")
);

CREATE TABLE "Libroj - paĝoj"
(
    "Kodo"   uuid        NOT NULL DEFAULT uuid_generate_v4(),
    "Libro"  uuid        NOT NULL,
    "Numero" varchar(16) NULL,
    "Uzanto" varchar(64) NOT NULL DEFAULT user,
    "Tempo"  timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT "Libroj_paĝoj_pk" PRIMARY KEY ("Kodo"),
    CONSTRAINT "Libroj_paĝoj_Libroj_FK" FOREIGN KEY ("Libro") REFERENCES "Libroj" ("Kodo")
);

CREATE TABLE "Aŭtoroj"
(
    "Kodo"                    uuid        NOT NULL DEFAULT uuid_generate_v4(),
    "Nomo originalo - lingvo" varchar(3)  NOT NULL,
    "Naskiĝo"                 date        NOT NULL,
    "Morto"                   date        NOT NULL,
    "Deskripcio"              text        NOT NULL,
    "Uzanto"                  varchar(64) NOT NULL DEFAULT user,
    "Tempo"                   timestamptz NOT NULL DEFAULT now(),
    "Foto generala"           bytea NULL,
    CONSTRAINT "Aŭtoroj_pk" PRIMARY KEY ("Kodo"),
    CONSTRAINT "Aŭtoroj_Lingvoj_FK" FOREIGN KEY ("Nomo originalo - lingvo") REFERENCES "Lingvoj" ("ISO 639-3")
);

CREATE TABLE "Aŭtoroj - nomoj"
(
    "Aŭtoro"           uuid        NOT NULL,
    "Lingvo"           varchar(3)  NOT NULL,
    "Nomo"             text        NOT NULL,
    "Familinomo"       text NULL,
    "Alianomoj"        text NULL,
    "Pseŭdonomo"       bool,
    "Adreso vikipedia" text,
    "Uzanto"           varchar(64) NOT NULL DEFAULT user,
    "Tempo"            timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT "Aŭtoroj_nomoj_pk" PRIMARY KEY ("Aŭtoro", "Lingvo"),
    CONSTRAINT "Aŭtoroj_nomoj_Aŭtoroj_FK" FOREIGN KEY ("Aŭtoro") REFERENCES "Aŭtoroj" ("Kodo"),
    CONSTRAINT "Aŭtoroj_nomoj_Lingvoj_FK" FOREIGN KEY ("Lingvo") REFERENCES "Lingvoj" ("ISO 639-3")
);

CREATE TABLE "Eldono"
(
    "Eldonejo" uuid        NOT NULL,
    "Libro"    uuid        NOT NULL,
    "Uzanto"   varchar(64) NOT NULL DEFAULT user,
    "Tempo"    timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT "Eldono_Eldonejoj_FK" FOREIGN KEY ("Eldonejo") REFERENCES "Eldonejoj" ("Kodo"),
    CONSTRAINT "Eldono_Libroj_FK" FOREIGN KEY ("Libro") REFERENCES "Libroj" ("Kodo")
);

CREATE TABLE "Aŭtoreco kun libro"
(
    "Aŭtoro" uuid        NOT NULL,
    "Libro"  uuid        NOT NULL,
    "Uzanto" varchar(64) NOT NULL DEFAULT user,
    "Tempo"  timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT "Eldono_Aŭtoroj_FK" FOREIGN KEY ("Aŭtoro") REFERENCES "Aŭtoroj" ("Kodo"),
    CONSTRAINT "Eldono_Libroj_FK" FOREIGN KEY ("Libro") REFERENCES "Libroj" ("Kodo")
);

CREATE TABLE "Laboroj"
(
    "Kodo"                    uuid        NOT NULL DEFAULT uuid_generate_v4(),
    "Nomo originalo - lingvo" varchar(3)  NOT NULL,
    "Publikacio"              date        NOT NULL,
    "Libro"                   uuid,
    "Uzanto"                  varchar(64) NOT NULL DEFAULT user,
    "Tempo"                   timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT "Laboroj_pk" PRIMARY KEY ("Kodo"),
    CONSTRAINT "Laboroj_Lingvoj_FK" FOREIGN KEY ("Nomo originalo - lingvo") REFERENCES "Lingvoj" ("ISO 639-3"),
    CONSTRAINT "Laboroj_Libroj_FK" FOREIGN KEY ("Libro") REFERENCES "Libroj" ("Kodo")
);

CREATE TABLE "Laboroj - nomoj"
(
    "Laboro" uuid        NOT NULL,
    "Lingvo" varchar(3)  NOT NULL,
    "Nomo"   text        NOT NULL,
    "Uzanto" varchar(64) NOT NULL DEFAULT user,
    "Tempo"  timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT "Laboroj_nomoj_pk" PRIMARY KEY ("Laboro", "Lingvo"),
    CONSTRAINT "Laboroj_nomoj_Laboroj_FK" FOREIGN KEY ("Laboro") REFERENCES "Laboroj" ("Kodo"),
    CONSTRAINT "Laboroj_nomoj_Lingvoj_FK" FOREIGN KEY ("Lingvo") REFERENCES "Lingvoj" ("ISO 639-3")
);

CREATE TABLE "Laboroj - originaloj"
(
    "Laboro"    uuid        NOT NULL,
    "Originalo" uuid        NOT NULL,
    "Lingvo"    varchar(3)  NOT NULL,
    "Uzanto"    varchar(64) NOT NULL DEFAULT user,
    "Tempo"     timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT "Laboroj_originaloj_pk" PRIMARY KEY ("Lingvo", "Originalo"),
    CONSTRAINT "Laboroj_originaloj_Lingvoj_FK" FOREIGN KEY ("Lingvo") REFERENCES "Lingvoj" ("ISO 639-3"),
    CONSTRAINT "Laboroj_originaloj_Laboroj_FK" FOREIGN KEY ("Laboro") REFERENCES "Laboroj" ("Kodo"),
    CONSTRAINT "Laboroj_originaloj_Laboroj_FK_1" FOREIGN KEY ("Originalo") REFERENCES "Laboroj" ("Kodo")
);

CREATE TABLE "Aŭtoreco kun laboro"
(
    "Aŭtoro" uuid        NOT NULL,
    "Laboro" uuid        NOT NULL,
    "Uzanto" varchar(64) NOT NULL DEFAULT user,
    "Tempo"  timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT "Eldono_Aŭtoroj_FK" FOREIGN KEY ("Aŭtoro") REFERENCES "Aŭtoroj" ("Kodo"),
    CONSTRAINT "Eldono_Laboroj_FK" FOREIGN KEY ("Laboro") REFERENCES "Laboroj" ("Kodo")
);

/* CSS */
CREATE TABLE "Dizajnoj"
(
    "Kodo"    serial      NOT NULL,
    "Etikedo" varchar(32) NOT NULL,
    "Klaso"   varchar(64),
    "Komento" text,
    "Uzanto"  varchar(64) NOT NULL DEFAULT user,
    "Tempo"   timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT "Dizajnoj_pk" PRIMARY KEY ("Kodo"),
    CONSTRAINT "Dizajnoj_uq" UNIQUE ("Etikedo", "Klaso")
);

CREATE TABLE "Dizajnoj - elementoj"
(
    "Kodo"     serial      NOT NULL,
    "Dizajno"  int         NOT NULL,
    "Atributo" varchar(64),
    "Valoro"   varchar(64),
    "Uzanto"   varchar(64) NOT NULL DEFAULT user,
    "Tempo"    timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT "Dizajnoj_elementoj_pk" PRIMARY KEY ("Kodo"),
    CONSTRAINT "Dizajnoj_elementoj_Dizajnoj_FK" FOREIGN KEY ("Dizajno") REFERENCES "Dizajnoj" ("Kodo")
);

/* PARAGRAFOJ */
CREATE TABLE "Paragrafoj"
(
    "Kodo"    uuid        NOT NULL DEFAULT uuid_generate_v4(),
    "Laboro"  uuid        NOT NULL,
    "Etikedo" varchar(32) NOT NULL,
    "Klaso"   varchar(64) NULL,
    "Interno" text NULL,
    "Uzanto"  varchar(64) NOT NULL DEFAULT user,
    "Tempo"   timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT "Paragrafoj_pk" PRIMARY KEY ("Kodo"),
    CONSTRAINT "Paragrafoj_Dizajnoj_FK" FOREIGN KEY ("Etikedo", "Klaso") REFERENCES "Dizajnoj" ("Etikedo", "Klaso"),
    CONSTRAINT "Paragrafoj_Laboroj_FK" FOREIGN KEY ("Laboro") REFERENCES "Laboroj" ("Kodo")
);

CREATE TABLE "Paragrafoj - ĉenoj"
(
    "Antaŭa" uuid        NOT NULL,
    "Sekva"  uuid        NOT NULL,
    "Uzanto" varchar(64) NOT NULL DEFAULT user,
    "Tempo"  timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT "Paragrafoj_ĉenoj_Paragrafoj_FK" FOREIGN KEY ("Antaŭa") REFERENCES "Paragrafoj" ("Kodo"),
    CONSTRAINT "Paragrafoj_ĉenoj_Paragrafoj_FK_1" FOREIGN KEY ("Sekva") REFERENCES "Paragrafoj" ("Kodo")
);

CREATE TABLE "Paragrafoj - notoj"
(
    "Paragrafo"   uuid        NOT NULL,
    "Aŭtora"      bool        NOT NULL,
    "Kodo_de_Div" text        NOT NULL,
    "Uzanto"      varchar(64) NOT NULL DEFAULT user,
    "Tempo"       timestamptz NOT NULL DEFAULT now(),
    "Fonto"       uuid        NOT NULL,
    CONSTRAINT "Paragrafoj_notoj_Paragrafoj_FK" FOREIGN KEY ("Paragrafo") REFERENCES "Paragrafoj" ("Kodo"),
    CONSTRAINT "Paragrafoj_notoj_Paragrafoj_FK1" FOREIGN KEY ("Fonto") REFERENCES "Paragrafoj" ("Kodo")
);

CREATE TABLE "Paragrafoj - originaloj"
(
    "Paragrafo" uuid        NOT NULL,
    "Originalo" uuid        NOT NULL,
    "Lingvo"    varchar(3)  NOT NULL,
    "Uzanto"    varchar(64) NOT NULL DEFAULT user,
    "Tempo"     timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT "Paragrafoj_originaloj_pk" PRIMARY KEY ("Lingvo", "Originalo"),
    CONSTRAINT "Paragrafoj_originaloj_Lingvoj_FK" FOREIGN KEY ("Lingvo") REFERENCES "Lingvoj" ("ISO 639-3"),
    CONSTRAINT "Paragrafoj_originaloj_Paragrafoj_FK" FOREIGN KEY ("Paragrafo") REFERENCES "Paragrafoj" ("Kodo"),
    CONSTRAINT "Paragrafoj_originaloj_Paragrafoj_FK_1" FOREIGN KEY ("Originalo") REFERENCES "Paragrafoj" ("Kodo")
);

CREATE TABLE "Paragrafoj - paĝoj"
(
    "Paragrafo" uuid        NOT NULL,
    "Paĝo"      uuid        NOT NULL,
    "Uzanto"    varchar(64) NOT NULL DEFAULT user,
    "Tempo"     timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT "Paragrafoj_paĝoj_Libroj_paĝoj_FK" FOREIGN KEY ("Paĝo") REFERENCES "Libroj - paĝoj" ("Kodo"),
    CONSTRAINT "Paragrafoj_paĝoj_Paragrafoj_FK" FOREIGN KEY ("Paragrafo") REFERENCES "Paragrafoj" ("Kodo")
);

-- insert lingva familioj
INSERT INTO "Lingva familioj" ("Kodo", "Nomo")
VALUES (1, 'Nigera-Konga');
INSERT INTO "Lingva familioj" ("Kodo", "Nomo")
VALUES (2, 'Dravidana');
INSERT INTO "Lingva familioj" ("Kodo", "Nomo")
VALUES (3, 'Kreola');
INSERT INTO "Lingva familioj" ("Kodo", "Nomo")
VALUES (4, 'Turka');
INSERT INTO "Lingva familioj" ("Kodo", "Nomo")
VALUES (5, 'Aŭstroasia');
INSERT INTO "Lingva familioj" ("Kodo", "Nomo")
VALUES (6, 'Tupia');
INSERT INTO "Lingva familioj" ("Kodo", "Nomo")
VALUES (7, 'Nordokcidenta Kaŭkaza');
INSERT INTO "Lingva familioj" ("Kodo", "Nomo")
VALUES (8, 'Izolita lingvoj');
INSERT INTO "Lingva familioj" ("Kodo", "Nomo")
VALUES (9, 'Sina-Tibeta');
INSERT INTO "Lingva familioj" ("Kodo", "Nomo")
VALUES (10, 'Hindeŭropa');
INSERT INTO "Lingva familioj" ("Kodo", "Nomo")
VALUES (11, 'Nila-Sahara');
INSERT INTO "Lingva familioj" ("Kodo", "Nomo")
VALUES (12, 'Keĉua');
INSERT INTO "Lingva familioj" ("Kodo", "Nomo")
VALUES (13, 'Afra-Asia');
INSERT INTO "Lingva familioj" ("Kodo", "Nomo")
VALUES (14, 'Tehnika');
INSERT INTO "Lingva familioj" ("Kodo", "Nomo")
VALUES (15, 'Suda Kaŭkaza');
INSERT INTO "Lingva familioj" ("Kodo", "Nomo")
VALUES (16, 'Eskimo-Aleŭta');
INSERT INTO "Lingva familioj" ("Kodo", "Nomo")
VALUES (17, 'Mongola');
INSERT INTO "Lingva familioj" ("Kodo", "Nomo")
VALUES (18, 'Nordorienta Kaŭkaza');
INSERT INTO "Lingva familioj" ("Kodo", "Nomo")
VALUES (19, 'Japona');
INSERT INTO "Lingva familioj" ("Kodo", "Nomo")
VALUES (20, 'Ajmara');
INSERT INTO "Lingva familioj" ("Kodo", "Nomo")
VALUES (21, 'Korea');
INSERT INTO "Lingva familioj" ("Kodo", "Nomo")
VALUES (22, 'Dené-Eniseia');
INSERT INTO "Lingva familioj" ("Kodo", "Nomo")
VALUES (23, 'Aŭstronesia');
INSERT INTO "Lingva familioj" ("Kodo", "Nomo")
VALUES (24, 'Tai-Kadai');
INSERT INTO "Lingva familioj" ("Kodo", "Nomo")
VALUES (25, 'Uralika');
INSERT INTO "Lingva familioj" ("Kodo", "Nomo")
VALUES (26, 'Algonkia');
--

-- basic languages
INSERT INTO "Lingvoj" ("Nomo originala", "Nomo", "Familio", "ISO 639-1", "ISO 639-3")
VALUES ('Deutsch', 'Germana', 10, 'de', 'deu')
     , ('Русский', 'Rusa', 10, 'ru', 'rus')
     , ('Español', 'Hispana', 10, 'es', 'spa')
     , ('Українська', 'Ukraina', 10, 'uk', 'ukr')
     , ('język polski, polszczyzna', 'Polona', 10, 'pl', 'pol')
     , ('latine, lingua latina', 'Latina', 10, 'la', 'lat');

-- other languages
INSERT INTO "Lingvoj" ("Nomo originala", "Nomo", "Familio", "ISO 639-1", "ISO 639-3")
VALUES ('Afaraf', NULL, 13, 'aa', 'aar')
     , ('аҧсуа бызшәа, аҧсшәа', NULL, 7, 'ab', 'abk')
     , ('Afrikaans', NULL, 10, 'af', 'afr')
     , ('Akan', NULL, 1, 'ak', 'aka')
     , ('አማርኛ', NULL, 13, 'am', 'amh')
     , ('العربية', NULL, 13, 'ar', 'ara')
     , ('aragonés', NULL, 10, 'an', 'arg')
     , ('অসমীয়া', NULL, 10, 'as', 'asm')
     , ('авар мацӀ, магӀарул мацӀ', NULL, 18, 'av', 'ava')
     , ('avesta', NULL, 10, 'ae', 'ave')
     , ('aymar aru', NULL, 20, 'ay', 'aym')
     , ('azərbaycan dili', NULL, 4, 'az', 'aze')
     , ('башҡорт теле', NULL, 4, 'ba', 'bak')
     , ('bamanankan', NULL, 1, 'bm', 'bam')
     , ('беларуская мова', NULL, 10, 'be', 'bel')
     , ('বাংলা', NULL, 10, 'bn', 'ben')
     , ('Bislama', NULL, 3, 'bi', 'bis')
     , ('བོད་ཡིག', NULL, 9, 'bo', 'bod')
     , ('bosanski jezik', NULL, 10, 'bs', 'bos')
     , ('brezhoneg', NULL, 10, 'br', 'bre')
     , ('български език', NULL, 10, 'bg', 'bul')
     , ('català, valencià', NULL, 10, 'ca', 'cat')
     , ('čeština, český jazyk', NULL, 10, 'cs', 'ces')
     , ('Chamoru', NULL, 23, 'ch', 'cha')
     , ('нохчийн мотт', NULL, 18, 'ce', 'che')
     , ('ѩзыкъ словѣньскъ', NULL, 10, 'cu', 'chu')
     , ('чӑваш чӗлхи', NULL, 4, 'cv', 'chv')
     , ('Kernewek', NULL, 10, 'kw', 'cor')
     , ('corsu, lingua corsa', NULL, 10, 'co', 'cos')
     , ('ᓀᐦᐃᔭᐍᐏᐣ', NULL, 26, 'cr', 'cre')
     , ('Cymraeg', NULL, 10, 'cy', 'cym')
     , ('dansk', NULL, 10, 'da', 'dan')
     , ('ދިވެހި', NULL, 10, 'dv', 'div')
     , ('རྫོང་ཁ', NULL, 9, 'dz', 'dzo')
     , ('eesti, eesti keel', NULL, 25, 'et', 'est')
     , ('euskara, euskera', NULL, 8, 'eu', 'eus')
     , ('Eʋegbe', NULL, 1, 'ee', 'ewe')
     , ('føroyskt', NULL, 10, 'fo', 'fao')
     , ('فارسی', NULL, 10, 'fa', 'fas')
     , ('vosa Vakaviti', NULL, 23, 'fj', 'fij')
     , ('suomi, suomen kieli', NULL, 25, 'fi', 'fin')
     , ('Frysk', NULL, 10, 'fy', 'fry')
     , ('Fulfulde, Pulaar, Pular', NULL, 1, 'ff', 'ful')
     , ('Gàidhlig', NULL, 10, 'gd', 'gla')
     , ('Gaeilge', NULL, 10, 'ga', 'gle')
     , ('Galego', NULL, 10, 'gl', 'glg')
     , ('Gaelg, Gailck', NULL, 10, 'gv', 'glv')
     , ('Avañe''ẽ', NULL, 6, 'gn', 'grn')
     , ('ગુજરાતી', NULL, 10, 'gu', 'guj')
     , ('Kreyòl ayisyen', NULL, 3, 'ht', 'hat')
     , ('(Hausa) هَوُسَ', NULL, 13, 'ha', 'hau')
     , ('עברית', NULL, 13, 'he', 'heb')
     , ('Otjiherero', NULL, 1, 'hz', 'her')
     , ('हिन्दी, हिंदी', NULL, 10, 'hi', 'hin')
     , ('Hiri Motu', NULL, 23, 'ho', 'hmo')
     , ('hrvatski jezik', NULL, 10, 'hr', 'hrv')
     , ('magyar', NULL, 25, 'hu', 'hun')
     , ('Հայերեն', NULL, 10, 'hy', 'hye')
     , ('Asụsụ Igbo', NULL, 1, 'ig', 'ibo')
     , ('Ido', NULL, 14, 'io', 'ido')
     , ('ꆈꌠ꒿ Nuosuhxop', NULL, 9, 'ii', 'iii')
     , ('ᐃᓄᒃᑎᑐᑦ', NULL, 16, 'iu', 'iku')
     , ('Interlingue/Occidental', NULL, 14, 'ie', 'ile')
     , ('Interlingua', NULL, 14, 'ia', 'ina')
     , ('Bahasa Indonesia', NULL, 23, 'id', 'ind')
     , ('Iñupiaq, Iñupiatun', NULL, 16, 'ik', 'ipk')
     , ('Íslenska', NULL, 10, 'is', 'isl')
     , ('Italiano', NULL, 10, 'it', 'ita')
     , ('ꦧꦱꦗꦮ, Basa Jawa', NULL, 23, 'jv', 'jav')
     , ('日本語 (にほんご)', NULL, 19, 'ja', 'jpn')
     , ('kalaallisut, kalaallit oqaasii', NULL, 16, 'kl', 'kal')
     , ('ಕನ್ನಡ', NULL, 2, 'kn', 'kan')
     , ('कश्मीरी, كشميري‎', NULL, 10, 'ks', 'kas')
     , ('ქართული', NULL, 15, 'ka', 'kat')
     , ('Kanuri', NULL, 11, 'kr', 'kau')
     , ('қазақ тілі', NULL, 4, 'kk', 'kaz')
     , ('ខ្មែរ, ខេមរភាសា, ភាសាខ្មែរ', NULL, 5, 'km', 'khm')
     , ('Gĩkũyũ', NULL, 1, 'ki', 'kik')
     , ('Ikinyarwanda', NULL, 1, 'rw', 'kin')
     , ('Кыргызча, Кыргыз тили', NULL, 4, 'ky', 'kir')
     , ('коми кыв', NULL, 25, 'kv', 'kom')
     , ('Kikongo', NULL, 1, 'kg', 'kon')
     , ('한국어', NULL, 21, 'ko', 'kor')
     , ('Kuanyama', NULL, 1, 'kj', 'kua')
     , ('Kurdî, کوردی‎', NULL, 10, 'ku', 'kur')
     , ('ພາສາລາວ', NULL, 24, 'lo', 'lao')
     , ('latviešu valoda', NULL, 10, 'lv', 'lav')
     , ('Limburgs', NULL, 10, 'li', 'lim')
     , ('Lingála', NULL, 1, 'ln', 'lin')
     , ('lietuvių kalba', NULL, 10, 'lt', 'lit')
     , ('Lëtzebuergesch', NULL, 10, 'lb', 'ltz')
     , ('Kiluba', NULL, 1, 'lu', 'lub')
     , ('Luganda', NULL, 1, 'lg', 'lug')
     , ('Kajin M̧ajeļ', NULL, 23, 'mh', 'mah')
     , ('മലയാളം', NULL, 2, 'ml', 'mal')
     , ('मराठी', NULL, 10, 'mr', 'mar')
     , ('македонски јазик', NULL, 10, 'mk', 'mkd')
     , ('fiteny malagasy', NULL, 23, 'mg', 'mlg')
     , ('Malti', NULL, 13, 'mt', 'mlt')
     , ('Монгол хэл', NULL, 17, 'mn', 'mon')
     , ('te reo Māori', NULL, 23, 'mi', 'mri')
     , ('Bahasa Melayu, بهاس ملايو‎', NULL, 23, 'ms', 'msa')
     , ('ဗမာစာ', NULL, 9, 'my', 'mya')
     , ('Dorerin Naoero', NULL, 23, 'na', 'nau')
     , ('Diné bizaad', NULL, 22, 'nv', 'nav')
     , ('isiNdebele', NULL, 1, 'nr', 'nbl')
     , ('isiNdebele', NULL, 1, 'nd', 'nde')
     , ('Owambo', NULL, 1, 'ng', 'ndo')
     , ('नेपाली', NULL, 10, 'ne', 'nep')
     , ('Nederlands, Vlaams', NULL, 10, 'nl', 'nld')
     , ('Norsk Nynorsk', NULL, 10, 'nn', 'nno')
     , ('Norsk Bokmål', NULL, 10, 'nb', 'nob')
     , ('Norsk', NULL, 10, 'no', 'nor')
     , ('chiCheŵa, chinyanja', NULL, 1, 'ny', 'nya')
     , ('occitan, lenga d''òc', NULL, 10, 'oc', 'oci')
     , ('ᐊᓂᔑᓈᐯᒧᐎᓐ', NULL, 26, 'oj', 'oji')
     , ('ଓଡ଼ିଆ', NULL, 10, 'or', 'ori')
     , ('Afaan Oromoo', NULL, 13, 'om', 'orm')
     , ('ирон æвзаг', NULL, 10, 'os', 'oss')
     , ('ਪੰਜਾਬੀ', NULL, 10, 'pa', 'pan')
     , ('पाऴि', NULL, 10, 'pi', 'pli')
     , ('Português', NULL, 10, 'pt', 'por')
     , ('پښتو', NULL, 10, 'ps', 'pus')
     , ('ελληνικά', 'Greka', 10, 'el', 'ell')
     , ('English', 'Angla', 10, 'en', 'eng')
     , ('français, langue française', 'Franca', 10, 'fr', 'fra')
     , ('Runa Simi, Kichwa', NULL, 12, 'qu', 'que')
     , ('Rumantsch Grischun', NULL, 10, 'rm', 'roh')
     , ('Română', NULL, 10, 'ro', 'ron')
     , ('Ikirundi', NULL, 1, 'rn', 'run')
     , ('yângâ tî sängö', NULL, 3, 'sg', 'sag')
     , ('संस्कृतम्', NULL, 10, 'sa', 'san')
     , ('සිංහල', NULL, 10, 'si', 'sin')
     , ('Slovenčina, Slovenský Jazyk', NULL, 10, 'sk', 'slk')
     , ('Slovenski Jezik, Slovenščina', NULL, 10, 'sl', 'slv')
     , ('Davvisámegiella', NULL, 25, 'se', 'sme')
     , ('gagana fa''a Samoa', NULL, 23, 'sm', 'smo')
     , ('chiShona', NULL, 1, 'sn', 'sna')
     , ('सिन्धी, سنڌي، سندھی‎', NULL, 10, 'sd', 'snd')
     , ('Soomaaliga, af Soomaali', NULL, 13, 'so', 'som')
     , ('Sesotho', NULL, 1, 'st', 'sot')
     , ('Shqip', NULL, 10, 'sq', 'sqi')
     , ('sardu', NULL, 10, 'sc', 'srd')
     , ('српски језик', NULL, 10, 'sr', 'srp')
     , ('SiSwati', NULL, 1, 'ss', 'ssw')
     , ('Basa Sunda', NULL, 23, 'su', 'sun')
     , ('Kiswahili', NULL, 1, 'sw', 'swa')
     , ('Svenska', NULL, 10, 'sv', 'swe')
     , ('Reo Tahiti', NULL, 23, 'ty', 'tah')
     , ('தமிழ்', NULL, 2, 'ta', 'tam')
     , ('татар теле, tatar tele', NULL, 4, 'tt', 'tat')
     , ('తెలుగు', NULL, 2, 'te', 'tel')
     , ('тоҷикӣ, toçikī, تاجیکی‎', NULL, 10, 'tg', 'tgk')
     , ('Wikang Tagalog', NULL, 23, 'tl', 'tgl')
     , ('ไทย', NULL, 24, 'th', 'tha')
     , ('ትግርኛ', NULL, 13, 'ti', 'tir')
     , ('Faka Tonga', NULL, 23, 'to', 'ton')
     , ('Setswana', NULL, 1, 'tn', 'tsn')
     , ('Xitsonga', NULL, 1, 'ts', 'tso')
     , ('Türkmen, Түркмен', NULL, 4, 'tk', 'tuk')
     , ('Türkçe', NULL, 4, 'tr', 'tur')
     , ('Twi', NULL, 1, 'tw', 'twi')
     , ('ئۇيغۇرچە‎, Uyghurche', NULL, 4, 'ug', 'uig')
     , ('اردو', NULL, 10, 'ur', 'urd')
     , ('Oʻzbek, Ўзбек, أۇزبېك‎', NULL, 4, 'uz', 'uzb')
     , ('Tshivenḓa', NULL, 1, 've', 'ven')
     , ('Tiếng Việt', NULL, 5, 'vi', 'vie')
     , ('Volapük', NULL, 14, 'vo', 'vol')
     , ('Walon', NULL, 10, 'wa', 'wln')
     , ('Wollof', NULL, 1, 'wo', 'wol')
     , ('isiXhosa', NULL, 1, 'xh', 'xho')
     , ('ייִדיש', NULL, 10, 'yi', 'yid')
     , ('Yorùbá', NULL, 1, 'yo', 'yor')
     , ('Saɯ cueŋƅ, Saw cuengh', NULL, 24, 'za', 'zha')
     , ('中文 (Zhōngwén), 汉语, 漢語', NULL, 9, 'zh', 'zho')
     , ('isiZulu', NULL, 1, 'zu', 'zul');
