#!/bin/bash
set -e

# Set defaults
: ${ELASTICSEARCH:="window.location.protocol + '//' + window.location.host"}
: ${DEFAULT_ROUTE:="/dashboard/file/default.json"}

# Check if we need quotes
if [[ "$ELASTICSEARCH" != *\ * ]]; then
    ELASTICSEARCH="'$ELASTICSEARCH'"
fi

# Update config
sed -i -r -e "s|^(\s*elasticsearch)\s*:.*|\1: $ELASTICSEARCH,|" \
          -e "s|^(\s*default_route)\s*:.*|\1: '$DEFAULT_ROUTE',|" \
    /var/www/kibana/config.js

exec "$@"
