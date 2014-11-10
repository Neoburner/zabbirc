module Zabbirc
  module Zabbix
    module Resource
      module Finders
        def find id, *options
          options = options.extract_options!
          options = options.reverse_merge({
                                              :"#{model_name}ids" => id
                                          })
          res = api.send(model_name).get options
          binding.pry if $catch
          if res.size == 0
            nil
          elsif res.size > 1
            raise StandardError, "#{model_name.camelize} ID is not unique"
          else
            self.new res.first
          end
        rescue Errno::ETIMEDOUT => e
          Zabbirc.logger.error "Zabbix::Resource#find: #{e}"
          nil
        end

        def get *options
          options = options.extract_options!
          res = api.send(model_name).get options
          res.collect do |obj|
            self.new obj
          end
        rescue Errno::ETIMEDOUT => e
          Zabbirc.logger.error "Zabbix::Resource#get: #{e}"
          []
        end

      end
    end
  end
end