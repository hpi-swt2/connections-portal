web: bin/rails server -p ${PORT:-5000} -e $RAILS_ENV
release: bin/rails db:migrate && bin/rake devise:create_demo_user