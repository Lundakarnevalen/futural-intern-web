module KarnevalisterHelper
  def gender_specific k
    if k.kon.nil?
      'det'
    else
      case k.kon.name
      when 'Man'
        'honom'
      when 'Kvinna'
        'henne'
      else
        'henom'
      end
    end
  end
end
