#!/bin/bash
set -e -o pipefail

is_true() { [[ "${1^^}" =~ ^(1|T|TRUE|Y|YES)$ ]]; }

if is_true "${LIQUIBASE_DEBUG}"; then
  set | grep LIQUIBASE_ >&2
fi

if ! is_true "${LIQUIBASE_DISABLE_INTERPOLATION}"; then
  opts=''
  is_true "${LIQUIBASE_DEBUG}" && opts='-v'
  is_true "${LIQUIBASE_TRACE}" && opts='-v -v'
  varsubst -x LIQUIBASE_ -s $opts liquibase.properties
  unset opts
fi

exec "$@"