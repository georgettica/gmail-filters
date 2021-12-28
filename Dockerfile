FROM ruby:3.1.0-alpine
RUN gem install gmail-britta
ENTRYPOINT ["/usr/local/bin/ruby"]
