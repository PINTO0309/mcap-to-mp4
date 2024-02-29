FROM --platform=amd64 python:3.10-slim-bookworm as base
ARG USERNAME=user

SHELL ["/bin/bash", "-c"]

# Install ffmpeg
RUN apt-get update -qq && \
    apt-get install -y ffmpeg sudo wget && \
    rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install poetry \
    && pip install mcap==1.1.1 \
    && pip install mcap-ros2-support==0.5.3

# Install mcap CLI
RUN wget https://github.com/foxglove/mcap/releases/latest/download/mcap-linux-amd64 -O mcap \
    && chmod +x mcap \
    && mv mcap /usr/bin/

WORKDIR /tool
COPY poetry.lock /tool
COPY pyproject.toml /tool
COPY README.md /tool
COPY mcap_to_mp4 /tool/mcap_to_mp4
RUN poetry install && poetry build && poetry env remove --all
RUN pip install dist/mcap_to_mp4-0.1.0-py3-none-any.whl

RUN echo "root:root" | chpasswd \
    && useradd \
        --create-home \
        --home-dir /home/${USERNAME} \
        --shell /bin/bash \
        --user-group \
        --groups adm,sudo \
        ${USERNAME} \
    && echo "${USERNAME}:${USERNAME}" | chpasswd \
    && cat /dev/null > /etc/sudoers.d/${USERNAME} \
    && echo "%${USERNAME}    ALL=(ALL)   NOPASSWD:    ALL" >> \
        /etc/sudoers.d/${USERNAME} \
    && mkdir -p /works \
    && chown ${USERNAME}:${USERNAME} /works

USER ${USERNAME}
WORKDIR /works
RUN echo "export USER=`whoami`" >> ~/.bashrc \
    && echo 'export PATH=${PATH}:${HOME}/.local/bin' >> ~/.bashrc
