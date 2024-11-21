# Base image from Puppeteer repository with pre-installed Chromium
FROM ghcr.io/puppeteer/puppeteer:19.7.2

# Environment variables to specify Puppeteer behavior and Chromium binary path
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome-stable \
    DISPLAY=:99

# Update and install necessary dependencies for headful Puppeteer
RUN apt-get update && apt-get install -y \
    wget gnupg libx11-xcb1 libxcomposite1 libxrandr2 libxss1 libxcursor1 libxi6 libxtst6 libnss3 \
    libatk1.0-0 libatk-bridge2.0-0 libpangocairo-1.0-0 libxdamage1 libxinerama1 libappindicator3-1 \
    libdbusmenu-glib4 libdbusmenu-gtk3-4 libgdk-pixbuf2.0-0 libcups2 xvfb fonts-liberation \
    libfontconfig1 --no-install-recommends

# Install Google Chrome stable version for Puppeteer
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt-get install -y ./google-chrome-stable_current_amd64.deb && \
    rm google-chrome-stable_current_amd64.deb

# Set working directory for the application
WORKDIR /usr/src/app

# Copy dependency files and install Node.js dependencies
COPY package*.json ./
RUN npm ci

# Copy the remaining application files
COPY . .

# Expose the port used by the application
EXPOSE 4000

# Start the application using Xvfb to enable GUI rendering
CMD ["xvfb-run", "--server-args=-screen 0 1280x1024x24", "node", "index.js"]


