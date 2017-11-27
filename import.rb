# Copyright (c) 2015 oti

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require 'highline/import'
require 'mechanize'

# Decomoji Importer
class Importer
  def initialize
    @page = nil
    @agent = Mechanize.new
  end
  attr_accessor :page, :agent

  def import_decomojis
    move_to_emoji_page
    upload_decomojis
  end

  private

  def login
    team_name  = ask('Your slack team name(subdomain): ')
    email      = ask('Login email: ')
    password   = ask('Login password(hidden): ') { |q| q.echo = false }

    emoji_page_url = "https://#{team_name}.slack.com/admin/emoji"

    page = agent.get(emoji_page_url)
    page.form.email = email
    page.form.password = password
    @page = page.form.submit
  end

  def enter_two_factor_authentication_code
    page.form['2fa_code'] = ask('Your two factor authentication code: ')
    @page = page.form.submit
  end

  def move_to_emoji_page
    loop do
      if page && page.form['signin_2fa']
        enter_two_factor_authentication_code
      else
        login
      end

      break if page.title.include?('Emoji')
      puts 'Login failure. Please try again.'
      puts
    end
  end

  def upload_decomojis
    Dir.glob(File.expand_path(File.dirname(__FILE__)) + "/emoji/*.png").each do |path|
      basename = File.basename(path, '.*')

      # skip if already exists
      next if page.body.include?(":#{basename}:")

      puts "importing #{basename}..."

      form = page.form_with(action: '/customize/emoji')
      form['name'] = basename
      form.file_upload.file_name = path
      @page = form.submit
    end
  end
end

importer = Importer.new
importer.import_decomojis
puts 'Done!'