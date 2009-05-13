#!/usr/bin/env ruby
repository_path = ARGV[0]
revision = ARGV[1]

require 'rubygems'
require 'tinder'
campfire = Tinder::Campfire.new 'your-campfire-sub-domain'
campfire.login 'email@of.user.with.access.to.cf.com', 'their-password'
# replace these with your campfire room ids
guitarhero_room    = campfire.rooms.detect { |r| '289609' == r.id }
cod5_room          = campfire.rooms.detect { |r| '288431' == r.id }
zomg_room          = campfire.rooms.detect { |r| '299696' == r.id }
dirs_changed       = `svnlook dirs-changed #{repository_path} -r #{revision}`

# from : http://blog.macromates.com/2006/wrapping-text-with-regular-expressions/
def wrap_text(txt, col = 80)
  txt.gsub(/(.{1,#{col}})( +|$)\n?|(.{#{col}})/,"\\1\\3\n")
end

# adjust these to match your own project directories
gh_regular_expression = /guitarhero/
if dirs_changed =~ gh_regular_expression
  last_changed_author = `svnlook info -r#{revision} #{repository_path}`.split("\n").first
  log_message = `svnlook propget  svn:log -r#{revision} --revprop`
  log_message = wrap_text("#{last_changed_author} committed revision #{revision} with log message: #{log_message}")
  guitarhero_room.paste(log_message)
  # post the link to our redmine
  guitarhero_room.speak("http://agora.redmine.made.up.crap.com/repositories/diff/guitarhero?rev=#{revision}")
end

if dirs_changed =~ /cod5/
  last_changed_author = `svnlook info -r#{revision} #{repository_path}`.split("\n").first
  diff = `svnlook diff -r#{revision} #{repository_path}`
  log_message = `svnlook propget #{repository_path} svn:log -r#{revision} --revprop`
  log_message = wrap_text("#{last_changed_author} committed revision #{revision} with log message: #{log_message}")
  cod5_room.paste("#{'-' * 80}\n#{log_message}\n#{'-' * 80}\n" + diff)
end

if dirs_changed =~ /zomg/
  last_changed_author = `svnlook info -r#{revision} #{repository_path}`.split("\n").first
  log_message = `svnlook propget #{repository_path} svn:log -r#{revision} --revprop`
  log_message = wrap_text("#{last_changed_author} committed revision #{revision} with log message: #{log_message}")
  zomg_room.paste(log_message)
  zomg_room.speak("http://agora.redmine.made.up.crap.com/repositories/diff/zomg?rev=#{revision}")
end
