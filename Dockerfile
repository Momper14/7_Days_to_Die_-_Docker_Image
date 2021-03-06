FROM debian:stable-slim

MAINTAINER Momper14 <moritz.momper@gmail.com>

RUN apt-get update && \
        apt-get install -y --no-install-recommends \
        ca-certificates

# create extra User 7days
RUN useradd -mUs /bin/bash -d /7daysded 7days

USER 7days

# add data
ADD --chown=7days:7days data/7daysded /7daysded
ADD --chown=7days:7days data/Mods /7daysded/Mods
RUN sed 's|-logfile.*.txt|-logfile /7daysded/logs/output_log__`date +%Y-%m-%d__%H-%M-%S`.txt|' /7daysded/startserver.sh >> /7daysded/tmp && mv /7daysded/tmp /7daysded/startserver.sh && chmod +x /7daysded/startserver.sh
RUN mkdir -p /7daysded/logs /7daysded/.local/share/7DaysToDie
ADD --chown=7days:7days data/7daysded/serverconfig.xml /7daysded/.local/share/7DaysToDie/serverconfig.xml

WORKDIR /7daysded

VOLUME ["/7daysded/Mods", "/7daysded/.local/share/7DaysToDie", "/7daysded/logs", "/7daysded/Data/Config"]

# remote
EXPOSE 8080-8081/tcp
# Alloc's mods map
EXPOSE 8082/tcp

# server ports
EXPOSE 26900/tcp 26900-26902/udp

# additional start params
ENV START_ARGS ""

ENTRYPOINT ["./startserver.sh",  "-configfile=/7daysded/.local/share/7DaysToDie/serverconfig.xml", "$START_ARGS"]
