module ProjectsHelper
  def project_status_in_words(status)
    return status.to_s.gsub(/_/, ' ').capitalize
  end
end
