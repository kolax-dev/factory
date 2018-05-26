class Factory

	include Enumerable

	 def self.new(*args, &block)

	 	class_name = args.shift  if (args[0].is_a?(String) && args[0].match(/[A-Z]/))

		obj = Class.new  do

			attr_accessor :vars

			define_method :initialize do |*vars|
				raise "ArgumentError" unless vars.count == args.count
				@args = args
				@vars = vars
			end

		  class_eval(&block) if block

			args.each_with_index do |item, index|
				define_method item do
					@vars[index]
				end
			end

		  define_method :== do |other|
			    if (other.is_a? obj) && (@vars == other.vars)
			      true
			    else
			      false
			    end
			end

			alias :eql? :==

			def each
				  if block_given?
				    yield(@vars)
				  else
				     'no block'
				  end
			end

			def to_a
				@vars
			end

			alias :values :to_a

			def values_at *items
				arr = []
				items.each do |item|
					arr << @vars[item]
				end
				arr
			end

			def to_h
				hash = {}
				@args.each_with_index do |item, index|
					hash[item] = @vars[index]
				end
				hash
			end

			def dig (*items)
				to_h.dig(*items)
			end

			def to_s
				str = to_h.collect{ |k, v| "#{k}='#{v}'" }.join(', ')
               "#<factory #{self.class.name} #{str}>"
			end

			alias :inspect  :to_s

			def [] (num)
				if num.is_a? Numeric
				     @vars[num]
				else
					@args.each_with_index do |item, index|
				    	return @vars[index]  if num.to_s == item.to_s
					end
				end
			end

			def []= (num,var)
				if num.is_a? Numeric
				     @vars[num] = var
				else
					@args.each_with_index do |item, index|
				    	return @vars[index] = var  if num.to_s == item.to_s
					end
				end
			end

			def each_pair
				  if block_given?
				  	@args.each_with_index do |item, index|
						yield(item,@vars[index])
					end
				  else
				    puts 'no block'
				  end
			end
			def select
				  if block_given?
				  	arr = []
					@vars.each do |item|
						arr.push(item) if yield(item)
					end
					arr
				  else
				    @vars.each.class
				  end
			end

			def length
				@vars.count
			end

			alias :size :length

			def members
				arr = []
				@args.each_with_index do |item|
					arr.push(item)
				end
			end

		end

		class_name ? const_set(class_name, obj) : obj

	 end

end
