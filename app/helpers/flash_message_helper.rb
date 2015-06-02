module FlashMessageHelper
    def flash_message
        content_tag :ul, :class => "flash-messages" do
            flash.map do |k, v|
                content_tag :li, v, :class => "flash-message flash-message-#{k}"
            end.join().html_safe
        end
    end
end
