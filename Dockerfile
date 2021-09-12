FROM rust:1 as builder
COPY library-scripts/install-rust-clis.sh /tmp/
RUN bash /tmp/install-rust-clis.sh


FROM rust:1 

# [Option] Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="false"
# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
COPY library-scripts/*.sh library-scripts/*.env /tmp/library-scripts/
COPY .config /tmp/.config
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
	# Remove imagemagick due to https://security-tracker.debian.org/tracker/CVE-2019-10131
	&& apt-get purge -y imagemagick imagemagick-6-common \
	# Install common packages, non-root user, updated lldb, dependencies
	&& bash /tmp/library-scripts/common-debian.sh "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \
	&& apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts
COPY --from=builder /usr/local/cargo/bin/* /usr/local/cargo/bin/