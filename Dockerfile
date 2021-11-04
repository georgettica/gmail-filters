FROM ruby:3.0.2-alpine
RUN gem install gmail-britta
ENTRYPOINT ["/usr/local/bin/ruby"]
