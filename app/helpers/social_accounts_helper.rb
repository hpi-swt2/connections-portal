module SocialAccountsHelper
  LINK_MAP = {
    'GitHub' => ->(name) { "https://github.com/#{name}" },
    'Telegram' => ->(name) { "https://t.me/#{name}" },
    'Facebook' => ->(name) { "https://facebook.com/#{name}" },
    'Twitter' => ->(name) { "https://twitter.com/#{name}" },
    'GitLab@HPI' => ->(name) { "https://gitlab.hpi.de/#{name}" },
    'Slack' => proc { 'https://slack.com/' },
    'Discord' => proc { 'https://discordapp.com/' }
  }.freeze

  def generate_link(social_account)
    LINK_MAP[social_account.social_network]&.call(social_account.user_name)
  end

  def supported_social_networks
    %w[GitHub Telegram Facebook Twitter GitLab@HPI Slack Discord].map do |network|
      [network, network]
    end
  end
end
