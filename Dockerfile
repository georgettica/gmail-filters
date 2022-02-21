FROM ruby:3.1.1-alpine
RUN gem install gmail-britta
ENTRYPOINT ["/usr/local/bin/ruby"]
