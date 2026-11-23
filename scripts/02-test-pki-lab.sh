#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
test -f build/pki/certs/ca.cert.pem || { echo "ERROR: run 01-build-pki-lab.sh first"; exit 1; }

pass() { echo "PASS: $1"; }
fail() { echo "FAIL: $1"; exit 1; }

openssl verify -CAfile build/pki/certs/ca.cert.pem build/pki/certs/signer.cert.pem >/dev/null \
  && pass "signer certificate chain" || fail "signer certificate chain"

openssl ocsp -issuer build/pki/certs/ca.cert.pem \
  -cert build/pki/certs/signer.cert.pem \
  -reqout build/pki/ocsp.req.der
openssl ocsp -index build/pki/db/index.txt -rsigner build/pki/certs/ocsp.cert.pem \
  -rkey build/pki/private/ocsp.key.pem -CA build/pki/certs/ca.cert.pem \
  -reqin build/pki/ocsp.req.der -respout build/pki/ocsp.resp.der
OCSP_TEXT="$(openssl ocsp -respin build/pki/ocsp.resp.der \
  -issuer build/pki/certs/ca.cert.pem -cert build/pki/certs/signer.cert.pem \
  -CAfile build/pki/certs/ca.cert.pem 2>&1)"
printf '%s\n' "$OCSP_TEXT"
printf '%s' "$OCSP_TEXT" | grep -q 'Response verify OK' || fail "OCSP response signature"
printf '%s' "$OCSP_TEXT" | grep -q 'good' || fail "OCSP status good"
pass "OCSP signed response and good status"

openssl cms -verify -binary -inform DER -in build/pki/document.cms.der \
  -CAfile build/pki/certs/ca.cert.pem -out build/pki/document.verified.txt >/dev/null \
  && pass "CMS signature verification" || fail "CMS signature verification"

openssl ts -verify -data build/pki/document.cms.der -in build/pki/document.tsr \
  -CAfile build/pki/certs/ca.cert.pem -untrusted build/pki/certs/tsa.cert.pem >/dev/null \
  && pass "RFC 3161 timestamp token" || fail "RFC 3161 timestamp token"

echo "All Week 1 PKI lab checks passed."
