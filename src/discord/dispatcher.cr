class BaseInfo end


class Crystaldiscord::Dispatcher
    alias PROC = BaseInfo -> Nil

    @callbacks = {} of String => Array(PROC)

    def register(name : String, b : PROC)
        @callbacks[name] << b
    end

    def dispatch(name : String, info : BaseInfo)
        if blocks = @callbacks[name]
            blocks.each do |block|
                spawn do
                    block.call info
                end 
            end
        end
    end
end
