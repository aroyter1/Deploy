# Create directories
New-Item -ItemType Directory -Force -Path "certs"

# Generate root CA private key and certificate
openssl req -x509 -nodes -new -sha256 -days 1024 -newkey rsa:2048 -keyout certs/RootCA.key -out certs/RootCA.pem -subj "/C=US/CN=Local-Root-CA"
openssl x509 -outform pem -in certs/RootCA.pem -out certs/RootCA.crt

# List of domains to generate certificates for
$domains = @("frontend.local", "backend1.local", "backend2.local", "api.local")

foreach ($domain in $domains) {
    # Generate private key
    openssl genrsa -out "certs/$domain.key" 2048

    # Create config file
    @"
[req]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn
req_extensions = req_ext

[dn]
C=US
ST=LocalState
L=LocalCity
O=LocalOrg
OU=Development
CN=$domain

[req_ext]
subjectAltName = @alt_names

[alt_names]
DNS.1 = $domain
DNS.2 = localhost
"@ | Out-File -FilePath "certs/$domain.conf" -Encoding ASCII

    # Generate CSR
    openssl req -new -key "certs/$domain.key" -out "certs/$domain.csr" -config "certs/$domain.conf"

    # Generate certificate
    openssl x509 -req -in "certs/$domain.csr" `
        -CA certs/RootCA.pem -CAkey certs/RootCA.key -CAcreateserial `
        -out "certs/$domain.crt" -days 365 -sha256 `
        -extfile "certs/$domain.conf" -extensions req_ext

    # Clean up CSR
    Remove-Item "certs/$domain.csr"
    Remove-Item "certs/$domain.conf"
}

Write-Host "Certificates generated successfully in the 'certs' directory"
Write-Host "Don't forget to import certs/RootCA.crt into your trusted root certificates" 