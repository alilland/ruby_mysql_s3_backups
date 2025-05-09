# MySQL Backup Script for AWS Lambda

This Ruby script is designed to run as an AWS Lambda function to **automatically back up a MySQL database** using `mysqldump`. The output is saved as a timestamped `.sql.gz` file in a specified backup directory and uploaded to Amazon S3. It is intended for automation tasks like daily backups and is compatible with both cloud and local environments.

---

## 🔧 What It Does

* Connects to a MySQL database using credentials from environment variables
* Executes `mysqldump` over TCP to avoid local socket issues
* Saves the SQL backup to a specified directory with a UTC timestamp
* Compresses the `.sql` file to `.sql.gz` using gzip
* Uploads the compressed backup to an S3 bucket
* Flushes the local backup directory after successful upload
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
| `S3_BUCKET`      | Name of the destination S3 bucket            | *required*  |
| `S3_REGION`      | AWS region of the S3 bucket                  | *required*  |

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
export S3_BUCKET=my-backup-bucket
export S3_REGION=us-west-2
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
* Compresses backup using `gzip` and uploads to S3
* Stack traces are logged on failure for easy debugging.

---

## ✅ Notes

* Uses `--protocol=TCP` to avoid socket errors common with XAMPP or cloud DBs.
* Make sure the MySQL user has the necessary privileges (`SELECT`, `LOCK TABLES`, etc.).
* The `settings.rb` file must define the `log` method and `TIMEZONE` constant.
* The `upload_to_s3` and `gzip_file` methods must be defined and accessible.
* The `flush` method clears the backup directory after upload.

---

## 📄 License

MIT — Use freely with attribution.
