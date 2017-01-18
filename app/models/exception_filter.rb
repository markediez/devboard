class ExceptionFilter < ApplicationRecord
	validates :kind, :inclusion => { :in => [ 'SET_PROJECT', 'CLEAN_SUBJECT' ] }

	# Applies filter to the given 'exception'. Returns true if any data changed in exception.
	def apply(exception)
		raise "ExceptionFilter only applies to ExceptionReport" unless exception.kind_of?(ExceptionReport)

		regex = Regexp.new(self.pattern)

		if regex.match(exception[self.concern]) != nil
			case kind
				# Sets 'project' equal to Project.find_by_name(value)
				when 'SET_PROJECT'
					Rails.logger.info "ExceptionReport ##{exception.id} filtered by SET_PROJECT"
					exception.project = Project.find_by_name(self.value)
					return true
				# Removes any matches to 'value' from exception subject
				when 'CLEAN_SUBJECT'
					Rails.logger.info "ExceptionReport ##{exception.id} filtered by CLEAN_SUBJECT"
					exception.subject.gsub!(value, '')
					return true
			end
		end

		return false
	end
end
