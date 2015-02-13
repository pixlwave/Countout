class IAPController < UIViewController
  extend IB

  outlet :titleLabel, UILabel
  outlet :descriptionLabel, UILabel
  outlet :priceLabel, UILabel

  def viewDidLoad

    Appearance::IAP.retrieve do |product, error|
      if product
        @titleLabel.text = product[:title]
        @descriptionLabel.text = product[:description]
        @priceLabel.text = product[:formatted_price]
      else
        puts error
      end
    end

  end

  def done

    self.presentingViewController.dismissModalViewControllerAnimated(true)

  end

  def purchase

    Appearance::IAP.purchase do |status, transaction|
      case status
      when :in_progress
        puts "In progress"
      when :deferred
        puts "deferred"
      when :purchased
        puts "Purchased, yay!"
        Turnkey.archive(true, "Appearance")
      when :canceled
        puts "Cancelled, oh well"
      when :error
        puts "Error", transaction.error.localizedDescription # => error message
      end
    end

  end

  def restore

    Appearance::IAP.restore do |status, product|
      if status == :restored
        puts "Restored"
        Turnkey.archive(true, "Appearance")
      end
    end

  end

end