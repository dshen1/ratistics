require 'zlib'
require 'csv'

module Ratistics

  # Helpers for loading sample data from comma separated value (CSV)
  # and fixed-width field (dat) files.
  module Load
    extend self

    # Convert an individual CSV record into a Ruby data structure
    # suitable for further processing. Leading and trailing
    # whitespace will be trimmed from all record values.
    #
    # The second parameter is an optional record definition which
    # describes individual fields in the CSV record. There
    # is one element in the record definition for each field in the
    # record. When a definition is omitted the record will be returned
    # as an array with one element for every field in the CSV.
    # The array will be ordered according to the original record. When
    # a record definition is given the record will be returned as a
    # hash with one key for every field in the definition. If
    # there are fewer fields in the definition than in the record
    # only the first *n* fields will be returned, where *n* is the
    # number of fields in the definition. Fields defined as *nil*
    # will also be skipped.
    #
    # Each field in the definition can consist of up to two values.
    # When two values are given the field definition must be an array.
    # When only one value is given the field can be a single-element
    # array or just the value. The first value for each field definition
    # can be any data type. It is the field name (key for the returned
    # hash). The second (optional) value must be either a symbol or
    # a lambda. When a symbol is given the corresponding method will
    # be called on the data value before being returned. For example,
    # to convert the data to an integer pass *:to_i* as the second
    # field element and the *#to_i* method will be called. When the
    # second element is a lambda the block must accept exactly one
    # parameter. The lambda will be called for the field and the
    # string field value will be passed as the block the argument.
    # The use of lambdas this way allows for complex field processing.
    #
    # @example Simple field definition
    #   definition = [
    #     :place,
    #     :div_tot,
    #     :div,
    #     :guntime,
    #     :nettime,
    #     :pace,
    #     :name,
    #     :age,
    #     :gender,
    #     :race_num,
    #     :city_state
    #   ]
    #
    # @example Complex field definition
    #   definition = [
    #     [:place, lambda {|i| i.to_i}],
    #     nil,
    #     :div,
    #     :guntime,
    #     :nettime,
    #     :pace,
    #     [:name],
    #     [:age, :to_i],
    #     [:gender],
    #     [:race_num, :to_i],
    #     [:city_state]
    #   ]
    #
    # @param [String, Array] data the CSV data to be processed
    # @param [Array] definition the record definition for processing
    #   individual fields (see above)
    # @param [Hash] opts options array compatable with the Ruby
    #   standard library CSV module
    #
    # @return [Array, Hash] an array of values when no record definition
    #   is given or a hash with keys matching the record definition
    #
    # @see http://ruby-doc.org/stdlib-1.9.3/libdoc/csv/rdoc/CSV.html
    def csv_record(data, definition = nil, opts = {})

      if data.is_a? String
        data = CSV.parse(data, opts) {|row| break(row) }
      end

      unless definition.nil?
        field = {}
        definition.each_index do |index|
          name, cast = definition[index]
          next if name.nil?
          if cast.is_a? Symbol
            field[name] = data[index].send(cast)
          elsif cast.is_a? Proc
            field[name] = cast.call(data[index])
          else
            field[name] = data[index]
          end
        end
        data = field
      end

      return data
    end

    # Convert an string representing multiple CSV records into an
    # array of Ruby data structures suitable for further processing.
    #
    # @note
    #   Record definitions work identically to #csv_record
    #
    # @param [String] data the CSV data to be processed
    # @param [Array] definition the record definition for processing
    #   individual fields (see #csv_record)
    # @param [Hash] opts options array compatable with the Ruby
    #   standard library CSV module
    #
    # @return [Array] an array of values representing individual
    #   CSV records
    # 
    # @see #csv_record
    def csv_data(data, definition = nil, opts = {})
      records = []

      CSV.parse(data, opts) do |row|
        records << csv_record(row, definition)
      end

      return records
    end

    # Convert a CSV file into an array of Ruby data structures
    # suitable for further processing.
    #
    # @note
    #   Record definitions work identically to #csv_record
    #
    # @param [String] path path to the CSV file
    # @param [Array] definition the record definition for processing
    #   individual fields (see #csv_record)
    # @param [Hash] opts options array compatable with the Ruby
    #   standard library CSV module
    #
    # @return [Array] an array of values representing individual
    #   CSV records
    # 
    # @see #csv_record
    def csv_file(path, definition = nil, opts = {})
      records = []

      CSV.foreach(path, opts) do |row|
        records << csv_record(row, definition)
      end

      return records
    end

    # Convert a gzipped CSV file into an array of Ruby data structures
    # suitable for further processing.
    #
    # @note
    #   Record definitions work identically to #csv_record
    #
    # @param [String] path path to the gzipped CSV file
    # @param [Array] definition the record definition for processing
    #   individual fields (see #csv_record)
    # @param [Hash] opts options array compatable with the Ruby
    #   standard library CSV module
    #
    # @return [Array] an array of values representing individual
    #   CSV records
    # 
    # @see #csv_record
    def csv_gz_file(path, definition = nil, opts = {})
      records = []

      Zlib::GzipReader.open(path) do |gz|
        gz.each_line do |line|
          records << csv_record(line, definition, opts)
        end
      end

      return records
    end

    # Convert an individual fixed-length field record into a Ruby
    # hash suitable for further processing. Leading and trailing
    # whitespace will be trimmed from all record values.
    #
    # The second parameter is a record definition whice describes
    # individual fields in the record. Only fields defined in the 
    # record definition will be included in the returned hash. A
    # record definition is an array of hashes where each individual
    # hash represents a single field in the record.
    #
    # Each field hash must include at least three values:
    # * *:field* The name of the field
    # * *:start* The starting index of the field
    # * *:end* The end index of the field
    #
    # The *:field* name can be any Ruby data type that Hash supports
    # as a key. The *:start* and *:end* values must be intengers greater
    # than or equal to one (1). Columns in the record are numbered
    # starting at one (1), unlike Ruby arrays. The data for a field
    # will be all the character from the *:start* to the *:end*,
    # inclusive. Any columns in the file not described by fields in
    # the record definition will be ingnored.
    #
    # The fourth (optional) value in the field definition, *:cast*,
    # must be either a symbol or a lambda. When a symbol is given the
    # corresponding method will be called on the data value before
    # being returned. For example, to convert the data to an integer
    # pass *:to_i* as the *:cast* and the *#to_i* method will be called.
    # When the *:cast* is a lambda the block must accept exactly one
    # parameter. The lambda will be called for the field and the
    # string field value will be passed as the block the argument.
    # The use of lambdas this way allows for complex field processing.
    #
    # @example Simple field definition
    #   definition = [
    #     {:field => :place, :start => 1, :end => 6},
    #     {:field => :div, :start =>  16, :end => 21},
    #     {:field => :nettime, :start =>  30, :end => 38},
    #     {:field => :pace, :start =>  39, :end => 44},
    #     {:field => :name, :start =>  45, :end => 67},
    #     {:field => :age, :start =>  68, :end => 70},
    #     {:field => :gender, :start =>  71, :end => 72},
    #     {:field => :race_num, :start =>  73, :end => 78},
    #   ]
    #
    # @example Complex field definition
    #   definition = [
    #     {:field => :place, :start => 1, :end => 6, :cast => lambda {|i| i.to_i} },
    #     {:field => :div_tot, :start =>  7, :end => 15},
    #     {:field => :div, :start =>  16, :end => 21},
    #     {:field => :guntime, :start =>  22, :end => 29},
    #     {:field => :nettime, :start =>  30, :end => 38},
    #     {:field => :pace, :start =>  39, :end => 44},
    #     {:field => :name, :start =>  45, :end => 67},
    #     {:field => :age, :start =>  68, :end => 70, :cast => :to_i},
    #     {:field => :gender, :start =>  71, :end => 72},
    #     {:field => :race_num, :start =>  73, :end => 78, :cast => :to_i},
    #     {:field => :city_state, :start =>  79, :end => 101},
    #   ]
    #
    # @param [String] data the data to be processed
    # @param [Array] definition the record definition for processing
    #   individual fields (see above)
    #
    # @return [Hash] a hash with keys matching the fields in the record definition
    def dat_record(data, definition)
      record = {}

      definition.each do |field|
        name = field[:field]
        record[name] = data.slice(field[:start]-1, field[:end]-field[:start]+1).strip
        if field[:cast].is_a? Symbol
          record[name] = record[name].send(field[:cast])
        elsif field[:cast].is_a? Proc
          record[name] = field[:cast].call(record[name])
        end
      end

      return record
    end

    # Convert a string representing multiple data records into an
    # array of Ruby data structures suitable for further processing.
    #
    # @note
    #   Record definitions work identically to #dat_record
    #
    # @param [String] data the data to be processed
    # @param [Array] definition the record definition for processing
    #   individual fields (see above)
    #
    # @return [Hash] a hash with keys matching the fields in the record definition
    #
    # @see #dat_record
    def dat_data(data, definition)
      records = []

      data.lines do |line|
        records << dat_record(line, definition)
      end

      return records
    end

    # Convert a fixed field width data file representing multiple data
    # records into an array of Ruby data structures suitable for further
    # processing.
    #
    # @note
    #   Record definitions work identically to #dat_record
    #
    # @param [String] path path to the data file
    # @param [Array] definition the record definition for processing
    #   individual fields (see above)
    #
    # @return [Hash] a hash with keys matching the fields in the record definition
    #
    # @see #dat_record
    def dat_file(path, definition)
      records = []

      File.open(path).each do |line|
        records << dat_record(line, definition)
      end

      return records
    end

    # Convert a gzipped fixed field width data file representing multiple
    # data records into an array of Ruby data structures suitable for
    # further processing.
    #
    # @note
    #   Record definitions work identically to #dat_record
    #
    # @param [String] path path to the gzipped data file
    # @param [Array] definition the record definition for processing
    #   individual fields (see above)
    #
    # @return [Hash] a hash with keys matching the fields in the record definition
    #
    # @see #dat_record
    def dat_gz_file(path, definition)
      records = []

      Zlib::GzipReader.open(path) do |gz|
        gz.each_line do |line|
          records << dat_record(line, definition)
        end
      end

      return records
    end

  end
end