require 'simplecov'
require 'simplecov_small_badge'
SimpleCovSmallBadge::Formatter.class_eval do # https://github.com/MarcGrimme/simplecov-small-badge/issues/15
  private

  def state(covered_percent)
    if SimpleCov.minimum_coverage[:line]&.positive?
      if covered_percent >= SimpleCov.minimum_coverage[:line]
        'good'
      else
        'bad'
      end
    else
      'unknown'
    end
  end
end
