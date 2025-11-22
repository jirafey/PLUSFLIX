-- SQL dump generated using DBML (dbml.dbdiagram.io)
-- Database: PostgreSQL
-- Generated at: 2025-11-21T23:30:49.236Z

CREATE TYPE "user_role" AS ENUM (
  'user',
  'moderator'
);

CREATE TYPE "media_type" AS ENUM (
  'movie',
  'series'
);

CREATE TYPE "person_role" AS ENUM (
  'actor',
  'director',
  'writer',
  'producer',
  'other'
);

CREATE TYPE "language_usage" AS ENUM (
  'original',
  'dub',
  'subtitle',
  'forced_subtitle',
  'cc',
  'ad'
);

CREATE TYPE "availability_type" AS ENUM (
  'subscription',
  'rental',
  'purchase',
  'free',
  'tvod'
);

CREATE TABLE "users" (
  "id" bigint PRIMARY KEY,
  "username" varchar UNIQUE NOT NULL,
  "password_hash" varchar NOT NULL,
  "role" user_role NOT NULL DEFAULT 'user'
);

CREATE TABLE "categories" (
  "id" bigint PRIMARY KEY,
  "name" varchar UNIQUE NOT NULL,
  "description" text
);

CREATE TABLE "languages" (
  "id" bigint PRIMARY KEY,
  "iso_code" char(2) UNIQUE NOT NULL,
  "name" varchar NOT NULL
);

CREATE TABLE "streaming_services" (
  "id" bigint PRIMARY KEY,
  "name" varchar UNIQUE NOT NULL,
  "website" varchar
);

CREATE TABLE "media_items" (
  "id" bigint PRIMARY KEY,
  "title" varchar NOT NULL,
  "original_title" varchar,
  "type" media_type NOT NULL,
  "description" text,
  "release_date" date,
  "runtime_minutes" int,
  "poster_url" varchar,
  "thumbnail_url" varchar
);

CREATE TABLE "media_categories" (
  "media_id" bigint,
  "category_id" bigint,
  PRIMARY KEY ("media_id", "category_id")
);

CREATE TABLE "persons" (
  "id" bigint PRIMARY KEY,
  "name" varchar NOT NULL,
  "birth_date" date,
  "bio" text
);

CREATE TABLE "media_persons" (
  "media_id" bigint,
  "person_id" bigint,
  "role" person_role,
  "character_name" varchar,
  PRIMARY KEY ("media_id", "person_id", "role")
);

CREATE TABLE "media_languages" (
  "media_id" bigint,
  "language_id" bigint,
  "usage" language_usage,
  PRIMARY KEY ("media_id", "language_id", "usage")
);

CREATE TABLE "service_availabilities" (
  "id" bigint PRIMARY KEY,
  "media_id" bigint NOT NULL,
  "service_id" bigint NOT NULL,
  "available_from" timestamp,
  "available_to" timestamp,
  "type" availability_type,
  "url" varchar,
  "quality" varchar,
  "price" numeric(10,2),
  "currency" char(3)
);

CREATE TABLE "reviews" (
  "id" bigint PRIMARY KEY,
  "media_id" bigint NOT NULL,
  "user_id" bigint NOT NULL,
  "rating" numeric(3,2),
  "title" varchar,
  "body" text,
  "is_spoiler" boolean DEFAULT false,
  "created_at" timestamp NOT NULL DEFAULT 'now()',
  "updated_at" timestamp
);

CREATE TABLE "collections" (
  "id" bigint PRIMARY KEY,
  "name" varchar NOT NULL,
  "description" text
);

CREATE TABLE "collection_items" (
  "collection_id" bigint,
  "media_id" bigint,
  PRIMARY KEY ("collection_id", "media_id")
);

ALTER TABLE "media_categories" ADD FOREIGN KEY ("media_id") REFERENCES "media_items" ("id");

ALTER TABLE "media_categories" ADD FOREIGN KEY ("category_id") REFERENCES "categories" ("id");

ALTER TABLE "media_persons" ADD FOREIGN KEY ("media_id") REFERENCES "media_items" ("id");

ALTER TABLE "media_persons" ADD FOREIGN KEY ("person_id") REFERENCES "persons" ("id");

ALTER TABLE "media_languages" ADD FOREIGN KEY ("media_id") REFERENCES "media_items" ("id");

ALTER TABLE "media_languages" ADD FOREIGN KEY ("language_id") REFERENCES "languages" ("id");

ALTER TABLE "service_availabilities" ADD FOREIGN KEY ("media_id") REFERENCES "media_items" ("id");

ALTER TABLE "service_availabilities" ADD FOREIGN KEY ("service_id") REFERENCES "streaming_services" ("id");

ALTER TABLE "reviews" ADD FOREIGN KEY ("media_id") REFERENCES "media_items" ("id");

ALTER TABLE "reviews" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "collection_items" ADD FOREIGN KEY ("collection_id") REFERENCES "collections" ("id");

ALTER TABLE "collection_items" ADD FOREIGN KEY ("media_id") REFERENCES "media_items" ("id");
