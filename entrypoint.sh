#!/bin/sh
set -e

echo "[chatwoot] ============================================"
echo "[chatwoot] Chatwoot on Railway starting..."
echo "[chatwoot] PORT=$PORT"
echo "[chatwoot] RAILS_ENV=$RAILS_ENV"
echo "[chatwoot] ============================================"

echo "[chatwoot] Running database migrations..."
bundle exec rails db:chatwoot_prepare
echo "[chatwoot] Migrations complete."

# Sidekiq runs in this container alongside the web server. It was previously
# started once and never watched: if it crashed, the container stayed up and
# healthy while every background job — outbound email, webhooks, automation
# rules, report generation — silently stopped running. Supervise it instead.
run_sidekiq() {
  while true; do
    echo "[chatwoot] Starting Sidekiq worker..."
    bundle exec sidekiq -C config/sidekiq.yml
    code=$?
    echo "[chatwoot] Sidekiq exited with code $code — restarting in 5s."
    sleep 5
  done
}

run_sidekiq &
SIDEKIQ_SUPERVISOR=$!
echo "[chatwoot] Sidekiq supervisor running with PID $SIDEKIQ_SUPERVISOR"

trap 'echo "[chatwoot] Shutting down..."; kill "$SIDEKIQ_SUPERVISOR" 2>/dev/null; exit' TERM INT

echo "[chatwoot] Starting Rails web server on port $PORT..."
exec bundle exec rails s -b 0.0.0.0
