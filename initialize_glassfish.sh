#!/bin/bash

/create_domain.sh
/start_domain.sh
/enable_secure_admin.sh

/check_secure_admin.sh

/stop_domain.sh
