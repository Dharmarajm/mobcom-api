class AddAttendanceLogToTimeSheet < ActiveRecord::Migration[5.1]
  def change
    add_column :time_sheets, :attendance_log, :boolean, default: true
  end
end
