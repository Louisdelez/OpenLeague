package com.riotgames.platform.common.xmpp.data.invite
{
   import com.riotgames.platform.gameclient.domain.invite.InviteProperties;
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.XMLStanza;
   
   public class InvitePropertiesXML extends XMLStanza
   {
      
      public static var ELEMENT:String = "entry";
      
      public static var ATTRIBUTE_TYPE:String = "properties";
      
      public static var ENTRY_FIELD_INVITE_ID:String = "inviteId";
      
      public static var ENTRY_FIELD_TEAM_SIZE:String = "teamSize";
      
      public function InvitePropertiesXML(param1:XMLNode = null)
      {
         super();
         if(param1 != null)
         {
            super.setNode(param1);
         }
         else
         {
            super.getNode().nodeName = ELEMENT;
            super.getNode().attributes.type = ATTRIBUTE_TYPE;
         }
      }
      
      public function serialize(param1:XMLNode, param2:InviteProperties) : void
      {
         addTextNode(getNode(),ENTRY_FIELD_INVITE_ID,param2.inviteId);
         addTextNode(getNode(),ENTRY_FIELD_TEAM_SIZE,param2.teamSizeIndex.toString());
         param1.appendChild(getNode());
      }
      
      public function deserialize() : InviteProperties
      {
         var _loc2_:XMLNode = null;
         var _loc1_:InviteProperties = new InviteProperties();
         for each(_loc2_ in getNode().childNodes)
         {
            switch(_loc2_.nodeName)
            {
               case ENTRY_FIELD_INVITE_ID:
                  if(_loc2_.firstChild != null)
                  {
                     _loc1_.inviteId = _loc2_.firstChild.nodeValue;
                  }
                  break;
               case ENTRY_FIELD_TEAM_SIZE:
                  if(_loc2_.firstChild != null)
                  {
                     _loc1_.teamSizeIndex = int(_loc2_.firstChild.nodeValue);
                  }
            }
         }
         return _loc1_;
      }
   }
}

