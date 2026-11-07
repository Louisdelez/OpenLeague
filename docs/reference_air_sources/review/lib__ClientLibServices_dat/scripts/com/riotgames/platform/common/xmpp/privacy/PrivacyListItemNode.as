package com.riotgames.platform.common.xmpp.privacy
{
   import com.riotgames.platform.common.xmpp.data.privacy.PrivacyListItem;
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.ISerializable;
   import org.igniterealtime.xiff.data.XMLStanza;
   
   public class PrivacyListItemNode extends XMLStanza implements ISerializable
   {
      
      public static const ITEM:String = "item";
      
      public static const VALUE:String = "value";
      
      public static const TYPE:String = "type";
      
      public static const ACTION:String = "action";
      
      public static const ORDER:String = "order";
      
      public var privacyListItem:PrivacyListItem;
      
      public function PrivacyListItemNode(param1:PrivacyListItem = null, param2:XMLNode = null)
      {
         super();
         this.privacyListItem = param1;
         if(param2 != null)
         {
            this.setNode(param2);
         }
         else if(param1 != null)
         {
            this.getNode().nodeName = PrivacyListItemNode.ITEM;
            this.getNode().attributes[PrivacyListItemNode.VALUE] = param1.value;
            this.getNode().attributes[PrivacyListItemNode.TYPE] = param1.type;
            this.getNode().attributes[PrivacyListItemNode.ACTION] = param1.action;
            this.getNode().attributes[PrivacyListItemNode.ORDER] = param1.order;
         }
      }
      
      public function serialize(param1:XMLNode) : Boolean
      {
         param1.appendChild(this.getNode());
         return true;
      }
      
      public function deserialize(param1:XMLNode) : Boolean
      {
         this.privacyListItem = new PrivacyListItem();
         this.privacyListItem.value = param1.attributes[PrivacyListItemNode.VALUE] as String;
         this.privacyListItem.type = param1.attributes[PrivacyListItemNode.TYPE] as String;
         this.privacyListItem.action = param1.attributes[PrivacyListItemNode.ACTION] as String;
         this.privacyListItem.order = parseInt(param1.attributes[PrivacyListItemNode.ORDER] as String);
         return true;
      }
   }
}

