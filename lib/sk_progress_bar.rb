require "sk_progress_bar/version"

module SkProgressBar
  # Update Progress Bar
  def self.update_progress_bar(percentage, message, jid = nil, channel = `sk_progress_bar_channel`)
    ActionCable.server.broadcast channel,
                                 progress_status: percentage,
                                 message:  message,
                                 sk_process_id: jid
  end

  # Return Percentage and Message result of cycle
  def self.progress_status(cycle_index, objects_count)
    percentage = (cycle_index + 1) * 100 / objects_count
    message = percentage == 100 ? 'Done' : 'Almost done'
    { percentage: percentage, message: message }
  end

  # Add/Update record in ProgressBar table
  def self.create_update_db(percentage, message, jid=nil)
    db_record = jid.present? ? ProgressBar.find_by(sk_process_id: jid) : nil
    if db_record.present?
      db_record.update( message: message, sk_process_id: jid, percentage: percentage )
    else
      new_record = ProgressBar.new( message: message, sk_process_id: jid, percentage: percentage )
      new_record.save
    end
  end
end
