# Booper

Booper is a simple web app about dogs that has been deployed on Oracle Cloud Infrastructure (OCI). This tow-part repository contains the resources necessary to get the web app up and running and to follow the process of deploying the web app on a public IP with OCI.

## Web App

The web app is a dog "booper" app. The app displays a randomized dog image from a given directory, repeating every time the user clicks on (boops) the dog image. It also records the total number of clicks (boops) in a text file and displays it on the web app. Full documentation is available in the Web App directory of this repository, which will walk through the steps for setup on your local machine.


## OCI Deployment

There is documentation in the OCI Deployment directory of this repository, providing a walkthrough for hosting the web app on a public IP address via Oracle Cloud Infrastructure. This includes provisioning Oracle Cloud resources with Terraform, along with containerized deployment with Docker.