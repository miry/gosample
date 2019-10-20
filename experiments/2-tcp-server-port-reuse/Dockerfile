FROM crystallang/crystal:0.31.0

WORKDIR /app
ADD server.cr /app/
RUN crystal build --release server.cr

EXPOSE 3000
CMD ["/app/server"]
