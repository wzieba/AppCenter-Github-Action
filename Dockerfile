FROM node:14

WORKDIR /app
COPY . /app

RUN npm install -g appcenter-cli@2.7.3

RUN mkdir -p /usr/local/lib/aapt/
RUN wget -q "https://dl.google.com/dl/android/maven2/com/android/tools/build/aapt2/4.0.1-6197926/aapt2-4.0.1-6197926-linux.jar" -O aapt2-all.jar \
    && mv aapt2-all.jar /usr/local/lib/aapt/aapt2-all.jar \
    && cd /usr/local/lib/aapt \
    && unzip -qq aapt2-all.jar \
    && ln -s /usr/local/lib/aapt/aapt2 /usr/local/bin/aapt2

RUN chmod +x /app/entrypoint.sh

ENTRYPOINT [ "/app/entrypoint.sh" ]

