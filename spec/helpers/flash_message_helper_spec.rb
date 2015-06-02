require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the FlashMessageHelper. For example:
#
# describe FlashMessageHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe FlashMessageHelper, type: :helper do
  describe "flash_message" do
    it "flashes a single message" do
      flash[:info] = "it works."

      expected_html = '''
      <ul class="flash-messages">
        <li class="flash-message flash-message-info">it works.</li>
      </ul>
      '''.squish.gsub(/\> /, '>')

      expect(flash_message).to eq expected_html
    end
    it "flashes multiple messages" do
      flash[:info] = ["steven", "amethyst", "garnet", "pearl"]

      expected_html = '''
      <ul class="flash-messages">
        <li class="flash-message flash-message-info">steven</li>
        <li class="flash-message flash-message-info">amethyst</li>
        <li class="flash-message flash-message-info">garnet</li>
        <li class="flash-message flash-message-info">pearl</li>
      </ul>
      '''.squish.gsub(/\> /, '>')
      
      expect(flash_message).to eq expected_html
    end
  end
end
