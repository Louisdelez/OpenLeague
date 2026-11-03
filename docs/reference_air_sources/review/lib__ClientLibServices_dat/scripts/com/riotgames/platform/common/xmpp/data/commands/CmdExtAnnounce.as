package com.riotgames.platform.common.xmpp.data.commands
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.ExtensionClassRegistry;
   import org.igniterealtime.xiff.data.IExtension;
   import org.igniterealtime.xiff.data.XMLStanza;
   
   public class CmdExtAnnounce extends CmdExtension implements IExtension
   {
      
      public static var ELEMENT:String = "x";
      
      public function CmdExtAnnounce(param1:XMLNode = null)
      {
         super(param1);
      }
      
      public static function enable() : void
      {
         ExtensionClassRegistry.register(CmdExtAnnounce);
      }
      
      public function addFormField(param1:String, param2:String, param3:String) : void
      {
         if(getNode().firstChild == null)
         {
            this.createExtNode();
         }
         var _loc4_:XMLNode = XMLStanza.XMLFactory.createElement("field");
         _loc4_.attributes.type = param1;
         _loc4_.attributes["var"] = param2;
         super.addTextNode(_loc4_,"value",param3);
         getNode().firstChild.appendChild(_loc4_);
      }
      
      private function createExtNode() : void
      {
         super.getNode().appendChild(XMLStanza.XMLFactory.createElement(ELEMENT));
         super.getNode().attributes.xmlns = "http://jabber.org/protocol/commands";
         super.getNode().attributes.node = "http://jabber.org/protocol/admin#announce";
         super.getNode().firstChild.attributes.xmlns = "jabber:x:data";
         super.getNode().firstChild.attributes.type = "submit";
      }
      
      public function getElementName() : String
      {
         return CmdExtension.ELEMENT;
      }
      
      public function getNS() : String
      {
         return CmdExtension.NS;
      }
   }
}

