# DuaCopilot Backend - AWS ECS Deployment Configuration
# Container-based deployment with Fargate

# Dockerfile for backend containerization
FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY firebase/functions/package*.json ./
RUN npm ci --only=production

# Copy source code
COPY firebase/functions/src ./src
COPY firebase/functions/tsconfig.json ./

# Build TypeScript
RUN npm run build

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1

# Start the application
CMD ["node", "lib/index.js"]
