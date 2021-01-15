module SocialAccountsHelper
  # rubocop:disable Metrics/CyclomaticComplexity
  def generate_link(social_account)
    network = social_account.social_network
    return "https://github.com/#{social_account.user_name}" if network == 'GitHub'
    return "https://t.me/#{social_account.user_name}" if network == 'Telegram'
    return "https://facebook.com/#{social_account.user_name}" if network == 'Facebook'
    return "https://twitter.com/#{social_account.user_name}" if network == 'Twitter'
    return "https://gitlab.hpi.de.com/#{social_account.user_name}" if network == 'GitLab@HPI'
    return 'https://slack.com/' if network == 'Slack'
    return "https://discordapp.com/#{social_account.user_name}" if network == 'Discord'

    '#'
  end

  # rubocop:enable Metrics/CyclomaticComplexity
  def supported_social_networks
    [
      %w[GitHub GitHub],
      %w[Telegram Telegram],
      %w[Facebook Facebook],
      %w[Twitter Twitter],
      ['GitLab@HPI', 'GitLab@HPI'],
      %w[Slack Slack],
      %w[Discord Discord]
    ]
  end
end
