## [1.1.1](https://github.com/CSKU-Lab/isolate-docker/compare/v1.1.0...v1.1.1) (2026-07-14)


### Bug Fixes

* expose go/rust on sandbox PATH; document language setup ([2adcd96](https://github.com/CSKU-Lab/isolate-docker/commit/2adcd96ed92e50af7febc494792f3db7d166497c))

# [1.1.0](https://github.com/CSKU-Lab/isolate-docker/compare/v1.0.0...v1.1.0) (2026-07-14)


### Features

* support java, go, rust, python 3.14, c/c++17 in with-compilers ([127d0cb](https://github.com/CSKU-Lab/isolate-docker/commit/127d0cbe07167ffa6df4ea05d34cd4db7ebf11e4))

# 1.0.0 (2026-07-14)


### Bug Fixes

* add RUN instruction and non-interactive flag for rustup install ([338dea1](https://github.com/CSKU-Lab/isolate-docker/commit/338dea1386541da0f61087987e58e80a76ba483f))
* add semantic-release config without npm plugin ([8c1ca45](https://github.com/CSKU-Lab/isolate-docker/commit/8c1ca45528c190c6504a28505c50b0b526c208b4))
* wrong image name ([b2014fc](https://github.com/CSKU-Lab/isolate-docker/commit/b2014fc7b52b10b6d528de582b678ff538bc6b53))


### Features

* add semantic release and cross-repo trigger to rebuild go-grader on base image update ([57ac1f6](https://github.com/CSKU-Lab/isolate-docker/commit/57ac1f6fdcbe53edaf6658eb481fba377c7b2c5b))
* create Dockerfile and config file ([e26aa2b](https://github.com/CSKU-Lab/isolate-docker/commit/e26aa2bb7b8afaf47158ca1382503ace612b919a))


### Reverts

* use normal shell script instead of systemd ([a6b1fe8](https://github.com/CSKU-Lab/isolate-docker/commit/a6b1fe8d7f96eb8c5ec239c747d0b1d49f08657d))
