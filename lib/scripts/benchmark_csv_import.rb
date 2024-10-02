require "benchmark"
require "benchmark/memory"

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

  def self.measure_memory(import_id: "imp_EdmPLw9bn3OMIQpnk7NaGQX3")
    puts("[BenchmarkCsvImport.measure_memory] Benchmarking CSV import...")

    import_history = ImportHistory.find(import_id)

    Benchmark.memory do |x|
      x.report("memory") { Imports::ParseCsvService.call(import_history:) }
    end
  end
end

# BenchmarkCsvImport.measure_realtime
BenchmarkCsvImport.measure_memory
