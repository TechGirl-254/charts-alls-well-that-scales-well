#!/bin/bash

echo "=== Cleaning up old/duplicate resources ==="
echo ""

# Delete old UI deployment (without scale-app prefix)
echo "1. Checking for old UI deployments..."
kubectl get deployment scale-app-ui -n scale-app-ns 2>/dev/null
if [ $? -eq 0 ]; then
    echo "Found old deployment 'scale-app-ui', deleting..."
    kubectl delete deployment scale-app-ui -n scale-app-ns
else
    echo "No old 'scale-app-ui' deployment found."
fi

echo ""
echo "2. Current deployments:"
kubectl get deployments -n scale-app-ns

echo ""
echo "3. Current pods:"
kubectl get pods -n scale-app-ns | grep scale-app

echo ""
echo "4. Restarting UI pods to apply new configuration:"
kubectl rollout restart deployment -l app.kubernetes.io/component=ui -n scale-app-ns

echo ""
echo "5. Waiting for rollout to complete..."
kubectl rollout status deployment -l app.kubernetes.io/component=ui -n scale-app-ns --timeout=120s

echo ""
echo "=== Cleanup Complete ==="
