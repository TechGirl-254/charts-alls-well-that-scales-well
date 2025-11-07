#!/bin/bash

echo "=== Latency Diagnostics for Scale App ==="
echo ""

# Test UI latency
echo "1. Testing UI Response Time:"
curl -w "\nDNS Lookup: %{time_namelookup}s\nTCP Connect: %{time_connect}s\nTLS Handshake: %{time_appconnect}s\nTime to First Byte: %{time_starttransfer}s\nTotal Time: %{time_total}s\n" \
  -o /dev/null -s https://scale-ui.wamatamuriu.org/

echo ""
echo "2. Testing API Response Time:"
curl -w "\nDNS Lookup: %{time_namelookup}s\nTCP Connect: %{time_connect}s\nTLS Handshake: %{time_appconnect}s\nTime to First Byte: %{time_starttransfer}s\nTotal Time: %{time_total}s\n" \
  -o /dev/null -s https://scale-api.wamatamuriu.org/

echo ""
echo "3. Checking Pod Status:"
kubectl get pods -n scale-app-ns -o wide

echo ""
echo "4. Checking Pod Resource Usage:"
kubectl top pods -n scale-app-ns

echo ""
echo "5. Checking Ingress Controller Logs (last 20 lines):"
kubectl logs -n ingress-nginx --tail=20 -l app.kubernetes.io/name=ingress-nginx

echo ""
echo "=== Diagnostics Complete ==="
