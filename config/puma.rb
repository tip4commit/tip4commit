# frozen_string_literal: true

max_threads = Integer(ENV.fetch('RAILS_MAX_THREADS', 5))
threads max_threads, max_threads

# 0 = single process (threads only), which suits a small host.
workers Integer(ENV.fetch('WEB_CONCURRENCY', 0))
preload_app!

port ENV.fetch('PORT', 3000)
environment ENV.fetch('RAILS_ENV', 'development')
pidfile ENV['PIDFILE'] if ENV['PIDFILE']

plugin :tmp_restart
