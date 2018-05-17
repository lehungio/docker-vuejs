#!/bin/bash

MAINTAINER="me@lehungio.com"

readonly NAME="liho"
readonly REPO_NAME="docker-vuejs"
readonly REPO="https://github.com/lehungio/$REPO_NAME"
readonly FULL_PATH="$( cd "$( dirname "$0" )" && pwd )"
readonly LIHO_PATH="/code"
readonly PUBLIC_PATH="/code/public_html"
readonly LOCALHOST="127.0.0.1"

readonly PM2_LOG_VUEJS="pm2 logs"

helps() {
	case $1 in
		all|*) allhelps ;;
	esac
}

allhelps() {
cat <<EOF
Usage: ./help.sh COMMAND
[help|usage|build|init|up|down|restart|status|logs|ssh]
[Commands]
  build        Build docker service
  up or start  Run docker-compose as daemon (or up)
  down or stop Terminate all docker containers run by docker-compose (or down)
  restart      Restart docker-compose containers
  status       View docker containers status
  logs         View docker containers logs
  ssh          ssh cli
EOF
}

# Usage
usage() {
	echo "Usage:"
	echo "${0} [help|usage|build|init|up|down|restart|status|logs|ssh]"
}

# Docker compose build
build() {
	docker-compose build
}

# Docker compose up
start() {
	docker-compose up -d
}

# Docker compose down
stop() {
	docker-compose down
}

# Docker compose restart
restart() {
	docker-compose restart
}

# Docker compose status
status() {
	docker-compose ps
}

# Docker compose logs
run_logs() {
	case $1 in
	  pm2)
      docker-compose exec vuejs-stable /bin/bash -c "$PM2_LOG_VUEJS"
    ;;
	  web|nginx)
      docker-compose logs web
    ;;
		liho|*)  
		  docker-compose logs 
		;;
	esac
}

# ssh cli
run_ssh() {
	case $1 in
		vuejs-stable) docker-compose exec vuejs-stable /bin/bash ;;
		vuejs|*) docker-compose exec vuejs /bin/bash ;;
	esac
}

# run vuejs
run_vuejs() {
	case $1 in
	  init)
		  # TODO init source code
			# Installation
			# https://vuejs.org/v2/guide/installation.html
			cd stable/vuejs
			npm install --global vue-cli
			# vue init webpack sample
		;;
		up)
		  cd stable/vuejs
			npm install
			npm run dev
		;;
		update)
		  # TODO update source code
			# stable https://github.com/vuejs/vue/releases
      npm i -g npm
		;;
		info)
		  # TODO show info for vuejs
		;;
		help|*)
			echo "vuejs usage:"
	    echo "${0} vuejs [help|init|up|update]"
		;;
	esac
}

case $1 in
	init) init ${2:-v2};;
	build) build ;;
	start|up) start ;;
	stop|down) stop ;;
	restart|reboot) restart ;;
	status|ps) status ;;
	logs) run_logs ${2:-all} ;;
	ssh) run_ssh ${2:-php} ;;
	vuejs) run_vuejs ${2:-help} ${3} ${4} ${5} ;;
	*) helps ;;
esac
