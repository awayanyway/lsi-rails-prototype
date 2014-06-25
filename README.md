lsi-rails prototype application with dial-a-device
=============


## set up your own application on Ubuntu > 13.04 64bit for development


* Install Ruby on Rails environment

		$ sudo apt-get install -y build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion pkg-config cmake

		$ sudo apt-get install -y libgdbm-dev libncurses5-dev automake libtool bison libffi-dev
		$ curl -L get.rvm.io | bash -s stable --auto
		
		$ /bin/bash -l -c "rvm requirements"
		$ /bin/bash -l -c "rvm autolibs enable"
		$ /bin/bash -l -c "rvm install 1.9.3"
		$ /bin/bash -l -c "rvm use 1.9.3 --default"
		
		$ /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"
		

* Install PostgreSQL

		$ sudo apt-get install -y postgresql-common postgresql-9.3 libpq-dev postgresql-client-9.3 postgresql-contrib-9.3

		$ sudo -u postgres -i /etc/init.d/postgresql start && sudo -u postgres -i psql --command "CREATE ROLE lsirailsprototype SUPERUSER LOGIN PASSWORD 'lsirailsprototype';"

		$ sudo -u root -i echo "host all all 0.0.0.0/0 md5" >> /etc/postgresql/9.3/main/pg_hba.conf
		
		$ sudo -u root -i echo "listen_addresses='*'" >> /etc/postgresql/9.3/main/postgresql.conf
		
* Install additional libraries

		$ sudo apt-get install -y openbabel imagemagick

* Clone the project and set it up

        git clone https://github.com/Cominch/lsi-rails-prototype.git
        cd lsi-rails-prototype
        bundle install --without production
        rake db:create:all
        rake db:migrate
        rake db:seed

* Go!

	Start the rails server ("thin" webserver) in development environment
		
		foreman start

	If rails is not detected, update your bash profile again:

		. ~/.bash_profile
		
	Open your webbrowser:
	
		http://localhost:5000/
		
## deploy on your local server

* Customize parameters

	host name etc. in

		config/initializers/x-customization.rb

	mail server in
		
		config/environments/localserver.rb

* Create the background service

		rvmsudo foreman export upstart /etc/init -e localserver.env -a lsi-rails-prototype -u yourusername
		
* Enable port forwarding

		iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 5000

* Make iptables permanent

		sudo su
		iptables-save > /etc/iptables.conf
		
		nano /etc/network/interfaces
		
		-- add this line after each adapter:
		post-up iptables-restore < /etc/iptables.conf
		
## deploy on heroku

* create an account on heroku and install toolbelt

	Create an account on heroku.com
	
	TODO: Explain how to install heroku toolbelt
	
		cd lsi-rails-prototype

		heroku login

* create your app on heroku

		heroku create yourappname

		heroku labs:enable user-env-compile

		heroku config:set BUNDLE_WITHOUT="development:developments3:test:localserver"

		heroku labs:enable websockets 

		heroku addons:add sendgrid

		heroku config:add BUILDPACK_URL=https://github.com/ddollar/heroku-buildpack-multi

		heroku config:add LD_LIBRARY_PATH=/app/vendor/openbabel/lib

		git push heroku master

		heroku run rake db:migrate

		heroku run rake db:seed


## (incomplete) instant setup on heroku from windows

* Install Heroku Toolbelt

		https://toolbelt.heroku.com/windows
		
* Open a command shell
		
		git clone https://github.com/Cominch/lsi-rails-prototype
		
		cd dial-a-device
		
		heroku login

		heroku create
		
		heroku ...
		
		git push heroku master

		heroku ps:scale worker=1
		
* Open a web browser

		http://yourappname.herokuapp.com




## Additional features: access legacy devices via vnc

* set up websockify gateway

		git clone https://github.com/hsanjuan/websockify


* fill up target list

		cd websockify

		nano targets

		ipadress:port:token

* add to crontab
	
		crontab -e

		append this line:
	
		@reboot cd /home/username/websockify && ./websockify :8091 --target-list ./targets

## License

	[GPLv3](http://www.gnu.org/licenses/gpl.html)
