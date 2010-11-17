module MassiveRecord

  class Connection
  
    attr_accessor :host, :port, :timeout
    
    def initialize(opts = {})
      @timeout = 4000
      
      %w{host port}.each do |name|
        send("#{name}=", opts[name.to_sym])
      end
    end
        
    def transport
      @transport ||= Thrift::BufferedTransport.new(Thrift::Socket.new(@host, @port, @timeout))
    end
    
    def protocol
      Thrift::BinaryProtocol.new(transport)
    end
    
    def client
      @client ||= Apache::Hadoop::Hbase::Thrift::Hbase::Client.new(protocol)
    end
    
    def open
      transport.open()
    end
    
    def tables
      client.getTableNames()
    end
    
  end

end