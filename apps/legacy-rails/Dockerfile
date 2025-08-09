FROM ruby:2.3

# Nota: ruby:2.3 es EOL; para desarrollo local puede requerir imágenes alternativas o compilar.
# Si falla, usar rbenv en contenedor base más moderno o cambiar a 2.6 con compatibilidad.

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential libpq-dev nodejs \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock /app/
RUN bundle install || true

COPY . /app

EXPOSE 3000
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0", "-p", "3000"]
