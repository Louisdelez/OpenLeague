package org.igniterealtime.xiff.data.privatedata
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.ExtensionClassRegistry;
   import org.igniterealtime.xiff.data.IExtension;
   import org.igniterealtime.xiff.data.ISerializable;
   import org.igniterealtime.xiff.privatedata.IPrivatePayload;
   
   public class PrivateDataExtension implements IExtension, ISerializable
   {
      
      private var _extension:XMLNode;
      
      private var _payload:IPrivatePayload;
      
      public function PrivateDataExtension(param1:String = null, param2:String = null, param3:IPrivatePayload = null)
      {
         super();
         this._extension = new XMLNode(1,param1);
         this._extension.attributes["xmlns"] = param2;
         this._payload = param3;
      }
      
      public function getNS() : String
      {
         return "jabber:iq:private";
      }
      
      public function getElementName() : String
      {
         return "query";
      }
      
      public function get privateName() : String
      {
         return this._extension.nodeName;
      }
      
      public function get privateNamespace() : String
      {
         return this._extension.attributes["xmlns"];
      }
      
      public function get payload() : IPrivatePayload
      {
         return this._payload;
      }
      
      public function serialize(param1:XMLNode) : Boolean
      {
         var _loc2_:XMLNode = this._extension.cloneNode(true);
         var _loc3_:XMLNode = new XMLNode(1,"query");
         _loc3_.attributes.xmlns = "jabber:iq:private";
         _loc3_.appendChild(_loc2_);
         param1.appendChild(_loc3_);
         return this._serializePayload(_loc2_);
      }
      
      private function _serializePayload(param1:XMLNode) : Boolean
      {
         if(this._payload == null)
         {
            return true;
         }
         return this._payload.serialize(param1);
      }
      
      public function deserialize(param1:XMLNode) : Boolean
      {
         var _loc2_:XMLNode = param1.firstChild;
         if(!_loc2_)
         {
            return false;
         }
         var _loc3_:String = _loc2_.attributes["xmlns"];
         if(_loc3_ == null)
         {
            return false;
         }
         this._extension = new XMLNode(1,_loc2_.nodeName);
         this._extension.attributes["xmlns"] = _loc3_;
         var _loc4_:Class = ExtensionClassRegistry.lookup(_loc3_);
         if(_loc4_ == null)
         {
            return false;
         }
         var _loc5_:IPrivatePayload = new _loc4_();
         if(_loc5_ != null && _loc5_ is IPrivatePayload)
         {
            _loc5_.deserialize(_loc2_);
            this._payload = _loc5_;
            return true;
         }
         return false;
      }
   }
}

