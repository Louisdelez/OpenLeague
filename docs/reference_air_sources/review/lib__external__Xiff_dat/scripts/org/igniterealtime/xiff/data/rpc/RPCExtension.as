package org.igniterealtime.xiff.data.rpc
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.Extension;
   import org.igniterealtime.xiff.data.ExtensionClassRegistry;
   import org.igniterealtime.xiff.data.IExtension;
   import org.igniterealtime.xiff.data.ISerializable;
   
   public class RPCExtension extends Extension implements IExtension, ISerializable
   {
      
      public static var NS:String = "jabber:iq:rpc";
      
      public static var ELEMENT:String = "query";
      
      private static var staticDepends:Class = ExtensionClassRegistry;
      
      private var myResult:Array;
      
      private var myFault:Object;
      
      public function RPCExtension()
      {
         super();
      }
      
      public static function enable() : void
      {
         ExtensionClassRegistry.register(RPCExtension);
      }
      
      public function call(param1:String, param2:Array) : void
      {
         XMLRPC.toXML(getNode(),param1,param2);
      }
      
      public function get result() : Array
      {
         return this.myResult;
      }
      
      public function get isFault() : Boolean
      {
         return this.myFault.isFault;
      }
      
      public function get fault() : Object
      {
         return this.myFault;
      }
      
      public function get faultCode() : Number
      {
         return this.myFault.faultCode;
      }
      
      public function get faultString() : String
      {
         return this.myFault.faultString;
      }
      
      public function getNS() : String
      {
         return RPCExtension.NS;
      }
      
      public function getElementName() : String
      {
         return RPCExtension.ELEMENT;
      }
      
      public function serialize(param1:XMLNode) : Boolean
      {
         if(!exists(getNode().parentNode))
         {
            param1.appendChild(getNode().cloneNode(true));
         }
         return true;
      }
      
      public function deserialize(param1:XMLNode) : Boolean
      {
         setNode(param1);
         var _loc2_:Array = XMLRPC.fromXML(param1);
         if(Boolean(_loc2_.isFault))
         {
            this.myFault = _loc2_;
         }
         else
         {
            this.myResult = _loc2_[0];
         }
         return true;
      }
   }
}

