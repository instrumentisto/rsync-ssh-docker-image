#!/usr/bin/env bats


@test "SSH is installed" {
  run docker run --rm --entrypoint sh $IMAGE -c 'which ssh'
  [ "$status" -eq 0 ]
}


@test "rsync is installed" {
  run docker run --rm --entrypoint sh $IMAGE -c 'which rsync'
  [ "$status" -eq 0 ]
}

@test "rsync runs ok" {
  run docker run --rm --entrypoint sh $IMAGE -c 'rsync --help'
  [ "$status" -eq 0 ]
}
