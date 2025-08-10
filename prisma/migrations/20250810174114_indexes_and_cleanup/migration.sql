-- CreateEnum
CREATE TYPE "public"."UserRole" AS ENUM ('user', 'admin');

-- CreateEnum
CREATE TYPE "public"."AccountStatus" AS ENUM ('PENDING', 'ACTIVE', 'BLOCKED', 'DELETED');

-- CreateEnum
CREATE TYPE "public"."LogEventType" AS ENUM ('REGISTER', 'LOGIN_SUCCESS', 'LOGIN_FAIL', 'EMAIL_VERIFIED', 'EMAIL_RESEND', 'EMAIL_FAILED', 'PASSWORD_CHANGED', 'ACCOUNT_BLOCKED', 'ACCOUNT_UNLOCKED', 'LOGIN_2FA_REQUIRED', 'ENABLE_2FA', 'DISABLE_2FA', 'LOGOUT', 'LOGIN_OAUTH_SUCCESS', 'LOGIN_OAUTH_FAIL', 'OAUTH_DISCONNECT', 'PASSWORD_SET_OAUTH_SUCCESS');

-- CreateTable
CREATE TABLE "public"."users" (
    "user_id" TEXT NOT NULL,
    "email" VARCHAR(320) NOT NULL,
    "display_name" VARCHAR(100),
    "picture_url" VARCHAR(255),
    "password_hash" TEXT NOT NULL,
    "user_role" "public"."UserRole" NOT NULL DEFAULT 'user',
    "account_status" "public"."AccountStatus" NOT NULL DEFAULT 'PENDING',
    "email_verified" BOOLEAN NOT NULL DEFAULT false,
    "email_verification_token" TEXT,
    "email_verification_token_expires_at" TIMESTAMP(3),
    "reset_password_token" TEXT,
    "reset_password_expires_at" TIMESTAMP(3),
    "two_factor_enabled" BOOLEAN NOT NULL DEFAULT false,
    "two_factor_secret" VARCHAR(64),
    "two_factor_expires_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("user_id")
);

-- CreateTable
CREATE TABLE "public"."sessions" (
    "session_id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "ip_address" VARCHAR(45) NOT NULL,
    "user_agent" VARCHAR(255),
    "device" VARCHAR(100),
    "client" VARCHAR(50),
    "location" VARCHAR(100),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "expires_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "sessions_pkey" PRIMARY KEY ("session_id")
);

-- CreateTable
CREATE TABLE "public"."access_logs" (
    "access_log_id" TEXT NOT NULL,
    "user_id" TEXT,
    "event_type" "public"."LogEventType" NOT NULL,
    "ip_address" VARCHAR(45),
    "user_agent" VARCHAR(255),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "access_logs_pkey" PRIMARY KEY ("access_log_id")
);

-- CreateTable
CREATE TABLE "public"."oauth_accounts" (
    "oauth_account_id" TEXT NOT NULL,
    "provider" TEXT NOT NULL,
    "providerId" TEXT NOT NULL,
    "email" TEXT,
    "accessToken" TEXT,
    "refreshToken" TEXT,
    "user_id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "oauth_accounts_pkey" PRIMARY KEY ("oauth_account_id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "public"."users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "users_email_verification_token_key" ON "public"."users"("email_verification_token");

-- CreateIndex
CREATE INDEX "users_created_at_idx" ON "public"."users"("created_at");

-- CreateIndex
CREATE INDEX "sessions_user_id_idx" ON "public"."sessions"("user_id");

-- CreateIndex
CREATE INDEX "sessions_expires_at_idx" ON "public"."sessions"("expires_at");

-- CreateIndex
CREATE INDEX "sessions_created_at_idx" ON "public"."sessions"("created_at");

-- CreateIndex
CREATE INDEX "access_logs_user_id_idx" ON "public"."access_logs"("user_id");

-- CreateIndex
CREATE INDEX "access_logs_created_at_idx" ON "public"."access_logs"("created_at");

-- CreateIndex
CREATE INDEX "access_logs_event_type_idx" ON "public"."access_logs"("event_type");

-- CreateIndex
CREATE INDEX "oauth_accounts_user_id_idx" ON "public"."oauth_accounts"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "oauth_accounts_provider_providerId_key" ON "public"."oauth_accounts"("provider", "providerId");

-- AddForeignKey
ALTER TABLE "public"."sessions" ADD CONSTRAINT "sessions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("user_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."access_logs" ADD CONSTRAINT "access_logs_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("user_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."oauth_accounts" ADD CONSTRAINT "oauth_accounts_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("user_id") ON DELETE CASCADE ON UPDATE CASCADE;
