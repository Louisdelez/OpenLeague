package com.riotgames.platform.common.xmpp.privacy
{
   import com.riotgames.platform.common.xmpp.data.privacy.PrivacyListItem;
   import flash.xml.XMLNode;
   import mx.collections.ArrayCollection;
   import org.igniterealtime.xiff.data.ISerializable;
   import org.igniterealtime.xiff.data.XMLStanza;
   
   public class PrivacyListNode extends XMLStanza implements ISerializable
   {
      
      public static const ACTIVE:String = "active";
      
      public static const DEFAULT:String = "default";
      
      public static const LIST:String = "list";
      
      public static const ADD:String = "add";
      
      public static const REMOVE:String = "remove";
      
      public var privacyListName:String;
      
      public var privacyItems:ArrayCollection;
      
      public function PrivacyListNode(param1:String = "", param2:String = "list", param3:ArrayCollection = null, param4:XMLNode = null)
      {
         super();
         if(param4 != null)
         {
            this.setNode(param4);
         }
         this.privacyItems = param3 == null ? new ArrayCollection() : param3;
         this.getNode().attributes.name = param1;
         this.getNode().nodeName = param2;
      }
      
      public function serialize(param1:XMLNode) : Boolean
      {
         var _loc2_:PrivacyListItem = null;
         var _loc3_:PrivacyListItemNode = null;
         param1.appendChild(this.getNode());
         for each(_loc2_ in this.privacyItems)
         {
            _loc3_ = new PrivacyListItemNode(_loc2_);
            _loc3_.serialize(this.getNode());
         }
         return true;
      }
      
      public function deserialize(param1:XMLNode) : Boolean
      {
         var _loc2_:XMLNode = null;
         var _loc3_:PrivacyListItemNode = null;
         this.setNode(param1);
         this.privacyListName = param1.attributes.name;
         this.privacyItems.removeAll();
         for each(_loc2_ in param1.childNodes)
         {
            if(_loc2_.nodeName == PrivacyListItemNode.ITEM)
            {
               _loc3_ = new PrivacyListItemNode();
               _loc3_.deserialize(_loc2_);
               this.privacyItems.addItem(_loc3_.privacyListItem);
            }
         }
         return true;
      }
   }
}

