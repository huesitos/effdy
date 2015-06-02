module FlashMessageHelper
  def flash_message
    content_tag :ul, :class => "flash-messages" do
      message_to_html = ->(k, v) {
        content_tag :li, v, :class => "flash-message flash-message-#{k}"
      }

      flash.map do |k, v|
        if v.kind_of? Array then
          # HERE BE UNICORNS:
          # * http://stackoverflow.com/questions/8162257/passing-a-lambda-as-a-block
          # * http://blog.khd.me/ruby/ruby-currying/
          v.map(&message_to_html.curry.(k)).join
        else
          message_to_html.call k, v
        end
      end.join.html_safe
    end
  end
end
