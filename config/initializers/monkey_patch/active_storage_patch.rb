# Make ActiveStorage analyze task synchronous to avoid the error of
# background jobs not being able to find the attached file.
# We want to make sure the file is attached before the background job is enqueued.
# Reference: https://stackoverflow.com/questions/74339227/rails-activestorage-and-sidekiq-why-is-attach-not-working-with-async-job
module ActiveStorage::Blob::Analyzable
  def analyze_later
    analyze
  end
end
