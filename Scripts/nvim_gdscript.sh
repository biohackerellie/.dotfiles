#!/bin/bash
ghostty -e "nvim --server /tmp/godot.pipe --remote $1 "
