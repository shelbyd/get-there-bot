class PercentagePresenter

  def self.present(string)
    "#{(string.to_f * 100).round(2)}%"
  end
end