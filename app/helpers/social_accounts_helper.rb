module SocialAccountsHelper
  def generate_link(social_account)
    network = social_account.social_network
      if network == "GitHub"
        return "https://github.com/#{social_account.user_name}"
      end
      if network == "Telegram"
        return "https://t.me/#{social_account.user_name}"
      end
      if network == "Facebook"
        return "https://facebook.com/#{social_account.user_name}"
      end
      if network == "Twitter"
        return "https://twitter.com/#{social_account.user_name}"
      end
      if network == "GitLab@HPI"
        return "https://gitlab.hpi.de.com/#{social_account.user_name}"
      end
      if network == "Slack"
        return "https://slack.com/"
      end
      if network == "Discord"
        return "https://discordapp.com/#{social_account.user_name}"
      end
      return "#"
  end
  def get_supported_social_networks 
    return [["GitHub", "GitHub"], ["Telegram", "Telegram"], ["Facebook", "Facebook"], ["Twitter", "Twitter"], ["GitLab@HPI", "GitLab@HPI"], ["Slack", "Slack"], ["Discord", "Discord"]]
  end
end
