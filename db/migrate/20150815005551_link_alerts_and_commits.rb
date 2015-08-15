class LinkAlertsAndCommits < ActiveRecord::Migration
  def up
    create_table :alerts_commits, id: false do |t|
      t.references :alert, :commit
      t.index [:alert_id, :commit_id], unique: true
    end

    commits = Commit.where("message ~ '{{'")
    pbar = ProgressBar.new("commits", commits.count)
    commits.find_each do |commit|
      commit.associate_alerts_with_self
      pbar.inc
    end
    pbar.finish
  end

  def down
    drop_table :alerts_commits
  end
end
