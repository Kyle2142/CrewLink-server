# ottomated/crewlink-server

# Stage 1, generate files separately so we only bring over what is necessary
FROM node:lts-alpine as builder

# Set working directory for subsequent commands
WORKDIR /app

# Copy the repo contents from the build context into the image
COPY . .

# Install NPM packages
RUN yarn install

# Compile project
RUN yarn compile


# Stage 2, output image
FROM node:lts-alpine

# Change to the /app directory *and* make it the default execution directory
WORKDIR /app
                                                                            # Copy relevant files from previous stage
COPY --chown=node:node --from=builder /app/dist ./dist                      COPY --chown=node:node --from=builder /app/node_modules ./node_modules
                                                                            # Start the image as node
USER node

# Tell the Docker engine the default port is 9736
EXPOSE 9736

# Run the app when the container starts
CMD ["node", "dist/index.js"]
