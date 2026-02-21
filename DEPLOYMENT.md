# Deployment Guide

## Prerequisites
- All environment variables configured
- Both frontend and backend tested locally
- GitHub repository setup (optional but recommended)

## Frontend Deployment

### Option 1: Vercel (Recommended for React apps)

```bash
# Install Vercel CLI
npm install -g vercel

# Login to Vercel
vercel login

# Deploy frontend
cd frontend
vercel
```

**Environment Variables on Vercel:**
1. Go to Project Settings → Environment Variables
2. Add:
   - `VITE_GOOGLE_CLIENT_ID`
   - `VITE_FACEBOOK_APP_ID`
   - `VITE_API_URL=https://api.yourdomain.com`

### Option 2: Netlify

```bash
# Install Netlify CLI
npm install -g netlify-cli

# Login to Netlify
netlify login

# Deploy from frontend folder
cd frontend
netlify deploy
```

**Build Settings:**
- Build command: `npm run build`
- Publish directory: `dist`

### Option 3: AWS Amplify

```bash
# Connect your GitHub repo
# Amplify will auto-deploy on push

# Or use Amplify CLI
amplify hosting add
amplify publish
```

## Backend Deployment

### Option 1: Railway (Easiest)

1. Go to [Railway.app](https://railway.app/)
2. Connect GitHub repository
3. Create new project from backend folder
4. Add environment variables:
   ```
   PORT=5000
   GOOGLE_CLIENT_ID=...
   GOOGLE_CLIENT_SECRET=...
   FACEBOOK_APP_ID=...
   FACEBOOK_APP_SECRET=...
   JWT_SECRET=...
   MONGODB_URI=...
   ```
5. Deploy automatically

### Option 2: Heroku

```bash
# Install Heroku CLI
npm install -g heroku

# Login
heroku login

# Create app
heroku create orry-backend

# Add MongoDB add-on
heroku addons:create mongolab:sandbox

# Set environment variables
heroku config:set GOOGLE_CLIENT_ID=...
heroku config:set JWT_SECRET=...

# Deploy
git push heroku main
```

### Option 3: AWS EC2

```bash
# SSH into your instance
ssh -i your-key.pem ubuntu@your-instance-ip

# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Clone repository
git clone your-repo-url
cd orry-backend

# Install dependencies
npm install

# Install PM2 for process management
npm install -g pm2

# Start application
pm2 start server.js --name orry-backend
pm2 startup
pm2 save

# Setup Nginx as reverse proxy
sudo apt-get install -y nginx
# Configure nginx to forward to localhost:5000
```

### Option 4: Docker Deployment

```bash
# Create Dockerfile for backend
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --production
COPY . .
EXPOSE 5000
CMD ["npm", "start"]

# Build image
docker build -t orry-backend .

# Run container
docker run -p 5000:5000 --env-file .env orry-backend
```

## Database Setup

### MongoDB Atlas (Cloud)

1. Go to [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
2. Create free account
3. Create new cluster
4. Get connection string
5. Add to `MONGODB_URI` in backend .env

### Update Backend Model

Replace in-memory storage in `backend/models/customer.js`:

```javascript
import mongoose from 'mongoose'

const customerSchema = new mongoose.Schema({
  email: { type: String, required: true, unique: true },
  name: String,
  provider: String,
  picture: String,
  facebookId: String,
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now }
})

export const Customer = mongoose.model('Customer', customerSchema)
```

## Update OAuth Credentials for Production

### Google Cloud Console
1. Go to Credentials
2. Update Authorized JavaScript origins:
   - Remove localhost URLs
   - Add production domain
3. Update Authorized redirect URIs

### Facebook Developers
1. Go to Settings → Basic
2. Update App Domains: `yourdomain.com`
3. Update Valid OAuth Redirect URIs:
   - `https://yourdomain.com/`

## CI/CD Pipeline (GitHub Actions)

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Install dependencies
        run: |
          cd backend && npm install
          cd ../frontend && npm install
      
      - name: Build frontend
        run: cd frontend && npm run build
      
      - name: Deploy frontend
        run: |
          npm install -g vercel
          cd frontend
          vercel --prod --token ${{ secrets.VERCEL_TOKEN }}
      
      - name: Deploy backend
        run: |
          git push heroku main:main
```

## Testing Before Deployment

```bash
# Backend
cd backend
npm test        # If tests configured
npm run build   # If compilation needed

# Frontend
cd frontend
npm run build
npm run preview
```

## Post-Deployment Checklist

- [ ] Frontend loads at production URL
- [ ] Backend API responds at production URL
- [ ] Google login works in production
- [ ] Facebook login works in production
- [ ] User data saves correctly
- [ ] JWT tokens work properly
- [ ] CORS allows production domain
- [ ] HTTPS enabled for security
- [ ] Database access working
- [ ] Environment variables set correctly
- [ ] Monitoring/logging configured
- [ ] Error reporting active (Sentry, etc.)

## Monitoring & Maintenance

### Application Monitoring
- Setup error tracking: [Sentry.io](https://sentry.io/)
- Monitor performance: [New Relic](https://newrelic.com/)
- Check uptime: [UptimeRobot](https://uptimerobot.com/)

### Database Monitoring
- MongoDB Atlas: Built-in monitoring
- Backups enabled
- Index optimization

### Security
- Enable Application Insights
- Monitor failed logins
- Analyze suspicious patterns
- Regular security audits

## Scaling

### Horizontal Scaling
- Use load balancer (AWS ELB, Cloudflare)
- Run multiple backend instances
- Use CDN for frontend (CloudFlare, Cloudfront)

### Vertical Scaling
- Upgrade server resources
- Optimize database queries
- Enable caching (Redis)

## Troubleshooting Production

### Frontend Issues
- Check browser DevTools console
- Verify API URL environment variable
- Check CORS headers

### Backend Issues
- Monitor server logs
- Check database connection
- Verify environment variables
- Monitor CPU/Memory usage

### OAuth Issues
- Verify redirect URIs exactly match
- Check credentials not rotated
- Verify domain whitelisting
- Check IP restrictions not enabled
