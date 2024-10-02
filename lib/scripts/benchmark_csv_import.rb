require "benchmark"

# Description: This script is responsible for benchmarking the CSV import process.
class BenchmarkCsvImport
  def self.measure_realtime(import_id: "imp_QekXdp7RVne5yuwnNqlA9D8b")
    puts("[BenchmarkCsvImport.measure_realtime] Benchmarking CSV import...")

    import_history = ImportHistory.find(import_id)

    time = Benchmark.realtime do
      Imports::ParseCsvService.call(import_history:)
    end

    puts("[BenchmarkCsvImport.measure_realtime] Time: #{time.round(2)} seconds")
  end
end

BenchmarkCsvImport.measure_realtime
