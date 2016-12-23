#! /usr/bin/env bash
#
# Install global npm packages through yarn and apm packages

export ZSH=$HOME/.dotfiles

set -e

$ZSH/node/yarn_packages

apm install --packages-file $ZSH/node/apm_packages
