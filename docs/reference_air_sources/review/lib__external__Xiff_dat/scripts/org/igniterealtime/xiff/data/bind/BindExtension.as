package org.igniterealtime.xiff.data.bind
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.core.EscapedJID;
   import org.igniterealtime.xiff.data.Extension;
   import org.igniterealtime.xiff.data.ExtensionClassRegistry;
   import org.igniterealtime.xiff.data.IExtension;
   import org.igniterealtime.xiff.data.ISerializable;
   import org.igniterealtime.xiff.data.XMLStanza;
   
   public class BindExtension extends Extension implements IExtension, ISerializable
   {
      
      public static var NS:String = "urn:ietf:params:xml:ns:xmpp-bind";
      
      public static var ELEMENT_NAME:String = "bind";
      
      private var _jid:EscapedJID;
      
      private var _resource:String;
      
      public function BindExtension(param1:XMLNode = null)
      {
         super(param1);
      }
      
      public static function enable() : void
      {
         ExtensionClassRegistry.register(BindExtension);
      }
      
      public function getNS() : String
      {
         return BindExtension.NS;
      }
      
      public function getElementName() : String
      {
         return BindExtension.ELEMENT_NAME;
      }
      
      public function get jid() : EscapedJID
      {
         return this._jid;
      }
      
      public function serialize(param1:XMLNode) : Boolean
      {
         var _loc2_:XMLNode = null;
         var _loc3_:XMLNode = null;
         if(!exists(getNode().parentNode))
         {
            _loc2_ = getNode().cloneNode(true);
            _loc3_ = new XMLNode(1,"resource");
            _loc3_.appendChild(XMLStanza.XMLFactory.createTextNode(Boolean(this.resource) ? this.resource : "xiff"));
            _loc2_.appendChild(_loc3_);
            param1.appendChild(_loc2_);
         }
         return true;
      }
      
      public function deserialize(param1:XMLNode) : Boolean
      {
         var _loc3_:String = null;
         setNode(param1);
         var _loc2_:Array = param1.childNodes;
         for(_loc3_ in _loc2_)
         {
            switch(_loc2_[_loc3_].nodeName)
            {
               case "jid":
                  break;
               default:
                  throw "Unknown element: " + _loc2_[_loc3_].nodeName;
            }
            this._jid = new EscapedJID(_loc2_[_loc3_].firstChild.nodeValue);
         }
         return true;
      }
      
      public function set resource(param1:String) : void
      {
         this._resource = param1;
      }
      
      public function get resource() : String
      {
         return this._resource;
      }
   }
}

