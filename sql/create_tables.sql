CREATE TABLE "users" (
  "id" varchar(64) PRIMARY KEY NOT NULL,
  "email" varchar,
  "firstName" varchar,
  "lastName" varchar
);

CREATE TABLE "courses" (
  "id" varchar(64) PRIMARY KEY NOT NULL,
  "title" varchar(256),
  "description" text,
  "publishedAt" timestamp
);

CREATE TABLE "certificates" (
  "course" varchar(64),
  "user" varchar(64),
  "completedDate" timestamp,
  "startDate" timestamp NOT NULL DEFAULT 'now()'
);

ALTER TABLE "certificates" ADD FOREIGN KEY ("course") REFERENCES "courses" ("id");

ALTER TABLE "certificates" ADD FOREIGN KEY ("user") REFERENCES "users" ("id");

CREATE INDEX "certificates_course" ON "certificates" ("course");

CREATE INDEX "certificates_user" ON "certificates" ("user");
