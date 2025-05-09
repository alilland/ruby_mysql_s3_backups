# MySQL Backup Script for AWS Lambda

This Ruby script is designed to run as an AWS Lambda function to **automatically back up a MySQL database** using `mysqldump`. The output is saved as a timestamped `.sql` file in a specified backup directory. It is intended for automation tasks like daily backups, and is compatible with cloud or local environments where environment variables are used for configuration.

---

## 🔧 What It Does

* Connects to a MySQL database using credentials from environment variables
* Executes `mysqldump` over TCP to avoid local socket issues
* Saves the SQL backup to a specified directory with a UTC timestamp
* Logs detailed information, including errors and stack traces
* Designed to be deployed as an AWS Lambda function or run locally

---

## 📦 Environment Variables

| Variable         | Description                                  | Default     |
| ---------------- | -------------------------------------------- | ----------- |
| `MYSQL_USER`     | MySQL username                               | *required*  |
| `MYSQL_PASS`     | MySQL password                               | *required*  |
| `MYSQL_HOST`     | MySQL host address                           | `localhost` |
| `MYSQL_PORT`     | MySQL port                                   | `3306`      |
| `MYSQL_DATABASE` | Database name to back up                     | *required*  |
| `BACKUP_DIR`     | Directory where `.sql` files are saved       | `./backups` |
| `TIMEZONE`       | Timezone string (e.g. `America/Los_Angeles`) | *required*  |

---

## 🖥️ Running Locally

Ensure all required environment variables are set:

```bash
export MYSQL_USER=root
export MYSQL_PASS=secret
export MYSQL_HOST=localhost
export MYSQL_PORT=3306
export MYSQL_DATABASE=myapp
export BACKUP_DIR=./backups
export TIMEZONE=America/Los_Angeles
```

Then run:

```bash
ruby local.rb
```

*You must define a `local.rb` that calls `script(event: {}, context: {})`.*

---

## ☁️ AWS Lambda Deployment

To deploy this script to Lambda:

1. Package it with dependencies:

   ```bash
   zip -r function.zip script.rb settings.rb vendor/
   ```

2. Upload to Lambda:

   ```bash
   aws lambda update-function-code --function-name mysql_backup --zip-file fileb://function.zip
   ```

Ensure your Lambda environment variables mirror the ones listed above.

---

## 📋 Logging and Error Handling

* Uses `log :debug`, `:info`, and `:fatal` for structured logging.
* Captures full `mysqldump` output and exit code.
* Stack traces are logged on failure for easy debugging.

---

## ✅ Notes

* Uses `--protocol=TCP` to avoid socket errors common with XAMPP or cloud DBs.
* Make sure the MySQL user has the necessary privileges (`SELECT`, `LOCK TABLES`, etc.).
* The `settings.rb` file must define the `log` method and `TIMEZONE` constant.

---

## 📄 License

MIT — Use freely with attribution.
