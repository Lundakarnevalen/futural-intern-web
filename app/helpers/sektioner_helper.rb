module SektionerHelper
  def medlemskap_status k
    if k.medlem_af && k.medlem_kar && k.medlem_nation
      'medlem-ok'
    else
      'medlem-fail'
    end
  end
end
