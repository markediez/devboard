class CopyProjectRepositoryToCommitRepository < ActiveRecord::Migration[5.0]
  def change
    Commit.all.each do |commit|
      if commit.project.present? and commit.project.repositories.first.present?
        commit.repository_id = commit.project.repositories.first.id
        commit.save!
      end
    end
  end
end
