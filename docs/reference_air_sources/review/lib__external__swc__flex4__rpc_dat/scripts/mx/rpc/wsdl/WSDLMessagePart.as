package mx.rpc.wsdl
{
   [ExcludeClass]
   public class WSDLMessagePart
   {
      
      public var type:QName;
      
      public var element:QName;
      
      public var definition:XML;
      
      public var optional:Boolean;
      
      private var _name:QName;
      
      public function WSDLMessagePart(name:QName, element:QName = null, type:QName = null)
      {
         super();
         this._name = name;
         this.type = type;
         this.element = element;
      }
      
      public function get name() : QName
      {
         return this._name;
      }
   }
}

