package mx.rpc.wsdl
{
   [ExcludeClass]
   public class WSDLMessage
   {
      
      public var parts:Array;
      
      private var _headerFaultsMap:Object;
      
      private var _partsMap:Object;
      
      public var name:String;
      
      public var encoding:WSDLEncoding;
      
      public var wrappedQName:QName;
      
      public var isWrapped:Boolean;
      
      private var _headersMap:Object;
      
      public function WSDLMessage(name:String = null)
      {
         super();
         this.name = name;
      }
      
      public function getHeader(name:String) : WSDLMessage
      {
         var header:WSDLMessage = null;
         if(_headersMap != null)
         {
            header = _headersMap[name];
         }
         return header;
      }
      
      public function getPart(name:String) : WSDLMessagePart
      {
         var part:WSDLMessagePart = null;
         if(_partsMap != null)
         {
            part = _partsMap[name];
         }
         return part;
      }
      
      public function addHeaderFault(headerFault:WSDLMessage) : void
      {
         if(_headerFaultsMap == null)
         {
            _headerFaultsMap = {};
         }
         _headerFaultsMap[headerFault.name] = headerFault;
      }
      
      public function addPart(part:WSDLMessagePart) : void
      {
         if(_partsMap == null)
         {
            _partsMap = {};
         }
         if(parts == null)
         {
            parts = [];
         }
         _partsMap[part.name.localName] = part;
         parts.push(part);
      }
      
      public function addHeader(header:WSDLMessage) : void
      {
         if(_headersMap == null)
         {
            _headersMap = {};
         }
         _headersMap[header.name] = header;
      }
      
      public function getHeaderFault(name:String) : WSDLMessage
      {
         var headerFault:WSDLMessage = null;
         if(_headerFaultsMap != null)
         {
            headerFault = _headerFaultsMap[name];
         }
         return headerFault;
      }
   }
}

