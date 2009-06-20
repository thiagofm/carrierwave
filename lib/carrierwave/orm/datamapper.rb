require 'dm-core'

module CarrierWave
  module DataMapper

    include CarrierWave::Mount

    ##
    # See +CarrierWave::Mount#mount_uploader+ for documentation
    #
    def mount_uploader(column, uploader, options={}, &block)
      super

      alias_method :read_uploader, :attribute_get
      alias_method :write_uploader, :attribute_set

      after :save do
        send("store_#{column}!")
      end

      before :save do
        send("write_#{column}_identifier")
      end

      after :destroy do
        send("remove_#{column}!")
      end
    end

  end # DataMapper
end # CarrierWave

DataMapper::Model.send(:include, CarrierWave::DataMapper)
