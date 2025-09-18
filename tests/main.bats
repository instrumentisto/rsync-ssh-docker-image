#!/usr/bin/env bats


@test "Built on correct arch" {
  run docker run --rm --pull never --platform $PLATFORM \
                 --entrypoint sh $IMAGE -c \
    'uname -m'
  [ "$status" -eq 0 ]
  if [ "$PLATFORM" = "linux/amd64" ]; then
    [ "$output" = "x86_64" ]
  elif [ "$PLATFORM" = "linux/arm/v6" ]; then
    [ "$output" = "armv7l" ]
  elif [ "$PLATFORM" = "linux/arm/v7" ]; then
    [ "$output" = "armv7l" ]
  elif [ "$PLATFORM" = "linux/arm64/v8" ]; then
    [ "$output" = "aarch64" ]
  elif [ "$PLATFORM" = "linux/386" ]; then
    [ "$output" = "x86_64" ]
  else
    [ "$output" = "$(echo $PLATFORM | cut -d '/' -f2-)" ]
  fi
}


@test "SSH is installed" {
  run docker run --rm --pull never --platform $PLATFORM \
                 --entrypoint sh $IMAGE -c \
    'which ssh'
  [ "$status" -eq 0 ]
}


@test "rsync is installed" {
  run docker run --rm --pull never --platform $PLATFORM \
                 --entrypoint sh $IMAGE -c \
    'which rsync'
  [ "$status" -eq 0 ]
}

@test "rsync runs ok" {
  run docker run --rm --pull never --platform $PLATFORM \
                 --entrypoint sh $IMAGE -c \
    'rsync --help'
  [ "$status" -eq 0 ]
}


@test "envsubst is installed" {
  run docker run --rm --pull never --platform $PLATFORM \
                 --entrypoint sh $IMAGE -c \
    'which envsubst'
  [ "$status" -eq 0 ]
}

@test "envsubst runs ok" {
  run docker run --rm --pull never --platform $PLATFORM \
                 --entrypoint sh $IMAGE -c \
    'envsubst --help'
  [ "$status" -eq 0 ]
}


@test "TZ env var works ok" {
  run docker run --rm --pull never --platform $PLATFORM \
                 -e TZ=Asia/Tokyo \
                 --entrypoint sh $IMAGE -c \
    'date +%Z'
  [ "$status" -eq 0 ]
  [ "$output" = "JST" ]
}
