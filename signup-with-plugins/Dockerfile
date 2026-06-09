FROM eclipse-temurin:21-jre-noble

ARG SOURCE
ARG COMMIT_HASH
ARG COMMIT_ID
ARG BUILD_TIME
LABEL source=${SOURCE}
LABEL commit_hash=${COMMIT_HASH}
LABEL commit_id=${COMMIT_ID}
LABEL build_time=${BUILD_TIME}

# can be passed during Docker build as build time environment
ARG container_user=mosip
ARG container_user_group=mosip
ARG container_user_uid=1001
ARG container_user_gid=1001

ENV work_dir=/home/${container_user}
ARG plugins_path=${work_dir}/plugins
ENV plugins_path_env=${plugins_path}

# Create user and plugins directory
RUN groupadd -g ${container_user_gid} ${container_user_group} \
    && useradd -u ${container_user_uid} -g ${container_user_group} -s /bin/sh -m ${container_user} \
    && mkdir -p ${plugins_path}

# copy all files under target to the plugins folder
COPY ./target/*.jar ${plugins_path_env}/

RUN chown -R ${container_user}:${container_user} ${plugins_path}

USER ${container_user_uid}:${container_user_gid}
