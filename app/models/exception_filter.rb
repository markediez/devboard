class ExceptionFilter < ApplicationRecord
	validates :kind, :inclusion => { :in => [ 'SET_PROJECT', 'CLEAN_SUBJECT' ] }

	# Applies filter to the given 'exception'. Returns true if any data changed in exception.
	def apply(exception)
		raise "ExceptionFilter only applies to ExceptionReport" unless exception.kind_of?(ExceptionReport)

		regex = Regexp.new(self.pattern)

		if regex.match(exception[self.concern]) != nil
			case kind
				when 'SET_PROJECT'
					exception.project = Project.find_by_name(self.value)
					return true
				when 'CLEAN_SUBJECT'
					exception.subject.gsub!(value, '')
					return true
			end
		end

		return false
	end
end

# Examples

# Set project if e-mail is from a certain address
## if concern == pattern then set field to value2

# Clean up subject line if e-mail is from a certain address
## if concern == pattern then set field to gsub(field)
