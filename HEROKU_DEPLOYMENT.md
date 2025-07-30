# Heroku Deployment Guide

## Prerequisites
1. Install Heroku CLI: https://devcenter.heroku.com/articles/heroku-cli
2. Have a Heroku account
3. Git repository initialized

## Deployment Steps

### 1. Login to Heroku
```bash
heroku login
```

### 2. Create Heroku App
```bash
heroku create your-app-name
```

### 3. Add Heroku Remote (if not automatically added)
```bash
heroku git:remote -a your-app-name
```

### 4. Set Rails Master Key
```bash
heroku config:set RAILS_MASTER_KEY=$(cat config/master.key)
```

### 5. Deploy to Heroku
```bash
git add .
git commit -m "Prepare for Heroku deployment"
git push heroku main
```

### 6. Run Database Migrations
```bash
heroku run rails db:migrate
```

### 7. (Optional) Seed Database with Test Data
```bash
heroku run rails db:seed
```

### 8. Open Your App
```bash
heroku open
```

## Useful Commands

- View logs: `heroku logs --tail`
- Run Rails console: `heroku run rails console`
- Check app status: `heroku ps`
- Restart app: `heroku restart`

## Environment Variables

The app uses these environment variables (automatically set by Heroku):
- `DATABASE_URL` - PostgreSQL connection string
- `RAILS_MASTER_KEY` - For Rails credentials

## Troubleshooting

1. If assets aren't loading:
   ```bash
   heroku run rails assets:precompile
   heroku restart
   ```

2. If you get database errors:
   ```bash
   heroku pg:reset DATABASE_URL
   heroku run rails db:migrate
   ```

3. Check Ruby version compatibility:
   - Heroku supports specific Ruby versions
   - Check `.ruby-version` file matches Heroku's supported versions

## Free Tier Limitations

- App sleeps after 30 mins of inactivity
- Limited to 1000 dyno hours per month
- PostgreSQL limited to 10,000 rows

## Upgrading

To upgrade from free tier:
```bash
heroku dyno:resize basic
heroku addons:upgrade heroku-postgresql:essential-0
```