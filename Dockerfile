FROM ruby:3.2.0-alpine
RUN gem install gmail-britta
ENTRYPOINT ["/usr/local/bin/ruby"]
