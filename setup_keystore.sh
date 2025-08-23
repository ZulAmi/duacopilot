#!/bin/bash
echo "========================================"
echo "DuaCopilot - Production Keystore Setup"
echo "========================================"
echo ""

echo "Creating Android production keystore..."
echo "This will generate a secure keystore for production builds."
echo ""

cd android/keystore

echo "Generating keystore with 10,000-day validity..."
keytool -genkey -v -keystore duacopilot-release-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias duacopilot-release-key

echo ""
echo "========================================"
echo "Keystore generation complete!"
echo "========================================"
echo ""

echo "Next steps:"
echo "1. Copy android/key.properties.template to android/key.properties"
echo "2. Build release: flutter build appbundle --release"
echo "3. IMPORTANT: Backup your keystore securely!"
echo ""

echo "Security reminder:"
echo "- Keep your keystore file safe and secure"
echo "- Never commit key.properties to version control"
echo "- Store passwords in a secure password manager"
echo ""

read -p "Press Enter to continue..."
