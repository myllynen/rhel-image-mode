# RHEL Image Mode Example

[![License: GPLv2](https://img.shields.io/badge/license-GPLv2-brightgreen.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)
[![License: GPLv3](https://img.shields.io/badge/license-GPLv3-brightgreen.svg)](https://www.gnu.org/licenses/gpl-3.0)

A simple RHEL image mode example.

## Contents

* [Containerfile](Containerfile)
  * Example to build RHEL container image
* [config.json](config.json)
  * Example to customize RHEL container image
* [etc](etc)
  * Example content to include in RHEL container image
* [ri-env](ri-env)
  * Environment settings for the build script
* [ri-image](ri-image)
  * Build script to build RHEL container and disk images

## RHEL Image Mode Example

This repo contains a simple RHEL image mode example to make it easier to
kick the tires.

```
# Adjust to suite local environment,
# note that the defaults will not work
vi ri-env
# Login to used registries
sudo podman login ...
# Review the Containerfile
vi Containerfile
# Review the build script
vi ri-image
# Run the build script
./ri-image
```

NB. The ability to run RHEL system roles during build time is being
worked on.

## See Also

See also
[https://github.com/bootc-dev/bootc/issues/1197](https://github.com/bootc-dev/bootc/issues/1197).

See also
[https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/10/html/using_image_mode_for_rhel_to_build_deploy_and_manage_operating_systems/index](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/10/html/using_image_mode_for_rhel_to_build_deploy_and_manage_operating_systems/index).

See also
[https://developers.redhat.com/articles/2025/03/18/how-use-rhel-system-roles-image-mode](https://developers.redhat.com/articles/2025/03/18/how-use-rhel-system-roles-image-mode).

See also
[https://github.com/myllynen/rhel-image](https://github.com/myllynen/rhel-image).

## License

GPLv2+
