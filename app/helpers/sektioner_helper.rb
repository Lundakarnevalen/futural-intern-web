# -*- encoding : utf-8 -*-
module SektionerHelper
  def medlemskap_status k
    if k.medlem_af && k.medlem_kar && k.medlem_nation && k.medlem_kollad
      'medlem-ok'
    else
      'medlem-fail'
    end
  end
  
  def aktiv_status k
    if k.aktiv
      'medlem-ok'
    else
      'medlem-fail'
    end
  end

end
