package com.riotgames.platform.common.xmpp.data.privacy
{
   import com.riotgames.platform.common.xmpp.privacy.*;
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.Extension;
   import org.igniterealtime.xiff.data.ExtensionClassRegistry;
   import org.igniterealtime.xiff.data.IExtension;
   import org.igniterealtime.xiff.data.ISerializable;
   
   public class PrivacyExtension extends Extension implements ISerializable, IExtension
   {
      
      public static const NS:String = "jabber:iq:privacy";
      
      public static const ELEMENT:String = "query";
      
      public var privacyListMap:Object = {};
      
      public function PrivacyExtension(param1:XMLNode = null)
      {
         super(param1);
      }
      
      public static function enable() : void
      {
         ExtensionClassRegistry.register(PrivacyExtension);
      }
      
      public function serialize(param1:XMLNode) : Boolean
      {
         var _loc2_:XMLNode = this.getNode();
         if(param1 != _loc2_.parentNode)
         {
            param1.appendChild(_loc2_.cloneNode(true));
         }
         return true;
      }
      
      public function getNS() : String
      {
         return PrivacyExtension.NS;
      }
      
      public function getElementName() : String
      {
         return PrivacyExtension.ELEMENT;
      }
      
      public function deserialize(param1:XMLNode) : Boolean
      {
         var _loc2_:XMLNode = null;
         var _loc3_:PrivacyListNode = null;
         var _loc4_:String = null;
         var _loc5_:PrivacyList = null;
         this.setNode(param1);
         for each(_loc2_ in param1.childNodes)
         {
            _loc3_ = new PrivacyListNode();
            _loc3_.deserialize(_loc2_);
            _loc4_ = _loc2_.attributes.name;
            if(this.privacyListMap[_loc4_] == null)
            {
               this.privacyListMap[_loc4_] = new PrivacyList(_loc4_);
            }
            _loc5_ = this.privacyListMap[_loc4_];
            switch(_loc2_.nodeName)
            {
               case PrivacyListNode.ACTIVE:
                  _loc5_.isActive = true;
                  break;
               case PrivacyListNode.DEFAULT:
                  _loc5_.isDefault = true;
                  break;
               case PrivacyListNode.LIST:
                  _loc5_.items = _loc3_.privacyItems;
            }
         }
         return true;
      }
   }
}

