# Step by Step - Using Linkerd and Emissary

## Intro

Hey folks! Thanks a ton for reading! Today I'm going to go through a step by step tutorial of using Linkerd with Emissary, formerly known as the Ambassador API Gateway from the folks at Ambassador. Emissary is an extremely powerful ingress/API Gateway that relies on Custom Resource definitions to allow you to route and manage traffic to your applications. Linkerd is an open source service mesh that will manage the traffic to and between applications running in Kubernetes.

By the end of this article you should feel comfortable setting up Linkerd and Emissary in Kubernetes. You should also know how to integrate them together and where to go to learn more.

## The Set Up

What we're using:

* Kubernetes
  * I'm using k3s but any distribution will work for you
  * Kubernetes version 1.19.7
* kubectl
  * version 1.19.7
* linkerd
  * version 2.10.1
* Ambassador API Gateway
  * version 1.13.2
  * Soon to be Emissary but it's in the process of migrating
  * You can learn more about that [here](https://www.youtube.com/watch?v=QDQy-W72KmY&t)
* Some Sample Apps
  * Going to use Linkerd's Emojivoto app
    * You can use anything you want

## Guide

Tell em the thing. And what they should be learning

## Wrap Up

Tell em what you told them. And what I wanted them to learn

Thanks so much for reading and I'd love to hear any feedback you have,

I'm: [twitter](https://twitter.com/RJasonMorgan) or [Linkedin](https://www.linkedin.com/in/jasonmorgan2/).

Jason
