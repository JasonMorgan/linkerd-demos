#!/usr/bin/env bash

flux reconcile source git gitops -n flux-system
flux reconcile source helm linkerd -n linkerd
flux reconcile kustomization linkerd -n flux-system
