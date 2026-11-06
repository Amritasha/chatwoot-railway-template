# Chatwoot on Railway

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/new?template=https://github.com/Amritasha/chatwoot-railway-template)

[Chatwoot](https://chatwoot.com) is an open-source customer support platform — a self-hosted alternative to Intercom and Zendesk. Live chat, email inbox, Twitter, WhatsApp, and more in one place.

---

## What's included

- **Chatwoot** — web app + Sidekiq background worker (single container)
- **PostgreSQL** — primary database
- **Redis** — queues, caching, real-time

---

## Deploy in 3 steps

### 1. Click Deploy on Railway
Railway provisions Postgres and Redis automatically.

### 2. Set environment variables

**Pre-configured — no action needed:**

| Variable | Value |
|----------|-------|
| `RAILS_ENV` | `production` |
| `NODE_ENV` | `production` |
| `INSTALLATION_ENV` | `docker` |
| `RAILS_LOG_TO_STDOUT` | `true` |
| `NUMBER_OF_PROXIES` | `1` |

**Set these yourself:**

| Variable | What to put |
|----------|-------------|
| `SECRET_KEY_BASE` | Random 128-char hex — `openssl rand -hex 64` |
| `FRONTEND_URL` | Your Railway domain e.g. `https://xyz.up.railway.app` |
| `DATABASE_URL` | Auto-filled from Postgres service |
| `REDIS_URL` | Auto-filled from Redis service |

### 3. First login

1. Open your Railway domain
2. Create your admin account
3. Set up your first inbox (live chat, email, WhatsApp, etc.)
4. Invite your team

---

## Email (invites & notifications)

```
MAILER_SENDER_EMAIL=noreply@yourdomain.com
SMTP_ADDRESS=smtp.sendgrid.net
SMTP_PORT=587
SMTP_USERNAME=apikey
SMTP_PASSWORD=your-api-key
SMTP_AUTHENTICATION=plain
SMTP_ENABLE_STARTTLS_AUTO=true
```

Works with SendGrid, Resend, Postmark, or any SMTP provider.

**Outbound SMTP is blocked on Railway's Free, Trial and Hobby plans** and only
opens up on Pro. On a lower plan, invites and notifications will fail no matter
how the variables are set — use a provider's HTTP API instead of SMTP, or move
to Pro.

---

## File storage (optional)

Attachments are written to `/app/storage` by default. This template mounts a
volume there, so they survive redeploys — without one, every file your team
or your customers upload is thrown away the next time the service restarts.

For a bucket instead, the variable names depend on which bucket:

**Amazon S3 proper:**

```
ACTIVE_STORAGE_SERVICE=amazon
AWS_ACCESS_KEY_ID=...
AWS_SECRET_ACCESS_KEY=...
AWS_REGION=us-east-1
S3_BUCKET_NAME=your-bucket
```

**A Railway bucket, or any other S3-compatible store** (Backblaze, R2, MinIO,
DigitalOcean Spaces). The `amazon` service has no endpoint setting, so it
cannot reach a non-AWS bucket — use `s3_compatible`:

```
ACTIVE_STORAGE_SERVICE=s3_compatible
STORAGE_ACCESS_KEY_ID=${{Bucket.ACCESS_KEY_ID}}
STORAGE_SECRET_ACCESS_KEY=${{Bucket.SECRET_ACCESS_KEY}}
STORAGE_REGION=${{Bucket.REGION}}
STORAGE_BUCKET_NAME=${{Bucket.BUCKET}}
STORAGE_ENDPOINT=${{Bucket.ENDPOINT}}
```

---

## Credentials you'll need

- **SendGrid / Resend** — for email notifications and invites
- **Twilio** — for WhatsApp / SMS inboxes (optional)
- **Twitter Developer App** — for Twitter inbox (optional)

---

## When to move on

Chatwoot works well for teams up to ~50 agents. If you outgrow it:

- **Intercom** — best-in-class but expensive ($74+/mo)
- **Zendesk** — enterprise support, ticketing, SLAs
- **Freshdesk** — cheaper Zendesk alternative

No official migration tool exists. Export conversations as CSV and reimport manually.

---

## License

Chatwoot is [MIT](https://github.com/chatwoot/chatwoot/blob/develop/LICENSE). This template is MIT.
