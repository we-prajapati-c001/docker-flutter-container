FROM ubuntu:20.04

# Prerequisites
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y tzdata
RUN apt update && apt install -y curl git unzip xz-utils zip libglu1-mesa openjdk-11-jdk wget

# Install fastlane
RUN apt update && apt install -y ruby ruby-dev
RUN apt update && apt install -y build-essential
RUN apt update && gem install fastlane
# Instal fastlane
RUN gem install fastlane-plugin-firebase_app_distribution
RUN gem install fastlane-plugin-flutter_version

# Set up a new user
RUN useradd -ms /bin/bash developer
USER developer
WORKDIR /home/developer

# Prepare android directories and system variables
RUN mkdir -p Android/sdk
RUN mkdir -p .android && touch .android/repositories.cfg
ENV ANDROID_SDK_ROOT /home/developer/Android/sdk

# Set up android tools
RUN mkdir -p $ANDROID_SDK_ROOT/cmdline-tools
RUN wget -O cmdline-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
RUN unzip cmdline-tools.zip && rm cmdline-tools.zip
RUN mv cmdline-tools latest && mv latest $ANDROID_SDK_ROOT/cmdline-tools

RUN yes | $ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager --licenses
RUN $ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager "build-tools;33.0.2" "platform-tools" "platforms;android-33" "sources;android-33"
ENV PATH "$PATH:/home/developer/Android/sdk/platform-tools"

# Download flutter
RUN git clone -b stable https://github.com/flutter/flutter.git
ENV PATH "$PATH:/home/developer/flutter/bin"
RUN yes | flutter doctor --android-licenses

# Run basic check for flutter
RUN flutter --version
RUN flutter doctor

# Fetch flutter code
ARG cachebust=1
ARG flutter_app_branch=main
RUN git clone -b $flutter_app_branch https://github.com/we-prajapati-c001/flutter-docker-playground.git app

# Run fastlane
ENV LANG=en_US.UTF-8
# Other way to fix is change user to admin and then switch back
# RUN cd ./app/android && fastlane install_plugins
RUN cd ./app/android && fastlane beta
