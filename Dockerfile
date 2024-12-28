FROM nvidia/cuda:12.6.2-cudnn-devel-ubuntu22.04

LABEL author="pejmans21"

# 1) Install dependencies
RUN apt -y update

RUN apt -y install \
    zsh \
    tmux \
    curl \
    git \
    htop \
    ffmpeg \
    libsm6 \
    libxext6 \
    libmagic-dev \
    python3.10 \
    python3.10-venv \
    python-is-python3

# 2) Set environment variables to suppress Oh My Zsh prompts
ENV RUNZSH="no"
ENV CHSH="no"
ENV POETRY_HOME="/etc/poetry"

# 3) Install Oh My Zsh non-interactively
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended

RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

COPY --chmod=644 .zshrc /root/.zshrc

# 4) Install Poetry (example extra step)
RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="$POETRY_HOME/bin:$PATH"

# 5) Optional: switch the shell at the container level.
#    This ensures that any new shell in the container is zsh by default.
SHELL ["/bin/zsh", "-c"]

# 6) Define a default command that starts Zsh (which will load Oh My Zsh)
CMD ["zsh"]
