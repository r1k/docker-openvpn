#!/bin/bash

CONTAINER_NAME="openvpn"
IMAGE_NAME="linuxserver/openvpn-as"

create() {
    docker create \
        --name $CONTAINER_NAME \
        --cap-add=NET_ADMIN \
        -e PUID=1000 \
        -e PGID=1000 \
        -e TZ=Europe/London \
        -e INTERFACE=eth0 \
        -p 943:943 \
        -p 9443:9443 \
        -p 1194:1194/udp \
        -v /mnt/storage1/openvpn/config:/config \
        --restart unless-stopped \
        $IMAGE_NAME
}

build() {
    docker build --tag="$IMAGE_NAME" .
}

start() {
    docker start "$CONTAINER_NAME"
}

stop() {
    docker stop "$CONTAINER_NAME"
}

remove() {
    docker rm "$CONTAINER_NAME"
}

remove_i() {
    docker rmi "$IMAGE_NAME"
}

pull() {
    docker pull "$IMAGE_NAME"
}

show_logs() {
    docker logs "$CONTAINER_NAME"
}

run() {
    docker run --name="$CONTAINER_NAME" "$IMAGE_NAME"
}

run_it() {
    docker run -it --name="$CONTAINER_NAME" "$IMAGE_NAME"
}

main() {

    for arg in "$@"; do
        case $arg in
            
            --create)

                create
                start
                sleep 3
                show_logs
                ;;

            --update)

                stop
                remove
                pull
                create
                start
                sleep 3
                show_logs
                ;;

            --start)

                start
                ;;

            --stop)

                stop
                ;;

            --remove)

                remove
                ;;

            --run)

                run
                ;;

            --runit)

                run_it
                ;;

            --build)

                build
                ;;

            --remove_image)

                remove_i
                ;;
            
            *)
            
                exit 1

        esac 
    done
}

main "$@" || exit 1
