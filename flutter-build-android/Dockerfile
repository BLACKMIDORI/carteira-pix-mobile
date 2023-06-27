FROM ubuntu:22.04
# SETUP NON-ROOT(nobody) USER
RUN mkdir /home/nobody
RUN chown nobody /home/nobody
RUN usermod -d /home/nobody nobody


# DEFINE ENVIRONMENT
# 🍵 JDK
ENV JAVA_HOME=/dependencies/jdk
# 🤖 ANDROID SDK
ENV ANDROID_HOME=/dependencies/android-sdk
ENV ANDROID_SDK_ROOT=/dependencies/android-sdk
# 🐦 FLUTTER
ENV FLUTTER_HOME=/dependencies/flutter
# PATH
ENV PATH="$PATH:$JAVA_HOME/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$FLUTTER_HOME/bin"


# INSTALL BASIC TOOLS
RUN apt-get update
RUN apt-get install git -y # required by Flutter
RUN apt-get install wget -y
RUN apt-get install unzip -y
RUN apt-get install xz-utils -y

USER nobody
# INSTALL DEPENDENCIES
WORKDIR /dependencies

# DEFINE SOME ARGS
# 🍵 JDK
ARG OPEN_JDK_URL=https://download.java.net/java/GA/jdk17.0.2/dfd4a8d0985749f896bed50d7138ee7f/8/GPL/openjdk-17.0.2_linux-x64_bin.tar.gz
ARG JAVA_SDK_SHA256=0022753d0cceecacdd3a795dd4cea2bd7ffdf9dc06e22ffd1be98411742fbb44
###
RUN wget $OPEN_JDK_URL -O open-jdk.tar.gz
RUN echo "$JAVA_SDK_SHA256 open-jdk.tar.gz" | sha256sum -c
RUN tar -zxf open-jdk.tar.gz
RUN mv jdk* jdk


# 🤖 ANDROID SDK
WORKDIR /dependencies/android-sdk/cmdline-tools/
ARG ANDROID_CMDLINE_TOOLS_URL=https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
ARG ANDROID_CMDLINE_TOOLS_SHA256=bd1aa17c7ef10066949c88dc6c9c8d536be27f992a1f3b5a584f9bd2ba5646a0
###
RUN wget $ANDROID_CMDLINE_TOOLS_URL -O commandlinetools.zip
RUN echo "$ANDROID_CMDLINE_TOOLS_SHA256 commandlinetools.zip" | sha256sum -c
RUN unzip commandlinetools.zip
RUN mv cmdline-tools latest/
RUN yes | sdkmanager "build-tools;30.0.3" "platforms;android-30"
RUN yes | sdkmanager "build-tools;31.0.0" "platforms;android-31"
RUN yes | sdkmanager "build-tools;32.0.0" "platforms;android-32"
RUN yes | sdkmanager "build-tools;33.0.2" "platforms;android-33"
RUN yes | sdkmanager "build-tools;34.0.0" "platforms;android-34"
RUN yes | sdkmanager "tools"
RUN yes | sdkmanager --licenses
WORKDIR /dependencies


# FLUTTER + DART
ARG FLUTTER_SDK_URL=https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.10.5-stable.tar.xz
ARG FLUTTER_SDK_SHA256=86643cbfe8acf766a226a6cd4625bb8301c2601ea9bb825448318c8669b72a13
###
RUN wget $FLUTTER_SDK_URL -O flutter-sdk.tar.xz
RUN echo "$FLUTTER_SDK_SHA256 flutter-sdk.tar.xz" | sha256sum -c
RUN tar -xf flutter-sdk.tar.xz
RUN flutter precache
RUN yes | flutter doctor --android-licenses


USER root
COPY ./docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

USER nobody
WORKDIR /output
WORKDIR /app
ENV BUILD_TYPE="appbundle"
ENV BUILD_PARAMS="--release"
