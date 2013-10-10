FROM ubuntu:12.04
MAINTAINER sameer@damagehead.com

RUN sed 's/main$/main universe/' -i /etc/apt/sources.list
RUN apt-get update && apt-get upgrade -y && apt-get clean # 20130925

RUN apt-get install -y python-software-properties && add-apt-repository -y ppa:git-core/ppa && \
		apt-get update && apt-get install -y sudo vim unzip wget curl nginx git-core postfix \
			mysql-server openssh-server redis-server python-docutils postfix  && apt-get clean

RUN apt-get install -y gcc g++ make libcurl4-openssl-dev libssl-dev \
      libicu-dev libmysqlclient-dev libxml2-dev libxslt1-dev libffi-dev libyaml-dev \
      zlib1g-dev libgdbm-dev libreadline-dev libncurses5-dev && apt-get clean

RUN wget ftp://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p448.tar.gz -O - | tar -zxf - -C /tmp/ && \
    cd /tmp/ruby-1.9.3-p448/ && ./configure --enable-pthread --prefix=/usr && make && make install && \
    cd /tmp/ruby-1.9.3-p448/ext/openssl/ && ruby extconf.rb && make && make install && \
    cd /tmp/ruby-1.9.3-p448/ext/zlib && ruby extconf.rb && make && make install && cd /tmp \
    rm -rf /tmp/ruby-1.9.3-p448 && gem install --no-ri --no-rdoc bundler

RUN apt-get install -y supervisor

ADD resources/6-1-stable.tar.gz /gitlab/setup/6-1-stable.tar.gz
ADD resources/v1.7.1.tar.gz /gitlab/setup/v1.7.1.tar.gz
ADD resources/cache/ /gitlab/setup/cache/
ADD resources/install /gitlab/setup/install
ADD resources/start /gitlab/start
RUN chmod 755 /gitlab/start /gitlab/setup/install && /gitlab/setup/install

ADD resources/authorized_keys /root/.ssh/
RUN chmod 700 /root/.ssh && chmod 600 /root/.ssh/authorized_keys && chown root:root -R /root/.ssh

EXPOSE 22
EXPOSE 80

CMD ["/gitlab/start"]
