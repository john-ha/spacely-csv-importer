
# Spacely CSV Importer

## ✨ About The Project

![![Screenshot][screenshot]](/docs/images/overview.png)

`Spacely CSV Importer` is a simple web application that allows users to upload CSV files of real estate properties and import them into a database. The imported properties are displayed in a table, and users can search, sort, and filter the properties. The history of the import jobs is also available.

The deployed application is available at [https://spacely-csv-importer.onrender.com/](https://spacely-csv-importer.onrender.com/).
Note: the application is deployed on a free tier, so it may take a few seconds to load the first time.

The application is built using Ruby on Rails and PostgreSQL. The front-end is using Rails views with Tailwind CSS for styling.

## ✍🏻 Assignment Requirements

```
課題:
CSVファイルから物件情報をデータベースに登録するWeb APIの実装

-------------------------------

要件:
● CSVファイルをアップロードし、データベースに登録してください。
● CSVファイルには各物件のユニークID、物件名、住所、部屋番号、賃料、広さ、建物の種類が含まれています。
● 建物の種類はアパート、一戸建て、マンションの3種類になります。
● ユニークID、物件名、部屋番号を必須項目としてください。ただし建物の種類が一建て場合、部屋番号にNULLを設定できるようにしてください。
● 同一のユニークIDの物件が既に存在する場合、CSVファイルの情報で更新してください。
● 単体テスト及び統合テストを作成してください。
● フロント画面の作成は任意です。

-------------------------------

コーディング要件:
● Ruby on Railsフレームワーク(バージョン:Rails7.1以降, Ruby 3.3以降)を使用してください。
● ソースコードはGitで管理し、GitHubにアップロードしてください。
  ○ 作業のコミットの履歴も残してください
● GitHub CopilotやChatGPTなどの利用も問題ないですが、使用した場合は申告し
てください。

-------------------------------

コードの提出方法:
下記の内容を含むメールをjohn@spacely.co.jp 宛にお送りください。
● 課題に取り組んだリポジトリのURL
● 課題に取り組んだ合計時間
● 参考にしたページや書籍、リポジトリのリンク

よろしくお願いいたします。
```

## ⏰ Time

| Day | Time
| --- | ---
| 金曜日 (9月27日) | 5 hours
| 土曜日 (9月28日) | 5 hours
| 日曜日 (9月29日) | 4 hours
| 月曜日 (9月30日) | 2 hours
| 水曜日 (10月2日) | 3 hours
|  |
| Total | 20 hours

## 📝 Tested versions

- Ruby 3.3
- Rails 7.2
- PostgreSQL 14.13

## 🚀 Getting Started

```bash
# install the dependencies
bundle install

# create the database and migrate the schema
rails db:create db:migrate

# start the server
bin/dev
```

## 📚 API Documentation

The API documentation is available at `/api-docs` and is powered by `Swagger UI`.

Example:
- `http://localhost:3000/api-docs`
- `https://spacely-csv-importer.onrender.com/api-docs`

![API Documentation](/docs/images/api-docs.png)

You can try the API endpoints directly from the Swagger UI interface.

## 🧪 Testing

To run the tests, you can use the following command:

```bash
bundle exec rspec spec
```
All test files are located in the `spec` directory.
Coverage report is available at `/coverage/index.html`.

## 📝 Linting

To run the linter, you can use the following command:

```bash
bundle exec standardrb
```

## 📦 Deployment

CI is set up with Github Actions to run the tests and linter on every push. Pushing to the `main` branch will trigger the deployment to Render.

The web application is deployed on Render (free tier) and is available at [https://spacely-csv-importer.onrender.com/](https://spacely-csv-importer.onrender.com/).

Database is hosted on Supabase (free tier).

## 📚 Resources
Below are some resources that I referred to while working on this project:
- Book on how to design Rails applications and extend beyond the default Rails conventions
  - https://www.amazon.co.jp/Layered-Design-Ruby-Rails-Applications/dp/1801813787

- GoRails, one of my favorite resources for learning Ruby on Rails:
  - https://gorails.com/episodes/web-scraper-production-emails?autoplay=1 | Not directly related to this project but I learned in this episode that I could use SolidQueue for background processing with the `plugin :solid_queue` in `config/puma.rb` to make Puma monitor the background jobs. No need to prepare a separate worker process (good for a simple and light project like this).

- Articles on how to efficiently process large CSV files with Ruby:
  - https://dalibornasevic.com/posts/68-processing-large-csv-files-with-ruby
  - https://medium.com/@tauqeer_ahmad/using-batch-processing-to-improve-performance-when-working-with-large-datasets-in-ruby-on-rails-487abf438092

- Front-end styling with Tailwind CSS:
  - https://tailwindcss.com/docs
  - https://tailwindui.com/ | (I used all the components from here)

- Terraform for infrastructure as code:
  - https://github.com/tonystrawberry/lgtm-generator-ruby/tree/main/terraform | Refered one of my previous project to remind myself the syntax of Terraform. I use it in this project only for setting up the S3 bucket for storing the CSV files uploaded by the users.

- Ruby on Rails official documentation:
  - https://guides.rubyonrails.org/

- Render documentation for learning how to deploy Ruby on Rails applications:
  - https://docs.render.com/deploy-rails

- Avoid N+1 queries in Rails for ActiveStorage:
  - https://shuttodev.hatenablog.com/entry/2019/09/10/012916

- Of course, I also used Github Copilot for writing code faster and ChatGPT for providing me syntax of Rails methods or giving me suggestions on how to improve the code quality.

- Gems documentation. This project gave me the opportunity to explore some new gems that I haven't used before:
  - `solid_queue` for background processing
  - `rswag` for generating API documentation and testing
  - `prefixed_ids` for generating prefixed UUIDs for the properties
  - `standard` for pre-set unconfigurable rules for Ruby code formatting
  - `capybara` and `selenium-webdriver` for system testing

## 🙋🏻‍♂️ FAQ

### Where are the CSV files stored?

In production environment, the CSV files uploaded by the users are stored in an S3 bucket using ActiveStorage. The bucket is created using Terraform and the credentials are stored in the Rails credentials.

### Could you describe how you organized the code?

I followed the Rails convention of course for organizing the code. But I added some additional layers of abstraction to make the code more modular and easier to maintain and test.

For example, I used:
- the service object pattern for the CSV upload and parsing job. This pattern is quite useful for encapsulation of the business logic and keeping the controllers thin. Another option could be instead to adopt the fat model pattern, but I prefer to keep the business logic away from the models. Please check `app/services`.
- the query object pattern for building the search query. This pattern is useful for building complex queries. Please check `app/queries`.
- the decorator pattern for separating the presentation logic from the models. For example, I used the `PropertyDecorator` to format the data of some columns (e.g., `rent` to add the `円` symbol) before displaying them in the view. Having the formatted logic in the model, views, or controllers would make the code harder to maintain and test. Please check `app/decorators`.

### How did you handle the case when the same property is uploaded multiple times?

I used the `import` method provided by the `activerecord-import` gem to bulk insert the properties. This method allows me to specify the `on_duplicate_key_update` option with `{conflict_target: [:external_id], columns: :all}` to allow updating all the columns of an existing property if an existing property with the same `external_id` is found.

### How are your tables structured?

I have two main tables: `properties` and `import_histories`. I also have one join table `import_histories_properties`.
- `properties` table stores the properties imported from the CSV files.
- `import_histories` table stores the history of the import jobs. With this table, users can track the status, check the start time and the number of imported properties.
- `import_histories_properties` table is a join table that links the properties to the import histories. This table is useful for knowing which import job imported which properties.

### Explain the process of importing the CSV file.

When the user uploads a CSV file, the file is stored in an S3 bucket and the import job is enqueued in the background. The response is immediately returned to the user with the import job ID.

The task of importing the properties of a CSV file is done in the background using the `solid_queue` gem. Depending on the size of the CSV file, the import job may take some time to complete and possibly cause timeout and bad UX experience. That's why I assumed it would be better to process the job in the background.

### What kind of errors can occur during the import process?

There are several types of errors that can occur during the import process:
- Maximum file size exceeded: it is important to limit the file size to prevent any abuse. If the file size exceeds the limit, the request for uploading the file will be rejected.
- Invalid CSV file format: the CSV file must have the correct headers. If the file is not in the correct format, the import job will fail with an `Invalid headers` error.

![Invalid headers](/docs/images/invalid-headers-error.png)

- Invalid data: the rows in the CSV file must containn valid data. ActiveRecord validations are used to validate the data. If the data is invalid (for example: rent is a negative number), the import job will fail with a `Invalid rows` error and an error report will be downloadable for the user to check which rows are invalid.

![Invalid rows](/docs/images/invalid-rows-error.png)
![Error report](/docs/images/error-report.png)

- In case of any other errors, the import job will fail with a `Unknown error` error. Ideally, the error should be logged and notified through a bug tracking system.


### How well does the application handle large CSV files?

- I am using the `csv` gem to parse the CSV file and using `CSV.foreach` to read the file line by line. This method is memory efficient because it reads the file line by line and does not load the entire file into memory.
- While parsing the CSV file, the properties are imported in bulk using the `activerecord-import` gem by batch of 2000 records to avoid memory over consumption (see https://github.com/tonystrawberry/spacely-csv-importer/blob/main/app/services/imports/parse_csv_service.rb#L74)
- To prevent potential timeout errors, the import job is processed in the background using the `solid_queue` gem (in this app, for simplicity purposes, the background jobs are run in the same process as the web server but in a real production environment, the jobs should be run in a separate process/container).
- As a note, since the production environment is running on starter tier, we are limiting the concurrency of the CSV parsing job to 1 to avoid any excessive memory consumption and ensure it remains within the allowed limits of Render.

Below are some performance tests I did with the biggest file size of 200,000 rows (found in `spec/fixtures/files/valid_rows_200000_rows.csv`):

```
[BenchmarkCsvImport] Time: 51.82 seconds
```

As we can see, importing 200,000 rows takes around 52 seconds. Performing validations while importing the properties is the tasks that is taking the most time.
