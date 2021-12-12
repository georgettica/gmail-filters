FROM ruby:3.0.3-alpine
RUN gem install gmail-britta
ENTRYPOINT ["/usr/local/bin/ruby"]
