module Bemonrails
    module ConsoleMessages
        def print_message(message, color)
            check_argument_data_type(message, String)
            check_argument_data_type(color, String)

            color = case color
                        when 'green' then "\e[0;32m"
                        when 'red' then "\e[0;31m"
                        when 'blue' then "\e[0;34m"
                        when 'cyan' then "\e[0;36m"
                        when 'purple' then "\e[0;35m"
                        when 'yellow' then "\e[1;33m"
                        else ''
                    end

            puts "#{color + message} \e[0m"
        end

        def check_argument_data_type(argument, type)
            raise print_message("#{argument} must be a #{type.to_s}", 'red') unless argument.kind_of? type
        end
    end
end