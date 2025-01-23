FROM alpine:latest AS build

RUN apk add --no-cache cmake g++ make

WORKDIR /app

COPY . .

ENV BUILD_DIR=/app/docker_build

RUN cmake -S . -B $BUILD_DIR && \
    cmake --build $BUILD_DIR --config Release && \
    cp $BUILD_DIR/cicd_test /usr/bin/cicd_test && \
    rm -rf /app/*

FROM alpine:latest AS cicd_test

COPY --from=build /usr/lib/libstdc++.so.6 /usr/lib/libstdc++.so.6
COPY --from=build /usr/lib/libgcc_s.so.1 /usr/lib/libgcc_s.so.1
COPY --from=build /usr/bin/cicd_test /usr/bin/cicd_test

CMD ["/usr/bin/cicd_test"]
