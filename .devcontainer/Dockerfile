FROM dart

RUN apt-get update && apt-get install -y xz-utils && apt-get clean

# download flutter
# unzip and delete zipfile
RUN FLUTTER_PATH=$(curl -s https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json | grep -o '"archive": ".*-stable\.tar\.xz"' | head -n 1 | sed 's/"archive": "stable\/linux\///;s/"//') && \
export FLUTTER_PATH=$FLUTTER_PATH && \
curl -O "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/${FLUTTER_PATH}" && \
tar xf "./${FLUTTER_PATH}" -C / && \
rm "./${FLUTTER_PATH}"

RUN git config --global --add safe.directory /flutter
# set env
ENV PATH="/flutter/bin:$PATH"

RUN flutter doctor
