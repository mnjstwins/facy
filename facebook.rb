module Facy
  module Facebook
    attr_reader :authen_hash, :rest

    #RULE: all facebook method should be prefix with facebook
    def facebook_stream_fetch
      streams = @graph.get_connections("me", "home")
      streams.each { |post| stream_print_queue << graph2item(post) }
    end

    def facebook_notification_fetch
      notifications = @graph.get_connections("me", "notifications")
      notifications.each { |notifi| notification_print_queue << graph2item(notifi) }
    end

    def facebook_post(text)
      ret = @graph.put_wall_post(text)
      p ret
      instant_output(Item.new(info: 'success', message: "post #{id} has been posted to your wall"))
    end

    def facebook_like(post_id)
      raise FacebookGraphReqError unless @graph.put_like(post_id)
      instant_output(Item.new(info: 'success', message: "post #{post_id} has been liked"))
    end
  end 

  init do
    oauth = Koala::Facebook::OAuth.new(
      config[:app_id], 
      config[:app_secret], 
      config[:redirect_uri]
    )
    token = oauth.get_token_from_session_key(config[:session_key])
    @graph = Koala::Facebook::API.new(token) 
  end
  extend Facebook
end
