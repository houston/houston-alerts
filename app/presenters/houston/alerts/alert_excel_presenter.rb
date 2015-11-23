class Houston::Alerts::AlertExcelPresenter
  include OpenXml::Xlsx::Elements

  attr_reader :alerts

  def initialize(alerts)
    @alerts = alerts
  end

  def to_s
    package = OpenXml::Xlsx::Package.new
    worksheet = package.workbook.worksheets[0]

    alerts = Houston.benchmark "[#{self.class.name.underscore}] Load objects" do
      self.alerts.load
    end if self.alerts.is_a?(ActiveRecord::Relation)

    title = {
      font: Font.new("Calibri", 16) }
    heading = {
      alignment: Alignment.new("left", "center") }
    general = {
      alignment: Alignment.new("left", "center") }
    timestamp = {
      format: NumberFormat::DATETIME,
      alignment: Alignment.new("right", "center") }
    number = {
      alignment: Alignment.new("right", "center") }

    worksheet.add_row(
      number: 2,
      cells: [
        { column: 2, value: "Alerts", style: title, height: 24 }])

    worksheet.add_row(
      number: 3,
      cells: [
        { column: 2, value: "Type", style: heading },
        { column: 3, value: "Project", style: heading },
        { column: 4, value: "Summary", style: heading },
        { column: 5, value: "Created", style: heading },
        { column: 6, value: "Closed", style: heading },
        { column: 7, value: "Deadline", style: heading },
        { column: 8, value: "Assigned", style: heading }
      ])

    alerts.each_with_index do |alert, i|
      worksheet.add_row(
        number: i + 4,
        cells: [
          { column: 2, value: alert.type, style: general },
          { column: 3, value: alert.project.try(:name), style: general },
          { column: 4, value: alert.summary, style: general },
          { column: 5, value: alert.opened_at, style: timestamp },
          { column: 6, value: alert.closed_at, style: timestamp },
          { column: 7, value: alert.deadline, style: timestamp },
          { column: 8, value: alert.checked_out_by.try(:name), style: general }
        ])
    end

    worksheet.column_widths({
      1 => 3.83203125,
      2 => 11.1640625,
      3 => 15.6640625,
      4 => 87.1640625,
      5 => 15,
      6 => 15,
      7 => 15,
      8 => 13.33203125,
    })

    worksheet.add_table 1, "Alerts", "B3:H#{alerts.length + 3}", [
      TableColumn.new("Type"),
      TableColumn.new("Project"),
      TableColumn.new("Summary"),
      TableColumn.new("Created"),
      TableColumn.new("Closed"),
      TableColumn.new("Deadline"),
      TableColumn.new("Assigned")
    ]

    Houston.benchmark "[#{self.class.name.underscore}] Prepare file" do
      package.to_stream.string
    end
  end

end
