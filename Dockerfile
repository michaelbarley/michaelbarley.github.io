FROM ruby:3.3-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /site

COPY Gemfile ./
RUN bundle install

EXPOSE 4000 35729

CMD bundle install && \
    bundle exec jekyll serve \
      --host 0.0.0.0 \
      --livereload \
      --force_polling \
      --incremental
