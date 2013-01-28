module MopedSessionHelper
  # returns a Moped session with stubbed address resolution
  def moped_session(name)
    config = File.join(File.dirname(__FILE__), "../../support/config/mongoid.yml")
    Mongoid.load! config, :production
    Moped::Node.any_instance.stub(:resolve_address)
    Mongoid::Sessions.with_name(name)
  end
end
