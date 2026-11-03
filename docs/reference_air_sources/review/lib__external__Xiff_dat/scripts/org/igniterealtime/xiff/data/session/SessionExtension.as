package org.igniterealtime.xiff.data.session
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.Extension;
   import org.igniterealtime.xiff.data.ExtensionClassRegistry;
   import org.igniterealtime.xiff.data.IExtension;
   import org.igniterealtime.xiff.data.ISerializable;
   
   public class SessionExtension extends Extension implements IExtension, ISerializable
   {
      
      public static var NS:String = "urn:ietf:params:xml:ns:xmpp-session";
      
      public static var ELEMENT_NAME:String = "session";
      
      private var jid:String;
      
      public function SessionExtension(param1:XMLNode = null)
      {
         super(param1);
      }
      
      public static function enable() : void
      {
         ExtensionClassRegistry.register(SessionExtension);
      }
      
      public function getNS() : String
      {
         return SessionExtension.NS;
      }
      
      public function getElementName() : String
      {
         return SessionExtension.ELEMENT_NAME;
      }
      
      public function getJID() : String
      {
         return this.jid;
      }
      
      public function serialize(param1:XMLNode) : Boolean
      {
         var _loc2_:XMLNode = null;
         if(!exists(getNode().parentNode))
         {
            _loc2_ = getNode().cloneNode(true);
            param1.appendChild(_loc2_);
         }
         return true;
      }
      
      public function deserialize(param1:XMLNode) : Boolean
      {
         setNode(param1);
         return true;
      }
   }
}

