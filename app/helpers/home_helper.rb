module HomeHelper
  def mindhub_mission
    <<-MISSION
The mission of MindHub is to create an (online) community that encourages and
supports creative professionals in the Central Valley.

The goal is to have
subscribers of the MindHub email list, creative professionals in the Fresno and
surrounding areas, share information and help each other to find jobs, find
employees, compare notes on their respective trades, and learn from each other
in an unintimidating environment.

Best of all, membership is FREE! If you would
like to join MindHub, all you need is an email address.

If you have any
questions about MindHub, please email #{mail_to "mindhub-info@listmindhub.org" }.
    MISSION
  end
end
