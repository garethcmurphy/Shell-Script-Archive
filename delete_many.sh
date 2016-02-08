#!/bin/bash
find . -name 'spam-*' -print0 | xargs -0 rm
