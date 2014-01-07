module Mongoid
  module Shell
    module Properties
      module Primary
        attr_accessor :primary

        # primary database host
        def primary
          @primary || begin
            if Mongoid::Shell.mongoid2?
              raise Mongoid::Shell::Errors::MissingPrimaryNodeError unless session
              raise Mongoid::Shell::Errors::SessionNotConnectedError unless session.connection
              address = "#{session.connection.host}:#{session.connection.port}"
              address == "localhost:27017" ? nil : address
            else
              raise Mongoid::Shell::Errors::SessionNotConnectedError unless session.cluster.nodes.any?
              node = session.cluster.nodes.find(&:primary?)
              raise Mongoid::Shell::Errors::MissingPrimaryNodeError unless node
              if Mongoid::Shell.mongoid3?
                node.address == "localhost:27017" ? nil : node.address
              else
                node.address.original == "localhost:27017" ? nil : node.address.original
              end
            end
          end
        end
      end
    end
  end
end
