#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

if [[ -d build/pki ]]; then
  echo "ERROR: build/pki already exists. Run ./scripts/99-clean.sh first to avoid overwriting CA state."
  exit 1
fi

mkdir -p build/pki/{certs,crl,csr,newcerts,private,db}
chmod 700 build/pki/private
: > build/pki/db/index.txt
echo 1000 > build/pki/db/serial
echo 1000 > build/pki/db/crlnumber
echo 1000 > build/pki/db/tsa.serial

# All identities are synthetic and all keys are disposable test keys.
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:3072 -out build/pki/private/ca.key.pem
chmod 600 build/pki/private/ca.key.pem
openssl req -config config/openssl/ca.cnf -key build/pki/private/ca.key.pem \
  -new -x509 -days 3650 -sha256 -extensions v3_ca \
  -out build/pki/certs/ca.cert.pem

# RA simulation: create a request, then explicitly approve it locally before issuance.
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:3072 -out build/pki/private/signer.key.pem
chmod 600 build/pki/private/signer.key.pem
openssl req -new -key build/pki/private/signer.key.pem -sha256 \
  -subj "/C=VN/O=PKI-PQC Capstone Lab/OU=Synthetic Test Identity/CN=Test Signer 001" \
  -out build/pki/csr/signer.csr.pem
echo "RA SIMULATION: approving synthetic CSR for local test issuance."
openssl ca -batch -config config/openssl/ca.cnf -extensions signer_cert \
  -days 365 -in build/pki/csr/signer.csr.pem \
  -out build/pki/certs/signer.cert.pem

# Dedicated OCSP responder key/certificate.
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out build/pki/private/ocsp.key.pem
chmod 600 build/pki/private/ocsp.key.pem
openssl req -new -key build/pki/private/ocsp.key.pem -sha256 \
  -subj "/C=VN/O=PKI-PQC Capstone Lab/CN=Test OCSP Responder" \
  -out build/pki/csr/ocsp.csr.pem
openssl ca -batch -config config/openssl/ca.cnf -extensions ocsp_cert \
  -days 365 -in build/pki/csr/ocsp.csr.pem \
  -out build/pki/certs/ocsp.cert.pem

# Dedicated TSA key/certificate.
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out build/pki/private/tsa.key.pem
chmod 600 build/pki/private/tsa.key.pem
openssl req -new -key build/pki/private/tsa.key.pem -sha256 \
  -subj "/C=VN/O=PKI-PQC Capstone Lab/CN=Test TSA" \
  -out build/pki/csr/tsa.csr.pem
openssl ca -batch -config config/openssl/ca.cnf -extensions tsa_cert \
  -days 365 -in build/pki/csr/tsa.csr.pem \
  -out build/pki/certs/tsa.cert.pem

# Create a harmless synthetic document and detached CMS signature.
printf 'Synthetic case document for Week 1 PKI lab.\nCase: DEMO-0001\nVersion: 1\n' > build/pki/document.txt
openssl cms -sign -binary -in build/pki/document.txt \
  -signer build/pki/certs/signer.cert.pem -inkey build/pki/private/signer.key.pem \
  -outform DER -out build/pki/document.cms.der -md sha256

# Create RFC 3161 request/response over the CMS signature.
openssl ts -query -data build/pki/document.cms.der -sha256 \
  -cert -out build/pki/document.tsq
openssl ts -reply -config config/openssl/tsa.cnf \
  -queryfile build/pki/document.tsq -out build/pki/document.tsr

echo
echo "Build complete. Generated files are in ignored build/pki/."
echo "Next: ./scripts/02-test-pki-lab.sh"
