class BaseInfo end

alias PROC = BaseInfo -> Nil

class Crystaldiscord::Dispatcher
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
