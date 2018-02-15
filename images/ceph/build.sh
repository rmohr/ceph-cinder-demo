#!/bin/bash

set -e

docker build . -t kubevirtci/ceph:kraken
