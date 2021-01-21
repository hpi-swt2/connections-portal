module SocialAccountsHelper
  LINK_MAP = {
    'GitHub' => ->(name) { "https://github.com/#{name}" },
    'Telegram' => ->(name) { "https://t.me/#{name}" },
    'Facebook' => ->(name) { "https://facebook.com/#{name}" },
    'Twitter' => ->(name) { "https://twitter.com/#{name}" },
    'GitLab@HPI' => ->(name) { "https://gitlab.hpi.de.com/#{name}" },
    'Slack' => proc { 'https://slack.com/' },
    'Discord' => ->(name) { "https://discordapp.com/#{name}" }
  }.freeze

  ICON_MAP = {
    'GitHub' => "fa-github",
    'Telegram' => "fa-telegram",
    'Facebook' => "fa-facebook" ,
    'Twitter' => "fa-twitter",
    'GitLab@HPI' => "fa-gitlab",
    'Slack' => "fa-slack",
    'Discord' => "fa-discord"
  }.freeze

  def generate_link(social_account)
    LINK_MAP[social_account.social_network]&.call(social_account.user_name)
  end

  def supported_social_networks
    %w[GitHub Telegram Facebook Twitter GitLab@HPI Slack Discord].map do |network|
      [network, network]
    end
  end

  def generate_icon(social_account)
    ICON_MAP[social_account.social_network]
  end
end
