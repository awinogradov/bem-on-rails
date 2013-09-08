#!/usr/bin/env ruby

require "bem-on-rails/thor/runner"
$thor_runner = true
$bemonrails_runner = true
::Bemonrails::Thor::Runner.start