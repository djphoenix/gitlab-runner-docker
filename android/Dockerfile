FROM djphoenix/gitlab-runner:gradle

RUN wget https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip -O/tmp/android-sdk.zip ; \
    mkdir /var/android ; \
    unzip -d /var/android/ /tmp/android-sdk.zip ; \
    rm /tmp/android-sdk.zip

ENV ANDROID_HOME=/var/android ANDROID_SDK_ROOT=/var/android

RUN yes | /var/android/tools/bin/sdkmanager --licenses ; \
    /var/android/tools/bin/sdkmanager platform-tools
