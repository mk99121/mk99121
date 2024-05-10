ImagePullBackoff

ImagePullBackoff can be caused if the pod runs with an invalid image or typo in the image name or even a non-existent image.

When a kubelet starts creating containers for a Pod using a container runtime, it might be possible the container is in Waiting state because of ImagePullBackOff.
The ImagePullBackOff means that a container could not start because Kubernetes could not pull a container image because of following

Invalid image name or
Pulling from a private registry without imagePullSecret.

The ImagePullBackOff indicates that Kubernetes will keep trying to pull the image, with increasing back-off delay.
Kubernetes delay each attempt until it reaches a compiled limit, which is 300 seconds (5 minutes).
