package mx.rpc.wsdl
{
   [ExcludeClass]
   public class WSDLMessage
   {
      
      public var encoding:WSDLEncoding;
      
      public var isWrapped:Boolean;
      
      public var name:String;
      
      public var parts:Array;
      
      public var wrappedQName:QName;
      
      private var _partsMap:Object;
      
      private var _headersMap:Object;
      
      private var _headerFaultsMap:Object;
      
      public function WSDLMessage(name:String = null)
      {
         super();
         this.name = name;
      }
      
      public function addPart(part:WSDLMessagePart) : void
      {
         if(this._partsMap == null)
         {
            this._partsMap = {};
         }
         if(this.parts == null)
         {
            this.parts = [];
         }
         this._partsMap[part.name.localName] = part;
         this.parts.push(part);
      }
      
      public function getPart(name:String) : WSDLMessagePart
      {
         var part:WSDLMessagePart = null;
         if(this._partsMap != null)
         {
            part = this._partsMap[name];
         }
         return part;
      }
      
      public function addHeader(header:WSDLMessage) : void
      {
         if(this._headersMap == null)
         {
            this._headersMap = {};
         }
         this._headersMap[header.name] = header;
      }
      
      public function getHeader(name:String) : WSDLMessage
      {
         var header:WSDLMessage = null;
         if(this._headersMap != null)
         {
            header = this._headersMap[name];
         }
         return header;
      }
      
      public function addHeaderFault(headerFault:WSDLMessage) : void
      {
         if(this._headerFaultsMap == null)
         {
            this._headerFaultsMap = {};
         }
         this._headerFaultsMap[headerFault.name] = headerFault;
      }
      
      public function getHeaderFault(name:String) : WSDLMessage
      {
         var headerFault:WSDLMessage = null;
         if(this._headerFaultsMap != null)
         {
            headerFault = this._headerFaultsMap[name];
         }
         return headerFault;
      }
   }
}

