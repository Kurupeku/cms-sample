# frozen_string_literal: true

require 'tempfile'
require 'csv'
require 'active_support/all'

module CsvProcessing
  def import_records(csv_text)
    result = []
    Tempfile.create do |f|
      f.write(csv_text)
      f.rewind
      CSV.foreach f.path, headers: true do |row|
        params = row.to_h.symbolize_keys
        result << find_or_update(params)
      end
    end
    result
  end

  def export_records
    CSV.generate do |csv|
      export_column = @export_params.map(&:to_s)
      csv << export_column
      @active_model.with_deleted
                   .reorder(id: :asc)
                   .pluck(*export_column).each do |rec|
        csv << rec
      end
    end
  end

  def import_template
    CSV.generate do |csv|
      csv.add_row(@permitted_params.map(&:to_s))
    end
  end

  private

  def find_or_update(params)
    record = @active_model.find_by(id: params[:id]) || @active_model.new
    record.attributes = params.delete_if { |k, _v| k == :id }
    return { status: :success, payload: record.attributes } if record.save

    { status: :error, payload: record.attributes, errors: record.errors.full_messages }
  end
end
